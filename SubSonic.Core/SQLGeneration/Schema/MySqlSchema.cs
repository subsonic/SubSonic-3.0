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
using System.Data;
using System.Text;
using SubSonic.Extensions;
using SubSonic.Schema;

namespace SubSonic.SqlGeneration.Schema
{
    public class MySqlSchema : ANSISchemaGenerator
    {
        public MySqlSchema()
        {
            ADD_COLUMN = @"ALTER TABLE `{0}` ADD `{1}`{2};";
            ALTER_COLUMN = @"ALTER TABLE `{0}` MODIFY `{1}`{2};";
            CREATE_TABLE = "CREATE TABLE `{0}` ({1} \r\n) ";
            DROP_COLUMN = @"ALTER TABLE `{0}` DROP COLUMN `{1}`;";
            DROP_TABLE = @"DROP TABLE {0};";
        }

        /// <summary>
        /// Gets the type of the native.
        /// </summary>
        /// <param name="dbType">Type of the db.</param>
        /// <returns></returns>
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
                    return "binary";
                case DbType.UInt32:
                case DbType.UInt16:
                case DbType.Int16:
                case DbType.Int32:
                case DbType.UInt64:
                case DbType.Int64:
                    return "int";
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

        /// <summary>
        /// Generates the columns.
        /// </summary>
        /// <param name="table">Table containing the columns.</param>
        /// <returns>
        /// SQL fragment representing the supplied columns.
        /// </returns>
        public override string GenerateColumns(ITable table)
        {
            StringBuilder createSql = new StringBuilder();

            foreach(IColumn col in table.Columns)
                createSql.AppendFormat("\r\n  `{0}`{1},", col.Name, GenerateColumnAttributes(col));
            string columnSql = createSql.ToString();
            return columnSql.Chop(",");
        }

        /// <summary>
        /// Builds a CREATE TABLE statement.
        /// </summary>
        /// <param name="table"></param>
        /// <returns></returns>
        public override string BuildCreateTableStatement(ITable table)
        {
            string result = base.BuildCreateTableStatement(table);

            result += "\r\nENGINE=InnoDB DEFAULT CHARSET=utf8";
            return result;
        }

        /// <summary>
        /// Sets the column attributes.
        /// </summary>
        /// <param name="column">The column.</param>
        /// <returns></returns>
        public override string GenerateColumnAttributes(IColumn column)
        {
            StringBuilder sb = new StringBuilder();
            if(column.DataType == DbType.Guid)
                column.MaxLength = 16;

            if(column.DataType == DbType.String && column.MaxLength > 8000)
                sb.Append(" LONGTEXT ");
            else
            {
                sb.Append(" " + GetNativeType(column.DataType));

                if(column.MaxLength > 0)
                    sb.Append("(" + column.MaxLength + ")");

                if(column.DataType == DbType.Double || column.DataType == DbType.Decimal)
                    sb.Append("(" + column.NumericPrecision + ", " + column.NumberScale + ")");
            }
            if(column.IsPrimaryKey)
                sb.Append(" PRIMARY KEY ");

            if(column.IsPrimaryKey | !column.IsNullable)
                sb.Append(" NOT NULL ");

            if(column.IsPrimaryKey && column.IsNumeric)
                sb.Append(" auto_increment ");

            if(column.DefaultSetting != null)
                sb.Append(" DEFAULT '" + column.DefaultSetting + "'");

            return sb.ToString();
        }

        /// <summary>
        /// Gets the type of the db.
        /// </summary>
        /// <param name="mySqlType">Type of my SQL.</param>
        /// <returns></returns>
        public override DbType GetDbType(string mySqlType)
        {
            switch(mySqlType.ToLowerInvariant())
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
                case "bigint":
                    return DbType.Int64;
                case "int":
                case "int32":
                case "integer":
                    return DbType.Int32;
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
                    return DbType.Binary;
                case "uint16":
                    return DbType.UInt16;
                case "uint32":
                    return DbType.UInt32;
                default:
                    return DbType.String;
            }
        }
    }
}