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
using System.Data;
using SubSonic.DataProviders;
using SubSonic.Extensions;
using SubSonic.SqlGeneration.Schema;
using SubSonic.Tests.Migrations;
using Xunit;

namespace SubSonic.Tests.SchemaTables
{
    
    public class IDAsKey
    {
        public int ID { get; set; }
        public string Name { get; set; }
    }

    public class TestType
    {
        public int TestTypeID { get; set; }
        public string Name { get; set; }
    }
    public class TestTypeWithDouble {
        public int ID { get; set; }
        public Double SomeDouble { get; set; }
    }

	[SubSonicTableNameOverride("TestTableName")]
	public class TestTypeWithTableNameOverride
	{
		public int ID { get; set; }
	}

	public enum TestIntBasedEnum
	{
		AnIntegerValue, AnotherIntegerValue
	}

	public class TestTypeWithEnum
	{
		public int ID { get; set; }
		public TestIntBasedEnum SomeIntEnum { get; set; }
		public TestIntBasedEnum? SomeNullableIntEnum { get; set; }
	}

    public class ToSchemaTests
    {
        private readonly IDataProvider _provider;

        public ToSchemaTests()
        {
            _provider = ProviderFactory.GetProvider(TestConfiguration.MsSql2005TestConnectionString, DbClientTypeName.MsSql);
        }

        [Fact]
        public void ToSchemaTable_Should_Create_ITable_For_SubSonicTest()
        {
            var table = typeof(SubSonicTest).ToSchemaTable(_provider);
            Assert.NotNull(table);
        }

        [Fact]
        public void ToSchemaTable_Should_Create_ITable_Named_SubSonicTests()
        {
            var table = typeof(SubSonicTest).ToSchemaTable(_provider);
            Assert.Equal("SubSonicTests", table.Name);
        }

        [Fact]
        public void ToSchemaTable_Should_Create_ITable_With_13_Columns()
        {
            var table = typeof(SubSonicTest).ToSchemaTable(_provider);
            Assert.Equal(13, table.Columns.Count);
            
        }

        [Fact]
        public void ToSchemaTable_Should_Create_ITable_With_PrimaryKey()
        {
            var table = typeof(SubSonicTest).ToSchemaTable(_provider);
            Assert.NotNull(table.PrimaryKey);
        }

        [Fact]
        public void ToSchemaTable_Should_Create_ITable_With_PrimaryKey_Called_Key_Which_Is_Guid()
        {
            var table = typeof(SubSonicTest).ToSchemaTable(_provider);
            Assert.Equal("Key", table.PrimaryKey.Name);
            Assert.Equal(DbType.Guid, table.PrimaryKey.DataType);
        }

        [Fact]
        public void ToSchemaTable_Should_Create_ITable_From_IDAsKey_With_ID_As_PK()
        {
            var table = typeof(IDAsKey).ToSchemaTable(_provider);
            Assert.Equal("ID", table.PrimaryKey.Name);
            Assert.True(table.PrimaryKey.IsNumeric);
            Assert.True(table.PrimaryKey.AutoIncrement);
        }

        [Fact]
        public void ToSchemaTable_Should_Create_ITable_From_TestType_With_TestTypeID_As_PK()
        {
            var table = typeof(TestType).ToSchemaTable(_provider);
            Assert.Equal("TestTypeID", table.PrimaryKey.Name);
            Assert.True(table.PrimaryKey.IsNumeric);
            Assert.True(table.PrimaryKey.AutoIncrement);
        }

        [Fact]
        public void ToSchemaTable_Should_Ignore_Column_With_IgnoreAttribute()
        {
            var table = typeof(SubSonicTest).ToSchemaTable(_provider);
            Assert.Null(table.GetColumn("IgnoreMe"));
        }

        [Fact]
        public void ToSchemaTable_Should_Default_StringLength_To_255()
        {
            var table = typeof(SubSonicTest).ToSchemaTable(_provider);
            Assert.Equal(255, table.GetColumn("Name").MaxLength);
        }

        [Fact]
        public void ToSchemaTable_Should_Set_Length_to_500_When_StringLengthAttribute_Set_To_500()
        {
            var table = typeof(SubSonicTest).ToSchemaTable(_provider);
            Assert.Equal(500, table.GetColumn("UserName").MaxLength);
        }

        [Fact]
        public void ToSchemaTable_Should_Default_Precision_To_10_And_Scale_To_2_For_Dec_Double()
        {
            var table = typeof(SubSonicTest).ToSchemaTable(_provider);
            Assert.Equal(10, table.GetColumn("Price").NumericPrecision);
            Assert.Equal(2, table.GetColumn("Price").NumberScale);
        }

        [Fact]
        public void ToSchemaTable_Should_Set_Precision_To_10_And_Scale_To_3_When_Precision_Attribute_Used()
        {
            var table = typeof(SubSonicTest).ToSchemaTable(_provider);
            Assert.Equal(10, table.GetColumn("Lat").NumericPrecision);
            Assert.Equal(3, table.GetColumn("Lat").NumberScale);
        }

        [Fact]
        public void ToSchemaTable_Should_Set_MaxLength_To_8001_When_LongTextAttribute_Used()
        {
            var table = typeof(SubSonicTest).ToSchemaTable(_provider);
            Assert.Equal(8001, table.GetColumn("LongText").MaxLength);
        }

        [Fact]
        public void ToSchemaTable_Should_Default_To_Not_Nullable()
        {
            var table = typeof(SubSonicTest).ToSchemaTable(_provider);
            Assert.False(table.GetColumn("Price").IsNullable);
        }

        [Fact]
        public void ToSchemaTable_Should_Set_NullableTypes_To_Nullable()
        {
            var table = typeof(SubSonicTest).ToSchemaTable(_provider);
            Assert.True(table.GetColumn("SomeNullableFlag").IsNullable);
        }
        [Fact]
        public void ToSchemaTable_Should_Set_Double_Properly() {
            var table = typeof(TestTypeWithDouble).ToSchemaTable(_provider);
            var col=table.Columns[1];
            string sql = col.AlterSql;
            Assert.False(sql.Contains("float(10,2)"));
            Assert.True(sql.Contains("ALTER COLUMN SomeDouble float"));
        }

		[Fact]
		public void ToSchemaTable_Should_Map_Enum_To_Underlying_DataType()
		{
			var table = typeof(TestTypeWithEnum).ToSchemaTable(_provider);
			var col = table.GetColumnByPropertyName("SomeIntEnum");
            
			Assert.Equal(DbType.Int32, col.DataType);
		}

		[Fact]
		public void ToSchemaTable_Should_Map_Nullable_Enum()
		{
			var table = typeof(TestTypeWithEnum).ToSchemaTable(_provider);
			var col = table.GetColumnByPropertyName("SomeNullableIntEnum");

			Assert.True(col.IsNullable);
		}

		[Fact]
		public void ToSchemaTable_Should_Map_Nullable_Enum_To_Underlying_DataType()
		{
			var table = typeof(TestTypeWithEnum).ToSchemaTable(_provider);
			var col = table.GetColumnByPropertyName("SomeNullableIntEnum");

			Assert.True(col.IsNullable);
			Assert.Equal(DbType.Int32, col.DataType);
		}

		[Fact]
		public void ToSchemaTable_Should_Set_TableName_To_TestTableName_When_TableNameOverrideAttribute_Used()
		{
			var table = typeof(TestTypeWithTableNameOverride).ToSchemaTable(_provider);
			Assert.Equal(table.Name, "TestTableName");
        }
    }
}