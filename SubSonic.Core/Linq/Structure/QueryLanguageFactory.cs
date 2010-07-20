using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.DataProviders;


using LinFu.IoC;

namespace SubSonic.Linq.Structure
{
    public static class QueryLanguageFactory
    {
        private static ServiceContainer _container = new ServiceContainer();
        private static bool containerIsLoaded = false;
        private static ServiceContainer Container
        {
            get
            {
                lock (_container)
                {
                    if (!containerIsLoaded)
                    {
                        _container.LoadFrom(AppDomain.CurrentDomain.BaseDirectory, "*.dll");
                        containerIsLoaded = true;
                    }
                    return _container;
                }
            }
        }
        public static QueryLanguage Create(IDataProvider provider)
        {
            QueryLanguage returnValue;
            try
            {
                returnValue = Container.GetService<QueryLanguage>(provider.ClientName, provider);
            }
            catch (Exception ex)
            {
                returnValue = new TSqlLanguage(provider);
                
            }
            return returnValue;
        }
    }
}
