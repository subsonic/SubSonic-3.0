// 
//   SubSonic - http://subsonicproject.com
// 
//   The contents of this file are subject to the New BSD
//   License (the "License"); you may not use this file
//   except in compliance with the License. You may obtain a copy of
//   the License at http://www.opensource.org/licenses/bsd-license.php
//  
//   Software distributed under the License is distributed on an 
//   "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
//   implied. See the License for the specific language governing
//   rights and limitations under the License.
// 
using System;
using System.Collections.Generic;
using System.Configuration;

namespace SubSonic.DataProviders
{
    public static class ProviderFactory
    {
        private const string DEFAULT_DB_CLIENT_TYPE_NAME = "System.Data.SqlClient";

        private static Dictionary<string, Func<string, string, IDataProvider>> _factories = new Dictionary<string, Func<string, string, IDataProvider>>();

        public static void Register(string providerName, Func<string, string, IDataProvider> factoryMethod)
        {
            if (_factories.ContainsKey(providerName))
            {
                _factories.Remove(providerName);
            }

            _factories.Add(providerName, factoryMethod);
        }
        
        public static IDataProvider GetProvider()
        {
            string connString = ConfigurationManager.ConnectionStrings[ConfigurationManager.ConnectionStrings.Count - 1].ConnectionString;
            string providerName = ConfigurationManager.ConnectionStrings[ConfigurationManager.ConnectionStrings.Count - 1].ProviderName;
            return LoadProvider(connString, providerName);
        }

        public static IDataProvider GetProvider(string connectionStringName)
        {
			if (ConfigurationManager.ConnectionStrings[connectionStringName] == null)
				throw new ApplicationException(string.Format("Connection string '{0}' does not exist", connectionStringName));

            string connString = ConfigurationManager.ConnectionStrings[connectionStringName].ConnectionString;
            string providerName = ConfigurationManager.ConnectionStrings[connectionStringName].ProviderName;
            return LoadProvider(connString, providerName);
        }

        public static IDataProvider GetProvider(string connectionString, string providerName)
        {
            return LoadProvider(connectionString, providerName);
        }

        private static IDataProvider LoadProvider(string connectionString, string providerName)
        {
            if (String.IsNullOrEmpty(providerName))
                providerName = DEFAULT_DB_CLIENT_TYPE_NAME;

            var factory = _factories[providerName];

            if (factory == null)
            {
                throw new InvalidOperationException(String.Format("Could not create a IDataProvider for providerName {0}", providerName));
            }

            IDataProvider result = factory(connectionString, providerName);

            if(result == null)
                throw new InvalidOperationException("There is no SubSonic provider for the provider you're using");

            return result;
        }
    }
}