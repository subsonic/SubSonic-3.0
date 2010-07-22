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
using System.IO;
using System.Reflection;
using SubSonic.DataProviders;
using SubSonic.Query;
using Xunit;

namespace SubSonic.Tests.Migrations
{

    public partial class SubSonicTest
    {
        //public DateTime ThingyDate { get; set; }
    }

    internal class SQLitey
    {
        public SQLitey()
        {
            if (!File.Exists(TestConfiguration.SQLiteTestsFilePath))
                throw new InvalidOperationException("Can't find the DB");
            Connection = TestConfiguration.SQLiteTestsConnectionString;
        }

        public string Connection { get; set; }
    }

    public class MigrationTests
    {
        static void DropTestTable(IDataProvider provider)
        {
            var qry = new CodingHorror(provider, "DROP TABLE SubSonicTests");
            try
            {
                qry.Execute();
            }
            catch
            {
                //nada
            }
        }

        [Fact]
        public void Migration_MigrateToDb_Should_Save_Schema_To_SqlLite()
        {

            if (!File.Exists(TestConfiguration.SQLiteMigrationsFilePath))
                throw new InvalidOperationException("Can't find the DB");
            string connString = TestConfiguration.SQLiteMigrationsConnectionString;

            var provider = ProviderFactory.GetProvider(connString, DbClientTypeName.SqlLite);

            DropTestTable(provider);
            var assembly = Assembly.GetExecutingAssembly();
            provider.MigrateToDatabase<SubSonicTest>(assembly);

            //query it to make sure it's there
            var qry = new CodingHorror(provider, "SELECT * FROM SubSonicTests").ExecuteTypedList<SubSonicTest>();
            Assert.Equal(0, qry.Count);
        }

        [Fact]
        public void Migration_Update_Should_Add_DateTime_With_Update()
        {

            //this is a silly manual test - I wish I could add a property on the fly
            //but I can't!

            var provider = ProviderFactory.GetProvider(new SQLitey().Connection, DbClientTypeName.SqlLite);

            var assembly = Assembly.GetExecutingAssembly();
            provider.MigrateToDatabase<SubSonicTest>(assembly);

        }

        [Fact]
        public void Migration_MigrateToDb_Should_Save_Schema_To_MySQL()
        {
            var provider = ProviderFactory.GetProvider(TestConfiguration.MySqlTestConnectionString, DbClientTypeName.MySql);
            DropTestTable(provider);
            var assembly = Assembly.GetExecutingAssembly();
            provider.MigrateToDatabase<SubSonicTest>(assembly);

            //query it to make sure it's there
            var qry = new CodingHorror(provider, "SELECT * FROM SubSonicTests").ExecuteTypedList<SubSonicTest>();
            Assert.Equal(0, qry.Count);
        }

    }
}
