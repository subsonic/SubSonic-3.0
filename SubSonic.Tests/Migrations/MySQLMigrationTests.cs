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
using System.Reflection;
using SubSonic.DataProviders;
using SubSonic.Extensions;
using SubSonic.Schema;
using Xunit;

namespace SubSonic.Tests.Migrations
{
    public class MySQLMigrationTests
    {
        private readonly IDataProvider _provider;
        private Migrator migrator;

        public MySQLMigrationTests()
        {
            _provider = ProviderFactory.GetProvider(TestConfiguration.MySqlTestConnectionString, DbClientTypeName.MySql);
            migrator = new Migrator(Assembly.GetExecutingAssembly());
        }

        [Fact]
        public void CreateTable_Should_CreateValid_SQL_For_SubSonicTest_Defaulted_To_Inno_UTF8()
        {
            var shouldbe =
                @"CREATE TABLE `SubSonicTests` (
  `Key` binary(16) PRIMARY KEY  NOT NULL ,
  `Thinger` int NOT NULL ,
  `Name` nvarchar(255) NOT NULL ,
  `UserName` nvarchar(500) NOT NULL ,
  `CreatedOn` datetime NOT NULL ,
  `Price` decimal(10, 2) NOT NULL ,
  `Discount` float(10, 2) NOT NULL ,
  `Lat` decimal(10, 3),
  `Long` decimal(10, 3),
  `SomeFlag` tinyint NOT NULL ,
  `SomeNullableFlag` tinyint,
  `LongText` LONGTEXT  NOT NULL ,
  `MediumText` nvarchar(800) NOT NULL  
) 
ENGINE=InnoDB DEFAULT CHARSET=utf8";

            var sql = typeof(SubSonicTest).ToSchemaTable(_provider).CreateSql;
            Assert.Equal(shouldbe, sql);
        }

        [Fact]
        public void DropTable_Should_Create_Valid_Sql()
        {
            var shouldbe = "DROP TABLE `SubSonicTests`;";

            var sql = typeof(SubSonicTest).ToSchemaTable(_provider).DropSql.Trim();
            Assert.Equal(shouldbe, sql);
        }

        [Fact]
        public void DropColumnSql_Should_Create_Valid_Sql()
        {
            var shouldbe = "ALTER TABLE `SubSonicTests` DROP COLUMN `UserName`;";

            var sql = typeof(SubSonicTest).ToSchemaTable(_provider).DropColumnSql("UserName");
            Assert.Equal(shouldbe, sql);
        }

        [Fact]
        public void CreateColumnSql_Should_Create_Valid_Sql()
        {
            var shouldbe = @"ALTER TABLE `SubSonicTests` ADD `UserName` nvarchar(500) NOT NULL  DEFAULT '';
UPDATE SubSonicTests SET UserName='';";

            var sql = typeof(SubSonicTest).ToSchemaTable(_provider).GetColumn("UserName").CreateSql;
            Assert.Equal(shouldbe, sql);
        }

        [Fact]
        public void AlterColumnSql_Should_Create_Valid_Sql()
        {
            var shouldbe = "ALTER TABLE `SubSonicTests` MODIFY `UserName` nvarchar(500) NOT NULL ;";

            var sql = typeof(SubSonicTest).ToSchemaTable(_provider).GetColumn("UserName").AlterSql;
            Assert.Equal(shouldbe, sql);
        }
    }
}