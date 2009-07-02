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

namespace SubSonic.Tests.BugReports
{
    public class AdvancedTemplates
    {
        private readonly SubSonicDB _db;

        public AdvancedTemplates()
        {
            _db = new SubSonicDB();
        }

        /// <summary>
        /// As reported by Christian Weyer in groups.google.com
        /// http://groups.google.com/group/subsonicproject/browse_thread/thread/0009e205ad7b0130
        /// </summary>
        [Fact]
        public void LINQ_Query_Bug()
        {
            var results = from c in _db.Customers
                          from o in _db.Orders
                          from od in _db.OrderDetails
                          where c.CustomerID == o.CustomerID && o.OrderID == od.OrderID
                          select new
                                     {
                                         c.CustomerID,
                                         c.CompanyName,
                                         o.ShippedDate,
                                         od.ProductID,
                                         od.Quantity
                                     };

            Assert.Equal(500, results.Count());
        }

        /// <summary>
        /// An other way to write the above query
        /// </summary>
        [Fact]
        public void LINQ_Query_Bug_Take2()
        {
            var results = from c in _db.Customers
                          join o in _db.Orders on c.CustomerID equals o.CustomerID
                          join od in _db.OrderDetails on o.OrderID equals od.OrderID
                          select new
                                     {
                                         c.CustomerID,
                                         c.CompanyName,
                                         o.ShippedDate,
                                         od.ProductID,
                                         od.Quantity
                                     };

            Assert.Equal(500, results.Count());
        }


    }
}