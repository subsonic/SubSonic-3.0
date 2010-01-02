// Copyright (c) Microsoft Corporation.  All rights reserved.
// This source code is made available under the terms of the Microsoft Public License (MS-PL)
//Original code created by Matt Warren: http://iqtoolkit.codeplex.com/Release/ProjectReleases.aspx?ReleaseId=19725


using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data.Common;
using System.IO;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using SubSonic.Linq.Translation;

namespace SubSonic.Linq.Structure
{
    /// <summary>
    /// Builds an execution plan for a query expression
    /// </summary>
    public class ExecutionBuilder : DbExpressionVisitor
    {
        private readonly List<Expression> initializers = new List<Expression>();
        private readonly QueryPolicy policy;
        private readonly Expression provider;
        private readonly List<ParameterExpression> variables = new List<ParameterExpression>();
        private bool isTop = true;
        private int nLookup;
        private int nReaders;
        private MemberInfo receivingMember;
        private Scope scope;

        private ExecutionBuilder(QueryPolicy policy, Expression provider)
        {
            this.policy = policy;
            this.provider = provider;
        }

        public static Expression Build(QueryPolicy policy, Expression expression, Expression provider)
        {
            return new ExecutionBuilder(policy, provider).Build(expression);
        }

        private Expression Build(Expression expression)
        {
            expression = Visit(expression);
            expression = AddVariables(expression);
            return expression;
        }

        private Expression AddVariables(Expression expression)
        {
            // add variable assignments up front
            if (variables.Count > 0)
            {
                List<Expression> exprs = new List<Expression>();
                for (int i = 0, n = variables.Count; i < n; i++)
                {
                    exprs.Add(MakeAssign(variables[i], initializers[i]));
                }
                exprs.Add(expression);
                Expression sequence = MakeSequence(exprs); // yields last expression value

                // use invoke/lambda to create variables via parameters in scope
                Expression[] nulls = variables.Select(v => Expression.Constant(null, v.Type)).ToArray();
                expression = Expression.Invoke(Expression.Lambda(sequence, variables.ToArray()), nulls);
            }

            return expression;
        }

        private static Expression MakeSequence(IList<Expression> expressions)
        {
            Expression last = expressions[expressions.Count - 1];
            return
                Expression.Convert(
                    Expression.Call(typeof (ExecutionBuilder), "Sequence", null,
                                    Expression.NewArrayInit(typeof (object), expressions)), last.Type);
        }

        public static object Sequence(params object[] values)
        {
            return values[values.Length - 1];
        }

        private static Expression MakeAssign(Expression variable, Expression value)
        {
            return Expression.Call(typeof (ExecutionBuilder), "Assign", new[] {variable.Type}, variable, value);
        }

        public static T Assign<T>(ref T variable, T value)
        {
            variable = value;
            return value;
        }

        private Expression BuildInner(Expression expression)
        {
            var eb = new ExecutionBuilder(policy, provider)
                         {
                             scope = scope,
                             receivingMember = receivingMember,
                             nReaders = nReaders,
                             nLookup = nLookup
                         };
            return eb.Build(expression);
        }

        protected override MemberBinding VisitBinding(MemberBinding binding)
        {
            var save = receivingMember;
            receivingMember = binding.Member;
            var result = base.VisitBinding(binding);
            receivingMember = save;
            return result;
        }

        private static Expression MakeJoinKey(IList<Expression> key)
        {
            if (key.Count == 1)
                return key[0];

            return
                Expression.New(typeof (CompoundKey).GetConstructors()[0],
                               Expression.NewArrayInit(typeof (object),
                                                       key.Select(k =>
                                                                  (Expression)
                                                                  Expression.Convert(k, typeof (object
                                                                                            )))));
        }

        protected override Expression VisitClientJoin(ClientJoinExpression join)
        {
            // convert client join into a up-front lookup table builder and replace client-join in tree with lookup accessor

            // 1) lookup = query.Select(e => new KVP(key: inner, value: e)).ToLookup(kvp => kvp.Key, kvp => kvp.Value)
            Expression innerKey = MakeJoinKey(join.InnerKey);
            Expression outerKey = MakeJoinKey(join.OuterKey);

            ConstructorInfo kvpConstructor =
                typeof (KeyValuePair<,>).MakeGenericType(innerKey.Type, join.Projection.Projector.Type).GetConstructor(
                    new[] {innerKey.Type, join.Projection.Projector.Type});
            Expression constructKVPair = Expression.New(kvpConstructor, innerKey, join.Projection.Projector);
            ProjectionExpression newProjection = new ProjectionExpression(join.Projection.Source, constructKVPair);

            int iLookup = ++nLookup;
            Expression execution = ExecuteProjection(newProjection, false);

            ParameterExpression kvp = Expression.Parameter(constructKVPair.Type, "kvp");

            // filter out nulls
            if (join.Projection.Projector.NodeType == (ExpressionType) DbExpressionType.OuterJoined)
            {
                LambdaExpression pred = Expression.Lambda(
                    Expression.NotEqual(
                        Expression.PropertyOrField(kvp, "Value"),
                        Expression.Constant(null, join.Projection.Projector.Type)
                        ),
                    kvp
                    );
                execution = Expression.Call(typeof (Enumerable), "Where", new[] {kvp.Type}, execution, pred);
            }

            // make lookup
            LambdaExpression keySelector = Expression.Lambda(Expression.PropertyOrField(kvp, "Key"), kvp);
            LambdaExpression elementSelector = Expression.Lambda(Expression.PropertyOrField(kvp, "Value"), kvp);
            Expression toLookup = Expression.Call(typeof (Enumerable), "ToLookup",
                                                  new[] {kvp.Type, outerKey.Type, join.Projection.Projector.Type},
                                                  execution, keySelector, elementSelector);

            // 2) agg(lookup[outer])
            ParameterExpression lookup = Expression.Parameter(toLookup.Type, "lookup" + iLookup);
            PropertyInfo property = lookup.Type.GetProperty("Item");
            Expression access = Expression.Call(lookup, property.GetGetMethod(), Visit(outerKey));
            if (join.Projection.Aggregator != null)
            {
                // apply aggregator
                access = DbExpressionReplacer.Replace(join.Projection.Aggregator.Body,
                                                      join.Projection.Aggregator.Parameters[0], access);
            }

            variables.Add(lookup);
            initializers.Add(toLookup);

            return access;
        }

        protected override Expression VisitProjection(ProjectionExpression projection)
        {
            if (isTop)
            {
                isTop = false;
                return ExecuteProjection(projection, scope != null);
            }
            return BuildInner(projection);
        }

		//mike
		internal class ColumnNamedGatherer : DbExpressionVisitor {
			List<string> columnNames = new List<string>();
			internal static List<string> Gather(Expression ex) {
				ColumnNamedGatherer gatherer = new ColumnNamedGatherer();
				gatherer.Visit(ex);
				return gatherer.columnNames;
			}

			protected override Expression VisitMemberInit(MemberInitExpression init) {
				//var ex = this.VisitBinding(init.Bindings[0]);
				foreach (var binding in init.Bindings) {
					this.columnNames.Add(binding.Member.Name);
				}
				return init;
			}
		}
		// end mike

		private Expression ExecuteProjection(ProjectionExpression projection, bool okayToDefer)
        {
            okayToDefer &= (receivingMember != null && policy.IsDeferLoaded(receivingMember));

            // parameterize query
            projection = (ProjectionExpression) Parameterizer.Parameterize(projection);

            if (scope != null)
            {
                // also convert references to outer alias to named values!  these become SQL parameters too
                projection = (ProjectionExpression) OuterParameterizer.Parameterize(scope.Alias, projection);
            }

            var saveScope = scope;
            ParameterExpression reader = Expression.Parameter(typeof (DbDataReader), "r" + nReaders++);
            scope = new Scope(scope, reader, projection.Source.Alias, projection.Source.Columns);
            LambdaExpression projector = Expression.Lambda(Visit(projection.Projector), reader);
            scope = saveScope;
			List<string> columnNames = ColumnNamedGatherer.Gather(projector.Body);//mike
            string commandText = policy.Mapping.Language.Format(projection.Source);
            ReadOnlyCollection<NamedValueExpression> namedValues = NamedValueGatherer.Gather(projection.Source);
            string[] names = namedValues.Select(v => v.Name).ToArray();
            Expression[] values = namedValues.Select(v => Expression.Convert(Visit(v.Value), typeof (object))).ToArray();

            string methExecute = okayToDefer
                                     ? "ExecuteDeferred"
                                     : "Execute";

            if (okayToDefer)
            {
            }

            // call low-level execute directly on supplied DbQueryProvider
            Expression result = Expression.Call(provider, methExecute, new[] {projector.Body.Type},
                                                Expression.New(
                                                    typeof (QueryCommand<>).MakeGenericType(projector.Body.Type).
                                                        GetConstructors()[0],
                                                    Expression.Constant(commandText),
                                                    Expression.Constant(names),
													projector, Expression.Constant(columnNames)
                                                    ),
                                                Expression.NewArrayInit(typeof (object), values)
                );

            if (projection.Aggregator != null)
            {
                // apply aggregator
                result = DbExpressionReplacer.Replace(projection.Aggregator.Body, projection.Aggregator.Parameters[0],
                                                      result);
            }
            return result;
        }

        protected override Expression VisitOuterJoined(OuterJoinedExpression outer)
        {
            Expression expr = Visit(outer.Expression);
            ColumnExpression column = (ColumnExpression) outer.Test;
            ParameterExpression reader;
            int iOrdinal;
            if (scope.TryGetValue(column, out reader, out iOrdinal))
            {
                return Expression.Condition(
                    Expression.Call(reader, "IsDbNull", null, Expression.Constant(iOrdinal)),
                    Expression.Constant(null, outer.Type),
                    expr
                    );
            }
            return expr;
        }

        protected override Expression VisitColumn(ColumnExpression column)
        {
            ParameterExpression reader;
            int iOrdinal;

            if (scope.TryGetValue(column, out reader, out iOrdinal))
            {
                Expression defvalue;
                if (!column.Type.IsValueType || TypeHelper.IsNullableType(column.Type))
                {
                    defvalue = Expression.Constant(null, column.Type);
                }
                else
                {
                    defvalue = Expression.Constant(Activator.CreateInstance(column.Type), column.Type);
                }

                // this sucks, but since we don't track true SQL types through the query, and ADO throws exception if you
                // call the wrong accessor, the best we can do is call GetValue and Convert.ChangeType
                Expression value = Expression.Convert(
                    Expression.Call(typeof (Convert), "ChangeType", null,
                                    Expression.Call(reader, "GetValue", null, Expression.Constant(iOrdinal)),
                                    Expression.Constant(TypeHelper.GetNonNullableType(column.Type))
                        ),
                    column.Type
                    );

                return Expression.Condition(
                    Expression.Call(reader, "IsDbNull", null, Expression.Constant(iOrdinal)),
                    defvalue, value
                    );
            }

            throw new InvalidDataException(string.Format("column not in scope: {0}", column));
            //System.Diagnostics.Debug.Fail(string.Format("column not in scope: {0}", column));
        }

        #region Nested type: OuterParameterizer

        /// <summary>
        /// columns referencing the outer alias are turned into special named-value parameters
        /// </summary>
        private class OuterParameterizer : DbExpressionVisitor
        {
            private readonly Dictionary<ColumnExpression, NamedValueExpression> map =
                new Dictionary<ColumnExpression, NamedValueExpression>();

            private int iParam;
            private TableAlias outerAlias;

            internal static Expression Parameterize(TableAlias outerAlias, Expression expr)
            {
                OuterParameterizer op = new OuterParameterizer {outerAlias = outerAlias};
                return op.Visit(expr);
            }

            protected override Expression VisitProjection(ProjectionExpression proj)
            {
                SelectExpression select = (SelectExpression) Visit(proj.Source);
                if (select != proj.Source)
                {
                    return new ProjectionExpression(select, proj.Projector, proj.Aggregator);
                }
                return proj;
            }

            protected override Expression VisitColumn(ColumnExpression column)
            {
                if (column.Alias == outerAlias)
                {
                    NamedValueExpression nv;
                    if (!map.TryGetValue(column, out nv))
                    {
                        nv = new NamedValueExpression("n" + (iParam++), column);
                        map.Add(column, nv);
                    }
                    return nv;
                }
                return column;
            }
        }

        #endregion

        #region Nested type: Scope

        private class Scope
        {
            private readonly ParameterExpression dbDataReader;
            private readonly Dictionary<string, int> nameMap;
            private readonly Scope outer;

            internal Scope(Scope outer, ParameterExpression dbDataReaderParam, TableAlias alias,
                           IEnumerable<ColumnDeclaration> columns)
            {
                this.outer = outer;
                dbDataReader = dbDataReaderParam;
                Alias = alias;
                nameMap = columns.Select((c, i) => new {c, i}).ToDictionary(x => x.c.Name, x => x.i);
            }

            internal TableAlias Alias { get; private set; }

            internal bool TryGetValue(ColumnExpression column, out ParameterExpression parameterExpression, out int ordinal)
            {
                for (Scope s = this; s != null; s = s.outer)
                {
                    if (column.Alias == s.Alias && nameMap.TryGetValue(column.Name, out ordinal))
                    {
                        parameterExpression = dbDataReader;
                        return true;
                    }
                }
                parameterExpression = null;
                ordinal = 0;
                return false;
            }
        }

        #endregion
    }
}