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
    /// rewrites nested projections into client-side joins
    /// </summary>
    public class ClientJoinedProjectionRewriter : DbExpressionVisitor
    {
        QueryLanguage language;
        bool isTopLevel = true;
        SelectExpression currentSelect;

        private ClientJoinedProjectionRewriter(QueryLanguage language)
        {
            this.language = language;
        }

        public static Expression Rewrite(QueryLanguage language, Expression expression)
        {
            return new ClientJoinedProjectionRewriter(language).Visit(expression);
        }

        protected override Expression VisitProjection(ProjectionExpression proj)
        {
            SelectExpression save = this.currentSelect;
            this.currentSelect = proj.Source;
            try
            {
                if (!this.isTopLevel)
                {
                    if (this.CanJoinOnClient(this.currentSelect))
                    {
                        // make a query that combines all the constraints from the outer queries into a single select
                        SelectExpression newOuterSelect = (SelectExpression)QueryDuplicator.Duplicate(save);

                        // remap any references to the outer select to the new alias;
                        SelectExpression newInnerSelect = (SelectExpression)ColumnMapper.Map(proj.Source, newOuterSelect.Alias, save.Alias);
                        // add outer-join test
                        ProjectionExpression newInnerProjection = new ProjectionExpression(newInnerSelect, proj.Projector).AddOuterJoinTest();
                        newInnerSelect = newInnerProjection.Source;
                        Expression newProjector = newInnerProjection.Projector;

                        TableAlias newAlias = new TableAlias();
                        var pc = ColumnProjector.ProjectColumns(this.language.CanBeColumn, newProjector, newOuterSelect.Columns, newAlias, newOuterSelect.Alias, newInnerSelect.Alias);
                        JoinExpression join = new JoinExpression(JoinType.OuterApply, newOuterSelect, newInnerSelect, null);
                        SelectExpression joinedSelect = new SelectExpression(newAlias, pc.Columns, join, null, null, null, proj.IsSingleton, null, null);

                        // apply client-join treatment recursively
                        this.currentSelect = joinedSelect;
                        newProjector = this.Visit(pc.Projector); 

                        // compute keys (this only works if join condition was a single column comparison)
                        List<Expression> outerKeys = new List<Expression>();
                        List<Expression> innerKeys = new List<Expression>();
                        if (this.GetEquiJoinKeyExpressions(newInnerSelect.Where, newOuterSelect.Alias, outerKeys, innerKeys))
                        {
                            // outerKey needs to refer to the outer-scope's alias
                            var outerKey = outerKeys.Select(k => ColumnMapper.Map(k, save.Alias, newOuterSelect.Alias));
                            // innerKey needs to refer to the new alias for the select with the new join
                            var innerKey = innerKeys.Select(k => ColumnMapper.Map(k, joinedSelect.Alias, ((ColumnExpression)k).Alias));
                            ProjectionExpression newProjection = new ProjectionExpression(joinedSelect, newProjector, proj.Aggregator);
                            return new ClientJoinExpression(newProjection, outerKey, innerKey);
                        }
                    }
                }
                else
                {
                    this.isTopLevel = false;
                }

                return base.VisitProjection(proj);
            }
            finally 
            {
                this.currentSelect = save;
            }
        }

        private bool CanJoinOnClient(SelectExpression select)
        {
            // can add singleton (1:0,1) join if no grouping/aggregates or distinct
            return !select.IsDistinct
                && (select.GroupBy == null || select.GroupBy.Count == 0)
                && !AggregateChecker.HasAggregates(select);
        }

        private bool GetEquiJoinKeyExpressions(Expression predicate, TableAlias outerAlias, List<Expression> outerExpressions, List<Expression> innerExpressions)
        {
            // predicate can be AND's and EQUAL's between columns
            BinaryExpression b = predicate as BinaryExpression;
            if (b != null)
            {
                switch (predicate.NodeType)
                {
                    case ExpressionType.And:
                    case ExpressionType.AndAlso:
                        return this.GetEquiJoinKeyExpressions(b.Left, outerAlias, outerExpressions, innerExpressions)
                            && this.GetEquiJoinKeyExpressions(b.Right, outerAlias, outerExpressions, innerExpressions);
                    case ExpressionType.Equal:
                        ColumnExpression left = b.Left as ColumnExpression;
                        ColumnExpression right = b.Right as ColumnExpression;
                        if (left != null && right != null)
                        {
                            if (left.Alias == outerAlias)
                            {
                                outerExpressions.Add(left);
                                innerExpressions.Add(right);
                                return true;
                            }
                            else if (right.Alias == outerAlias)
                            {
                                innerExpressions.Add(left);
                                outerExpressions.Add(right);
                                return true;
                            }
                        }
                        break;
                }
            }
            return false;
        }

        protected override Expression VisitSubquery(SubqueryExpression subquery)
        {
            return subquery;
        }
    }
}