using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.DataProviders;

namespace SubSonic.Tests.Repositories
{
    public class MySQLSimpleRepositoryTests : SimpleRepositoryTests
    {
        public MySQLSimpleRepositoryTests() :
            base(ProviderFactory.GetProvider(@"server=carbuncle;database=subsonic;user id=aspnet_uid; password=pass;", "MySql.Data.MySqlClient"))
        {
        }
    }
}
