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

namespace SubSonic.Schema
{
    public class DatabaseSchema : IDatabaseSchema
    {
        public DatabaseSchema()
        {
            Tables = new List<ITable>();
            Views = new List<IView>();
            StoredProcedures = new List<IStoredProcedure>();
            DbObjects = new List<IDBObject>();
        }


        #region IDatabaseSchema Members

        public IList<IDBObject> DbObjects { get; set; }
        public IList<ITable> Tables { get; set; }
        public IList<IView> Views { get; set; }
        public IList<IStoredProcedure> StoredProcedures { get; set; }

        #endregion


        /// <summary>
        /// Returns Schema instance with empty lists.
        /// </summary>
        internal static IDatabaseSchema Empty()
        {
            return new DatabaseSchema();
        }
    }
}