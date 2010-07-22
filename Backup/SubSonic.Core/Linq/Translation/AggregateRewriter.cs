// Copyright (c) Microsoft Corporation.  All rights reserved.
// This source code is made available under the terms of the Microsoft Public License (MS-PL)
//Original code created by Matt Warren: http://iqtoolkit.codeplex.com/Release/ProjectReleases.aspx?ReleaseId=19725


using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using SubSonic.Linq.Structure;

namespace SubSonic.Linq.Translation
{
    /// <summary>
    /// Rewrite aggregate expressions, moving them into same select expression that has the group-by clause
    /// </summary>
    public class AggregateRewriter : DbExpressionVisitor
    {
        ILookup<TableAlias, AggregateSubqueryExpression> lookup;
        Dictionary<AggregateSubqueryExpression, Expression> map;

        private AggregateRewriter(Expression expr)
        {
            this.map = new Dictionary<AggregateSubqueryExpression, Expression>();
            this.lookup = AggregateGatherer.Gather(expr).ToLookup(a => a.GroupByAlias);
        }

        public static Expression Rewrite(Expression expr)
        {
            return new AggregateRewriter(expr).Visit(expr);
        }

        protected override Expression VisitSelect(SelectExpression select)
        {
            select = (SelectExpression)base.VisitSelect(select);
            if (lookup.Contains(select.Alias))
            {
                List<ColumnDeclaration> aggColumns = new List<ColumnDeclaration>(select.Columns);
                foreach (AggregateSubqueryExpression ae in lookup[select.Alias])
                {
                    string name = "agg" + aggColumns.Count;
                    ColumnDeclaration cd = new ColumnDeclaration(name, ae.AggregateInGroupSelect);
                    this.map.Add(ae, new ColumnExpression(ae.Type, ae.GroupByAlias, name));
                    aggColumns.Add(cd);
                }
                return new SelectExpression(select.Alias, aggColumns, select.From, select.Where, select.OrderBy, select.GroupBy, select.IsDistinct, select.Skip, select.Take);
            }
            return select;
        }

        protected override Expression VisitAggregateSubquery(AggregateSubqueryExpression aggregate)
        {
            Expression mapped;
            if (this.map.TryGetValue(aggregate, out mapped))
            {
                return mapped;
            }
            return this.Visit(aggregate.AggregateAsSubquery);
        }

        class AggregateGatherer : DbExpressionVisitor
        {
            List<AggregateSubqueryExpression> aggregates = new List<AggregateSubqueryExpression>();
            private AggregateGatherer()
            {
            }

            internal static List<AggregateSubqueryExpression> Gather(Expression expression)
            {
                AggregateGatherer gatherer = new AggregateGatherer();
                gatherer.Visit(expression);
                return gatherer.aggregates;
            }

            protected override Expression VisitAggregateSubquery(AggregateSubqueryExpression aggregate)
            {
                this.aggregates.Add(aggregate);
                return base.VisitAggregateSubquery(aggregate);
            }
        }
    }
}