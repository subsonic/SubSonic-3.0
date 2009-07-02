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
using Xunit;

namespace SubSonic.Tests.Aggregates
{
    /// <summary>
    /// Summary description for AggregateTests
    /// </summary>
    public class AggregateTests
    {
        private readonly SubSonicDB _db;

        public AggregateTests()
        {
            _db = new SubSonicDB();
        }

        [Fact]
        public void Aggregates_Should_Run_Count_Old_Skool()
        {
            decimal result = _db.Products
                .Count();

            Assert.True(result > 0);
        }

        [Fact]
        public void Aggregates_Should_Run_Avg_Old_Skool()
        {
            decimal result = (decimal)_db.Products
                                          .Average(x => x.ProductID);

            Assert.True(result > 0);
        }

        [Fact]
        public void Aggregates_Should_Run_Sum_Old_Skool()
        {
            decimal result = _db.Products
                .Sum(x => x.UnitPrice);

            Assert.True(result > 0);
        }

        [Fact]
        public void Aggregates_Should_Run_Joined_Count_Old_Skool()
        {
            //this FAILS on ORDER BY
            var result = from c in _db.Categories
                         //orderby c.CategoryID
                         select new
                                    {
                                        ID = c.CategoryID,
                                        Name = c.CategoryName,
                                        Count = _db.Products.Where(x => x.CategoryID
                                                                        == c.CategoryID).Count()
                                    };

            Assert.Equal(5, result.Count());
            Assert.Equal("Category1", result.ToList()[0].Name);
            Assert.Equal(20, result.ToList()[0].Count);
        }

        [Fact]
        public void Aggregates_Should_Return_Average()
        {
            decimal result = (decimal)_db.Avg<Product>(x => x.UnitPrice).ExecuteScalar();
            Assert.True(result > 0);
        }

        [Fact]
        public void Aggregates_Should_Return_Max()
        {
            var result1 = (int)_db.Max<Product>(x => x.ProductID).ExecuteScalar();
            Assert.Equal(result1, 100);

            var result2 = (int)_db.Products.Max(x => x.ProductID);
            Assert.Equal(result1, result2);
        }

        [Fact]
        public void Aggregates_Should_Return_Min()
        {
            var result1 = (int)_db.Min<Product>(x => x.ProductID).ExecuteScalar();
            Assert.Equal(result1, 1);

            var result2 = (int)_db.Products.Min(x => x.ProductID);
            Assert.Equal(result1, result2);
        }
    }
}