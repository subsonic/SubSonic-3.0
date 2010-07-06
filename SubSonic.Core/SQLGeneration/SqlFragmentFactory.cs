using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using LinFu.IoC;

namespace SubSonic.SqlGeneration
{
    public class SqlFragmentFactory
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

        public static ISqlFragment Create(string providerName)
        {
            ISqlFragment returnValue;
            try
            {
                returnValue = Container.GetService<ISqlFragment>(providerName);
            }
            catch (Exception ex)
            {
                returnValue = new SqlFragment(); ;
            }

            return returnValue;
        }
    }
}
