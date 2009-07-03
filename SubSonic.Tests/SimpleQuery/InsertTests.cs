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
using System.Linq;
using SubSonic.Tests.Linq.TestBases;
using Xunit;
using SubSonic.DataProviders;
using SubSonic.Tests.TestClasses;

namespace SubSonic.Tests.Update
{
    /// <summary>
    /// Summary description for InsertTests
    /// </summary>
    public class InsertTests
    {

        private readonly TestDB _db;

        public InsertTests()
        {
            var provider = ProviderFactory.GetProvider("WestWind");
            _db = new TestDB(provider);
            var setup = new Setup(provider);
            setup.DropTestTables();
            setup.CreateTestTable();
            setup.LoadTestData();
        }

        [Fact]
        public void Insert_Single()
        {
            bool wasThere = _db.Categories.Any(x => x.CategoryName == "SubSonic");
            Assert.False(wasThere);

            var qry = _db.Insert.Into<Category>(x => x.CategoryName)
                .Values("SubSonic").Execute();

            wasThere = _db.Categories.Any(x => x.CategoryName == "SubSonic");
            Assert.True(wasThere);
        }

        [Fact]
        public void Insert_Explicit()
        {
            
            //delete all records
            _db.Delete<Category>(x => x.CategoryID > 0).Execute();
            Assert.Equal(0, _db.Categories.Count());

            _db.Insert.Into<Category>("CategoryName").Values("SubSonic").Execute();

            Assert.Equal(1, _db.Categories.Count());
        }
    }
}