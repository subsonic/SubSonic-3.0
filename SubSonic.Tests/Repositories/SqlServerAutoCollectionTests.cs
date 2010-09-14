using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.DataProviders;

namespace SubSonic.Tests.Repositories
{
    public class SqlServerAutoCollectionTests : AutoCollectionTests
    {
        public SqlServerAutoCollectionTests() :
            base(ProviderFactory.GetProvider("WestWind"))
        {}
    }
}
