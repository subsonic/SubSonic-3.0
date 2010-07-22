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
using System.Linq;
//using NUnit.Framework;
using SubSonic.Tests.Linq.TestBases;
using Xunit;

namespace SubSonic.Tests.Linq
{
    // ReSharper disable InconsistentNaming
    // these are unit tests and I like underscores
    // suck it Osherove :)
    // [TestFixture]
    public abstract class SelectTests
    {
        protected TestDB _db;

        [Fact]
        public void All_With_StartsWith()
        {
            var result =
                _db.Customers.All(c => c.ContactName.StartsWith("x"));

            Assert.False(result);
        }

        [Fact]
        public void Any_Should_Not_Fail()
        {
            Assert.True(_db.Products.Any(x => x.ProductID == 1));
        }

        [Fact]
        public void Contains_With_Subquery()
        {
            var result =
                _db.Customers
                .Where(c => _db.Orders
                    .Select(o => o.CustomerID)
                    .Contains(c.CustomerID));

            Assert.Equal(5, result.Count());
        }
			       
        [Fact]
        public void Count_Distinct_With_Arg()
        {
            var result = _db.Customers.Distinct().Count(x => x.CustomerID == "TEST1");

            Assert.Equal(1, result);
        }
			       
        [Fact]
        public void Count_With_SingleArg()
        {
            var result = _db.Orders.Count(x => x.OrderID > 0);
            Assert.Equal(100, result);
        }
			
        [Fact]
        public void First_Product_Should_Have_ProductID_1()
        {
            Assert.True(_db.Products.First().ProductID == 1);
        }      

        [Fact]
        public void Select_Single_Product_With_ID_1()
        {
            var result = (from p in _db.Products
                          where p.ProductID == 1
                          select p).SingleOrDefault();

            Assert.NotNull(result);
            Assert.Equal(1, result.ProductID);
        }

				[Fact]
        public void Single_Product_Should_Have_ProductID_1()
        {
            Assert.True(_db.Products.Single(x => x.ProductID == 1).ProductID == 1);
        }

        [Fact]
        public void Sum_No_Args()
        {
            var result = _db.Orders.Select(o => o.OrderID).Sum();
            Assert.Equal(5050, result);
        }

        [Fact]
        public void Sum_With_SingleArg()
        {
            var result = _db.Orders.Sum(x => x.OrderID);
            Assert.Equal(5050, result);
        }     
    }

    // ReSharper restore InconsistentNaming
}