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
using System.Linq;

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

        public Update query { get; internal set; }

        /// <summary>
        /// Equals to.
        /// </summary>
        /// <param name="value">The value.</param>
        /// <returns></returns>
        public Update EqualTo(object value)
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

    public class Update : ISqlQuery
    {
        #region .ctors

        /// <summary>
        /// Initializes a new instance of the <see cref="Update&lt;T&gt;"/> class.
        /// </summary>
        public Update(string tableName) : this(ProviderFactory.GetProvider().FindTable(tableName)) {}

        public Update(string tableName, IDataProvider provider) : this(provider.FindTable(tableName)) {}

        /// <summary>
        /// Initializes a new instance of the <see cref="Update&lt;T&gt;"/> class.
        /// </summary>
        /// <param name="table">The table.</param>
        public Update(ITable table)
        {
            _query = new SqlQuery(table.Provider);
            _provider = table.Provider;
            _query.QueryCommandType = QueryType.Update;
            ITable tbl = table;
            DatabaseTable dbTable = new DatabaseTable(tbl.Name, _provider, tbl.ClassName);
            dbTable.Columns = tbl.Columns;
            _query.FromTables.Add(dbTable);
        }

        #endregion


        internal readonly IDataProvider _provider;
        internal readonly SqlQuery _query;

        internal List<Setting> SetStatements
        {
            get { return _query.SetStatements; }
            set { _query.SetStatements = value; }
        }

        public IList<Setting> Settings
        {
            get { return _query.SetStatements; }
        }

        public List<Constraint> Constraints
        {
            get { return _query.Constraints; }
            set { _query.Constraints = value; }
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

        internal Setting CreateSetting(string columnName, DbType dbType, bool isExpression)
        {
            Setting s = new Setting
                            {
                                query = this,
                                ColumnName = columnName,
                                ParameterName = String.Format("{0}up_{1}", _provider.ParameterPrefix,columnName),
                                IsExpression = isExpression,
                                DataType = dbType
                            };
            return s;
        }

        internal Setting CreateSetting(IColumn column, bool isExpression)
        {
            Setting s = new Setting
                            {
                                query = this,
                                ColumnName = column.Name,
                                ParameterName = (_provider.ParameterPrefix + "up_" + column.Name),
                                IsExpression = isExpression,
                                DataType = column.DataType
                            };
            return s;
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
            {
                //Fix the data type!
                var table = _query.FromTables.FirstOrDefault();
                if(table != null)
                {
                    // EK: The line below is intentional. See: http://weblogs.asp.net/fbouma/archive/2009/06/25/linq-beware-of-the-access-to-modified-closure-demon.aspx
                    Setting setting = s;

                    var col = table.Columns.SingleOrDefault(x => x.Name.Equals(setting.ColumnName, StringComparison.InvariantCultureIgnoreCase));
                    if(col != null)
                        s.DataType = col.DataType;
                }
                cmd.Parameters.Add(s.ParameterName, s.Value, s.DataType);
            }

            //set the contstraints
            _query.SetConstraintParams(cmd);

            return cmd;
        }

        #endregion


        public Update Where<T>(Expression<Func<T, bool>> expression)
        {
            //ExpressionParser parser = new ExpressionParser();
            IList<Constraint> c = expression.ParseConstraints();

            foreach(Constraint constrain in c)
            {
                IColumn column = _provider.FindTable(typeof(T).Name).GetColumnByPropertyName(constrain.ColumnName);
                constrain.ColumnName = column.Name;
                constrain.ConstructionFragment = column.Name;
                constrain.DbType = column.DataType;
                constrain.ParameterName = column.ParameterName;
                constrain.QualifiedColumnName = column.QualifiedName;
                constrain.TableName = column.Table.Name;
                Constraints.Add(constrain);
            }

            return this;
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public class Update<T> : Update where T : new()
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="Update&lt;T&gt;"/> class.
        /// </summary>
        /// <param name="provider">The provider.</param>
        public Update(IDataProvider provider) : base(provider.FindOrCreateTable<T>()) {}


        #region Special Constraint

        public Update<T> Where(Expression<Func<T, bool>> column)
        {
            LambdaExpression lamda = column;
            Constraint c = lamda.ParseConstraint();
            var tbl = _provider.FindOrCreateTable(typeof(T));
            IColumn col = tbl.GetColumnByPropertyName(c.ColumnName);
            Constraint con = new Constraint(c.Condition, col.Name, col.QualifiedName, col.Name)
                                 {
                                     ParameterName = col.PropertyName,
                                     ParameterValue = c.ParameterValue
                                 };

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

        #endregion
    }
}