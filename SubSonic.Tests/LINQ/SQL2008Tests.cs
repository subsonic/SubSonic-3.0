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
    // ReSharper disable InconsistentNaming
    // these are unit tests and I like underscores
    // suck it Osherove :)

    // [TestFixture]
    public class Sql2008SelectTests : SelectTests
    {
        public Sql2008SelectTests()
        {
            _db = new TestDB(TestConfiguration.MsSql2008TestConnectionString, DbClientTypeName.MsSql);
            var setup = new Setup(_db.Provider);
            setup.DropTestTables();
            setup.CreateTestTable();
            setup.LoadTestData();
        }
    }

    // [TestFixture]
    public class Sql2008NumberTests : NumberTests
    {
        public Sql2008NumberTests()
        {
            _db = new TestDB(TestConfiguration.MsSql2008TestConnectionString, DbClientTypeName.MsSql);
        }
    }

    // [TestFixture]
    public class Sql2008StringTests : StringTests
    {
        public Sql2008StringTests()
        {
            _db = new TestDB(TestConfiguration.MsSql2008TestConnectionString, DbClientTypeName.MsSql);
        }
    }

    // [TestFixture]
    public class Sql2008DateTests : DateTests
    {
        public Sql2008DateTests()
        {
            _db = new TestDB(TestConfiguration.MsSql2008TestConnectionString, DbClientTypeName.MsSql);
        }
    }
}