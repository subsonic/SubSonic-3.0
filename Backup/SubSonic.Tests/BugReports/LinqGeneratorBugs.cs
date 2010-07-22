using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.DataProviders;
using SubSonic.Tests.Linq.TestBases;
using Xunit;

namespace SubSonic.Tests.BugReports {
    public class LinqGeneratorBugs {

        TestDB _db;
        public LinqGeneratorBugs()
        {
            _db = new TestDB(TestConfiguration.MsSql2005TestConnectionString, DbClientTypeName.MsSql);
            var setup = new Setup(_db.Provider);
            setup.DropTestTables();
            setup.CreateTestTable();
            setup.LoadTestData();
        }

        /// <summary>
        /// Issue #1 - !=null incorrectly creates "IS NULL"
        /// </summary>
        [Fact]
        
        public void Linq_With_ProductID_IsNotNull_Should_Return_100() {
            var products = from p in _db.Products
                           where p.ProductID != null
                           select p;

            Assert.Equal(100, products.Count());
        }

        /// <summary>
        /// Issue 30 = "==null incorrectly creates "IS NOT NULL"
        /// </summary>
        [Fact]
        public void Linq_With_ProductID_IsNull_Should_Return_0() {
            var products = from p in _db.Products
                           where p.ProductID == null
                           select p;

            Assert.Equal(0, products.Count());
        }
    }
}
