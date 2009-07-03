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
using SubSonic.Repository;
using SubSonic.Tests.Linq.TestBases;
using Xunit;
using SubSonic.DataProviders;
using SubSonic.Tests.TestClasses;

namespace SubSonic.Tests.Update
{
    /// <summary>
    /// Summary description for UpdateTests
    /// </summary>
    public class UpdateTests
    {
        
        private readonly TestDB _db;

        public UpdateTests()
        {
            _db = new TestDB(ProviderFactory.GetProvider("WestWind"));
            var setup = new Setup(_db.Provider);
            setup.DropTestTables();
            setup.CreateTestTable();
            setup.LoadTestData();
        }


        [Fact]
        public void Update_Should_Update_En_Masse()
        {


            _db.Update<Product>().Set("UnitPrice").EqualTo(1000).Where<Product>(x=>x.ProductID==5).Execute();
            
            //pull it back out
            var p = _db.Select.From<Product>().Where("ProductID").IsEqualTo(5).ExecuteSingle<Product>();

            Assert.Equal(1000, p.UnitPrice);

        }

    }
}