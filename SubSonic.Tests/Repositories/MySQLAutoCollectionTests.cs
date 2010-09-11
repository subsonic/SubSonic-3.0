using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.DataProviders;

namespace SubSonic.Tests.Repositories
{
    public class MySQLAutoCollectionTests : AutoCollectionTests
    {
        public MySQLAutoCollectionTests() :
            base(ProviderFactory.GetProvider(@"server=localhost;database=SubSonic;user id=root; password=;", "MySql.Data.MySqlClient"))
        {}
    }
}
