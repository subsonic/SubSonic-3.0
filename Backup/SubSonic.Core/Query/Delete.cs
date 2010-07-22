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
using SubSonic.DataProviders;
using SubSonic.Schema;

namespace SubSonic.Query
{
    public class Destroy<T> : Delete<T> where T : new() {}

    /// <summary>
    /// 
    /// </summary>
    public class Delete<T> : SqlQuery where T : new()
    {

        /// <summary>
        /// Initializes a new instance of the <see cref="Delete&lt;T&gt;"/> class.
        /// </summary>
        public Delete() : this(ProviderFactory.GetProvider()) {}

        /// <summary>
        /// Initializes a new instance of the <see cref="Delete&lt;T&gt;"/> class.
        /// </summary>
        /// <param name="table">The table.</param>
        /// <param name="provider">The provider.</param>
        public Delete(ITable table, IDataProvider provider)
        {
            QueryCommandType = QueryType.Delete;
            _provider = provider;
            ITable tbl = table;
            //string tableName = table.Name;
            FromTables.Add(tbl);
        }

        public Delete(IDataProvider provider) : this(provider.FindTable(typeof(T).Name), provider) {}
    }

    /// <summary>
    /// 
    /// </summary>
    public enum QueryType
    {
        /// <summary>
        /// 
        /// </summary>
        Select,
        /// <summary>
        /// 
        /// </summary>
        Update,
        /// <summary>
        /// 
        /// </summary>
        Insert,
        /// <summary>
        /// 
        /// </summary>
        Delete
    }

}