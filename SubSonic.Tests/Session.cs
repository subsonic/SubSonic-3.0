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
using System.Linq;
using SubSonic.Query;

namespace SubSonic.Tests
{
    public class Session : ISession
    {
        private Dictionary<object, object> InstanceList;

        public Session()
        {
            InstanceList = new Dictionary<object, object>();
        }


        #region ISession Members

        public IQueryable<T> GetAll<T>() where T : class
        {
            throw new NotImplementedException();
        }

        public void SubmitChanges()
        {
            throw new NotImplementedException();
        }

        public void Attach<T>(T item) where T : class
        {
            throw new NotImplementedException();
        }

        public void Insert<T>(T item) where T : class
        {
            throw new NotImplementedException();
        }

        public void Insert<T>(IEnumerable<T> items) where T : class
        {
            throw new NotImplementedException();
        }

        public void Remove<T>(T item) where T : class
        {
            throw new NotImplementedException();
        }

        public void Remove<T>(IEnumerable<T> items) where T : class
        {
            throw new NotImplementedException();
        }

        #endregion


        private void Store<T>(T item, InstanceState state) where T : class, new()
        {
            //see if it's in the list
            object hash = item.GetHashCode();
            object found = InstanceList[hash];
            InstanceOf<T> instance = new InstanceOf<T>(item, state);

            if(found != null)
                InstanceList[hash] = instance;
            else
                InstanceList.Add(hash, instance);
        }
    }

    internal enum InstanceState
    {
        New,
        Altered,
        Deleted
    }

    internal class InstanceOf<T> where T : class, new()
    {
        public QueryCommand Command;
        public object HashCode;
        private InstanceState State;
        public InstanceOf(T item) : this(item, InstanceState.Altered) {}

        public InstanceOf(T item, InstanceState state)
        {
            HashCode = item.GetHashCode();
            State = state;
        }

        public T Instance { get; set; }
    }
}