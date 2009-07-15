// Copyright (c) Microsoft Corporation.  All rights reserved.
// This source code is made available under the terms of the Microsoft Public License (MS-PL)
//Original code created by Matt Warren: http://iqtoolkit.codeplex.com/Release/ProjectReleases.aspx?ReleaseId=19725


using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using SubSonic.Linq.Structure;

namespace SubSonic.Linq.Translation
{
    /// <summary>
    /// Converts LINQ query operators to into custom DbExpression's
    /// </summary>
    public class QueryBinder : DbExpressionVisitor
    {
        private readonly Dictionary<Expression, GroupByInfo> groupByMap;
        private readonly Dictionary<ParameterExpression, Expression> map;
        private readonly QueryMapping mapping;
        private readonly Expression root;
        private Expression currentGroupElement;
        private List<OrderExpression> thenBys;

        private QueryBinder(QueryMapping mapping, Expression root)
        {
            this.mapping = mapping;
            map = new Dictionary<ParameterExpression, Expression>();
            groupByMap = new Dictionary<Expression, GroupByInfo>();
            this.root = root;
        }

        public static Expression Bind(QueryMapping mapping, Expression expression)
        {
            return new QueryBinder(mapping, expression).Visit(expression);
        }

        private static Expression StripQuotes(Expression e)
        {
            while (e.NodeType == ExpressionType.Quote)
            {
                e = ((UnaryExpression) e).Operand;
            }
            return e;
        }

        internal static TableAlias GetNextAlias()
        {
            return new TableAlias();
        }

        private ProjectedColumns ProjectColumns(Expression expression, TableAlias newAlias,
                                                params TableAlias[] existingAliases)
        {
            return ColumnProjector.ProjectColumns(mapping.Language.CanBeColumn, expression, null, newAlias,
                                                  existingAliases);
        }

        protected override Expression VisitMethodCall(MethodCallExpression m)
        {
            if (m.Method.DeclaringType == typeof (Queryable) || m.Method.DeclaringType == typeof (Enumerable))
            {
                switch (m.Method.Name)
                {
                    case "Where":
                        return BindWhere(m.Type, m.Arguments[0], (LambdaExpression) StripQuotes(m.Arguments[1]));
                    case "Select":
                        return BindSelect(m.Type, m.Arguments[0], (LambdaExpression) StripQuotes(m.Arguments[1]));
                    case "SelectMany":
                        if (m.Arguments.Count == 2)
                        {
                            return BindSelectMany(
                                m.Type, m.Arguments[0],
                                (LambdaExpression) StripQuotes(m.Arguments[1]),
                                null
                                );
                        }
                        else if (m.Arguments.Count == 3)
                        {
                            return BindSelectMany(
                                m.Type, m.Arguments[0],
                                (LambdaExpression) StripQuotes(m.Arguments[1]),
                                (LambdaExpression) StripQuotes(m.Arguments[2])
                                );
                        }
                        break;
                    case "Join":
                        return BindJoin(
                            m.Type, m.Arguments[0], m.Arguments[1],
                            (LambdaExpression) StripQuotes(m.Arguments[2]),
                            (LambdaExpression) StripQuotes(m.Arguments[3]),
                            (LambdaExpression) StripQuotes(m.Arguments[4])
                            );
                    case "OrderBy":
                        return BindOrderBy(m.Type, m.Arguments[0], (LambdaExpression) StripQuotes(m.Arguments[1]),
                                           OrderType.Ascending);
                    case "OrderByDescending":
                        return BindOrderBy(m.Type, m.Arguments[0], (LambdaExpression) StripQuotes(m.Arguments[1]),
                                           OrderType.Descending);
                    case "ThenBy":
                        return BindThenBy(m.Arguments[0], (LambdaExpression) StripQuotes(m.Arguments[1]),
                                          OrderType.Ascending);
                    case "ThenByDescending":
                        return BindThenBy(m.Arguments[0], (LambdaExpression) StripQuotes(m.Arguments[1]),
                                          OrderType.Descending);
                    case "GroupBy":
                        if (m.Arguments.Count == 2)
                        {
                            return BindGroupBy(
                                m.Arguments[0],
                                (LambdaExpression) StripQuotes(m.Arguments[1]),
                                null,
                                null
                                );
                        }
                        else if (m.Arguments.Count == 3)
                        {
                            LambdaExpression lambda1 = (LambdaExpression) StripQuotes(m.Arguments[1]);
                            LambdaExpression lambda2 = (LambdaExpression) StripQuotes(m.Arguments[2]);
                            if (lambda2.Parameters.Count == 1)
                            {
                                // second lambda is element selector
                                return BindGroupBy(m.Arguments[0], lambda1, lambda2, null);
                            }
                            else if (lambda2.Parameters.Count == 2)
                            {
                                // second lambda is result selector
                                return BindGroupBy(m.Arguments[0], lambda1, null, lambda2);
                            }
                        }
                        else if (m.Arguments.Count == 4)
                        {
                            return BindGroupBy(
                                m.Arguments[0],
                                (LambdaExpression) StripQuotes(m.Arguments[1]),
                                (LambdaExpression) StripQuotes(m.Arguments[2]),
                                (LambdaExpression) StripQuotes(m.Arguments[3])
                                );
                        }
                        break;
                    case "Count":
                    case "Min":
                    case "Max":
                    case "Sum":
                    case "Average":
                        if (m.Arguments.Count == 1)
                        {
                            return BindAggregate(m.Arguments[0], m.Method, null, m == root);
                        }
                        else if (m.Arguments.Count == 2)
                        {
                            LambdaExpression selector = (LambdaExpression) StripQuotes(m.Arguments[1]);
                            return BindAggregate(m.Arguments[0], m.Method, selector, m == root);
                        }
                        break;
                    case "Distinct":
                        if (m.Arguments.Count == 1)
                        {
                            return BindDistinct(m.Arguments[0]);
                        }
                        break;
                    case "Skip":
                        if (m.Arguments.Count == 2)
                        {
                            return BindSkip(m.Arguments[0], m.Arguments[1]);
                        }
                        break;
                    case "Take":
                        if (m.Arguments.Count == 2)
                        {
                            return BindTake(m.Arguments[0], m.Arguments[1]);
                        }
                        break;
                    case "First":
                    case "FirstOrDefault":
                    case "Single":
                    case "SingleOrDefault":
                        if (m.Arguments.Count == 1)
                        {
                            return BindFirst(m.Arguments[0], null, m.Method.Name, m == root);
                        }
                        else if (m.Arguments.Count == 2)
                        {
                            LambdaExpression predicate = (LambdaExpression) StripQuotes(m.Arguments[1]);
                            return BindFirst(m.Arguments[0], predicate, m.Method.Name, m == root);
                        }
                        break;
                    case "Any":
                        if (m.Arguments.Count == 1)
                        {
                            return BindAnyAll(m.Arguments[0], m.Method, null, m == root);
                        }
                        else if (m.Arguments.Count == 2)
                        {
                            LambdaExpression predicate = (LambdaExpression) StripQuotes(m.Arguments[1]);
                            return BindAnyAll(m.Arguments[0], m.Method, predicate, m == root);
                        }
                        break;
                    case "All":
                        if (m.Arguments.Count == 2)
                        {
                            LambdaExpression predicate = (LambdaExpression) StripQuotes(m.Arguments[1]);
                            return BindAnyAll(m.Arguments[0], m.Method, predicate, m == root);
                        }
                        break;
                    case "Contains":
                        if (m.Arguments.Count == 2)
                        {
                            return BindContains(m.Arguments[0], m.Arguments[1], m == root);
                        }
                        break;
                }
            }
            return base.VisitMethodCall(m);
        }

        private ProjectionExpression VisitSequence(Expression source)
        {
            // sure to call base.Visit in order to skip my override
            return ConvertToSequence(base.Visit(source));
        }

        private ProjectionExpression ConvertToSequence(Expression expr)
        {
            switch (expr.NodeType)
            {
                case (ExpressionType) DbExpressionType.Projection:
                    return (ProjectionExpression) expr;
                case ExpressionType.New:
                    NewExpression nex = (NewExpression) expr;
                    if (expr.Type.IsGenericType && expr.Type.GetGenericTypeDefinition() == typeof (Grouping<,>))
                    {
                        return (ProjectionExpression) nex.Arguments[1];
                    }
                    goto default;
                case ExpressionType.MemberAccess:
                    return ConvertToSequence(BindRelationshipProperty((MemberExpression) expr));
                default:
                    throw new Exception(string.Format("The expression of type '{0}' is not a sequence", expr.Type));
            }
        }

        private Expression BindRelationshipProperty(MemberExpression mex)
        {
            if (mapping.IsRelationship(mex.Member))
            {
                return mapping.GetMemberExpression(mex.Expression, mex.Member);
            }
            return mex;
        }

        protected override Expression Visit(Expression exp)
        {
            Expression result = base.Visit(exp);

            if (result != null)
            {
                // bindings that expect projections should have called VisitSequence, the rest will probably get annoyed if
                // the projection does not have the expected type.
                Type expectedType = exp.Type;
                ProjectionExpression projection = result as ProjectionExpression;
                if (projection != null && projection.Aggregator == null &&
                    !expectedType.IsAssignableFrom(projection.Type))
                {
                    LambdaExpression aggregator = mapping.GetAggregator(expectedType, projection.Type);
                    if (aggregator != null)
                    {
                        return new ProjectionExpression(projection.Source, projection.Projector, aggregator);
                    }
                }
            }

            return result;
        }

        private Expression BindWhere(Type resultType, Expression source, LambdaExpression predicate)
        {
            ProjectionExpression projection = VisitSequence(source);
            map[predicate.Parameters[0]] = projection.Projector;
            Expression where = Visit(predicate.Body);
            var alias = GetNextAlias();
            ProjectedColumns pc = ProjectColumns(projection.Projector, alias, projection.Source.Alias);
            return new ProjectionExpression(
                new SelectExpression(alias, pc.Columns, projection.Source, where),
                pc.Projector
                );
        }

        private Expression BindSelect(Type resultType, Expression source, LambdaExpression selector)
        {
            ProjectionExpression projection = VisitSequence(source);
            map[selector.Parameters[0]] = projection.Projector;
            Expression expression = Visit(selector.Body);
            var alias = GetNextAlias();
            ProjectedColumns pc = ProjectColumns(expression, alias, projection.Source.Alias);
            return new ProjectionExpression(
                new SelectExpression(alias, pc.Columns, projection.Source, null),
                pc.Projector
                );
        }

        protected virtual Expression BindSelectMany(Type resultType, Expression source,
                                                    LambdaExpression collectionSelector, LambdaExpression resultSelector)
        {
            ProjectionExpression projection = VisitSequence(source);
            map[collectionSelector.Parameters[0]] = projection.Projector;

            Expression collection = collectionSelector.Body;

            // check for DefaultIfEmpty
            bool defaultIfEmpty = false;
            MethodCallExpression mcs = collection as MethodCallExpression;
            if (mcs != null && mcs.Method.Name == "DefaultIfEmpty" && mcs.Arguments.Count == 1 &&
                (mcs.Method.DeclaringType == typeof (Queryable) || mcs.Method.DeclaringType == typeof (Enumerable)))
            {
                collection = mcs.Arguments[0];
                defaultIfEmpty = true;
            }

            ProjectionExpression collectionProjection = VisitSequence(collection);
            bool isTable = collectionProjection.Source.From is TableExpression;
            JoinType joinType = isTable
                                    ? JoinType.CrossJoin
                                    : defaultIfEmpty ? JoinType.OuterApply : JoinType.CrossApply;
            if (joinType == JoinType.OuterApply)
            {
                collectionProjection = collectionProjection.AddOuterJoinTest();
            }
            JoinExpression join = new JoinExpression(joinType, projection.Source, collectionProjection.Source, null);

            var alias = GetNextAlias();
            ProjectedColumns pc;
            if (resultSelector == null)
            {
                pc = ProjectColumns(collectionProjection.Projector, alias, projection.Source.Alias,
                                    collectionProjection.Source.Alias);
            }
            else
            {
                map[resultSelector.Parameters[0]] = projection.Projector;
                map[resultSelector.Parameters[1]] = collectionProjection.Projector;
                Expression result = Visit(resultSelector.Body);
                pc = ProjectColumns(result, alias, projection.Source.Alias, collectionProjection.Source.Alias);
            }
            return new ProjectionExpression(
                new SelectExpression(alias, pc.Columns, join, null),
                pc.Projector
                );
        }

        protected virtual Expression BindJoin(Type resultType, Expression outerSource, Expression innerSource,
                                              LambdaExpression outerKey, LambdaExpression innerKey,
                                              LambdaExpression resultSelector)
        {
            ProjectionExpression outerProjection = VisitSequence(outerSource);
            ProjectionExpression innerProjection = VisitSequence(innerSource);
            map[outerKey.Parameters[0]] = outerProjection.Projector;
            Expression outerKeyExpr = Visit(outerKey.Body);
            map[innerKey.Parameters[0]] = innerProjection.Projector;
            Expression innerKeyExpr = Visit(innerKey.Body);
            map[resultSelector.Parameters[0]] = outerProjection.Projector;
            map[resultSelector.Parameters[1]] = innerProjection.Projector;
            Expression resultExpr = Visit(resultSelector.Body);
            JoinExpression join = new JoinExpression(JoinType.InnerJoin, outerProjection.Source, innerProjection.Source,
                                                     Expression.Equal(outerKeyExpr, innerKeyExpr));
            var alias = GetNextAlias();
            ProjectedColumns pc = ProjectColumns(resultExpr, alias, outerProjection.Source.Alias,
                                                 innerProjection.Source.Alias);
            return new ProjectionExpression(
                new SelectExpression(alias, pc.Columns, join, null),
                pc.Projector
                );
        }

        protected virtual Expression BindOrderBy(Type resultType, Expression source, LambdaExpression orderSelector,
                                                 OrderType orderType)
        {
            List<OrderExpression> myThenBys = thenBys;
            thenBys = null;
            ProjectionExpression projection = VisitSequence(source);

            map[orderSelector.Parameters[0]] = projection.Projector;
            List<OrderExpression> orderings = new List<OrderExpression>();
            orderings.Add(new OrderExpression(orderType, Visit(orderSelector.Body)));

            if (myThenBys != null)
            {
                for (int i = myThenBys.Count - 1; i >= 0; i--)
                {
                    OrderExpression tb = myThenBys[i];
                    LambdaExpression lambda = (LambdaExpression) tb.Expression;
                    map[lambda.Parameters[0]] = projection.Projector;
                    orderings.Add(new OrderExpression(tb.OrderType, Visit(lambda.Body)));
                }
            }

            var alias = GetNextAlias();
            ProjectedColumns pc = ProjectColumns(projection.Projector, alias, projection.Source.Alias);
            return new ProjectionExpression(
                new SelectExpression(alias, pc.Columns, projection.Source, null, orderings.AsReadOnly(), null),
                pc.Projector
                );
        }

        protected virtual Expression BindThenBy(Expression source, LambdaExpression orderSelector, OrderType orderType)
        {
            if (thenBys == null)
            {
                thenBys = new List<OrderExpression>();
            }
            thenBys.Add(new OrderExpression(orderType, orderSelector));
            return Visit(source);
        }

        protected virtual Expression BindGroupBy(Expression source, LambdaExpression keySelector,
                                                 LambdaExpression elementSelector, LambdaExpression resultSelector)
        {
            ProjectionExpression projection = VisitSequence(source);

            map[keySelector.Parameters[0]] = projection.Projector;
            Expression keyExpr = Visit(keySelector.Body);

            Expression elemExpr = projection.Projector;
            if (elementSelector != null)
            {
                map[elementSelector.Parameters[0]] = projection.Projector;
                elemExpr = Visit(elementSelector.Body);
            }

            // Use ProjectColumns to get group-by expressions from key expression
            ProjectedColumns keyProjection = ProjectColumns(keyExpr, projection.Source.Alias, projection.Source.Alias);
            IEnumerable<Expression> groupExprs = keyProjection.Columns.Select(c => c.Expression);

            // make duplicate of source query as basis of element subquery by visiting the source again
            ProjectionExpression subqueryBasis = VisitSequence(source);

            // recompute key columns for group expressions relative to subquery (need these for doing the correlation predicate)
            map[keySelector.Parameters[0]] = subqueryBasis.Projector;
            Expression subqueryKey = Visit(keySelector.Body);

            // use same projection trick to get group-by expressions based on subquery
            ProjectedColumns subqueryKeyPC = ProjectColumns(subqueryKey, subqueryBasis.Source.Alias,
                                                            subqueryBasis.Source.Alias);
            IEnumerable<Expression> subqueryGroupExprs = subqueryKeyPC.Columns.Select(c => c.Expression);
            Expression subqueryCorrelation = BuildPredicateWithNullsEqual(subqueryGroupExprs, groupExprs);

            // compute element based on duplicated subquery
            Expression subqueryElemExpr = subqueryBasis.Projector;
            if (elementSelector != null)
            {
                map[elementSelector.Parameters[0]] = subqueryBasis.Projector;
                subqueryElemExpr = Visit(elementSelector.Body);
            }

            // build subquery that projects the desired element
            var elementAlias = GetNextAlias();
            ProjectedColumns elementPC = ProjectColumns(subqueryElemExpr, elementAlias, subqueryBasis.Source.Alias);
            ProjectionExpression elementSubquery =
                new ProjectionExpression(
                    new SelectExpression(elementAlias, elementPC.Columns, subqueryBasis.Source, subqueryCorrelation),
                    elementPC.Projector
                    );

            var alias = GetNextAlias();

            // make it possible to tie aggregates back to this group-by
            GroupByInfo info = new GroupByInfo(alias, elemExpr);
            groupByMap.Add(elementSubquery, info);

            Expression resultExpr;
            if (resultSelector != null)
            {
                Expression saveGroupElement = currentGroupElement;
                currentGroupElement = elementSubquery;
                // compute result expression based on key and element-subquery
                map[resultSelector.Parameters[0]] = keyProjection.Projector;
                map[resultSelector.Parameters[1]] = elementSubquery;
                resultExpr = Visit(resultSelector.Body);
                currentGroupElement = saveGroupElement;
            }
            else
            {
                // result must be IGrouping<K,E>
                resultExpr =
                    Expression.New(
                        typeof (Grouping<,>).MakeGenericType(keyExpr.Type, subqueryElemExpr.Type).GetConstructors()[0],
                        new[] {keyExpr, elementSubquery}
                        );
            }

            ProjectedColumns pc = ProjectColumns(resultExpr, alias, projection.Source.Alias);

            // make it possible to tie aggregates back to this group-by
            Expression projectedElementSubquery = ((NewExpression) pc.Projector).Arguments[1];
            groupByMap.Add(projectedElementSubquery, info);

            return new ProjectionExpression(
                new SelectExpression(alias, pc.Columns, projection.Source, null, null, groupExprs),
                pc.Projector
                );
        }

        private Expression BuildPredicateWithNullsEqual(IEnumerable<Expression> source1, IEnumerable<Expression> source2)
        {
            IEnumerator<Expression> en1 = source1.GetEnumerator();
            IEnumerator<Expression> en2 = source2.GetEnumerator();
            Expression result = null;
            while (en1.MoveNext() && en2.MoveNext())
            {
                Expression compare =
                    Expression.Or(
                        Expression.And(new IsNullExpression(en1.Current), new IsNullExpression(en2.Current)),
                        Expression.Equal(en1.Current, en2.Current)
                        );
                result = (result == null) ? compare : Expression.And(result, compare);
            }
            return result;
        }

        private AggregateType GetAggregateType(string methodName)
        {
            switch (methodName)
            {
                case "Count":
                    return AggregateType.Count;
                case "Min":
                    return AggregateType.Min;
                case "Max":
                    return AggregateType.Max;
                case "Sum":
                    return AggregateType.Sum;
                case "Average":
                    return AggregateType.Average;
                default:
                    throw new Exception(string.Format("Unknown aggregate type: {0}", methodName));
            }
        }

        private bool HasPredicateArg(AggregateType aggregateType)
        {
            return aggregateType == AggregateType.Count;
        }

        private Expression BindAggregate(Expression source, MethodInfo method, LambdaExpression argument, bool isRoot)
        {
            Type returnType = method.ReturnType;
            AggregateType aggType = GetAggregateType(method.Name);
            bool hasPredicateArg = HasPredicateArg(aggType);
            bool isDistinct = false;
            bool argumentWasPredicate = false;
            bool useAlternateArg = false;

            // check for distinct
            MethodCallExpression mcs = source as MethodCallExpression;
            if (mcs != null && !hasPredicateArg && argument == null)
            {
                if (mcs.Method.Name == "Distinct" && mcs.Arguments.Count == 1 &&
                    (mcs.Method.DeclaringType == typeof (Queryable) || mcs.Method.DeclaringType == typeof (Enumerable)))
                {
                    source = mcs.Arguments[0];
                    isDistinct = true;
                }
            }

            if (argument != null && hasPredicateArg)
            {
                // convert query.Count(predicate) into query.Where(predicate).Count()
                source = Expression.Call(typeof (Queryable), "Where", method.GetGenericArguments(), source, argument);
                argument = null;
                argumentWasPredicate = true;
            }

            ProjectionExpression projection = VisitSequence(source);

            Expression argExpr = null;
            if (argument != null)
            {
                map[argument.Parameters[0]] = projection.Projector;
                argExpr = Visit(argument.Body);
            }
            else if (!hasPredicateArg || useAlternateArg)
            {
                argExpr = projection.Projector;
            }

            var alias = GetNextAlias();
            var pc = ProjectColumns(projection.Projector, alias, projection.Source.Alias);
            Expression aggExpr = new AggregateExpression(returnType, aggType, argExpr, isDistinct);
            SelectExpression select = new SelectExpression(alias, new[] {new ColumnDeclaration("", aggExpr)},
                                                           projection.Source, null);

            if (isRoot)
            {
                ParameterExpression p = Expression.Parameter(typeof (IEnumerable<>).MakeGenericType(aggExpr.Type), "p");
                LambdaExpression gator =
                    Expression.Lambda(Expression.Call(typeof (Enumerable), "Single", new[] {returnType}, p), p);
                return new ProjectionExpression(select, new ColumnExpression(returnType, alias, ""), gator);
            }

            ScalarExpression subquery = new ScalarExpression(returnType, select);

            // if we can find the corresponding group-info we can build a special AggregateSubquery node that will enable us to 
            // optimize the aggregate expression later using AggregateRewriter
            GroupByInfo info;
            if (!argumentWasPredicate && groupByMap.TryGetValue(projection, out info))
            {
                // use the element expression from the group-by info to rebind the argument so the resulting expression is one that 
                // would be legal to add to the columns in the select expression that has the corresponding group-by clause.
                if (argument != null)
                {
                    map[argument.Parameters[0]] = info.Element;
                    argExpr = Visit(argument.Body);
                }
                else if (!hasPredicateArg || useAlternateArg)
                {
                    argExpr = info.Element;
                }
                aggExpr = new AggregateExpression(returnType, aggType, argExpr, isDistinct);

                // check for easy to optimize case.  If the projection that our aggregate is based on is really the 'group' argument from
                // the query.GroupBy(xxx, (key, group) => yyy) method then whatever expression we return here will automatically
                // become part of the select expression that has the group-by clause, so just return the simple aggregate expression.
                if (projection == currentGroupElement)
                    return aggExpr;

                return new AggregateSubqueryExpression(info.Alias, aggExpr, subquery);
            }

            return subquery;
        }

        private Expression BindDistinct(Expression source)
        {
            ProjectionExpression projection = VisitSequence(source);
            SelectExpression select = projection.Source;
            var alias = GetNextAlias();
            ProjectedColumns pc = ProjectColumns(projection.Projector, alias, projection.Source.Alias);
            return new ProjectionExpression(
                new SelectExpression(alias, pc.Columns, projection.Source, null, null, null, true, null, null),
                pc.Projector
                );
        }

        private Expression BindTake(Expression source, Expression take)
        {
            ProjectionExpression projection = VisitSequence(source);
            take = Visit(take);
            SelectExpression select = projection.Source;
            var alias = GetNextAlias();
            ProjectedColumns pc = ProjectColumns(projection.Projector, alias, projection.Source.Alias);
            return new ProjectionExpression(
                new SelectExpression(alias, pc.Columns, projection.Source, null, null, null, false, null, take),
                pc.Projector
                );
        }

        private Expression BindSkip(Expression source, Expression skip)
        {
            ProjectionExpression projection = VisitSequence(source);
            skip = Visit(skip);
            SelectExpression select = projection.Source;
            var alias = GetNextAlias();
            ProjectedColumns pc = ProjectColumns(projection.Projector, alias, projection.Source.Alias);
            return new ProjectionExpression(
                new SelectExpression(alias, pc.Columns, projection.Source, null, null, null, false, skip, null),
                pc.Projector
                );
        }

        private Expression BindFirst(Expression source, LambdaExpression predicate, string kind, bool isRoot)
        {
            ProjectionExpression projection = VisitSequence(source);
            Expression where = null;
            if (predicate != null)
            {
                map[predicate.Parameters[0]] = projection.Projector;
                where = Visit(predicate.Body);
            }
            Expression take = kind.StartsWith("First") ? Expression.Constant(1) : null;
            if (take != null || where != null)
            {
                var alias = GetNextAlias();
                ProjectedColumns pc = ProjectColumns(projection.Projector, alias, projection.Source.Alias);
                projection = new ProjectionExpression(
                    new SelectExpression(alias, pc.Columns, projection.Source, where, null, null, false, null, take),
                    pc.Projector
                    );
            }
            if (isRoot)
            {
                Type elementType = projection.Projector.Type;
                ParameterExpression p = Expression.Parameter(typeof (IEnumerable<>).MakeGenericType(elementType), "p");
                LambdaExpression gator =
                    Expression.Lambda(Expression.Call(typeof (Enumerable), kind, new[] {elementType}, p), p);
                return new ProjectionExpression(projection.Source, projection.Projector, gator);
            }
            return projection;
        }

        private Expression BindAnyAll(Expression source, MethodInfo method, LambdaExpression predicate, bool isRoot)
        {
            bool isAll = method.Name == "All";
            ConstantExpression constSource = source as ConstantExpression;
            if (constSource != null && !IsQuery(constSource))
            {
                Debug.Assert(!isRoot);
                Expression where = null;
                foreach (object value in (IEnumerable) constSource.Value)
                {
                    Expression expr = Expression.Invoke(predicate,
                                                        Expression.Constant(value, predicate.Parameters[0].Type));
                    if (where == null)
                    {
                        where = expr;
                    }
                    else if (isAll)
                    {
                        where = Expression.And(where, expr);
                    }
                    else
                    {
                        where = Expression.Or(where, expr);
                    }
                }
                return Visit(where);
            }
            else
            {
                if (isAll)
                {
                    predicate = Expression.Lambda(Expression.Not(predicate.Body), predicate.Parameters.ToArray());
                }
                if (predicate != null)
                {
                    source = Expression.Call(typeof (Queryable), "Where", method.GetGenericArguments(), source,
                                             predicate);
                }
                ProjectionExpression projection = VisitSequence(source);
                Expression result = new ExistsExpression(projection.Source);
                if (isAll)
                {
                    result = Expression.Not(result);
                }
                if (isRoot)
                {
                    return GetSingletonSequence(result, "SingleOrDefault");
                }
                return result;
            }
        }

        private Expression BindContains(Expression source, Expression match, bool isRoot)
        {
            ConstantExpression constSource = source as ConstantExpression;
            if (constSource != null && !IsQuery(constSource))
            {
                Debug.Assert(!isRoot);
                List<Expression> values = new List<Expression>();
                foreach (object value in (IEnumerable) constSource.Value)
                {
                    values.Add(Expression.Constant(Convert.ChangeType(value, match.Type), match.Type));
                }
                match = Visit(match);
                return new InExpression(match, values);
            }
            else
            {
                ProjectionExpression projection = VisitSequence(source);
                match = Visit(match);
                Expression result = new InExpression(match, projection.Source);
                if (isRoot)
                {
                    return GetSingletonSequence(result, "SingleOrDefault");
                }
                return result;
            }
        }

        private Expression GetSingletonSequence(Expression expr, string aggregator)
        {
            ParameterExpression p = Expression.Parameter(typeof (IEnumerable<>).MakeGenericType(expr.Type), "p");
            LambdaExpression gator = null;
            if (aggregator != null)
            {
                gator = Expression.Lambda(Expression.Call(typeof (Enumerable), aggregator, new[] {expr.Type}, p), p);
            }
            var alias = GetNextAlias();
            SelectExpression select = new SelectExpression(alias, new[] {new ColumnDeclaration("value", expr)}, null,
                                                           null);
            return new ProjectionExpression(select, new ColumnExpression(expr.Type, alias, "value"), gator);
        }

        private bool IsQuery(Expression expression)
        {
            bool IsAssignable = true;
            foreach (Type genericargument in expression.Type.GetGenericArguments())
            {
                IsAssignable &= typeof(IQueryable<>).MakeGenericType(genericargument).IsAssignableFrom(expression.Type);
            }

            return expression.Type.IsGenericType && IsAssignable;
        }

        protected override Expression VisitConstant(ConstantExpression c)
        {
            if (IsQuery(c))
            {
                return VisitSequence(mapping.GetTableQuery(TypeHelper.GetElementType(c.Type)));
            }
            return c;
        }

        protected override Expression VisitParameter(ParameterExpression p)
        {
            Expression e;
            if (map.TryGetValue(p, out e))
            {
                return e;
            }
            return p;
        }

        protected override Expression VisitInvocation(InvocationExpression iv)
        {
            LambdaExpression lambda = iv.Expression as LambdaExpression;
            if (lambda != null)
            {
                for (int i = 0, n = lambda.Parameters.Count; i < n; i++)
                {
                    map[lambda.Parameters[i]] = iv.Arguments[i];
                }
                return Visit(lambda.Body);
            }
            return base.VisitInvocation(iv);
        }

        protected override Expression VisitMemberAccess(MemberExpression m)
        {
            if (m.Expression != null && m.Expression.NodeType == ExpressionType.Parameter && IsQuery(m))
            {
                return VisitSequence(mapping.GetTableQuery(TypeHelper.GetElementType(m.Type)));
            }
            Expression source = Visit(m.Expression);

            Expression result = BindMember(source, m.Member);
            MemberExpression mex = result as MemberExpression;
            if (mex != null && mex.Member == m.Member && mex.Expression == m.Expression)
            {
                return m;
            }
            return result;
        }

        internal static Expression BindMember(Expression source, MemberInfo member)
        {
            switch (source.NodeType)
            {
                case ExpressionType.MemberInit:
                    MemberInitExpression min = (MemberInitExpression) source;
                    for (int i = 0, n = min.Bindings.Count; i < n; i++)
                    {
                        MemberAssignment assign = min.Bindings[i] as MemberAssignment;
                        if (assign != null && MembersMatch(assign.Member, member))
                        {
                            return assign.Expression;
                        }
                    }
                    break;

                case ExpressionType.New:
                    NewExpression nex = (NewExpression) source;
                    if (nex.Members != null)
                    {
                        for (int i = 0, n = nex.Members.Count; i < n; i++)
                        {
                            if (MembersMatch(nex.Members[i], member))
                            {
                                return nex.Arguments[i];
                            }
                        }
                    }
                    else if (nex.Type.IsGenericType && nex.Type.GetGenericTypeDefinition() == typeof (Grouping<,>))
                    {
                        if (member.Name == "Key")
                        {
                            return nex.Arguments[0];
                        }
                    }
                    break;

                case (ExpressionType) DbExpressionType.Projection:
                    // member access on a projection turns into a new projection w/ member access applied
                    ProjectionExpression proj = (ProjectionExpression) source;
                    Expression newProjector = BindMember(proj.Projector, member);
                    return new ProjectionExpression(proj.Source, newProjector);

                case (ExpressionType) DbExpressionType.OuterJoined:
                    OuterJoinedExpression oj = (OuterJoinedExpression) source;
                    Expression em = BindMember(oj.Expression, member);
                    if (em is ColumnExpression)
                    {
                        return em;
                    }
                    return new OuterJoinedExpression(oj.Test, em);

                case ExpressionType.Conditional:
                    ConditionalExpression cex = (ConditionalExpression) source;
                    return Expression.Condition(cex.Test, BindMember(cex.IfTrue, member),
                                                BindMember(cex.IfFalse, member));

                case ExpressionType.Constant:
                    ConstantExpression con = (ConstantExpression) source;
                    if (con.Value == null)
                    {
                        Type memberType = TypeHelper.GetMemberType(member);
                        return Expression.Constant(GetDefault(memberType), memberType);
                    }
                    break;
            }
            return Expression.MakeMemberAccess(source, member);
        }

        private static object GetDefault(Type type)
        {
            if (!type.IsValueType || TypeHelper.IsNullableType(type))
            {
                return null;
            }
            else
            {
                return Activator.CreateInstance(type);
            }
        }

        private static bool MembersMatch(MemberInfo a, MemberInfo b)
        {
            if (a == b) {
                return true;
            }

            if ((a.DeclaringType.IsAssignableFrom(b.DeclaringType) || b.DeclaringType.IsAssignableFrom(a.DeclaringType)) &&
                a.Name == b.Name) {
                return true;
            }

            if (a is MethodInfo && b is PropertyInfo) {
                return a == ((PropertyInfo)b).GetGetMethod();
            }
            if (a is PropertyInfo && b is MethodInfo) {
                return ((PropertyInfo)a).GetGetMethod() == b;
            }
            return false;
        }

        #region Nested type: GroupByInfo

        private class GroupByInfo
        {
            internal GroupByInfo(TableAlias alias, Expression element)
            {
                Alias = alias;
                Element = element;
            }

            internal TableAlias Alias { get; private set; }
            internal Expression Element { get; private set; }
        }

        #endregion
    }
}