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

using SubSonic.Tests.Unit.Linq.TestBases;
using SubSonic.Tests.Unit.Linq.SqlStrings;
using SubSonic.Tests;
namespace SubSonic.Tests.Unit.Linq
{
    // ReSharper disable InconsistentNaming
    // these are unit tests and I like underscores
    // suck it Osherove :)

    public class SQLiteSelectTests : SelectTests
    {
        public SQLiteSelectTests()
        {
            _selectTestsSql = new SQLiteSelectTestsSql();
            _db = new TestDB(TestConfiguration.SQLiteTestsConnectionString, DbClientTypeName.SqlLite);
        }
    }

    public class SQLiteNumberTests : NumberTests
    {
        public SQLiteNumberTests()
        {
            _numberTestsSql = new SQLiteNumberTestsSql();
            _db = new TestDB(TestConfiguration.SQLiteTestsConnectionString, DbClientTypeName.SqlLite);
        }
    }

    public class SQLiteStringTests : StringTests
    {
        public SQLiteStringTests()
        {
            _stringTestsSql = new SQLiteStringTestsSql();
            _db = new TestDB(TestConfiguration.SQLiteTestsConnectionString, DbClientTypeName.SqlLite);
        }
    }

    public class SQLiteDateTests : DateTests
    {
        public SQLiteDateTests()
        {
            _dateTestsSql = new SQLiteDateTestsSql();
            _db = new TestDB(TestConfiguration.SQLiteTestsConnectionString, DbClientTypeName.SqlLite);
        }
    }
}