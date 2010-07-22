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
    /// Duplicate the query expression by making a copy with new table aliases
    /// </summary>
    public class QueryDuplicator : DbExpressionVisitor
    {
        Dictionary<TableAlias, TableAlias> map = new Dictionary<TableAlias, TableAlias>();

        public static Expression Duplicate(Expression expression)
        {
            return new QueryDuplicator().Visit(expression);
        }

        protected override Expression VisitTable(TableExpression table)
        {
            TableAlias newAlias = new TableAlias();
            this.map[table.Alias] = newAlias;
            return new TableExpression(newAlias, table.Name);
        }

        protected override Expression VisitSelect(SelectExpression select)
        {
            TableAlias newAlias = new TableAlias();
            this.map[select.Alias] = newAlias;
            select = (SelectExpression)base.VisitSelect(select);
            return new SelectExpression(newAlias, select.Columns, select.From, select.Where, select.OrderBy, select.GroupBy, select.IsDistinct, select.Skip, select.Take);
        }

        protected override Expression VisitColumn(ColumnExpression column)
        {
            TableAlias newAlias;
            if (this.map.TryGetValue(column.Alias, out newAlias))
            {
                return new ColumnExpression(column.Type, newAlias, column.Name);
            }
            return column;
        }
    }
}