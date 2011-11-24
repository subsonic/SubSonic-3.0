// 
//   SubSonic - http://subsonicproject.com
// 
//   The contents of this file are subject to the New BSD
//   License (the "License"); you may not use this file
//   except in compliance with the License. You may obtain a copy of
//   the License at http://www.opensource.org/licenses/bsd-license.php
//  
//   Software distributed under the License is distributed on an 
//   "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
//   implied. See the License for the specific language governing
//   rights and limitations under the License.
// 
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.IO;
using System.Linq;
using System.Reflection;
using SubSonic.DataProviders.Log;
using SubSonic.Extensions;
using SubSonic.Query;
using SubSonic.Schema;
using SubSonic.SqlGeneration.Schema;
using SubSonic.DataProviders;
using SubSonic.SqlGeneration;
using SubSonic.Linq.Structure;


namespace SubSonic.DataProviders
{
    public abstract class DbDataProvider : IDataProvider
    {
        [ThreadStatic]
        private static DbConnection __sharedConnection;

        private ILogAdapter _logger;

        public IInterceptionStrategy InterceptionStrategy { get; set; }

        protected DbDataProvider(string connectionString, string providerName)
        {
            if (String.IsNullOrEmpty(connectionString))
            {
                throw new ArgumentNullException("connectionString");
            }

            ConnectionString = connectionString;

            if (String.IsNullOrEmpty(providerName))
            {
                throw new ArgumentNullException("providerName");
            }

            DbDataProviderName = providerName;

            // TODO: Schema is specific to SQL Server?
            Schema = new DatabaseSchema();

			InterceptionStrategy = new DynamicProxyInterceptionStrategy(this);
        }

        public string ConnectionString { get; private set; }
        public string DbDataProviderName { get; private set; }

        /// <summary>
        /// Gets a value indicating whether [current connection string is default].
        /// </summary>
        /// <value>
        /// 	<c>true</c> if [current connection string is default]; otherwise, <c>false</c>.
        /// </value>
        public bool CurrentConnectionStringIsDefault
        {
            get
            {
                if(CurrentSharedConnection != null)
                {
                    if(CurrentSharedConnection.ConnectionString != ConnectionString)
                        return false;
                }
                return true;
            }
        }


        #region IDataProvider Members

        public abstract ISchemaGenerator SchemaGenerator { get; }
        
        public virtual ISqlFragment SqlFragment
        {
            get { return new SqlFragment(); }
        }

        public abstract IQueryLanguage QueryLanguage { get; }

        
        public virtual ISqlGenerator GetSqlGenerator(SqlQuery query)
        {
            return new ANSISqlGenerator(query);
        }

        public TextWriter Log
        {
            get
            {
                if (_logger == null)
                {
                    return null;
                }

                if (!(_logger is TextWriterLogAdapter))
                {
                    throw new InvalidOperationException("Logger that is currently used is not based on TextWriter");
                }

                return ((TextWriterLogAdapter) _logger).Writer;
            }
            set { _logger = new TextWriterLogAdapter(value); }
        }

        public void SetLogger(ILogAdapter logger)
        {
            _logger = logger;
        }

        public void SetLogger(Action<String> logger)
        {
            _logger = new DelegatingLogAdapter(logger);
        }

        public IDatabaseSchema Schema { get; private set; }

        public DbProviderFactory Factory 
        {
            get  { return DbProviderFactories.GetFactory(DbDataProviderName); }
        }

        public DbDataReader ExecuteReader(QueryCommand qry)
        {
            AutomaticConnectionScope scope = new AutomaticConnectionScope(this);

						WriteToLog(() => string.Format("ExecuteReader(QueryCommand):\r\n{0}", qry.CommandSql));

            DbCommand cmd = scope.Connection.CreateCommand();
            cmd.Connection = scope.Connection; //CreateConnection();

            cmd.CommandText = qry.CommandSql;
            cmd.CommandType = qry.CommandType;

            AddParams(cmd, qry);

            //this may look completely lame
            //but there is a bug in here...

            DbDataReader rdr;
            //Thanks jcoenen!
            try
            {
                // if it is a shared connection, we shouldn't be telling the reader to close it when it is done
                rdr = scope.IsUsingSharedConnection ? cmd.ExecuteReader() : cmd.ExecuteReader(CommandBehavior.CloseConnection);
            }
            catch(Exception)
            {
                // AutoConnectionScope will figure out what to do with the connection
                scope.Dispose();
                //rethrow retaining stack trace.
                throw;
            }

            return rdr;
        }

        public DataSet ExecuteDataSet(QueryCommand qry)
        {
						WriteToLog(() => string.Format("ExecuteDataSet(QueryCommand): {0}.", qry.CommandSql));

            DbCommand cmd = Factory.CreateCommand();
            cmd.CommandText = qry.CommandSql;
            cmd.CommandType = qry.CommandType;
            DataSet ds = new DataSet();

            using(AutomaticConnectionScope scope = new AutomaticConnectionScope(this))
            {
                cmd.Connection = scope.Connection;
                AddParams(cmd, qry);
                DbDataAdapter da = Factory.CreateDataAdapter();
                da.SelectCommand = cmd;
                da.Fill(ds);

                return ds;
            }
        }

        public object ExecuteScalar(QueryCommand qry)
        {
            WriteToLog(() => string.Format("ExecuteScalar(QueryCommand): {0}.", qry.CommandSql));

            object result;
            using(AutomaticConnectionScope automaticConnectionScope = new AutomaticConnectionScope(this))
            {
                DbCommand cmd = Factory.CreateCommand();
                cmd.Connection = automaticConnectionScope.Connection;
                cmd.CommandType = qry.CommandType;
                cmd.CommandText = qry.CommandSql;
                AddParams(cmd, qry);
                result = cmd.ExecuteScalar();
            }

            return result;
        }

        public T ExecuteSingle<T>(QueryCommand qry) where T : new()
        {
						WriteToLog(() => string.Format("ExecuteSingle<T>(QueryCommand): {0}.", qry.CommandSql));

						T result = default(T);
            using(IDataReader rdr = ExecuteReader(qry))
            {
                List<T> items = rdr.ToList<T>(GetInterceptor(typeof(T)));

                if(items.Count > 0)
                    result = items[0];
            }
            return result;
        }

        public DbCommand CreateCommand()
        {
            return Factory.CreateCommand();
        }

        public int ExecuteQuery(QueryCommand qry)
        {
						WriteToLog(() => string.Format("ExecuteQuery(QueryCommand): {0}.", qry.CommandSql));

            int result;
            using(AutomaticConnectionScope automaticConnectionScope = new AutomaticConnectionScope(this))
            {
                DbCommand cmd = automaticConnectionScope.Connection.CreateCommand();
                cmd.CommandText = qry.CommandSql;
                cmd.CommandType = qry.CommandType;
                AddParams(cmd, qry);
                result = cmd.ExecuteNonQuery();
                // Issue 11 fix introduced by feroalien@hotmail.com
                qry.GetOutputParameters(cmd);
            }

            return result;
        }

        public IList<T> ToList<T>(QueryCommand qry) where T : new()
        {
            List<T> result;
            using(var rdr = ExecuteReader(qry))
                result = rdr.ToList<T>(GetInterceptor(typeof(T)));

            return result;
        }

        public string ParameterPrefix
        {
            get { return "@"; }
        }

        public string Name
        {
            get { return DbDataProviderName; }
        }

        /// <summary>
        /// Gets or sets the current shared connection.
        /// </summary>
        /// <value>The current shared connection.</value>
        public DbConnection CurrentSharedConnection
        {
            get { return __sharedConnection; }

            protected set
            {
                if(value == null)
                {
                    __sharedConnection.Dispose();
                    __sharedConnection = null;
                }
                else
                {
                    __sharedConnection = value;
                    __sharedConnection.Disposed += __sharedConnection_Disposed;
                }
            }
        }

        /// <summary>
        /// Initializes the shared connection.
        /// </summary>
        /// <returns></returns>
        public DbConnection InitializeSharedConnection()
        {
            if(CurrentSharedConnection == null)
                CurrentSharedConnection = CreateConnection();

            return CurrentSharedConnection;
        }

        /// <summary>
        /// Initializes the shared connection.
        /// </summary>
        /// <param name="sharedConnectionString">The shared connection string.</param>
        /// <returns></returns>
        public DbConnection InitializeSharedConnection(string sharedConnectionString)
        {
            if(CurrentSharedConnection == null)
                CurrentSharedConnection = CreateConnection(sharedConnectionString);

            return CurrentSharedConnection;
        }

        /// <summary>
        /// Resets the shared connection.
        /// </summary>
        public void ResetSharedConnection()
        {
            CurrentSharedConnection = null;
        }

        public DbConnection CreateConnection()
        {
            return CreateConnection(ConnectionString);
        }

        public ITable FindTable(string tableName)
        {
            //TODO: Remove this check
            //if (Schema.Tables.Count == 0) {
            //    throw new InvalidOperationException("The schema hasn't been loaded by this provider. This is usually done by the constructor of the 'QuerySurface' or 'DataContext' provided by " +
            //        "the template you're using. Make sure to use it, and not the query directly");
            //}

            //var result = Schema.Tables.FirstOrDefault(x => x.Name.ToLower() == tableName.ToLower());
            var result = Schema.Tables.FirstOrDefault(x => x.Name.Equals(tableName, StringComparison.InvariantCultureIgnoreCase)) ??
                         Schema.Tables.FirstOrDefault(x => x.ClassName.Equals(tableName, StringComparison.InvariantCultureIgnoreCase));

            return result;
        }

        public ITable FindOrCreateTable(Type type)
        {
            ITable result = null;
            if(Schema.Tables.Count > 0)
                result = FindTable(type.Name);
            if(result == null)
            {
                result = type.ToSchemaTable(this);
                Schema.Tables.Add(result);
            }

            return result;
        }

        public ITable FindOrCreateTable<T>() where T : new()
        {
            //ITable result = null;
            return FindOrCreateTable(typeof(T));
        }

        public abstract string InsertionIdentityFetchString { get; }

        public abstract string QualifyTableName(ITable tbl);
        public abstract string QualifyColumnName(IColumn column);
       
        // TODO: Make that abstract too? Or at least virtual
        public string QualifySPName(IStoredProcedure sp)
        {
            const string qualifiedFormat = "[{0}].[{1}]";
            return String.Format(qualifiedFormat, sp.SchemaName, sp.Name);
        }

        public ITable GetTableFromDB(string tableName)
        {
            return SchemaGenerator.GetTableFromDB(this, tableName);
        }

        public void MigrateToDatabase<T>(Assembly assembly)
        {
            var m = new Migrator(assembly);
            
            var migrationSql = m.MigrateFromModel<T>(this);
            BatchQuery query = new BatchQuery(this);
            foreach(var s in migrationSql)
                query.QueueForTransaction(new QueryCommand(s.Trim(), this));

            //pop the transaction
            query.ExecuteTransaction();
        }

        public void MigrateNamespaceToDatabase(string modelNamespace, Assembly assembly)
        {
            var m = new Migrator(assembly);

            var migrationSql = m.MigrateFromModel(modelNamespace, this);
            BatchQuery query = new BatchQuery(this);
            foreach(var s in migrationSql)
                query.QueueForTransaction(new QueryCommand(s.Trim(), this));

            //pop the transaction
            query.ExecuteTransaction();
        }

        #endregion


        /// <summary>
        /// Adds the params.
        /// </summary>
        /// <param name="cmd">The CMD.</param>
        /// <param name="qry">The qry.</param>
        private static void AddParams(DbCommand cmd, QueryCommand qry)
        {
            if(qry.Parameters != null)
            {
                foreach(QueryParameter param in qry.Parameters)
                {
                    DbParameter p = cmd.CreateParameter();
                    p.ParameterName = param.ParameterName;
                    p.Direction = param.Mode;
                    p.DbType = param.DataType;

                    //output parameters need to define a size
                    //our default is 50
                    if(p.Direction == ParameterDirection.Output || p.Direction == ParameterDirection.InputOutput)
                        p.Size = param.Size;

                    //fix for NULLs as parameter values
                    if(param.ParameterValue == null)
                    {
                        p.Value = DBNull.Value;
                    }
                    else if(param.DataType == DbType.Guid)
                    {
                        string paramValue = param.ParameterValue.ToString();
                        if (!String.IsNullOrEmpty(paramValue))
                        {
                            if(!paramValue.Equals("DEFAULT", StringComparison.InvariantCultureIgnoreCase))
                                p.Value = new Guid(paramValue);
                        }
                        else
                            p.Value = DBNull.Value;
                    }
                    else
                        p.Value = param.ParameterValue;

                    cmd.Parameters.Add(p);
                }
            }
        }

        private static void __sharedConnection_Disposed(object sender, EventArgs e)
        {
            __sharedConnection = null;
        }

        public DbConnection CreateConnection(string connectionString)
        {
            DbConnection conn = Factory.CreateConnection();
            conn.ConnectionString = connectionString;
            if(conn.State == ConnectionState.Closed)
                conn.Open();
            return conn;
        }

		public virtual IEnumerable<T> ToEnumerable<T>(QueryCommand<T> query, object[] paramValues)
        {
            QueryCommand cmd = new QueryCommand(query.CommandText, this);
            for (int i = 0; i < paramValues.Length; i++)
            {
                
                //need to assign a DbType
                var valueType = paramValues[i].GetType();
                var dbType = Database.GetDbType(valueType);
                
                
                cmd.AddParameter(query.ParameterNames[i], paramValues[i],dbType);
            }

						// TODO: Can we use Database.ToEnumerable here? -> See commit 654aa2f48a67ba537e34 that fixes some issues
						Type type = typeof(T);
						//this is so hacky - the issue is that the Projector below uses Expression.Convert, which is a bottleneck
						//it's about 10x slower than our ToEnumerable. Our ToEnumerable, however, stumbles on Anon types and groupings
						//since it doesn't know how to instantiate them (I tried - not smart enough). So we do some trickery here.
						if (type.Name.Contains("AnonymousType") || type.Name.StartsWith("Grouping`") || type.FullName.StartsWith("System."))
						{
							var reader = ExecuteReader(cmd);
							return Project(reader, query.Projector);
						}
						else
						{
						  using (var reader = ExecuteReader(cmd))
						  {

						    return reader.ToEnumerable<T>(query.ColumnNames, GetInterceptor(type));
						  }
						}
        }

        private Func<object, object> GetInterceptor(Type t)
        {
            if (InterceptionStrategy.Accept(t))
            {
                return InterceptionStrategy.Intercept;
            }

            return null;
        }

				/// <summary>
				/// Converts a data reader into a sequence of objects using a projector function on each row
				/// </summary>
				/// <typeparam name="T"></typeparam>
				/// <param name="reader">The reader.</param>
				/// <param name="fnProjector">The fn projector.</param>
				/// <returns></returns>
				public virtual IEnumerable<T> Project<T>(DbDataReader reader, Func<DbDataReader, T> fnProjector)
				{
					try
					{
						var readValues = new List<T>();

						while (reader.Read())
						{
							readValues.Add(fnProjector(reader));
						}
						return readValues;
					}
					finally
					{
						reader.Dispose();
					}
				}

        private void WriteToLog(Func<string> logMessage)
        {
            if (_logger != null)
            {
                _logger.Log(logMessage());
            }
        }
    }
}