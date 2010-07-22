// Copyright (c) Microsoft Corporation.  All rights reserved.
// This source code is made available under the terms of the Microsoft Public License (MS-PL)
//Original code created by Matt Warren: http://iqtoolkit.codeplex.com/Release/ProjectReleases.aspx?ReleaseId=19725


using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using System.Text;
using SubSonic.DataProviders;

namespace SubSonic.Linq.Structure
{
    /// <summary>
    /// Optional interface for IQueryProvider to implement Query&lt;T&gt;'s QueryText property.
    /// </summary>
    public interface IQueryText
    {
        string GetQueryText(Expression expression);
    }

    /// <summary>
    /// A default implementation of IQueryable for use with QueryProvider
    /// </summary>
    public class Query<T> : IQueryable<T>, IQueryable, IEnumerable<T>, IEnumerable, IOrderedQueryable<T>, IOrderedQueryable
    {
        IQueryProvider provider;
        Expression expression;
        public Query():this(ProviderFactory.GetProvider())
        {
        }

        public Query(IDataProvider provider):this(new DbQueryProvider(provider))
        {
        }

        public Query(IQueryProvider provider)
        {
            if (provider == null)
            {
                throw new ArgumentNullException("provider");
            }
            this.provider = provider;
            this.expression = Expression.Constant(this);
        }

        public Query(QueryProvider provider, Expression expression)
        {
            if (provider == null)
            {
                throw new ArgumentNullException("provider");
            }
            if (expression == null)
            {
                throw new ArgumentNullException("expression");
            }
            if (!typeof(IQueryable<T>).IsAssignableFrom(expression.Type))
            {
                throw new ArgumentOutOfRangeException("expression");
            }
            this.provider = provider;
            this.expression = expression;
        }

        Expression IQueryable.Expression
        {
            get { return this.expression; }
        }

        Type IQueryable.ElementType
        {
            get { return typeof(T); }
        }

        IQueryProvider IQueryable.Provider
        {
            get { return this.provider; }
        }

        public virtual IEnumerator<T> GetEnumerator()
        {
            return ((IEnumerable<T>)this.provider.Execute(this.expression)).GetEnumerator();
        }

        IEnumerator  IEnumerable.GetEnumerator()
        {
            return ((IEnumerable)this.provider.Execute(this.expression)).GetEnumerator();
        }

        public override string ToString()
        {
            if (this.expression.NodeType == ExpressionType.Constant &&
                ((ConstantExpression)this.expression).Value == this)
            {
                return "Query(" + typeof(T) + ")";
            }
            else
            {
                return this.expression.ToString();
            }
        }

        public string QueryText
        {
            get 
            {
                IQueryText iqt = this.provider as IQueryText;
                if (iqt != null)
                {
                    return iqt.GetQueryText(this.expression);
                }
                return "";
            }
        }
    }
}
