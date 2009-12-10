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
using System.Data;
using System.Linq;
using System.Text;
using SubSonic.Extensions;
using SubSonic.Query;
using SubSonic.Schema;
using Constraint = SubSonic.Query.Constraint;

namespace SubSonic.SqlGeneration
{

    /// <summary>
    /// Summary for the SqlFragment class
    /// </summary>
    public class SqlFragment
    {
        public string AND = " AND ";
        public string AS = " AS ";
        public string ASC = " ASC";
        public string BETWEEN = " BETWEEN ";
        public string CROSS_JOIN = " CROSS JOIN ";
        public string DELETE_FROM = "DELETE FROM ";
        public string DESC = " DESC";
        public string DISTINCT = "DISTINCT ";
        public string EQUAL_TO = " = ";
        public string FROM = " FROM ";
        public string GROUP_BY = " GROUP BY ";
        public string HAVING = " HAVING ";
        public string IN = " IN ";

        public string INNER_JOIN = " INNER JOIN ";

        public string INSERT_INTO = "INSERT INTO ";
        public string JOIN_PREFIX = "J";
        public string LEFT_INNER_JOIN = " LEFT INNER JOIN ";
        public string LEFT_JOIN = " LEFT JOIN ";
        public string LEFT_OUTER_JOIN = " LEFT OUTER JOIN ";
        public string NOT_EQUAL_TO = " <> ";
        public string NOT_IN = " NOT IN ";
        public string ON = " ON ";
        public string OR = " OR ";
        public string ORDER_BY = " ORDER BY ";
        public string OUTER_JOIN = " OUTER JOIN ";
        public string RIGHT_INNER_JOIN = " RIGHT INNER JOIN ";
        public string RIGHT_JOIN = " RIGHT JOIN ";
        public string RIGHT_OUTER_JOIN = " RIGHT OUTER JOIN ";
        public string SELECT = "SELECT ";
        public string SET = " SET ";
        public string SPACE = " ";
        public string TOP = "TOP ";
        public string UNEQUAL_JOIN = " JOIN ";
        public string UPDATE = "UPDATE ";
        public string WHERE = " WHERE ";

        public SqlFragment(DataProviders.IDataProvider provider)
        {
            switch (provider.Client)
            {
                case SubSonic.DataProviders.DataClient.SqlClient:
                    this.LEFT_INNER_JOIN = this.LEFT_JOIN;  //MSSQL Doesn't like standard left join syntax.
                    this.RIGHT_INNER_JOIN = this.RIGHT_JOIN;
                    break;
            }
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public class ANSISqlGenerator : ISqlGenerator
    {
        private const string PAGING_SQL =
            @"					
					DECLARE @Page int
					DECLARE @PageSize int

					SET @Page = {4}
					SET @PageSize = {5}

					SET NOCOUNT ON

					-- create a temp table to hold order ids
					DECLARE @TempTable TABLE (IndexId int identity, _keyID {6})

					-- insert the table ids and row numbers into the memory table
					INSERT INTO @TempTable
					(
					  _keyID
					)
					SELECT 
						{0}
					    {1}
                        {2}
					-- select only those rows belonging to the proper page
					    {3}
					INNER JOIN @TempTable t ON {0} = t._keyID
					WHERE t.IndexId BETWEEN ((@Page - 1) * @PageSize + 1) AND (@Page * @PageSize)
                    
                    ";

        internal Insert insert;
        internal SqlQuery query;
        public SqlFragment sqlFragment { get; private set; }

        /// <summary>
        /// Initializes a new instance of the <see cref="ANSISqlGenerator"/> class.
        /// </summary>
        /// <param name="q">The q.</param>
        public ANSISqlGenerator(SqlQuery q)
        {
            this.sqlFragment = new SqlFragment(q._provider);
            query = q;
        }


        #region ISqlGenerator Members

        /// <summary>
        /// Sets the insert query.
        /// </summary>
        /// <param name="q">The q.</param>
        public void SetInsertQuery(Insert q)
        {
            insert = q;
        }

        /// <summary>
        /// Finds the column.
        /// </summary>
        /// <param name="columnName">Name of the column.</param>
        /// <returns></returns>
        public IColumn FindColumn(string columnName)
        {
            IColumn result = null;
            foreach (ITable t in query.FromTables)
            {
                result = t.GetColumn(columnName);
                if (result != null)
                    return result;
            }
            return result;
        }

        /// <summary>
        /// Generates the group by.
        /// </summary>
        /// <returns></returns>
        public virtual string GenerateGroupBy()
        {
            string result = String.Empty;

            if (query.Aggregates.Count > 0)
            {
                StringBuilder sb = new StringBuilder();
                sb.AppendLine();

                bool isFirst = true;
                foreach (SubSonic.Query.Aggregate agg in query.Aggregates)
                {
                    if (agg.AggregateType == AggregateFunction.GroupBy)
                    {
                        if (!isFirst)
                            sb.Append(", ");
                        else
                            sb.Append(this.sqlFragment.GROUP_BY);

                        sb.Append(string.Format("[{0}]", agg.ColumnName));
                        isFirst = false;
                    }
                }
            }

            return result;
        }

        /// <summary>
        /// Generates the command line.
        /// </summary>
        /// <returns></returns>
        public virtual string GenerateCommandLine()
        {
            StringBuilder sb = new StringBuilder();

            //start with the SqlCommand - SELECT, UPDATE, INSERT, DELETE
            sb.Append(query.SQLCommand);
            string columnList;
            if (query.Aggregates.Count > 0)
                columnList = BuildAggregateCommands();
            else
            {
                //set "TOP"
                sb.Append(query.TopSpec);

                //decide the columns
                if (query.SelectColumnList.Length == 0)
                    columnList = GenerateSelectColumnList();
                else
                {
                    StringBuilder sbCols = new StringBuilder();
                    //loop each column - 
                    //there n tables in the select list
                    //need to get the schema
                    //so for each column, loop the FromList until we find the column
                    bool isFirst = true;
                    foreach (string s in query.SelectColumnList)
                    {
                        if (!isFirst)
                            sbCols.Append(", ");
                        isFirst = false;
                        //find the column
                        IColumn c = FindColumn(s);

                        if (c != null)
                            sbCols.Append(c.QualifiedName);
                        else
                        {
                            //just append it in - allowing for function calls
                            //or literals in the command line
                            sbCols.Append(s);
                        }
                    }
                    columnList = sbCols.ToString();
                }
            }
            sb.Append(columnList);

            if (query.Expressions.Count > 0)
            {
                //add in expression                
                foreach (string s in query.Expressions)
                {
                    sb.Append(", ");
                    sb.Append(s);
                }
            }

            return sb.ToString();
        }

        /// <summary>
        /// Generates the joins.
        /// </summary>
        /// <returns></returns>
        public virtual string GenerateJoins()
        {
            StringBuilder sb = new StringBuilder();

            if (query.Joins.Count > 0)
            {
                sb.AppendLine();
                //build up the joins
                foreach (Join j in query.Joins)
                {
                    string joinType = Join.GetJoinTypeValue(this, j.Type);
                    string equality = " = ";
                    if (j.Type == Join.JoinType.NotEqual)
                        equality = " <> ";

                    sb.Append(joinType);
                    sb.Append(j.FromColumn.Table.QualifiedName);
                    if (j.Type != Join.JoinType.Cross)
                    {
                        sb.Append(" ON ");
                        sb.Append(j.ToColumn.QualifiedName);
                        sb.Append(equality);
                        sb.Append(j.FromColumn.QualifiedName);
                    }
                }
            }
            return sb.ToString();
        }

        /// <summary>
        /// Generates from list.
        /// </summary>
        /// <returns></returns>
        public virtual string GenerateFromList()
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendLine();
            sb.Append(this.sqlFragment.FROM);

            bool isFirst = true;
            foreach (ITable tbl in query.FromTables)
            {
                // EK: The line below is intentional. See: http://weblogs.asp.net/fbouma/archive/2009/06/25/linq-beware-of-the-access-to-modified-closure-demon.aspx
                ITable table = tbl;

                //Can't pop a table into the FROM list if it's also in a JOIN
                if (!query.Joins.Any(x => x.FromColumn.Table.Name.Equals(table.Name, StringComparison.InvariantCultureIgnoreCase)))
                {
                    if (!isFirst)
                        sb.Append(", ");
                    sb.Append(tbl.QualifiedName);
                    isFirst = false;
                }
            }
            return sb.ToString();
        }

        /// <summary>
        /// Generates the constraints.
        /// </summary>
        /// <returns></returns>
        public virtual string GenerateConstraints()
        {
            string whereOperator = this.sqlFragment.WHERE;

            if (query.Aggregates.Count > 0 && query.Aggregates.Any(x => x.AggregateType == AggregateFunction.GroupBy))
                whereOperator = this.sqlFragment.HAVING;

            StringBuilder sb = new StringBuilder();
            sb.AppendLine();
            bool isFirst = true;

            //int paramCount;
            bool expressionIsOpen = false;
            int indexer = 0;
            foreach (Constraint c in query.Constraints)
            {
                string columnName = String.Empty;
                bool foundColumn = false;
                if (c.ConstructionFragment == c.ColumnName && c.ConstructionFragment != "##")
                {
                    IColumn col = FindColumn(c.ColumnName);

                    if (col != null)
                    {
                        columnName = col.QualifiedName;
                        c.ParameterName = string.Format("{0}{1}", GetParameterPrefix(), indexer);
                        c.DbType = col.DataType;
                        foundColumn = true;
                    }
                }

                if (!foundColumn && c.ConstructionFragment != "##")
                {
                    bool isAggregate = false;
                    //this could be an expression
                    //string rawColumnName = c.ConstructionFragment;
                    if (c.ConstructionFragment.StartsWith("("))
                    {
                        //rawColumnName = c.ConstructionFragment.Replace("(", String.Empty);
                        expressionIsOpen = true;
                    }
                    //this could be an aggregate function
                    else if (c.IsAggregate ||
                            (c.ConstructionFragment.Contains("(") && c.ConstructionFragment.Contains(")")))
                    {
                        //rawColumnName = c.ConstructionFragment.Replace("(", String.Empty).Replace(")", String.Empty);
                        isAggregate = true;
                    }

                    IColumn col = FindColumn(c.ColumnName);
                    if (!isAggregate && col != null)
                    {
                        columnName = c.ConstructionFragment.FastReplace(col.Name, col.QualifiedName);
                        c.ParameterName = String.Concat(col.ParameterName, indexer.ToString());
                        c.DbType = col.DataType;
                    }
                    else
                    {
                        c.ParameterName = query.FromTables[0].Provider.ParameterPrefix + indexer;
                        columnName = c.ConstructionFragment;
                    }
                }

                //paramCount++;

                if (!isFirst)
                {
                    whereOperator = Enum.GetName(typeof(ConstraintType), c.Condition);
                    whereOperator = String.Concat(" ", whereOperator.ToUpper(), " ");
                }

                if (c.Comparison != Comparison.OpenParentheses && c.Comparison != Comparison.CloseParentheses)
                    sb.Append(whereOperator);

                if (c.Comparison == Comparison.BetweenAnd)
                {
                    sb.Append(columnName);
                    sb.Append(this.sqlFragment.BETWEEN);
                    sb.Append(c.ParameterName + "_start");
                    sb.Append(this.sqlFragment.AND);
                    sb.Append(c.ParameterName + "_end");
                }
                else if (c.Comparison == Comparison.In || c.Comparison == Comparison.NotIn)
                {
                    sb.Append(columnName);
                    if (c.Comparison == Comparison.In)
                        sb.Append(this.sqlFragment.IN);
                    else
                        sb.Append(this.sqlFragment.NOT_IN);

                    sb.Append("(");

                    if (c.InSelect != null)
                    {
                        //create a sql statement from the passed-in select
                        string sql = c.InSelect.BuildSqlStatement();
                        sb.Append(sql);
                    }
                    else
                    {
                        //enumerate INs
                        IEnumerator en = c.InValues.GetEnumerator();
                        StringBuilder sbIn = new StringBuilder();
                        bool first = true;
                        int i = 1;
                        while (en.MoveNext())
                        {
                            if (!first)
                                sbIn.Append(",");
                            else
                                first = false;

                            sbIn.Append(String.Concat(c.ParameterName, "In", i));
                            i++;
                        }

                        string inList = sbIn.ToString();
                        //inList = Sugar.Strings.Chop(inList);
                        sb.Append(inList);
                    }

                    sb.Append(")");
                }
                else if (c.Comparison == Comparison.OpenParentheses)
                {
                    expressionIsOpen = true;
                    sb.Append("(");
                }
                else if (c.Comparison == Comparison.CloseParentheses)
                {
                    expressionIsOpen = false;
                    sb.Append(")");
                }
                else
                {
                    if (columnName.StartsWith("("))
                        expressionIsOpen = true;
                    if (c.ConstructionFragment != "##")
                    {
                        sb.Append(columnName);
                        sb.Append(Constraint.GetComparisonOperator(c.Comparison));
                        if (c.Comparison == Comparison.Is || c.Comparison == Comparison.IsNot)
                        {
                            if (c.ParameterValue == null || c.ParameterValue == DBNull.Value)
                                sb.Append("NULL");
                        }
                        else
                            sb.Append(c.ParameterName);
                    }
                }
                indexer++;

                isFirst = false;
            }

            string result = sb.ToString();
            //a little help...
            if (expressionIsOpen & !result.EndsWith(")"))
                result = String.Concat(result, ")");

            return result;
        }

        /// <summary>
        /// Generates the order by.
        /// </summary>
        /// <returns></returns>
        public virtual string GenerateOrderBy()
        {
            StringBuilder sb = new StringBuilder();
            if (query.OrderBys.Count > 0)
            {
                sb.AppendLine();
                sb.Append(this.sqlFragment.ORDER_BY);
                bool isFirst = true;
                foreach (string s in query.OrderBys)
                {
                    if (!isFirst)
                        sb.Append(", ");
                    sb.Append(s);
                    isFirst = false;
                }
            }
            return sb.ToString();
        }

        /// <summary>
        /// Gets the select columns.
        /// </summary>
        /// <returns></returns>
        public virtual List<string> GetSelectColumns()
        {
            List<string> result = new List<string>();
            string columns;

            if (query.SelectColumnList.Length == 0)
            {
                columns = GenerateSelectColumnList();
                string[] columnList = columns.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                foreach (string s in columnList)
                    result.Add(s);
            }
            else
            {
                foreach (string s in query.SelectColumnList)
                    result.Add(s);
            }

            return result;
        }

        /// <summary>
        /// Gets the paging SQL wrapper.
        /// </summary>
        /// <returns></returns>
        public virtual string GetPagingSqlWrapper()
        {
            return PAGING_SQL;
        }

        /// <summary>
        /// Builds the paged select statement.
        /// </summary>
        /// <returns></returns>
        public virtual string BuildPagedSelectStatement()
        {
            string idColumn = GetSelectColumns()[0];
            string sqlType;

            IColumn idCol = FindColumn(idColumn);
            if (idCol != null)
            {
                string pkType = String.Empty;
                if (idCol.IsString)
                    pkType = String.Concat("(", idCol.MaxLength, ")");
                sqlType = Enum.GetName(typeof(SqlDbType), idCol.DataType.GetSqlDBType());
                sqlType = String.Concat(sqlType, pkType);
            }
            else
            {
                //assume it's an integer
                sqlType = Enum.GetName(typeof(SqlDbType), SqlDbType.Int);
            }

            string select = GenerateCommandLine();
            //string columnList = select.Replace("SELECT", "");
            string fromLine = GenerateFromList();
            string joins = GenerateJoins();
            string wheres = GenerateConstraints();

            //have to doctor the wheres, since we're using a WHERE in the paging
            //bits. So change all "WHERE" to "AND"
            string tweakedWheres = wheres.Replace("WHERE", "AND");
            string orderby = GenerateOrderBy();

            if (query.Aggregates.Count > 0)
                joins = String.Concat(joins, GenerateGroupBy());

            //this uses SQL2000-compliant paging
            //the arguments are...
            //1 - id column - this is the PK or identifier
            //2 - from/join/where
            //3 - select/from/joins
            //4 - where/order by
            //5 - page index
            //6 - page size
            //7 - PK Type (using Utility.GetSqlDBType)

            string sql = string.Format(PAGING_SQL, idColumn, String.Concat(fromLine, joins, wheres),
                String.Concat(select, fromLine, joins), String.Concat(tweakedWheres, orderby),
                query.CurrentPage, query.PageSize, sqlType);

            return sql;
        }

        /// <summary>
        /// Builds the select statement.
        /// </summary>
        /// <returns></returns>
        public virtual string BuildSelectStatement()
        {
            StringBuilder sql = new StringBuilder();

            if (query.PageSize > 0)
                sql.Append(BuildPagedSelectStatement());
            else
            {
                //build the command string
                sql.Append(GenerateCommandLine());
                sql.Append(GenerateFromList());
                sql.Append(GenerateJoins());
                sql.Append(GenerateGroupBy());
                sql.Append(GenerateConstraints());
                sql.Append(GenerateOrderBy());
            }
            //return
            return sql.ToString();
        }

        /// <summary>
        /// Builds the update statement.
        /// </summary>
        /// <returns></returns>
        public virtual string BuildUpdateStatement()
        {
            StringBuilder sb = new StringBuilder();

            //cast it

            sb.Append(this.sqlFragment.UPDATE);
            sb.Append(query.FromTables[0].QualifiedName);

            for (int i = 0; i < query.SetStatements.Count; i++)
            {
                if (i == 0)
                {
                    sb.AppendLine(" ");
                    sb.Append(this.sqlFragment.SET);
                }
                else
                    sb.AppendLine(", ");

                //if (!String.IsNullOrEmpty(u.ProviderName))
                //    sb.Append(DataService.GetInstance(u.ProviderName).DelimitDbName(u.SetStatements[i].ColumnName));
                //else
                sb.Append(query.SetStatements[i].ColumnName);

                sb.Append("=");

                if (!query.SetStatements[i].IsExpression)
                    sb.Append(query.SetStatements[i].ParameterName);
                else
                    sb.Append(query.SetStatements[i].Value.ToString());
            }

            //wheres
            sb.Append(GenerateConstraints());

            return sb.ToString();
        }

        /// <summary>
        /// Builds the insert statement.
        /// </summary>
        /// <returns></returns>
        public virtual string BuildInsertStatement()
        {
            StringBuilder sb = new StringBuilder();

            //cast it
            Insert i = insert;
            sb.Append(this.sqlFragment.INSERT_INTO);
            sb.Append(i.Table.QualifiedName);
            sb.Append("(");
            sb.Append(i.SelectColumns);
            sb.AppendLine(")");

            //if the values list is set, use that
            if (i.Inserts.Count > 0)
            {
                sb.Append(" VALUES (");
                bool isFirst = true;
                foreach (InsertSetting s in i.Inserts)
                {
                    if (!isFirst)
                        sb.Append(",");
                    if (!s.IsExpression)
                        sb.Append(s.ParameterName);
                    else
                        sb.Append(s.Value);
                    isFirst = false;
                }
                sb.AppendLine(")");
            }
            else
            {
                if (i.SelectValues != null)
                {
                    string selectSql = i.SelectValues.BuildSqlStatement();
                    sb.AppendLine(selectSql);
                }
                else
                {
                    throw new InvalidOperationException(
                        "Need to specify Values or a Select query to insert - can't go on!");
                }
            }
            return sb.ToString();
        }

        /// <summary>
        /// Builds the delete statement.
        /// </summary>
        /// <returns></returns>
        public virtual string BuildDeleteStatement()
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(this.sqlFragment.DELETE_FROM);
            sb.Append(query.FromTables[0].QualifiedName);

            sb.Append(GenerateConstraints());

            return sb.ToString();
        }

        #endregion


        /// <summary>
        /// Qualifies the name of the table.
        /// </summary>
        /// <param name="tbl">The TBL.</param>
        /// <returns></returns>
        public virtual string QualifyTableName(ITable tbl)
        {
            return tbl.QualifiedName;
        }

        public virtual string GetParameterPrefix()
        {
            return "@";
        }

        /// <summary>
        /// Gets the qualified select.
        /// </summary>
        /// <param name="table">The table.</param>
        /// <returns></returns>
        public string GetQualifiedSelect(ITable table)
        {
            StringBuilder sb = new StringBuilder();
            bool isFirst = true;
            foreach (IColumn tc in table.Columns)
            {
                if (!isFirst)
                    sb.Append(", ");

                sb.Append(tc.QualifiedName);
                isFirst = false;
            }

            return sb.ToString();
        }

        /// <summary>
        /// Generates the select column list.
        /// </summary>
        /// <returns></returns>
        public virtual string GenerateSelectColumnList()
        {
            StringBuilder sbColumns = new StringBuilder();
            int loopCount = 1;

            foreach (ITable tbl in query.FromTables)
            {
                if (tbl.Columns.Count > 0)
                {
                    string columnList = GetQualifiedSelect(tbl);
                    sbColumns.Append(columnList);

                    if (loopCount < query.FromTables.Count)
                        sbColumns.AppendLine(", ");

                    loopCount++;
                }
                else
                {
                    sbColumns.Append("*");
                    break;
                }
            }
            return sbColumns.ToString();
        }

        /// <summary>
        /// Builds the aggregate commands.
        /// </summary>
        /// <returns></returns>
        protected virtual string BuildAggregateCommands()
        {
            StringBuilder sb = new StringBuilder();
            bool isFirst = true;
            foreach (SubSonic.Query.Aggregate agg in query.Aggregates)
            {
                if (!isFirst)
                    sb.Append(", ");
                sb.Append(GenerateAggregateSelect(agg));
                isFirst = false;
            }
            return sb.ToString();
        }

        /// <summary>
        /// Generates the 'SELECT' part of an <see cref="SubSonic.Query.Aggregate"/>
        /// </summary>
        /// <param name="aggregate">The aggregate to include in the SELECT clause</param>
        /// <returns>The portion of the SELECT clause represented by this <see cref="SubSonic.Query.Aggregate"/></returns>
        /// <remarks>
        /// The ToString() logic moved from <see cref="SubSonic.Query.Aggregate.ToString"/>, rather than
        /// including it in the Aggregate class itself...
        /// </remarks>
        protected virtual string GenerateAggregateSelect(SubSonic.Query.Aggregate aggregate)
        {
            bool hasAlias = !String.IsNullOrEmpty(aggregate.Alias);

            if (aggregate.AggregateType == AggregateFunction.GroupBy && hasAlias)
                return String.Format("{0} AS {1}", aggregate.ColumnName, aggregate.Alias);
            if (aggregate.AggregateType == AggregateFunction.GroupBy)
                return string.Format("{0}", aggregate.ColumnName);
            if (hasAlias)
            {
                return String.Format("{0}({1}) AS {2}", SubSonic.Query.Aggregate.GetFunctionType(aggregate).ToUpper(),
                    aggregate.ColumnName, aggregate.Alias);
            }

            return String.Format("{0}({1})", SubSonic.Query.Aggregate.GetFunctionType(aggregate).ToUpper(), aggregate.ColumnName);
        }
    }
}