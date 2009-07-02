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
using SubSonic.Extensions;
using SubSonic.DataProviders;

namespace SubSonic.Query
{
    /// <summary>
    /// This set of classes abstracts out commands and their parameters so that
    /// the DataProviders can work their magic regardless of the client type. The
    /// System.Data.Common class was supposed to do this, but sort of fell flat
    /// when it came to MySQL and other DB Providers that don't implement the Data
    /// Factory pattern. Abstracts out the assignment of parameters, etc
    /// </summary>
    public class QueryParameter
    {
        internal const ParameterDirection DefaultParameterDirection = ParameterDirection.Input;
        internal const int DefaultSize = 50;
        private ParameterDirection _mode = DefaultParameterDirection;

        private int _size = DefaultSize;
        public int Scale { get; set; }
        public int Precision { get; set; }

        /// <summary>
        /// Gets or sets the size.
        /// </summary>
        /// <value>The size.</value>
        public int Size
        {
            get { return _size; }
            set { _size = value; }
        }

        /// <summary>
        /// Gets or sets the mode.
        /// </summary>
        /// <value>The mode.</value>
        public ParameterDirection Mode
        {
            get { return _mode; }
            set { _mode = value; }
        }

        /// <summary>
        /// Gets or sets the name of the parameter.
        /// </summary>
        /// <value>The name of the parameter.</value>
        public string ParameterName { get; set; }

        /// <summary>
        /// Gets or sets the parameter value.
        /// </summary>
        /// <value>The parameter value.</value>
        public object ParameterValue { get; set; }

        /// <summary>
        /// Gets or sets the type of the data.
        /// </summary>
        /// <value>The type of the data.</value>
        public DbType DataType { get; set; }
    }

    /// <summary>
    /// Summary for the QueryParameterCollection class
    /// </summary>
    public class QueryParameterCollection : List<QueryParameter>
    {
        /// <summary>
        /// Checks to see if specified parameter exists in the current collection
        /// </summary>
        /// <param name="parameterName"></param>
        /// <returns></returns>
        public bool Contains(string parameterName)
        {
            foreach(QueryParameter p in this)
            {
                if(p.ParameterName.MatchesTrimmed(parameterName))
                    return true;
            }
            return false;
        }

        /// <summary>
        /// returns the specified QueryParameter, if it exists in this collection
        /// </summary>
        /// <param name="parameterName"></param>
        /// <returns></returns>
        public QueryParameter GetParameter(string parameterName)
        {
            foreach(QueryParameter p in this)
            {
                if(p.ParameterName.MatchesTrimmed(parameterName))
                    return p;
            }
            return null;
        }

        /// <summary>
        /// Adds the specified parameter name.
        /// </summary>
        /// <param name="parameterName">Name of the parameter.</param>
        /// <param name="value">The value.</param>
        public void Add(string parameterName, object value)
        {
            Add(parameterName, value, DbType.AnsiString, ParameterDirection.Input);
        }

        /// <summary>
        /// Adds the specified parameter name.
        /// </summary>
        /// <param name="parameterName">Name of the parameter.</param>
        /// <param name="value">The value.</param>
        /// <param name="dataType">Type of the data.</param>
        public void Add(string parameterName, object value, DbType dataType)
        {
            Add(parameterName, value, dataType, ParameterDirection.Input);
        }

        /// <summary>
        /// Adds the specified parameter name.
        /// </summary>
        /// <param name="parameterName">Name of the parameter.</param>
        /// <param name="value">The value.</param>
        /// <param name="dataType">Type of the data.</param>
        /// <param name="mode">The mode.</param>
        public void Add(string parameterName, object value, DbType dataType, ParameterDirection mode)
        {
            //remove if already added, and replace with last in
            if(Contains(parameterName))
                Remove(GetParameter(parameterName));

            QueryParameter param = new QueryParameter
                                       {
                                           ParameterName = parameterName,
                                           ParameterValue = value,
                                           DataType = dataType,
                                           Mode = mode
                                       };
            Add(param);
        }
    }

    /// <summary>
    /// Summary for the QueryCommandCollection class
    /// </summary>
    public class QueryCommandCollection : List<QueryCommand> {}

    /// <summary>
    /// Summary for the QueryCommand class
    /// </summary>
    public class QueryCommand
    {
        private int commandTimeout = 60;

        /// <summary>
        /// 
        /// </summary>
        public List<object> OutputValues;

        private QueryParameterCollection parameters;

        /// <summary>
        /// Initializes a new instance of the <see cref="QueryCommand"/> class.
        /// </summary>
        /// <param name="sql">The SQL.</param>
        /// <param name="provider">The provider.</param>
        public QueryCommand(string sql, IDataProvider provider)
        {
            CommandSql = sql;
            CommandType = CommandType.Text;
            parameters = new QueryParameterCollection();
            OutputValues = new List<object>();
            Provider = provider;
        }

        public IDataProvider Provider { get; set; }
        public string ProviderName { get; set; }

        /// <summary>
        /// Gets or sets the command timeout (in seconds).
        /// </summary>
        /// <value>The command timeout.</value>
        public int CommandTimeout
        {
            get { return commandTimeout; }
            set { commandTimeout = value; }
        }

        /// <summary>
        /// Gets or sets the type of the command.
        /// </summary>
        /// <value>The type of the command.</value>
        public CommandType CommandType { get; set; }

        /// <summary>
        /// Gets or sets the command SQL.
        /// </summary>
        /// <value>The command SQL.</value>
        public string CommandSql { get; set; }

        /// <summary>
        /// Gets or sets the parameters.
        /// </summary>
        /// <value>The parameters.</value>
        public QueryParameterCollection Parameters
        {
            get { return parameters; }
            set { parameters = value; }
        }

        /// <summary>
        /// Determines whether [has output params].
        /// </summary>
        /// <returns>
        /// 	<c>true</c> if [has output params]; otherwise, <c>false</c>.
        /// </returns>
        public bool HasOutputParams()
        {
            bool bOut = false;

            //loop the params and see if one is in/out
            foreach(QueryParameter param in Parameters)
            {
                if(param.Mode != ParameterDirection.Input)
                {
                    bOut = true;
                    break;
                }
            }

            return bOut;
        }

        /// <summary>
        /// Adds the parameter. The public AddParameter methods should call this one.
        /// </summary>
        /// <param name="parameterName">Name of the parameter.</param>
        /// <param name="parameterValue">The parameter value.</param>
        /// <param name="maxSize">Size of the max.</param>
        /// <param name="dbType">Type of the db.</param>
        /// <param name="direction">The direction.</param>
        private void AddParameter(string parameterName, object parameterValue, int maxSize, DbType dbType, ParameterDirection direction)
        {
            if(parameters == null)
                parameters = new QueryParameterCollection();

            QueryParameter param = new QueryParameter
                                       {
                                           ParameterName = parameterName,
                                           ParameterValue = (parameterValue ?? DBNull.Value),
                                           Mode = direction,
                                           DataType = dbType
                                       };

            if(maxSize > -1 && direction != ParameterDirection.Output)
                param.Size = maxSize;

            parameters.Add(param);
        }

        /// <summary>
        /// Adds the parameter.
        /// </summary>
        /// <param name="parameterName">Name of the parameter.</param>
        /// <param name="parameterValue">The parameter value.</param>
        /// <param name="dataType">Type of the data.</param>
        /// <param name="parameterDirection">The parameter direction.</param>
        public void AddParameter(string parameterName, object parameterValue, DbType dataType, ParameterDirection parameterDirection)
        {
            AddParameter(parameterName, parameterValue, QueryParameter.DefaultSize, dataType, parameterDirection);
        }

        /// <summary>
        /// Adds the parameter.
        /// </summary>
        /// <param name="parameterName">Name of the parameter.</param>
        /// <param name="parameterValue">The parameter value.</param>
        /// <param name="dataType">Type of the data.</param>
        public void AddParameter(string parameterName, object parameterValue, DbType dataType)
        {
            AddParameter(parameterName, parameterValue, QueryParameter.DefaultSize, dataType, QueryParameter.DefaultParameterDirection);
        }

        /// <summary>
        /// Adds the parameter.
        /// </summary>
        /// <param name="parameterName">Name of the parameter.</param>
        /// <param name="parameterValue">The parameter value.</param>
        public void AddParameter(string parameterName, object parameterValue)
        {
            AddParameter(parameterName, parameterValue, QueryParameter.DefaultSize, DbType.Object, QueryParameter.DefaultParameterDirection);
        }

        /// <summary>
        /// Adds the output parameter.
        /// </summary>
        /// <param name="parameterName">Name of the parameter.</param>
        /// <param name="maxSize">Size of the max.</param>
        /// <param name="dbType">Type of the db.</param>
        public void AddOutputParameter(string parameterName, int maxSize, DbType dbType)
        {
            AddParameter(parameterName, DBNull.Value, maxSize, dbType, ParameterDirection.Output);
        }

        /// <summary>
        /// Adds the output parameter.
        /// </summary>
        /// <param name="parameterName">Name of the parameter.</param>
        /// <param name="maxSize">Size of the max.</param>
        public void AddOutputParameter(string parameterName, int maxSize)
        {
            AddOutputParameter(parameterName, maxSize, DbType.AnsiString);
        }

        /// <summary>
        /// Adds the output parameter.
        /// </summary>
        /// <param name="parameterName">Name of the parameter.</param>
        public void AddOutputParameter(string parameterName)
        {
            AddOutputParameter(parameterName, -1, DbType.AnsiString);
        }

        /// <summary>
        /// Adds the output parameter.
        /// </summary>
        /// <param name="parameterName">Name of the parameter.</param>
        /// <param name="dbType">Type of the db.</param>
        public void AddOutputParameter(string parameterName, DbType dbType)
        {
            AddOutputParameter(parameterName, -1, dbType);
        }

        /// <summary>
        /// Adds a return parameter (RETURN_VALUE) to the command.
        /// 
        /// </summary>
        public void AddReturnParameter()
        {
            AddParameter("@RETURN_VALUE", null, DbType.Int32, ParameterDirection.ReturnValue);
        }

        public DbCommand ToDbCommand()
        {
            return ToDbCommand(null);
        }

        public DbCommand ToDbCommand(DbTransaction trannie)
        {
            var connection = Provider.Factory.CreateConnection();
            connection.ConnectionString = Provider.ConnectionString;

            var cmd = connection.CreateCommand();
            cmd.CommandText = CommandSql;
            cmd.CommandType = CommandType.Text;

            if(trannie != null)
                cmd.Transaction = trannie;

            foreach(var param in parameters)
            {
                DbParameter p = cmd.CreateParameter();
                p.ParameterName = param.ParameterName;
                p.Value = param.ParameterValue ?? DBNull.Value;
                p.DbType = param.DataType;
                cmd.Parameters.Add(p);
            }
            return cmd;
        }

        /// <summary>
        /// Suggested by feroalien@hotmail.com
        /// Issue 11 fix
        /// </summary>
        /// <param name="command"></param>
        public void GetOutputParameters(DbCommand command)
        {
            if(HasOutputParams())
            {
                foreach(QueryParameter p in Parameters)
                {
                    if(p.Mode == ParameterDirection.InputOutput || p.Mode == ParameterDirection.Output || p.Mode == ParameterDirection.ReturnValue)
                    {
                        object oVal = command.Parameters[p.ParameterName].Value;
                        p.ParameterValue = oVal;
                        OutputValues.Add(oVal);
                    }
                }
            }
        }
    }
}