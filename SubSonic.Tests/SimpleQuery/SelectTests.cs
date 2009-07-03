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
using SubSonic.DataProviders;
using SubSonic.Query;
using SubSonic.Tests.Linq.TestBases;
using Xunit;
using SubSonic.Tests.Batch;
using SubSonic.Tests.TestClasses;

namespace SubSonic.Tests
{

  
    
    /// <summary>
    /// Summary description for SelectTests
    /// </summary>
    public class SelectTests
    {
        private readonly IDataProvider provider;

        public SelectTests()
        {
            provider = ProviderFactory.GetProvider("WestWind");
            var setup = new Setup(provider);
            setup.DropTestTables();
            setup.CreateTestTable();
            setup.LoadTestData();
        }

        [Fact]
        public void Exec_Simple()
        {
            int records = new Select(provider, "productID").From<Product>().GetRecordCount();
            Assert.Equal(100, records);
        }

        [Fact]
        public void Exec_SimpleWithTypedColumns()
        {
            int records = new Select(provider, "productid", "productname").From<Product>().GetRecordCount();
            Assert.Equal(100, records);
        }

        [Fact]
        public void Exec_SimpleAsSingle()
        {
            Product p = new Select(provider).From<Product>().Where("ProductID").IsEqualTo(1).ExecuteSingle<Product>();
            Assert.NotNull(p);
        }

        [Fact]
        public void Exec_WithAllColumns()
        {
            int records = new Select(provider).From<Product>().GetRecordCount();
            Assert.Equal(100, records);
        }

        [Fact]
        public void Exec_SimpleWhere()
        {
            int records = new Select(provider).From<Product>().Where("categoryID").IsEqualTo(5).GetRecordCount();
            Assert.Equal(20, records);
        }

        [Fact]
        public void Exec_SimpleWhere2()
        {
            int records = new Select(provider).From<Product>().Where("CategoryID").IsEqualTo(5).GetRecordCount();
            Assert.Equal(20, records);
        }

        [Fact]
        public void Exec_SimpleWhereAnd()
        {
            var products =
                new Select(provider).From<Product>()
                    .Where("categoryID").IsEqualTo(5)
                    .And("productid").IsGreaterThan(50)
                    .ToList<Product>();

            int records = new Select(provider).From<Product>().Where("categoryID").IsEqualTo(5).And("productid").IsGreaterThan(50).GetRecordCount();
            Assert.Equal(10, records);
        }

        [Fact]
        public void Exec_SimpleJoin()
        {
            var q = new Select(provider, "productid").From<OrderDetail>()
                .InnerJoin<Product>()
                .Where("CategoryID").IsEqualTo(5);
            string sql = q.ToString();
            int records = q.GetRecordCount();
            Assert.Equal(100, records);
        }

        [Fact]
        public void Exec_MultiJoin()
        {
            var customersByCategory = new Select(provider)
                .From<Customer>()
                .InnerJoin<Order>()
                .InnerJoin<OrderDetail>()
                .InnerJoin<Product>()
                .Where("CategoryID").IsEqualTo(5)
                .ToList<Customer>();

            Assert.Equal(100, customersByCategory.Count);
        }

        [Fact]
        public void Exec_LeftOuterJoin_With_Generics()
        {
            var query = new Select(provider, Aggregate.GroupBy("CompanyName"))
                .From<Customer>()
                .LeftOuterJoin<Order>();

            int records = query.GetRecordCount();
            Assert.Equal(195, records);
        }
    }
}