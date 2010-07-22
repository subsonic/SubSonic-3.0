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
using System.Collections.Generic;
using SubSonic.Query;
using SubSonic.Schema;

namespace SubSonic.SqlGeneration
{
    /// <summary>
    /// 
    /// </summary>
    public interface ISqlGenerator
    {
        /// <summary>
        /// SqlFragment. Field values may change depending on the inheriting Generator.
        /// </summary>
        SqlFragment sqlFragment { get; }

        /// <summary>
        /// Generates the command line.
        /// </summary>
        /// <returns></returns>
        string GenerateCommandLine();

        /// <summary>
        /// Generates the constraints.
        /// </summary>
        /// <returns></returns>
        string GenerateConstraints();

        /// <summary>
        /// Generates from list.
        /// </summary>
        /// <returns></returns>
        string GenerateFromList();

        /// <summary>
        /// Generates the order by.
        /// </summary>
        /// <returns></returns>
        string GenerateOrderBy();

        /// <summary>
        /// Generates the group by.
        /// </summary>
        /// <returns></returns>
        string GenerateGroupBy();

        /// <summary>
        /// Generates the joins.
        /// </summary>
        /// <returns></returns>
        string GenerateJoins();

        /// <summary>
        /// Gets the paging SQL wrapper.
        /// </summary>
        /// <returns></returns>
        string GetPagingSqlWrapper();

        /// <summary>
        /// Gets the select columns.
        /// </summary>
        /// <returns></returns>
        List<string> GetSelectColumns();

        /// <summary>
        /// Finds the column.
        /// </summary>
        /// <param name="columnName">Name of the column.</param>
        /// <returns></returns>
        IColumn FindColumn(string columnName);

        /// <summary>
        /// Builds the select statement.
        /// </summary>
        /// <returns></returns>
        string BuildSelectStatement();

        /// <summary>
        /// Builds the paged select statement.
        /// </summary>
        /// <returns></returns>
        string BuildPagedSelectStatement();

        /// <summary>
        /// Builds the update statement.
        /// </summary>
        /// <returns></returns>
        string BuildUpdateStatement();

        /// <summary>
        /// Builds the insert statement.
        /// </summary>
        /// <returns></returns>
        string BuildInsertStatement();

        /// <summary>
        /// Builds the delete statement.
        /// </summary>
        /// <returns></returns>
        string BuildDeleteStatement();

        /// <summary>
        /// Sets the insert query.
        /// </summary>
        /// <param name="q">The q.</param>
        void SetInsertQuery(Insert q);
    }
}