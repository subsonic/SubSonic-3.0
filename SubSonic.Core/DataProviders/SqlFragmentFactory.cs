using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.SqlGeneration;

using Microsoft.Practices.ServiceLocation;

namespace SubSonic.DataProviders
{
    public class SqlFragmentFactory:IOCFactory
    {

        public static ISqlFragment Create(string providerName)
        {
            ISqlFragment returnValue;
            try
            {
                returnValue = IOCFactory.GetContainer().GetAllInstances<ISqlFragment>().Where(f => f.ClientName == providerName).Single(); // Container.GetService<ISqlFragment>(providerName);
            }
            catch (Exception ex)
            {
                returnValue = new SqlFragment(); ;
            }

            return returnValue;
        }
    }
}
