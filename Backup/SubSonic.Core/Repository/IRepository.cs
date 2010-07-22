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
using SubSonic.Schema;
using SubSonic.DataProviders;

namespace SubSonic.Repository
{
    public interface IRepository<T>
    {
        IQueryable<T> GetAll();
        PagedList<T> GetPaged<TKey>(Func<T, TKey> orderBy, int pageIndex, int pageSize);
        PagedList<T> GetPaged(int pageIndex, int pageSize);
        PagedList<T> GetPaged(string sortBy, int pageIndex, int pageSize);
        IList<T> Search(string column, string value);
        IQueryable<T> Find(Expression<Func<T, bool>> expression);
        
        object Add(T item);
        object Add(T item, IDataProvider provider);

        void Add(IEnumerable<T> items);
        void Add(IEnumerable<T> items, IDataProvider provider);

        int Update(T item);
        int Update(T item, IDataProvider provider);

        int Update(IEnumerable<T> items);
        int Update(IEnumerable<T> items, IDataProvider provider);

        int Delete(T item);
        int Delete(T item, IDataProvider provider);

        int Delete(object key);
        int Delete(object key, IDataProvider provider);

        int DeleteMany(Expression<Func<T, bool>> expression);
        int DeleteMany(Expression<Func<T, bool>> expression, IDataProvider provider);

        int Delete(IEnumerable<T> items);
        int Delete(IEnumerable<T> items, IDataProvider provider);

        
        T GetByKey(object key);
        ITable GetTable();
        bool Load<T>(T item, Expression<Func<T, bool>> expression) where T : class, new();
        bool Load<T>(T item, string column, object value) where T : class, new();
    }

    public interface IRepository
    {

        bool Exists<T>(Expression<Func<T, bool>> expression) where T : class, new();
        IQueryable<T> All<T>() where T : class, new();
        T Single<T>(object key) where T : class, new();
        T Single<T>(Expression<Func<T, bool>> expression) where T : class, new();
        IList<T> Find<T>(Expression<Func<T, bool>> expression) where T : class, new();
        PagedList<T> GetPaged<T>(int pageIndex, int pageSize) where T : class, new();
        PagedList<T> GetPaged<T>(string sortBy, int pageIndex, int pageSize) where T : class, new();

        object Add<T>(T item) where T : class, new();
        void AddMany<T>(IEnumerable<T> items) where T : class, new();
        int Update<T>(T item) where T : class, new();
        int UpdateMany<T>(IEnumerable<T> items) where T : class, new();
        int Delete<T>(object key) where T : class, new();
        int DeleteMany<T>(Expression<Func<T, bool>> expression) where T : class, new();
        int DeleteMany<T>(IEnumerable<T> items) where T : class, new();
    }
}