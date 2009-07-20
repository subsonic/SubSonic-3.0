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
using System.Linq.Expressions;
using System.Text;
using SubSonic.Extensions;
using SubSonic.DataProviders;
using SubSonic.Query;
using SubSonic.Schema;
using SubSonic.SqlGeneration;

namespace SubSonic.Query
{
    public class InsertSetting
    {
        internal string ColumnName = String.Empty;
        internal DbType DataType = DbType.AnsiString;
        internal bool IsExpression;
        internal string ParameterName = String.Empty;
        internal object Value;
    }

    /// <summary>
    /// 
    /// </summary>
    public class Insert : ISqlQuery
    {
        private readonly IDataProvider _provider;
        public List<string> ColumnList = new List<string>();
        public List<InsertSetting> Inserts = new List<InsertSetting>();
        internal SqlQuery SelectValues;
        internal ITable Table;
        private string tableName = "";

        /// <summary>
        /// Initializes a new instance of the <see cref="Insert"/> class.
        /// </summary>
        public Insert() : this(ProviderFactory.GetProvider()) {}

        /// <summary>
        /// Initializes a new instance of the <see cref="Insert"/> class.
        /// </summary>
        /// <param name="provider">The provider.</param>
        public Insert(IDataProvider provider)
        {
            _provider = provider;
        }

        internal string SelectColumns
        {
            get { return ColumnList.ToDelimitedList(); }
        }


        #region ISqlQuery Members

        /// <summary>
        /// Builds the SQL statement.
        /// </summary>
        /// <returns></returns>
        public string BuildSqlStatement()
        {
            SqlQuery q = new SqlQuery(_provider);

            ISqlGenerator generator = q.GetGenerator();
            generator.SetInsertQuery(this);

            string sql = generator.BuildInsertStatement();
            return sql;
        }

        #endregion


        public Insert Into<T>(params Expression<Func<T, object>>[] props)
        {
            ColumnList.Clear();
            Table = _provider.FindOrCreateTable(typeof(T));
            tableName = Table.Name;
            Init();
            foreach(object o in props)
            {
                LambdaExpression lamba = o as LambdaExpression;
                ColumnList.Add(lamba.ParseObjectValue());
            }
            return this;
        }

        /// <summary>
        /// Adds the specified columns into a new Insert object.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="columns">The columns.</param>
        /// <returns></returns>
        public Insert Into<T>(params string[] columns) where T : new()
        {
            ColumnList.Clear();
            ColumnList.AddRange(columns);
            Table = _provider.FindOrCreateTable(typeof(T));
            tableName = Table.Name;
            Init();
            return this; //Init(new T().GetSchema());
        }

        /// <summary>
        /// Adds the specified columns into a new Insert object.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="tbl">The TBL.</param>
        /// <returns></returns>
        public Insert Into<T>(ITable tbl) where T : new()
        {
            ColumnList.Clear();
            Table = tbl;
            tableName = tbl.Name;
            Init();
            return this;
        }

        /// <summary>
        /// Inits this instance.
        /// </summary>
        /// <returns></returns>
        private Insert Init()
        {
            if(Table==null)
                throw new InvalidOperationException("No table is set");

            // EK: No methods consume the return value. Is the rest of this necessary?
            bool isFirst = true;
            StringBuilder sb = new StringBuilder();
            foreach(string s in ColumnList)
            {
                if(!isFirst)
                    sb.Append(",");
                sb.Append(s);

                isFirst = false;
            }
            return this;
        }

        private Insert AddValues(bool isExpression, params object[] values)
        {
            //this is a lineup game
            //make sure that the count of values
            //is equal to the columns
            if(values.Length != ColumnList.Count)
                throw new InvalidOperationException("The Select list and value list don't match - they need to match exactly if you're creating an INSERT VALUES query");

            int itemIndex = 0;
            foreach(string s in ColumnList)
            {
                AddInsertSetting(s, values[itemIndex], DbType.AnsiString, isExpression);
                itemIndex++;
            }

            return this;
        }

        private void AddInsertSetting(string columnName, object columnValue, DbType dbType, bool isExpression)
        {
            InsertSetting setting = new InsertSetting
                                        {
                                            ColumnName = columnName,
                                            ParameterName = _provider.ParameterPrefix + "ins_" + columnName.ToAlphaNumericOnly(),
                                            Value = columnValue,
                                            IsExpression = isExpression,
                                            DataType = dbType
                                        };
            Inserts.Add(setting);
        }

        /// <summary>
        /// Values the specified column.
        /// </summary>
        /// <param name="column">The column.</param>
        /// <param name="columnValue">The column value.</param>
        /// <returns></returns>
        public Insert Value(string column, object columnValue)
        {
            AddInsertSetting(column, columnValue, DbType.AnsiString, false);
            ColumnList.Add(column);
            return this;
        }

        /// <summary>
        /// Values the specified column.
        /// </summary>
        /// <param name="column">The column.</param>
        /// <param name="columnValue">The column value.</param>
        /// <param name="dbType">Type of the db.</param>
        /// <returns></returns>
        public Insert Value(string column, object columnValue, DbType dbType)
        {
            AddInsertSetting(column, columnValue, dbType, false);
            ColumnList.Add(column);
            return this;
        }

        /// <summary>
        /// Valueses the specified values.
        /// </summary>
        /// <param name="values">The values.</param>
        /// <returns></returns>
        public Insert Values(params object[] values)
        {
            return AddValues(false, values);
        }

        /// <summary>
        /// Values the expression.
        /// </summary>
        /// <param name="values">The values.</param>
        /// <returns></returns>
        public Insert ValueExpression(params object[] values)
        {
            return AddValues(true, values);
        }

        /// <summary>
        /// Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.
        /// </summary>
        /// <returns>
        /// A <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.
        /// </returns>
        public override string ToString()
        {
            return BuildSqlStatement();
        }


        #region Execution

        public IDataReader ExecuteReader()
        {
            return _provider.ExecuteReader(GetCommand());
        }

        /// <summary>
        /// Executes this instance.
        /// </summary>
        /// <returns></returns>
        public int Execute()
        {
            int returner = 0;

            object result = _provider.ExecuteScalar(GetCommand());
            if(result != null)
            {
                if(result.GetType() == typeof(decimal))
                    returner = Convert.ToInt32(result);
                if(result.GetType() == typeof(int))
                    returner = Convert.ToInt32(result);
            }
            return returner;
        }

        public QueryCommand GetCommand()
        {
            string sql = BuildSqlStatement();
            QueryCommand cmd = new QueryCommand(sql, _provider);

            //add in the commands
            foreach(InsertSetting s in Inserts)
            {
                QueryParameter p = new QueryParameter
                                       {
                                           ParameterName = s.ParameterName,
                                           ParameterValue = s.Value ?? DBNull.Value,
                                           DataType = s.DataType
                                       };
                cmd.Parameters.Add(p);
            }
            return cmd;
        }

        #endregion
    }
}