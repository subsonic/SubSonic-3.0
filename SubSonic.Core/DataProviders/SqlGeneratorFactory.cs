using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using SubSonic.DataProviders;
using SubSonic.Query;
using SubSonic.SqlGeneration;
using SubSonic.DataProviders.SqlServer;
using Microsoft.Practices.ServiceLocation;


namespace SubSonic.DataProviders
{
    public class SqlGeneratorFactory:IOCFactory
    {
    
        public static ISqlGenerator GetInstance(string providerName, SqlQuery query )
        {
            
            ISqlGenerator returnValue;
            try
            {
                returnValue = IOCFactory.GetContainer().GetAllInstances<ISqlGenerator>().Where(g => g.ClientName == providerName).Single();
                returnValue.Query = query;
                //Container.GetService<ISqlGenerator>(providerName, query);
            }
            catch(Exception ex)
            {
                returnValue = new Sql2005Generator();
                returnValue.Query = query;
            }
            return returnValue;   
        }
        
    }
}
