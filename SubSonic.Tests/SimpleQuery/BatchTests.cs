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
using System.Collections.Generic;
using System.Data;
using System.Linq;
using SubSonic.Extensions;
using SubSonic.Query;
using Xunit;
using SubSonic.DataProviders;
using SubSonic.Linq.Structure;
using SubSonic.Tests.TestClasses;

namespace SubSonic.Tests.Batch
{


    
    /// <summary>
    /// Summary description for FutureTests
    /// </summary>
    public class BatchTests
    {
        
        private readonly IDataProvider provider;

        public BatchTests()
        {
            provider = ProviderFactory.GetProvider("WestWind");
        }

        [Fact]
        public void Batch_Should_Build_Batched_SQL()
        {
            BatchQuery qry = new BatchQuery(provider);

            qry.Queue(new Select(provider).From("Products").Where("ProductID").IsEqualTo(1));
            qry.Queue(new Select(provider).From("Products").Where("ProductID").IsEqualTo(2));
            qry.Queue(new Select(provider).From("Products").Where("ProductID").IsEqualTo(3));

            string sql = qry.BuildSqlStatement();

            Assert.Equal(3, sql.FindMatches("SELECT").Count);
        }
        [Fact]
        public void Batch_Should_Build_Batched_SQL_With_Replaced_SQL_Parameters()
        {
            BatchQuery qry = new BatchQuery(provider);
            qry.Queue(new Select(provider).From("Products").Where("ProductID").IsEqualTo(1));
            qry.Queue(new Select(provider).From("Products").Where("ProductID").IsEqualTo(2));
            qry.Queue(new Select(provider).From("Products").Where("ProductID").IsEqualTo(3));

            string sql = qry.BuildSqlStatement();

            Assert.True(sql.FindMatches("@0").Count == 1);
            Assert.True(sql.FindMatches("@1").Count == 1);
            Assert.True(sql.FindMatches("@2").Count == 1);
        }

        [Fact]
        public void Batch_Should_Build_Batched_SQL_With_Replaced_Command_Parameters()
        {
            BatchQuery qry = new BatchQuery(provider);
            qry.Queue(new Select(provider).From("Products").Where("ProductID").IsEqualTo(1));
            qry.Queue(new Select(provider).From("Products").Where("ProductID").IsEqualTo(2));
            qry.Queue(new Select(provider).From("Products").Where("ProductID").IsEqualTo(3));
            QueryCommand cmd = qry.GetCommand();

            Assert.Equal("@0", cmd.Parameters[0].ParameterName);
            Assert.Equal("@1", cmd.Parameters[1].ParameterName);
            Assert.Equal("@2", cmd.Parameters[2].ParameterName);
        }

        [Fact]
        public void Batch_Should_Execute_Reader()
        {
            BatchQuery qry = new BatchQuery(provider);
            qry.Queue(new Select(provider).From("Products").Where("ProductID").IsEqualTo(1));
            qry.Queue(new Select(provider).From("Products").Where("ProductID").IsEqualTo(2));
            qry.Queue(new Select(provider).From("Products").Where("ProductID").IsEqualTo(3));
            int sets = 1;
            bool canRead = false;
            using(IDataReader rdr = qry.ExecuteReader())
            {
                canRead = true;
                if(rdr.NextResult())
                    sets = 2;

                if(rdr.NextResult())
                    sets = 3;

                canRead = rdr.NextResult();
            }
            Assert.Equal(3, sets);
            Assert.False(canRead);
        }

        [Fact]
        public void Batch_Should_Execute_Reader_And_Return_Typed_Lists()
        {
            BatchQuery qry = new BatchQuery(provider);
            qry.Queue(new Select(provider).From("Products").Where("ProductID").IsEqualTo(1));
            qry.Queue(new Select(provider).From("Products").Where("ProductID").IsEqualTo(2));
            qry.Queue(new Select(provider).From("Products").Where("ProductID").IsEqualTo(3));

            int sets = 1;
            bool canRead = false;
            List<Product> result1 = null;
            List<Product> result2 = null;
            List<Product> result3 = null;

            using(IDataReader rdr = qry.ExecuteReader())
            {
                result1 = rdr.ToList<Product>();
                canRead = true;
                if(rdr.NextResult())
                    result2 = rdr.ToList<Product>();

                if(rdr.NextResult())
                    result3 = rdr.ToList<Product>();

                canRead = rdr.NextResult();
            }
            Assert.True(result1.Count > 0);
            Assert.True(result2.Count > 0);
            Assert.True(result3.Count > 0);
            Assert.False(canRead);
        }

        [Fact]
        public void Batch_Should_Build_Batched_SQL_Using_Linq()
        {
            BatchQuery qry = new BatchQuery(provider);
            var pquery = new Query<Product>(provider);

            qry.Queue(from p in pquery where p.ProductID == 1 select p);
            qry.Queue(from p in pquery where p.ProductID == 2 select p);
            qry.Queue(from p in pquery where p.ProductID == 3 select p);

            string sql = qry.BuildSqlStatement();

            Assert.Equal(3, sql.FindMatches("SELECT").Count);
        }

        [Fact]
        public void Batch_Should_Execute_Reader_And_Return_Typed_Lists_Using_Linq()
        {
            BatchQuery qry = new BatchQuery(provider);
            var pquery = new Query<Product>(provider);

            qry.Queue(from p in pquery where p.ProductID == 1 select p);
            qry.Queue(from p in pquery where p.ProductID == 2 select p);
            qry.Queue(from p in pquery where p.ProductID == 3 select p);

            int sets = 1;
            bool canRead = false;
            List<Product> result1 = null;
            List<Product> result2 = null;
            List<Product> result3 = null;

            using(IDataReader rdr = qry.ExecuteReader())
            {
                result1 = rdr.ToList<Product>();
                canRead = true;
                if(rdr.NextResult())
                    result2 = rdr.ToList<Product>();

                if(rdr.NextResult())
                    result3 = rdr.ToList<Product>();

                canRead = rdr.NextResult();
            }
            Assert.True(result1.Count > 0);
            Assert.True(result2.Count > 0);
            Assert.True(result3.Count > 0);
            Assert.False(canRead);
        }

    }
}