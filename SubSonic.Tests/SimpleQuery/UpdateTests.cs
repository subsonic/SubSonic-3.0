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
using System.Collections.Generic;
using System.Linq;
using WestWind;
using SubSonic.Repository;
using SubSonic.Tests.Linq.TestBases;
using Xunit;

namespace SubSonic.Tests.Update
{
    /// <summary>
    /// Summary description for UpdateTests
    /// </summary>
    public class UpdateTests
    {
        private readonly SubSonicDB _db;

        public UpdateTests()
        {
            _db = new SubSonicDB();
            var setup = new Setup(_db.Provider);
            setup.DropTestTables();
            setup.CreateTestTable();
            setup.LoadTestData();
        }

        [Fact]
        public void Update_Using_Simple_Linq()
        {
            var expected =
                @"UPDATE [Products] 
 SET [dbo].[Products].[UnitPrice]=@up_UnitPrice, 
[dbo].[Products].[ProductName]=@up_ProductName
 WHERE [dbo].[Products].[ProductID] = @0";

            var db = new SubSonicDB();
            var query = db.Update<Product>()
                .Set(x => x.UnitPrice == 100, x => x.ProductName == "Test")
                .Where(x => x.ProductID == 1);

            string sql = query.BuildSqlStatement();
            Assert.Equal(expected, sql);
        }

        [Fact]
        public void Update_Should_Update_En_Masse()
        {
            var repo = new SubSonicRepository<Product>(new SubSonicDB());
            Product p = repo.Find(x => x.ProductID == 5).SingleOrDefault();
            p.UnitPrice = 1000;
            repo.Update(p);
            //pull it back out
            p = repo.Find(x => x.ProductID == 5).SingleOrDefault();

            Assert.Equal(1000, p.UnitPrice);

            // Restore price to original value
            p.UnitPrice = 100;
            repo.Update(p);
        }

        [Fact]
        public void Update_Should_Update_Through_Context()
        {
            var repo = new SubSonicRepository<Product>(new SubSonicDB());
            //another way of doing it
            _db.Update<Product>().Set(x => x.UnitPrice == 100).Where(x => x.ProductID == 5).Execute();
            //pull it back out
            Product p = repo.Find(x => x.ProductID == 5).SingleOrDefault();

            Assert.Equal(100, p.UnitPrice);
        }

        [Fact]
        public void Batch_Update_Should_Update_3_With_Execute()
        {
            var repo = new SubSonicRepository<Product>(new SubSonicDB());
            var queue = new List<Product>();

            for(int i = 1; i <= 3; i++)
            {
                Product p = repo.GetByKey(i);
                p.UnitPrice = 1000;
                queue.Add(p);
            }
            repo.Update(queue);
        }
    }
}