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
//using NUnit.Framework;
using SubSonic.DataProviders;
using SubSonic.Tests.Linq.TestBases;
using Xunit;

namespace SubSonic.Tests.Linq
{
    /*
     These tests require MySQL 5.0 + and you can get that from http://mysql.org
     *Make sure to download the GUI tools as well
     *Open up the MySQL Administrator and create a new database called "WestWind"
     *Open up the MySQL Query Browser against WestWind, then select File/Open Script.
     *Navigate to this test project folder, and inside is another folder called "DbScripts"
     *Open up WestWind_Schema_Data_MySQL.sql in the Query Browser, and select Execute (green lighting button)
     *This will load up the DB - now you can run the tests below
     */
    // ReSharper disable InconsistentNaming
    // these are unit tests and I like underscores
    // suck it Osherove :)

    // [TestFixture]
    public class MySQLSelectTests : SelectTests
    {
        public MySQLSelectTests()
        {
            _db = new TestDB(TestConfiguration.MySqlTestConnectionString, DbClientTypeName.MySql);
            var setup = new Setup(_db.Provider);
            setup.DropTestTables();
            setup.CreateTestTable();
            setup.LoadTestData();
        }
    }

    // [TestFixture]
    public class MySQLNumberTests : NumberTests
    {
        public MySQLNumberTests()
        {
            _db = new TestDB(TestConfiguration.MySqlTestConnectionString, DbClientTypeName.MySql);
        }
    }

    // [TestFixture]
    public class MySQLStringTests : StringTests
    {
        public MySQLStringTests()
        {
            _db = new TestDB(TestConfiguration.MySqlTestConnectionString, DbClientTypeName.MySql);
        }
    }

    // [TestFixture]
    public class MySQLDateTests : DateTests
    {
        public MySQLDateTests()
        {
            _db = new TestDB(TestConfiguration.MySqlTestConnectionString, DbClientTypeName.MySql);
        }
    }
}