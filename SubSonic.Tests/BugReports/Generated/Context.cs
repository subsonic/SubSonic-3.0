


using System;
using System.Data;
using System.Linq;
using System.Linq.Expressions;
using SubSonic.DataProviders;
using SubSonic.Extensions;
using SubSonic.Linq.Structure;
using SubSonic.Query;
using SubSonic.Schema;
using System.Data.Common;
using System.Collections.Generic;

namespace SouthWind
{
    public partial class NorthwindDB : IQuerySurface
    {

        public IDataProvider DataProvider;
        public DbQueryProvider provider;
        
        public bool TestMode
		{
            get
			{
                return DataProvider.ConnectionString.Equals("test", StringComparison.InvariantCultureIgnoreCase);
            }
        }

        public NorthwindDB() 
        { 
            DataProvider = ProviderFactory.GetProvider("Northwind");
            Init();
        }

        public NorthwindDB(string connectionStringName)
        {
            DataProvider = ProviderFactory.GetProvider(connectionStringName);
            Init();
        }

		public NorthwindDB(string connectionString, string providerName)
        {
            DataProvider = ProviderFactory.GetProvider(connectionString,providerName);
            Init();
        }

		public ITable FindByPrimaryKey(string pkName)
        {
            return DataProvider.Schema.Tables.SingleOrDefault(x => x.PrimaryKey.Name.Equals(pkName, StringComparison.InvariantCultureIgnoreCase));
        }

        public Query<T> GetQuery<T>()
        {
            return new Query<T>(provider);
        }
        
        public ITable FindTable(string tableName)
        {
            return DataProvider.FindTable(tableName);
        }
               
        public IDataProvider Provider
        {
            get { return DataProvider; }
            set {DataProvider=value;}
        }
        
        public DbQueryProvider QueryProvider
        {
            get { return provider; }
        }
        
        BatchQuery _batch = null;
        public void Queue<T>(IQueryable<T> qry)
        {
            if (_batch == null)
                _batch = new BatchQuery(Provider, QueryProvider);
            _batch.Queue(qry);
        }

        public void Queue(ISqlQuery qry)
        {
            if (_batch == null)
                _batch = new BatchQuery(Provider, QueryProvider);
            _batch.Queue(qry);
        }

        public void ExecuteTransaction(IList<DbCommand> commands)
		{
            if(!TestMode)
			{
                using(var connection = commands[0].Connection)
				{
                   if (connection.State == ConnectionState.Closed)
                        connection.Open();
                   
                   using (var trans = connection.BeginTransaction()) 
				   {
                        foreach (var cmd in commands) 
						{
                            cmd.Transaction = trans;
                            cmd.Connection = connection;
                            cmd.ExecuteNonQuery();
                        }
                        trans.Commit();
                    }
                    connection.Close();
                }
            }
        }

        public IDataReader ExecuteBatch()
        {
            if (_batch == null)
                throw new InvalidOperationException("There's nothing in the queue");
            if(!TestMode)
                return _batch.ExecuteReader();
            return null;
        }
			
        public Query<Customer> Customers { get; set; }
        public Query<Shipper> Shippers { get; set; }
        public Query<Supplier> Suppliers { get; set; }
        public Query<OrderDetail> OrderDetails { get; set; }
        public Query<CustomerCustomerDemo> CustomerCustomerDemos { get; set; }
        public Query<CustomerDemographic> CustomerDemographics { get; set; }
        public Query<Region> Regions { get; set; }
        public Query<Territory> Territories { get; set; }
        public Query<EmployeeTerritory> EmployeeTerritories { get; set; }
        public Query<Order> Orders { get; set; }
        public Query<SubSonicTest> SubSonicTests { get; set; }
        public Query<Product> Products { get; set; }
        public Query<Employee> Employees { get; set; }
        public Query<Category> Categories { get; set; }

			

        #region ' Aggregates and SubSonic Queries '
        public Select SelectColumns(params string[] columns)
        {
            return new Select(DataProvider, columns);
        }

        public Select Select
        {
            get { return new Select(this.Provider); }
        }

        public Insert Insert
		{
            get { return new Insert(this.Provider); }
        }

        public Update<T> Update<T>() where T:new()
		{
            return new Update<T>(this.Provider);
        }

        public SqlQuery Delete<T>(Expression<Func<T,bool>> column) where T:new()
        {
            LambdaExpression lamda = column;
            SqlQuery result = new Delete<T>(this.Provider);
            result = result.From<T>();            
            result.Constraints=lamda.ParseConstraints().ToList();
            return result;
        }

        public SqlQuery Max<T>(Expression<Func<T,object>> column)
        {
            LambdaExpression lamda = column;
            string colName = lamda.ParseObjectValue();
            string objectName = typeof(T).Name;
            string tableName = DataProvider.FindTable(objectName).Name;
            return new Select(DataProvider, new Aggregate(colName, AggregateFunction.Max)).From(tableName);
        }

        public SqlQuery Min<T>(Expression<Func<T,object>> column)
        {
            LambdaExpression lamda = column;
            string colName = lamda.ParseObjectValue();
            string objectName = typeof(T).Name;
            string tableName = this.Provider.FindTable(objectName).Name;
            return new Select(this.Provider, new Aggregate(colName, AggregateFunction.Min)).From(tableName);
        }

        public SqlQuery Sum<T>(Expression<Func<T,object>> column)
        {
            LambdaExpression lamda = column;
            string colName = lamda.ParseObjectValue();
            string objectName = typeof(T).Name;
            string tableName = this.Provider.FindTable(objectName).Name;
            return new Select(this.Provider, new Aggregate(colName, AggregateFunction.Sum)).From(tableName);
        }

        public SqlQuery Avg<T>(Expression<Func<T,object>> column)
        {
            LambdaExpression lamda = column;
            string colName = lamda.ParseObjectValue();
            string objectName = typeof(T).Name;
            string tableName = this.Provider.FindTable(objectName).Name;
            return new Select(this.Provider, new Aggregate(colName, AggregateFunction.Avg)).From(tableName);
        }

        public SqlQuery Count<T>(Expression<Func<T,object>> column)
        {
            LambdaExpression lamda = column;
            string colName = lamda.ParseObjectValue();
            string objectName = typeof(T).Name;
            string tableName = this.Provider.FindTable(objectName).Name;
            return new Select(this.Provider, new Aggregate(colName, AggregateFunction.Count)).From(tableName);
        }

        public SqlQuery Variance<T>(Expression<Func<T,object>> column)
        {
            LambdaExpression lamda = column;
            string colName = lamda.ParseObjectValue();
            string objectName = typeof(T).Name;
            string tableName = this.Provider.FindTable(objectName).Name;
            return new Select(this.Provider, new Aggregate(colName, AggregateFunction.Var)).From(tableName);
        }

        public SqlQuery StandardDeviation<T>(Expression<Func<T,object>> column)
        {
            LambdaExpression lamda = column;
            string colName = lamda.ParseObjectValue();
            string objectName = typeof(T).Name;
            string tableName = this.Provider.FindTable(objectName).Name;
            return new Select(this.Provider, new Aggregate(colName, AggregateFunction.StDev)).From(tableName);
        }

        #endregion

        void Init()
        {
            provider = new DbQueryProvider(this.Provider);

            #region ' Query Defs '
            Customers = new Query<Customer>(provider);
            Shippers = new Query<Shipper>(provider);
            Suppliers = new Query<Supplier>(provider);
            OrderDetails = new Query<OrderDetail>(provider);
            CustomerCustomerDemos = new Query<CustomerCustomerDemo>(provider);
            CustomerDemographics = new Query<CustomerDemographic>(provider);
            Regions = new Query<Region>(provider);
            Territories = new Query<Territory>(provider);
            EmployeeTerritories = new Query<EmployeeTerritory>(provider);
            Orders = new Query<Order>(provider);
            SubSonicTests = new Query<SubSonicTest>(provider);
            Products = new Query<Product>(provider);
            Employees = new Query<Employee>(provider);
            Categories = new Query<Category>(provider);
            #endregion


            #region ' Schemas '
        	if(DataProvider.Schema.Tables.Count == 0)
			{
            	DataProvider.Schema.Tables.Add(new CustomersTable(DataProvider));
            	DataProvider.Schema.Tables.Add(new ShippersTable(DataProvider));
            	DataProvider.Schema.Tables.Add(new SuppliersTable(DataProvider));
            	DataProvider.Schema.Tables.Add(new OrderDetailsTable(DataProvider));
            	DataProvider.Schema.Tables.Add(new CustomerCustomerDemoTable(DataProvider));
            	DataProvider.Schema.Tables.Add(new CustomerDemographicsTable(DataProvider));
            	DataProvider.Schema.Tables.Add(new RegionTable(DataProvider));
            	DataProvider.Schema.Tables.Add(new TerritoriesTable(DataProvider));
            	DataProvider.Schema.Tables.Add(new EmployeeTerritoriesTable(DataProvider));
            	DataProvider.Schema.Tables.Add(new OrdersTable(DataProvider));
            	DataProvider.Schema.Tables.Add(new SubSonicTestsTable(DataProvider));
            	DataProvider.Schema.Tables.Add(new ProductsTable(DataProvider));
            	DataProvider.Schema.Tables.Add(new EmployeesTable(DataProvider));
            	DataProvider.Schema.Tables.Add(new CategoriesTable(DataProvider));
            }
            #endregion
        }
    }
}