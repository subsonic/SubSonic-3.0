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
using System.Text;
using SubSonic.Query;

namespace SubSonic.SqlGeneration
{
    public class SQLiteGenerator : ANSISqlGenerator
    {
        private const string PAGING_SQL =
            @"{0}
        {1}
        LIMIT {2}, {3};";

        /// <summary>
        /// Initializes a new instance of the <see cref="MySqlGenerator"/> class.
        /// </summary>
        /// <param name="query">The query.</param>
        public SQLiteGenerator(SqlQuery query)
            : base(query) {}

        /// <summary>
        /// Builds the paged select statement.
        /// </summary>
        /// <returns></returns>
        public override string BuildPagedSelectStatement()
        {
            string select = GenerateCommandLine();
            string fromLine = GenerateFromList();
            string joins = GenerateJoins();
            string wheres = GenerateConstraints();
            string orderby = GenerateOrderBy();
            string havings = String.Empty;
            string groupby = String.Empty;

            if(query.Aggregates.Count > 0)
                groupby = GenerateGroupBy();

            string sql = string.Format(PAGING_SQL,
                String.Concat(select, fromLine, joins),
                String.Concat(wheres, groupby, havings, orderby),
                (query.CurrentPage - 1) * query.PageSize, query.PageSize);

            return sql;
        }

        /// <summary>
        /// Builds the insert statement.
        /// </summary>
        /// <returns></returns>
        public override string BuildInsertStatement()
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
            if(i.Inserts.Count > 0)
            {
                sb.Append(" VALUES (");
                bool isFirst = true;
                foreach(InsertSetting s in i.Inserts)
                {
                    if(!isFirst)
                        sb.Append(",");
                    if(!s.IsExpression)
                        sb.Append(s.ParameterName);
                    else
                        sb.Append(s.Value);
                    isFirst = false;
                }
                sb.AppendLine(")");
            }
            else
            {
                if(i.SelectValues != null)
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
            sb.AppendLine(";");

            sb.AppendFormat("SELECT last_insert_rowid();");
            return sb.ToString();
        }

        public override string BuildUpdateStatement()
        {
            StringBuilder sb = new StringBuilder();

            //cast it

            sb.Append(this.sqlFragment.UPDATE);
            sb.Append(query.FromTables[0].QualifiedName);

            for(int i = 0; i < query.SetStatements.Count; i++)
            {
                if(i == 0)
                {
                    sb.AppendLine(" ");
                    sb.Append(this.sqlFragment.SET);
                }
                else
                    sb.AppendLine(", ");

                //if (!String.IsNullOrEmpty(u.ProviderName))
                //    sb.Append(DataService.GetInstance(u.ProviderName).DelimitDbName(u.SetStatements[i].ColumnName));
                //else
                sb.AppendFormat("{0}", query.SetStatements[i].ColumnName);

                sb.Append("=");

                if(!query.SetStatements[i].IsExpression)
                    sb.Append(query.SetStatements[i].ParameterName);
                else
                    sb.Append(query.SetStatements[i].Value.ToString());
            }

            //wheres
            sb.Append(GenerateConstraints());

            return sb.ToString();
        }
    }
}