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
using System.Reflection;
using SubSonic.Extensions;
using SubSonic.DataProviders;
using SubSonic.Query;
using SubSonic.Schema;
using SubSonic.Linq.Structure;

namespace SubSonic.Repository
{
    public class SimpleRepository : IRepository
    {
        private readonly IDataProvider _provider;
        private readonly List<Type> migrated;
        private readonly SimpleRepositoryOptions _options=SimpleRepositoryOptions.Default;
        
        public SimpleRepository() : this(ProviderFactory.GetProvider(),SimpleRepositoryOptions.Default) {}

        public SimpleRepository(string connectionStringName)
            : this(connectionStringName,SimpleRepositoryOptions.Default) { }

        public SimpleRepository(string connectionStringName, SimpleRepositoryOptions options)
            : this(ProviderFactory.GetProvider(connectionStringName), options) { }


        public SimpleRepository(SimpleRepositoryOptions options) : this(ProviderFactory.GetProvider(), options) { }

        public SimpleRepository(IDataProvider provider) : this(provider, SimpleRepositoryOptions.Default) {}

        public SimpleRepository(IDataProvider provider, SimpleRepositoryOptions options)
        {
            _provider = provider;
            _options = options;
            if (_options.Contains(SimpleRepositoryOptions.RunMigrations))
                migrated = new List<Type>();
        }


        #region IRepository Members


        public bool Exists<T>(Expression<Func<T, bool>> expression) where T : class, new()
        {
            return All<T>().Any(expression);
        }

        public IQueryable<T> All<T>() where T : class, new()
        {
            if (_options.Contains(SimpleRepositoryOptions.RunMigrations))
                Migrate<T>();

            var qry = new Query<T>(_provider);
            return qry;
        }


        /// <summary>
        /// Singles the specified expression.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="expression">The expression.</param>
        /// <returns></returns>
        public T Single<T>(Expression<Func<T, bool>> expression) where T : class, new()
        {
            if (_options.Contains(SimpleRepositoryOptions.RunMigrations))
                Migrate<T>();
            T result = default(T);
            var tbl = _provider.FindOrCreateTable<T>();

            var qry = new Select(_provider).From(tbl);
            var constraints = expression.ParseConstraints().ToList();
            qry.Constraints = constraints;
            var list = qry.ToList<T>();
            if(list.Count > 0)
                result = list[0];
            return result;
        }

        /// <summary>
        /// Singles the specified key.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="key">The key.</param>
        /// <returns></returns>
        public T Single<T>(object key) where T : class, new()
        {
            if (_options.Contains(SimpleRepositoryOptions.RunMigrations))
                Migrate<T>();
            var tbl = _provider.FindOrCreateTable<T>();

            var result = new Select(_provider).From(tbl).Where(tbl.PrimaryKey).IsEqualTo(key).ExecuteSingle<T>();

            return result;
        }

        /// <summary>
        /// Retrieves subset of records from the database matching the expression
        /// </summary>
        public IList<T> Find<T>(Expression<Func<T, bool>> expression) where T : class, new()
        {
            if (_options.Contains(SimpleRepositoryOptions.RunMigrations))
                Migrate<T>();
            var tbl = _provider.FindOrCreateTable<T>();

            var qry = new Select(_provider).From(tbl);
            var constraints = expression.ParseConstraints().ToList();
            qry.Constraints = constraints;
            return qry.ExecuteTypedList<T>();
        }

        /// <summary>
        /// Gets the paged.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="pageIndex">Index of the page.</param>
        /// <param name="pageSize">Size of the page.</param>
        /// <returns></returns>
        public PagedList<T> GetPaged<T>(int pageIndex, int pageSize) where T : class, new()
        {
            if (_options.Contains(SimpleRepositoryOptions.RunMigrations))
                Migrate<T>();
            var tbl = _provider.FindOrCreateTable<T>();
            var qry = new Select(_provider).From(tbl).Paged(pageIndex + 1, pageSize).OrderAsc(tbl.PrimaryKey.Name);
            var total =
                new Select(_provider, new Aggregate(tbl.PrimaryKey, AggregateFunction.Count)).From<T>().ExecuteScalar();
            int totalRecords = 0;
            int.TryParse(total.ToString(), out totalRecords);
            return new PagedList<T>(qry.ToList<T>(), totalRecords, pageIndex, pageSize);
        }

        /// <summary>
        /// Gets the paged.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="sortBy">The sort by.</param>
        /// <param name="pageIndex">Index of the page.</param>
        /// <param name="pageSize">Size of the page.</param>
        /// <returns></returns>
        public PagedList<T> GetPaged<T>(string sortBy, int pageIndex, int pageSize) where T : class, new()
        {
            if (_options.Contains(SimpleRepositoryOptions.RunMigrations))
                Migrate<T>();
            var tbl = _provider.FindOrCreateTable<T>();
            var qry = new Select(_provider).From(tbl).Paged(pageIndex + 1, pageSize).OrderAsc(sortBy);
            var total =
                new Select(_provider, new Aggregate(tbl.PrimaryKey, AggregateFunction.Count)).From<T>().ExecuteScalar();

            return new PagedList<T>(qry.ToList<T>(), (int)total, pageIndex, pageSize);
        }

        /// <summary>
        /// Adds the specified item, setting the key if available.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="item">The item.</param>
        /// <returns></returns>
        public object Add<T>(T item) where T : class, new()
        {
            if (_options.Contains(SimpleRepositoryOptions.RunMigrations))
                Migrate<T>();

            object result = null;
            using(var rdr = item.ToInsertQuery(_provider).ExecuteReader())
            {
                if(rdr.Read())
                    result = rdr[0];
            }

            //for Rick :)
            if (result != null && result != DBNull.Value) {
                try {
                    var tbl =  _provider.FindOrCreateTable(typeof(T));
                    var prop = item.GetType().GetProperty(tbl.PrimaryKey.Name);
                    var settable = result.ChangeTypeTo(prop.PropertyType);
                    prop.SetValue(item, settable, null);

                } catch(Exception x) {
                    //swallow it - I don't like this per se but this is a convenience and we
                    //don't want to throw the whole thing just because we can't auto-set the value
                }
            }

            return result;
        }

        /// <summary>
        /// Adds a lot of the items using a transaction.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="items">The items.</param>
        public void AddMany<T>(IEnumerable<T> items) where T : class, new()
        {
            if (_options.Contains(SimpleRepositoryOptions.RunMigrations))
                Migrate<T>();

            BatchQuery batch = new BatchQuery(_provider);
            foreach(var item in items)
                batch.QueueForTransaction(item.ToInsertQuery(_provider));
            batch.ExecuteTransaction();
        }

        /// <summary>
        /// Updates the specified item.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="item">The item.</param>
        /// <returns></returns>
        public int Update<T>(T item) where T : class, new()
        {
            if (_options.Contains(SimpleRepositoryOptions.RunMigrations))
                Migrate<T>();
            return item.ToUpdateQuery(_provider).Execute();
        }

        /// <summary>
        /// Updates lots of items using a transaction.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="items">The items.</param>
        /// <returns></returns>
        public int UpdateMany<T>(IEnumerable<T> items) where T : class, new()
        {
            if (_options.Contains(SimpleRepositoryOptions.RunMigrations))
                Migrate<T>();
            BatchQuery batch = new BatchQuery(_provider);
            int result = 0;
            foreach(var item in items)
            {
                batch.QueueForTransaction(item.ToUpdateQuery(_provider));
                result++;
            }
            batch.ExecuteTransaction();
            return result;
        }

        /// <summary>
        /// Deletes the specified key.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="key">The key.</param>
        /// <returns></returns>
        public int Delete<T>(object key) where T : class, new()
        {
            if (_options.Contains(SimpleRepositoryOptions.RunMigrations))
                Migrate<T>();

            var tbl = _provider.FindOrCreateTable<T>();
            return new Delete<T>(_provider).From<T>().Where(tbl.PrimaryKey).IsEqualTo(key).Execute();
        }

        /// <summary>
        /// Deletes 1 or more items.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="expression">The expression.</param>
        /// <returns></returns>
        public int DeleteMany<T>(Expression<Func<T, bool>> expression) where T : class, new()
        {
            if (_options.Contains(SimpleRepositoryOptions.RunMigrations))
                Migrate<T>();

            var tbl = _provider.FindOrCreateTable<T>();
            var qry = new Delete<T>(_provider).From<T>();

            var constraints = expression.ParseConstraints().ToList();
            qry.Constraints = constraints;

            return qry.Execute();
        }

        /// <summary>
        /// Deletes 1 or more items.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="items">The items.</param>
        /// <returns></returns>
        public int DeleteMany<T>(IEnumerable<T> items) where T : class, new()
        {
            if (_options.Contains(SimpleRepositoryOptions.RunMigrations))
                Migrate<T>();

            BatchQuery batch = new BatchQuery(_provider);
            int result = 0;
            foreach(var item in items)
            {
                batch.QueueForTransaction(item.ToDeleteQuery(_provider));
                result++;
            }
            batch.ExecuteTransaction();
            return result;
        }

        #endregion


        /// <summary>
        /// Migrates this instance.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        private void Migrate<T>() where T : class, new()
        {
            Type type = typeof(T);
            if(!migrated.Contains(type))
            {
                BatchQuery batch = new BatchQuery(_provider);
                Migrator m = new Migrator(Assembly.GetExecutingAssembly());
                var commands = m.MigrateFromModel(type, _provider);
                foreach(var s in commands)
                    batch.QueueForTransaction(new QueryCommand(s, _provider));
                batch.ExecuteTransaction();
                migrated.Add(type);
            }
        }
    }
}