// Copyright (c) Microsoft Corporation.  All rights reserved.
// This source code is made available under the terms of the Microsoft Public License (MS-PL)
//Original code created by Matt Warren: http://iqtoolkit.codeplex.com/Release/ProjectReleases.aspx?ReleaseId=19725


using System.Linq.Expressions;
using SubSonic.Linq.Structure;

namespace SubSonic.Linq.Translation
{
    /// <summary>
    /// Rewrites nested singleton projection into server-side joins
    /// </summary>
    public class SingletonProjectionRewriter : DbExpressionVisitor
    {
        private readonly QueryLanguage language;
        private SelectExpression currentSelect;
        private bool isTopLevel = true;

        private SingletonProjectionRewriter(QueryLanguage language)
        {
            this.language = language;
        }

        public static Expression Rewrite(QueryLanguage language, Expression expression)
        {
            return new SingletonProjectionRewriter(language).Visit(expression);
        }

        protected override Expression VisitClientJoin(ClientJoinExpression join)
        {
            // treat client joins as new top level
            var saveTop = isTopLevel;
            var saveSelect = currentSelect;
            isTopLevel = true;
            currentSelect = null;
            Expression result = base.VisitClientJoin(join);
            isTopLevel = saveTop;
            currentSelect = saveSelect;
            return result;
        }

        protected override Expression VisitProjection(ProjectionExpression proj)
        {
            if (isTopLevel)
            {
                isTopLevel = false;
                currentSelect = proj.Source;
                Expression projector = Visit(proj.Projector);
                if (projector != proj.Projector || currentSelect != proj.Source)
                {
                    return new ProjectionExpression(currentSelect, projector, proj.Aggregator);
                }
                return proj;
            }

            if (proj.IsSingleton && CanJoinOnServer(currentSelect))
            {
                TableAlias newAlias = new TableAlias();
                currentSelect = currentSelect.AddRedundantSelect(newAlias);

                // remap any references to the outer select to the new alias;
                SelectExpression source =
                    (SelectExpression) ColumnMapper.Map(proj.Source, newAlias, currentSelect.Alias);

                // add outer-join test
                ProjectionExpression pex = new ProjectionExpression(source, proj.Projector).AddOuterJoinTest();

                var pc = ColumnProjector.ProjectColumns(language.CanBeColumn, pex.Projector, currentSelect.Columns,
                                                        currentSelect.Alias, newAlias, proj.Source.Alias);

                JoinExpression join = new JoinExpression(JoinType.OuterApply, currentSelect.From, pex.Source, null);

                currentSelect = new SelectExpression(currentSelect.Alias, pc.Columns, join, null);
                return Visit(pc.Projector);
            }

            var saveTop = isTopLevel;
            var saveSelect = currentSelect;
            isTopLevel = true;
            currentSelect = null;
            Expression result = base.VisitProjection(proj);
            isTopLevel = saveTop;
            currentSelect = saveSelect;
            return result;
        }

        private static bool CanJoinOnServer(SelectExpression select)
        {
            // can add singleton (1:0,1) join if no grouping/aggregates or distinct
            return !select.IsDistinct
                   && (select.GroupBy == null || select.GroupBy.Count == 0)
                   && !AggregateChecker.HasAggregates(select);
        }

        protected override Expression VisitSubquery(SubqueryExpression subquery)
        {
            return subquery;
        }
    }
}