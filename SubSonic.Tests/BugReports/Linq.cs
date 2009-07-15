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
    }
}
