using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using LinFu.IoC;


namespace SubSonic.DatabaseSupport
{
    public class IOCFactory
    {
        protected static ServiceContainer _container = new ServiceContainer();
        protected static bool containerIsLoaded = false;
        public static ServiceContainer Container
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
    }
}
