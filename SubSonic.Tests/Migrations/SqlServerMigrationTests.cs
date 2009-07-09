using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.DataProviders;
using Xunit;
using System.Reflection;
using SubSonic.Schema;
using SubSonic.Extensions;

namespace SubSonic.Tests.Migrations
{
    public class GuidAsKey{
       public Guid ID { get; set; }
        public string Title { get; set; }
    }
    
    public class SqlServerMigrationTests {

        IDataProvider _provider;
        Migrator migrator;

        public SqlServerMigrationTests()
        {
            _provider = ProviderFactory.GetProvider(TestConfiguration.MsSql2005TestConnectionString, DbClientTypeName.MsSql);
            migrator=new Migrator(Assembly.GetExecutingAssembly());
        }


        [Fact]
        public void CreateTable_Should_Set_PK_If_Guid_To_DefaultSetting_NewID() {
            var sql = typeof(GuidAsKey).ToSchemaTable(_provider).CreateSql;
            Assert.True(sql.Contains("CONSTRAINT DF_GuidAsKeys_ID DEFAULT (NEWID())"));
        }

        [Fact]
        public void CreateTable_Should_CreateValid_SQL_For_SubSonicTest()
        {
            var shouldbe =
                @"CREATE TABLE [SubSonicTests] (
  [Key] uniqueidentifier NOT NULL,
  [Thinger] int NOT NULL,
  [Name] nvarchar(255) NOT NULL,
  [UserName] nvarchar(500) NOT NULL,
  [CreatedOn] datetime NOT NULL,
  [Price] decimal(10, 2) NOT NULL,
  [Discount] float(10, 2) NOT NULL,
  [Lat] decimal(10, 3),
  [Long] decimal(10, 3),
  [SomeFlag] bit NOT NULL,
  [SomeNullableFlag] bit,
  [LongText] nvarchar(MAX) NOT NULL,
  [MediumText] nvarchar(800) NOT NULL 
);ALTER TABLE [SubSonicTests]
ADD CONSTRAINT PK_SubSonicTests_Key PRIMARY KEY([Key])";
            
            var sql = typeof (SubSonicTest).ToSchemaTable(_provider).CreateSql;
            Assert.Equal(shouldbe, sql);

            
        }

        [Fact]
        public void DropTable_Should_Create_Valid_Sql()
        {
            var shouldbe = "DROP TABLE [SubSonicTests];";
            
            var sql = typeof(SubSonicTest).ToSchemaTable(_provider).DropSql.Trim();
            Assert.Equal(shouldbe, sql);
        }

        [Fact]
        public void DropColumnSql_Should_Create_Valid_Sql() {
            var shouldbe = @"IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_SubSonicTests_UserName]') AND type = 'D')
BEGIN
ALTER TABLE SubSonicTests DROP CONSTRAINT [DF_SubSonicTests_UserName]
END
ALTER TABLE [SubSonicTests] DROP COLUMN UserName;";

            var sql = typeof (SubSonicTest).ToSchemaTable(_provider).DropColumnSql("UserName");
            Assert.Equal(shouldbe, sql);
        }

        [Fact]
        public void CreateColumnSql_Should_Create_Valid_Sql() {
            var shouldbe = @"ALTER TABLE [SubSonicTests] ADD UserName nvarchar(500) NOT NULL CONSTRAINT DF_SubSonicTests_UserName DEFAULT ('');
UPDATE SubSonicTests SET UserName='';";

            var sql = typeof (SubSonicTest).ToSchemaTable(_provider).GetColumn("UserName").CreateSql;
            Assert.Equal(shouldbe, sql);
        }

        [Fact]
        public void AlterColumnSql_Should_Create_Valid_Sql() {
            var shouldbe = "ALTER TABLE [SubSonicTests] ALTER COLUMN UserName nvarchar(500) NOT NULL;";

            var sql = typeof(SubSonicTest).ToSchemaTable(_provider).GetColumn("UserName").AlterSql;
            Assert.Equal(shouldbe, sql);
        }

    }
}