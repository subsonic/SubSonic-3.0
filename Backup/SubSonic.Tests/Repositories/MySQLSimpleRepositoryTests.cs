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
            base(ProviderFactory.GetProvider(@"server=localhost;database=SubSonic;user id=root; password=;", "MySql.Data.MySqlClient"))
        {
        }
    }
}
