


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

namespace Blog
{
    public partial class BlogDB : IQuerySurface
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

        public BlogDB() 
        { 
            DataProvider = ProviderFactory.GetProvider("Blog");
            Init();
        }

        public BlogDB(string connectionStringName)
        {
            DataProvider = ProviderFactory.GetProvider(connectionStringName);
            Init();
        }

		public BlogDB(string connectionString, string providerName)
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
			
        public Query<Post> Posts { get; set; }
        public Query<Category> Categories { get; set; }

			

        #region ' Aggregates and SubSonic Queries '
        public Select SelectColumns(params string[] columns)
        {
            return new Select(DataProvider, columns);
        }

        public Select Select
        {
            get { return new Select(DataProvider); }
        }

        public Insert Insert
		{
            get { return new Insert(DataProvider); }
        }

        public Update<T> Update<T>() where T:new()
		{
            return new Update<T>(DataProvider);
        }

        public SqlQuery Delete<T>(Expression<Func<T,bool>> column) where T:new()
        {
            LambdaExpression lamda = column;
            SqlQuery result = new Delete<T>(DataProvider);
            result = result.From<T>();
            SubSonic.Query.Constraint c = lamda.ParseConstraint();
            result.Constraints.Add(c);
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
            string tableName = DataProvider.FindTable(objectName).Name;
            return new Select(DataProvider, new Aggregate(colName, AggregateFunction.Min)).From(tableName);
        }

        public SqlQuery Sum<T>(Expression<Func<T,object>> column)
        {
            LambdaExpression lamda = column;
            string colName = lamda.ParseObjectValue();
            string objectName = typeof(T).Name;
            string tableName = DataProvider.FindTable(objectName).Name;
            return new Select(DataProvider, new Aggregate(colName, AggregateFunction.Sum)).From(tableName);
        }

        public SqlQuery Avg<T>(Expression<Func<T,object>> column)
        {
            LambdaExpression lamda = column;
            string colName = lamda.ParseObjectValue();
            string objectName = typeof(T).Name;
            string tableName = DataProvider.FindTable(objectName).Name;
            return new Select(DataProvider, new Aggregate(colName, AggregateFunction.Avg)).From(tableName);
        }

        public SqlQuery Count<T>(Expression<Func<T,object>> column)
        {
            LambdaExpression lamda = column;
            string colName = lamda.ParseObjectValue();
            string objectName = typeof(T).Name;
            string tableName = DataProvider.FindTable(objectName).Name;
            return new Select(DataProvider, new Aggregate(colName, AggregateFunction.Count)).From(tableName);
        }

        public SqlQuery Variance<T>(Expression<Func<T,object>> column)
        {
            LambdaExpression lamda = column;
            string colName = lamda.ParseObjectValue();
            string objectName = typeof(T).Name;
            string tableName = DataProvider.FindTable(objectName).Name;
            return new Select(DataProvider, new Aggregate(colName, AggregateFunction.Var)).From(tableName);
        }

        public SqlQuery StandardDeviation<T>(Expression<Func<T,object>> column)
        {
            LambdaExpression lamda = column;
            string colName = lamda.ParseObjectValue();
            string objectName = typeof(T).Name;
            string tableName = DataProvider.FindTable(objectName).Name;
            return new Select(DataProvider, new Aggregate(colName, AggregateFunction.StDev)).From(tableName);
        }

        #endregion

        void Init()
        {
            provider = new DbQueryProvider(DataProvider);

            #region ' Query Defs '
            Posts = new Query<Post>(provider);
            Categories = new Query<Category>(provider);
            #endregion


            #region ' Schemas '
        	if(DataProvider.Schema.Tables.Count == 0)
			{
				
				// Table: Posts
				// Primary Key: PostID
				ITable PostsSchema = new DatabaseTable("Posts", DataProvider) { ClassName = "Post", SchemaName = "dbo" };
            	PostsSchema.Columns.Add(new DatabaseColumn("PostID", PostsSchema)
												{
													IsPrimaryKey = true,
													DataType = DbType.Guid,
													IsNullable = false,
													AutoIncrement = false,
													IsForeignKey = false
												});
            	PostsSchema.Columns.Add(new DatabaseColumn("CategoryID", PostsSchema)
												{
													IsPrimaryKey = false,
													DataType = DbType.Int32,
													IsNullable = false,
													AutoIncrement = false,
													IsForeignKey = true
												});
            	PostsSchema.Columns.Add(new DatabaseColumn("Title", PostsSchema)
												{
													IsPrimaryKey = false,
													DataType = DbType.String,
													IsNullable = false,
													AutoIncrement = false,
													IsForeignKey = false
												});
            	PostsSchema.Columns.Add(new DatabaseColumn("Slug", PostsSchema)
												{
													IsPrimaryKey = false,
													DataType = DbType.String,
													IsNullable = false,
													AutoIncrement = false,
													IsForeignKey = false
												});
            	PostsSchema.Columns.Add(new DatabaseColumn("Body", PostsSchema)
												{
													IsPrimaryKey = false,
													DataType = DbType.String,
													IsNullable = true,
													AutoIncrement = false,
													IsForeignKey = false
												});
            	PostsSchema.Columns.Add(new DatabaseColumn("PublishedOn", PostsSchema)
												{
													IsPrimaryKey = false,
													DataType = DbType.DateTime,
													IsNullable = false,
													AutoIncrement = false,
													IsForeignKey = false
												});
            	PostsSchema.Columns.Add(new DatabaseColumn("CreatedOn", PostsSchema)
												{
													IsPrimaryKey = false,
													DataType = DbType.DateTime,
													IsNullable = false,
													AutoIncrement = false,
													IsForeignKey = false
												});
            	PostsSchema.Columns.Add(new DatabaseColumn("ModifiedOn", PostsSchema)
												{
													IsPrimaryKey = false,
													DataType = DbType.DateTime,
													IsNullable = false,
													AutoIncrement = false,
													IsForeignKey = false
												});
            	PostsSchema.Columns.Add(new DatabaseColumn("CreatedBy", PostsSchema)
												{
													IsPrimaryKey = false,
													DataType = DbType.String,
													IsNullable = true,
													AutoIncrement = false,
													IsForeignKey = false
												});
            	PostsSchema.Columns.Add(new DatabaseColumn("ModifiedBy", PostsSchema)
												{
													IsPrimaryKey = false,
													DataType = DbType.String,
													IsNullable = true,
													AutoIncrement = false,
													IsForeignKey = false
												});
				// Add Posts to schema
            	DataProvider.Schema.Tables.Add(PostsSchema);
				
				// Table: Categories
				// Primary Key: CategoryID
				ITable CategoriesSchema = new DatabaseTable("Categories", DataProvider) { ClassName = "Category", SchemaName = "dbo" };
            	CategoriesSchema.Columns.Add(new DatabaseColumn("CategoryID", CategoriesSchema)
												{
													IsPrimaryKey = true,
													DataType = DbType.Int32,
													IsNullable = false,
													AutoIncrement = true,
													IsForeignKey = true
												});
            	CategoriesSchema.Columns.Add(new DatabaseColumn("Description", CategoriesSchema)
												{
													IsPrimaryKey = false,
													DataType = DbType.String,
													IsNullable = false,
													AutoIncrement = false,
													IsForeignKey = false
												});
				// Add Categories to schema
            	DataProvider.Schema.Tables.Add(CategoriesSchema);
            }
            #endregion
        }
    }
}