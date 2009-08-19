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
using System.ComponentModel;
using System.Data;
using SubSonic.Extensions;

namespace SubSonic.Query
{
    /// <summary>
    /// Where, And, Or
    /// </summary>
    public enum ConstraintType
    {
        /// <summary>
        /// WHERE operator
        /// </summary>
        Where,
        /// <summary>
        /// AND operator
        /// </summary>
        And,
        /// <summary>
        /// OR Operator
        /// </summary>
        Or
    }


    /// <summary>
    /// SQL Comparison Operators
    /// </summary>
    public enum Comparison
    {
        Equals,
        NotEquals,
        Like,
        NotLike,
        GreaterThan,
        GreaterOrEquals,
        LessThan,
        LessOrEquals,
        Blank,
        Is,
        IsNot,
        In,
        NotIn,
        OpenParentheses,
        CloseParentheses,
        BetweenAnd,
        StartsWith,
        EndsWith
    }


    /// <summary>
    /// Summary for the SqlComparison class
    /// </summary>
    public class SqlComparison
    {
        public const string BLANK = " ";
        public const string EQUAL = " = ";
        public const string GREATER = " > ";
        public const string GREATER_OR_EQUAL = " >= ";
        public const string IS = " IS ";
        public const string IS_NOT = " IS NOT ";
        public const string LESS = " < ";
        public const string LESS_OR_EQUAL = " <= ";
        public const string LIKE = " LIKE ";
        public const string NOT_EQUAL = " <> ";
        public const string NOT_LIKE = " NOT LIKE ";
    }

    /// <summary>
    /// A Class for handling SQL Constraint generation
    /// </summary>
    public class Constraint
    {
        /// <summary>
        /// The query that this constraint is operating on
        /// </summary>
        public SqlQuery query;

        public Constraint() {}


        #region Factory methods

        /// <summary>
        /// Initializes a new instance of the <see cref="Constraint"/> class.
        /// </summary>
        /// <param name="condition">The condition.</param>
        /// <param name="constraintColumnName">Name of the constraint column.</param>
        public Constraint(ConstraintType condition, string constraintColumnName)
        {
            Condition = condition;
            ColumnName = constraintColumnName;
            QualifiedColumnName = constraintColumnName;
            ConstructionFragment = constraintColumnName;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="Constraint"/> class.
        /// </summary>
        /// <param name="condition">The condition.</param>
        /// <param name="constraintColumnName">Name of the constraint column.</param>
        /// <param name="constraintQualifiedColumnName">Name of the constraint qualified column.</param>
        public Constraint(ConstraintType condition, string constraintColumnName, string constraintQualifiedColumnName)
        {
            Condition = condition;
            ColumnName = constraintColumnName;
            QualifiedColumnName = constraintQualifiedColumnName;
            ConstructionFragment = constraintColumnName;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="Constraint"/> class.
        /// </summary>
        /// <param name="condition">The condition.</param>
        /// <param name="constraintColumnName">Name of the constraint column.</param>
        /// <param name="constraintQualifiedColumnName">Name of the constraint qualified column.</param>
        /// <param name="constraintConstructionFragment">The constraint construction fragment.</param>
        public Constraint(ConstraintType condition, string constraintColumnName, string constraintQualifiedColumnName, string constraintConstructionFragment)
        {
            Condition = condition;
            ColumnName = constraintColumnName;
            QualifiedColumnName = constraintQualifiedColumnName;
            ConstructionFragment = constraintConstructionFragment;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="Constraint"/> class.
        /// </summary>
        /// <param name="condition">The condition.</param>
        /// <param name="constraintColumnName">Name of the constraint column.</param>
        /// <param name="sqlQuery">The SQL query.</param>
        public Constraint(ConstraintType condition, string constraintColumnName, SqlQuery sqlQuery)
        {
            Condition = condition;
            ColumnName = constraintColumnName;
            QualifiedColumnName = constraintColumnName;
            ConstructionFragment = constraintColumnName;
            query = sqlQuery;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="Constraint"/> class.
        /// </summary>
        /// <param name="condition">The condition.</param>
        /// <param name="constraintColumnName">Name of the constraint column.</param>
        /// <param name="constraintQualifiedColumnName">Name of the constraint qualified column.</param>
        /// <param name="constraintConstructionFragment">The constraint construction fragment.</param>
        /// <param name="sqlQuery">The SQL query.</param>
        public Constraint(ConstraintType condition, string constraintColumnName, string constraintQualifiedColumnName, string constraintConstructionFragment, SqlQuery sqlQuery)
        {
            Condition = condition;
            ColumnName = constraintColumnName;
            QualifiedColumnName = constraintQualifiedColumnName;
            ConstructionFragment = constraintConstructionFragment;
            query = sqlQuery;
        }

        /// <summary>
        /// Wheres the specified column name.
        /// </summary>
        /// <param name="columnName">Name of the column.</param>
        /// <returns></returns>
        public static Constraint Where(string columnName)
        {
            return new Constraint(ConstraintType.Where, columnName);
        }

        /// <summary>
        /// Ands the specified column name.
        /// </summary>
        /// <param name="columnName">Name of the column.</param>
        /// <returns></returns>
        public static Constraint And(string columnName)
        {
            return new Constraint(ConstraintType.And, columnName);
        }

        /// <summary>
        /// Ors the specified column name.
        /// </summary>
        /// <param name="columnName">Name of the column.</param>
        /// <returns></returns>
        public static Constraint Or(string columnName)
        {
            return new Constraint(ConstraintType.Or, columnName);
        }

        #endregion


        #region props

        /// <summary>
        /// Gets or sets the name of the table.
        /// </summary>
        /// <value>The name of the table.</value>
        private string _tableName = String.Empty;

        private ConstraintType condition = ConstraintType.Where;
        private string parameterName;

        /// <summary>
        /// Gets or sets the condition.
        /// </summary>
        /// <value>The condition.</value>
        public ConstraintType Condition
        {
            get { return condition; }
            set { condition = value; }
        }

        public string TableName
        {
            get { return _tableName; }
            set { _tableName = value; }
        }

        /// <summary>
        /// Gets or sets the name of the column.
        /// </summary>
        /// <value>The name of the column.</value>
        public string ColumnName { get; set; }

        /// <summary>
        /// Gets or sets the fully qualified name of the column.
        /// </summary>
        /// <value>The name of the column.</value>
        public string QualifiedColumnName { get; set; }

        /// <summary>
        /// Gets or sets the string fragment used when assembling the text of query.
        /// </summary>
        /// <value>The construction fragment.</value>
        public string ConstructionFragment { get; set; }

        /// <summary>
        /// Gets or sets the comparison.
        /// </summary>
        /// <value>The comparison.</value>
        public Comparison Comparison { get; set; }

        /// <summary>
        /// Gets or sets the parameter value.
        /// </summary>
        /// <value>The parameter value.</value>
        public object ParameterValue { get; set; }

        /// <summary>
        /// Gets or sets the start value.
        /// </summary>
        /// <value>The start value.</value>
        public object StartValue { get; set; }

        /// <summary>
        /// Gets or sets the end value.
        /// </summary>
        /// <value>The end value.</value>
        public object EndValue { get; set; }

        /// <summary>
        /// Gets or sets the in values.
        /// </summary>
        /// <value>The in values.</value>
        public IEnumerable InValues { get; set; }

        /// <summary>
        /// Gets or sets the in select.
        /// </summary>
        /// <value>The in select.</value>
        public SqlQuery InSelect { get; set; }

        /// <summary>
        /// Gets or sets the name of the parameter.
        /// </summary>
        /// <value>The name of the parameter.</value>
        public string ParameterName
        {
            get { return parameterName ?? ColumnName; }
            set { parameterName = value; }
        }

        /// <summary>
        /// Gets or sets the type of the db.
        /// </summary>
        /// <value>The type of the db.</value>
        public DbType DbType { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether this constraint is an Aggregate.
        /// </summary>
        /// <value>
        /// 	<c>true</c> if this instance is aggregate; otherwise, <c>false</c>.
        /// </value>
        public bool IsAggregate { get; set; }

        /// <summary>
        /// Gets the comparison operator.
        /// </summary>
        /// <param name="comp">The comp.</param>
        /// <returns></returns>
        public static string GetComparisonOperator(Comparison comp)
        {
            string sOut;
            switch(comp)
            {
                case Comparison.Blank:
                    sOut = SqlComparison.BLANK;
                    break;
                case Comparison.GreaterThan:
                    sOut = SqlComparison.GREATER;
                    break;
                case Comparison.GreaterOrEquals:
                    sOut = SqlComparison.GREATER_OR_EQUAL;
                    break;
                case Comparison.LessThan:
                    sOut = SqlComparison.LESS;
                    break;
                case Comparison.LessOrEquals:
                    sOut = SqlComparison.LESS_OR_EQUAL;
                    break;
                case Comparison.Like:
                    sOut = SqlComparison.LIKE;
                    break;
                case Comparison.NotEquals:
                    sOut = SqlComparison.NOT_EQUAL;
                    break;
                case Comparison.NotLike:
                    sOut = SqlComparison.NOT_LIKE;
                    break;
                case Comparison.Is:
                    sOut = SqlComparison.IS;
                    break;
                case Comparison.IsNot:
                    sOut = SqlComparison.IS_NOT;
                    break;
                case Comparison.OpenParentheses:
                    sOut = "(";
                    break;
                case Comparison.CloseParentheses:
                    sOut = ")";
                    break;
                case Comparison.In:
                    sOut = " IN ";
                    break;
                case Comparison.NotIn:
                    sOut = " NOT IN ";
                    break;
                default:
                    sOut = SqlComparison.EQUAL;
                    break;
            }
            return sOut;
        }

        #endregion


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
            if(obj is Constraint)
            {
                Constraint compareTo = (Constraint)obj;
                return compareTo.ParameterName.Matches(parameterName) &&
                       compareTo.ParameterValue.Equals(ParameterValue);
            }
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
        /// Creates a LIKE statement.
        /// </summary>
        /// <param name="val">The val.</param>
        /// <returns></returns>
        public SqlQuery Like(string val)
        {
            Comparison = Comparison.Like;
            ParameterValue = val;
            DbType = query.GetConstraintDbType(TableName, ColumnName, val);
            query.Constraints.Add(this);

            return query;
        }

        /// <summary>
        /// Creates a LIKE statement and appends a wildcard to the end of the passed-in value.
        /// </summary>
        /// <param name="val">The val.</param>
        /// <returns></returns>
        public SqlQuery StartsWith(string val)
        {
            return StartsWith(val, "%");
        }

        public SqlQuery StartsWith(string val, string wildCard)
        {
            Comparison = Comparison.Like;
            ParameterValue = String.Format("{0}{1}", val, wildCard);
            DbType = query.GetConstraintDbType(TableName, ColumnName, val);
            query.Constraints.Add(this);

            return query;
        }

        /// <summary>
        /// Creates a LIKE statement and appends a wildcard to the end of the passed-in value.
        /// </summary>
        /// <param name="val">The val.</param>
        /// <param name="wildCard">The wild card.</param>
        /// <returns></returns>
        public SqlQuery EndsWith(string val, string wildCard)
        {
            Comparison = Comparison.Like;
            ParameterValue = String.Format("{0}{1}", wildCard, val);
            DbType = query.GetConstraintDbType(TableName, ColumnName, val);
            query.Constraints.Add(this);

            return query;
        }

        /// <summary>
        /// Creates a LIKE statement and appends a wildcard to the end of the passed-in value.
        /// </summary>
        /// <param name="val">The val.</param>
        /// <returns></returns>
        public SqlQuery EndsWith(string val)
        {
            return EndsWith(val, "%");
        }

        /// <summary>
        /// Creates a NOT LIKE statement
        /// </summary>
        /// <param name="val">The val.</param>
        /// <returns></returns>
        public SqlQuery NotLike(string val)
        {
            Comparison = Comparison.NotLike;
            ParameterValue = val;
            DbType = query.GetConstraintDbType(TableName, ColumnName, val);
            query.Constraints.Add(this);

            return query;
        }

        /// <summary>
        /// Determines whether [is greater than] [the specified val].
        /// </summary>
        /// <param name="val">The val.</param>
        /// <returns></returns>
        public SqlQuery IsGreaterThan(object val)
        {
            Comparison = Comparison.GreaterThan;
            ParameterValue = val;
            DbType = query.GetConstraintDbType(TableName, ColumnName, val);
            query.Constraints.Add(this);

            return query;
        }

        /// <summary>
        /// Determines whether [is greater than] [the specified val].
        /// </summary>
        /// <param name="val">The val.</param>
        /// <returns></returns>
        public SqlQuery IsGreaterThanOrEqualTo(object val)
        {
            Comparison = Comparison.GreaterOrEquals;
            ParameterValue = val;
            DbType = query.GetConstraintDbType(TableName, ColumnName, val);
            query.Constraints.Add(this);

            return query;
        }

        /// <summary>
        /// Specifies a SQL IN statement using a nested Select statement
        /// </summary>
        /// <param name="selectQuery">The select query.</param>
        /// <returns></returns>
        public SqlQuery In(SqlQuery selectQuery)
        {
            //validate that there is only one column in the columnlist
            if(selectQuery.SelectColumnList.Length == 0 || selectQuery.SelectColumnList.Length > 1)
                throw new InvalidOperationException("You must specify a column to return for the IN to be valid. Use Select(\"column\") to do this");

            InSelect = selectQuery;

            Comparison = Comparison.In;
            query.Constraints.Add(this);
            return query;
        }

        /// <summary>
        /// Specifies a SQL IN statement
        /// </summary>
        /// <param name="vals">Value array</param>
        /// <returns></returns>
        public SqlQuery In(IEnumerable vals)
        {
            InValues = vals;
            Comparison = Comparison.In;
            query.Constraints.Add(this);
            return query;
        }

        /// <summary>
        /// Specifies a SQL IN statement
        /// </summary>
        /// <param name="vals">Value array</param>
        /// <returns></returns>
        public SqlQuery In(params object[] vals)
        {
            InValues = vals;
            Comparison = Comparison.In;
            query.Constraints.Add(this);
            return query;
            //this is trickery, since every time we send in a Select query, it will call this method
            //so we need to evaluate it, and call In(Select)
            //I don't like this hack, but don't see a way around it
            /*
			if(vals.Length > 0)
			{
				if(vals[0].ToString().StartsWith("SELECT"))
				{
					Select s = (Select)vals[0];
					query = In(s);
				}
				else
				{
					InValues = vals;
					Comparison = Comparison.In;
					query.Constraints.Add(this);
				}
			}
            
			return query;*/
        }

        /// <summary>
        /// Specifies a SQL IN statement using a nested Select statement
        /// </summary>
        /// <param name="selectQuery">The select query.</param>
        /// <returns></returns>
        public SqlQuery NotIn(SqlQuery selectQuery)
        {
            //validate that there is only one column in the columnlist
            if(selectQuery.SelectColumnList.Length == 0 || selectQuery.SelectColumnList.Length > 1)
                throw new InvalidOperationException("You must specify a column to return for the IN to be valid. Use Select(\"column\") to do this");

            InSelect = selectQuery;

            Comparison = Comparison.NotIn;
            query.Constraints.Add(this);
            return query;
        }

        /// <summary>
        /// Specifies a SQL Not IN statement
        /// </summary>
        /// <param name="vals">Value array</param>
        /// <returns></returns>
        public SqlQuery NotIn(IEnumerable vals)
        {
            InValues = vals;
            Comparison = Comparison.NotIn;
            query.Constraints.Add(this);
            return query;
        }

        /// <summary>
        /// Specifies a SQL NOT IN statement
        /// </summary>
        /// <param name="vals">Value array</param>
        /// <returns></returns>
        public SqlQuery NotIn(params object[] vals)
        {
            InValues = vals;
            Comparison = Comparison.NotIn;
            query.Constraints.Add(this);
            return query;
                /*
            if(vals.Length > 0)
            {
                if(vals[0].ToString().StartsWith("SELECT"))
                {
                    Select s = (Select)vals[0];
                    query = NotIn(s);
                }
                else
                {
                    InValues = vals;
                    Comparison = Comparison.NotIn;
                    query.Constraints.Add(this);
                }
            }
            return query;*/
        }

        /// <summary>
        /// Determines whether [is less than] [the specified val].
        /// </summary>
        /// <param name="val">The val.</param>
        /// <returns></returns>
        public SqlQuery IsLessThan(object val)
        {
            Comparison = Comparison.LessThan;
            ParameterValue = val;
            DbType = query.GetConstraintDbType(TableName, ColumnName, val);
            query.Constraints.Add(this);
            return query;
        }

        /// <summary>
        /// Determines whether [is less than] [the specified val].
        /// </summary>
        /// <param name="val">The val.</param>
        /// <returns></returns>
        public SqlQuery IsLessThanOrEqualTo(object val)
        {
            Comparison = Comparison.LessOrEquals;
            ParameterValue = val;
            DbType = query.GetConstraintDbType(TableName, ColumnName, val);
            query.Constraints.Add(this);
            return query;
        }

        /// <summary>
        /// Determines whether [is not null] [the specified val].
        /// </summary>
        /// <returns></returns>
        public SqlQuery IsNotNull()
        {
            Comparison = Comparison.IsNot;
            ParameterValue = DBNull.Value;
            query.Constraints.Add(this);
            return query;
        }

        /// <summary>
        /// Determines whether the specified val is null.
        /// </summary>
        /// <returns></returns>
        public SqlQuery IsNull()
        {
            Comparison = Comparison.Is;
            ParameterValue = DBNull.Value;
            query.Constraints.Add(this);
            return query;
        }

        /// <summary>
        /// Determines whether [is between and] [the specified val1].
        /// </summary>
        /// <param name="val1">The val1.</param>
        /// <param name="val2">The val2.</param>
        /// <returns></returns>
        public SqlQuery IsBetweenAnd(object val1, object val2)
        {
            Comparison = Comparison.BetweenAnd;
            StartValue = val1;
            EndValue = val2;
            DbType = query.GetConstraintDbType(TableName, ColumnName, val1);
            query.Constraints.Add(this);
            return query;
        }

        /// <summary>
        /// Determines whether [is equal to] [the specified val].
        /// </summary>
        /// <param name="val">The val.</param>
        /// <returns></returns>
        public SqlQuery IsEqualTo(object val)
        {
            Comparison = Comparison.Equals;
            ParameterValue = val;
            DbType = query.GetConstraintDbType(TableName, ColumnName, val);
            query.Constraints.Add(this);
            return query;
        }

        /// <summary>
        /// Determines whether [is not equal to] [the specified val].
        /// </summary>
        /// <param name="val">The val.</param>
        /// <returns></returns>
        public SqlQuery IsNotEqualTo(object val)
        {
            Comparison = Comparison.NotEquals;
            ParameterValue = val;
            DbType = query.GetConstraintDbType(TableName, ColumnName, val);
            query.Constraints.Add(this);
            return query;
        }
    }
}