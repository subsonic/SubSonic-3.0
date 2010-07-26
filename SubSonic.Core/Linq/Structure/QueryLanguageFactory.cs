using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.DataProviders;


namespace SubSonic.Linq.Structure
{
    public static class QueryLanguageFactory
    {
        public static IQueryLanguage Create(IDataProvider provider)
        {
            IQueryLanguage returnValue;
            try
            {
                returnValue = IOCFactory.GetContainer().GetAllInstances<IQueryLanguage>().Where(q => q.ClientName == provider.ClientName).Single();
                returnValue.DataProvider = provider;
            }
            catch (Exception ex)
            {
                returnValue = new TSqlLanguage();
                returnValue.ClientName = provider.ClientName;
                returnValue.DataProvider = provider;
                
            }
            return returnValue;
        }
    }
}
