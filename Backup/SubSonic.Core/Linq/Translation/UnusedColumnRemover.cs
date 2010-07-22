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
    /// Removes column declarations in SelectExpression's that are not referenced
    /// </summary>
    public class UnusedColumnRemover : DbExpressionVisitor
    {
        Dictionary<TableAlias, HashSet<string>> allColumnsUsed;

        private UnusedColumnRemover()
        {
            this.allColumnsUsed = new Dictionary<TableAlias, HashSet<string>>();
        }

        public static Expression Remove(Expression expression) 
        {
            return new UnusedColumnRemover().Visit(expression);
        }

        private void MarkColumnAsUsed(TableAlias alias, string name)
        {
            HashSet<string> columns;
            if (!this.allColumnsUsed.TryGetValue(alias, out columns))
            {
                columns = new HashSet<string>();
                this.allColumnsUsed.Add(alias, columns);
            }
            columns.Add(name);
        }

        private bool IsColumnUsed(TableAlias alias, string name)
        {
            HashSet<string> columnsUsed;
            if (this.allColumnsUsed.TryGetValue(alias, out columnsUsed))
            {
                if (columnsUsed != null)
                {
                    return columnsUsed.Contains(name);
                }
            }
            return false;
        }

        private void ClearColumnsUsed(TableAlias alias)
        {
            this.allColumnsUsed[alias] = new HashSet<string>();
        }

        protected override Expression VisitColumn(ColumnExpression column)
        {
            MarkColumnAsUsed(column.Alias, column.Name);
            return column;
        }

        protected override Expression VisitSubquery(SubqueryExpression subquery) 
        {
            if ((subquery.NodeType == (ExpressionType)DbExpressionType.Scalar ||
                subquery.NodeType == (ExpressionType)DbExpressionType.In) &&
                subquery.Select != null) 
            {
                System.Diagnostics.Debug.Assert(subquery.Select.Columns.Count == 1);
                MarkColumnAsUsed(subquery.Select.Alias, subquery.Select.Columns[0].Name);
            }
 	        return base.VisitSubquery(subquery);
        }

        protected override Expression VisitSelect(SelectExpression select)
        {
            // visit column projection first
            ReadOnlyCollection<ColumnDeclaration> columns = select.Columns;

            List<ColumnDeclaration> alternate = null;
            for (int i = 0, n = select.Columns.Count; i < n; i++)
            {
                ColumnDeclaration decl = select.Columns[i];
                if (select.IsDistinct || IsColumnUsed(select.Alias, decl.Name))
                {
                    Expression expr = this.Visit(decl.Expression);
                    if (expr != decl.Expression)
                    {
                        decl = new ColumnDeclaration(decl.Name, expr);
                    }
                }
                else
                {
                    decl = null;  // null means it gets omitted
                }
                if (decl != select.Columns[i] && alternate == null)
                {
                    alternate = new List<ColumnDeclaration>();
                    for (int j = 0; j < i; j++)
                    {
                        alternate.Add(select.Columns[j]);
                    }
                }
                if (decl != null && alternate != null)
                {
                    alternate.Add(decl);
                }
            }
            if (alternate != null)
            {
                columns = alternate.AsReadOnly();
            }

            Expression take = this.Visit(select.Take);
            Expression skip = this.Visit(select.Skip);
            ReadOnlyCollection<Expression> groupbys = this.VisitExpressionList(select.GroupBy);
            ReadOnlyCollection<OrderExpression> orderbys = this.VisitOrderBy(select.OrderBy);
            Expression where = this.Visit(select.Where);
            Expression from = this.Visit(select.From);

            ClearColumnsUsed(select.Alias);

            if (columns != select.Columns 
                || take != select.Take 
                || skip != select.Skip
                || orderbys != select.OrderBy 
                || groupbys != select.GroupBy
                || where != select.Where 
                || from != select.From)
            {
                select = new SelectExpression(select.Alias, columns, from, where, orderbys, groupbys, select.IsDistinct, skip, take);
            }

            return select;
        }

        protected override Expression VisitProjection(ProjectionExpression projection)
        {
            // visit mapping in reverse order
            Expression projector = this.Visit(projection.Projector);
            SelectExpression source = (SelectExpression)this.Visit(projection.Source);
            if (projector != projection.Projector || source != projection.Source)
            {
                return new ProjectionExpression(source, projector, projection.Aggregator);
            }
            return projection;
        }

        protected override Expression VisitClientJoin(ClientJoinExpression join)
        {
            var innerKey = this.VisitExpressionList(join.InnerKey);
            var outerKey = this.VisitExpressionList(join.OuterKey);
            ProjectionExpression projection = (ProjectionExpression)this.Visit(join.Projection);
            if (projection != join.Projection || innerKey != join.InnerKey || outerKey != join.OuterKey)
            {
                return new ClientJoinExpression(projection, outerKey, innerKey);
            }
            return join;
        }

        protected override Expression VisitJoin(JoinExpression join)
        {
            // visit join in reverse order
            Expression condition = this.Visit(join.Condition);
            Expression right = this.VisitSource(join.Right);
            Expression left = this.VisitSource(join.Left);
            if (left != join.Left || right != join.Right || condition != join.Condition)
            {
                return new JoinExpression(join.Join, left, right, condition);
            }
            return join;
        }
    }
}