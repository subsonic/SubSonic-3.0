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
    /// Adds relationship to query results depending on policy
    /// </summary>
    public class RelationshipIncluder : DbExpressionVisitor
    {
        QueryPolicy policy;
        QueryMapping mapping;
        ScopedDictionary<MemberInfo, bool> includeScope = new ScopedDictionary<MemberInfo, bool>(null);

        private RelationshipIncluder(QueryPolicy policy)
        {
            this.policy = policy;
            this.mapping = policy.Mapping;
        }

        public static Expression Include(QueryPolicy policy, Expression expression)
        {
            return new RelationshipIncluder(policy).Visit(expression);
        }

        protected override Expression VisitProjection(ProjectionExpression proj)
        {
            Expression projector = this.Visit(proj.Projector);
            if (projector != proj.Projector)
            {
                return new ProjectionExpression(proj.Source, projector, proj.Aggregator);
            }
            return proj;
        }

        protected override Expression VisitMemberInit(MemberInitExpression init)
        {
            if (this.mapping.IsEntity(init.Type))
            {
                var save = this.includeScope;
                this.includeScope = new ScopedDictionary<MemberInfo,bool>(this.includeScope);

                Dictionary<MemberInfo, MemberBinding> existing = init.Bindings.ToDictionary(b => b.Member);
                List<MemberBinding> newBindings = null;
                foreach (var mi in this.mapping.GetMappedMembers(init.Type))
                {
                    if (!existing.ContainsKey(mi) && this.mapping.IsRelationship(mi) && this.policy.IsIncluded(mi))
                    {
                        if (this.includeScope.ContainsKey(mi))
                        {
                            throw new NotSupportedException(string.Format("Cannot include '{0}.{1}' recursively.", mi.DeclaringType.Name, mi.Name));
                        }
                        Expression me = this.mapping.GetMemberExpression(init, mi);
                        if (newBindings == null)
                        {
                            newBindings = new List<MemberBinding>(init.Bindings);
                        }
                        newBindings.Add(Expression.Bind(mi, me));
                    }
                }
                if (newBindings != null)
                {
                    init = Expression.MemberInit(init.NewExpression, newBindings);
                }

                this.includeScope = save;
            }
            return base.VisitMemberInit(init);
        }
    }
}
