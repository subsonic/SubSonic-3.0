using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Xunit;
using SubSonic;
using SubSonic.Tests.Linq.TestBases;
using SubSonic.DataProviders;
using SubSonic.Tests.TestClasses;
using SubSonic.Schema;

namespace SubSonic.Tests.BugReports {
    public class CustomerSummaryView {
        public string CustomerID { get; set; }
        public int OrderID { get; set; }
        public string ProductName { get; set; }
    }

    public class Linq {

        TestDB _db;
        public Linq() {
            _db = new TestDB(TestConfiguration.MsSql2005TestConnectionString, DbClientTypeName.MsSql);
        }

        [Fact]
        public void PagedList_Should_Not_Fail_With_OrderBy_Failure() {
            var qry = from p in _db.Products
                      orderby p.ProductID
                      select p;

            var list = new PagedList<Product>(qry, 1, 10);

            Assert.True(list.Count > 0);
        }
        [Fact]
        public void Change_To_CountOrderBy_Remover_Should_Not_Effect_Regular_Selects() {
            var qry = from p in _db.Products
                      select p;

            var list = qry.ToList();

            int customers = _db.Customers.Select(c => c.City).Distinct().Count();



            Assert.True(list.Count > 0);
            Assert.True(customers > 0);
        }

        [Fact]
        public void Joined_Projection_Should_Return_All_Values() {
            var qry = (from c in _db.Customers
                             join order in _db.Orders on c.CustomerID equals order.CustomerID
                             join details in _db.OrderDetails on order.OrderID equals details.OrderID
                             join products in _db.Products on details.ProductID equals products.ProductID
                             select new CustomerSummaryView
                             {
                                 CustomerID = c.CustomerID,
                                 OrderID = order.OrderID,
                                 ProductName = products.ProductName
                             });

            Assert.True(qry.Count() > 0);

            foreach (var view in qry) {
                Assert.False(String.IsNullOrEmpty(view.ProductName));
                Assert.True(view.OrderID > 0);
                Assert.False(String.IsNullOrEmpty(view.CustomerID));
            }

        }

    }
}
