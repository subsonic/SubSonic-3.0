using System;
using System.Linq.Expressions;
using System.Reflection;
using SubSonic.DataProviders;
using SubSonic.Extensions;
using SubSonic.Linq.Structure;
using SubSonic.Query;
using SubSonic.Schema;
using SubSonic.Tests.Unit.TestClasses;

namespace SubSonic.Tests.Unit.Linq.TestBases
{
    public class TestDB : IQuerySurface
    {
        private IDataProvider _provider;
        public TestDB(string connection, string provider) : this(ProviderFactory.GetProvider(connection, provider)) { }

        public TestDB(IDataProvider provider)
        {
            _provider = provider;

            Products = new Query<Product>(provider);
            Customers = new Query<Customer>(provider);
            Orders = new Query<Order>(provider);
            OrderDetails = new Query<OrderDetail>(provider);
            Categories = new Query<Category>(provider);

            _provider.Schema.Tables.Add(typeof(Product).ToSchemaTable(_provider));
            _provider.Schema.Tables.Add(typeof(Customer).ToSchemaTable(_provider));
            _provider.Schema.Tables.Add(typeof(Order).ToSchemaTable(_provider));
            _provider.Schema.Tables.Add(typeof(OrderDetail).ToSchemaTable(_provider));
            _provider.Schema.Tables.Add(typeof(Category).ToSchemaTable(_provider));
        }


        #region Not Implemented

        public SqlQuery Avg<T>(Expression<Func<T, object>> column)
        {
            throw new NotImplementedException();
        }

        public SqlQuery Count<T>(Expression<Func<T, object>> column)
        {
            throw new NotImplementedException();
        }

        public SqlQuery Max<T>(Expression<Func<T, object>> column)
        {
            throw new NotImplementedException();
        }

        public SqlQuery Min<T>(Expression<Func<T, object>> column)
        {
            throw new NotImplementedException();
        }

        public SqlQuery Variance<T>(Expression<Func<T, object>> column)
        {
            throw new NotImplementedException();
        }

        public SqlQuery StandardDeviation<T>(Expression<Func<T, object>> column)
        {
            throw new NotImplementedException();
        }

        public SqlQuery Sum<T>(Expression<Func<T, object>> column)
        {
            throw new NotImplementedException();
        }

        #endregion


        public Query<Product> Products { get; set; }
        public Query<Customer> Customers { get; set; }
        public Query<Order> Orders { get; set; }
        public Query<OrderDetail> OrderDetails { get; set; }
        public Query<Category> Categories { get; set; }


        #region IQuerySurface Members

        public SqlQuery Delete<T>(Expression<Func<T, bool>> column) where T : new()
        {
            LambdaExpression lamda = column;
            SqlQuery result = new Delete<T>(_provider);
            result = result.From<T>();
            Constraint c = lamda.ParseConstraint();
            result.Constraints.Add(c);
            return result;
        }

        public Query<T> GetQuery<T>()
        {
            throw new NotImplementedException();
        }

        public ITable FindTable(string tableName)
        {
            var m = new Migrator(Assembly.GetExecutingAssembly());

            if (tableName == "Product")
                return _provider.FindTable("Products");
            if (tableName == "Customer")
                return _provider.FindTable("Customer");
            if (tableName == "Order")
                return _provider.FindTable("Order");
            if (tableName == "OrderDetail")
                return _provider.FindTable("OrderDetail");

            if (tableName == "Category")
                return _provider.FindTable("Category");
            return null;
        }

        public IDataProvider Provider
        {
            get { return _provider; }
        }

        public Select Select
        {
            get { return new Select(_provider); }
        }

        public Insert Insert
        {
            get { return new Insert(_provider); }
        }

        public Update<T> Update<T>() where T : new()
        {
            return new Update<T>(_provider);
        }

        #endregion
    }

}
