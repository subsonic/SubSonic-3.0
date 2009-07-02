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
using System.Linq;

namespace SubSonic.Query
{
    public interface ISession
    {
        IQueryable<T> GetAll<T>() where T : class;
        void SubmitChanges();
        void Attach<T>(T item) where T : class;
        void Insert<T>(T item) where T : class;
        void Insert<T>(IEnumerable<T> items) where T : class;
        void Remove<T>(T item) where T : class;
        void Remove<T>(IEnumerable<T> items) where T : class;
    }
}