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
using System.Data;
using System.Text;
using SubSonic.Extensions;
using SubSonic.Query;
using SubSonic.Schema;

namespace SubSonic.SqlGeneration
{
    /// <summary>
    /// 
    /// </summary>
    public class MySqlGenerator : ANSISqlGenerator
    {
        private const string PAGING_SQL =
            @"{0}
        {1}
        LIMIT {2}, {3};";

        /// <summary>
        /// Initializes a new instance of the <see cref="MySqlGenerator"/> class.
        /// </summary>
        /// <param name="query">The query.</param>
        public MySqlGenerator(SqlQuery query)
            : base(query) {}

        /// <summary>
        /// Gets the type of the native.
        /// </summary>
        /// <param name="dbType">Type of the db.</param>
        /// <returns></returns>
        protected string GetNativeType(DbType dbType)
        {
            switch(dbType)
            {
                case DbType.Object:
                case DbType.AnsiString:
                case DbType.AnsiStringFixedLength:
                case DbType.String:
                case DbType.StringFixedLength:
                    return "nvarchar";
                case DbType.Boolean:
                    return "bit";
                case DbType.SByte:
                case DbType.Binary:
                case DbType.Byte:
                    return "image";
                case DbType.Currency:
                    return "money";
                case DbType.Time:
                case DbType.Date:
                case DbType.DateTime:
                    return "datetime";
                case DbType.Decimal:
                    return "decimal";
                case DbType.Double:
                    return "float";
                case DbType.Guid:
                    return "uniqueidentifier";
                case DbType.UInt32:
                case DbType.UInt16:
                case DbType.Int16:
                case DbType.Int32:
                    return "INTEGER";
                case DbType.UInt64:
                case DbType.Int64:
                    return "bigint";
                case DbType.Single:
                    return "real";
                case DbType.VarNumeric:
                    return "numeric";
                case DbType.Xml:
                    return "xml";
                default:
                    return "nvarchar";
            }
        }

        /// <summary>
        /// Generates SQL for all the columns in table
        /// </summary>
        /// <param name="table">Table containing the columns.</param>
        /// <returns>
        /// SQL fragment representing the supplied columns.
        /// </returns>
        protected string GenerateColumns(ITable table)
        {
            if(table.Columns.Count == 0)
                return String.Empty;

            StringBuilder columnsSql = new StringBuilder();

            foreach(IColumn col in table.Columns)
                columnsSql.AppendFormat("\r\n  `{0}`{1},", col.Name, GenerateColumnAttributes(col));

            if(table.HasPrimaryKey)
                columnsSql.AppendFormat("\r\n  PRIMARY KEY (`{0}`),", table.PrimaryKey.Name);

            string sql = columnsSql.ToString();
            return sql.Chop(",");
        }

        /// <summary>
        /// Generates from list.
        /// </summary>
        /// <returns></returns>
        public override string GenerateFromList()
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(this.sqlFragment.FROM);

            bool isFirst = true;
            foreach(ITable tbl in query.FromTables)
            {
                if(!isFirst)
                    sb.Append(",");
                sb.Append(tbl.Name);
                isFirst = false;
            }
            sb.Append(Environment.NewLine);
            return sb.ToString();
        }

        /// <summary>
        /// Sets the column attributes.
        /// </summary>
        /// <param name="column">The column.</param>
        /// <returns></returns>
        protected string GenerateColumnAttributes(IColumn column)
        {
            StringBuilder sb = new StringBuilder();
            if(column.DataType == DbType.DateTime && column.DefaultSetting.ToString() == "getdate()")
            {
                //there is no way to have two fields with a NOW or CURRENT_TIMESTAMP setting
                //so need to rely on the code to help here
                sb.Append(" datetime ");
            }
            else
            {
                sb.Append(" " + GetNativeType(column.DataType));

                if(column.IsPrimaryKey)
                {
                    sb.Append(" NOT NULL");
                    if(column.IsNumeric)
                        sb.Append(" AUTO_INCREMENT");
                }
                else
                {
                    if(column.MaxLength > 0 && column.MaxLength < 8000)
                        sb.Append("(" + column.MaxLength + ")");

                    if(!column.IsNullable)
                        sb.Append(" NOT NULL");
                    else
                        sb.Append(" NULL");

                    if(column.DefaultSetting != null)
                        sb.Append(" DEFAULT " + column.DefaultSetting + " ");
                }
            }
            return sb.ToString();
        }

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

        protected override string GenerateAggregateSelect(Aggregate aggregate)
        {
            bool hasAlias = !String.IsNullOrEmpty(aggregate.Alias);

            if(aggregate.AggregateType == AggregateFunction.GroupBy && hasAlias)
                return String.Format("`{0}` AS `{1}`", aggregate.ColumnName, aggregate.Alias);
            if(aggregate.AggregateType == AggregateFunction.GroupBy)
                return string.Format("`{0}`", aggregate.ColumnName);
            if(hasAlias)
            {
                return String.Format("{0}(`{1}`) AS `{2}`", Aggregate.GetFunctionType(aggregate).ToUpper(),
                    aggregate.ColumnName, aggregate.Alias);
            }

            return String.Format("{0}(`{1}`)", Aggregate.GetFunctionType(aggregate).ToUpper(), aggregate.ColumnName);
        }

        public override string GenerateGroupBy()
        {
            string result = String.Empty;

            if(query.Aggregates.Count > 0)
            {
                StringBuilder sb = new StringBuilder();
                sb.AppendLine();

                bool isFirst = true;
                foreach(Aggregate agg in query.Aggregates)
                {
                    if(agg.AggregateType == AggregateFunction.GroupBy)
                    {
                        if(!isFirst)
                            sb.Append(", ");
                        else
                            sb.Append(this.sqlFragment.GROUP_BY);

                        sb.Append(string.Format("`{0}`", agg.ColumnName));
                        isFirst = false;
                    }
                }
            }

            return result;
        }

        public override string BuildInsertStatement()
        {
            string result = base.BuildInsertStatement();

            return result + ";SELECT LAST_INSERT_ID() as newid;";
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