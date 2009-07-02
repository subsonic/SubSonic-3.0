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
using WestWind;
using SubSonic.Repository;
using SubSonic.Tests.Linq.TestBases;
using Xunit;

namespace SubSonic.Tests.Update
{
    /// <summary>
    /// Summary description for DeleteTests
    /// </summary>
    public class DeleteTests
    {
        private readonly SubSonicDB _db;

        public DeleteTests()
        {
            _db = new SubSonicDB();
            var setup = new Setup(_db.Provider);
            setup.DropTestTables();
            setup.CreateTestTable();
            setup.LoadTestData();
        }

        [Fact]
        public void Delete_With_Advanced_Template_Repo()
        {
            //make sure it's there
            bool wasThere = _db.Products.Any(x => x.ProductID == 1);
            Assert.True(wasThere);

            //delete it
            _db.Delete<Product>(x => x.ProductID == 1).Execute();
            wasThere = _db.Products.Any(x => x.ProductID == 1);

            //make sure it's not there
            Assert.False(wasThere);
        }

        [Fact]
        public void Delete_With_ActiveRecord_DeleteMany()
        {
            var simpleRepo = new SimpleRepository(_db.Provider);

            bool wasThere = Southwind.Product.Exists(x => x.ProductID == 1);
            Assert.True(wasThere);

            //delete it
            Southwind.Product.Delete(x => x.ProductID == 1);

            wasThere = Southwind.Product.Exists(x => x.ProductID == 1);

            //make sure it's not there
            Assert.False(wasThere);
        }

        [Fact]
        public void Delete_With_ActiveRecord_Single()
        {
            var simpleRepo = new SimpleRepository(_db.Provider);

            bool wasThere = Southwind.Product.Exists(x => x.ProductID == 1);
            Assert.True(wasThere);

            //delete it
            Southwind.Product.Delete(x=>x.ProductID==1);

            wasThere = Southwind.Product.Exists(x => x.ProductID == 1);

            //make sure it's not there
            Assert.False(wasThere);
        }
    }
}