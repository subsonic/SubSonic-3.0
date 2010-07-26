using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.DataProviders;

using Microsoft.Practices.ServiceLocation;

namespace SubSonic.DataProviders.Schema
{
    public class SchemaGeneratorFactory : IOCFactory
    {
       
        public static ISchemaGenerator Create(string clientName)
        {
            
            ISchemaGenerator returnValue;
            try
            {
                returnValue = IOCFactory.GetContainer().GetAllInstances<ISchemaGenerator>().Where(b => b.ClientName == clientName).Single();
            }
            catch (Exception ex)
            {
                throw new ArgumentOutOfRangeException(clientName.ToString(), "There is no generator for this client");
            }
            return returnValue;
        }
    }
}
