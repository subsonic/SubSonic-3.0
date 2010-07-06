using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using LinFu.IoC;

using SubSonic.DataProviders;
using SubSonic.Query;


namespace SubSonic.SqlGeneration
{
    public class SqlGeneratorFactory
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

        public static ISqlGenerator GetInstance(string providerName, SqlQuery query )
        {
            
            ISqlGenerator returnValue;
            try
            {
                returnValue = Container.GetService<ISqlGenerator>(providerName, query);
            }
            catch(Exception ex)
            {
                returnValue = new Sql2005Generator(query);
            }
            return returnValue;   
        }
        
    }
}
