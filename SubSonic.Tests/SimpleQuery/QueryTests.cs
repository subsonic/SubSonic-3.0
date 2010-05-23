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
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.DataProviders;
using SubSonic.Tests.Linq.TestBases;
using SubSonic.Linq.Structure;
using SubSonic.Tests.TestClasses;
using Xunit;

namespace SubSonic.Tests.SimpleQuery
{
    public class QueryTests
    {
        private readonly TestDB _db;
        private IDataProvider _provider;

        public QueryTests()
        {
            _provider = ProviderFactory.GetProvider("WestWind");
            _db = new TestDB(_provider);
            var setup = new Setup(_provider);
            setup.DropTestTables();
            setup.CreateTestTable();
            setup.LoadTestData();
        }

        [Fact]
        public void Issue105_Query_Should_Load_BinaryFields()
        {
            var query = new Query<Product>(_provider);
            var result = (from x in query select x).ToList();

            Assert.False(result.Any(p => p.Image == null));
        }
    }
}
