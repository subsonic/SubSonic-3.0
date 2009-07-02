// Copyright (c) Microsoft Corporation.  All rights reserved.
// This source code is made available under the terms of the Microsoft Public License (MS-PL)
//Original code created by Matt Warren: http://iqtoolkit.codeplex.com/Release/ProjectReleases.aspx?ReleaseId=19725


using System.Collections.ObjectModel;
using System.Linq;
using System.Linq.Expressions;
using SubSonic.Linq.Translation;

namespace SubSonic.Linq.Structure
{
    /// <summary>
    /// Determines if two expressions are equivalent. Supports DbExpression nodes.
    /// </summary>
    public class DbExpressionComparer : ExpressionComparer
    {
        private ScopedDictionary<TableAlias, TableAlias> aliasScope;

        protected DbExpressionComparer(ScopedDictionary<ParameterExpression, ParameterExpression> parameterScope,
                                       ScopedDictionary<TableAlias, TableAlias> aliasScope)
            : base(parameterScope)
        {
            this.aliasScope = aliasScope;
        }

        public new static bool AreEqual(Expression a, Expression b)
        {
            return AreEqual(null, null, a, b);
        }

        public static bool AreEqual(ScopedDictionary<ParameterExpression, ParameterExpression> parameterScope,
                                    ScopedDictionary<TableAlias, TableAlias> aliasScope, Expression a, Expression b)
        {
            return new DbExpressionComparer(parameterScope, aliasScope).Compare(a, b);
        }

        protected override bool Compare(Expression a, Expression b)
        {
            if (a == b)
                return true;
            if (a == null || b == null)
                return false;
            if (a.NodeType != b.NodeType)
                return false;
            if (a.Type != b.Type)
                return false;
            switch ((DbExpressionType) a.NodeType)
            {
                case DbExpressionType.Table:
                    return CompareTable((TableExpression) a, (TableExpression) b);
                case DbExpressionType.Column:
                    return CompareColumn((ColumnExpression) a, (ColumnExpression) b);
                case DbExpressionType.Select:
                    return CompareSelect((SelectExpression) a, (SelectExpression) b);
                case DbExpressionType.Join:
                    return CompareJoin((JoinExpression) a, (JoinExpression) b);
                case DbExpressionType.Aggregate:
                    return CompareAggregate((AggregateExpression) a, (AggregateExpression) b);
                case DbExpressionType.Scalar:
                case DbExpressionType.Exists:
                case DbExpressionType.In:
                    return CompareSubquery((SubqueryExpression) a, (SubqueryExpression) b);
                case DbExpressionType.AggregateSubquery:
                    return CompareAggregateSubquery((AggregateSubqueryExpression) a, (AggregateSubqueryExpression) b);
                case DbExpressionType.IsNull:
                    return CompareIsNull((IsNullExpression) a, (IsNullExpression) b);
                case DbExpressionType.Between:
                    return CompareBetween((BetweenExpression) a, (BetweenExpression) b);
                case DbExpressionType.RowCount:
                    return CompareRowNumber((RowNumberExpression) a, (RowNumberExpression) b);
                case DbExpressionType.Projection:
                    return CompareProjection((ProjectionExpression) a, (ProjectionExpression) b);
                case DbExpressionType.NamedValue:
                    return CompareNamedValue((NamedValueExpression) a, (NamedValueExpression) b);
                default:
                    return base.Compare(a, b);
            }
        }

        protected virtual bool CompareTable(TableExpression a, TableExpression b)
        {
            return a.Name == b.Name;
        }

        protected virtual bool CompareColumn(ColumnExpression a, ColumnExpression b)
        {
            return CompareAlias(a.Alias, b.Alias) && a.Name == b.Name;
        }

        protected virtual bool CompareAlias(TableAlias a, TableAlias b)
        {
            if (aliasScope != null)
            {
                TableAlias mapped;
                if (aliasScope.TryGetValue(a, out mapped))
                    return mapped == b;
            }
            return a == b;
        }

        protected virtual bool CompareSelect(SelectExpression a, SelectExpression b)
        {
            var save = aliasScope;
            try
            {
                if (!Compare(a.From, b.From))
                    return false;

                aliasScope = new ScopedDictionary<TableAlias, TableAlias>(save);
                MapAliases(a.From, b.From);

                return Compare(a.Where, b.Where)
                       && CompareOrderList(a.OrderBy, b.OrderBy)
                       && CompareExpressionList(a.GroupBy, b.GroupBy)
                       && Compare(a.Skip, b.Skip)
                       && Compare(a.Take, b.Take)
                       && a.IsDistinct == b.IsDistinct
                       && CompareColumnDeclarations(a.Columns, b.Columns);
            }
            finally
            {
                aliasScope = save;
            }
        }

        private void MapAliases(Expression a, Expression b)
        {
            TableAlias[] prodA = DeclaredAliasGatherer.Gather(a).ToArray();
            TableAlias[] prodB = DeclaredAliasGatherer.Gather(b).ToArray();
            for (int i = 0, n = prodA.Length; i < n; i++)
            {
                aliasScope.Add(prodA[i], prodB[i]);
            }
        }

        protected virtual bool CompareOrderList(ReadOnlyCollection<OrderExpression> a,
                                                ReadOnlyCollection<OrderExpression> b)
        {
            if (a == b)
                return true;
            if (a == null || b == null)
                return false;
            if (a.Count != b.Count)
                return false;
            for (int i = 0, n = a.Count; i < n; i++)
            {
                if (a[i].OrderType != b[i].OrderType ||
                    !Compare(a[i].Expression, b[i].Expression))
                    return false;
            }
            return true;
        }

        protected virtual bool CompareColumnDeclarations(ReadOnlyCollection<ColumnDeclaration> a,
                                                         ReadOnlyCollection<ColumnDeclaration> b)
        {
            if (a == b)
                return true;
            if (a == null || b == null)
                return false;
            if (a.Count != b.Count)
                return false;
            for (int i = 0, n = a.Count; i < n; i++)
            {
                if (!CompareColumnDeclaration(a[i], b[i]))
                    return false;
            }
            return true;
        }

        protected virtual bool CompareColumnDeclaration(ColumnDeclaration a, ColumnDeclaration b)
        {
            return a.Name == b.Name && Compare(a.Expression, b.Expression);
        }

        protected virtual bool CompareJoin(JoinExpression a, JoinExpression b)
        {
            if (a.Join != b.Join || !Compare(a.Left, b.Left))
                return false;

            if (a.Join == JoinType.CrossApply || a.Join == JoinType.OuterApply)
            {
                var save = aliasScope;
                try
                {
                    aliasScope = new ScopedDictionary<TableAlias, TableAlias>(aliasScope);
                    MapAliases(a.Left, b.Left);

                    return Compare(a.Right, b.Right)
                           && Compare(a.Condition, b.Condition);
                }
                finally
                {
                    aliasScope = save;
                }
            }

            return Compare(a.Right, b.Right) && Compare(a.Condition, b.Condition);
        }

        protected virtual bool CompareAggregate(AggregateExpression a, AggregateExpression b)
        {
            return a.AggregateType == b.AggregateType && Compare(a.Argument, b.Argument);
        }

        protected virtual bool CompareIsNull(IsNullExpression a, IsNullExpression b)
        {
            return Compare(a.Expression, b.Expression);
        }

        protected virtual bool CompareBetween(BetweenExpression a, BetweenExpression b)
        {
            return Compare(a.Expression, b.Expression)
                   && Compare(a.Lower, b.Lower)
                   && Compare(a.Upper, b.Upper);
        }

        protected virtual bool CompareRowNumber(RowNumberExpression a, RowNumberExpression b)
        {
            return CompareOrderList(a.OrderBy, b.OrderBy);
        }

        protected virtual bool CompareNamedValue(NamedValueExpression a, NamedValueExpression b)
        {
            return a.Name == b.Name && Compare(a.Value, b.Value);
        }

        protected virtual bool CompareSubquery(SubqueryExpression a, SubqueryExpression b)
        {
            if (a.NodeType != b.NodeType)
                return false;
            switch ((DbExpressionType) a.NodeType)
            {
                case DbExpressionType.Scalar:
                    return CompareScalar((ScalarExpression) a, (ScalarExpression) b);
                case DbExpressionType.Exists:
                    return CompareExists((ExistsExpression) a, (ExistsExpression) b);
                case DbExpressionType.In:
                    return CompareIn((InExpression) a, (InExpression) b);
            }
            return false;
        }

        protected virtual bool CompareScalar(ScalarExpression a, ScalarExpression b)
        {
            return Compare(a.Select, b.Select);
        }

        protected virtual bool CompareExists(ExistsExpression a, ExistsExpression b)
        {
            return Compare(a.Select, b.Select);
        }

        protected virtual bool CompareIn(InExpression a, InExpression b)
        {
            return Compare(a.Expression, b.Expression)
                   && Compare(a.Select, b.Select)
                   && CompareExpressionList(a.Values, b.Values);
        }

        protected virtual bool CompareAggregateSubquery(AggregateSubqueryExpression a, AggregateSubqueryExpression b)
        {
            return Compare(a.AggregateAsSubquery, b.AggregateAsSubquery)
                   && Compare(a.AggregateInGroupSelect, b.AggregateInGroupSelect)
                   && a.GroupByAlias == b.GroupByAlias;
        }

        protected virtual bool CompareProjection(ProjectionExpression a, ProjectionExpression b)
        {
            if (!Compare(a.Source, b.Source))
                return false;

            var save = aliasScope;
            try
            {
                aliasScope = new ScopedDictionary<TableAlias, TableAlias>(aliasScope);
                aliasScope.Add(a.Source.Alias, b.Source.Alias);

                return Compare(a.Projector, b.Projector)
                       && Compare(a.Aggregator, b.Aggregator)
                       && a.IsSingleton == b.IsSingleton;
            }
            finally
            {
                aliasScope = save;
            }
        }
    }
}