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
using System.Linq.Expressions;
using System.Reflection;
using SubSonic.DataProviders;
using SubSonic.Extensions;
using SubSonic.Linq.Structure;
using SubSonic.Query;
using SubSonic.Schema;
using SubSonic.Tests.TestClasses;

namespace SubSonic.Tests.Linq.TestBases
{
    public class TestDB : IQuerySurface
    {
        private IDataProvider _provider;
        private DbQueryProvider _queryProvider;
        public TestDB(string connection, string provider) : this(ProviderFactory.GetProvider(connection, provider)) {}

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
            return new Query<T>(_queryProvider);
        }

        public ITable FindTable(string tableName)
        {
            var m = new Migrator(Assembly.GetExecutingAssembly());

            if(tableName == "Product")
                return _provider.FindTable("Products");
            if(tableName == "Customer")
                return _provider.FindTable("Customer");
            if(tableName == "Order")
                return _provider.FindTable("Order");
            if(tableName == "OrderDetail")
                return _provider.FindTable("OrderDetail");

            if(tableName == "Category")
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

    public class Setup
    {
        private IDataProvider _provider;

        public Setup(IDataProvider provider)
        {
            _provider = provider;
        }

        public void CreateTestTable()
        {
            //Migrate the Products etc object
            var assembly = Assembly.GetExecutingAssembly();
            _provider.MigrateToDatabase<Product>(assembly);
            _provider.MigrateToDatabase<Order>(assembly);
            _provider.MigrateToDatabase<OrderDetail>(assembly);
            _provider.MigrateToDatabase<Customer>(assembly);
            _provider.MigrateToDatabase<Category>(assembly);
        }

        public void LoadTestData()
        {
            var batch = new BatchQuery(_provider);

            //load some test data - 100 records
            string city = "City1";
            string company = "Company1";
            for(int i = 1; i <= 100; i++)
            {
                if(i % 10 == 0)
                {
                    city = "City" + i;
                    company = "Company" + i;
                }
                Customer c = new Customer();
                c.Address = i + "Street";
                c.City = city;
                c.Region = "CA";
                c.Country = "US";
                c.CompanyName = company;
                c.ContactName = "Charlie";
                c.CustomerID = "TEST" + i;
                var qry = c.ToInsertQuery(_provider);
                batch.QueueForTransaction(qry);
            }
            batch.ExecuteTransaction();

            for(int i = 1; i <= 5; i++)
            {
                Category c = new Category();
                c.CategoryID = i;
                c.CategoryName = "Category" + i;
                batch.QueueForTransaction(c.ToInsertQuery(_provider));
            }
            batch.ExecuteTransaction();

            //Products
            int categoryCounter = 1;
            for(int i = 1; i <= 100; i++)
            {
                Product p = new Product();
                p.Sku = Guid.NewGuid();
                p.ProductID = i;
                p.ProductName = "Product" + i;
                p.UnitPrice = 1.245M * i / 5.22M * 8.09M;
                p.Discontinued = i % 2 == 0 ? true : false;
                p.CategoryID = categoryCounter;
                batch.QueueForTransaction(p.ToInsertQuery(_provider));

                categoryCounter++;
                if(categoryCounter > 5)
                    categoryCounter = 1;
            }

            batch.ExecuteTransaction();

            //Orders
            int customerID = 1;

            for(int i = 1; i <= 100; i++)
            {
                Order o = new Order();
                o.OrderDate = DateTime.Parse("1/1/2008").AddDays(-i * 12 + 23);
                o.RequiredDate = DateTime.Parse("1/1/2008").AddDays(-i * 12 + 28);
                o.ShippedDate = DateTime.Parse("1/1/2008").AddDays(-i * 12 + 32);
                o.CustomerID = "TEST" + customerID;
                o.OrderID = i;
                //5 items per order
                for(int j = 1; j <= 5; j++)
                {
                    OrderDetail detail = new OrderDetail();
                    detail.Discount = i * 1 / 4M;
                    detail.OrderID = i;
                    detail.ProductID = i;
                    detail.Quantity = 2;
                    detail.UnitPrice = 2 * (1.245M * i / 5.22M * 8.09M);
                    batch.QueueForTransaction(detail.ToInsertQuery(_provider));
                }
                customerID++;
                if(customerID > 5)
                    customerID = 1;

                batch.QueueForTransaction(o.ToInsertQuery(_provider));
            }

            batch.ExecuteTransaction();
        }

        public void DropTestTables()
        {
            var sql = "DROP TABLE Products;\r\n";
            sql += "DROP TABLE Orders;\r\n";
            sql += "DROP TABLE OrderDetails;\r\n";
            sql += "DROP TABLE Customers;\r\n";
            sql += "DROP TABLE Categories;\r\n";

            try
            {
                _provider.ExecuteQuery(new QueryCommand(sql, _provider));
            }
            catch(Exception x)
            {
                //do nothing - this is here to catch a DROP error
            }
        }
    }
}