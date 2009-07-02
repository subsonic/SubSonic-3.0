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
using SubSonic.Linq.Structure;

namespace SubSonic.Linq.Translation
{
    /// <summary>
    /// Removes select expressions that don't add any additional semantic value
    /// </summary>
    public class RedundantSubqueryRemover : DbExpressionVisitor
    {
        private RedundantSubqueryRemover() 
        {
        }

        public static Expression Remove(Expression expression)
        {
            expression = new RedundantSubqueryRemover().Visit(expression);
            expression = SubqueryMerger.Merge(expression);
            return expression;
        }

        protected override Expression VisitSelect(SelectExpression select)
        {
            select = (SelectExpression)base.VisitSelect(select);

            // first remove all purely redundant subqueries
            List<SelectExpression> redundant = RedundantSubqueryGatherer.Gather(select.From);
            if (redundant != null)
            {
                select = SubqueryRemover.Remove(select, redundant);
            }

            return select;
        }

        protected override Expression VisitProjection(ProjectionExpression proj)
        {
            proj = (ProjectionExpression)base.VisitProjection(proj);
            if (proj.Source.From is SelectExpression) 
            {
                List<SelectExpression> redundant = RedundantSubqueryGatherer.Gather(proj.Source);
                if (redundant != null) 
                {
                    proj = SubqueryRemover.Remove(proj, redundant);
                }
            }
            return proj;
        }

        internal static bool IsSimpleProjection(SelectExpression select)
        {
            foreach (ColumnDeclaration decl in select.Columns)
            {
                ColumnExpression col = decl.Expression as ColumnExpression;
                if (col == null || decl.Name != col.Name)
                {
                    return false;
                }
            }
            return true;
        }

        internal static bool IsNameMapProjection(SelectExpression select)
        {
            if (select.From is TableExpression) return false;
            SelectExpression fromSelect = select.From as SelectExpression;
            if (fromSelect == null || select.Columns.Count != fromSelect.Columns.Count)
                return false;
            ReadOnlyCollection<ColumnDeclaration> fromColumns = fromSelect.Columns;
            // test that all columns in 'select' are refering to columns in the same position
            // in from.
            for (int i = 0, n = select.Columns.Count; i < n; i++)
            {
                ColumnExpression col = select.Columns[i].Expression as ColumnExpression;
                if (col == null || !(col.Name == fromColumns[i].Name))
                    return false;
            }
            return true;
        }

        internal static bool IsInitialProjection(SelectExpression select)
        {
            return select.From is TableExpression;
        }

        class RedundantSubqueryGatherer : DbExpressionVisitor
        {
            List<SelectExpression> redundant;

            private RedundantSubqueryGatherer()
            {
            }

            internal static List<SelectExpression> Gather(Expression source)
            {
                RedundantSubqueryGatherer gatherer = new RedundantSubqueryGatherer();
                gatherer.Visit(source);
                return gatherer.redundant;
            }

            private static bool IsRedudantSubquery(SelectExpression select)
            {
                return (IsSimpleProjection(select) || IsNameMapProjection(select))
                    && !select.IsDistinct
                    && select.Take == null
                    && select.Skip == null
                    && select.Where == null
                    && (select.OrderBy == null || select.OrderBy.Count == 0)
                    && (select.GroupBy == null || select.GroupBy.Count == 0);
            }

            protected override Expression VisitSelect(SelectExpression select)
            {
                if (IsRedudantSubquery(select))
                {
                    if (this.redundant == null)
                    {
                        this.redundant = new List<SelectExpression>();
                    }
                    this.redundant.Add(select);
                }
                return select;
            }

            protected override Expression VisitSubquery(SubqueryExpression subquery)
            {
                // don't gather inside scalar and exists
                return subquery;
            }
        }

        class SubqueryMerger : DbExpressionVisitor
        {
            private SubqueryMerger()
            {
            }

            internal static Expression Merge(Expression expression)
            {
                return new SubqueryMerger().Visit(expression);
            }

            bool isTopLevel = true;

            protected override Expression VisitSelect(SelectExpression select)
            {
                bool wasTopLevel = isTopLevel;
                isTopLevel = false;

                select = (SelectExpression)base.VisitSelect(select);

                // next attempt to merge subqueries that would have been removed by the above
                // logic except for the existence of a where clause
                while (CanMergeWithFrom(select, wasTopLevel))
                {
                    SelectExpression fromSelect = GetLeftMostSelect(select.From);

                    // remove the redundant subquery
                    select = SubqueryRemover.Remove(select, fromSelect);

                    // merge where expressions 
                    Expression where = select.Where;
                    if (fromSelect.Where != null)
                    {
                        if (where != null)
                        {
                            where = Expression.And(fromSelect.Where, where);
                        }
                        else
                        {
                            where = fromSelect.Where;
                        }
                    }
                    var orderBy = select.OrderBy != null && select.OrderBy.Count > 0 ? select.OrderBy : fromSelect.OrderBy;
                    var groupBy = select.GroupBy != null && select.GroupBy.Count > 0 ? select.GroupBy : fromSelect.GroupBy;
                    Expression skip = select.Skip != null ? select.Skip : fromSelect.Skip;
                    Expression take = select.Take != null ? select.Take : fromSelect.Take;
                    bool isDistinct = select.IsDistinct | fromSelect.IsDistinct;

                    if (where != select.Where
                        || orderBy != select.OrderBy
                        || groupBy != select.GroupBy
                        || isDistinct != select.IsDistinct
                        || skip != select.Skip
                        || take != select.Take)
                    {
                        select = new SelectExpression(select.Alias, select.Columns, select.From, where, orderBy, groupBy, isDistinct, skip, take);
                    }
                }

                return select;
            }

            private static SelectExpression GetLeftMostSelect(Expression source)
            {
                SelectExpression select = source as SelectExpression;
                if (select != null) return select;
                JoinExpression join = source as JoinExpression;
                if (join != null) return GetLeftMostSelect(join.Left);
                return null;
            }

            private static bool IsColumnProjection(SelectExpression select)
            {
                for (int i = 0, n = select.Columns.Count; i < n; i++)
                {
                    var cd = select.Columns[i];
                    if (cd.Expression.NodeType != (ExpressionType)DbExpressionType.Column &&
                        cd.Expression.NodeType != ExpressionType.Constant)
                        return false;
                }
                return true;
            }

            private static bool CanMergeWithFrom(SelectExpression select, bool isTopLevel)
            {
                SelectExpression fromSelect = GetLeftMostSelect(select.From);
                if (fromSelect == null)
                    return false;
                if (!IsColumnProjection(fromSelect))
                    return false;
                bool selHasNameMapProjection = IsNameMapProjection(select);
                bool selHasOrderBy = select.OrderBy != null && select.OrderBy.Count > 0;
                bool selHasGroupBy = select.GroupBy != null && select.GroupBy.Count > 0;
                bool selHasAggregates = AggregateChecker.HasAggregates(select);
                bool frmHasOrderBy = fromSelect.OrderBy != null && fromSelect.OrderBy.Count > 0;
                bool frmHasGroupBy = fromSelect.GroupBy != null && fromSelect.GroupBy.Count > 0;
                // both cannot have orderby
                if (selHasOrderBy && frmHasOrderBy)
                    return false;
                // both cannot have groupby
                if (selHasOrderBy && frmHasOrderBy)
                    return false;
                // cannot move forward order-by if outer has group-by
                if (frmHasOrderBy && (selHasGroupBy || selHasAggregates || select.IsDistinct))
                    return false;
                // cannot move forward group-by if outer has where clause
                if (frmHasGroupBy /*&& (select.Where != null)*/) // need to assert projection is the same in order to move group-by forward
                    return false;
                // cannot move forward a take if outer has take or skip or distinct
                if (fromSelect.Take != null && (select.Take != null || select.Skip != null || select.IsDistinct || selHasAggregates || selHasGroupBy))
                    return false;
                // cannot move forward a skip if outer has skip or distinct
                if (fromSelect.Skip != null && (select.Skip != null || select.IsDistinct || selHasAggregates || selHasGroupBy))
                    return false;
                // cannot move forward a distinct if outer has take, skip, groupby or a different projection
                if (fromSelect.IsDistinct && (select.Take != null || select.Skip != null || !selHasNameMapProjection || selHasGroupBy || selHasAggregates || (selHasOrderBy && !isTopLevel)))
                    return false;
                return true;
            }
        }
    }
}