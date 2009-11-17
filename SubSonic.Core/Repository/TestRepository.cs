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
using System.Linq.Expressions;
using SubSonic.Extensions;
using SubSonic.Query;
using SubSonic.Schema;

namespace SubSonic.Repository
{
    public class TestRepository<T> : IRepository<T> where T : IActiveRecord, new()
    {
        private readonly IQuerySurface _db;
        public List<T> _items;

        public TestRepository(IQuerySurface db)
        {
            _db = db;
            _items = new List<T>();
        }



        public object Add(T item)
        {
            _items = _items ?? new List<T>();
            _items.Add(item);
            return item.KeyValue();
        }

        public int DeleteMany(Expression<Func<T, bool>> expression)
        {
            return 0;
        }

        public int Delete(object key)
        {
            _items.Remove(_items.SingleOrDefault(x => x.KeyValue() == key));
            return 0;
        }

        public int Delete(T item)
        {
            _items.Remove(item);
            return 0;
        }

        public IQueryable<T> Find(Expression<Func<T, bool>> expression)
        {
            return GetAll().Where(expression);
        }

        public IQueryable<T> GetAll()
        {
            return _items.AsQueryable();
        }

        public T GetByKey(object key)
        {
            T result = new T();
            if(_items.Count > 0)
                result = _items.SingleOrDefault(x => x.KeyValue() == key);

            return result;
        }

        public PagedList<T> GetPaged(string sortBy, int pageIndex, int pageSize)
        {
            return new PagedList<T>(_items.ToList().AsQueryable(), pageIndex, pageSize);
        }

        public PagedList<T> GetPaged(int pageIndex, int pageSize)
        {
            return new PagedList<T>(_items.ToList().AsQueryable(), pageIndex, pageSize);
        }

        public PagedList<T> GetPaged<TKey>(Func<T, TKey> orderBy, int pageIndex, int pageSize)
        {
            return new PagedList<T>(_items.ToList().AsQueryable(), pageIndex, pageSize);
        }

        public ITable GetTable()
        {
            return _db.FindTable(typeof(T).Name);
        }

        public bool Load<T>(T item, string column, object value) where T : class, new()
        {
            if(item is IActiveRecord)
            {
                var activeItem = item as IActiveRecord;
                if(_items.Count > 0)
                {
                    //see if it's in there by key
                    activeItem = _items.SingleOrDefault(x => x.KeyValue() == value);

                    if(activeItem != null)
                    {
                        //ohhhhh this is ugly - but it's only for testing so I think we're OK
                        item = activeItem.CopyTo(item);
                    }
                }
            }
            return true;
        }

        public bool Load<T>(T item, Expression<Func<T, bool>> expression) where T : class, new()
        {
            return true;
        }

        public IList<T> Search(string column, string value)
        {
            return _items;
        }

        public int Update(T item)
        {
            var index = _items.FindIndex(x => x.KeyValue().ToString() == item.KeyValue().ToString());
            _items.RemoveAt(index);
            _items.Add(item);
            return 0;
        }

        public void Add(IEnumerable<T> items)
        {
            foreach(var item in items)
                _items.Add(item);
        }

        public int Update(IEnumerable<T> items)
        {
            foreach(var item in items)
                Update(item);
            return items.Count();
        }

        public int Delete(IEnumerable<T> items)
        {
            foreach(var item in items)
                _items.Remove(item);
            return items.Count();
        }



        /// <summary>
        /// Builds the delete query.
        /// </summary>
        /// <param name="item">The item.</param>
        /// <returns></returns>
        public ISqlQuery BuildDeleteQuery(T item)
        {
            return new Delete<T>();
        }

        /// <summary>
        /// Builds the insert query.
        /// </summary>
        /// <param name="item">The item.</param>
        /// <returns></returns>
        public ISqlQuery BuildInsertQuery(T item)
        {
            return new Insert();
        }

        /// <summary>
        /// Builds the update query.
        /// </summary>
        /// <param name="item">The item.</param>
        /// <returns></returns>
        public ISqlQuery BuildUpdateQuery(T item)
        {
            return new Update<T>(_db.Provider);
        }

        public object Add(T item, SubSonic.DataProviders.IDataProvider provider) {
            return Add(item);
        }

        public void Add(IEnumerable<T> items, SubSonic.DataProviders.IDataProvider provider) {
            Add(items);
        }

        public int Update(T item, SubSonic.DataProviders.IDataProvider provider) {
            return Update(item);
        }

        public int Update(IEnumerable<T> items, SubSonic.DataProviders.IDataProvider provider) {
            return Update(items);
        }

        public int Delete(T item, SubSonic.DataProviders.IDataProvider provider) {
            return Delete(item);
        }

        public int Delete(object key, SubSonic.DataProviders.IDataProvider provider) {
            return Delete(key);
        }

        public int DeleteMany(Expression<Func<T, bool>> expression, SubSonic.DataProviders.IDataProvider provider) {
            return DeleteMany(expression);
        }

        public int Delete(IEnumerable<T> items, SubSonic.DataProviders.IDataProvider provider) {
            return Delete(items);
        }

    }
}