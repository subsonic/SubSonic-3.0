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
using SubSonic.Schema;

namespace SubSonic.Query
{
    /// <summary>
    /// Enum for General SQL Functions
    /// </summary>
    public enum AggregateFunction
    {
        Count,
        Sum,
        Avg,
        Min,
        Max,
        StDev,
        Var,
        GroupBy
    }

    /// <summary>
    /// 
    /// </summary>
    public class Aggregate
    {
        #region Aggregates Factories

        /// <summary>
        /// Counts the specified col.
        /// </summary>
        /// <param name="col">The col.</param>
        /// <returns></returns>
        public static Aggregate Count(IColumn col)
        {
            Aggregate agg = new Aggregate(col, AggregateFunction.Count);
            return agg;
        }

        /// <summary>
        /// Counts the specified col.
        /// </summary>
        /// <param name="col">The col.</param>
        /// <param name="alias">The alias.</param>
        /// <returns></returns>
        public static Aggregate Count(IColumn col, string alias)
        {
            Aggregate agg = new Aggregate(col, alias, AggregateFunction.Count);
            return agg;
        }

        /// <summary>
        /// Counts the specified column name.
        /// </summary>
        /// <param name="columnName">Name of the column.</param>
        /// <returns></returns>
        public static Aggregate Count(string columnName)
        {
            Aggregate agg = new Aggregate(columnName, AggregateFunction.Count);
            return agg;
        }

        /// <summary>
        /// Counts the specified column name.
        /// </summary>
        /// <param name="columnName">Name of the column.</param>
        /// <param name="alias">The alias.</param>
        /// <returns></returns>
        public static Aggregate Count(string columnName, string alias)
        {
            Aggregate agg = new Aggregate(columnName, alias, AggregateFunction.Count);
            return agg;
        }

        /// <summary>
        /// Sums the specified col.
        /// </summary>
        /// <param name="col">The col.</param>
        /// <returns></returns>
        public static Aggregate Sum(IColumn col)
        {
            Aggregate agg = new Aggregate(col, AggregateFunction.Sum);
            return agg;
        }

        /// <summary>
        /// Sums the specified column name.
        /// </summary>
        /// <param name="columnName">Name of the column.</param>
        /// <returns></returns>
        public static Aggregate Sum(string columnName)
        {
            Aggregate agg = new Aggregate(columnName, AggregateFunction.Sum);
            return agg;
        }

        /// <summary>
        /// Sums the specified col.
        /// </summary>
        /// <param name="col">The col.</param>
        /// <param name="alias">The alias.</param>
        /// <returns></returns>
        public static Aggregate Sum(IColumn col, string alias)
        {
            Aggregate agg = new Aggregate(col, alias, AggregateFunction.Sum);
            return agg;
        }

        /// <summary>
        /// Sums the specified column name.
        /// </summary>
        /// <param name="columnName">Name of the column.</param>
        /// <param name="alias">The alias.</param>
        /// <returns></returns>
        public static Aggregate Sum(string columnName, string alias)
        {
            Aggregate agg = new Aggregate(columnName, alias, AggregateFunction.Sum);
            return agg;
        }

        /// <summary>
        /// Groups the by.
        /// </summary>
        /// <param name="col">The col.</param>
        /// <returns></returns>
        public static Aggregate GroupBy(IColumn col)
        {
            Aggregate agg = new Aggregate(col, AggregateFunction.GroupBy);
            return agg;
        }

        /// <summary>
        /// Groups the by.
        /// </summary>
        /// <param name="columnName">Name of the column.</param>
        /// <returns></returns>
        public static Aggregate GroupBy(string columnName)
        {
            Aggregate agg = new Aggregate(columnName, AggregateFunction.GroupBy);
            return agg;
        }

        /// <summary>
        /// Groups the by.
        /// </summary>
        /// <param name="col">The col.</param>
        /// <param name="alias">The alias.</param>
        /// <returns></returns>
        public static Aggregate GroupBy(IColumn col, string alias)
        {
            Aggregate agg = new Aggregate(col, alias, AggregateFunction.GroupBy);
            return agg;
        }

        /// <summary>
        /// Groups the by.
        /// </summary>
        /// <param name="columnName">Name of the column.</param>
        /// <param name="alias">The alias.</param>
        /// <returns></returns>
        public static Aggregate GroupBy(string columnName, string alias)
        {
            Aggregate agg = new Aggregate(columnName, alias, AggregateFunction.GroupBy);
            return agg;
        }

        /// <summary>
        /// Avgs the specified col.
        /// </summary>
        /// <param name="col">The col.</param>
        /// <returns></returns>
        public static Aggregate Avg(IColumn col)
        {
            Aggregate agg = new Aggregate(col, AggregateFunction.Avg);
            return agg;
        }

        /// <summary>
        /// Avgs the specified column name.
        /// </summary>
        /// <param name="columnName">Name of the column.</param>
        /// <returns></returns>
        public static Aggregate Avg(string columnName)
        {
            Aggregate agg = new Aggregate(columnName, AggregateFunction.Avg);
            return agg;
        }

        /// <summary>
        /// Avgs the specified col.
        /// </summary>
        /// <param name="col">The col.</param>
        /// <param name="alias">The alias.</param>
        /// <returns></returns>
        public static Aggregate Avg(IColumn col, string alias)
        {
            Aggregate agg = new Aggregate(col, alias, AggregateFunction.Avg);
            return agg;
        }

        /// <summary>
        /// Avgs the specified column name.
        /// </summary>
        /// <param name="columnName">Name of the column.</param>
        /// <param name="alias">The alias.</param>
        /// <returns></returns>
        public static Aggregate Avg(string columnName, string alias)
        {
            Aggregate agg = new Aggregate(columnName, alias, AggregateFunction.Avg);
            return agg;
        }

        /// <summary>
        /// Maxes the specified col.
        /// </summary>
        /// <param name="col">The col.</param>
        /// <returns></returns>
        public static Aggregate Max(IColumn col)
        {
            Aggregate agg = new Aggregate(col, AggregateFunction.Max);
            return agg;
        }

        /// <summary>
        /// Maxes the specified column name.
        /// </summary>
        /// <param name="columnName">Name of the column.</param>
        /// <returns></returns>
        public static Aggregate Max(string columnName)
        {
            Aggregate agg = new Aggregate(columnName, AggregateFunction.Max);
            return agg;
        }

        /// <summary>
        /// Maxes the specified col.
        /// </summary>
        /// <param name="col">The col.</param>
        /// <param name="alias">The alias.</param>
        /// <returns></returns>
        public static Aggregate Max(IColumn col, string alias)
        {
            Aggregate agg = new Aggregate(col, alias, AggregateFunction.Max);
            return agg;
        }

        /// <summary>
        /// Maxes the specified column name.
        /// </summary>
        /// <param name="columnName">Name of the column.</param>
        /// <param name="alias">The alias.</param>
        /// <returns></returns>
        public static Aggregate Max(string columnName, string alias)
        {
            Aggregate agg = new Aggregate(columnName, alias, AggregateFunction.Max);
            return agg;
        }

        /// <summary>
        /// Mins the specified col.
        /// </summary>
        /// <param name="col">The col.</param>
        /// <returns></returns>
        public static Aggregate Min(IColumn col)
        {
            Aggregate agg = new Aggregate(col, AggregateFunction.Min);
            return agg;
        }

        /// <summary>
        /// Mins the specified column name.
        /// </summary>
        /// <param name="columnName">Name of the column.</param>
        /// <returns></returns>
        public static Aggregate Min(string columnName)
        {
            Aggregate agg = new Aggregate(columnName, AggregateFunction.Min);
            return agg;
        }

        /// <summary>
        /// Mins the specified col.
        /// </summary>
        /// <param name="col">The col.</param>
        /// <param name="alias">The alias.</param>
        /// <returns></returns>
        public static Aggregate Min(IColumn col, string alias)
        {
            Aggregate agg = new Aggregate(col, alias, AggregateFunction.Min);
            return agg;
        }

        /// <summary>
        /// Mins the specified column name.
        /// </summary>
        /// <param name="columnName">Name of the column.</param>
        /// <param name="alias">The alias.</param>
        /// <returns></returns>
        public static Aggregate Min(string columnName, string alias)
        {
            Aggregate agg = new Aggregate(columnName, alias, AggregateFunction.Min);
            return agg;
        }

        /// <summary>
        /// Variances the specified col.
        /// </summary>
        /// <param name="col">The col.</param>
        /// <returns></returns>
        public static Aggregate Variance(IColumn col)
        {
            Aggregate agg = new Aggregate(col, AggregateFunction.Var);
            return agg;
        }

        /// <summary>
        /// Variances the specified column name.
        /// </summary>
        /// <param name="columnName">Name of the column.</param>
        /// <returns></returns>
        public static Aggregate Variance(string columnName)
        {
            Aggregate agg = new Aggregate(columnName, AggregateFunction.Var);
            return agg;
        }

        /// <summary>
        /// Variances the specified col.
        /// </summary>
        /// <param name="col">The col.</param>
        /// <param name="alias">The alias.</param>
        /// <returns></returns>
        public static Aggregate Variance(IColumn col, string alias)
        {
            Aggregate agg = new Aggregate(col, alias, AggregateFunction.Var);
            return agg;
        }

        /// <summary>
        /// Variances the specified column name.
        /// </summary>
        /// <param name="columnName">Name of the column.</param>
        /// <param name="alias">The alias.</param>
        /// <returns></returns>
        public static Aggregate Variance(string columnName, string alias)
        {
            Aggregate agg = new Aggregate(columnName, alias, AggregateFunction.Var);
            return agg;
        }

        /// <summary>
        /// Standards the deviation.
        /// </summary>
        /// <param name="col">The col.</param>
        /// <returns></returns>
        public static Aggregate StandardDeviation(IColumn col)
        {
            Aggregate agg = new Aggregate(col, AggregateFunction.StDev);
            return agg;
        }

        /// <summary>
        /// Standards the deviation.
        /// </summary>
        /// <param name="columnName">Name of the column.</param>
        /// <returns></returns>
        public static Aggregate StandardDeviation(string columnName)
        {
            Aggregate agg = new Aggregate(columnName, AggregateFunction.StDev);
            return agg;
        }

        /// <summary>
        /// Standards the deviation.
        /// </summary>
        /// <param name="col">The col.</param>
        /// <param name="alias">The alias.</param>
        /// <returns></returns>
        public static Aggregate StandardDeviation(IColumn col, string alias)
        {
            Aggregate agg = new Aggregate(col, alias, AggregateFunction.StDev);
            return agg;
        }

        /// <summary>
        /// Standards the deviation.
        /// </summary>
        /// <param name="columnName">Name of the column.</param>
        /// <param name="alias">The alias.</param>
        /// <returns></returns>
        public static Aggregate StandardDeviation(string columnName, string alias)
        {
            Aggregate agg = new Aggregate(columnName, alias, AggregateFunction.StDev);
            return agg;
        }

        #endregion


        #region .ctors

        private AggregateFunction _aggregateType = AggregateFunction.Count;

        /// <summary>
        /// Initializes a new instance of the <see cref="Aggregate"/> class.
        /// </summary>
        /// <param name="columnName">Name of the column.</param>
        /// <param name="aggregateType">Type of the aggregate.</param>
        public Aggregate(string columnName, AggregateFunction aggregateType)
        {
            ColumnName = columnName;
            _aggregateType = aggregateType;
            Alias = String.Concat(GetFunctionType(this), "Of", columnName);
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="Aggregate"/> class.
        /// </summary>
        /// <param name="columnName">Name of the column.</param>
        /// <param name="alias">The alias.</param>
        /// <param name="aggregateType">Type of the aggregate.</param>
        public Aggregate(string columnName, string alias, AggregateFunction aggregateType)
        {
            ColumnName = columnName;
            _aggregateType = aggregateType;
            Alias = alias;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="Aggregate"/> class.
        /// </summary>
        /// <param name="column">The column.</param>
        /// <param name="aggregateType">Type of the aggregate.</param>
        public Aggregate(IDBObject column, AggregateFunction aggregateType)
        {
            ColumnName = column.QualifiedName;
            _aggregateType = aggregateType;
            Alias = String.Concat(GetFunctionType(this), "Of", column.Name);
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="Aggregate"/> class.
        /// </summary>
        /// <param name="column">The column.</param>
        /// <param name="alias">The alias.</param>
        /// <param name="aggregateType">Type of the aggregate.</param>
        public Aggregate(IDBObject column, string alias, AggregateFunction aggregateType)
        {
            ColumnName = column.QualifiedName;
            Alias = alias;
            _aggregateType = aggregateType;
        }

        /// <summary>
        /// Gets the type of the function.
        /// </summary>
        /// <param name="agg">The agg.</param>
        /// <returns></returns>
        public static string GetFunctionType(Aggregate agg)
        {
            return Enum.GetName(typeof(AggregateFunction), agg.AggregateType);
        }

        #endregion


        /// <summary>
        /// Gets or sets the type of the aggregate.
        /// </summary>
        /// <value>The type of the aggregate.</value>
        public AggregateFunction AggregateType
        {
            get { return _aggregateType; }
            set { _aggregateType = value; }
        }

        /// <summary>
        /// Gets or sets the name of the column.
        /// </summary>
        /// <value>The name of the column.</value>
        public string ColumnName { get; set; }

        /// <summary>
        /// Gets or sets the alias.
        /// </summary>
        /// <value>The alias.</value>
        public string Alias { get; set; }

        /// <summary>
        /// Gets the SQL function call without an alias.  Example: AVG(UnitPrice).
        /// </summary>
        /// <returns></returns>
        public string WithoutAlias()
        {
            string result;

            if(AggregateType == AggregateFunction.GroupBy)
                result = ColumnName;
            else
            {
                string functionName = GetFunctionType(this);
                functionName = functionName.ToUpper();
                const string aggFormat = " {0}({1})";
                result = string.Format(aggFormat, functionName, ColumnName);
            }

            return result;
        }

        /// <summary>
        /// Overrides ToString() to return the SQL Function call
        /// </summary>
        /// <returns></returns>
        public override string ToString()
        {
            string result;

            if(AggregateType == AggregateFunction.GroupBy)
                result = ColumnName;
            else
            {
                string functionName = GetFunctionType(this);
                functionName = functionName.ToUpper();
                const string aggFormat = " {0}({1}) as '{2}'";
                result = string.Format(aggFormat, functionName, ColumnName, Alias);
            }

            return result;
        }
    }
}