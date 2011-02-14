using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SouthWind;
using Xunit;
using SubSonic;
using SubSonic.Query;
using System.Data;

using SubSonic.DataProviders;

namespace SubSonic.Tests.BugReports {
    public class UpdateQuery 
    {
        [Fact]
        public void Update_Should_Set_DBType_For_Settings() {
            var provider = ProviderFactory.GetProvider("Northwind");
            var qry = new Update<SouthWind.Order>(provider)
                .Set("RequiredDate").EqualTo(DateTime.Parse("1/12/2001"));
                
            var cmd = qry.GetCommand();
            Assert.Equal(cmd.Parameters[0].DataType, DbType.DateTime);
        }

        [Fact]
        public void Github_Issue211_Update_Should_Support_IsNull_Constraint()
        {
            var provider = ProviderFactory.GetProvider("Northwind");
            var qry = new Update<SouthWind.Order>(provider)
                .Where(o => o.EmployeeID == null)
                .Set("RequiredDate").EqualTo(new DateTime(2001, 12, 1));

            Assert.Contains("IS NULL", qry.GetCommand().CommandSql);
        }

        [Fact]
        public void Github_Issue211_Update_Should_Support_IsNotNull_Constraint()
        {
            var provider = ProviderFactory.GetProvider("Northwind");
            var qry = new Update<SouthWind.Order>(provider)
                .Where(o => o.EmployeeID != null)
                .Set("RequiredDate").EqualTo(new DateTime(2001, 12, 1));

            Assert.Contains("IS NOT NULL", qry.GetCommand().CommandSql);
        }

        
        [Fact]
        public void Github_Issue210_Update_Should_Support_LessThan_Comparison_Constraints()
        {
            var provider = ProviderFactory.GetProvider("Northwind");
            var qry = new Update<SouthWind.Order>(provider)
                .Where(x=> x.EmployeeID < 100)
                .Set("RequiredDate").EqualTo(new DateTime(2001, 12, 1));

            Assert.Contains("[Orders].[EmployeeID] < @0", qry.GetCommand().CommandSql);
        }

        [Fact]
        public void Github_Issue210_Update_Should_Support_GreaterThan_Comparison_Constraints()
        {
            var provider = ProviderFactory.GetProvider("Northwind");
            var qry = new Update<SouthWind.Order>(provider)
                .Where(x => x.EmployeeID > 100)
                .Set("RequiredDate").EqualTo(new DateTime(2001, 12, 1));

            Assert.Contains("[Orders].[EmployeeID] > @0", qry.GetCommand().CommandSql);
        }

        [Fact]
        public void Github_Issue210_Update_Should_Support_Boolean_And_Constraints()
        {
            var provider = ProviderFactory.GetProvider("Northwind");
            var qry = new Update<SouthWind.Order>(provider)
                .Where(x=> x.EmployeeID < 100 && x.OrderID > 100)
                .Set("RequiredDate").EqualTo(new DateTime(2001, 12, 1));

            Assert.Contains("WHERE [Orders].[EmployeeID] < @0 AND [Orders].[OrderID] > @1", qry.GetCommand().CommandSql);
        }

        [Fact]
        public void Github_Issue246_Update_Should_Support_Set_To_Null()
        {
            var provider = ProviderFactory.GetProvider("Northwind");
            var qry = new Update<SouthWind.Category>(provider)
                .Where(x => x.Picture == null)
                .Set(x => x.Description == null);

            Assert.Contains("SET [Categories].[Description]=@up_Description", qry.GetCommand().CommandSql);
            Assert.Contains("WHERE [Categories].[Picture] IS NULL", qry.GetCommand().CommandSql);
        }
        
    }
}
