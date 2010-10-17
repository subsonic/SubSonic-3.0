using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.Query;
using System.Collections;
using Castle.DynamicProxy;
using SubSonic.Schema;
using System.Reflection;

namespace SubSonic.DataProviders
{
    public class LazyLoadInterceptor : IInterceptor
    {
        private object _left;
        private IDataProvider _provider;
        private Type _leftType;
        private ITable _leftTable;

        private List<string> _setProperties;

        public LazyLoadInterceptor(IDataProvider provider, object left)
        {
            _left = left;
            _provider = provider;

            _leftType = _left.GetType();
            _leftTable = _provider.FindOrCreateTable(_leftType);

            _setProperties = new List<string>();
        }

        public void Intercept(IInvocation invocation)
        {
            if (IsPropertyGetCall(invocation.Method))
            {
                var propertyName = GetPropertyName(invocation.Method);
                InterceptGetCall(propertyName);
            }
            else if (IsPropertySetCall(invocation.Method))
            {
                var propertyName = GetPropertyName(invocation.Method);
                MarkPropertySet(propertyName);
            }

            invocation.Proceed();
        }

        private void MarkPropertySet(string propertyName)
        {
            var relation = _leftTable.GetRelation(propertyName);

            if (relation == null)
            {
                return;
            }

            if (!_setProperties.Contains(propertyName))
            {
                lock (this)
                {
                    if (!_setProperties.Contains(propertyName))
                    {
                        _setProperties.Add(propertyName);
                    }
                }
            }
        }

        private bool IsPropertySet(string propertyName)
        {
            return _setProperties.Contains(propertyName);
        }

        private void InterceptGetCall(string propertyName)
        {
            var relation = _leftTable.GetRelation(propertyName);

            if (relation == null)
            {
                return;
            }

            if (IsPropertySet(propertyName))
            {
                return;
            }

            LoadPropertyValues(propertyName, relation);
        }

        private string GetPropertyName(MethodInfo method)
        {
            return method.Name.Substring(4, method.Name.Length - 4);
        }

        private bool IsPropertyGetCall(MethodInfo method)
        {
            return method.Name.StartsWith("get_");
        }

        private bool IsPropertySetCall(MethodInfo method)
        {
            return method.Name.StartsWith("set_");
        }

        protected virtual void LoadPropertyValues(string propertyName, IRelation relation)
        {
            var prop = _leftType.GetProperty(propertyName);

            var key = GetJoinKeyValue(relation);

            var select = new Select(_provider)
                .From(relation.TargetTable)
                .Where(relation.TargetJoinKey)
                .IsEqualTo(key);

            object result = ExecuteQuery(relation, select);

            prop.SetValue(_left, result, null);
        }

        private object GetJoinKeyValue(IRelation relation)
        {
            if (relation.JoinKey == null)
            {
                throw new InvalidOperationException("Join key to retrieve entries from DB is not set");
            }

            var keyProp = _leftType.GetProperty(relation.JoinKey.Name);

            if (keyProp == null)
            {
                throw new InvalidOperationException("Could not locate key property for join!");
            }

            return keyProp.GetValue(_left, null);
        }

        private static object ExecuteQuery(IRelation relation, SqlQuery select)
        {
            var queryExecutorType = typeof(QueryExecutor<>).MakeGenericType(relation.TargetType);
            var queryExecutor = ((IQueryExecutor)Activator.CreateInstance(queryExecutorType));

            if (relation.Qualifier == Qualifier.Many)
            {
                return queryExecutor.Select(select);
            }
            
            return queryExecutor.Single(select);
        }

        private interface IQueryExecutor
        {
            IList Select(SqlQuery select);
            object Single(SqlQuery select);
        }

        private class QueryExecutor<T> : IQueryExecutor where T : new()
        {
            public QueryExecutor()
            { }

            public IList Select(SqlQuery select)
            {
                return select.ExecuteTypedList<T>();
            }

            public object Single(SqlQuery select)
            {
                return select.ExecuteSingle<T>();
            }
        }
    }
}
