using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.DataProviders;

using LinFu.IoC;

namespace SubSonic.SqlGeneration.Schema
{
    public static class SchemaGeneratorFactory
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
        public static ISchemaGenerator Create(string clientName)
        {
            
            ISchemaGenerator returnValue;
            try
            {
                returnValue = Container.GetService<ISchemaGenerator>(clientName);
            }
            catch (Exception ex)
            {
                throw new ArgumentOutOfRangeException(clientName.ToString(), "There is no generator for this client");
            }
            return returnValue;
        }
    }
}
