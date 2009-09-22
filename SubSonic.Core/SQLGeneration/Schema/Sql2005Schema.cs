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
using SubSonic.Schema;
using System;

namespace SubSonic.SqlGeneration.Schema
{
    public class Sql2005Schema : ANSISchemaGenerator
    {
        public Sql2005Schema()
        {
            ADD_COLUMN = @"ALTER TABLE [{0}] ADD {1}{2};";
            ALTER_COLUMN = @"ALTER TABLE [{0}] ALTER COLUMN {1}{2};";
            CREATE_TABLE = "CREATE TABLE [{0}] ({1} \r\n);";
            DROP_COLUMN = @"ALTER TABLE [{0}] DROP COLUMN {1};";
            DROP_TABLE = @"DROP TABLE {0};";
        }

        /// <summary>
        /// Removes the column.
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="columnName"></param>
        /// <returns></returns>
        public override string BuildDropColumnStatement(string tableName, string columnName)
        {
            StringBuilder sql = new StringBuilder();

            string defConstraint = string.Format("DF_{0}_{1}", tableName, columnName);

            sql.AppendFormat("IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[{0}]') AND type = 'D')\r\n",
                defConstraint);
            sql.AppendLine("BEGIN");
            sql.AppendFormat("ALTER TABLE {0} DROP CONSTRAINT [{1}]\r\n", tableName, defConstraint);
            sql.AppendLine("END");

            //if this is a PK we'll need to drop that too

            //check to see if there are any constraints
            //QueryCommand cmd;
            //if (column.DefaultSetting != null) {
            //    sql.AppendFormat("ALTER TABLE {0} DROP CONSTRAINT DF_{0}_{1}", tableName, columnName);
            //    sql.Append(";\r\n");

            //    //drop FK constraints ...

            //    //drop CHECK constraints ...
            //}

            sql.AppendFormat(DROP_COLUMN, tableName, columnName);
            return sql.ToString();
        }

        public override string BuildCreateTableStatement(ITable table)
        {
            var result = base.BuildCreateTableStatement(table);

            //add a named PK constraint so we can drop it later
            result += "ALTER TABLE " + table.QualifiedName + "\r\n";
            result += string.Format("ADD CONSTRAINT PK_{0}_{1} PRIMARY KEY([{1}])", table.Name, table.PrimaryKey.Name);

            return result;
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
                    return "bit";
                case DbType.SByte:
                case DbType.Binary:
                case DbType.Byte:
                    return "image";
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
                    return "uniqueidentifier";
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
        /// Sets the column attributes.
        /// </summary>
        /// <param name="column">The column.</param>
        /// <returns></returns>
        public override string GenerateColumnAttributes(IColumn column)
        {
            StringBuilder sb = new StringBuilder();
            if(column.DataType == DbType.String && column.MaxLength > 8000)
            {
                //use nvarchar MAX 
                //TODO - this won't work for SQL 2000
                //need to tell the diff somehow
                sb.Append(" nvarchar(MAX)");
            }
            else
            {
                sb.Append(" " + GetNativeType(column.DataType));

                if(column.MaxLength > 0)
                    sb.Append("(" + column.MaxLength + ")");

                if(column.DataType == DbType.Decimal)
                    sb.Append("(" + column.NumericPrecision + ", " + column.NumberScale + ")");
            }

            if(column.IsPrimaryKey | ! column.IsNullable)
                sb.Append(" NOT NULL");

            if(column.IsPrimaryKey && column.IsNumeric)
                sb.Append(" IDENTITY(1,1)");
            else if (column.IsPrimaryKey && column.DataType==DbType.Guid)
                column.DefaultSetting="NEWID()";


            if(column.DefaultSetting != null)
            {

                var defaultType = column.DefaultSetting.GetType();
                var defaultValue = column.DefaultSetting;
                if (defaultType == typeof(string) || defaultType == typeof(DateTime)) {
                    if(!column.DefaultSetting.ToString().EndsWith("()"))
                        defaultValue = string.Format("'{0}'", defaultValue);
                }
                
                sb.Append(" CONSTRAINT DF_" + column.Table.Name + "_" + column.Name + " DEFAULT (" +
                          defaultValue + ")");
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
            switch(sqlType)
            {
                case "varchar":
                    return DbType.AnsiString;
                case "nvarchar":
                    return DbType.String;
                case "int":
                    return DbType.Int32;
                case "uniqueidentifier":
                    return DbType.Guid;
                case "datetime":
                case "datetime2":
                    return DbType.DateTime;
                case "bigint":
                    return DbType.Int64;
                case "binary":
                    return DbType.Binary;
                case "bit":
                    return DbType.Boolean;
                case "char":
                    return DbType.AnsiStringFixedLength;
                case "decimal":
                    return DbType.Decimal;
                case "float":
                    return DbType.Double;
                case "image":
                    return DbType.Binary;
                case "money":
                    return DbType.Currency;
                case "nchar":
                    return DbType.String;
                case "ntext":
                    return DbType.String;
                case "numeric":
                    return DbType.Decimal;
                case "real":
                    return DbType.Single;
                case "smalldatetime":
                    return DbType.DateTime;
                case "smallint":
                    return DbType.Int16;
                case "smallmoney":
                    return DbType.Currency;
                case "sql_variant":
                    return DbType.String;
                case "sysname":
                    return DbType.String;
                case "text":
                    return DbType.AnsiString;
                case "timestamp":
                    return DbType.Binary;
                case "tinyint":
                    return DbType.Byte;
                case "varbinary":
                    return DbType.Binary;
                default:
                    return DbType.AnsiString;
            }
        }
    }
}