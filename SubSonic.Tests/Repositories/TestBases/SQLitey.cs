using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace SubSonic.Tests.Repositories.TestBases
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
}
