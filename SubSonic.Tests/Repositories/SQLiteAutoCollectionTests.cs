using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.DataProviders;
using System.IO;
using SubSonic.Tests.Repositories.TestBases;

namespace SubSonic.Tests.Repositories
{
    public class SQLiteAutoCollectionTests : AutoCollectionTests
    {
        public SQLiteAutoCollectionTests() :
            base(ProviderFactory.GetProvider(new SQLitey().Connection, "System.Data.SQLite"))
        {}
    }
}
