using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.DataProviders;
using Castle.DynamicProxy;

namespace SubSonic.Tests.Repositories.TestBases
{
    public class MockInterceptionStrategy : IInterceptionStrategy
    {
        private MockDynamicProxyInterceptionStrategy _strategy;

        public MockInterceptionStrategy(IDataProvider provider)
        {
            _strategy = new MockDynamicProxyInterceptionStrategy(provider);
        }

        public object Intercept(object objectToIntercept)
        {
            return _strategy.Intercept(objectToIntercept);
        }

        public bool Accept(Type type)
        {
            return _strategy.Accept(type);
        }
    }

    public class MockDynamicProxyInterceptionStrategy : DynamicProxyInterceptionStrategy
    {
        private IDataProvider _provider;

        public MockDynamicProxyInterceptionStrategy(IDataProvider provider)
            : base(provider)
        {
            _provider = provider;
        }

        protected override IInterceptor CreateInterceptor(object objectToIntercept)
        {
            return new ThrowOnLoadInterceptor(_provider, objectToIntercept);
        }
    }

    public class ThrowOnLoadInterceptor : LazyLoadInterceptor
    {
        public ThrowOnLoadInterceptor(IDataProvider provider, object left)
            : base(provider, left)
        { }

        protected override void LoadPropertyValues(string propertyName, SubSonic.Schema.IRelation reference)
        {
            throw new InvalidOperationException("Must not load already loaded properties twice!");
        }
    }

}
