using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using WestWind;
using Xunit;
using SubSonic.Query;
using SubSonic.DataProviders;

namespace SubSonic.Tests.Batch
{
    public class SelectTests {

        IDataProvider _provider;
        public SelectTests()
        {
            _provider = ProviderFactory.GetProvider("WestWind");
        }

        [Fact]
        public void BatchQuery_Should_Queue_IQueryable()
        {
            WestWind.SubSonicDB db=new SubSonicDB();

            var batch = new BatchQuery(_provider);
            batch.Queue(db.Products);
            batch.Queue(db.Orders);
            Assert.Equal(2,batch.QueryCount);
        }

        [Fact]
        public void BatchQuery_Should_Queue_Have_2_ResultSets_For_2_IQueryable() {
            WestWind.SubSonicDB db = new SubSonicDB();

            var batch = new BatchQuery(_provider);
            batch.Queue(db.Products);
            batch.Queue(db.Orders);
            bool result = false;
            using(var rdr=batch.ExecuteReader())
            {
                rdr.Read();
                result = rdr.NextResult();
            }
            Assert.True(result);

            new SubSonic.Query.Update<WestWind.Product>(_provider).Set(x => x.CategoryID == 5).Set(
                x => x.UnitPrice == 100).Where(x => x.ProductID == 1);
        }


    }
}