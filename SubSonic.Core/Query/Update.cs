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
using System.ComponentModel;
using System.Data;
using System.Linq.Expressions;
using SubSonic.Extensions;
using SubSonic.DataProviders;
using SubSonic.Schema;
using SubSonic.SqlGeneration;

namespace SubSonic.Query
{
    /// <summary>
    /// 
    /// </summary>
    public class Setting
    {
        internal DbType DataType = DbType.AnsiString;

        public Setting()
        {
            ColumnName = String.Empty;
            ParameterName = String.Empty;
        }

        public string ColumnName { get; internal set; }

        public string ParameterName { get; internal set; }

        public object Value { get; internal set; }

        public bool IsExpression { get; internal set; }

        public SqlQuery query { get; internal set; }

        /// <summary>
        /// Equals to.
        /// </summary>
        /// <param name="value">The value.</param>
        /// <returns></returns>
        public SqlQuery EqualTo(object value)
        {
            Value = value;
            query.SetStatements.Add(this);
            return query;
        }

        /// <summary>
        /// Determines whether the specified <see cref="T:System.Object"/> is equal to the current <see cref="T:System.Object"/>.
        /// </summary>
        /// <param name="obj">The <see cref="T:System.Object"/> to compare with the current <see cref="T:System.Object"/>.</param>
        /// <returns>
        /// true if the specified <see cref="T:System.Object"/> is equal to the current <see cref="T:System.Object"/>; otherwise, false.
        /// </returns>
        /// <exception cref="T:System.NullReferenceException">The <paramref name="obj"/> parameter is null.</exception>
        [EditorBrowsable(EditorBrowsableState.Never)]
        public override bool Equals(object obj)
        {
            return base.Equals(obj);
        }

        /// <summary>
        /// Serves as a hash function for a particular type.
        /// </summary>
        /// <returns>
        /// A hash code for the current <see cref="T:System.Object"/>.
        /// </returns>
        [EditorBrowsable(EditorBrowsableState.Never)]
        public override int GetHashCode()
        {
            return base.GetHashCode();
        }

        /// <summary>
        /// Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.
        /// </summary>
        /// <returns>
        /// A <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.
        /// </returns>
        [EditorBrowsable(EditorBrowsableState.Never)]
        public override string ToString()
        {
            return base.ToString();
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public class Update<T> : ISqlQuery where T : new()
    {
        private readonly IDataProvider _provider;
        private readonly SqlQuery _query;

        public IList<Setting> Settings
        {
            get { return _query.SetStatements; }
        }

        public List<Constraint> Constraints
        {
            get { return _query.Constraints; }
            set { _query.Constraints = value; }
        }


        #region Special Constraint

        public Update<T> Where(Expression<Func<T, bool>> column)
        {
            LambdaExpression lamda = column;
            Constraint c = lamda.ParseConstraint();

            IColumn col = _provider.FindTable(typeof(T).Name).GetColumnByPropertyName(c.ColumnName);
            Constraint con = new Constraint(c.Condition, col.Name, col.QualifiedName, col.Name);
            con.ParameterName = col.PropertyName;
            con.ParameterValue = c.ParameterValue;

            _query.Constraints.Add(con);
            return this;
        }

        #endregion


        #region SET

        /// <summary>
        /// Sets the specified columns.
        /// </summary>
        /// <param name="columns">The columns.</param>
        /// <returns></returns>
        public Update<T> Set(params Expression<Func<T, bool>>[] columns)
        {
            foreach(var column in columns)
            {
                LambdaExpression lamda = column;
                Constraint c = lamda.ParseConstraint();

                if(c.Comparison != Comparison.Equals)
                    throw new InvalidOperationException("Can't use a non-equality here");

                IColumn col = _provider.FindTable(typeof(T).Name).GetColumnByPropertyName(c.ColumnName);
                Setting setting = CreateSetting(col, false);
                setting.Value = c.ParameterValue;
                _query.SetStatements.Add(setting);
            }
            return this;
        }

        /// <summary>
        /// Sets the specified column name.
        /// </summary>
        /// <param name="columnName">Name of the column.</param>
        /// <returns></returns>
        public Setting Set(string columnName)
        {
            return CreateSetting(columnName, DbType.AnsiString, false);
        }

        public Setting Set(IColumn column)
        {
            return CreateSetting(column, false);
        }

        /// <summary>
        /// Sets the expression.
        /// </summary>
        /// <param name="column">The column.</param>
        /// <returns></returns>
        public Setting SetExpression(string column)
        {
            return CreateSetting(column, DbType.AnsiString, true);
        }

        private Setting CreateSetting(string columnName, DbType dbType, bool isExpression)
        {
            Setting s = new Setting
                            {
                                query = _query,
                                ColumnName = columnName,
                                ParameterName = (_provider.ParameterPrefix + "up_" + columnName),
                                IsExpression = isExpression,
                                DataType = dbType
                            };
            return s;
        }

        private Setting CreateSetting(IColumn column, bool isExpression)
        {
            Setting s = new Setting
                            {
                                query = _query,
                                ColumnName = column.QualifiedName,
                                ParameterName = (_provider.ParameterPrefix + "up_" + column.Name),
                                IsExpression = isExpression,
                                DataType = column.DataType
                            };
            return s;
        }

        #endregion


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
            int result = _provider.ExecuteQuery(GetCommand());

            return result;
        }

        public string BuildSqlStatement()
        {
            ISqlGenerator generator = _query.GetGenerator();
            string sql = generator.BuildUpdateStatement();
            return sql;
        }

        public QueryCommand GetCommand()
        {
            QueryCommand cmd = new QueryCommand(BuildSqlStatement(), _provider);

            //add in the commands
            foreach(Setting s in _query.SetStatements)
                cmd.Parameters.Add(s.ParameterName, s.Value, s.DataType);

            //set the contstraints
            _query.SetConstraintParams(cmd);

            return cmd;
        }

        #endregion


        #region .ctors


        /// <summary>
        /// Initializes a new instance of the <see cref="Update&lt;T&gt;"/> class.
        /// </summary>
        public Update() : this(ProviderFactory.GetProvider()) {}

        /// <summary>
        /// Initializes a new instance of the <see cref="Update&lt;T&gt;"/> class.
        /// </summary>
        /// <param name="provider">The provider.</param>
        public Update(IDataProvider provider) : this(provider.FindTable(typeof(T).Name), provider) {}

        /// <summary>
        /// Initializes a new instance of the <see cref="Update&lt;T&gt;"/> class.
        /// </summary>
        /// <param name="table">The table.</param>
        /// <param name="provider">The provider.</param>
        public Update(ITable table, IDataProvider provider)
        {
            _query = new SqlQuery(provider);
            _provider = provider;
            _query.QueryCommandType = QueryType.Update;
            ITable tbl = table;
            DatabaseTable dbTable = new DatabaseTable(tbl.Name, _provider, tbl.ClassName);
            dbTable.Columns = tbl.Columns;
            _query.FromTables.Add(dbTable);
        }

        #endregion
    }
}