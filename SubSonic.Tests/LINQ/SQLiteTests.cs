// 
//   SubSonic - http://subsonicproject.com
// 
//   The contents of this file are subject to the New BSD
//   License (the "License"); you may not use this file
//   except in compliance with the License. You may obtain a copy of
//   the License at http://www.opensource.org/licenses/bsd-license.php
//  
//   Software distributed under the License is distributed on an 
//   "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
//   implied. See the License for the specific language governing
//   rights and limitations under the License.
// 
using System;
using System.IO;
//using NUnit.Framework;
using SubSonic.Tests.Linq.TestBases;
using Xunit;

namespace SubSonic.Tests.Linq
{
    /*
 These tests require SQLite and you shouldn't need much to get this to work
 The dependency is in the project (System.Data.SQLite.dll) but if you want to see what's in there
 * you can by downloading the SQLite explorer - you can find it online
 *The actual DB is in the DbScripts directory - WestWind.db
 */
    // ReSharper disable InconsistentNaming
    // these are unit tests and I like underscores
    // suck it Osherove :)

    internal class SQLitey
    {
        public SQLitey()
        {
            if(!File.Exists(TestConfiguration.SQLiteTestsFilePath))
                throw new InvalidOperationException("Can't find the DB");
            Connection = TestConfiguration.SQLiteTestsConnectionString;
        }

        public string Connection { get; set; }
    }

    // [TestFixture]
    public class SQLiteSelectTests : SelectTests
    {
        public SQLiteSelectTests()
        {
            _db = new TestDB(new SQLitey().Connection, DataProviders.DbClientTypeName.SqlLite);
            var setup = new Setup(_db.Provider);
            setup.DropTestTables();
            setup.CreateTestTable();
            setup.LoadTestData();
        }
    }

    // [TestFixture]
    public class SQLiteNumberTests : NumberTests
    {
        public SQLiteNumberTests()
        {
            _db = new TestDB(new SQLitey().Connection, DataProviders.DbClientTypeName.SqlLite);
            var setup = new Setup(_db.Provider);
            setup.DropTestTables();
            setup.CreateTestTable();
            setup.LoadTestData();
        }
    }

    // [TestFixture]
    public class SQLiteStringTests : StringTests
    {
        public SQLiteStringTests()
        {
            _db = new TestDB(new SQLitey().Connection, DataProviders.DbClientTypeName.SqlLite);
            var setup = new Setup(_db.Provider);
            setup.DropTestTables();
            setup.CreateTestTable();
            setup.LoadTestData();
        }
    }

    // [TestFixture]
    public class SQLiteDateTests : DateTests
    {
        public SQLiteDateTests()
        {
            _db = new TestDB(new SQLitey().Connection, DataProviders.DbClientTypeName.SqlLite);
            var setup = new Setup(_db.Provider);
            setup.DropTestTables();
            setup.CreateTestTable();
            setup.LoadTestData();
        }
    }
}