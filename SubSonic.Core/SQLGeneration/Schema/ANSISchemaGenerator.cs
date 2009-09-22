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
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Text;
using SubSonic.Extensions;
using SubSonic.DataProviders;
using SubSonic.Schema;

namespace SubSonic.SqlGeneration.Schema
{
    /// <summary>
    /// A schema generator for your DB
    /// </summary>
    public abstract class ANSISchemaGenerator : ISchemaGenerator
    {
        protected string ADD_COLUMN = @"ALTER TABLE {0} ADD {1}{2};";
        protected string ALTER_COLUMN = @"ALTER TABLE {0} ALTER COLUMN {1}{2};";
        protected string CREATE_TABLE = "CREATE TABLE {0} ({1} \r\n);";
        protected string DROP_COLUMN = @"ALTER TABLE {0} DROP COLUMN {1};";
        protected string DROP_TABLE = @"DROP TABLE {0};";


        #region ISchemaGenerator Members

        /// <summary>
        /// Builds a CREATE TABLE statement.
        /// </summary>
        /// <param name="table"></param>
        /// <returns></returns>
        public virtual string BuildCreateTableStatement(ITable table)
        {
            string columnSql = GenerateColumns(table);
            return string.Format(CREATE_TABLE, table.Name, columnSql);
        }

        /// <summary>
        /// Builds a DROP TABLE statement.
        /// </summary>
        /// <param name="tableName">Name of the table.</param>
        /// <returns></returns>
        public virtual string BuildDropTableStatement(string tableName)
        {
            return string.Format(DROP_TABLE, tableName);
        }

        /// <summary>
        /// Adds the column.
        /// </summary>
        /// <param name="tableName">Name of the table.</param>
        /// <param name="column">The column.</param>
        /// <returns></returns>
        public virtual string BuildAddColumnStatement(string tableName, IColumn column)
        {
            var sql = new StringBuilder();

            //if we're adding a Non-null column to the DB schema, there has to be a default value
            //otherwise it will result in an error'
            if (!column.IsNullable && column.DefaultSetting == null)
            {
                SetColumnDefaults(column);
            }

            sql.AppendFormat(ADD_COLUMN, tableName, column.Name, GenerateColumnAttributes(column));
            
            //if the column isn't nullable and there are records already
            //the default setting won't be honored and a null value could be entered (in SQLite for instance)
            //enforce the default setting here
            if(!column.IsNullable)
            {
                sql.AppendLine();
                if (column.IsString || column.IsDateTime)
                    sql.AppendFormat("UPDATE {0} SET {1}='{2}';", tableName, column.Name, column.DefaultSetting);
                else {
                    sql.AppendFormat("UPDATE {0} SET {1}={2};", tableName, column.Name, column.DefaultSetting);
                }
            }
            
            return sql.ToString();
        }

        /// <summary>
        /// Alters the column.
        /// </summary>
        /// <param name="column">The column.</param>
        public virtual string BuildAlterColumnStatement(IColumn column)
        {
            var sql = new StringBuilder();
            sql.AppendFormat(ALTER_COLUMN, column.Table.Name, column.Name, GenerateColumnAttributes(column));
            return sql.ToString();
        }

        /// <summary>
        /// Removes the column.
        /// </summary>
        /// <param name="tableName">Name of the table.</param>
        /// <param name="columnName">Name of the column.</param>
        /// <returns></returns>
        public virtual string BuildDropColumnStatement(string tableName, string columnName)
        {
            StringBuilder sql = new StringBuilder();
            sql.AppendFormat(DROP_COLUMN, tableName, columnName);
            return sql.ToString();
        }

        /// <summary>
        /// Gets the type of the native.
        /// </summary>
        /// <param name="dbType">Type of the db.</param>
        /// <returns></returns>
        public abstract string GetNativeType(DbType dbType);

        /// <summary>
        /// Generates the columns.
        /// </summary>
        /// <param name="table">Table containing the columns.</param>
        /// <returns>
        /// SQL fragment representing the supplied columns.
        /// </returns>
        public virtual string GenerateColumns(ITable table)
        {
            StringBuilder createSql = new StringBuilder();

            foreach(IColumn col in table.Columns)
                createSql.AppendFormat("\r\n  [{0}]{1},", col.Name, GenerateColumnAttributes(col));
            string columnSql = createSql.ToString();
            return columnSql.Chop(",");
        }

        /// <summary>
        /// Sets the column attributes.
        /// </summary>
        /// <param name="column">The column.</param>
        /// <returns></returns>
        public abstract string GenerateColumnAttributes(IColumn column);

        ///<summary>
        ///Gets an ITable from the DB based on name
        ///</summary>
        public virtual ITable GetTableFromDB(IDataProvider provider, string tableName)
        {
            ITable result = null;
            DataTable schema;

            using(var scope = new AutomaticConnectionScope(provider))
            {
                var restrictions = new string[4] {null, null, tableName, null};
                schema = scope.Connection.GetSchema("COLUMNS", restrictions);
            }

            if(schema.Rows.Count > 0)
            {
                result = new DatabaseTable(tableName, provider);
                foreach(DataRow dr in schema.Rows)
                {
                    IColumn col = new DatabaseColumn(dr["COLUMN_NAME"].ToString(), result);
                    col.DataType = GetDbType(dr["DATA_TYPE"].ToString());
                    col.IsNullable = dr["IS_NULLABLE"].ToString() == "YES";

                    string maxLength = dr["CHARACTER_MAXIMUM_LENGTH"].ToString();

                    int iMax = 0;
                    int.TryParse(maxLength, out iMax);
                    col.MaxLength = iMax;
                    result.Columns.Add(col);
                }
            }

            return result;
        }

        /// <summary>
        /// Creates a list of table names
        /// </summary>
        public virtual string[] GetTableList(IDataProvider provider)
        {
            List<string> result = new List<string>();
            using(DbConnection conn = provider.CreateConnection())
            {
                conn.Open();
                var schema = conn.GetSchema("TABLES");
                conn.Close();

                foreach(DataRow dr in schema.Rows)
                {
                    if(dr["TABLE_TYPE"].ToString().Equals("BASE TABLE"))
                        result.Add(dr["TABLE_NAME"].ToString());
                }
            }
            return result.ToArray();
        }

        public abstract DbType GetDbType(string sqlType);

        #endregion


        public virtual void SetColumnDefaults(IColumn column)
        {
            if(column.IsNumeric)
                column.DefaultSetting = 0;
            else if(column.IsDateTime)
                column.DefaultSetting = DateTime.Parse("1/1/1900");
            else if(column.IsString)
                column.DefaultSetting = "";
            else if(column.DataType == DbType.Boolean)
                column.DefaultSetting = 0;
        }
    }
}