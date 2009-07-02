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
    /// Translates accesses to relationship members into projections or joins
    /// </summary>
    public class RelationshipBinder : DbExpressionVisitor
    {
        QueryMapping mapping;
        Expression currentFrom;

        private RelationshipBinder(QueryMapping mapping)
        {
            this.mapping = mapping;
        }

        public static Expression Bind(QueryMapping mapping, Expression expression)
        {
            return new RelationshipBinder(mapping).Visit(expression);
        }

        protected override Expression VisitSelect(SelectExpression select)
        {
            Expression saveCurrentFrom = this.currentFrom;
            this.currentFrom = this.VisitSource(select.From);
            try
            {
                Expression where = this.Visit(select.Where);
                ReadOnlyCollection<OrderExpression> orderBy = this.VisitOrderBy(select.OrderBy);
                ReadOnlyCollection<Expression> groupBy = this.VisitExpressionList(select.GroupBy);
                Expression skip = this.Visit(select.Skip);
                Expression take = this.Visit(select.Take);
                ReadOnlyCollection<ColumnDeclaration> columns = this.VisitColumnDeclarations(select.Columns);
                if (this.currentFrom != select.From
                    || where != select.Where
                    || orderBy != select.OrderBy
                    || groupBy != select.GroupBy
                    || take != select.Take
                    || skip != select.Skip
                    || columns != select.Columns
                    )
                {
                    return new SelectExpression(select.Alias, columns, this.currentFrom, where, orderBy, groupBy, select.IsDistinct, skip, take);
                }
                return select;
            }
            finally
            {
                this.currentFrom = saveCurrentFrom;
            }
        }

        protected override Expression VisitMemberAccess(MemberExpression m)
        {
            Expression source = this.Visit(m.Expression);

            if (this.mapping.IsRelationship(m.Member))
            {
                ProjectionExpression projection = (ProjectionExpression)this.Visit(this.mapping.GetMemberExpression(source, m.Member));
                if (this.currentFrom != null && this.mapping.IsSingletonRelationship(m.Member))
                {
                    // convert singleton associations directly to OUTER APPLY
                    projection = projection.AddOuterJoinTest();
                    Expression newFrom = new JoinExpression(JoinType.OuterApply, this.currentFrom, projection.Source, null);
                    this.currentFrom = newFrom;
                    return projection.Projector;
                }
                return projection;
            }
            else
            {
                Expression result = QueryBinder.BindMember(source, m.Member);
                MemberExpression mex = result as MemberExpression;
                if (mex != null && mex.Member == m.Member && mex.Expression == m.Expression)
                {
                    return m;
                }
                return result;
            }
        }
    }
}
