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
    public class CountOrderByRemover : DbExpressionVisitor
    {
        Dictionary<TableAlias, HashSet<string>> allColumnsUsed;


        public static Expression Remove(Expression expression) 
        {
            return new CountOrderByRemover().Visit(expression);
        }


        protected override Expression VisitSelect(SelectExpression select)
        {
            // visit column projection first
            ReadOnlyCollection<ColumnDeclaration> columns = select.Columns;

            Expression take = this.Visit(select.Take);
            Expression skip = this.Visit(select.Skip);
            ReadOnlyCollection<Expression> groupbys = this.VisitExpressionList(select.GroupBy);
            ReadOnlyCollection<OrderExpression> orderbys = this.VisitOrderBy(select.OrderBy);
            Expression where = this.Visit(select.Where);
            Expression from = this.Visit(select.From);

            if (columns.Count == 1 && orderbys!=null) {
                if (columns[0].Expression.ToString() == "COUNT(*)" && orderbys.Count > 0) {
                    var newOrders=new OrderExpression[0];
                    //this is is COUNT/ORDER BY/GROUP BY issue
                    select = new SelectExpression(select.Alias, columns, from, where, newOrders, groupbys, select.IsDistinct, skip, take);
                    return select;
                }
            }

            return select;
        }



    }
}