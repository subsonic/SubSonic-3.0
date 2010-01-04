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
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq.Expressions;
using System.Text;
using System.Transactions;
using SubSonic.Extensions;
using SubSonic.DataProviders;
using SubSonic.Schema;
using SubSonic.SqlGeneration;

namespace SubSonic.Query
{
    /// <summary>
    /// 
    /// </summary>
    public class SqlQuery : ISqlQuery
    {
        public IDataProvider _provider;
        private List<Setting> _setStatements = new List<Setting>();
        public IList<Aggregate> Aggregates = new List<Aggregate>();

        public List<Constraint> Constraints = new List<Constraint>();
        public int CurrentPage;
        public List<string> Expressions = new List<string>();
        public IList<ITable> FromTables = new List<ITable>();
        public List<Join> Joins = new List<Join>();
        public List<string> OrderBys = new List<string>();

        public int PageSize;
        public QueryType QueryCommandType = QueryType.Select;

        public string[] SelectColumnList = new string[0];
        public IList<IColumn> SelectColumns = new List<IColumn>();
        public string TopSpec = String.Empty;

        /// <summary>
        /// Initializes a new instance of the <see cref="SqlQuery"/> class.
        /// </summary>
        /// <param name="provider">The provider.</param>
        public SqlQuery(IDataProvider provider)
        {
            _provider = provider;
        }

        public SqlQuery()
        {
            //_provider = new DbDataProvider();
        }

        public SqlQuery(string connectionStringName)
        {
            string provider = ConfigurationManager.ConnectionStrings[connectionStringName].ProviderName;
            string cString = ConfigurationManager.ConnectionStrings[connectionStringName].ConnectionString;
            _provider = new DbDataProvider(cString, provider);
        }


        #region Validation

        /// <summary>
        /// Validates the query.
        /// </summary>
        public virtual void ValidateQuery()
        {
            //gotta have a "FROM"
            if(FromTables.Count == 0)
                throw new InvalidOperationException("Need to have at least one From table specified");
        }

        #endregion


        /// <summary>
        /// Gets or sets the open paren count.
        /// </summary>
        /// <value>The open paren count.</value>
        public int OpenParenCount { get; internal set; }

        /// <summary>
        /// Gets or sets the closed paren count.
        /// </summary>
        /// <value>The closed paren count.</value>
        public int ClosedParenCount { get; internal set; }

        internal List<Setting> SetStatements
        {
            get { return _setStatements; }
            set { _setStatements = value; }
        }

        public string SQLCommand { get; set; }
        public bool ReturnsAnonymousType { get; set; }
        public Expression WhereExpression { get; set; }
        public Expression Projector { get; set; }

        /// <summary>
        /// Finds the column.
        /// </summary>
        /// <param name="Name">Name of the column.</param>
        /// <returns></returns>
        public IColumn FindColumn(string Name)
        {
            IColumn result = null;
            foreach(ITable t in FromTables)
            {
                result = t.GetColumn(Name);
                if(result != null)
                    return result;
            }
            return result;
        }

        internal DbType GetConstraintDbType(string tableName, string Name, object constraintValue)
        {
            string providerTable = null;
            string providerColumn = null;

            if(!String.IsNullOrEmpty(tableName))
                providerTable = tableName;
            if(FromTables.Count > 0)
                providerTable = FromTables[0].Name;

            if(!String.IsNullOrEmpty(Name))
                providerColumn = Name;

            if(!String.IsNullOrEmpty(providerTable) & ! String.IsNullOrEmpty(providerColumn))
            {
                ITable table = _provider.FindTable(providerTable);
                if(table != null)
                {
                    IColumn column = table.GetColumn(providerColumn);
                    if(column != null)
                        return column.DataType;
                }
            }
            return DbType.AnsiString;
        }


        #region Where

        public SqlQuery Where<T>(Expression<Func<T, bool>> expression)
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

        /// <summary>
        /// Wheres the specified column name.
        /// </summary>
        /// <param name="Name">Name of the column.</param>
        /// <returns></returns>
        public Constraint Where(string Name)
        {
            return new Constraint(ConstraintType.Where, Name, this);
        }

        /// <summary>
        /// Wheres the specified column.
        /// </summary>
        /// <param name="column">The column.</param>
        /// <returns></returns>
        public Constraint Where(IColumn column)
        {
            Constraint c = new Constraint(ConstraintType.Where, column.Name, column.QualifiedName, column.Name, this)
                               {
                                   TableName = column.Table.Name
                               };
            return c;
        }

        /// <summary>
        /// Wheres the specified agg.
        /// </summary>
        /// <param name="agg">The agg.</param>
        /// <returns></returns>
        public Constraint Where(Aggregate agg)
        {
            Constraint c = new Constraint(ConstraintType.Where, agg.ColumnName, agg.ColumnName, agg.WithoutAlias(), this)
                               {
                                   IsAggregate = true
                               };
            return c;
        }

        #endregion


        #region Or

        /// <summary>
        /// Ors the specified column name.
        /// </summary>
        /// <param name="Name">Name of the column.</param>
        /// <returns></returns>
        public Constraint Or(string Name)
        {
            return new Constraint(ConstraintType.Or, Name, this);
        }

        /// <summary>
        /// Ors the specified column.
        /// </summary>
        /// <param name="column">The column.</param>
        /// <returns></returns>
        public Constraint Or(IColumn column)
        {
            Constraint c = new Constraint(ConstraintType.Or, column.Name, column.QualifiedName, column.Name, this)
                               {
                                   TableName = column.Table.Name
                               };
            return c;
        }

        /// <summary>
        /// Ors the specified agg.
        /// </summary>
        /// <param name="agg">The agg.</param>
        /// <returns></returns>
        public Constraint Or(Aggregate agg)
        {
            Constraint c = new Constraint(ConstraintType.Or, agg.ColumnName, agg.ColumnName, agg.WithoutAlias(), this)
                               {
                                   IsAggregate = true
                               };
            return c;
        }

        /// <summary>
        /// Ors the expression.
        /// </summary>
        /// <param name="columnName">Name of the column.</param>
        /// <returns></returns>
        public Constraint OrExpression(string columnName)
        {
            //as a convenience, check that the last constraint
            //is a close paren
            if(Constraints.Count > 0 && (ClosedParenCount < OpenParenCount))
            {
                Constraint last = Constraints[Constraints.Count - 1];
                if(last.Comparison != Comparison.CloseParentheses)
                    CloseExpression();
            }

            OpenParenCount++;
            return new Constraint(ConstraintType.Or, columnName, columnName, "(" + columnName, this);
        }

        /// <summary>
        /// Opens the expression.
        /// </summary>
        /// <returns></returns>
        public SqlQuery OpenExpression()
        {
            Constraint c = new Constraint(ConstraintType.Where, "##", "##", "##", this)
                               {
                                   Comparison = Comparison.OpenParentheses
                               };
            Constraints.Add(c);
            OpenParenCount++;
            return this;
        }

        /// <summary>
        /// Closes the expression.
        /// </summary>
        /// <returns></returns>
        public SqlQuery CloseExpression()
        {
            Constraint c = new Constraint(ConstraintType.Where, "##", "##", "##", this)
                               {
                                   Comparison = Comparison.CloseParentheses
                               };
            Constraints.Add(c);
            ClosedParenCount++;
            return this;
        }

        #endregion


        #region And

        /// <summary>
        /// Ands the specified column name.
        /// </summary>
        /// <param name="Name">Name of the column.</param>
        /// <returns></returns>
        public Constraint And(string Name)
        {
            return new Constraint(ConstraintType.And, Name, this);
        }

        /// <summary>
        /// Ands the specified column.
        /// </summary>
        /// <param name="column">The column.</param>
        /// <returns></returns>
        public Constraint And(IColumn column)
        {
            Constraint c = new Constraint(ConstraintType.And, column.Name, column.QualifiedName, column.Name, this)
                               {
                                   TableName = column.Table.Name
                               };
            return c;
        }

        /// <summary>
        /// Ands the specified agg.
        /// </summary>
        /// <param name="agg">The agg.</param>
        /// <returns></returns>
        public Constraint And(Aggregate agg)
        {
            Constraint c = new Constraint(ConstraintType.And, agg.ColumnName, agg.ColumnName, agg.WithoutAlias(), this)
                               {
                                   IsAggregate = true
                               };
            return c;
        }

        /// <summary>
        /// Ands the expression.
        /// </summary>
        /// <param name="columnName">Name of the column.</param>
        /// <returns></returns>
        public Constraint AndExpression(string columnName)
        {
            //as a convenience, check that the last constraint
            //is a close paren
            if(Constraints.Count > 0 && (ClosedParenCount < OpenParenCount))
            {
                Constraint last = Constraints[Constraints.Count - 1];
                if(last.Comparison != Comparison.CloseParentheses)
                    CloseExpression();
            }
            OpenParenCount++;
            return new Constraint(ConstraintType.And, columnName, columnName, "(" + columnName, this);
        }

        #endregion


        #region Exception Handling

        internal static InvalidOperationException GenerateException(Exception fromException)
        {
            InvalidOperationException result;
            //evaluate the error
            //sometimes these things are easy
            //and we can not only report back the problem
            //but how to solve

            //connection strings?
            if(fromException.Message.ToLower().Contains("user instance"))
            {
                result =
                    new InvalidOperationException(
                        "You're trying to connect to a database in your App_Data directory, and your SQL Server installation does not support User Instances.",
                        fromException);
            }
            else if(fromException.Message.Contains("use correlation names"))
            {
                result =
                    new InvalidOperationException(
                        "The joins on your query are not ordered properly - make sure you're not repeating a table in the first (or 'from') position on a join that's also specified in FROM. Also - a JOIN can't have two of the same table in the 'from' first position. Check the SQL output to see how to order this properly",
                        fromException);
            }
            else
                result = new InvalidOperationException(fromException.Message, fromException);

            return result;
        }

        #endregion


        #region object overrides

        /// <summary>
        /// Returns the currently set SQL statement for this query object
        /// </summary>
        /// <returns></returns>
        public override string ToString()
        {
            return BuildSqlStatement();
        }

        #endregion


        #region Sql Builder

        /// <summary>
        /// Builds the SQL statement.
        /// </summary>
        /// <returns></returns>
        public virtual string BuildSqlStatement()
        {
            ValidateQuery();
            ISqlGenerator generator = GetGenerator();
            string sql;

            switch(QueryCommandType)
            {
                case QueryType.Update:
                    sql = generator.BuildUpdateStatement();
                    break;
                case QueryType.Insert:
                    sql = generator.BuildInsertStatement();
                    break;
                case QueryType.Delete:
                    sql = generator.BuildDeleteStatement();
                    break;
                default:
                    sql = PageSize > 0 ? generator.BuildPagedSelectStatement() : generator.BuildSelectStatement();
                    break;
            }

            return sql;
        }

        internal ISqlGenerator GetGenerator()
        {
            switch(_provider.Client)
            {
                case DataClient.MySqlClient:
                    return new MySqlGenerator(this);
                case DataClient.SQLite:
                    return new SQLiteGenerator(this);
                default:
                    return new Sql2005Generator(this);
            }
        }

        #endregion


        #region Command Builder

        public QueryCommand GetCommand()
        {
            
            QueryCommand cmd = new QueryCommand(BuildSqlStatement(), _provider);
            SetConstraintParams(cmd);

            return cmd;
        }

        internal static void SetConstraintParams(SqlQuery qry, QueryCommand cmd)
        {
            //loop the constraints and add the values
            foreach(Constraint c in qry.Constraints)
            {
                //set the data type of the param
                IColumn col = qry.FindColumn(c.ColumnName);
                if(col != null)
                    c.DbType = col.DataType;

                if(c.Comparison == Comparison.BetweenAnd)
                {
                    cmd.Parameters.Add(String.Concat(c.ParameterName, "_start"), c.StartValue, c.DbType);
                    cmd.Parameters.Add(String.Concat(c.ParameterName + "_end"), c.EndValue, c.DbType);
                }
                else if(c.Comparison == Comparison.In || c.Comparison == Comparison.NotIn)
                {
                    if(c.InSelect != null)
                    {
                        //set the parameters for the nested select
                        //this will support recursive INs... I hope
                        SetConstraintParams(c.InSelect, cmd);
                    }
                    else
                    {
                        int i = 1;
                        IEnumerator en = c.InValues.GetEnumerator();
                        while(en.MoveNext())
                        {
                            cmd.Parameters.Add(String.Concat(c.ParameterName, "In", i), en.Current, c.DbType);
                            i++;
                        }
                    }
                }
                else
                    cmd.Parameters.Add(c.ParameterName, c.ParameterValue, c.DbType);
            }
        }

        internal void SetConstraintParams(QueryCommand cmd)
        {
            //loop the constraints and add the values
            SetConstraintParams(this, cmd);
        }

        #endregion


        #region From

        /// <summary>
        /// Froms the specified TBL.
        /// </summary>
        /// <param name="tbl">The TBL.</param>
        /// <returns></returns>
        public SqlQuery From(ITable tbl)
        {
            FromTables.Add(tbl);
            _provider = tbl.Provider;
            return this;
        }

        /// <summary>
        /// Froms the specified TBL.
        /// </summary>
        /// <param name="tableName">Name of the table.</param>
        /// <returns></returns>
        public SqlQuery From(string tableName)
        {
            ITable tbl = _provider.FindTable(tableName) ?? new DatabaseTable(tableName,_provider);

            if(tbl == null)
                throw new InvalidOperationException("Can't find the table " + tableName + "; suggest you use the Generics <T> to pass the From (From<T>())");

            FromTables.Add(tbl);
            _provider = tbl.Provider;
            return this;
        }

        /// <summary>
        /// Froms the specified TBL.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public SqlQuery From<T>()
        {
            Type tblType = typeof(T);
            var result = _provider.FindOrCreateTable(tblType);
            return From(result);
        }

        #endregion


        #region Joins


        #region Join Builders

        private void CreateJoin(IColumn fromColumn, IColumn toColumn, Join.JoinType type)
        {
            Join j = new Join(toColumn, fromColumn, type);
            Joins.Add(j);

            //add the tables to the From collection
            if(!FromTables.Contains(toColumn.Table))
                FromTables.Add(toColumn.Table);
        }

        private void CreateJoin<T>(string fromColumnName, string toColumnName, Join.JoinType type)
        {
            //see if we can find the table
            var toTable = _provider.FindOrCreateTable(typeof(T));

            //the assumption here is that the FromTable[0] is the table to join from
            if(FromTables.Count == 0)
                throw new InvalidOperationException("Can't join if there's no table to join to - make sure to use From() before InnerJoin");

            if(toTable == null)
                throw new InvalidOperationException("Can't find the table for this type. Try using the Column instead");

            var fromColumn = FromTables[0].GetColumn(fromColumnName);
            if(fromColumn == null)
                throw new InvalidOperationException("Don't know which column to join to - can't find column " + fromColumnName + " in table " + FromTables[0].Name);

            var toColumn = toTable.GetColumn(toColumnName);
            if(toColumn == null)
                throw new InvalidOperationException("Don't know which column to join to - can't find column " + toColumnName + " in table " + toTable.Name);

            CreateJoin(fromColumn, toColumn, Join.JoinType.Inner);
        }

        private void CreateJoin<T>(Join.JoinType type)
        {
            //see if we can find the table
            var toTable = _provider.FindOrCreateTable(typeof(T));

            if(toTable == null)
                throw new InvalidOperationException("Can't find the table for this type. Try using the Column instead");

            //the assumption here is that the FromTable[0] is the table to join from
            if(FromTables.Count == 0)
                throw new InvalidOperationException("Can't join if there's no table to join to - make sure to use From() before InnerJoin");

            //the "from" table is a bit tricky
            //if this is a multi-join, then we need to pull from the very last table in the Join list

            ITable fromTable = Joins.Count > 0 ? Joins[Joins.Count - 1].FromColumn.Table : FromTables[0];

            //first effort, match the name of the fromTable PK to the toTable
            var fromColumn = fromTable.PrimaryKey;

            //find the From table's PK in the other table
            var toColumn = toTable.GetColumn(fromColumn.Name);

            if(toColumn == null)
            {
                //second effort - reverse the lookup and match the PK of the toTable to the fromTable
                toColumn = toTable.PrimaryKey;
                fromColumn = fromTable.GetColumn(toColumn.Name);
            }

            if(toColumn == null)
            {
                //match the first matching pair 
                foreach(var col in fromTable.Columns)
                {
                    fromColumn = col;
                    toColumn = toTable.GetColumn(fromColumn.Name);

                    if(toColumn != null)
                        break;
                }
            }

            //still null? keep going - reverse the last search
            if(toColumn == null)
            {
                //match the first matching pair 
                foreach(var col in toTable.Columns)
                {
                    fromColumn = col;
                    toColumn = toTable.GetColumn(fromColumn.Name);

                    if(toColumn != null)
                        break;
                }
            }

            //OK - give up
            if(toColumn == null)
                throw new InvalidOperationException("Don't know which column to join to - tried to join based on Primary Key (" + fromColumn.Name + ") but couldn't find a match");

            CreateJoin(fromColumn, toColumn, type);
        }

        #endregion


        #region Inner

        /// <summary>
        /// Creates an inner join based on the passed-in column names
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="fromColumnName"></param>
        /// <param name="toColumnName"></param>
        /// <returns></returns>
        public SqlQuery InnerJoin<T>(string fromColumnName, string toColumnName)
        {
            CreateJoin<T>(fromColumnName, toColumnName, Join.JoinType.Inner);

            return this;
        }

        /// <summary>
        /// Creates an Inner Join, guessing based on Primary Key matching
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public SqlQuery InnerJoin<T>() where T : new()
        {
            //see if we can find the table
            CreateJoin<T>(Join.JoinType.Inner);
            return this;
        }

        /// <summary>
        /// Inners the join.
        /// </summary>
        /// <param name="fromColumn">From column.</param>
        /// <param name="toColumn">To column.</param>
        /// <returns></returns>
        public SqlQuery InnerJoin(IColumn fromColumn, IColumn toColumn)
        {
            CreateJoin(fromColumn, toColumn, Join.JoinType.Inner);
            return this;
        }

        #endregion


        #region Outer

        /// <summary>
        /// Outers the join.
        /// </summary>
        /// <param name="fromColumn">From column.</param>
        /// <param name="toColumn">To column.</param>
        /// <returns></returns>
        public SqlQuery OuterJoin(IColumn fromColumn, IColumn toColumn)
        {
            CreateJoin(fromColumn, toColumn, Join.JoinType.Outer);
            return this;
        }

        public SqlQuery OuterJoin<T>() where T : new()
        {
            //see if we can find the table
            CreateJoin<T>(Join.JoinType.Outer);
            return this;
        }

        public SqlQuery OuterJoin<T>(string fromColumnName, string toColumnName)
        {
            CreateJoin<T>(fromColumnName, toColumnName, Join.JoinType.Outer);

            return this;
        }

        #endregion


        #region Cross

        /// <summary>
        /// Crosses the join.
        /// </summary>
        /// <param name="fromColumn">From column.</param>
        /// <param name="toColumn">To column.</param>
        /// <returns></returns>
        public SqlQuery CrossJoin(IColumn fromColumn, IColumn toColumn)
        {
            CreateJoin(fromColumn, toColumn, Join.JoinType.Cross);
            return this;
        }

        public SqlQuery CrossJoin<T>() where T : new()
        {
            //see if we can find the table
            CreateJoin<T>(Join.JoinType.Cross);
            return this;
        }

        public SqlQuery CrossJoin<T>(string fromColumnName, string toColumnName)
        {
            CreateJoin<T>(fromColumnName, toColumnName, Join.JoinType.Cross);

            return this;
        }

        #endregion


        #region LeftInner

        /// <summary>
        /// Lefts the inner join.
        /// </summary>
        /// <param name="fromColumn">From column.</param>
        /// <param name="toColumn">To column.</param>
        /// <returns></returns>
        public SqlQuery LeftInnerJoin(IColumn fromColumn, IColumn toColumn)
        {
            CreateJoin(fromColumn, toColumn, Join.JoinType.LeftInner);
            return this;
        }

        public SqlQuery LeftInnerJoin<T>() where T : new()
        {
            //see if we can find the table
            CreateJoin<T>(Join.JoinType.LeftInner);
            return this;
        }

        public SqlQuery LeftInnerJoin<T>(string fromColumnName, string toColumnName)
        {
            CreateJoin<T>(fromColumnName, toColumnName, Join.JoinType.LeftInner);

            return this;
        }

        #endregion


        #region RightInner

        /// <summary>
        /// Rights the inner join.
        /// </summary>
        /// <param name="fromColumn">From column.</param>
        /// <param name="toColumn">To column.</param>
        /// <returns></returns>
        public SqlQuery RightInnerJoin(IColumn fromColumn, IColumn toColumn)
        {
            CreateJoin(fromColumn, toColumn, Join.JoinType.RightInner);
            return this;
        }

        public SqlQuery RightInnerJoin<T>() where T : new()
        {
            //see if we can find the table
            CreateJoin<T>(Join.JoinType.RightInner);
            return this;
        }

        public SqlQuery RightInnerJoin<T>(string fromColumnName, string toColumnName)
        {
            CreateJoin<T>(fromColumnName, toColumnName, Join.JoinType.RightInner);

            return this;
        }

        #endregion


        #region LeftOuter

        /// <summary>
        /// Lefts the outer join.
        /// </summary>
        /// <param name="fromColumn">From column.</param>
        /// <param name="toColumn">To column.</param>
        /// <returns></returns>
        public SqlQuery LeftOuterJoin(IColumn fromColumn, IColumn toColumn)
        {
            CreateJoin(fromColumn, toColumn, Join.JoinType.LeftOuter);
            return this;
        }

        public SqlQuery LeftOuterJoin<T>() where T : new()
        {
            //see if we can find the table
            CreateJoin<T>(Join.JoinType.LeftOuter);
            return this;
        }

        public SqlQuery LeftOuterJoin<T>(string fromColumnName, string toColumnName)
        {
            CreateJoin<T>(fromColumnName, toColumnName, Join.JoinType.LeftOuter);

            return this;
        }

        #endregion


        #region RightOuter

        /// <summary>
        /// Rights the outer join.
        /// </summary>
        /// <param name="fromColumn">From column.</param>
        /// <param name="toColumn">To column.</param>
        /// <returns></returns>
        public SqlQuery RightOuterJoin(IColumn fromColumn, IColumn toColumn)
        {
            CreateJoin(fromColumn, toColumn, Join.JoinType.RightOuter);
            return this;
        }

        public SqlQuery RightOuterJoin<T>() where T : new()
        {
            //see if we can find the table
            CreateJoin<T>(Join.JoinType.RightOuter);
            return this;
        }

        public SqlQuery RightOuterJoin<T>(string fromColumnName, string toColumnName)
        {
            CreateJoin<T>(fromColumnName, toColumnName, Join.JoinType.RightOuter);

            return this;
        }

        #endregion


        #region NotEqual

        /// <summary>
        /// Nots the equal join.
        /// </summary>
        /// <param name="fromColumn">From column.</param>
        /// <param name="toColumn">To column.</param>
        /// <returns></returns>
        public SqlQuery NotEqualJoin(IColumn fromColumn, IColumn toColumn)
        {
            CreateJoin(fromColumn, toColumn, Join.JoinType.NotEqual);
            return this;
        }

        public SqlQuery NotEqualJoin<T>() where T : new()
        {
            //see if we can find the table
            CreateJoin<T>(Join.JoinType.NotEqual);
            return this;
        }

        public SqlQuery NotEqualJoin<T>(string fromColumnName, string toColumnName)
        {
            CreateJoin<T>(fromColumnName, toColumnName, Join.JoinType.NotEqual);

            return this;
        }

        #endregion


        #endregion


        #region Ordering

        /// <summary>
        /// Orders the asc.
        /// </summary>
        /// <param name="columns">The columns.</param>
        /// <returns></returns>
        public SqlQuery OrderAsc(params string[] columns)
        {
            ISqlGenerator generator = GetGenerator();
            StringBuilder sb = new StringBuilder();
            bool isFirst = true;
            foreach(string s in columns)
            {
                if(!isFirst)
                    sb.Append(", ");
                sb.Append(s);
                sb.Append(generator.sqlFragment.ASC);
                isFirst = false;
            }
            OrderBys.Add(sb.ToString());
            return this;
        }

        /// <summary>
        /// Orders the desc.
        /// </summary>
        /// <param name="columns">The columns.</param>
        /// <returns></returns>
        public SqlQuery OrderDesc(params string[] columns)
        {
            ISqlGenerator generator = GetGenerator();
            StringBuilder sb = new StringBuilder();
            bool isFirst = true;
            foreach(string s in columns)
            {
                if(!isFirst)
                    sb.Append(", ");
                sb.Append(s);
                sb.Append(generator.sqlFragment.DESC);
                isFirst = false;
            }
            OrderBys.Add(sb.ToString());
            return this;
        }

        #endregion


        #region Paging

        /// <summary>
        /// Pageds the specified current page.
        /// </summary>
        /// <param name="currentPage">The current page.</param>
        /// <param name="pageSize">Size of the page.</param>
        /// <returns></returns>
        public SqlQuery Paged(int currentPage, int pageSize)
        {
            CurrentPage = currentPage;
            PageSize = pageSize;
            return this;
        }

        /// <summary>
        /// Pageds the specified current page.
        /// </summary>
        /// <param name="currentPage">The current page.</param>
        /// <param name="pageSize">Size of the page.</param>
        /// <param name="idColumn">The id column.</param>
        /// <returns></returns>
        public SqlQuery Paged(int currentPage, int pageSize, string idColumn)
        {
            CurrentPage = currentPage;
            PageSize = pageSize;
            return this;
        }

        #endregion


        #region Execution

        /// <summary>
        /// Executes this instance.
        /// </summary>
        /// <returns></returns>
        public virtual int Execute()
        {
            int result;
            try
            {
                result = _provider.ExecuteQuery(GetCommand());
            }
            catch(Exception x)
            {
                InvalidOperationException ex = GenerateException(x);
                throw ex;
            }
            return result;
        }

        /// <summary>
        /// Executes the reader.
        /// </summary>
        /// <returns></returns>
        public virtual IDataReader ExecuteReader()
        {
            IDataReader rdr;
            try
            {
                var command = GetCommand();
                rdr = _provider.ExecuteReader(command);
            }
            catch(Exception x)
            {
                InvalidOperationException ex = GenerateException(x);
                throw ex;
            }
            return rdr;
        }

        /// <summary>
        /// Executes the scalar.
        /// </summary>
        /// <returns></returns>
        public virtual object ExecuteScalar()
        {
            object result;
            try
            {
                result = _provider.ExecuteScalar(GetCommand());
            }
            catch(Exception x)
            {
                InvalidOperationException ex = GenerateException(x);
                throw ex;
            }
            return result;
        }

        /// <summary>
        /// Executes the scalar.
        /// </summary>
        /// <typeparam name="TResult">The type of the result.</typeparam>
        /// <returns></returns>
        public virtual TResult ExecuteScalar<TResult>()
        {
            TResult result = default(TResult);

            try
            {
                object queryResult = _provider.ExecuteScalar(GetCommand());

                if(queryResult != null && queryResult != DBNull.Value)
                    result = (TResult)queryResult.ChangeTypeTo<TResult>();
            }
            catch(Exception x)
            {
                InvalidOperationException ex = GenerateException(x);
                throw ex;
            }

            return result;
        }

        /// <summary>
        /// Gets the record count.
        /// </summary>
        /// <returns></returns>
        public virtual int GetRecordCount()
        {
            int count = 0;
            try
            {
                using(IDataReader rdr = ExecuteReader())
                {
                    while(rdr.Read())
                        count++;
                    rdr.Close();
                }
            }
            catch(Exception x)
            {
                InvalidOperationException ex = GenerateException(x);
                throw ex;
            }

            return count;
        }

        /// <summary>
        /// Executes the typed list.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public virtual List<T> ExecuteTypedList<T>() where T : new()
        {
            return _provider.ToList<T>(GetCommand()) as List<T>;
        }

        /// <summary>
        /// Executes the typed list.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public virtual List<T> ToList<T>() where T : new()
        {
            return _provider.ToList<T>(GetCommand()) as List<T>;
        }

        /// <summary>
        /// Executes the query and returns the result as a single item of T
        /// </summary>
        /// <typeparam name="T">The type of item to return</typeparam>
        public virtual T ExecuteSingle<T>() where T : new()
        {
            return _provider.ExecuteSingle<T>(GetCommand());
        }

        #endregion


        #region Transactions

        /// <summary>
        /// Executes the transaction.
        /// </summary>
        /// <param name="queries">The queries.</param>
        public static void ExecuteTransaction(List<SqlQuery> queries)
        {
            using(SharedDbConnectionScope scope = new SharedDbConnectionScope())
            {
                using(TransactionScope ts = new TransactionScope())
                {
                    foreach(SqlQuery q in queries)
                        q.Execute();
                }
            }
        }

        /// <summary>
        /// Executes the transaction.
        /// </summary>
        /// <param name="queries">The queries.</param>
        /// <param name="connectionStringName">Name of the connection string.</param>
        public static void ExecuteTransaction(List<SqlQuery> queries, string connectionStringName)
        {

            var provider = ProviderFactory.GetProvider(connectionStringName);
            using (SharedDbConnectionScope scope = new SharedDbConnectionScope(provider))
            {
                using(TransactionScope ts = new TransactionScope())
                {
                    foreach(SqlQuery q in queries)
                        q.Execute();
                }
            }
        }

        #endregion
    }
}