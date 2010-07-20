using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.DataProviders;

using LinFu.IoC;

namespace SubSonic.DatabaseSupport.Schema
{
    public class SchemaGeneratorFactory : IOCFactory
    {
       
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
