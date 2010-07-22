using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.DataProviders;
using System.IO;

namespace SubSonic.Tests.Repositories
{
    internal class SQLitey
    {
        public SQLitey()
        {
            if (!File.Exists(TestConfiguration.SQLiteRepositoryFilePath))
                throw new InvalidOperationException("Can't find the DB");
            Connection = TestConfiguration.SQLiteRepositoryConnectionString;
        }

        public string Connection { get; set; }
    }

    public class SQLiteSimpleRepositoryTests : SimpleRepositoryTests
    {
        protected override string[] StringNumbers
        {
            get { return new string[] { "1", "2", "3" }; }
        }

        public SQLiteSimpleRepositoryTests() :
            base(ProviderFactory.GetProvider(new SQLitey().Connection, "System.Data.SQLite"))
        {
        }
    }
}
