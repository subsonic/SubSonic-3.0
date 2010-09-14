using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.DataProviders;
using SubSonic.Query;

namespace SubSonic.Tests.Repositories
{
    public static class TestSupport
    {
        public static void CleanTables(IDataProvider provider, params string[] tableNames)
        {
            foreach (var tableName in tableNames)
            {
                try
                {
                    new CodingHorror(provider, String.Format("DROP TABLE {0}", tableName)).Execute();
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex);
                }
            }
        }
    }
}
