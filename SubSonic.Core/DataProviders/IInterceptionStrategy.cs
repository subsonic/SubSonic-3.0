using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Castle.DynamicProxy;

namespace SubSonic.DataProviders
{
    public interface IInterceptionStrategy
    {
        object Intercept(object objectToIntercept);

        bool Accept(Type type);
    }

    public class DynamicProxyInterceptionStrategy : IInterceptionStrategy
    {
        private static readonly ProxyGenerator Generator = new ProxyGenerator();

        private IDataProvider _provider;

        public DynamicProxyInterceptionStrategy(IDataProvider provider)
        {
            _provider = provider;
        }

        public object Intercept(object objectToIntercept)
        {
            var interceptor = CreateInterceptor(objectToIntercept);

            return Generator.CreateClassProxyWithTarget(objectToIntercept.GetType(), objectToIntercept, ProxyGenerationOptions.Default, interceptor);
        }

        protected virtual IInterceptor CreateInterceptor(object objectToIntercept)
        {
            return new LazyLoadInterceptor(_provider, objectToIntercept);
        }

        public bool Accept(Type type)
        {
            try
            {
                var table = _provider.FindOrCreateTable(type);

                return table.HasRelations;
            }
            catch (InvalidOperationException)
            {
                // Cannot map that type - for example value types...
                return false;
            }
        }
    }
}
