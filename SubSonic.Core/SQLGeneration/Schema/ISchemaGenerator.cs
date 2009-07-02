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
using SubSonic.DataProviders;
using SubSonic.Schema;

namespace SubSonic.SqlGeneration.Schema
{
    public interface ISchemaGenerator
    {
        /// <summary>
        /// Builds a CREATE TABLE statement.
        /// </summary>
        /// <param name="table"></param>
        /// <returns></returns>
        string BuildCreateTableStatement(ITable table);

        /// <summary>
        /// Builds a DROP TABLE statement.
        /// </summary>
        /// <param name="tableName">Name of the table.</param>
        /// <returns></returns>
        string BuildDropTableStatement(string tableName);

        /// <summary>
        /// Adds the column.
        /// </summary>
        /// <param name="tableName">Name of the table.</param>
        /// <param name="column">The column.</param>
        string BuildAddColumnStatement(string tableName, IColumn column);

        /// <summary>
        /// Alters the column.
        /// </summary>
        /// <param name="column">The column.</param>
        string BuildAlterColumnStatement(IColumn column);

        /// <summary>
        /// Removes the column.
        /// </summary>
        /// <param name="tableName">Name of the table.</param>
        /// <param name="columnName">Name of the column.</param>
        /// <returns></returns>
        string BuildDropColumnStatement(string tableName, string columnName);

        /// <summary>
        /// Gets the type of the native.
        /// </summary>
        /// <param name="dbType">Type of the db.</param>
        /// <returns></returns>
        string GetNativeType(DbType dbType);

        /// <summary>
        /// Generates the columns.
        /// </summary>
        /// <param name="table">Table containing the columns.</param>
        /// <returns>
        /// SQL fragment representing the supplied columns.
        /// </returns>
        string GenerateColumns(ITable table);

        /// <summary>
        /// Sets the column attributes.
        /// </summary>
        /// <param name="column">The column.</param>
        /// <returns></returns>
        string GenerateColumnAttributes(IColumn column);

        ITable GetTableFromDB(IDataProvider provider, string tableName);
        string[] GetTableList(IDataProvider provider);
        DbType GetDbType(string sqlType);
    }
}