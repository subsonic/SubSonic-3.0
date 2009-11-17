#region

using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using SubSonic.Extensions;
using SubSonic.Linq.Structure;

#endregion

namespace SubSonic.Linq.Translation.MySql
{
    /// <summary>
    /// Formats a query expression into TSQL language syntax
    /// </summary>
    public class MySqlFormatter : TSqlFormatter
    {


        protected override Expression VisitMemberAccess(MemberExpression m) {
            if (m.Member.DeclaringType == typeof(string)) {
                switch (m.Member.Name) {
                    case "Length":
                        sb.Append("CHAR_LENGTH(");
                        this.Visit(m.Expression);
                        sb.Append(")");
                        return m;
                }
            } else if (m.Member.DeclaringType == typeof(DateTime) || m.Member.DeclaringType == typeof(DateTimeOffset)) {
                switch (m.Member.Name) {
                    case "Day":
                        sb.Append("DAY(");
                        this.Visit(m.Expression);
                        sb.Append(")");
                        return m;
                    case "Month":
                        sb.Append("MONTH(");
                        this.Visit(m.Expression);
                        sb.Append(")");
                        return m;
                    case "Year":
                        sb.Append("YEAR(");
                        this.Visit(m.Expression);
                        sb.Append(")");
                        return m;
                    case "Hour":
                        sb.Append("HOUR( ");
                        this.Visit(m.Expression);
                        sb.Append(")");
                        return m;
                    case "Minute":
                        sb.Append("MINUTE( ");
                        this.Visit(m.Expression);
                        sb.Append(")");
                        return m;
                    case "Second":
                        sb.Append("SECOND( ");
                        this.Visit(m.Expression);
                        sb.Append(")");
                        return m;
                    case "Millisecond":
                        sb.Append("MICROSECOND( ");
                        this.Visit(m.Expression);
                        sb.Append(")");
                        return m;
                    case "DayOfWeek":
                        sb.Append("(DAYOFWEEK(");
                        this.Visit(m.Expression);
                        sb.Append(") - 1)");
                        return m;
                    case "DayOfYear":
                        sb.Append("(DAYOFYEAR( ");
                        this.Visit(m.Expression);
                        sb.Append(") - 1)");
                        return m;
                }
            }
            throw new NotSupportedException(string.Format("The member '{0}' is not supported", m.Member.Name));
        }

        protected override Expression VisitMethodCall(MethodCallExpression m) {
            if (m.Method.DeclaringType == typeof(string)) {
                switch (m.Method.Name) {
                    case "StartsWith":
                        sb.Append("(");
                        this.Visit(m.Object);
                        sb.Append(" LIKE CONCAT(");
                        this.Visit(m.Arguments[0]);
                        sb.Append(",'%'))");
                        return m;
                    case "EndsWith":
                        sb.Append("(");
                        this.Visit(m.Object);
                        sb.Append(" LIKE CONCAT('%',");
                        this.Visit(m.Arguments[0]);
                        sb.Append("))");
                        return m;
                    case "Contains":
                        sb.Append("(");
                        this.Visit(m.Object);
                        sb.Append(" LIKE CONCAT('%',");
                        this.Visit(m.Arguments[0]);
                        sb.Append(",'%'))");
                        return m;
                    case "Concat":
                        IList<Expression> args = m.Arguments;
                        if (args.Count == 1 && args[0].NodeType == ExpressionType.NewArrayInit) {
                            args = ((NewArrayExpression)args[0]).Expressions;
                        }
                        for (int i = 0, n = args.Count; i < n; i++) {
                            if (i > 0) sb.Append(" + ");
                            this.Visit(args[i]);
                        }
                        return m;
                    case "IsNullOrEmpty":
                        sb.Append("(");
                        this.Visit(m.Arguments[0]);
                        sb.Append(" IS NULL OR ");
                        this.Visit(m.Arguments[0]);
                        sb.Append(" = '')");
                        return m;
                    case "ToUpper":
                        sb.Append("UPPER(");
                        this.Visit(m.Object);
                        sb.Append(")");
                        return m;
                    case "ToLower":
                        sb.Append("LOWER(");
                        this.Visit(m.Object);
                        sb.Append(")");
                        return m;
                    case "Replace":
                        sb.Append("REPLACE(");
                        this.Visit(m.Object);
                        sb.Append(", ");
                        this.Visit(m.Arguments[0]);
                        sb.Append(", ");
                        this.Visit(m.Arguments[1]);
                        sb.Append(")");
                        return m;
                    case "Substring":
                        sb.Append("SUBSTRING(");
                        this.Visit(m.Object);
                        sb.Append(", ");
                        this.Visit(m.Arguments[0]);
                        sb.Append(" + 1, ");
                        if (m.Arguments.Count == 2) {
                            this.Visit(m.Arguments[1]);
                        } else {
                            sb.Append("8000");
                        }
                        sb.Append(")");
                        return m;
                    case "Remove":
                        sb.Append("STUFF(");
                        this.Visit(m.Object);
                        sb.Append(", ");
                        this.Visit(m.Arguments[0]);
                        sb.Append(" + 1, ");
                        if (m.Arguments.Count == 2) {
                            this.Visit(m.Arguments[1]);
                        } else {
                            sb.Append("8000");
                        }
                        sb.Append(", '')");
                        return m;
                    case "IndexOf":
                        sb.Append("(LOCATE(");
                        this.Visit(m.Arguments[0]);
                        sb.Append(", ");
                        this.Visit(m.Object);
                        if (m.Arguments.Count == 2 && m.Arguments[1].Type == typeof(int)) {
                            sb.Append(", ");
                            this.Visit(m.Arguments[1]);
                        }
                        sb.Append(") - 1)");
                        return m;
                    case "Trim":
                        sb.Append("RTRIM(LTRIM(");
                        this.Visit(m.Object);
                        sb.Append("))");
                        return m;
                }
            } else if (m.Method.DeclaringType == typeof(DateTime)) {
                switch (m.Method.Name) {
                    case "op_Subtract":
                        if (m.Arguments[1].Type == typeof(DateTime)) {
                            sb.Append("DATEDIFF(");
                            this.Visit(m.Arguments[0]);
                            sb.Append(", ");
                            this.Visit(m.Arguments[1]);
                            sb.Append(")");
                            return m;
                        }
                        break;
                }
            } else if (m.Method.DeclaringType == typeof(Decimal)) {
                switch (m.Method.Name) {
                    case "Add":
                    case "Subtract":
                    case "Multiply":
                    case "Divide":
                    case "Remainder":
                        sb.Append("(");
                        this.VisitValue(m.Arguments[0]);
                        sb.Append(" ");
                        sb.Append(GetOperator(m.Method.Name));
                        sb.Append(" ");
                        this.VisitValue(m.Arguments[1]);
                        sb.Append(")");
                        return m;
                    case "Negate":
                        sb.Append("-");
                        this.Visit(m.Arguments[0]);
                        sb.Append("");
                        return m;
                    case "Ceiling":
                    case "Floor":
                        sb.Append(m.Method.Name.ToUpper());
                        sb.Append("(");
                        this.Visit(m.Arguments[0]);
                        sb.Append(")");
                        return m;
                    case "Round":
                        //if (m.Arguments.Count == 1) {
                            sb.Append("ROUND(");
                            this.Visit(m.Arguments[0]);
                            sb.Append(", 0)");
                            return m;
                        //} else if (m.Arguments.Count == 2 && m.Arguments[1].Type == typeof(int)) {
                            //sb.Append("ROUND(");
                            //this.Visit(m.Arguments[0]);
                            //sb.Append(", ");
                            //this.Visit(m.Arguments[1]);
                            //sb.Append(")");
                            //return m;
                        //}
                    case "Truncate":
                        sb.Append("ROUND(");
                        this.Visit(m.Arguments[0]);
                        sb.Append(", 0)");
                        return m;
                }
            } else if (m.Method.DeclaringType == typeof(Math)) {
                switch (m.Method.Name) {
                    case "Abs":
                    case "Acos":
                    case "Asin":
                    case "Atan":
                    case "Cos":
                    case "Exp":
                    case "Log10":
                    case "Sin":
                    case "Tan":
                    case "Sqrt":
                    case "Sign":
                    case "Ceiling":
                    case "Floor":
                        sb.Append(m.Method.Name.ToUpper());
                        sb.Append("(");
                        this.Visit(m.Arguments[0]);
                        sb.Append(")");
                        return m;
                    case "Atan2":
                        sb.Append("ATAN2(");
                        this.Visit(m.Arguments[0]);
                        sb.Append(", ");
                        this.Visit(m.Arguments[1]);
                        sb.Append(")");
                        return m;
                    case "Log":
                        if (m.Arguments.Count == 1) {
                            goto case "Log10";
                        }
                        break;
                    case "Pow":
                        sb.Append("POWER(");
                        this.Visit(m.Arguments[0]);
                        sb.Append(", ");
                        this.Visit(m.Arguments[1]);
                        sb.Append(")");
                        return m;
                    case "Round":
                        //if (m.Arguments.Count == 1) {
                            sb.Append("ROUND(");
                            this.Visit(m.Arguments[0]);
                            sb.Append(", 0)");
                            return m;
                        //} else if (m.Arguments.Count == 2 && m.Arguments[1].Type == typeof(int)) {
                            //sb.Append("ROUND(");
                            //this.Visit(m.Arguments[0]);
                            //sb.Append(", ");
                            //this.Visit(m.Arguments[1]);
                            //sb.Append(")");
                            //return m;
                        //}
                        //break;
                    case "Truncate":
                        sb.Append("ROUND(");
                        this.Visit(m.Arguments[0]);
                        sb.Append(", 0)");
                        return m;
                }
            }
            if (m.Method.Name == "ToString") {
                if (m.Object.Type == typeof(string)) {
                    this.Visit(m.Object);  // no op
                } else {
                    sb.Append("CONVERT(, ");
                    this.Visit(m.Object);
                    sb.Append(", VARCHAR(200))");
                }
                return m;
            } else if (m.Method.Name == "Equals") {
                if (m.Method.IsStatic && m.Method.DeclaringType == typeof(object)) {
                    sb.Append("(");
                    this.Visit(m.Arguments[0]);
                    sb.Append(" = ");
                    this.Visit(m.Arguments[1]);
                    sb.Append(")");
                    return m;
                } else if (!m.Method.IsStatic && m.Arguments.Count == 1 && m.Arguments[0].Type == m.Object.Type) {
                    sb.Append("(");
                    this.Visit(m.Object);
                    sb.Append(" = ");
                    this.Visit(m.Arguments[0]);
                    sb.Append(")");
                    return m;
                }
            }

            throw new NotSupportedException(string.Format("The method '{0}' is not supported", m.Method.Name));
        }

        
        protected override Expression VisitSelect(SelectExpression select)
        {
            sb.Append("SELECT ");
            if (select.IsDistinct)
            {
                sb.Append("DISTINCT ");
            }

            if (select.Columns.Count > 0)
            {
                for (int i = 0, n = select.Columns.Count; i < n; i++)
                {
                    ColumnDeclaration column = select.Columns[i];
                    if (i > 0)
                    {
                        sb.Append(", ");
                    }
                    ColumnExpression c = VisitValue(column.Expression) as ColumnExpression;
                    if (!string.IsNullOrEmpty(column.Name) && (c == null || c.Name != column.Name))
                    {
                        sb.Append(" AS ");
                        sb.Append(column.Name);
                    }
                }
            }
            else
            {
                sb.Append("NULL ");
                if (isNested)
                {
                    sb.Append("AS tmp ");
                }
            }
            if (select.From != null)
            {
                AppendNewLine(Indentation.Same);
                sb.Append("FROM ");
                VisitSource(select.From);
            }
            if (select.Where != null)
            {
                AppendNewLine(Indentation.Same);
                sb.Append("WHERE ");
                VisitPredicate(select.Where);
            }
            if (select.GroupBy != null && select.GroupBy.Count > 0)
            {
                AppendNewLine(Indentation.Same);
                sb.Append("GROUP BY ");
                for (int i = 0, n = select.GroupBy.Count; i < n; i++)
                {
                    if (i > 0)
                    {
                        sb.Append(", ");
                    }
                    VisitValue(select.GroupBy[i]);
                }
            }
            if (select.OrderBy != null && select.OrderBy.Count > 0)
            {
                AppendNewLine(Indentation.Same);
                sb.Append("ORDER BY ");
                for (int i = 0, n = select.OrderBy.Count; i < n; i++)
                {
                    OrderExpression exp = select.OrderBy[i];
                    if (i > 0)
                    {
                        sb.Append(", ");
                    }
                    VisitValue(exp.Expression);
                    if (exp.OrderType != OrderType.Ascending)
                    {
                        sb.Append(" DESC");
                    }
                }
            }

            int skip = select.Skip == null ? 0 : (int) select.Skip.GetConstantValue();
            int take = select.Take == null ? 0 : (int) select.Take.GetConstantValue();

            if (take > 0)
            {
                AppendNewLine(Indentation.Same);
                sb.AppendFormat(" LIMIT {0},{1}", skip, take);
            }
            return select;
        }

        protected override Expression VisitColumn(ColumnExpression column)
        {
            if (column.Alias != null)
            {
                sb.AppendFormat("`{0}`", GetAliasName(column.Alias));
                sb.Append(".");
            }
            sb.AppendFormat("`{0}`", column.Name);
            return column;
        }

        public static string FormatExpression(Expression expression)
        {
            MySqlFormatter formatter = new MySqlFormatter();
            formatter.Visit(expression);
            return formatter.sb.ToString();
        }
    }
}