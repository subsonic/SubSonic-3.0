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

namespace SubSonic.Linq.Structure
{
    /// <summary>
    /// An extended expression visitor including custom DbExpression nodes
    /// </summary>
    public abstract class DbExpressionVisitor : ExpressionVisitor
    {
        protected override Expression Visit(Expression exp)
        {
            if (exp == null)
            {
                return null;
            }
            switch ((DbExpressionType)exp.NodeType)
            {
                case DbExpressionType.Table:
                    return this.VisitTable((TableExpression)exp);
                case DbExpressionType.Column:
                    return this.VisitColumn((ColumnExpression)exp);
                case DbExpressionType.Select:
                    return this.VisitSelect((SelectExpression)exp);
                case DbExpressionType.Join:
                    return this.VisitJoin((JoinExpression)exp);
                case DbExpressionType.OuterJoined:
                    return this.VisitOuterJoined((OuterJoinedExpression)exp);
                case DbExpressionType.Aggregate:
                    return this.VisitAggregate((AggregateExpression)exp);
                case DbExpressionType.Scalar:
                case DbExpressionType.Exists:
                case DbExpressionType.In:
                    return this.VisitSubquery((SubqueryExpression)exp);
                case DbExpressionType.AggregateSubquery:
                    return this.VisitAggregateSubquery((AggregateSubqueryExpression)exp);
                case DbExpressionType.IsNull:
                    return this.VisitIsNull((IsNullExpression)exp);
                case DbExpressionType.Between:
                    return this.VisitBetween((BetweenExpression)exp);
                case DbExpressionType.RowCount:
                    return this.VisitRowNumber((RowNumberExpression)exp);
                case DbExpressionType.Projection:
                    return this.VisitProjection((ProjectionExpression)exp);
                case DbExpressionType.NamedValue:
                    return this.VisitNamedValue((NamedValueExpression)exp);
                case DbExpressionType.ClientJoin:
                    return this.VisitClientJoin((ClientJoinExpression)exp);
                default:
                    return base.Visit(exp);
            }
        }
        protected virtual Expression VisitTable(TableExpression table)
        {
            return table;
        }
        protected virtual Expression VisitColumn(ColumnExpression column)
        {
            return column;
        }
        protected virtual Expression VisitSelect(SelectExpression select)
        {
            Expression from = this.VisitSource(select.From);
            Expression where = this.Visit(select.Where);
            ReadOnlyCollection<OrderExpression> orderBy = this.VisitOrderBy(select.OrderBy);
            ReadOnlyCollection<Expression> groupBy = this.VisitExpressionList(select.GroupBy);
            Expression skip = this.Visit(select.Skip);
            Expression take = this.Visit(select.Take);
            ReadOnlyCollection<ColumnDeclaration> columns = this.VisitColumnDeclarations(select.Columns);
            if (from != select.From
                || where != select.Where
                || orderBy != select.OrderBy
                || groupBy != select.GroupBy
                || take != select.Take
                || skip != select.Skip
                || columns != select.Columns
                )
            {
                return new SelectExpression(select.Alias, columns, from, where, orderBy, groupBy, select.IsDistinct, skip, take);
            }
            return select;
        }
        protected virtual Expression VisitJoin(JoinExpression join)
        {
            Expression left = this.VisitSource(join.Left);
            Expression right = this.VisitSource(join.Right);
            Expression condition = this.Visit(join.Condition);
            if (left != join.Left || right != join.Right || condition != join.Condition)
            {
                return new JoinExpression(join.Join, left, right, condition);
            }
            return join;
        }
        protected virtual Expression VisitOuterJoined(OuterJoinedExpression outer)
        {
            Expression test = this.Visit(outer.Test);
            Expression expression = this.Visit(outer.Expression);
            if (test != outer.Test || expression != outer.Expression)
            {
                return new OuterJoinedExpression(test, expression);
            }
            return outer;
        }
        protected virtual Expression VisitAggregate(AggregateExpression aggregate)
        {
            Expression arg = this.Visit(aggregate.Argument);
            if (arg != aggregate.Argument)
            {
                return new AggregateExpression(aggregate.Type, aggregate.AggregateType, arg, aggregate.IsDistinct);
            }
            return aggregate;
        }
        protected virtual Expression VisitIsNull(IsNullExpression isnull)
        {
            Expression expr = this.Visit(isnull.Expression);
            if (expr != isnull.Expression)
            {
                return new IsNullExpression(expr);
            }
            return isnull;
        }
        protected virtual Expression VisitBetween(BetweenExpression between)
        {
            Expression expr = this.Visit(between.Expression);
            Expression lower = this.Visit(between.Lower);
            Expression upper = this.Visit(between.Upper);
            if (expr != between.Expression || lower != between.Lower || upper != between.Upper)
            {
                return new BetweenExpression(expr, lower, upper);
            }
            return between;
        }
        protected virtual Expression VisitRowNumber(RowNumberExpression rowNumber)
        {
            var orderby = this.VisitOrderBy(rowNumber.OrderBy);
            if (orderby != rowNumber.OrderBy)
            {
                return new RowNumberExpression(orderby);
            }
            return rowNumber;
        }
        protected virtual Expression VisitNamedValue(NamedValueExpression value)
        {
            return value;
        }
        protected virtual Expression VisitSubquery(SubqueryExpression subquery)
        {
            switch ((DbExpressionType)subquery.NodeType)
            {
                case DbExpressionType.Scalar:
                    return this.VisitScalar((ScalarExpression)subquery);
                case DbExpressionType.Exists:
                    return this.VisitExists((ExistsExpression)subquery);
                case DbExpressionType.In:
                    return this.VisitIn((InExpression)subquery);
            }
            return subquery;
        }

        protected virtual Expression VisitScalar(ScalarExpression scalar)
        {
            SelectExpression select = (SelectExpression)this.Visit(scalar.Select);
            if (select != scalar.Select)
            {
                return new ScalarExpression(scalar.Type, select);
            }
            return scalar;
        }

        protected virtual Expression VisitExists(ExistsExpression exists)
        {
            SelectExpression select = (SelectExpression)this.Visit(exists.Select);
            if (select != exists.Select)
            {
                return new ExistsExpression(select);
            }
            return exists;
        }

        protected virtual Expression VisitIn(InExpression @in)
        {
            Expression expr = this.Visit(@in.Expression);
            if (@in.Select != null)
            {
                SelectExpression select = (SelectExpression)this.Visit(@in.Select);
                if (expr != @in.Expression || select != @in.Select)
                {
                    return new InExpression(expr, select);
                }
            }
            else
            {
                IEnumerable<Expression> values = this.VisitExpressionList(@in.Values);
                if (expr != @in.Expression || values != @in.Values)
                {
                    return new InExpression(expr, values);
                }
            }
            return @in;
        }

        protected virtual Expression VisitAggregateSubquery(AggregateSubqueryExpression aggregate)
        {
            Expression e = this.Visit(aggregate.AggregateAsSubquery);
            System.Diagnostics.Debug.Assert(e is ScalarExpression);
            ScalarExpression subquery = (ScalarExpression)e;
            if (subquery != aggregate.AggregateAsSubquery)
            {
                return new AggregateSubqueryExpression(aggregate.GroupByAlias, aggregate.AggregateInGroupSelect, subquery);
            }
            return aggregate;
        }

        protected virtual Expression VisitSource(Expression source)
        {
            return this.Visit(source);
        }

        protected virtual Expression VisitProjection(ProjectionExpression proj)
        {
            SelectExpression source = (SelectExpression)this.Visit(proj.Source);
            Expression projector = this.Visit(proj.Projector);
            if (source != proj.Source || projector != proj.Projector)
            {
                return new ProjectionExpression(source, projector, proj.Aggregator);
            }
            return proj;
        }

        protected virtual Expression VisitClientJoin(ClientJoinExpression join)
        {
            ProjectionExpression projection = (ProjectionExpression)this.Visit(join.Projection);
            var outerKey = this.VisitExpressionList(join.OuterKey);
            var innerKey = this.VisitExpressionList(join.InnerKey);
            if (projection != join.Projection || outerKey != join.OuterKey || innerKey != join.InnerKey)
            {
                return new ClientJoinExpression(projection, outerKey, innerKey);
            }
            return join;
        }

        protected virtual ReadOnlyCollection<ColumnDeclaration> VisitColumnDeclarations(ReadOnlyCollection<ColumnDeclaration> columns)
        {
            List<ColumnDeclaration> alternate = null;
            for (int i = 0, n = columns.Count; i < n; i++)
            {
                ColumnDeclaration column = columns[i];
                Expression e = this.Visit(column.Expression);
                if (alternate == null && e != column.Expression)
                {
                    alternate = columns.Take(i).ToList();
                }
                if (alternate != null)
                {
                    alternate.Add(new ColumnDeclaration(column.Name, e));
                }
            }
            if (alternate != null)
            {
                return alternate.AsReadOnly();
            }
            return columns;
        }

        protected virtual ReadOnlyCollection<OrderExpression> VisitOrderBy(ReadOnlyCollection<OrderExpression> expressions)
        {
            if (expressions != null)
            {
                List<OrderExpression> alternate = null;
                for (int i = 0, n = expressions.Count; i < n; i++)
                {
                    OrderExpression expr = expressions[i];
                    Expression e = this.Visit(expr.Expression);
                    if (alternate == null && e != expr.Expression)
                    {
                        alternate = expressions.Take(i).ToList();
                    }
                    if (alternate != null)
                    {
                        alternate.Add(new OrderExpression(expr.OrderType, e));
                    }
                }
                if (alternate != null)
                {
                    return alternate.AsReadOnly();
                }
            }
            return expressions;
        }
    }
}