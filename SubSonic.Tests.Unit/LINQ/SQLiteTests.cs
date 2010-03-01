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
using SubSonic.Tests.Unit.Linq.TestBases;
using Xunit;

namespace SubSonic.Tests.Unit.Linq
{
    // ReSharper disable InconsistentNaming
    // these are unit tests and I like underscores
    // suck it Osherove :)

		//internal class SQLitey
		//{
		//    public SQLitey()
		//    {
		//        if(!File.Exists(TestConfiguration.SQLiteTestsFilePath))
		//            throw new InvalidOperationException("Can't find the DB");
		//        Connection = TestConfiguration.SQLiteTestsConnectionString;
		//    }

		//    public string Connection { get; set; }
		//}

		//public class SQLiteSelectTests : SelectTests
		//{
		//    public SQLiteSelectTests()
		//    {
		//      _db = new TestDB(TestConfiguration.SQLiteTestsConnectionString, DataProviders.DbClientTypeName.SqlLite);
		//    }
		//}

		//public class SQLiteNumberTests : NumberTests
		//{
		//    public SQLiteNumberTests()
		//    {
		//        _db = new TestDB(new SQLitey().Connection, DataProviders.DbClientTypeName.SqlLite);
		//    }
		//}

		//public class SQLiteStringTests : StringTests
		//{
		//    public SQLiteStringTests()
		//    {
		//        _db = new TestDB(new SQLitey().Connection, DataProviders.DbClientTypeName.SqlLite);
		//    }
		//}

		//public class SQLiteDateTests : DateTests
		//{
		//    public SQLiteDateTests()
		//    {
		//        _db = new TestDB(new SQLitey().Connection, DataProviders.DbClientTypeName.SqlLite);
		//    }
		//}
}