using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using LinFu.IoC;

using SubSonic.DataProviders;
using SubSonic.Query;
using SubSonic.SqlGeneration;


namespace SubSonic.DatabaseSupport
{
    public class SqlGeneratorFactory:IOCFactory
    {
    
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
