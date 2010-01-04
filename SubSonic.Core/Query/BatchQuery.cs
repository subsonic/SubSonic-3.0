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
using System.Linq;
using System.Text;
using SubSonic.DataProviders;
using SubSonic.Linq.Structure;

namespace SubSonic.Query
{
    /// <summary>
    /// A holder for 1 or more queries to be executed together
    /// </summary>
    public class BatchQuery : ISqlQuery
    {
        private readonly List<QueryCommand> _fixedCommands;
        private readonly DbQueryProvider _linqProvider;

        private readonly IDataProvider _provider;
        private readonly List<ISqlQuery> _queries;
        private readonly StringBuilder sb;

        public int QueryCount
        {
            get
            {
                return _queries.Count;
            }
        }

        public BatchQuery(IDataProvider provider)
        {
            _queries = new List<ISqlQuery>();
            _linqProvider = new DbQueryProvider(provider);
            sb = new StringBuilder();
            _provider = provider;
            _fixedCommands = new List<QueryCommand>();
        }

        public BatchQuery(IDataProvider dbProvider, DbQueryProvider queryProvider)
        {
            _queries = new List<ISqlQuery>();
            sb = new StringBuilder();
            _linqProvider = queryProvider;
            _provider = dbProvider;
            _fixedCommands = new List<QueryCommand>();
        }

        public BatchQuery() : this(ProviderFactory.GetProvider()) { }


        #region ISqlQuery Members

        /// <summary>
        /// Builds the SQL statement.
        /// </summary>
        /// <returns></returns>
        public string BuildSqlStatement()
        {
            ResetCommands();
            foreach (QueryCommand cmd in _fixedCommands)
            {
                string sql = cmd.CommandSql;
                if (!sql.EndsWith(";"))
                    sql += ";\r\n";
                sb.Append(sql);
            }
            return sb.ToString();
        }

        /// <summary>
        /// Executes this instance.
        /// </summary>
        /// <returns></returns>
        public int Execute()
        {
            return _provider.ExecuteQuery(GetCommand());
        }

        /// <summary>
        /// Executes the queries in and returns a multiple result set reader.
        /// </summary>
        /// <returns></returns>
        public IDataReader ExecuteReader()
        {
            return _provider.ExecuteReader(GetCommand());
        }

        /// <summary>
        /// Gets a command containing all the queued queries.
        /// </summary>
        /// <returns></returns>
        public QueryCommand GetCommand()
        {
            string sql = BuildSqlStatement();
            QueryCommand result = new QueryCommand(sql, _provider);

            //add in the tweakered params
            foreach (var cmd in _fixedCommands)
            {
                foreach (var p in cmd.Parameters)
                    result.Parameters.Add(p);
            }

            return result;
        }

        #endregion


        /// <summary>
        /// Queues the specified query.
        /// </summary>
        /// <param name="query">The query.</param>
        public void Queue(ISqlQuery query)
        {

            _queries.Add(query);
        }

        /// <summary>
        /// Queues the specified query.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="query">The query.</param>
        public void Queue<T>(IQueryable<T> query)
        {
            QueryCommand cmd = _linqProvider.GetCommand(query.Expression);
            List<object> paramValues = new List<object>();
            foreach (var p in cmd.Parameters)
                paramValues.Add(p.ParameterValue);
            ISqlQuery q = new CodingHorror(_provider, cmd.CommandSql, paramValues.ToArray());

            _queries.Add(q);
        }

        /// <summary>
        /// Queues a query for use in a transaction.
        /// </summary>
        /// <param name="qry">The qry.</param>
        public void QueueForTransaction(ISqlQuery qry)
        {
            QueueForTransaction(qry.GetCommand());
        }

        /// <summary>
        /// Queues a query for use in a transaction.
        /// </summary>
        /// <param name="cmd">The CMD.</param>
        public void QueueForTransaction(QueryCommand cmd)
        {
            _fixedCommands.Add(cmd);
        }

        /// <summary>
        /// Queues a query for use in a transaction.
        /// </summary>
        /// <param name="sql">The SQL.</param>
        /// <param name="parameters">The parameters.</param>
        public void QueueForTransaction(string sql, params object[] parameters)
        {
            var qry = new CodingHorror(sql, parameters);
            _fixedCommands.Add(qry.GetCommand());
        }

        /// <summary>
        /// Executes the transaction.
        /// </summary>
        public void ExecuteTransaction()
        {
            using (var scope = new AutomaticConnectionScope(_provider))
            {
                using (var trans = scope.Connection.BeginTransaction())
                {
                    foreach (var cmd in _fixedCommands)
                    {
                        if (!String.IsNullOrEmpty(cmd.CommandSql))
                        {
                            var dbCommand = cmd.ToDbCommand();
                            dbCommand.Connection = scope.Connection;
                            dbCommand.Transaction = trans;

                            dbCommand.ExecuteNonQuery();
                        }
                    }
                    trans.Commit();
                    scope.Connection.Dispose();
                    _fixedCommands.Clear();
                }
            }
        }

        private void ResetCommands()
        {
            _fixedCommands.Clear();
            int indexer = 0;
            foreach (var qry in _queries)
            {
                QueryCommand cmd = qry.GetCommand();
                string commandText = cmd.CommandSql;
                foreach (var p in cmd.Parameters)
                {
                    string oldParamName = p.ParameterName;
                    p.ParameterName = _provider.ParameterPrefix + indexer;

                    commandText = System.Text.RegularExpressions.Regex.Replace(commandText, oldParamName + @"(\s)", _provider.ParameterPrefix + "p" + indexer + "$1");
                    indexer++;
                }
                cmd.CommandSql = commandText.Replace(_provider.ParameterPrefix + "p", _provider.ParameterPrefix);
                _fixedCommands.Add(cmd);
            }
        }
    }
}