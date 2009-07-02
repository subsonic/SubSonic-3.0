


using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using SubSonic.DataProviders;
using SubSonic.Extensions;
using System.Linq.Expressions;
using SubSonic.Schema;
using System.Collections;
using SubSonic;
using SubSonic.Repository;
using System.ComponentModel;
using System.Data.Common;

namespace Southwind
{
    
    
    /// <summary>
    /// A class which represents the Products table in the Northwind Database.
    /// </summary>
    public partial class Product: IActiveRecord
    {
    
        #region Built-in testing
        static IList<Product> TestItems;
        static TestRepository<Product> _testRepo;
        public void SetIsLoaded(bool isLoaded){
            _isLoaded=isLoaded;
        }
        static void SetTestRepo(){
            _testRepo = _testRepo ?? new TestRepository<Product>(new Southwind.NorthwindDB());
        }
        public static void ResetTestRepo(){
            _testRepo = null;
            SetTestRepo();
        }
        public static void Setup(List<Product> testlist){
            SetTestRepo();
            _testRepo._items = testlist;
        }
        public static void Setup(Product item) {
            SetTestRepo();
            _testRepo._items.Add(item);
        }
        public static void Setup(int testItems) {
            SetTestRepo();
            for(int i=0;i<testItems;i++){
                Product item=new Product();
                _testRepo._items.Add(item);
            }
        }
        
        public bool TestMode = false;


        #endregion

        IRepository<Product> _repo;
        ITable tbl;
        bool _isNew;
        public bool IsNew(){
            return _isNew;
        }
        public void SetIsNew(bool isNew){
            _isNew=isNew;
        }
        bool _isLoaded;
        public bool IsLoaded(){
            return _isLoaded;
        }
                
        List<IColumn> _dirtyColumns;
        public bool IsDirty(){
            return _dirtyColumns.Count>0;
        }
        
        public List<IColumn> GetDirtyColumns (){
            return _dirtyColumns;
        }

        Southwind.NorthwindDB _db;
        public Product(string connectionString, string providerName) {

            _db=new Southwind.NorthwindDB(connectionString, providerName);
            Init();            
         }
        void Init(){
            TestMode=this._db.DataProvider.ConnectionString.Equals("test", StringComparison.InvariantCultureIgnoreCase);
            _dirtyColumns=new List<IColumn>();
            if(TestMode){
                Product.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<Product>(_db);
            }
            tbl=_repo.GetTable();
            _isNew = true;
            OnCreated();       
      
        }
        
        public Product(){
             _db=new Southwind.NorthwindDB();
            Init();            
        }
        
       
        partial void OnCreated();
            
        partial void OnLoaded();
        
        partial void OnSaved();
        
        partial void OnChanged();
        
        public IList<IColumn> Columns{
            get{
                return tbl.Columns;
            }
        }

        public Product(Expression<Func<Product, bool>> expression):this() {
            _isLoaded=_repo.Load(this,expression);
            if(_isLoaded)
                OnLoaded();
        }
        
       
        
        internal static IRepository<Product> GetRepo(string connectionString, string providerName){
            Southwind.NorthwindDB db;
            if(String.IsNullOrEmpty(connectionString)){
                db=new Southwind.NorthwindDB();
            }else{
                db=new Southwind.NorthwindDB(connectionString, providerName);
            }
            IRepository<Product> _repo;
            
            if(db.TestMode){
                Product.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<Product>(db);
            }
            return _repo;        
        }       
        
        internal static IRepository<Product> GetRepo(){
            return GetRepo("","");
        }
        
        public static Product SingleOrDefault(Expression<Func<Product, bool>> expression) {

            var repo = GetRepo();
            var results=repo.Find(expression);
            Product single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
                single.OnLoaded();
                single.SetIsLoaded(true);
            }

            return single;
        }      
        
        public static Product SingleOrDefault(Expression<Func<Product, bool>> expression,string connectionString, string providerName) {
            var repo = GetRepo(connectionString,providerName);
            var results=repo.Find(expression);
            Product single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
                single.OnLoaded();
                single.SetIsLoaded(true);
            }

            return single;


        }
        
        
        public static bool Exists(Expression<Func<Product, bool>> expression,string connectionString, string providerName) {
           
            return All(connectionString,providerName).Any(expression);
        }        
        public static bool Exists(Expression<Func<Product, bool>> expression) {
           
            return All().Any(expression);
        }        

        public static IList<Product> Find(Expression<Func<Product, bool>> expression) {
            
            var repo = GetRepo();
            return repo.Find(expression).ToList();
        }
        
        public static IList<Product> Find(Expression<Func<Product, bool>> expression,string connectionString, string providerName) {

            var repo = GetRepo(connectionString,providerName);
            return repo.Find(expression).ToList();

        }
        public static IQueryable<Product> All(string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetAll();
        }
        public static IQueryable<Product> All() {
            return GetRepo().GetAll();
        }
        
        public static PagedList<Product> GetPaged(string sortBy, int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(sortBy, pageIndex, pageSize);
        }
      
        public static PagedList<Product> GetPaged(string sortBy, int pageIndex, int pageSize) {
            return GetRepo().GetPaged(sortBy, pageIndex, pageSize);
        }

        public static PagedList<Product> GetPaged(int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(pageIndex, pageSize);
            
        }


        public static PagedList<Product> GetPaged(int pageIndex, int pageSize) {
            return GetRepo().GetPaged(pageIndex, pageSize);
            
        }

        public string KeyName()
        {
            return "ProductID";
        }

        public object KeyValue()
        {
            return this.ProductID;
        }
        
        public void SetKeyValue(object value) {
            if (value != null && value!=DBNull.Value) {
                var settable = value.ChangeTypeTo<int>();
                this.GetType().GetProperty(this.KeyName()).SetValue(this, settable, null);
            }
        }
        
        public override string ToString(){
            return this.ProductName.ToString();
        }

        public override bool Equals(object obj){
            if(obj.GetType()==typeof(Product)){
                Product compare=(Product)obj;
                return compare.KeyValue()==this.KeyValue();
            }else{
                return base.Equals(obj);
            }
        }

        public string DescriptorValue()
        {
            return this.ProductName.ToString();
        }

        public string DescriptorColumn() {
            return "ProductName";
        }
        public static string GetKeyColumn()
        {
            return "ProductID";
        }        
        public static string GetDescriptorColumn()
        {
            return "ProductName";
        }
        
        #region ' Foreign Keys '
        #endregion
        

        int _ProductID;
        public int ProductID
        {
            get { return _ProductID; }
            set
            {
                
                _ProductID=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="ProductID");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        Guid _Sku;
        public Guid Sku
        {
            get { return _Sku; }
            set
            {
                
                _Sku=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="Sku");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        int _CategoryID;
        public int CategoryID
        {
            get { return _CategoryID; }
            set
            {
                
                _CategoryID=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="CategoryID");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        string _ProductName;
        public string ProductName
        {
            get { return _ProductName; }
            set
            {
                
                _ProductName=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="ProductName");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        decimal _UnitPrice;
        public decimal UnitPrice
        {
            get { return _UnitPrice; }
            set
            {
                
                _UnitPrice=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="UnitPrice");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        bool _Discontinued;
        public bool Discontinued
        {
            get { return _Discontinued; }
            set
            {
                
                _Discontinued=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="Discontinued");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }



        public DbCommand GetUpdateCommand() {
            if(TestMode)
                return _db.DataProvider.CreateCommand();
            else
                return this.ToUpdateQuery(_db.Provider).GetCommand().ToDbCommand();
            
        }
        public DbCommand GetInsertCommand() {
 
            if(TestMode)
                return _db.DataProvider.CreateCommand();
            else
                return this.ToInsertQuery(_db.Provider).GetCommand().ToDbCommand();
        }
        
        public DbCommand GetDeleteCommand() {
            if(TestMode)
                return _db.DataProvider.CreateCommand();
            else
                return this.ToDeleteQuery(_db.Provider).GetCommand().ToDbCommand();
        }
       
        
        public void Update(){
            Update(_db.DataProvider);
        }
        
        public void Update(IDataProvider provider){
        
            
            if(this._dirtyColumns.Count>0)
                _repo.Update(this,provider);
            OnSaved();
       }
 
        public void Add(){
            Add(_db.DataProvider);
        }
        
        
       
        public void Add(IDataProvider provider){

            this.SetKeyValue(_repo.Add(this,provider));
            OnSaved();
        }
        
                
        
        public void Save() {
            Save(_db.DataProvider);
        }      
        public void Save(IDataProvider provider) {
            
           
            if (_isNew) {
                Add(provider);
                
            } else {
                Update(provider);
            }
            
        }

        

        public void Delete(IDataProvider provider) {
                   
                 
            _repo.Delete(KeyValue());
            
                    }


        public void Delete() {
            Delete(_db.DataProvider);
        }


        public static void Delete(Expression<Func<Product, bool>> expression) {
            var repo = GetRepo();
            
       
            
            repo.DeleteMany(expression);
            
        }

        

        public void Load(IDataReader rdr) {
            Load(rdr, true);
        }
        public void Load(IDataReader rdr, bool closeReader) {
            if (rdr.Read()) {

                try {
                    rdr.Load(this);
                    _isNew = false;
                    _isLoaded = true;
                } catch {
                    _isLoaded = false;
                    throw;
                }
            }else{
                _isLoaded = false;
            }

            if (closeReader)
                rdr.Dispose();
        }
        

    } 
    
    
    /// <summary>
    /// A class which represents the Orders table in the Northwind Database.
    /// </summary>
    public partial class Order: IActiveRecord
    {
    
        #region Built-in testing
        static IList<Order> TestItems;
        static TestRepository<Order> _testRepo;
        public void SetIsLoaded(bool isLoaded){
            _isLoaded=isLoaded;
        }
        static void SetTestRepo(){
            _testRepo = _testRepo ?? new TestRepository<Order>(new Southwind.NorthwindDB());
        }
        public static void ResetTestRepo(){
            _testRepo = null;
            SetTestRepo();
        }
        public static void Setup(List<Order> testlist){
            SetTestRepo();
            _testRepo._items = testlist;
        }
        public static void Setup(Order item) {
            SetTestRepo();
            _testRepo._items.Add(item);
        }
        public static void Setup(int testItems) {
            SetTestRepo();
            for(int i=0;i<testItems;i++){
                Order item=new Order();
                _testRepo._items.Add(item);
            }
        }
        
        public bool TestMode = false;


        #endregion

        IRepository<Order> _repo;
        ITable tbl;
        bool _isNew;
        public bool IsNew(){
            return _isNew;
        }
        public void SetIsNew(bool isNew){
            _isNew=isNew;
        }
        bool _isLoaded;
        public bool IsLoaded(){
            return _isLoaded;
        }
                
        List<IColumn> _dirtyColumns;
        public bool IsDirty(){
            return _dirtyColumns.Count>0;
        }
        
        public List<IColumn> GetDirtyColumns (){
            return _dirtyColumns;
        }

        Southwind.NorthwindDB _db;
        public Order(string connectionString, string providerName) {

            _db=new Southwind.NorthwindDB(connectionString, providerName);
            Init();            
         }
        void Init(){
            TestMode=this._db.DataProvider.ConnectionString.Equals("test", StringComparison.InvariantCultureIgnoreCase);
            _dirtyColumns=new List<IColumn>();
            if(TestMode){
                Order.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<Order>(_db);
            }
            tbl=_repo.GetTable();
            _isNew = true;
            OnCreated();       
      
        }
        
        public Order(){
             _db=new Southwind.NorthwindDB();
            Init();            
        }
        
       
        partial void OnCreated();
            
        partial void OnLoaded();
        
        partial void OnSaved();
        
        partial void OnChanged();
        
        public IList<IColumn> Columns{
            get{
                return tbl.Columns;
            }
        }

        public Order(Expression<Func<Order, bool>> expression):this() {
            _isLoaded=_repo.Load(this,expression);
            if(_isLoaded)
                OnLoaded();
        }
        
       
        
        internal static IRepository<Order> GetRepo(string connectionString, string providerName){
            Southwind.NorthwindDB db;
            if(String.IsNullOrEmpty(connectionString)){
                db=new Southwind.NorthwindDB();
            }else{
                db=new Southwind.NorthwindDB(connectionString, providerName);
            }
            IRepository<Order> _repo;
            
            if(db.TestMode){
                Order.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<Order>(db);
            }
            return _repo;        
        }       
        
        internal static IRepository<Order> GetRepo(){
            return GetRepo("","");
        }
        
        public static Order SingleOrDefault(Expression<Func<Order, bool>> expression) {

            var repo = GetRepo();
            var results=repo.Find(expression);
            Order single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
                single.OnLoaded();
                single.SetIsLoaded(true);
            }

            return single;
        }      
        
        public static Order SingleOrDefault(Expression<Func<Order, bool>> expression,string connectionString, string providerName) {
            var repo = GetRepo(connectionString,providerName);
            var results=repo.Find(expression);
            Order single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
                single.OnLoaded();
                single.SetIsLoaded(true);
            }

            return single;


        }
        
        
        public static bool Exists(Expression<Func<Order, bool>> expression,string connectionString, string providerName) {
           
            return All(connectionString,providerName).Any(expression);
        }        
        public static bool Exists(Expression<Func<Order, bool>> expression) {
           
            return All().Any(expression);
        }        

        public static IList<Order> Find(Expression<Func<Order, bool>> expression) {
            
            var repo = GetRepo();
            return repo.Find(expression).ToList();
        }
        
        public static IList<Order> Find(Expression<Func<Order, bool>> expression,string connectionString, string providerName) {

            var repo = GetRepo(connectionString,providerName);
            return repo.Find(expression).ToList();

        }
        public static IQueryable<Order> All(string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetAll();
        }
        public static IQueryable<Order> All() {
            return GetRepo().GetAll();
        }
        
        public static PagedList<Order> GetPaged(string sortBy, int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(sortBy, pageIndex, pageSize);
        }
      
        public static PagedList<Order> GetPaged(string sortBy, int pageIndex, int pageSize) {
            return GetRepo().GetPaged(sortBy, pageIndex, pageSize);
        }

        public static PagedList<Order> GetPaged(int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(pageIndex, pageSize);
            
        }


        public static PagedList<Order> GetPaged(int pageIndex, int pageSize) {
            return GetRepo().GetPaged(pageIndex, pageSize);
            
        }

        public string KeyName()
        {
            return "OrderID";
        }

        public object KeyValue()
        {
            return this.OrderID;
        }
        
        public void SetKeyValue(object value) {
            if (value != null && value!=DBNull.Value) {
                var settable = value.ChangeTypeTo<int>();
                this.GetType().GetProperty(this.KeyName()).SetValue(this, settable, null);
            }
        }
        
        public override string ToString(){
            return this.CustomerID.ToString();
        }

        public override bool Equals(object obj){
            if(obj.GetType()==typeof(Order)){
                Order compare=(Order)obj;
                return compare.KeyValue()==this.KeyValue();
            }else{
                return base.Equals(obj);
            }
        }

        public string DescriptorValue()
        {
            return this.CustomerID.ToString();
        }

        public string DescriptorColumn() {
            return "CustomerID";
        }
        public static string GetKeyColumn()
        {
            return "OrderID";
        }        
        public static string GetDescriptorColumn()
        {
            return "CustomerID";
        }
        
        #region ' Foreign Keys '
        #endregion
        

        int _OrderID;
        public int OrderID
        {
            get { return _OrderID; }
            set
            {
                
                _OrderID=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="OrderID");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        DateTime _OrderDate;
        public DateTime OrderDate
        {
            get { return _OrderDate; }
            set
            {
                
                _OrderDate=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="OrderDate");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        string _CustomerID;
        public string CustomerID
        {
            get { return _CustomerID; }
            set
            {
                
                _CustomerID=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="CustomerID");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        DateTime? _RequiredDate;
        public DateTime? RequiredDate
        {
            get { return _RequiredDate; }
            set
            {
                
                _RequiredDate=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="RequiredDate");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        DateTime? _ShippedDate;
        public DateTime? ShippedDate
        {
            get { return _ShippedDate; }
            set
            {
                
                _ShippedDate=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="ShippedDate");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }



        public DbCommand GetUpdateCommand() {
            if(TestMode)
                return _db.DataProvider.CreateCommand();
            else
                return this.ToUpdateQuery(_db.Provider).GetCommand().ToDbCommand();
            
        }
        public DbCommand GetInsertCommand() {
 
            if(TestMode)
                return _db.DataProvider.CreateCommand();
            else
                return this.ToInsertQuery(_db.Provider).GetCommand().ToDbCommand();
        }
        
        public DbCommand GetDeleteCommand() {
            if(TestMode)
                return _db.DataProvider.CreateCommand();
            else
                return this.ToDeleteQuery(_db.Provider).GetCommand().ToDbCommand();
        }
       
        
        public void Update(){
            Update(_db.DataProvider);
        }
        
        public void Update(IDataProvider provider){
        
            
            if(this._dirtyColumns.Count>0)
                _repo.Update(this,provider);
            OnSaved();
       }
 
        public void Add(){
            Add(_db.DataProvider);
        }
        
        
       
        public void Add(IDataProvider provider){

            this.SetKeyValue(_repo.Add(this,provider));
            OnSaved();
        }
        
                
        
        public void Save() {
            Save(_db.DataProvider);
        }      
        public void Save(IDataProvider provider) {
            
           
            if (_isNew) {
                Add(provider);
                
            } else {
                Update(provider);
            }
            
        }

        

        public void Delete(IDataProvider provider) {
                   
                 
            _repo.Delete(KeyValue());
            
                    }


        public void Delete() {
            Delete(_db.DataProvider);
        }


        public static void Delete(Expression<Func<Order, bool>> expression) {
            var repo = GetRepo();
            
       
            
            repo.DeleteMany(expression);
            
        }

        

        public void Load(IDataReader rdr) {
            Load(rdr, true);
        }
        public void Load(IDataReader rdr, bool closeReader) {
            if (rdr.Read()) {

                try {
                    rdr.Load(this);
                    _isNew = false;
                    _isLoaded = true;
                } catch {
                    _isLoaded = false;
                    throw;
                }
            }else{
                _isLoaded = false;
            }

            if (closeReader)
                rdr.Dispose();
        }
        

    } 
    
    
    /// <summary>
    /// A class which represents the OrderDetails table in the Northwind Database.
    /// </summary>
    public partial class OrderDetail: IActiveRecord
    {
    
        #region Built-in testing
        static IList<OrderDetail> TestItems;
        static TestRepository<OrderDetail> _testRepo;
        public void SetIsLoaded(bool isLoaded){
            _isLoaded=isLoaded;
        }
        static void SetTestRepo(){
            _testRepo = _testRepo ?? new TestRepository<OrderDetail>(new Southwind.NorthwindDB());
        }
        public static void ResetTestRepo(){
            _testRepo = null;
            SetTestRepo();
        }
        public static void Setup(List<OrderDetail> testlist){
            SetTestRepo();
            _testRepo._items = testlist;
        }
        public static void Setup(OrderDetail item) {
            SetTestRepo();
            _testRepo._items.Add(item);
        }
        public static void Setup(int testItems) {
            SetTestRepo();
            for(int i=0;i<testItems;i++){
                OrderDetail item=new OrderDetail();
                _testRepo._items.Add(item);
            }
        }
        
        public bool TestMode = false;


        #endregion

        IRepository<OrderDetail> _repo;
        ITable tbl;
        bool _isNew;
        public bool IsNew(){
            return _isNew;
        }
        public void SetIsNew(bool isNew){
            _isNew=isNew;
        }
        bool _isLoaded;
        public bool IsLoaded(){
            return _isLoaded;
        }
                
        List<IColumn> _dirtyColumns;
        public bool IsDirty(){
            return _dirtyColumns.Count>0;
        }
        
        public List<IColumn> GetDirtyColumns (){
            return _dirtyColumns;
        }

        Southwind.NorthwindDB _db;
        public OrderDetail(string connectionString, string providerName) {

            _db=new Southwind.NorthwindDB(connectionString, providerName);
            Init();            
         }
        void Init(){
            TestMode=this._db.DataProvider.ConnectionString.Equals("test", StringComparison.InvariantCultureIgnoreCase);
            _dirtyColumns=new List<IColumn>();
            if(TestMode){
                OrderDetail.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<OrderDetail>(_db);
            }
            tbl=_repo.GetTable();
            _isNew = true;
            OnCreated();       
      
        }
        
        public OrderDetail(){
             _db=new Southwind.NorthwindDB();
            Init();            
        }
        
       
        partial void OnCreated();
            
        partial void OnLoaded();
        
        partial void OnSaved();
        
        partial void OnChanged();
        
        public IList<IColumn> Columns{
            get{
                return tbl.Columns;
            }
        }

        public OrderDetail(Expression<Func<OrderDetail, bool>> expression):this() {
            _isLoaded=_repo.Load(this,expression);
            if(_isLoaded)
                OnLoaded();
        }
        
       
        
        internal static IRepository<OrderDetail> GetRepo(string connectionString, string providerName){
            Southwind.NorthwindDB db;
            if(String.IsNullOrEmpty(connectionString)){
                db=new Southwind.NorthwindDB();
            }else{
                db=new Southwind.NorthwindDB(connectionString, providerName);
            }
            IRepository<OrderDetail> _repo;
            
            if(db.TestMode){
                OrderDetail.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<OrderDetail>(db);
            }
            return _repo;        
        }       
        
        internal static IRepository<OrderDetail> GetRepo(){
            return GetRepo("","");
        }
        
        public static OrderDetail SingleOrDefault(Expression<Func<OrderDetail, bool>> expression) {

            var repo = GetRepo();
            var results=repo.Find(expression);
            OrderDetail single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
                single.OnLoaded();
                single.SetIsLoaded(true);
            }

            return single;
        }      
        
        public static OrderDetail SingleOrDefault(Expression<Func<OrderDetail, bool>> expression,string connectionString, string providerName) {
            var repo = GetRepo(connectionString,providerName);
            var results=repo.Find(expression);
            OrderDetail single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
                single.OnLoaded();
                single.SetIsLoaded(true);
            }

            return single;


        }
        
        
        public static bool Exists(Expression<Func<OrderDetail, bool>> expression,string connectionString, string providerName) {
           
            return All(connectionString,providerName).Any(expression);
        }        
        public static bool Exists(Expression<Func<OrderDetail, bool>> expression) {
           
            return All().Any(expression);
        }        

        public static IList<OrderDetail> Find(Expression<Func<OrderDetail, bool>> expression) {
            
            var repo = GetRepo();
            return repo.Find(expression).ToList();
        }
        
        public static IList<OrderDetail> Find(Expression<Func<OrderDetail, bool>> expression,string connectionString, string providerName) {

            var repo = GetRepo(connectionString,providerName);
            return repo.Find(expression).ToList();

        }
        public static IQueryable<OrderDetail> All(string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetAll();
        }
        public static IQueryable<OrderDetail> All() {
            return GetRepo().GetAll();
        }
        
        public static PagedList<OrderDetail> GetPaged(string sortBy, int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(sortBy, pageIndex, pageSize);
        }
      
        public static PagedList<OrderDetail> GetPaged(string sortBy, int pageIndex, int pageSize) {
            return GetRepo().GetPaged(sortBy, pageIndex, pageSize);
        }

        public static PagedList<OrderDetail> GetPaged(int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(pageIndex, pageSize);
            
        }


        public static PagedList<OrderDetail> GetPaged(int pageIndex, int pageSize) {
            return GetRepo().GetPaged(pageIndex, pageSize);
            
        }

        public string KeyName()
        {
            return "OrderDetailID";
        }

        public object KeyValue()
        {
            return this.OrderDetailID;
        }
        
        public void SetKeyValue(object value) {
            if (value != null && value!=DBNull.Value) {
                var settable = value.ChangeTypeTo<int>();
                this.GetType().GetProperty(this.KeyName()).SetValue(this, settable, null);
            }
        }
        
        public override string ToString(){
            return this.OrderID.ToString();
        }

        public override bool Equals(object obj){
            if(obj.GetType()==typeof(OrderDetail)){
                OrderDetail compare=(OrderDetail)obj;
                return compare.KeyValue()==this.KeyValue();
            }else{
                return base.Equals(obj);
            }
        }

        public string DescriptorValue()
        {
            return this.OrderID.ToString();
        }

        public string DescriptorColumn() {
            return "OrderID";
        }
        public static string GetKeyColumn()
        {
            return "OrderDetailID";
        }        
        public static string GetDescriptorColumn()
        {
            return "OrderID";
        }
        
        #region ' Foreign Keys '
        #endregion
        

        int _OrderDetailID;
        public int OrderDetailID
        {
            get { return _OrderDetailID; }
            set
            {
                
                _OrderDetailID=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="OrderDetailID");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        int _OrderID;
        public int OrderID
        {
            get { return _OrderID; }
            set
            {
                
                _OrderID=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="OrderID");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        int _ProductID;
        public int ProductID
        {
            get { return _ProductID; }
            set
            {
                
                _ProductID=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="ProductID");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        decimal _UnitPrice;
        public decimal UnitPrice
        {
            get { return _UnitPrice; }
            set
            {
                
                _UnitPrice=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="UnitPrice");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        int _Quantity;
        public int Quantity
        {
            get { return _Quantity; }
            set
            {
                
                _Quantity=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="Quantity");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        decimal _Discount;
        public decimal Discount
        {
            get { return _Discount; }
            set
            {
                
                _Discount=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="Discount");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }



        public DbCommand GetUpdateCommand() {
            if(TestMode)
                return _db.DataProvider.CreateCommand();
            else
                return this.ToUpdateQuery(_db.Provider).GetCommand().ToDbCommand();
            
        }
        public DbCommand GetInsertCommand() {
 
            if(TestMode)
                return _db.DataProvider.CreateCommand();
            else
                return this.ToInsertQuery(_db.Provider).GetCommand().ToDbCommand();
        }
        
        public DbCommand GetDeleteCommand() {
            if(TestMode)
                return _db.DataProvider.CreateCommand();
            else
                return this.ToDeleteQuery(_db.Provider).GetCommand().ToDbCommand();
        }
       
        
        public void Update(){
            Update(_db.DataProvider);
        }
        
        public void Update(IDataProvider provider){
        
            
            if(this._dirtyColumns.Count>0)
                _repo.Update(this,provider);
            OnSaved();
       }
 
        public void Add(){
            Add(_db.DataProvider);
        }
        
        
       
        public void Add(IDataProvider provider){

            this.SetKeyValue(_repo.Add(this,provider));
            OnSaved();
        }
        
                
        
        public void Save() {
            Save(_db.DataProvider);
        }      
        public void Save(IDataProvider provider) {
            
           
            if (_isNew) {
                Add(provider);
                
            } else {
                Update(provider);
            }
            
        }

        

        public void Delete(IDataProvider provider) {
                   
                 
            _repo.Delete(KeyValue());
            
                    }


        public void Delete() {
            Delete(_db.DataProvider);
        }


        public static void Delete(Expression<Func<OrderDetail, bool>> expression) {
            var repo = GetRepo();
            
       
            
            repo.DeleteMany(expression);
            
        }

        

        public void Load(IDataReader rdr) {
            Load(rdr, true);
        }
        public void Load(IDataReader rdr, bool closeReader) {
            if (rdr.Read()) {

                try {
                    rdr.Load(this);
                    _isNew = false;
                    _isLoaded = true;
                } catch {
                    _isLoaded = false;
                    throw;
                }
            }else{
                _isLoaded = false;
            }

            if (closeReader)
                rdr.Dispose();
        }
        

    } 
    
    
    /// <summary>
    /// A class which represents the Customers table in the Northwind Database.
    /// </summary>
    public partial class Customer: IActiveRecord
    {
    
        #region Built-in testing
        static IList<Customer> TestItems;
        static TestRepository<Customer> _testRepo;
        public void SetIsLoaded(bool isLoaded){
            _isLoaded=isLoaded;
        }
        static void SetTestRepo(){
            _testRepo = _testRepo ?? new TestRepository<Customer>(new Southwind.NorthwindDB());
        }
        public static void ResetTestRepo(){
            _testRepo = null;
            SetTestRepo();
        }
        public static void Setup(List<Customer> testlist){
            SetTestRepo();
            _testRepo._items = testlist;
        }
        public static void Setup(Customer item) {
            SetTestRepo();
            _testRepo._items.Add(item);
        }
        public static void Setup(int testItems) {
            SetTestRepo();
            for(int i=0;i<testItems;i++){
                Customer item=new Customer();
                _testRepo._items.Add(item);
            }
        }
        
        public bool TestMode = false;


        #endregion

        IRepository<Customer> _repo;
        ITable tbl;
        bool _isNew;
        public bool IsNew(){
            return _isNew;
        }
        public void SetIsNew(bool isNew){
            _isNew=isNew;
        }
        bool _isLoaded;
        public bool IsLoaded(){
            return _isLoaded;
        }
                
        List<IColumn> _dirtyColumns;
        public bool IsDirty(){
            return _dirtyColumns.Count>0;
        }
        
        public List<IColumn> GetDirtyColumns (){
            return _dirtyColumns;
        }

        Southwind.NorthwindDB _db;
        public Customer(string connectionString, string providerName) {

            _db=new Southwind.NorthwindDB(connectionString, providerName);
            Init();            
         }
        void Init(){
            TestMode=this._db.DataProvider.ConnectionString.Equals("test", StringComparison.InvariantCultureIgnoreCase);
            _dirtyColumns=new List<IColumn>();
            if(TestMode){
                Customer.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<Customer>(_db);
            }
            tbl=_repo.GetTable();
            _isNew = true;
            OnCreated();       
      
        }
        
        public Customer(){
             _db=new Southwind.NorthwindDB();
            Init();            
        }
        
       
        partial void OnCreated();
            
        partial void OnLoaded();
        
        partial void OnSaved();
        
        partial void OnChanged();
        
        public IList<IColumn> Columns{
            get{
                return tbl.Columns;
            }
        }

        public Customer(Expression<Func<Customer, bool>> expression):this() {
            _isLoaded=_repo.Load(this,expression);
            if(_isLoaded)
                OnLoaded();
        }
        
       
        
        internal static IRepository<Customer> GetRepo(string connectionString, string providerName){
            Southwind.NorthwindDB db;
            if(String.IsNullOrEmpty(connectionString)){
                db=new Southwind.NorthwindDB();
            }else{
                db=new Southwind.NorthwindDB(connectionString, providerName);
            }
            IRepository<Customer> _repo;
            
            if(db.TestMode){
                Customer.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<Customer>(db);
            }
            return _repo;        
        }       
        
        internal static IRepository<Customer> GetRepo(){
            return GetRepo("","");
        }
        
        public static Customer SingleOrDefault(Expression<Func<Customer, bool>> expression) {

            var repo = GetRepo();
            var results=repo.Find(expression);
            Customer single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
                single.OnLoaded();
                single.SetIsLoaded(true);
            }

            return single;
        }      
        
        public static Customer SingleOrDefault(Expression<Func<Customer, bool>> expression,string connectionString, string providerName) {
            var repo = GetRepo(connectionString,providerName);
            var results=repo.Find(expression);
            Customer single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
                single.OnLoaded();
                single.SetIsLoaded(true);
            }

            return single;


        }
        
        
        public static bool Exists(Expression<Func<Customer, bool>> expression,string connectionString, string providerName) {
           
            return All(connectionString,providerName).Any(expression);
        }        
        public static bool Exists(Expression<Func<Customer, bool>> expression) {
           
            return All().Any(expression);
        }        

        public static IList<Customer> Find(Expression<Func<Customer, bool>> expression) {
            
            var repo = GetRepo();
            return repo.Find(expression).ToList();
        }
        
        public static IList<Customer> Find(Expression<Func<Customer, bool>> expression,string connectionString, string providerName) {

            var repo = GetRepo(connectionString,providerName);
            return repo.Find(expression).ToList();

        }
        public static IQueryable<Customer> All(string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetAll();
        }
        public static IQueryable<Customer> All() {
            return GetRepo().GetAll();
        }
        
        public static PagedList<Customer> GetPaged(string sortBy, int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(sortBy, pageIndex, pageSize);
        }
      
        public static PagedList<Customer> GetPaged(string sortBy, int pageIndex, int pageSize) {
            return GetRepo().GetPaged(sortBy, pageIndex, pageSize);
        }

        public static PagedList<Customer> GetPaged(int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(pageIndex, pageSize);
            
        }


        public static PagedList<Customer> GetPaged(int pageIndex, int pageSize) {
            return GetRepo().GetPaged(pageIndex, pageSize);
            
        }

        public string KeyName()
        {
            return "CustomerID";
        }

        public object KeyValue()
        {
            return this.CustomerID;
        }
        
        public void SetKeyValue(object value) {
            if (value != null && value!=DBNull.Value) {
                var settable = value.ChangeTypeTo<string>();
                this.GetType().GetProperty(this.KeyName()).SetValue(this, settable, null);
            }
        }
        
        public override string ToString(){
            return this.CustomerID.ToString();
        }

        public override bool Equals(object obj){
            if(obj.GetType()==typeof(Customer)){
                Customer compare=(Customer)obj;
                return compare.KeyValue()==this.KeyValue();
            }else{
                return base.Equals(obj);
            }
        }

        public string DescriptorValue()
        {
            return this.CustomerID.ToString();
        }

        public string DescriptorColumn() {
            return "CustomerID";
        }
        public static string GetKeyColumn()
        {
            return "CustomerID";
        }        
        public static string GetDescriptorColumn()
        {
            return "CustomerID";
        }
        
        #region ' Foreign Keys '
        #endregion
        

        string _CustomerID;
        public string CustomerID
        {
            get { return _CustomerID; }
            set
            {
                
                _CustomerID=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="CustomerID");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        string _CompanyName;
        public string CompanyName
        {
            get { return _CompanyName; }
            set
            {
                
                _CompanyName=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="CompanyName");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        string _ContactName;
        public string ContactName
        {
            get { return _ContactName; }
            set
            {
                
                _ContactName=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="ContactName");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        string _Address;
        public string Address
        {
            get { return _Address; }
            set
            {
                
                _Address=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="Address");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        string _City;
        public string City
        {
            get { return _City; }
            set
            {
                
                _City=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="City");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        string _Region;
        public string Region
        {
            get { return _Region; }
            set
            {
                
                _Region=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="Region");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        string _Country;
        public string Country
        {
            get { return _Country; }
            set
            {
                
                _Country=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="Country");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }



        public DbCommand GetUpdateCommand() {
            if(TestMode)
                return _db.DataProvider.CreateCommand();
            else
                return this.ToUpdateQuery(_db.Provider).GetCommand().ToDbCommand();
            
        }
        public DbCommand GetInsertCommand() {
 
            if(TestMode)
                return _db.DataProvider.CreateCommand();
            else
                return this.ToInsertQuery(_db.Provider).GetCommand().ToDbCommand();
        }
        
        public DbCommand GetDeleteCommand() {
            if(TestMode)
                return _db.DataProvider.CreateCommand();
            else
                return this.ToDeleteQuery(_db.Provider).GetCommand().ToDbCommand();
        }
       
        
        public void Update(){
            Update(_db.DataProvider);
        }
        
        public void Update(IDataProvider provider){
        
            
            if(this._dirtyColumns.Count>0)
                _repo.Update(this,provider);
            OnSaved();
       }
 
        public void Add(){
            Add(_db.DataProvider);
        }
        
        
       
        public void Add(IDataProvider provider){

            this.SetKeyValue(_repo.Add(this,provider));
            OnSaved();
        }
        
                
        
        public void Save() {
            Save(_db.DataProvider);
        }      
        public void Save(IDataProvider provider) {
            
           
            if (_isNew) {
                Add(provider);
                
            } else {
                Update(provider);
            }
            
        }

        

        public void Delete(IDataProvider provider) {
                   
                 
            _repo.Delete(KeyValue());
            
                    }


        public void Delete() {
            Delete(_db.DataProvider);
        }


        public static void Delete(Expression<Func<Customer, bool>> expression) {
            var repo = GetRepo();
            
       
            
            repo.DeleteMany(expression);
            
        }

        

        public void Load(IDataReader rdr) {
            Load(rdr, true);
        }
        public void Load(IDataReader rdr, bool closeReader) {
            if (rdr.Read()) {

                try {
                    rdr.Load(this);
                    _isNew = false;
                    _isLoaded = true;
                } catch {
                    _isLoaded = false;
                    throw;
                }
            }else{
                _isLoaded = false;
            }

            if (closeReader)
                rdr.Dispose();
        }
        

    } 
    
    
    /// <summary>
    /// A class which represents the Categories table in the Northwind Database.
    /// </summary>
    public partial class Category: IActiveRecord
    {
    
        #region Built-in testing
        static IList<Category> TestItems;
        static TestRepository<Category> _testRepo;
        public void SetIsLoaded(bool isLoaded){
            _isLoaded=isLoaded;
        }
        static void SetTestRepo(){
            _testRepo = _testRepo ?? new TestRepository<Category>(new Southwind.NorthwindDB());
        }
        public static void ResetTestRepo(){
            _testRepo = null;
            SetTestRepo();
        }
        public static void Setup(List<Category> testlist){
            SetTestRepo();
            _testRepo._items = testlist;
        }
        public static void Setup(Category item) {
            SetTestRepo();
            _testRepo._items.Add(item);
        }
        public static void Setup(int testItems) {
            SetTestRepo();
            for(int i=0;i<testItems;i++){
                Category item=new Category();
                _testRepo._items.Add(item);
            }
        }
        
        public bool TestMode = false;


        #endregion

        IRepository<Category> _repo;
        ITable tbl;
        bool _isNew;
        public bool IsNew(){
            return _isNew;
        }
        public void SetIsNew(bool isNew){
            _isNew=isNew;
        }
        bool _isLoaded;
        public bool IsLoaded(){
            return _isLoaded;
        }
                
        List<IColumn> _dirtyColumns;
        public bool IsDirty(){
            return _dirtyColumns.Count>0;
        }
        
        public List<IColumn> GetDirtyColumns (){
            return _dirtyColumns;
        }

        Southwind.NorthwindDB _db;
        public Category(string connectionString, string providerName) {

            _db=new Southwind.NorthwindDB(connectionString, providerName);
            Init();            
         }
        void Init(){
            TestMode=this._db.DataProvider.ConnectionString.Equals("test", StringComparison.InvariantCultureIgnoreCase);
            _dirtyColumns=new List<IColumn>();
            if(TestMode){
                Category.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<Category>(_db);
            }
            tbl=_repo.GetTable();
            _isNew = true;
            OnCreated();       
      
        }
        
        public Category(){
             _db=new Southwind.NorthwindDB();
            Init();            
        }
        
       
        partial void OnCreated();
            
        partial void OnLoaded();
        
        partial void OnSaved();
        
        partial void OnChanged();
        
        public IList<IColumn> Columns{
            get{
                return tbl.Columns;
            }
        }

        public Category(Expression<Func<Category, bool>> expression):this() {
            _isLoaded=_repo.Load(this,expression);
            if(_isLoaded)
                OnLoaded();
        }
        
       
        
        internal static IRepository<Category> GetRepo(string connectionString, string providerName){
            Southwind.NorthwindDB db;
            if(String.IsNullOrEmpty(connectionString)){
                db=new Southwind.NorthwindDB();
            }else{
                db=new Southwind.NorthwindDB(connectionString, providerName);
            }
            IRepository<Category> _repo;
            
            if(db.TestMode){
                Category.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<Category>(db);
            }
            return _repo;        
        }       
        
        internal static IRepository<Category> GetRepo(){
            return GetRepo("","");
        }
        
        public static Category SingleOrDefault(Expression<Func<Category, bool>> expression) {

            var repo = GetRepo();
            var results=repo.Find(expression);
            Category single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
                single.OnLoaded();
                single.SetIsLoaded(true);
            }

            return single;
        }      
        
        public static Category SingleOrDefault(Expression<Func<Category, bool>> expression,string connectionString, string providerName) {
            var repo = GetRepo(connectionString,providerName);
            var results=repo.Find(expression);
            Category single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
                single.OnLoaded();
                single.SetIsLoaded(true);
            }

            return single;


        }
        
        
        public static bool Exists(Expression<Func<Category, bool>> expression,string connectionString, string providerName) {
           
            return All(connectionString,providerName).Any(expression);
        }        
        public static bool Exists(Expression<Func<Category, bool>> expression) {
           
            return All().Any(expression);
        }        

        public static IList<Category> Find(Expression<Func<Category, bool>> expression) {
            
            var repo = GetRepo();
            return repo.Find(expression).ToList();
        }
        
        public static IList<Category> Find(Expression<Func<Category, bool>> expression,string connectionString, string providerName) {

            var repo = GetRepo(connectionString,providerName);
            return repo.Find(expression).ToList();

        }
        public static IQueryable<Category> All(string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetAll();
        }
        public static IQueryable<Category> All() {
            return GetRepo().GetAll();
        }
        
        public static PagedList<Category> GetPaged(string sortBy, int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(sortBy, pageIndex, pageSize);
        }
      
        public static PagedList<Category> GetPaged(string sortBy, int pageIndex, int pageSize) {
            return GetRepo().GetPaged(sortBy, pageIndex, pageSize);
        }

        public static PagedList<Category> GetPaged(int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(pageIndex, pageSize);
            
        }


        public static PagedList<Category> GetPaged(int pageIndex, int pageSize) {
            return GetRepo().GetPaged(pageIndex, pageSize);
            
        }

        public string KeyName()
        {
            return "CategoryID";
        }

        public object KeyValue()
        {
            return this.CategoryID;
        }
        
        public void SetKeyValue(object value) {
            if (value != null && value!=DBNull.Value) {
                var settable = value.ChangeTypeTo<int>();
                this.GetType().GetProperty(this.KeyName()).SetValue(this, settable, null);
            }
        }
        
        public override string ToString(){
            return this.CategoryName.ToString();
        }

        public override bool Equals(object obj){
            if(obj.GetType()==typeof(Category)){
                Category compare=(Category)obj;
                return compare.KeyValue()==this.KeyValue();
            }else{
                return base.Equals(obj);
            }
        }

        public string DescriptorValue()
        {
            return this.CategoryName.ToString();
        }

        public string DescriptorColumn() {
            return "CategoryName";
        }
        public static string GetKeyColumn()
        {
            return "CategoryID";
        }        
        public static string GetDescriptorColumn()
        {
            return "CategoryName";
        }
        
        #region ' Foreign Keys '
        #endregion
        

        int _CategoryID;
        public int CategoryID
        {
            get { return _CategoryID; }
            set
            {
                
                _CategoryID=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="CategoryID");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        string _CategoryName;
        public string CategoryName
        {
            get { return _CategoryName; }
            set
            {
                
                _CategoryName=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="CategoryName");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }



        public DbCommand GetUpdateCommand() {
            if(TestMode)
                return _db.DataProvider.CreateCommand();
            else
                return this.ToUpdateQuery(_db.Provider).GetCommand().ToDbCommand();
            
        }
        public DbCommand GetInsertCommand() {
 
            if(TestMode)
                return _db.DataProvider.CreateCommand();
            else
                return this.ToInsertQuery(_db.Provider).GetCommand().ToDbCommand();
        }
        
        public DbCommand GetDeleteCommand() {
            if(TestMode)
                return _db.DataProvider.CreateCommand();
            else
                return this.ToDeleteQuery(_db.Provider).GetCommand().ToDbCommand();
        }
       
        
        public void Update(){
            Update(_db.DataProvider);
        }
        
        public void Update(IDataProvider provider){
        
            
            if(this._dirtyColumns.Count>0)
                _repo.Update(this,provider);
            OnSaved();
       }
 
        public void Add(){
            Add(_db.DataProvider);
        }
        
        
       
        public void Add(IDataProvider provider){

            this.SetKeyValue(_repo.Add(this,provider));
            OnSaved();
        }
        
                
        
        public void Save() {
            Save(_db.DataProvider);
        }      
        public void Save(IDataProvider provider) {
            
           
            if (_isNew) {
                Add(provider);
                
            } else {
                Update(provider);
            }
            
        }

        

        public void Delete(IDataProvider provider) {
                   
                 
            _repo.Delete(KeyValue());
            
                    }


        public void Delete() {
            Delete(_db.DataProvider);
        }


        public static void Delete(Expression<Func<Category, bool>> expression) {
            var repo = GetRepo();
            
       
            
            repo.DeleteMany(expression);
            
        }

        

        public void Load(IDataReader rdr) {
            Load(rdr, true);
        }
        public void Load(IDataReader rdr, bool closeReader) {
            if (rdr.Read()) {

                try {
                    rdr.Load(this);
                    _isNew = false;
                    _isLoaded = true;
                } catch {
                    _isLoaded = false;
                    throw;
                }
            }else{
                _isLoaded = false;
            }

            if (closeReader)
                rdr.Dispose();
        }
        

    } 
    
    
    /// <summary>
    /// A class which represents the Shwerkos table in the Northwind Database.
    /// </summary>
    public partial class Shwerko: IActiveRecord
    {
    
        #region Built-in testing
        static IList<Shwerko> TestItems;
        static TestRepository<Shwerko> _testRepo;
        public void SetIsLoaded(bool isLoaded){
            _isLoaded=isLoaded;
        }
        static void SetTestRepo(){
            _testRepo = _testRepo ?? new TestRepository<Shwerko>(new Southwind.NorthwindDB());
        }
        public static void ResetTestRepo(){
            _testRepo = null;
            SetTestRepo();
        }
        public static void Setup(List<Shwerko> testlist){
            SetTestRepo();
            _testRepo._items = testlist;
        }
        public static void Setup(Shwerko item) {
            SetTestRepo();
            _testRepo._items.Add(item);
        }
        public static void Setup(int testItems) {
            SetTestRepo();
            for(int i=0;i<testItems;i++){
                Shwerko item=new Shwerko();
                _testRepo._items.Add(item);
            }
        }
        
        public bool TestMode = false;


        #endregion

        IRepository<Shwerko> _repo;
        ITable tbl;
        bool _isNew;
        public bool IsNew(){
            return _isNew;
        }
        public void SetIsNew(bool isNew){
            _isNew=isNew;
        }
        bool _isLoaded;
        public bool IsLoaded(){
            return _isLoaded;
        }
                
        List<IColumn> _dirtyColumns;
        public bool IsDirty(){
            return _dirtyColumns.Count>0;
        }
        
        public List<IColumn> GetDirtyColumns (){
            return _dirtyColumns;
        }

        Southwind.NorthwindDB _db;
        public Shwerko(string connectionString, string providerName) {

            _db=new Southwind.NorthwindDB(connectionString, providerName);
            Init();            
         }
        void Init(){
            TestMode=this._db.DataProvider.ConnectionString.Equals("test", StringComparison.InvariantCultureIgnoreCase);
            _dirtyColumns=new List<IColumn>();
            if(TestMode){
                Shwerko.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<Shwerko>(_db);
            }
            tbl=_repo.GetTable();
            _isNew = true;
            OnCreated();       
      
        }
        
        public Shwerko(){
             _db=new Southwind.NorthwindDB();
            Init();            
        }
        
       
        partial void OnCreated();
            
        partial void OnLoaded();
        
        partial void OnSaved();
        
        partial void OnChanged();
        
        public IList<IColumn> Columns{
            get{
                return tbl.Columns;
            }
        }

        public Shwerko(Expression<Func<Shwerko, bool>> expression):this() {
            _isLoaded=_repo.Load(this,expression);
            if(_isLoaded)
                OnLoaded();
        }
        
       
        
        internal static IRepository<Shwerko> GetRepo(string connectionString, string providerName){
            Southwind.NorthwindDB db;
            if(String.IsNullOrEmpty(connectionString)){
                db=new Southwind.NorthwindDB();
            }else{
                db=new Southwind.NorthwindDB(connectionString, providerName);
            }
            IRepository<Shwerko> _repo;
            
            if(db.TestMode){
                Shwerko.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<Shwerko>(db);
            }
            return _repo;        
        }       
        
        internal static IRepository<Shwerko> GetRepo(){
            return GetRepo("","");
        }
        
        public static Shwerko SingleOrDefault(Expression<Func<Shwerko, bool>> expression) {

            var repo = GetRepo();
            var results=repo.Find(expression);
            Shwerko single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
                single.OnLoaded();
                single.SetIsLoaded(true);
            }

            return single;
        }      
        
        public static Shwerko SingleOrDefault(Expression<Func<Shwerko, bool>> expression,string connectionString, string providerName) {
            var repo = GetRepo(connectionString,providerName);
            var results=repo.Find(expression);
            Shwerko single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
                single.OnLoaded();
                single.SetIsLoaded(true);
            }

            return single;


        }
        
        
        public static bool Exists(Expression<Func<Shwerko, bool>> expression,string connectionString, string providerName) {
           
            return All(connectionString,providerName).Any(expression);
        }        
        public static bool Exists(Expression<Func<Shwerko, bool>> expression) {
           
            return All().Any(expression);
        }        

        public static IList<Shwerko> Find(Expression<Func<Shwerko, bool>> expression) {
            
            var repo = GetRepo();
            return repo.Find(expression).ToList();
        }
        
        public static IList<Shwerko> Find(Expression<Func<Shwerko, bool>> expression,string connectionString, string providerName) {

            var repo = GetRepo(connectionString,providerName);
            return repo.Find(expression).ToList();

        }
        public static IQueryable<Shwerko> All(string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetAll();
        }
        public static IQueryable<Shwerko> All() {
            return GetRepo().GetAll();
        }
        
        public static PagedList<Shwerko> GetPaged(string sortBy, int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(sortBy, pageIndex, pageSize);
        }
      
        public static PagedList<Shwerko> GetPaged(string sortBy, int pageIndex, int pageSize) {
            return GetRepo().GetPaged(sortBy, pageIndex, pageSize);
        }

        public static PagedList<Shwerko> GetPaged(int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(pageIndex, pageSize);
            
        }


        public static PagedList<Shwerko> GetPaged(int pageIndex, int pageSize) {
            return GetRepo().GetPaged(pageIndex, pageSize);
            
        }

        public string KeyName()
        {
            return "ID";
        }

        public object KeyValue()
        {
            return this.ID;
        }
        
        public void SetKeyValue(object value) {
            if (value != null && value!=DBNull.Value) {
                var settable = value.ChangeTypeTo<int>();
                this.GetType().GetProperty(this.KeyName()).SetValue(this, settable, null);
            }
        }
        
        public override string ToString(){
            return this.Name.ToString();
        }

        public override bool Equals(object obj){
            if(obj.GetType()==typeof(Shwerko)){
                Shwerko compare=(Shwerko)obj;
                return compare.KeyValue()==this.KeyValue();
            }else{
                return base.Equals(obj);
            }
        }

        public string DescriptorValue()
        {
            return this.Name.ToString();
        }

        public string DescriptorColumn() {
            return "Name";
        }
        public static string GetKeyColumn()
        {
            return "ID";
        }        
        public static string GetDescriptorColumn()
        {
            return "Name";
        }
        
        #region ' Foreign Keys '
        #endregion
        

        int _ID;
        public int ID
        {
            get { return _ID; }
            set
            {
                
                _ID=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="ID");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        Guid _Key;
        public Guid Key
        {
            get { return _Key; }
            set
            {
                
                _Key=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="Key");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        string _Name;
        public string Name
        {
            get { return _Name; }
            set
            {
                
                _Name=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="Name");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        DateTime _ElDate;
        public DateTime ElDate
        {
            get { return _ElDate; }
            set
            {
                
                _ElDate=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="ElDate");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        decimal _SomeNumber;
        public decimal SomeNumber
        {
            get { return _SomeNumber; }
            set
            {
                
                _SomeNumber=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="SomeNumber");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        int? _NullInt;
        public int? NullInt
        {
            get { return _NullInt; }
            set
            {
                
                _NullInt=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="NullInt");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        decimal? _NullSomeNumber;
        public decimal? NullSomeNumber
        {
            get { return _NullSomeNumber; }
            set
            {
                
                _NullSomeNumber=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="NullSomeNumber");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        DateTime? _NullElDate;
        public DateTime? NullElDate
        {
            get { return _NullElDate; }
            set
            {
                
                _NullElDate=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="NullElDate");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        Guid? _NullKey;
        public Guid? NullKey
        {
            get { return _NullKey; }
            set
            {
                
                _NullKey=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="NullKey");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        int _Underscored_Column;
        public int Underscored_Column
        {
            get { return _Underscored_Column; }
            set
            {
                
                _Underscored_Column=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="Underscored_Column");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }



        public DbCommand GetUpdateCommand() {
            if(TestMode)
                return _db.DataProvider.CreateCommand();
            else
                return this.ToUpdateQuery(_db.Provider).GetCommand().ToDbCommand();
            
        }
        public DbCommand GetInsertCommand() {
 
            if(TestMode)
                return _db.DataProvider.CreateCommand();
            else
                return this.ToInsertQuery(_db.Provider).GetCommand().ToDbCommand();
        }
        
        public DbCommand GetDeleteCommand() {
            if(TestMode)
                return _db.DataProvider.CreateCommand();
            else
                return this.ToDeleteQuery(_db.Provider).GetCommand().ToDbCommand();
        }
       
        
        public void Update(){
            Update(_db.DataProvider);
        }
        
        public void Update(IDataProvider provider){
        
            
            if(this._dirtyColumns.Count>0)
                _repo.Update(this,provider);
            OnSaved();
       }
 
        public void Add(){
            Add(_db.DataProvider);
        }
        
        
       
        public void Add(IDataProvider provider){

            this.SetKeyValue(_repo.Add(this,provider));
            OnSaved();
        }
        
                
        
        public void Save() {
            Save(_db.DataProvider);
        }      
        public void Save(IDataProvider provider) {
            
           
            if (_isNew) {
                Add(provider);
                
            } else {
                Update(provider);
            }
            
        }

        

        public void Delete(IDataProvider provider) {
                   
                 
            _repo.Delete(KeyValue());
            
                    }


        public void Delete() {
            Delete(_db.DataProvider);
        }


        public static void Delete(Expression<Func<Shwerko, bool>> expression) {
            var repo = GetRepo();
            
       
            
            repo.DeleteMany(expression);
            
        }

        

        public void Load(IDataReader rdr) {
            Load(rdr, true);
        }
        public void Load(IDataReader rdr, bool closeReader) {
            if (rdr.Read()) {

                try {
                    rdr.Load(this);
                    _isNew = false;
                    _isLoaded = true;
                } catch {
                    _isLoaded = false;
                    throw;
                }
            }else{
                _isLoaded = false;
            }

            if (closeReader)
                rdr.Dispose();
        }
        

    } 
}
