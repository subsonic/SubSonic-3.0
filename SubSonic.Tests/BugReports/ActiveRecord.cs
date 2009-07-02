using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Xunit;

namespace SubSonic.Tests.BugReports {
    public class ActiveRecord {

        /// <summary>
        /// Issue 58 on SubSonicThree site, reported by jonathan.channon (aka ZIPPY!~)
        /// Reports a null return - cannot repro
        /// </summary>
        [Fact]
        public void FindByPrimaryKey_Should_Not_Return_Null() {
            var db = new Southwind.NorthwindDB();
            var table=db.FindByPrimaryKey("CategoryID");
            Assert.NotNull(table);
        }

    }
}
