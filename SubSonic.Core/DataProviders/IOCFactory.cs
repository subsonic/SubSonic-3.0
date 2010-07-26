using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.Reflection;
using System.ComponentModel.Composition;
using System.ComponentModel.Composition.Hosting;
using Microsoft.Practices.ServiceLocation;


namespace SubSonic.DataProviders
{
    public class IOCFactory
    {
        protected static CompositionContainer _container = new CompositionContainer();
        protected static bool containerIsLoaded = false;

        protected static IServiceLocator GetDefaultProvider()
        {
            var catalog = new AssemblyCatalog(System.Reflection.Assembly.GetExecutingAssembly());
            _container = new CompositionContainer(catalog);
            //_container.ComposeParts(catalog);
            Microsoft.Mef.CommonServiceLocator.MefServiceLocator locator = new Microsoft.Mef.CommonServiceLocator.MefServiceLocator(_container);
            return locator;
        }


        public static IServiceLocator GetContainer()
        {
            if (!containerIsLoaded)
            { 
                InitIOC(); 
            }
            return ServiceLocator.Current;

        }

        public static void InitIOC()
        {

            lock (_container)
            {
                if (!containerIsLoaded)
                {
                    if (System.Configuration.ConfigurationManager.AppSettings["SubsonicIOCFramework"] == null)
                    {
                        ServiceLocatorProvider provider = GetDefaultProvider;
                        ServiceLocator.SetLocatorProvider(provider);
                    }


                    /*_container.LoadFrom(AppDomain.CurrentDomain.BaseDirectory, "*.dll");
                        
                    var type = typeof(IDataProvider);
                    var types = AppDomain.CurrentDomain.GetAssemblies().ToList()
                        .SelectMany(s => s.GetTypes())
                        .Where(p => type.IsAssignableFrom(p) 
                                 && p.IsInterface == false 
                                 && p.IsAbstract == false);

                    foreach (Type t in types)
                        try
                        {

                            _container.AddService(typeof(IDataProvider).ToString(), typeof(IDataProvider), Activator.CreateInstance(t));
                                
                        }
                        catch (Exception ex)
                        {
                            //can't instanciate 
                        }*/
                    containerIsLoaded = true;
                }
            }
        }
    }
}

