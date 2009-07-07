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
using System.Text;
using SubSonic.Schema;

namespace SubSonic.SqlGeneration.Schema
{
    public class SQLiteSchema : ANSISchemaGenerator
    {
        public SQLiteSchema()
        {
            ADD_COLUMN = @"ALTER TABLE `{0}` ADD `{1}`{2};";
            //can't do this
            ALTER_COLUMN = @"";
            CREATE_TABLE = "CREATE TABLE `{0}` ({1} \r\n);";
            //can't do this
            DROP_COLUMN = @"";
            DROP_TABLE = @"DROP TABLE {0};";
        }

        public override string GetNativeType(DbType dbType)
        {
            switch(dbType)
            {
                case DbType.Object:
                case DbType.AnsiString:
                case DbType.AnsiStringFixedLength:
                case DbType.String:
                case DbType.StringFixedLength:
                    return "nvarchar";
                case DbType.Boolean:
                    return "tinyint";
                case DbType.SByte:
                case DbType.Binary:
                case DbType.Byte:
                    return "longblob";
                case DbType.Currency:
                    return "money";
                case DbType.Time:
                case DbType.Date:
                case DbType.DateTime:
                    return "datetime";
                case DbType.Decimal:
                    return "decimal";
                case DbType.Double:
                    return "float";
                case DbType.Guid:
                    return "guid";
                case DbType.UInt32:
                case DbType.Int32:
                    return "int";
                case DbType.Int16:
                case DbType.UInt16:
                    return "tinyint";
                case DbType.UInt64:
                case DbType.Int64:
                    return "integer";
                case DbType.Single:
                    return "real";
                case DbType.VarNumeric:
                    return "numeric";
                case DbType.Xml:
                    return "xml";
                default:
                    return "nvarchar";
            }
        }

        public override string BuildDropColumnStatement(string tableName, string columnName)
        {
            //what a pain
            //http://grass.osgeo.org/wiki/Sqlite_Drop_Column
            Console.WriteLine("Can't drop a column from SQLite - you have to do this manually: http://grass.osgeo.org/wiki/Sqlite_Drop_Column");
            return "";
        }

        public override string BuildAlterColumnStatement(IColumn column)
        {
            //SQLite doesn't support altering columns. There is no typing either, or length considerations
            //so - unless we're adding/dropping, fuggedaboutit
            //http://stackoverflow.com/questions/623044/how-to-alter-sqlite-column-iphone
            return "";
        }

        /// <summary>
        /// Sets the column attributes.
        /// </summary>
        /// <param name="column">The column.</param>
        /// <returns></returns>
        public override string GenerateColumnAttributes(IColumn column)
        {
            StringBuilder sb = new StringBuilder();
            if (column.DataType == DbType.String && column.MaxLength > 8000)
                sb.Append(" TEXT ");
            else if (column.IsPrimaryKey && column.DataType == DbType.Int32
                || column.IsPrimaryKey && column.DataType == DbType.Int16
                || column.IsPrimaryKey && column.DataType == DbType.Int64
                )
                sb.Append(" integer ");
            else
                sb.Append(" " + GetNativeType(column.DataType));

            if(column.IsPrimaryKey)
            {
                sb.Append(" NOT NULL PRIMARY KEY");
                if(column.IsNumeric)
                    sb.Append(" AUTOINCREMENT ");
            }
            else
            {
                if(column.IsString && column.MaxLength < 8000)
                    sb.Append("(" + column.MaxLength + ")");
                else if(column.DataType == DbType.Double || column.DataType == DbType.Decimal)
                    sb.Append("(" + column.NumericPrecision + ", " + column.NumberScale + ")");

                if(!column.IsNullable)
                    sb.Append(" NOT NULL");
                else
                    sb.Append(" NULL");

                if(column.DefaultSetting != null)
                    sb.Append(" DEFAULT '" + column.DefaultSetting + "'");
            }

            return sb.ToString();
        }

        /// <summary>
        /// Gets the type of the db.
        /// </summary>
        /// <param name="sqlType">Type of the SQL.</param>
        /// <returns></returns>
        public override DbType GetDbType(string sqlType)
        {
            switch (sqlType.ToLowerInvariant())
            {
                case "longtext":
                case "nchar":
                case "ntext":
                case "text":
                case "sysname":
                case "varchar":
                case "nvarchar":
                    return DbType.String;
                case "bit":
                case "tinyint":
                    return DbType.Boolean;
                case "decimal":
                case "float":
                case "newdecimal":
                case "numeric":
                case "double":
                case "real":
                    return DbType.Decimal;
                case "int":
                case "int32":
                    return DbType.Int32;
                case "integer":
                    return DbType.Int64;
                case "int16":
                case "smallint":
                    return DbType.Int16;
                case "date":
                case "time":
                case "datetime":
                case "smalldatetime":
                    return DbType.DateTime;
                case "image":
                case "varbinary":
                case "binary":
                case "blob":
                case "longblob":
                    return DbType.Binary;
                case "char":
                    return DbType.AnsiStringFixedLength;
                case "currency":
                case "money":
                case "smallmoney":
                    return DbType.Currency;
                case "timestamp":
                    return DbType.DateTime;
                case "uniqueidentifier":
                    return DbType.Guid;
                case "uint16":
                    return DbType.UInt16;
                case "uint32":
                    return DbType.UInt32;
                default:
                    return DbType.String;
            }
        }


        public override void SetColumnDefaults(IColumn column) {
            if (column.IsNumeric)
                column.DefaultSetting = 0;
            else if (column.IsDateTime)
                column.DefaultSetting = "1900-01-01";
            else if (column.IsString)
                column.DefaultSetting = "";
            else if (column.DataType == DbType.Boolean)
                column.DefaultSetting = false;
        }
    
    }
}