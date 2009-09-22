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
using SubSonic.Extensions;
using SubSonic.Query;
using SubSonic.Schema;
using SubSonic.SqlGeneration.Schema;

namespace SubSonic.DataProviders
{
    public class DbClientTypeName
    {
        public const string MsSql = "System.Data.SqlClient";
        public const string MsSqlCe = "System.Data.SqlServerCe.3.5";
        public const string MySql = "MySql.Data.MySqlClient";
        //public const string OleDb = "System.Data.OleDb";
        public const string Oracle = "System.Data.OracleClient";
        public const string SqlLite = "System.Data.SQLite";
    }

    public class DbDataProvider : IDataProvider
    {
        [ThreadStatic]
        private static DbConnection __sharedConnection;

        internal DbDataProvider(string connectionString, string providerName)
        {
            ConnectionString = connectionString;
            DbDataProviderName = String.IsNullOrEmpty(providerName) ? DbClientTypeName.MsSql : providerName;
            Schema = new DatabaseSchema();
            DecideClient(DbDataProviderName);

            Factory = DbProviderFactories.GetFactory(DbDataProviderName);
        }

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

        public ISchemaGenerator SchemaGenerator
        {
            get
            {
                switch(Client)
                {
                    case DataClient.SqlClient:
                        return new Sql2005Schema();
                    case DataClient.MySqlClient:
                        return new MySqlSchema();
                    case DataClient.SQLite:
                        return new SQLiteSchema();
                    default:
                        throw new ArgumentOutOfRangeException(Client.ToString(), "There is no generator for this client");
                }
            }
        }

        public TextWriter Log { get; set; }

        public string ConnectionString { get; private set; }

        public DataClient Client { get; set; }
        public IDatabaseSchema Schema { get; set; }

        public string DbDataProviderName { get; private set; }

        public DbProviderFactory Factory { get; private set; }

        public DbDataReader ExecuteReader(QueryCommand qry)
        {
            AutomaticConnectionScope scope = new AutomaticConnectionScope(this);

            if(Log != null)
                Log.WriteLine(qry.CommandSql);

#if DEBUG
            //Console.Error.WriteLine("ExecuteReader(QueryCommand):\r\n{0}", qry.CommandSql);
#endif
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
            if(Log != null)
                Log.WriteLine(qry.CommandSql);
#if DEBUG
            //Console.Error.WriteLine("ExecuteDataSet(QueryCommand): {0}.", qry.CommandSql);
#endif
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
            if(Log != null)
                Log.WriteLine(qry.CommandSql);

#if DEBUG
            //Console.Error.WriteLine("ExecuteScalar(QueryCommand): {0}.", qry.CommandSql);
            //foreach (var param in qry.Parameters) {
            //    if(param.ParameterValue==null)
            //        Console.Error.WriteLine(param.ParameterName + " = NULL");
            //    else
            //        Console.Error.WriteLine(param.ParameterName + " = " + param.ParameterValue.ToString());
            //}
#endif

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
            if(Log != null)
                Log.WriteLine(qry.CommandSql);

#if DEBUG
            //Console.Error.WriteLine("ExecuteSingle<T>(QueryCommand): {0}.", qry.CommandSql);
#endif
            T result = default(T);
            using(IDataReader rdr = ExecuteReader(qry))
            {
                List<T> items = rdr.ToList<T>();

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
            if(Log != null)
                Log.WriteLine(qry.CommandSql);

#if DEBUG
            //Console.Error.WriteLine("ExecuteQuery(QueryCommand): {0}.", qry.CommandSql);
#endif
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
                result = rdr.ToList<T>();

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

        public string QualifyTableName(ITable tbl)
        {
            string qualifiedTable;

            switch(Client)
            {
                case DataClient.MySqlClient:
                case DataClient.SQLite:
                    qualifiedTable = String.Format("`{0}`", tbl.Name);
                    break;
                default:
                    string qualifiedFormat = String.IsNullOrEmpty(tbl.SchemaName) ? "[{1}]" : "[{0}].[{1}]";
                    qualifiedTable = String.Format(qualifiedFormat, tbl.SchemaName, tbl.Name);
                    break;
            }

            return qualifiedTable;
        }

        public string QualifyColumnName(IColumn column)
        {
            string qualifiedFormat;

            switch(Client)
            {
                case DataClient.SQLite:
                    qualifiedFormat = "`{2}`";
                    break;
                case DataClient.MySqlClient:
                    qualifiedFormat = String.IsNullOrEmpty(column.SchemaName) ? "`{2}`" : "`{0}`.`{1}`.`{2}`";
                    break;
                default:
                    qualifiedFormat = String.IsNullOrEmpty(column.SchemaName) ? "[{1}].[{2}]" : "[{0}].[{1}].[{2}]";
                    break;
            }

            return String.Format(qualifiedFormat, column.Table.SchemaName, column.Table.Name, column.Name);
        }

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


        private void DecideClient(string dbProviderTypeName)
        {
            if(dbProviderTypeName.Matches(DbClientTypeName.MsSql))
                Client = DataClient.SqlClient;
            else if (dbProviderTypeName.Matches(DbClientTypeName.MySql))
                Client = DataClient.MySqlClient;
            else if (dbProviderTypeName.Matches(DbClientTypeName.Oracle))
                Client = DataClient.OracleClient;
            else if (dbProviderTypeName.Matches(DbClientTypeName.SqlLite))
                Client = DataClient.SQLite;
            else
                Client = DataClient.SqlClient;
        }

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
    }
}