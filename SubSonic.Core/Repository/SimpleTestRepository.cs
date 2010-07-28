using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.Repository;
using SubSonic.Schema;
using SubSonic.Extensions;
using System.Linq.Expressions;
using System.Reflection;

namespace SubSonic.Repository
{
    public class SimpleTestRepository : IRepository
    {
        private DataStorage _storage;

        public SimpleTestRepository()
        {
            _storage = new DataStorage();
        }

        public object Add<T>(T item) where T : class, new()
        {
            return Table<T>().Add(item);
        }

        public void AddMany<T>(IEnumerable<T> items) where T : class, new()
        {
            foreach (var item in items)
            {
                Add(item);
            }
        }

        public IQueryable<T> All<T>() where T : class, new()
        {
            return Table<T>().All();
        }

        public int Delete<T>(object key) where T : class, new()
        {
            return Table<T>().Delete(key);
        }

        public int DeleteMany<T>(IEnumerable<T> items) where T : class, new()
        {
            return Table<T>().DeleteMany(items);
        }

        public int DeleteMany<T>(Expression<Func<T, bool>> expression) where T : class, new()
        {
            return Table<T>().DeleteMany(expression);
        }

        public bool Exists<T>(Expression<Func<T, bool>> expression) where T : class, new()
        {
            return Table<T>().Exists(expression);
        }

        public IList<T> Find<T>(Expression<Func<T, bool>> expression) where T : class, new()
        {
            return Table<T>().All().Where(expression).ToList();
        }

        public PagedList<T> GetPaged<T>(string sortBy, int pageIndex, int pageSize) where T : class, new()
        {
            return Table<T>().GetPaged(sortBy, pageIndex, pageSize);
        }

        public PagedList<T> GetPaged<T>(int pageIndex, int pageSize) where T : class, new()
        {
            return Table<T>().GetPaged(pageIndex, pageSize);
        }

        public T Single<T>(Expression<Func<T, bool>> expression) where T : class, new()
        {
            return Table<T>().Single(expression);
        }

        public T Single<T>(object key) where T : class, new()
        {
            return Table<T>().Single(key);
        }

        public int Update<T>(T item) where T : class, new()
        {
            return Table<T>().Update(item);
        }

        public int UpdateMany<T>(IEnumerable<T> items) where T : class, new()
        {
            int i = 0;
            foreach (var item in items)
            {
                i += Update(item);
            }

            return i;
        }

        private ItemStorage<T> Table<T>()
        {
            return _storage.FindOrCreateTable<T>();
        }

        private class DataStorage
        {
            private Dictionary<Type, ItemStorage> _itemStorages;

            public DataStorage()
            {
                _itemStorages = new Dictionary<Type,ItemStorage>();
            }

            public ItemStorage<T> FindOrCreateTable<T>()
            {
                var type = typeof(T);

                if (!_itemStorages.ContainsKey(type))
                {
                    _itemStorages[type] = new ItemStorage<T>();
                }

                return (ItemStorage<T>)_itemStorages[type];
            }
        }

        private class ItemStorage
        {

        }

        private class ItemStorage<T> : ItemStorage
        {
            private List<T> _items;
            private ITable _table;
            private ISequenceStrategy _sequenceStrategy;
            private PropertyInfo _primaryKeyProperty;

            public ItemStorage()
            {
                _items = new List<T>();
                _table = typeof(T).ToSchemaTable(null);

                if (_table.PrimaryKey.AutoIncrement)
                {
                    if (_table.PrimaryKey.IsNumeric)
                    {
                        _sequenceStrategy = new IncrementingSequenceStrategy();
                    }
                    else
                    {
                        _sequenceStrategy = new NewGuidSequenceStrategy();
                    }
                }

                _primaryKeyProperty = typeof(T).GetProperty(_table.PrimaryKey.Name);
            }

            public object Add(T item)
            {
                _items.Add(item);

                // Set defaults
                var type = typeof(T);
                foreach (var col in _table.Columns)
                {
                    if (col.DefaultSetting != null && type.GetProperty(col.Name).GetValue(item, null) == null)
                    {
                        type.GetProperty(col.Name).SetValue(item, col.DefaultSetting, null);
                    }
                }

                if (!_table.PrimaryKey.AutoIncrement)
                {
                    return null;
                }

                var primaryKey = item.GetType().GetProperty(_table.PrimaryKey.Name);

                var sequenceId = _sequenceStrategy.Next();
                primaryKey.SetValue(item, sequenceId, null);

                return sequenceId;
            }

            public IQueryable<T> All()
            {
                return _items.AsQueryable();
            }

            public int Delete(object key)
            {
                return _items.RemoveAll(x => key.Equals(_primaryKeyProperty.GetValue(x, null)));
            }

            public int DeleteMany(Expression<Func<T, bool>> expression)
            {
                var func = expression.Compile();
                return _items.RemoveAll(p => func(p));
            }

            public int DeleteMany(IEnumerable<T> items)
            {
                var i = 0;
                foreach (var item in items)
                {
                    i+=Delete(_primaryKeyProperty.GetValue(item, null));
                }

                return i;
            }

            public bool Exists(Expression<Func<T, bool>> expression)
            {
                return _items.Any(expression.Compile());
            }

            public T Single(Expression<Func<T, bool>> expression)
            {
                return _items.Single(expression.Compile());
            }

            public T Single(object key)
            {
                return Single(x => key.Equals(_primaryKeyProperty.GetValue(x, null)));
            }

            public int Update(object item)
            {
                var key = _primaryKeyProperty.GetValue(item, null);
                var idx = _items.FindIndex(x => key.Equals(_primaryKeyProperty.GetValue(x, null)));

                if (idx >= 0 && idx < _items.Count)
                {
                    _items[idx] = (T)item;
                    return 1;
                }

                return 0;
            }

            public PagedList<T> GetPaged(string sortBy, int pageIndex, int pageSize)
            {
                var sortedItems = GetItemsSorted(sortBy);
                return GetPaged(sortedItems, pageIndex, pageSize);
            }

            private IOrderedQueryable<T> GetItemsSorted(string sortBy)
            {
                var sortColumnName = sortBy.FastReplace(" desc", "");
                var sortColumnProperty = typeof(T).GetProperty(sortColumnName);

                Func<T, object> keySelector = x => {
                    return sortColumnProperty.GetValue(x, null);
                };


                if (sortBy.EndsWith(" desc", StringComparison.InvariantCultureIgnoreCase))
                {
                    return All().OrderByDescending(x => keySelector(x));
                }
                else
                {
                    return All().OrderBy(x => keySelector(x));
                }
            }

            public PagedList<T> GetPaged(int pageIndex, int pageSize)
            {
                return GetPaged(All(), pageIndex, pageSize);
            }

            private PagedList<T> GetPaged(IEnumerable<T> items, int pageIndex, int pageSize)
            {
                var pageItems = items.Skip(pageIndex * pageSize).Take(pageSize);

                return new PagedList<T>(pageItems, items.Count(), pageIndex, pageSize);
            }
        }

        private interface ISequenceStrategy
        {
            object Next();
        }

        private class IncrementingSequenceStrategy : ISequenceStrategy
        {
            private int _current = 1;

            public object Next()
            {
                return _current++;
            }
        }

        private class NewGuidSequenceStrategy : ISequenceStrategy
        {
            public object Next()
            {
                return Guid.NewGuid();
            }
        }
    }
}
