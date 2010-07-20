using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.SqlGeneration;

using LinFu.IoC;

namespace SubSonic.DatabaseSupport
{
    public class SqlFragmentFactory:IOCFactory
    {

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
