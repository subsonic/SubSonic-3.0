// Copyright (c) Microsoft Corporation.  All rights reserved.
// This source code is made available under the terms of the Microsoft Public License (MS-PL)
//Original code created by Matt Warren: http://iqtoolkit.codeplex.com/Release/ProjectReleases.aspx?ReleaseId=19725

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using System.Text;
using SubSonic.Linq.Translation;

namespace SubSonic.Linq.Structure
{
    /// <summary>
    /// Extended node types for custom expressions
    /// </summary>
    public enum DbExpressionType
    {
        Table = 1000, // make sure these don't overlap with ExpressionType
        ClientJoin,
        Column,
        Select,
        Projection,
        Join,
        Aggregate,
        Scalar,
        Exists,
        In,
        Grouping,
        AggregateSubquery,
        IsNull,
        Between,
        RowCount,
        NamedValue,
        OuterJoined,
        Limit
    }

    public static class DbExpressionTypeExtensions
    {
        public static bool IsDbExpression(this ExpressionType et)
        {
            return ((int)et) >= 1000;
        }
    }

    public abstract class DbExpression : Expression
    {
        protected DbExpression(DbExpressionType eType, Type type)
            : base((ExpressionType)eType, type)
        {
        }

        public override string ToString()
        {
            return DbExpressionWriter.WriteToString(this);
        }
    }

    public abstract class AliasedExpression : DbExpression
    {
        TableAlias alias;
        protected AliasedExpression(DbExpressionType nodeType, Type type, TableAlias alias)
            : base(nodeType, type)
        {
            this.alias = alias;
        }
        public TableAlias Alias
        {
            get { return this.alias; }
            set { this.alias = value; }
        }
    }


    /// <summary>
    /// A custom expression node that represents a table reference in a SQL query
    /// </summary>
    public class TableExpression : AliasedExpression
    {
        string name;

        public TableExpression(TableAlias alias, string name)
            : base(DbExpressionType.Table, typeof(void), alias)
        {
            this.name = name;
        }

        public string Name
        {
            get { return this.name; }
        }

        public override string ToString()
        {
            return "T(" + this.name + ")";
        }
    }

    /// <summary>
    /// A custom expression node that represents a reference to a column in a SQL query
    /// </summary>
    public class ColumnExpression : DbExpression, IEquatable<ColumnExpression>
    {
        TableAlias alias;
        string name;

        public ColumnExpression(Type type, TableAlias alias, string name)
            : base(DbExpressionType.Column, type)
        {
            this.alias = alias;
            this.name = name;
        }

        public TableAlias Alias
        {
            get { return this.alias; }
        }

        public string Name
        {
            get { return this.name; }
        }

        public override string ToString()
        {
            return this.Alias.ToString() + ".C(" + this.name + ")";
        }

        public override int GetHashCode()
        {
            return alias.GetHashCode() + name.GetHashCode();
        }

        public override bool Equals(object obj)
        {
            return Equals(obj as ColumnExpression);
        }

        public bool Equals(ColumnExpression other)
        {
            return other != null
                && ((object)this) == (object)other
                 || (alias == other.alias && name == other.Name);
        }
    }

    public class TableAlias
    {
        public TableAlias()
        {
        }

        public override string ToString()
        {
            return "A:" + this.GetHashCode();
        }
    }

    /// <summary>
    /// A declaration of a column in a SQL SELECT expression
    /// </summary>
    public class ColumnDeclaration
    {
        string name;
        Expression expression;
        public ColumnDeclaration(string name, Expression expression)
        {
            this.name = name;
            this.expression = expression;
        }
        public string Name
        {
            get { return this.name; }
        }
        public Expression Expression
        {
            get { return this.expression; }
        }
    }

    /// <summary>
    /// An SQL OrderBy order type 
    /// </summary>
    public enum OrderType
    {
        Ascending,
        Descending
    }

    /// <summary>
    /// A pairing of an expression and an order type for use in a SQL Order By clause
    /// </summary>
    public class OrderExpression
    {
        OrderType orderType;
        Expression expression;
        public OrderExpression(OrderType orderType, Expression expression)
        {
            this.orderType = orderType;
            this.expression = expression;
        }
        public OrderType OrderType
        {
            get { return this.orderType; }
        }
        public Expression Expression
        {
            get { return this.expression; }
        }
    }

    /// <summary>
    /// A custom expression node used to represent a SQL SELECT expression
    /// </summary>
    public class SelectExpression : AliasedExpression
    {
        ReadOnlyCollection<ColumnDeclaration> columns;
        bool isDistinct;
        Expression from;
        Expression where;
        ReadOnlyCollection<OrderExpression> orderBy;
        ReadOnlyCollection<Expression> groupBy;
        Expression take;
        Expression skip;
        Expression limit;
        internal int SkipRecords;
        internal int TakeRecords;
        public SelectExpression(
            TableAlias alias,
            IEnumerable<ColumnDeclaration> columns,
            Expression from,
            Expression where,
            IEnumerable<OrderExpression> orderBy,
            IEnumerable<Expression> groupBy,
            bool isDistinct,
            Expression skip,
            Expression take)
            : base(DbExpressionType.Select, typeof(void), alias)
        {
            this.columns = columns as ReadOnlyCollection<ColumnDeclaration>;
            if (this.columns == null)
            {
                this.columns = new List<ColumnDeclaration>(columns).AsReadOnly();
            }
            this.isDistinct = isDistinct;
            this.from = from;
            this.where = where;
            this.orderBy = orderBy as ReadOnlyCollection<OrderExpression>;
            if (this.orderBy == null && orderBy != null)
            {
                this.orderBy = new List<OrderExpression>(orderBy).AsReadOnly();
            }
            this.groupBy = groupBy as ReadOnlyCollection<Expression>;
            if (this.groupBy == null && groupBy != null)
            {
                this.groupBy = new List<Expression>(groupBy).AsReadOnly();
            }
            this.take = take;
            this.skip = skip;
        }
        public SelectExpression(
            TableAlias alias,
            IEnumerable<ColumnDeclaration> columns,
            Expression from,
            Expression where,
            IEnumerable<OrderExpression> orderBy,
            IEnumerable<Expression> groupBy
            )
            : this(alias, columns, from, where, orderBy, groupBy, false, null, null)
        {
        }
        public SelectExpression(
            TableAlias alias, IEnumerable<ColumnDeclaration> columns,
            Expression from, Expression where
            )
            : this(alias, columns, from, where, null, null)
        {
        }
        public ReadOnlyCollection<ColumnDeclaration> Columns
        {
            get { return this.columns; }
        }
        public Expression From
        {
            get { return this.from; }
            set { this.from = value; }
        }
        public Expression Where
        {
            get { return this.where; }
        }
        public ReadOnlyCollection<OrderExpression> OrderBy
        {
            get { return this.orderBy; }
        }
        public ReadOnlyCollection<Expression> GroupBy
        {
            get { return this.groupBy; }
        }
        public bool IsDistinct
        {
            get { return this.isDistinct; }
        }
        public Expression Skip
        {
            get { return this.skip; }
            set { this.skip = value; }
        }
        public Expression Take
        {
            get { return this.take; }
            set { this.take=value; }
       }
        public string QueryText
        {
            get { return TSqlFormatter.Format(this); }
        }

    }

    /// <summary>
    /// A kind of SQL join
    /// </summary>
    public enum JoinType
    {
        CrossJoin,
        InnerJoin,
        CrossApply,
        OuterApply,
        LeftOuter
    }

    /// <summary>
    /// A custom expression node representing a SQL join clause
    /// </summary>
    public class JoinExpression : DbExpression
    {
        JoinType joinType;
        Expression left;
        Expression right;
        Expression condition;

        public JoinExpression(JoinType joinType, Expression left, Expression right, Expression condition)
            : base(DbExpressionType.Join, typeof(void))
        {
            this.joinType = joinType;
            this.left = left;
            this.right = right;
            this.condition = condition;
        }
        public JoinType Join
        {
            get { return this.joinType; }
        }
        public Expression Left
        {
            get { return this.left; }
        }
        public Expression Right
        {
            get { return this.right; }
        }
        public new Expression Condition
        {
            get { return this.condition; }
        }
    }

    public class OuterJoinedExpression : DbExpression
    {
        Expression test;
        Expression expression;

        public OuterJoinedExpression(Expression test, Expression expression)
            : base(DbExpressionType.OuterJoined, expression.Type)
        {
            this.test = test;
            this.expression = expression;
        }

        public Expression Test
        {
            get { return this.test; }
        }

        public Expression Expression
        {
            get { return this.expression; }
        }
    }

    public abstract class SubqueryExpression : DbExpression
    {
        SelectExpression select;
        protected SubqueryExpression(DbExpressionType eType, Type type, SelectExpression select)
            : base(eType, type)
        {
            System.Diagnostics.Debug.Assert(eType == DbExpressionType.Scalar || eType == DbExpressionType.Exists || eType == DbExpressionType.In);
            this.select = select;
        }
        public SelectExpression Select
        {
            get { return this.select; }
        }
    }

    public class ScalarExpression : SubqueryExpression
    {
        public ScalarExpression(Type type, SelectExpression select)
            : base(DbExpressionType.Scalar, type, select)
        {
        }
    }

    public class ExistsExpression : SubqueryExpression
    {
        public ExistsExpression(SelectExpression select)
            : base(DbExpressionType.Exists, typeof(bool), select)
        {
        }
    }

    public class InExpression : SubqueryExpression
    {
        Expression expression;
        ReadOnlyCollection<Expression> values;  // either select or expressions are assigned
        public InExpression(Expression expression, SelectExpression select)
            : base(DbExpressionType.In, typeof(bool), select)
        {
            this.expression = expression;
        }
        public InExpression(Expression expression, IEnumerable<Expression> values)
            : base(DbExpressionType.In, typeof(bool), null)
        {
            this.expression = expression;
            this.values = values as ReadOnlyCollection<Expression>;
            if (this.values == null && values != null)
            {
                this.values = new List<Expression>(values).AsReadOnly();
            }
        }
        public Expression Expression
        {
            get { return this.expression; }
        }
        public ReadOnlyCollection<Expression> Values
        {
            get { return this.values; }
        }
    }

    public enum AggregateType
    {
        Count,
        Min,
        Max,
        Sum,
        Average
    }

    public class AggregateExpression : DbExpression
    {
        AggregateType aggType;
        Expression argument;
        bool isDistinct;
        public AggregateExpression(Type type, AggregateType aggType, Expression argument, bool isDistinct)
            : base(DbExpressionType.Aggregate, type)
        {
            this.aggType = aggType;
            this.argument = argument;
            this.isDistinct = isDistinct;
        }
        public AggregateType AggregateType
        {
            get { return this.aggType; }
        }
        public Expression Argument
        {
            get { return this.argument; }
        }
        public bool IsDistinct
        {
            get { return this.isDistinct; }
        }
    }

    public class AggregateSubqueryExpression : DbExpression
    {
        TableAlias groupByAlias;
        Expression aggregateInGroupSelect;
        ScalarExpression aggregateAsSubquery;
        public AggregateSubqueryExpression(TableAlias groupByAlias, Expression aggregateInGroupSelect, ScalarExpression aggregateAsSubquery)
            : base(DbExpressionType.AggregateSubquery, aggregateAsSubquery.Type)
        {
            this.aggregateInGroupSelect = aggregateInGroupSelect;
            this.groupByAlias = groupByAlias;
            this.aggregateAsSubquery = aggregateAsSubquery;
        }
        public TableAlias GroupByAlias { get { return this.groupByAlias; } }
        public Expression AggregateInGroupSelect { get { return this.aggregateInGroupSelect; } }
        public ScalarExpression AggregateAsSubquery { get { return this.aggregateAsSubquery; } }
    }

    /// <summary>
    /// Allows is-null tests against value-types like int and float
    /// </summary>
    public class IsNullExpression : DbExpression
    {
        Expression expression;
        public IsNullExpression(Expression expression)
            : base(DbExpressionType.IsNull, typeof(bool))
        {
            this.expression = expression;
        }
        public Expression Expression
        {
            get { return this.expression; }
        }
    }

    public class BetweenExpression : DbExpression
    {
        Expression expression;
        Expression lower;
        Expression upper;
        public BetweenExpression(Expression expression, Expression lower, Expression upper)
            : base(DbExpressionType.Between, expression.Type)
        {
            this.expression = expression;
            this.lower = lower;
            this.upper = upper;
        }
        public Expression Expression
        {
            get { return this.expression; }
        }
        public Expression Lower
        {
            get { return this.lower; }
        }
        public Expression Upper
        {
            get { return this.upper; }
        }
    }

    public class RowNumberExpression : DbExpression
    {
        ReadOnlyCollection<OrderExpression> orderBy;
        public RowNumberExpression(IEnumerable<OrderExpression> orderBy)
            : base(DbExpressionType.RowCount, typeof(int))
        {
            this.orderBy = orderBy as ReadOnlyCollection<OrderExpression>;
            if (this.orderBy == null && orderBy != null)
            {
                this.orderBy = new List<OrderExpression>(orderBy).AsReadOnly();
            }
        }
        public ReadOnlyCollection<OrderExpression> OrderBy
        {
            get { return this.orderBy; }
        }
    }
    public class LimitExpression : DbExpression {
        public int Skip {
            get {
                return _skip;
            }
        }
        public int Take {
            get {
                return _take;
            }
        }
        int _skip;
        int _take;
        Expression value;
        public LimitExpression(int skip, int take, Expression value):base(DbExpressionType.Limit,value.Type) {
            _skip = skip;
            _take = take;
            this.value = value;
        }
        public Expression Value {
            get { return this.value; }
        }
    }
    public class NamedValueExpression : DbExpression
    {
        string name;
        Expression value;
        public NamedValueExpression(string name, Expression value)
            : base(DbExpressionType.NamedValue, value.Type)
        {
            this.name = name;
            this.value = value;
        }
        public string Name
        {
            get { return this.name; }
        }
        public Expression Value
        {
            get { return this.value; }
        }
    }

    /// <summary>
    /// A custom expression representing the construction of one or more result objects from a 
    /// SQL select expression
    /// </summary>
    public class ProjectionExpression : DbExpression
    {
        SelectExpression source;
        Expression projector;
        LambdaExpression aggregator;
        public ProjectionExpression(SelectExpression source, Expression projector)
            : this(source, projector, null)
        {
        }
        public ProjectionExpression( SelectExpression source, Expression projector, LambdaExpression aggregator)
            : base(DbExpressionType.Projection, aggregator != null ? aggregator.Body.Type : typeof(IEnumerable<>).MakeGenericType(projector.Type))
        {
            this.source = source;
            this.projector = projector;
            this.aggregator = aggregator;
        }
        public SelectExpression Source
        {
            get { return this.source; }
        }
        public Expression Projector
        {
            get { return this.projector; }
        }
        public LambdaExpression Aggregator
        {
            get { return this.aggregator; }
        }
        public bool IsSingleton
        {
            get { return this.aggregator != null && this.aggregator.Body.Type == projector.Type; }
        }
        public override string ToString()
        {
            return DbExpressionWriter.WriteToString(this);
        }
        public string QueryText
        {
            get { return TSqlFormatter.Format(source); }
        }
    }

    public class ClientJoinExpression : DbExpression
    {
        ReadOnlyCollection<Expression> outerKey;
        ReadOnlyCollection<Expression> innerKey;
        ProjectionExpression projection;

        public ClientJoinExpression(ProjectionExpression projection, IEnumerable<Expression> outerKey, IEnumerable<Expression> innerKey)
            : base(DbExpressionType.ClientJoin, projection.Type)
        {
            this.outerKey = outerKey as ReadOnlyCollection<Expression>;
            if (this.outerKey == null)
            {
                this.outerKey = new List<Expression>(outerKey).AsReadOnly();
            }
            this.innerKey = innerKey as ReadOnlyCollection<Expression>;
            if (this.innerKey == null)
            {
                this.innerKey = new List<Expression>(innerKey).AsReadOnly();
            }
            this.projection = projection;
        }

        public ReadOnlyCollection<Expression> OuterKey
        {
            get { return this.outerKey; }
        }

        public ReadOnlyCollection<Expression> InnerKey
        {
            get { return this.innerKey; }
        }

        public ProjectionExpression Projection
        {
            get { return this.projection; }
        }
    }

    public static class DbExpressionExtensions
    {
        public static SelectExpression SetColumns(this SelectExpression select, IEnumerable<ColumnDeclaration> columns)
        {
            return new SelectExpression(select.Alias, columns.OrderBy(c => c.Name), select.From, select.Where, select.OrderBy, select.GroupBy, select.IsDistinct, select.Skip, select.Take);
        }

        public static SelectExpression AddColumn(this SelectExpression select, ColumnDeclaration column)
        {
            List<ColumnDeclaration> columns = new List<ColumnDeclaration>(select.Columns);
            columns.Add(column);
            return select.SetColumns(columns);
        }

        public static SelectExpression RemoveColumn(this SelectExpression select, ColumnDeclaration column)
        {
            List<ColumnDeclaration> columns = new List<ColumnDeclaration>(select.Columns);
            columns.Remove(column);
            return select.SetColumns(columns);
        }

        public static string GetAvailableColumnName(this SelectExpression select, string baseName)
        {
            string name = baseName;
            int n = 0;
            while (!IsUniqueName(select, name))
            {
                name = baseName + (n++);
            }
            return name;
        }

        private static bool IsUniqueName(SelectExpression select, string name)
        {
            foreach (var col in select.Columns)
            {
                if (col.Name == name)
                {
                    return false;
                }
            }
            return true;
        }

        public static ProjectionExpression AddOuterJoinTest(this ProjectionExpression proj)
        {
            string colName = proj.Source.GetAvailableColumnName("Test");
            SelectExpression newSource = proj.Source.AddColumn(new ColumnDeclaration(colName, Expression.Constant(1, typeof(int?))));
            Expression newProjector = 
                new OuterJoinedExpression(
                    new ColumnExpression(typeof(int?), newSource.Alias, colName),
                    proj.Projector
                    );
            return new ProjectionExpression(newSource, newProjector, proj.Aggregator);
        }

        public static SelectExpression SetDistinct(this SelectExpression select, bool isDistinct)
        {
            if (select.IsDistinct != isDistinct)
            {
                return new SelectExpression(select.Alias, select.Columns, select.From, select.Where, select.OrderBy, select.GroupBy, isDistinct, select.Skip, select.Take);
            }
            return select;
        }

        public static SelectExpression SetWhere(this SelectExpression select, Expression where)
        {
            if (where != select.Where)
            {
                return new SelectExpression(select.Alias, select.Columns, select.From, where, select.OrderBy, select.GroupBy, select.IsDistinct, select.Skip, select.Take);
            }
            return select;
        }

        public static SelectExpression SetOrderBy(this SelectExpression select, IEnumerable<OrderExpression> orderBy)
        {
            return new SelectExpression(select.Alias, select.Columns, select.From, select.Where, orderBy, select.GroupBy, select.IsDistinct, select.Skip, select.Take);
        }

        public static SelectExpression AddOrderExpression(this SelectExpression select, OrderExpression ordering)
        {
            List<OrderExpression> orderby = new List<OrderExpression>();
            if (select.OrderBy != null)
                orderby.AddRange(select.OrderBy);
            orderby.Add(ordering);
            return select.SetOrderBy(orderby);
        }

        public static SelectExpression RemoveOrderExpression(this SelectExpression select, OrderExpression ordering)
        {
            if (select.OrderBy != null && select.OrderBy.Count > 0)
            {
                List<OrderExpression> orderby = new List<OrderExpression>(select.OrderBy);
                orderby.Remove(ordering);
                return select.SetOrderBy(orderby);
            }
            return select;
        }

        public static SelectExpression SetGroupBy(this SelectExpression select, IEnumerable<Expression> groupBy)
        {
            return new SelectExpression(select.Alias, select.Columns, select.From, select.Where, select.OrderBy, groupBy, select.IsDistinct, select.Skip, select.Take);
        }

        public static SelectExpression AddGroupExpression(this SelectExpression select, Expression expression)
        {
            List<Expression> groupby = new List<Expression>();
            if (select.GroupBy != null)
                groupby.AddRange(select.GroupBy);
            groupby.Add(expression);
            return select.SetGroupBy(groupby);
        }

        public static SelectExpression RemoveGroupExpression(this SelectExpression select, Expression expression)
        {
            if (select.GroupBy != null && select.GroupBy.Count > 0)
            {
                List<Expression> groupby = new List<Expression>(select.GroupBy);
                groupby.Remove(expression);
                return select.SetGroupBy(groupby);
            }
            return select;
        }

        public static SelectExpression SetSkip(this SelectExpression select, Expression skip)
        {
            if (skip != select.Skip)
            {
                
                return new SelectExpression(select.Alias, select.Columns, select.From, select.Where, select.OrderBy, select.GroupBy, select.IsDistinct, skip, select.Take);
            }
            return select;
        }

        public static SelectExpression SetTake(this SelectExpression select, Expression take)
        {
            if (take != select.Take)
            {
                return new SelectExpression(select.Alias, select.Columns, select.From, select.Where, select.OrderBy, select.GroupBy, select.IsDistinct, select.Skip, take);
            }
            return select;
        }

        public static SelectExpression AddRedundantSelect(this SelectExpression select, TableAlias newAlias)
        {
            var newColumns = select.Columns.Select(d => new ColumnDeclaration(d.Name, new ColumnExpression(d.Expression.Type, newAlias, d.Name)));
            var newFrom = new SelectExpression(newAlias, select.Columns, select.From, select.Where, select.OrderBy, select.GroupBy, select.IsDistinct, select.Skip, select.Take);
            return new SelectExpression(select.Alias, newColumns, newFrom, null, null, null, false, null, null);
        }

        public static SelectExpression RemoveRedundantFrom(this SelectExpression select)
        {
            SelectExpression fromSelect = select.From as SelectExpression;
            if (fromSelect != null)
            {
                return SubqueryRemover.Remove(select, fromSelect);
            }
            return select;
        }

        public static SelectExpression SetFrom(this SelectExpression select, Expression from)
        {
            if (select.From != from)
            {
                return new SelectExpression(select.Alias, select.Columns, from, select.Where, select.OrderBy, select.GroupBy, select.IsDistinct, select.Skip, select.Take);
            }
            return select;
        }
    }
}
