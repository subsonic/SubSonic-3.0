// Copyright (c) Microsoft Corporation.  All rights reserved.
// This source code is made available under the terms of the Microsoft Public License (MS-PL)
//Original code created by Matt Warren: http://iqtoolkit.codeplex.com/Release/ProjectReleases.aspx?ReleaseId=19725

using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Linq.Expressions;
using System.IO;
using SubSonic.DataProviders;
using SubSonic.Extensions;
using SubSonic.Linq.Translation;
using SubSonic.Linq.Translation.MySql;
using SubSonic.Linq.Translation.SQLite;
using SubSonic.Query;

namespace SubSonic.Linq.Structure
{
    /// <summary>
    /// A LINQ IQueryable query provider that executes database queries over a DbConnection
    /// </summary>
    public class DbQueryProvider : QueryProvider
    {
        private readonly IDataProvider _provider;
        private readonly DbConnection connection;
        private readonly QueryLanguage language;
        private readonly QueryMapping mapping;
        private readonly QueryPolicy policy;

        /// <summary>
        /// DbQueryProvider constrcutor that allows for external control of policy
        /// to allow for new types of databases.
        /// </summary>
        public DbQueryProvider(IDataProvider provider, QueryPolicy paramPolicy, TextWriter log)
        {
            _provider = provider;
            connection = _provider.CreateConnection();
            policy = paramPolicy;
            mapping = policy.Mapping;
            language = mapping.Language;
            //log = log;
        }
        
        public DbQueryProvider(IDataProvider provider)
        {
            _provider = provider;

            QueryLanguage lang;
            switch (_provider.Client)
            {
                case DataClient.MySqlClient:
                    lang = new MySqlLanguage(_provider);
                    break;
                case  DataClient.SQLite:
                    lang = new SqliteLanguage(_provider);
                    break;
                default:
                    lang = new TSqlLanguage(_provider);
                    break;
            }

            //connection = _provider.CreateConnection();
            policy = new QueryPolicy(new ImplicitMapping(lang));

            mapping = policy.Mapping;
            language = mapping.Language;
        }

        public DbConnection Connection
        {
            get { return connection; }
        }


        public QueryPolicy Policy
        {
            get { return policy; }
        }

        public QueryMapping Mapping
        {
            get { return mapping; }
        }

        public QueryLanguage Language
        {
            get { return language; }
        }

        /// <summary>
        /// Converts the query expression into text that corresponds to the command that would be executed.
        /// Useful for debugging.
        /// </summary>
        /// <param name="expression"></param>
        /// <returns></returns>
        public override string GetQueryText(Expression expression)
        {
            Expression translated = Translate(expression);
            var selects = SelectGatherer.Gather(translated).Select(s => language.Format(s));
            return string.Join("\n\n", selects.ToArray());
        }

        public string GetQueryPlan(Expression expression)
        {
            Expression plan = GetExecutionPlan(expression);
            return DbExpressionWriter.WriteToString(plan);
        }

        /// <summary>
        /// Execute the query expression (does translation, etc.)
        /// </summary>
        /// <param name="expression"></param>
        /// <returns></returns>
        public override object Execute(Expression expression)
        {
            Expression plan = GetExecutionPlan(expression);

            LambdaExpression lambda = expression as LambdaExpression;
            if (lambda != null)
            {
                // compile and return the execution plan so it can be used multiple times
                LambdaExpression fn = Expression.Lambda(lambda.Type, plan, lambda.Parameters);
                return fn.Compile();
            }
            else
            {
                // compile the execution plan and invoke it
                Expression<Func<object>> efn = ConvertThis(plan,typeof(object));
                Func<object> fn = efn.Compile();
                return fn();
            }
        }

        public Expression<Func<object>> ConvertThis(Expression exp, Type type)
        {

            var result = Expression.Lambda<Func<object>>(Expression.Convert(exp, type));

            return result;
        }

        public QueryCommand GetCommand(Expression exp)
        {
            string sql = GetQueryText(exp);
            QueryCommand cmd = new QueryCommand(sql, _provider);
            return cmd;
        }

        /// <summary>
        /// Convert the query expression into an execution plan
        /// </summary>
        /// <param name="expression"></param>
        /// <returns></returns>
        protected virtual Expression GetExecutionPlan(Expression expression)
        {
            // strip off lambda for now
            LambdaExpression lambda = expression as LambdaExpression;
            if (lambda != null)
                expression = lambda.Body;

            // translate query into client and server parts
            ProjectionExpression projection = Translate(expression);

            Expression rootQueryable = RootQueryableFinder.Find(expression);
            Expression provider = Expression.Convert(
                Expression.Property(rootQueryable, typeof(IQueryable).GetProperty("Provider")),
                typeof(DbQueryProvider)
                );

            return policy.BuildExecutionPlan(projection, provider);
        }

        /// <summary>
        /// Do all query translations execpt building the execution plan
        /// </summary>
        /// <param name="expression"></param>
        /// <returns></returns>
        protected virtual ProjectionExpression Translate(Expression expression)
        {
            // pre-evaluate local sub-trees
            expression = PartialEvaluator.Eval(expression, CanBeEvaluatedLocally);

            // apply mapping (binds LINQ operators too)
            expression = mapping.Translate(expression);

            // any policy specific translations or validations
            expression = policy.Translate(expression);

            // any language specific translations or validations
            expression = language.Translate(expression);

            // do final reduction
            expression = UnusedColumnRemover.Remove(expression);
            expression = RedundantSubqueryRemover.Remove(expression);
            expression = RedundantJoinRemover.Remove(expression);
            expression = RedundantColumnRemover.Remove(expression);


            //HACK: Have to fix invalid COUNT/ORDER BY here
            expression = CountOrderByRemover.Remove(expression);

            return (ProjectionExpression)expression;
        }

        /// <summary>
        /// Determines whether a given expression can be executed locally. 
        /// (It contains no parts that should be translated to the target environment.)
        /// </summary>
        /// <param name="expression"></param>
        /// <returns></returns>
        protected virtual bool CanBeEvaluatedLocally(Expression expression)
        {
            // any operation on a query can't be done locally
            ConstantExpression cex = expression as ConstantExpression;
            if (cex != null)
            {
                IQueryable query = cex.Value as IQueryable;
                if (query != null && query.Provider == this)
                    return false;
            }
            MethodCallExpression mc = expression as MethodCallExpression;
            if (mc != null &&
                (mc.Method.DeclaringType == typeof(Enumerable) ||
                 mc.Method.DeclaringType == typeof(Queryable)))
            {
                return false;
            }
            if (expression.NodeType == ExpressionType.Convert &&
                expression.Type == typeof(object))
                return true;
            return expression.NodeType != ExpressionType.Parameter &&
                   expression.NodeType != ExpressionType.Lambda;
        }

        /// <summary>
        /// Execute an actual query specified in the target language using the sADO connection
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="query"></param>
        /// <param name="paramValues"></param>
        /// <returns></returns>
        public virtual IEnumerable<T> Execute<T>(QueryCommand<T> query, object[] paramValues)
        {
            //DbCommand cmd = this.GetCommand(query.CommandText, query.ParameterNames, paramValues);
            //this.LogCommand(cmd);
            //DbDataReader reader = cmd.ExecuteReader();
            //return Project(reader, query.Projector);

            

            QueryCommand cmd = new QueryCommand(query.CommandText, _provider);
            for (int i = 0; i < paramValues.Length; i++)
            {
                
                //need to assign a DbType
                var valueType = paramValues[i].GetType();
                var dbType = Database.GetDbType(valueType);
                
                
                cmd.AddParameter(query.ParameterNames[i], paramValues[i],dbType);
            }
/*
            var reader = _provider.ExecuteReader(cmd);
            var result = Project(reader, query.Projector);
            return result;
*/

            IEnumerable<T> result;
            Type type = typeof (T);
            //this is so hacky - the issue is that the Projector below uses Expression.Convert, which is a bottleneck
            //it's about 10x slower than our ToEnumerable. Our ToEnumerable, however, stumbles on Anon types and groupings
            //since it doesn't know how to instantiate them (I tried - not smart enough). So we do some trickery here.
            if (type.Name.Contains("AnonymousType") || type.Name.StartsWith("Grouping`") || type.FullName.StartsWith("System.")) {
                var reader = _provider.ExecuteReader(cmd);
                result = Project(reader, query.Projector);
            } 
			else {

            	using (var reader = _provider.ExecuteReader(cmd)) {

            		//use our reader stuff
            		//thanks to Pascal LaCroix for the help here...
            		var resultType = typeof (T);
            		if (resultType.IsValueType) {
            			result = reader.ToEnumerableValueType<T>();

            		}
            		else {
            			if (query.ColumnNames.Count != 0) {//mike check to see if we have ColumnNames
							result = reader.ToEnumerable<T>(query.ColumnNames);
						}
            			else {
            				result = reader.ToEnumerable<T>(null);
            			}
            		}

            	}
            }
        	return result;


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
            while (reader.Read())
            {
                yield return fnProjector(reader);
            }
            reader.Dispose();
        }

        /// <summary>
        /// Get an IEnumerable that will execute the specified query when enumerated
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="query"></param>
        /// <param name="paramValues"></param>
        /// <returns></returns>
        public virtual IEnumerable<T> ExecuteDeferred<T>(QueryCommand<T> query, object[] paramValues)
        {
            DbCommand cmd = GetCommand(query.CommandText, query.ParameterNames, paramValues);
            LogCommand(cmd);
            DbDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                yield return query.Projector(reader);
            }
        }

        /// <summary>
        /// Get an ADO command object initialized with the command-text and parameters
        /// </summary>
        /// <param name="commandText"></param>
        /// <param name="paramNames"></param>
        /// <param name="paramValues"></param>
        /// <returns></returns>
        public virtual DbCommand GetCommand(string commandText, IList<string> paramNames, object[] paramValues)
        {
            // create command object (and fill in parameters)
            DbCommand cmd = connection.CreateCommand();
            cmd.CommandText = commandText;
            for (int i = 0, n = paramNames.Count; i < n; i++)
            {
                DbParameter p = cmd.CreateParameter();
                p.ParameterName = paramNames[i];
                p.Value = paramValues[i] ?? DBNull.Value;
                cmd.Parameters.Add(p);
            }
            return cmd;
        }

        /// <summary>
        /// Write a command to the log
        /// </summary>
        /// <param name="command"></param>
        protected virtual void LogCommand(DbCommand command)
        {
            //if (this.log != null)
            //{
            //    this.log.WriteLine(command.CommandText);
            //    foreach(DbParameter p in command.Parameters)
            //    {
            //        if (p.Value == null || p.Value == DBNull.Value)
            //        {
            //            this.log.WriteLine("-- @{0} = NULL", p.ParameterName);
            //        }
            //        else
            //        {
            //            this.log.WriteLine("-- @{0} = [{1}]", p.ParameterName, p.Value);
            //        }
            //    }
            //    this.log.WriteLine();
            //}
        }
    }
}