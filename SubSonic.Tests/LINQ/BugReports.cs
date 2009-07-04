using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.Tests.Linq.TestBases;
using SubSonic.DataProviders;
using Xunit;

namespace SubSonic.Tests.LINQ.TestBases {
    public class BugReports {

        protected TestDB _db;

        public BugReports() {
            _db=new TestDB(ProviderFactory.GetProvider("WestWind"));
        }

        [Fact]
        public void Not_Equal_Null_Should_Generate_IS_NOT_NULL() {
            var qry = from p in _db.Products
                      where p.ProductID != null
                      select p;

            Assert.Equal(100, qry.Count());
        }
    }
}
