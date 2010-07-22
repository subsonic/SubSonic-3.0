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
    /// Rewrites take and skip expressions into uses of TSQL row_number function
    /// </summary>
    public class SkipRewriter : DbExpressionVisitor
    {
        private SkipRewriter()
        {
        }

        public static Expression Rewrite(Expression expression)
        {
            return new SkipRewriter().Visit(expression);
        }

        protected override Expression VisitSelect(SelectExpression select)
        {
            select = (SelectExpression)base.VisitSelect(select);
            if (select.Skip != null)
            {
                SelectExpression newSelect = select.SetSkip(null).SetTake(null);
                bool canAddColumn = !select.IsDistinct && (select.GroupBy == null || select.GroupBy.Count == 0);
                if (!canAddColumn)
                {
                    newSelect = newSelect.AddRedundantSelect(new TableAlias());
                }
                newSelect = newSelect.AddColumn(new ColumnDeclaration("rownum", new RowNumberExpression(select.OrderBy)));

                // add layer for WHERE clause that references new rownum column
                newSelect = newSelect.AddRedundantSelect(new TableAlias());
                newSelect = newSelect.RemoveColumn(newSelect.Columns.Single(c => c.Name == "rownum"));

                var newAlias = ((SelectExpression)newSelect.From).Alias;
                ColumnExpression rnCol = new ColumnExpression(typeof(int), newAlias, "rownum");
                Expression where;
                if (select.Take != null)
                {
                    where = new BetweenExpression(rnCol, Expression.Add(select.Skip, Expression.Constant(1)), Expression.Add(select.Skip, select.Take));
                }
                else
                {
                    where = Expression.GreaterThan(rnCol, select.Skip);
                }
                if (newSelect.Where != null)
                {
                    where = Expression.And(newSelect.Where, where);
                }
                newSelect = newSelect.SetWhere(where);

                select = newSelect;
            }
            return select;
        }
    }
}