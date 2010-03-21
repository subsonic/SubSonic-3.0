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
using System;
using System.Linq;
using SubSonic.DataProviders;
using SubSonic.Query;
using SubSonic.Repository;
using SubSonic.Tests;
using SubSonic.Tests.Linq.TestBases;
using SouthWind;
using System.Configuration;

namespace PerfRunner
{
    public class Program
    {
        private static readonly IDataProvider mySqlProvider = ProviderFactory.GetProvider(TestConfiguration.MySqlTestConnectionString, DbClientTypeName.MySql);

        private static readonly IDataProvider sql2005Provider = ProviderFactory.GetProvider(ConfigurationManager.ConnectionStrings["Northwind"].ConnectionString, DbClientTypeName.MsSql);

        private static readonly IDataProvider sql2008Provider = ProviderFactory.GetProvider(ConfigurationManager.ConnectionStrings["Northwind"].ConnectionString, DbClientTypeName.MsSql);

        private static void Main(string[] args)
        {
            //SubSonic.Tests.ActiveRecord.FetchTests.ActiveRecord_Should_Return_10_Products_LessOrEqual_To_10();
            //SubSonic.Tests.ActiveRecord.FetchTests.ActiveRecord_Should_Return_10_Products_Paged();
            //RunSimpleRepoSelects();
            //RunIQSelects();
            //RunSimpleQuerySelects();
            //RunAR();
            RunARLists();
            Console.WriteLine("Done");
            Console.ReadLine();
        }

        private static void RunARLists()
        {
            //SelectActiveRecordList(mySqlProvider);
            SelectActiveRecordList(sql2005Provider);
            //SelectActiveRecordList(sql2008Provider);
        }

        private static void RunAR()
        {
            SelectActiveRecord(mySqlProvider);
            SelectActiveRecord(sql2005Provider);
            SelectActiveRecord(sql2008Provider);
        }

        private static void RunSimpleQuerySelects()
        {
            SelectSimpleQuery(mySqlProvider);
            SelectSimpleQuery(sql2005Provider);
            SelectSimpleQuery(sql2008Provider);
        }

        private static void RunSimpleRepoSelects()
        {
            SelectSimpleRepo(mySqlProvider);
            SelectSimpleRepo(sql2005Provider);
            SelectSimpleRepo(sql2008Provider);
        }

        private static void RunIQSelects()
        {
            SelectIQueryable(mySqlProvider);
            SelectIQueryable(sql2005Provider);
            SelectIQueryable(sql2008Provider);
        }

        private static void RunInserts()
        {
            RunInsert(mySqlProvider);
            RunInsert(sql2005Provider);
            RunInsert(sql2008Provider);
        }

        private static void SelectActiveRecordList(IDataProvider provider)
        {
            Console.WriteLine("Selecting 1000 records of 10/each with AR: " + DateTime.Now + " using " + provider.Client);
            DateTime start = DateTime.Now;
            for(int i = 1; i < 1000; i++)
            {
                var p = Product.Find(x => x.ProductID > 0 && x.ProductID <= 10);
                Console.WriteLine(i);
            }
            DateTime end = DateTime.Now;
            TimeSpan ts = end.Subtract(start);
            Console.WriteLine("End: " + DateTime.Now + " (" + ts.Seconds + ":" + ts.Milliseconds + ")");
        }

        private static void SelectActiveRecord(IDataProvider provider)
        {
            Console.WriteLine("Selecting 10000 records with AR: " + DateTime.Now + " using " + provider.Client);
            DateTime start = DateTime.Now;
            for(int i = 1; i < 10000; i++)
            {
                var p = Product.SingleOrDefault(x => x.ProductID == 1, provider.ConnectionString, provider.DbDataProviderName);
                Console.WriteLine(i);
            }
            DateTime end = DateTime.Now;
            TimeSpan ts = end.Subtract(start);
            Console.WriteLine("End: " + DateTime.Now + " (" + ts.Seconds + ":" + ts.Milliseconds + ")");
        }

        private static void SelectSimpleQuery(IDataProvider provider)
        {
            Console.WriteLine("Selecting 10000 records with SimpleQuery: " + DateTime.Now + " using " + provider.Client);
            DateTime start = DateTime.Now;
            for(int i = 1; i < 10000; i++)
            {
                SubSonic.Tests.TestClasses.Product p =
                    new Select(provider).From<SubSonic.Tests.TestClasses.Product>().Where("ProductID").IsEqualTo(1).ExecuteSingle<SubSonic.Tests.TestClasses.Product>();
                Console.WriteLine(i);
            }
            DateTime end = DateTime.Now;
            TimeSpan ts = end.Subtract(start);
            Console.WriteLine("End: " + DateTime.Now + " (" + ts.Seconds + ":" + ts.Milliseconds + ")");
        }

        private static void SelectSimpleRepo(IDataProvider provider)
        {
            Console.WriteLine("Selecting 10000 records with SimpleRepo: " + DateTime.Now + " using " + provider.Client);
            var repo = new SimpleRepository(provider);
            DateTime start = DateTime.Now;
            for(int i = 1; i < 10000; i++)
            {
                SubSonic.Tests.TestClasses.Product p = repo.Single<SubSonic.Tests.TestClasses.Product>(1);
                Console.WriteLine(i);
            }
            DateTime end = DateTime.Now;
            TimeSpan ts = end.Subtract(start);
            Console.WriteLine("End: " + DateTime.Now + " (" + ts.Seconds + ":" + ts.Milliseconds + ")");
        }

        private static void SelectIQueryable(IDataProvider provider)
        {
            Console.WriteLine("Selecting 10000 records with IQueryable: " + DateTime.Now + " using " + provider.Client);
            var db = new TestDB(provider);
            DateTime start = DateTime.Now;
            for(int i = 1; i < 10000; i++)
            {
                SubSonic.Tests.TestClasses.Product p = db.Products.SingleOrDefault(x => x.ProductID == 1);
                Console.WriteLine(i);
            }
            DateTime end = DateTime.Now;
            TimeSpan ts = end.Subtract(start);
            Console.WriteLine("End: " + DateTime.Now + " (" + ts.Seconds + ":" + ts.Milliseconds + ")");
        }

        private static void RunInsert(IDataProvider provider)
        {
            ResetDB(provider);

            var repo = new SimpleRepository(provider);
            Console.WriteLine("Inserting 1000 rows using Simple Repo: " + DateTime.Now + " using " + provider.Client);
            DateTime start = DateTime.Now;
            for(int i = 1; i < 1000; i++)
            {
                SubSonic.Tests.TestClasses.Product p = new SubSonic.Tests.TestClasses.Product();
                p.CategoryID = 1;
                p.Discontinued = false;
                p.ProductName = "Product" + i;
                p.Sku = Guid.NewGuid();
                p.UnitPrice = 1000;
                repo.Add(p);
                //Console.WriteLine(i);
            }
            DateTime end = DateTime.Now;
            TimeSpan ts = end.Subtract(start);
            Console.WriteLine("End: " + DateTime.Now + " (" + ts.Seconds + ":" + ts.Milliseconds + ")");
        }

        private static void ResetDB(IDataProvider provider)
        {
            var setup = new Setup(provider);
            setup.DropTestTables();
            setup.CreateTestTable();
        }
    }
}