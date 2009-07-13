using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Xunit;
using SubSonic;
using SubSonic.Query;
using System.Data;
using SubSonic.Tests.Linq.TestBases;
using SubSonic.DataProviders;

namespace SubSonic.Tests.BugReports {
    public class UpdateQuery {


        [Fact]
        public void Update_Should_Set_DBType_For_Settings() {
            var provider = ProviderFactory.GetProvider("Northwind");
            var qry = new Update<SouthWind.Order>(provider)
                .Set("RequiredDate").EqualTo(DateTime.Parse("1/12/2001"));
                
            var cmd = qry.GetCommand();
            Assert.Equal(cmd.Parameters[0].DataType, DbType.DateTime);

        }

    }
}
