


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

namespace SouthWind
{
    
    
    /// <summary>
    /// A class which represents the Customers table in the Northwind Database.
    /// </summary>
    public partial class Customer: IActiveRecord
    {
    
        #region Built-in testing
        static IList<Customer> TestItems;
        static TestRepository<Customer> _testRepo;
        

        
        static void SetTestRepo(){
            _testRepo = _testRepo ?? new TestRepository<Customer>(new SouthWind.NorthwindDB());
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
        
        public void SetIsLoaded(bool isLoaded){
            _isLoaded=isLoaded;
            if(isLoaded)
                OnLoaded();
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

        SouthWind.NorthwindDB _db;
        public Customer(string connectionString, string providerName) {

            _db=new SouthWind.NorthwindDB(connectionString, providerName);
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
            SetIsNew(true);
            OnCreated();       

        }
        
        public Customer(){
             _db=new SouthWind.NorthwindDB();
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

            SetIsLoaded(_repo.Load(this,expression));
        }
        
       
        
        internal static IRepository<Customer> GetRepo(string connectionString, string providerName){
            SouthWind.NorthwindDB db;
            if(String.IsNullOrEmpty(connectionString)){
                db=new SouthWind.NorthwindDB();
            }else{
                db=new SouthWind.NorthwindDB(connectionString, providerName);
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
                single.SetIsNew(false);
            }

            return single;
        }      
        
        public static Customer SingleOrDefault(Expression<Func<Customer, bool>> expression,string connectionString, string providerName) {
            var repo = GetRepo(connectionString,providerName);
            var results=repo.Find(expression);
            Customer single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
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
        public IQueryable<CustomerCustomerDemo> CustomerCustomerDemos
        {
            get
            {
                
                  var repo=SouthWind.CustomerCustomerDemo.GetRepo();
                  return from items in repo.GetAll()
                       where items.CustomerID == _CustomerID
                       select items;
            }
        }

        public IQueryable<Order> Orders
        {
            get
            {
                
                  var repo=SouthWind.Order.GetRepo();
                  return from items in repo.GetAll()
                       where items.CustomerID == _CustomerID
                       select items;
            }
        }

        #endregion
        

        string _CustomerID;
        public string CustomerID
        {
            get { return _CustomerID; }
            set
            {
                if(_CustomerID!=value){
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
        }

        string _CompanyName;
        public string CompanyName
        {
            get { return _CompanyName; }
            set
            {
                if(_CompanyName!=value){
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
        }

        string _ContactName;
        public string ContactName
        {
            get { return _ContactName; }
            set
            {
                if(_ContactName!=value){
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
        }

        string _ContactTitle;
        public string ContactTitle
        {
            get { return _ContactTitle; }
            set
            {
                if(_ContactTitle!=value){
                    _ContactTitle=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="ContactTitle");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _Address;
        public string Address
        {
            get { return _Address; }
            set
            {
                if(_Address!=value){
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
        }

        string _City;
        public string City
        {
            get { return _City; }
            set
            {
                if(_City!=value){
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
        }

        string _Region;
        public string Region
        {
            get { return _Region; }
            set
            {
                if(_Region!=value){
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
        }

        string _PostalCode;
        public string PostalCode
        {
            get { return _PostalCode; }
            set
            {
                if(_PostalCode!=value){
                    _PostalCode=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="PostalCode");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _Country;
        public string Country
        {
            get { return _Country; }
            set
            {
                if(_Country!=value){
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
        }

        string _Phone;
        public string Phone
        {
            get { return _Phone; }
            set
            {
                if(_Phone!=value){
                    _Phone=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="Phone");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _Fax;
        public string Fax
        {
            get { return _Fax; }
            set
            {
                if(_Fax!=value){
                    _Fax=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="Fax");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
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

            
            var newKey=_repo.Add(this,provider);
            if(newKey!=KeyValue())
                this.SetKeyValue(newKey);
            
            SetIsNew(false);
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
                    SetIsNew(false);
                    SetIsLoaded(true);
                } catch {
                    SetIsLoaded(false);
                    throw;
                }
            }else{
                SetIsLoaded(false);
            }

            if (closeReader)
                rdr.Dispose();
        }
        

    } 
    
    
    /// <summary>
    /// A class which represents the Shippers table in the Northwind Database.
    /// </summary>
    public partial class Shipper: IActiveRecord
    {
    
        #region Built-in testing
        static IList<Shipper> TestItems;
        static TestRepository<Shipper> _testRepo;
        

        
        static void SetTestRepo(){
            _testRepo = _testRepo ?? new TestRepository<Shipper>(new SouthWind.NorthwindDB());
        }
        public static void ResetTestRepo(){
            _testRepo = null;
            SetTestRepo();
        }
        public static void Setup(List<Shipper> testlist){
            SetTestRepo();
            _testRepo._items = testlist;
        }
        public static void Setup(Shipper item) {
            SetTestRepo();
            _testRepo._items.Add(item);
        }
        public static void Setup(int testItems) {
            SetTestRepo();
            for(int i=0;i<testItems;i++){
                Shipper item=new Shipper();
                _testRepo._items.Add(item);
            }
        }
        
        public bool TestMode = false;


        #endregion

        IRepository<Shipper> _repo;
        ITable tbl;
        bool _isNew;
        public bool IsNew(){
            return _isNew;
        }
        
        public void SetIsLoaded(bool isLoaded){
            _isLoaded=isLoaded;
            if(isLoaded)
                OnLoaded();
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

        SouthWind.NorthwindDB _db;
        public Shipper(string connectionString, string providerName) {

            _db=new SouthWind.NorthwindDB(connectionString, providerName);
            Init();            
         }
        void Init(){
            TestMode=this._db.DataProvider.ConnectionString.Equals("test", StringComparison.InvariantCultureIgnoreCase);
            _dirtyColumns=new List<IColumn>();
            if(TestMode){
                Shipper.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<Shipper>(_db);
            }
            tbl=_repo.GetTable();
            SetIsNew(true);
            OnCreated();       

        }
        
        public Shipper(){
             _db=new SouthWind.NorthwindDB();
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

        public Shipper(Expression<Func<Shipper, bool>> expression):this() {

            SetIsLoaded(_repo.Load(this,expression));
        }
        
       
        
        internal static IRepository<Shipper> GetRepo(string connectionString, string providerName){
            SouthWind.NorthwindDB db;
            if(String.IsNullOrEmpty(connectionString)){
                db=new SouthWind.NorthwindDB();
            }else{
                db=new SouthWind.NorthwindDB(connectionString, providerName);
            }
            IRepository<Shipper> _repo;
            
            if(db.TestMode){
                Shipper.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<Shipper>(db);
            }
            return _repo;        
        }       
        
        internal static IRepository<Shipper> GetRepo(){
            return GetRepo("","");
        }
        
        public static Shipper SingleOrDefault(Expression<Func<Shipper, bool>> expression) {

            var repo = GetRepo();
            var results=repo.Find(expression);
            Shipper single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
                single.OnLoaded();
                single.SetIsLoaded(true);
                single.SetIsNew(false);
            }

            return single;
        }      
        
        public static Shipper SingleOrDefault(Expression<Func<Shipper, bool>> expression,string connectionString, string providerName) {
            var repo = GetRepo(connectionString,providerName);
            var results=repo.Find(expression);
            Shipper single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
            }

            return single;


        }
        
        
        public static bool Exists(Expression<Func<Shipper, bool>> expression,string connectionString, string providerName) {
           
            return All(connectionString,providerName).Any(expression);
        }        
        public static bool Exists(Expression<Func<Shipper, bool>> expression) {
           
            return All().Any(expression);
        }        

        public static IList<Shipper> Find(Expression<Func<Shipper, bool>> expression) {
            
            var repo = GetRepo();
            return repo.Find(expression).ToList();
        }
        
        public static IList<Shipper> Find(Expression<Func<Shipper, bool>> expression,string connectionString, string providerName) {

            var repo = GetRepo(connectionString,providerName);
            return repo.Find(expression).ToList();

        }
        public static IQueryable<Shipper> All(string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetAll();
        }
        public static IQueryable<Shipper> All() {
            return GetRepo().GetAll();
        }
        
        public static PagedList<Shipper> GetPaged(string sortBy, int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(sortBy, pageIndex, pageSize);
        }
      
        public static PagedList<Shipper> GetPaged(string sortBy, int pageIndex, int pageSize) {
            return GetRepo().GetPaged(sortBy, pageIndex, pageSize);
        }

        public static PagedList<Shipper> GetPaged(int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(pageIndex, pageSize);
            
        }


        public static PagedList<Shipper> GetPaged(int pageIndex, int pageSize) {
            return GetRepo().GetPaged(pageIndex, pageSize);
            
        }

        public string KeyName()
        {
            return "ShipperID";
        }

        public object KeyValue()
        {
            return this.ShipperID;
        }
        
        public void SetKeyValue(object value) {
            if (value != null && value!=DBNull.Value) {
                var settable = value.ChangeTypeTo<int>();
                this.GetType().GetProperty(this.KeyName()).SetValue(this, settable, null);
            }
        }
        
        public override string ToString(){
            return this.CompanyName.ToString();
        }

        public override bool Equals(object obj){
            if(obj.GetType()==typeof(Shipper)){
                Shipper compare=(Shipper)obj;
                return compare.KeyValue()==this.KeyValue();
            }else{
                return base.Equals(obj);
            }
        }

        public string DescriptorValue()
        {
            return this.CompanyName.ToString();
        }

        public string DescriptorColumn() {
            return "CompanyName";
        }
        public static string GetKeyColumn()
        {
            return "ShipperID";
        }        
        public static string GetDescriptorColumn()
        {
            return "CompanyName";
        }
        
        #region ' Foreign Keys '
        public IQueryable<Order> Orders
        {
            get
            {
                
                  var repo=SouthWind.Order.GetRepo();
                  return from items in repo.GetAll()
                       where items.ShipVia == _ShipperID
                       select items;
            }
        }

        #endregion
        

        int _ShipperID;
        public int ShipperID
        {
            get { return _ShipperID; }
            set
            {
                if(_ShipperID!=value){
                    _ShipperID=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="ShipperID");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _CompanyName;
        public string CompanyName
        {
            get { return _CompanyName; }
            set
            {
                if(_CompanyName!=value){
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
        }

        string _Phone;
        public string Phone
        {
            get { return _Phone; }
            set
            {
                if(_Phone!=value){
                    _Phone=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="Phone");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
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

            
            var newKey=_repo.Add(this,provider);
            if(newKey!=KeyValue())
                this.SetKeyValue(newKey);
            
            SetIsNew(false);
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


        public static void Delete(Expression<Func<Shipper, bool>> expression) {
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
                    SetIsNew(false);
                    SetIsLoaded(true);
                } catch {
                    SetIsLoaded(false);
                    throw;
                }
            }else{
                SetIsLoaded(false);
            }

            if (closeReader)
                rdr.Dispose();
        }
        

    } 
    
    
    /// <summary>
    /// A class which represents the Suppliers table in the Northwind Database.
    /// </summary>
    public partial class Supplier: IActiveRecord
    {
    
        #region Built-in testing
        static IList<Supplier> TestItems;
        static TestRepository<Supplier> _testRepo;
        

        
        static void SetTestRepo(){
            _testRepo = _testRepo ?? new TestRepository<Supplier>(new SouthWind.NorthwindDB());
        }
        public static void ResetTestRepo(){
            _testRepo = null;
            SetTestRepo();
        }
        public static void Setup(List<Supplier> testlist){
            SetTestRepo();
            _testRepo._items = testlist;
        }
        public static void Setup(Supplier item) {
            SetTestRepo();
            _testRepo._items.Add(item);
        }
        public static void Setup(int testItems) {
            SetTestRepo();
            for(int i=0;i<testItems;i++){
                Supplier item=new Supplier();
                _testRepo._items.Add(item);
            }
        }
        
        public bool TestMode = false;


        #endregion

        IRepository<Supplier> _repo;
        ITable tbl;
        bool _isNew;
        public bool IsNew(){
            return _isNew;
        }
        
        public void SetIsLoaded(bool isLoaded){
            _isLoaded=isLoaded;
            if(isLoaded)
                OnLoaded();
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

        SouthWind.NorthwindDB _db;
        public Supplier(string connectionString, string providerName) {

            _db=new SouthWind.NorthwindDB(connectionString, providerName);
            Init();            
         }
        void Init(){
            TestMode=this._db.DataProvider.ConnectionString.Equals("test", StringComparison.InvariantCultureIgnoreCase);
            _dirtyColumns=new List<IColumn>();
            if(TestMode){
                Supplier.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<Supplier>(_db);
            }
            tbl=_repo.GetTable();
            SetIsNew(true);
            OnCreated();       

        }
        
        public Supplier(){
             _db=new SouthWind.NorthwindDB();
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

        public Supplier(Expression<Func<Supplier, bool>> expression):this() {

            SetIsLoaded(_repo.Load(this,expression));
        }
        
       
        
        internal static IRepository<Supplier> GetRepo(string connectionString, string providerName){
            SouthWind.NorthwindDB db;
            if(String.IsNullOrEmpty(connectionString)){
                db=new SouthWind.NorthwindDB();
            }else{
                db=new SouthWind.NorthwindDB(connectionString, providerName);
            }
            IRepository<Supplier> _repo;
            
            if(db.TestMode){
                Supplier.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<Supplier>(db);
            }
            return _repo;        
        }       
        
        internal static IRepository<Supplier> GetRepo(){
            return GetRepo("","");
        }
        
        public static Supplier SingleOrDefault(Expression<Func<Supplier, bool>> expression) {

            var repo = GetRepo();
            var results=repo.Find(expression);
            Supplier single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
                single.OnLoaded();
                single.SetIsLoaded(true);
                single.SetIsNew(false);
            }

            return single;
        }      
        
        public static Supplier SingleOrDefault(Expression<Func<Supplier, bool>> expression,string connectionString, string providerName) {
            var repo = GetRepo(connectionString,providerName);
            var results=repo.Find(expression);
            Supplier single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
            }

            return single;


        }
        
        
        public static bool Exists(Expression<Func<Supplier, bool>> expression,string connectionString, string providerName) {
           
            return All(connectionString,providerName).Any(expression);
        }        
        public static bool Exists(Expression<Func<Supplier, bool>> expression) {
           
            return All().Any(expression);
        }        

        public static IList<Supplier> Find(Expression<Func<Supplier, bool>> expression) {
            
            var repo = GetRepo();
            return repo.Find(expression).ToList();
        }
        
        public static IList<Supplier> Find(Expression<Func<Supplier, bool>> expression,string connectionString, string providerName) {

            var repo = GetRepo(connectionString,providerName);
            return repo.Find(expression).ToList();

        }
        public static IQueryable<Supplier> All(string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetAll();
        }
        public static IQueryable<Supplier> All() {
            return GetRepo().GetAll();
        }
        
        public static PagedList<Supplier> GetPaged(string sortBy, int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(sortBy, pageIndex, pageSize);
        }
      
        public static PagedList<Supplier> GetPaged(string sortBy, int pageIndex, int pageSize) {
            return GetRepo().GetPaged(sortBy, pageIndex, pageSize);
        }

        public static PagedList<Supplier> GetPaged(int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(pageIndex, pageSize);
            
        }


        public static PagedList<Supplier> GetPaged(int pageIndex, int pageSize) {
            return GetRepo().GetPaged(pageIndex, pageSize);
            
        }

        public string KeyName()
        {
            return "SupplierID";
        }

        public object KeyValue()
        {
            return this.SupplierID;
        }
        
        public void SetKeyValue(object value) {
            if (value != null && value!=DBNull.Value) {
                var settable = value.ChangeTypeTo<int>();
                this.GetType().GetProperty(this.KeyName()).SetValue(this, settable, null);
            }
        }
        
        public override string ToString(){
            return this.CompanyName.ToString();
        }

        public override bool Equals(object obj){
            if(obj.GetType()==typeof(Supplier)){
                Supplier compare=(Supplier)obj;
                return compare.KeyValue()==this.KeyValue();
            }else{
                return base.Equals(obj);
            }
        }

        public string DescriptorValue()
        {
            return this.CompanyName.ToString();
        }

        public string DescriptorColumn() {
            return "CompanyName";
        }
        public static string GetKeyColumn()
        {
            return "SupplierID";
        }        
        public static string GetDescriptorColumn()
        {
            return "CompanyName";
        }
        
        #region ' Foreign Keys '
        public IQueryable<Product> Products
        {
            get
            {
                
                  var repo=SouthWind.Product.GetRepo();
                  return from items in repo.GetAll()
                       where items.SupplierID == _SupplierID
                       select items;
            }
        }

        #endregion
        

        int _SupplierID;
        public int SupplierID
        {
            get { return _SupplierID; }
            set
            {
                if(_SupplierID!=value){
                    _SupplierID=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="SupplierID");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _CompanyName;
        public string CompanyName
        {
            get { return _CompanyName; }
            set
            {
                if(_CompanyName!=value){
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
        }

        string _ContactName;
        public string ContactName
        {
            get { return _ContactName; }
            set
            {
                if(_ContactName!=value){
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
        }

        string _ContactTitle;
        public string ContactTitle
        {
            get { return _ContactTitle; }
            set
            {
                if(_ContactTitle!=value){
                    _ContactTitle=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="ContactTitle");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _Address;
        public string Address
        {
            get { return _Address; }
            set
            {
                if(_Address!=value){
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
        }

        string _City;
        public string City
        {
            get { return _City; }
            set
            {
                if(_City!=value){
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
        }

        string _Region;
        public string Region
        {
            get { return _Region; }
            set
            {
                if(_Region!=value){
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
        }

        string _PostalCode;
        public string PostalCode
        {
            get { return _PostalCode; }
            set
            {
                if(_PostalCode!=value){
                    _PostalCode=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="PostalCode");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _Country;
        public string Country
        {
            get { return _Country; }
            set
            {
                if(_Country!=value){
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
        }

        string _Phone;
        public string Phone
        {
            get { return _Phone; }
            set
            {
                if(_Phone!=value){
                    _Phone=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="Phone");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _Fax;
        public string Fax
        {
            get { return _Fax; }
            set
            {
                if(_Fax!=value){
                    _Fax=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="Fax");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _HomePage;
        public string HomePage
        {
            get { return _HomePage; }
            set
            {
                if(_HomePage!=value){
                    _HomePage=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="HomePage");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
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

            
            var newKey=_repo.Add(this,provider);
            if(newKey!=KeyValue())
                this.SetKeyValue(newKey);
            
            SetIsNew(false);
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


        public static void Delete(Expression<Func<Supplier, bool>> expression) {
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
                    SetIsNew(false);
                    SetIsLoaded(true);
                } catch {
                    SetIsLoaded(false);
                    throw;
                }
            }else{
                SetIsLoaded(false);
            }

            if (closeReader)
                rdr.Dispose();
        }
        

    } 
    
    
    /// <summary>
    /// A class which represents the Order Details table in the Northwind Database.
    /// </summary>
    public partial class OrderDetail: IActiveRecord
    {
    
        #region Built-in testing
        static IList<OrderDetail> TestItems;
        static TestRepository<OrderDetail> _testRepo;
        

        
        static void SetTestRepo(){
            _testRepo = _testRepo ?? new TestRepository<OrderDetail>(new SouthWind.NorthwindDB());
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
        
        public void SetIsLoaded(bool isLoaded){
            _isLoaded=isLoaded;
            if(isLoaded)
                OnLoaded();
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

        SouthWind.NorthwindDB _db;
        public OrderDetail(string connectionString, string providerName) {

            _db=new SouthWind.NorthwindDB(connectionString, providerName);
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
            SetIsNew(true);
            OnCreated();       

        }
        
        public OrderDetail(){
             _db=new SouthWind.NorthwindDB();
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

            SetIsLoaded(_repo.Load(this,expression));
        }
        
       
        
        internal static IRepository<OrderDetail> GetRepo(string connectionString, string providerName){
            SouthWind.NorthwindDB db;
            if(String.IsNullOrEmpty(connectionString)){
                db=new SouthWind.NorthwindDB();
            }else{
                db=new SouthWind.NorthwindDB(connectionString, providerName);
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
                single.SetIsNew(false);
            }

            return single;
        }      
        
        public static OrderDetail SingleOrDefault(Expression<Func<OrderDetail, bool>> expression,string connectionString, string providerName) {
            var repo = GetRepo(connectionString,providerName);
            var results=repo.Find(expression);
            OrderDetail single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
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
            return this.ProductID.ToString();
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
            return this.ProductID.ToString();
        }

        public string DescriptorColumn() {
            return "ProductID";
        }
        public static string GetKeyColumn()
        {
            return "OrderID";
        }        
        public static string GetDescriptorColumn()
        {
            return "ProductID";
        }
        
        #region ' Foreign Keys '
        public IQueryable<Order> Orders
        {
            get
            {
                
                  var repo=SouthWind.Order.GetRepo();
                  return from items in repo.GetAll()
                       where items.OrderID == _OrderID
                       select items;
            }
        }

        public IQueryable<Product> Products
        {
            get
            {
                
                  var repo=SouthWind.Product.GetRepo();
                  return from items in repo.GetAll()
                       where items.ProductID == _ProductID
                       select items;
            }
        }

        #endregion
        

        int _OrderID;
        public int OrderID
        {
            get { return _OrderID; }
            set
            {
                if(_OrderID!=value){
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
        }

        int _ProductID;
        public int ProductID
        {
            get { return _ProductID; }
            set
            {
                if(_ProductID!=value){
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
        }

        decimal _UnitPrice;
        public decimal UnitPrice
        {
            get { return _UnitPrice; }
            set
            {
                if(_UnitPrice!=value){
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
        }

        short _Quantity;
        public short Quantity
        {
            get { return _Quantity; }
            set
            {
                if(_Quantity!=value){
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
        }

        decimal _Discount;
        public decimal Discount
        {
            get { return _Discount; }
            set
            {
                if(_Discount!=value){
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

            
            var newKey=_repo.Add(this,provider);
            if(newKey!=KeyValue())
                this.SetKeyValue(newKey);
            
            SetIsNew(false);
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
                    SetIsNew(false);
                    SetIsLoaded(true);
                } catch {
                    SetIsLoaded(false);
                    throw;
                }
            }else{
                SetIsLoaded(false);
            }

            if (closeReader)
                rdr.Dispose();
        }
        

    } 
    
    
    /// <summary>
    /// A class which represents the CustomerCustomerDemo table in the Northwind Database.
    /// </summary>
    public partial class CustomerCustomerDemo: IActiveRecord
    {
    
        #region Built-in testing
        static IList<CustomerCustomerDemo> TestItems;
        static TestRepository<CustomerCustomerDemo> _testRepo;
        

        
        static void SetTestRepo(){
            _testRepo = _testRepo ?? new TestRepository<CustomerCustomerDemo>(new SouthWind.NorthwindDB());
        }
        public static void ResetTestRepo(){
            _testRepo = null;
            SetTestRepo();
        }
        public static void Setup(List<CustomerCustomerDemo> testlist){
            SetTestRepo();
            _testRepo._items = testlist;
        }
        public static void Setup(CustomerCustomerDemo item) {
            SetTestRepo();
            _testRepo._items.Add(item);
        }
        public static void Setup(int testItems) {
            SetTestRepo();
            for(int i=0;i<testItems;i++){
                CustomerCustomerDemo item=new CustomerCustomerDemo();
                _testRepo._items.Add(item);
            }
        }
        
        public bool TestMode = false;


        #endregion

        IRepository<CustomerCustomerDemo> _repo;
        ITable tbl;
        bool _isNew;
        public bool IsNew(){
            return _isNew;
        }
        
        public void SetIsLoaded(bool isLoaded){
            _isLoaded=isLoaded;
            if(isLoaded)
                OnLoaded();
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

        SouthWind.NorthwindDB _db;
        public CustomerCustomerDemo(string connectionString, string providerName) {

            _db=new SouthWind.NorthwindDB(connectionString, providerName);
            Init();            
         }
        void Init(){
            TestMode=this._db.DataProvider.ConnectionString.Equals("test", StringComparison.InvariantCultureIgnoreCase);
            _dirtyColumns=new List<IColumn>();
            if(TestMode){
                CustomerCustomerDemo.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<CustomerCustomerDemo>(_db);
            }
            tbl=_repo.GetTable();
            SetIsNew(true);
            OnCreated();       

        }
        
        public CustomerCustomerDemo(){
             _db=new SouthWind.NorthwindDB();
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

        public CustomerCustomerDemo(Expression<Func<CustomerCustomerDemo, bool>> expression):this() {

            SetIsLoaded(_repo.Load(this,expression));
        }
        
       
        
        internal static IRepository<CustomerCustomerDemo> GetRepo(string connectionString, string providerName){
            SouthWind.NorthwindDB db;
            if(String.IsNullOrEmpty(connectionString)){
                db=new SouthWind.NorthwindDB();
            }else{
                db=new SouthWind.NorthwindDB(connectionString, providerName);
            }
            IRepository<CustomerCustomerDemo> _repo;
            
            if(db.TestMode){
                CustomerCustomerDemo.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<CustomerCustomerDemo>(db);
            }
            return _repo;        
        }       
        
        internal static IRepository<CustomerCustomerDemo> GetRepo(){
            return GetRepo("","");
        }
        
        public static CustomerCustomerDemo SingleOrDefault(Expression<Func<CustomerCustomerDemo, bool>> expression) {

            var repo = GetRepo();
            var results=repo.Find(expression);
            CustomerCustomerDemo single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
                single.OnLoaded();
                single.SetIsLoaded(true);
                single.SetIsNew(false);
            }

            return single;
        }      
        
        public static CustomerCustomerDemo SingleOrDefault(Expression<Func<CustomerCustomerDemo, bool>> expression,string connectionString, string providerName) {
            var repo = GetRepo(connectionString,providerName);
            var results=repo.Find(expression);
            CustomerCustomerDemo single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
            }

            return single;


        }
        
        
        public static bool Exists(Expression<Func<CustomerCustomerDemo, bool>> expression,string connectionString, string providerName) {
           
            return All(connectionString,providerName).Any(expression);
        }        
        public static bool Exists(Expression<Func<CustomerCustomerDemo, bool>> expression) {
           
            return All().Any(expression);
        }        

        public static IList<CustomerCustomerDemo> Find(Expression<Func<CustomerCustomerDemo, bool>> expression) {
            
            var repo = GetRepo();
            return repo.Find(expression).ToList();
        }
        
        public static IList<CustomerCustomerDemo> Find(Expression<Func<CustomerCustomerDemo, bool>> expression,string connectionString, string providerName) {

            var repo = GetRepo(connectionString,providerName);
            return repo.Find(expression).ToList();

        }
        public static IQueryable<CustomerCustomerDemo> All(string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetAll();
        }
        public static IQueryable<CustomerCustomerDemo> All() {
            return GetRepo().GetAll();
        }
        
        public static PagedList<CustomerCustomerDemo> GetPaged(string sortBy, int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(sortBy, pageIndex, pageSize);
        }
      
        public static PagedList<CustomerCustomerDemo> GetPaged(string sortBy, int pageIndex, int pageSize) {
            return GetRepo().GetPaged(sortBy, pageIndex, pageSize);
        }

        public static PagedList<CustomerCustomerDemo> GetPaged(int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(pageIndex, pageSize);
            
        }


        public static PagedList<CustomerCustomerDemo> GetPaged(int pageIndex, int pageSize) {
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
            if(obj.GetType()==typeof(CustomerCustomerDemo)){
                CustomerCustomerDemo compare=(CustomerCustomerDemo)obj;
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
        public IQueryable<CustomerDemographic> CustomerDemographics
        {
            get
            {
                
                  var repo=SouthWind.CustomerDemographic.GetRepo();
                  return from items in repo.GetAll()
                       where items.CustomerTypeID == _CustomerTypeID
                       select items;
            }
        }

        public IQueryable<Customer> Customers
        {
            get
            {
                
                  var repo=SouthWind.Customer.GetRepo();
                  return from items in repo.GetAll()
                       where items.CustomerID == _CustomerID
                       select items;
            }
        }

        #endregion
        

        string _CustomerID;
        public string CustomerID
        {
            get { return _CustomerID; }
            set
            {
                if(_CustomerID!=value){
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
        }

        string _CustomerTypeID;
        public string CustomerTypeID
        {
            get { return _CustomerTypeID; }
            set
            {
                if(_CustomerTypeID!=value){
                    _CustomerTypeID=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="CustomerTypeID");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
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

            
            var newKey=_repo.Add(this,provider);
            if(newKey!=KeyValue())
                this.SetKeyValue(newKey);
            
            SetIsNew(false);
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


        public static void Delete(Expression<Func<CustomerCustomerDemo, bool>> expression) {
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
                    SetIsNew(false);
                    SetIsLoaded(true);
                } catch {
                    SetIsLoaded(false);
                    throw;
                }
            }else{
                SetIsLoaded(false);
            }

            if (closeReader)
                rdr.Dispose();
        }
        

    } 
    
    
    /// <summary>
    /// A class which represents the CustomerDemographics table in the Northwind Database.
    /// </summary>
    public partial class CustomerDemographic: IActiveRecord
    {
    
        #region Built-in testing
        static IList<CustomerDemographic> TestItems;
        static TestRepository<CustomerDemographic> _testRepo;
        

        
        static void SetTestRepo(){
            _testRepo = _testRepo ?? new TestRepository<CustomerDemographic>(new SouthWind.NorthwindDB());
        }
        public static void ResetTestRepo(){
            _testRepo = null;
            SetTestRepo();
        }
        public static void Setup(List<CustomerDemographic> testlist){
            SetTestRepo();
            _testRepo._items = testlist;
        }
        public static void Setup(CustomerDemographic item) {
            SetTestRepo();
            _testRepo._items.Add(item);
        }
        public static void Setup(int testItems) {
            SetTestRepo();
            for(int i=0;i<testItems;i++){
                CustomerDemographic item=new CustomerDemographic();
                _testRepo._items.Add(item);
            }
        }
        
        public bool TestMode = false;


        #endregion

        IRepository<CustomerDemographic> _repo;
        ITable tbl;
        bool _isNew;
        public bool IsNew(){
            return _isNew;
        }
        
        public void SetIsLoaded(bool isLoaded){
            _isLoaded=isLoaded;
            if(isLoaded)
                OnLoaded();
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

        SouthWind.NorthwindDB _db;
        public CustomerDemographic(string connectionString, string providerName) {

            _db=new SouthWind.NorthwindDB(connectionString, providerName);
            Init();            
         }
        void Init(){
            TestMode=this._db.DataProvider.ConnectionString.Equals("test", StringComparison.InvariantCultureIgnoreCase);
            _dirtyColumns=new List<IColumn>();
            if(TestMode){
                CustomerDemographic.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<CustomerDemographic>(_db);
            }
            tbl=_repo.GetTable();
            SetIsNew(true);
            OnCreated();       

        }
        
        public CustomerDemographic(){
             _db=new SouthWind.NorthwindDB();
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

        public CustomerDemographic(Expression<Func<CustomerDemographic, bool>> expression):this() {

            SetIsLoaded(_repo.Load(this,expression));
        }
        
       
        
        internal static IRepository<CustomerDemographic> GetRepo(string connectionString, string providerName){
            SouthWind.NorthwindDB db;
            if(String.IsNullOrEmpty(connectionString)){
                db=new SouthWind.NorthwindDB();
            }else{
                db=new SouthWind.NorthwindDB(connectionString, providerName);
            }
            IRepository<CustomerDemographic> _repo;
            
            if(db.TestMode){
                CustomerDemographic.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<CustomerDemographic>(db);
            }
            return _repo;        
        }       
        
        internal static IRepository<CustomerDemographic> GetRepo(){
            return GetRepo("","");
        }
        
        public static CustomerDemographic SingleOrDefault(Expression<Func<CustomerDemographic, bool>> expression) {

            var repo = GetRepo();
            var results=repo.Find(expression);
            CustomerDemographic single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
                single.OnLoaded();
                single.SetIsLoaded(true);
                single.SetIsNew(false);
            }

            return single;
        }      
        
        public static CustomerDemographic SingleOrDefault(Expression<Func<CustomerDemographic, bool>> expression,string connectionString, string providerName) {
            var repo = GetRepo(connectionString,providerName);
            var results=repo.Find(expression);
            CustomerDemographic single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
            }

            return single;


        }
        
        
        public static bool Exists(Expression<Func<CustomerDemographic, bool>> expression,string connectionString, string providerName) {
           
            return All(connectionString,providerName).Any(expression);
        }        
        public static bool Exists(Expression<Func<CustomerDemographic, bool>> expression) {
           
            return All().Any(expression);
        }        

        public static IList<CustomerDemographic> Find(Expression<Func<CustomerDemographic, bool>> expression) {
            
            var repo = GetRepo();
            return repo.Find(expression).ToList();
        }
        
        public static IList<CustomerDemographic> Find(Expression<Func<CustomerDemographic, bool>> expression,string connectionString, string providerName) {

            var repo = GetRepo(connectionString,providerName);
            return repo.Find(expression).ToList();

        }
        public static IQueryable<CustomerDemographic> All(string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetAll();
        }
        public static IQueryable<CustomerDemographic> All() {
            return GetRepo().GetAll();
        }
        
        public static PagedList<CustomerDemographic> GetPaged(string sortBy, int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(sortBy, pageIndex, pageSize);
        }
      
        public static PagedList<CustomerDemographic> GetPaged(string sortBy, int pageIndex, int pageSize) {
            return GetRepo().GetPaged(sortBy, pageIndex, pageSize);
        }

        public static PagedList<CustomerDemographic> GetPaged(int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(pageIndex, pageSize);
            
        }


        public static PagedList<CustomerDemographic> GetPaged(int pageIndex, int pageSize) {
            return GetRepo().GetPaged(pageIndex, pageSize);
            
        }

        public string KeyName()
        {
            return "CustomerTypeID";
        }

        public object KeyValue()
        {
            return this.CustomerTypeID;
        }
        
        public void SetKeyValue(object value) {
            if (value != null && value!=DBNull.Value) {
                var settable = value.ChangeTypeTo<string>();
                this.GetType().GetProperty(this.KeyName()).SetValue(this, settable, null);
            }
        }
        
        public override string ToString(){
            return this.CustomerTypeID.ToString();
        }

        public override bool Equals(object obj){
            if(obj.GetType()==typeof(CustomerDemographic)){
                CustomerDemographic compare=(CustomerDemographic)obj;
                return compare.KeyValue()==this.KeyValue();
            }else{
                return base.Equals(obj);
            }
        }

        public string DescriptorValue()
        {
            return this.CustomerTypeID.ToString();
        }

        public string DescriptorColumn() {
            return "CustomerTypeID";
        }
        public static string GetKeyColumn()
        {
            return "CustomerTypeID";
        }        
        public static string GetDescriptorColumn()
        {
            return "CustomerTypeID";
        }
        
        #region ' Foreign Keys '
        public IQueryable<CustomerCustomerDemo> CustomerCustomerDemos
        {
            get
            {
                
                  var repo=SouthWind.CustomerCustomerDemo.GetRepo();
                  return from items in repo.GetAll()
                       where items.CustomerTypeID == _CustomerTypeID
                       select items;
            }
        }

        #endregion
        

        string _CustomerTypeID;
        public string CustomerTypeID
        {
            get { return _CustomerTypeID; }
            set
            {
                if(_CustomerTypeID!=value){
                    _CustomerTypeID=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="CustomerTypeID");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _CustomerDesc;
        public string CustomerDesc
        {
            get { return _CustomerDesc; }
            set
            {
                if(_CustomerDesc!=value){
                    _CustomerDesc=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="CustomerDesc");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
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

            
            var newKey=_repo.Add(this,provider);
            if(newKey!=KeyValue())
                this.SetKeyValue(newKey);
            
            SetIsNew(false);
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


        public static void Delete(Expression<Func<CustomerDemographic, bool>> expression) {
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
                    SetIsNew(false);
                    SetIsLoaded(true);
                } catch {
                    SetIsLoaded(false);
                    throw;
                }
            }else{
                SetIsLoaded(false);
            }

            if (closeReader)
                rdr.Dispose();
        }
        

    } 
    
    
    /// <summary>
    /// A class which represents the Region table in the Northwind Database.
    /// </summary>
    public partial class Region: IActiveRecord
    {
    
        #region Built-in testing
        static IList<Region> TestItems;
        static TestRepository<Region> _testRepo;
        

        
        static void SetTestRepo(){
            _testRepo = _testRepo ?? new TestRepository<Region>(new SouthWind.NorthwindDB());
        }
        public static void ResetTestRepo(){
            _testRepo = null;
            SetTestRepo();
        }
        public static void Setup(List<Region> testlist){
            SetTestRepo();
            _testRepo._items = testlist;
        }
        public static void Setup(Region item) {
            SetTestRepo();
            _testRepo._items.Add(item);
        }
        public static void Setup(int testItems) {
            SetTestRepo();
            for(int i=0;i<testItems;i++){
                Region item=new Region();
                _testRepo._items.Add(item);
            }
        }
        
        public bool TestMode = false;


        #endregion

        IRepository<Region> _repo;
        ITable tbl;
        bool _isNew;
        public bool IsNew(){
            return _isNew;
        }
        
        public void SetIsLoaded(bool isLoaded){
            _isLoaded=isLoaded;
            if(isLoaded)
                OnLoaded();
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

        SouthWind.NorthwindDB _db;
        public Region(string connectionString, string providerName) {

            _db=new SouthWind.NorthwindDB(connectionString, providerName);
            Init();            
         }
        void Init(){
            TestMode=this._db.DataProvider.ConnectionString.Equals("test", StringComparison.InvariantCultureIgnoreCase);
            _dirtyColumns=new List<IColumn>();
            if(TestMode){
                Region.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<Region>(_db);
            }
            tbl=_repo.GetTable();
            SetIsNew(true);
            OnCreated();       

        }
        
        public Region(){
             _db=new SouthWind.NorthwindDB();
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

        public Region(Expression<Func<Region, bool>> expression):this() {

            SetIsLoaded(_repo.Load(this,expression));
        }
        
       
        
        internal static IRepository<Region> GetRepo(string connectionString, string providerName){
            SouthWind.NorthwindDB db;
            if(String.IsNullOrEmpty(connectionString)){
                db=new SouthWind.NorthwindDB();
            }else{
                db=new SouthWind.NorthwindDB(connectionString, providerName);
            }
            IRepository<Region> _repo;
            
            if(db.TestMode){
                Region.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<Region>(db);
            }
            return _repo;        
        }       
        
        internal static IRepository<Region> GetRepo(){
            return GetRepo("","");
        }
        
        public static Region SingleOrDefault(Expression<Func<Region, bool>> expression) {

            var repo = GetRepo();
            var results=repo.Find(expression);
            Region single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
                single.OnLoaded();
                single.SetIsLoaded(true);
                single.SetIsNew(false);
            }

            return single;
        }      
        
        public static Region SingleOrDefault(Expression<Func<Region, bool>> expression,string connectionString, string providerName) {
            var repo = GetRepo(connectionString,providerName);
            var results=repo.Find(expression);
            Region single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
            }

            return single;


        }
        
        
        public static bool Exists(Expression<Func<Region, bool>> expression,string connectionString, string providerName) {
           
            return All(connectionString,providerName).Any(expression);
        }        
        public static bool Exists(Expression<Func<Region, bool>> expression) {
           
            return All().Any(expression);
        }        

        public static IList<Region> Find(Expression<Func<Region, bool>> expression) {
            
            var repo = GetRepo();
            return repo.Find(expression).ToList();
        }
        
        public static IList<Region> Find(Expression<Func<Region, bool>> expression,string connectionString, string providerName) {

            var repo = GetRepo(connectionString,providerName);
            return repo.Find(expression).ToList();

        }
        public static IQueryable<Region> All(string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetAll();
        }
        public static IQueryable<Region> All() {
            return GetRepo().GetAll();
        }
        
        public static PagedList<Region> GetPaged(string sortBy, int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(sortBy, pageIndex, pageSize);
        }
      
        public static PagedList<Region> GetPaged(string sortBy, int pageIndex, int pageSize) {
            return GetRepo().GetPaged(sortBy, pageIndex, pageSize);
        }

        public static PagedList<Region> GetPaged(int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(pageIndex, pageSize);
            
        }


        public static PagedList<Region> GetPaged(int pageIndex, int pageSize) {
            return GetRepo().GetPaged(pageIndex, pageSize);
            
        }

        public string KeyName()
        {
            return "RegionID";
        }

        public object KeyValue()
        {
            return this.RegionID;
        }
        
        public void SetKeyValue(object value) {
            if (value != null && value!=DBNull.Value) {
                var settable = value.ChangeTypeTo<int>();
                this.GetType().GetProperty(this.KeyName()).SetValue(this, settable, null);
            }
        }
        
        public override string ToString(){
            return this.RegionDescription.ToString();
        }

        public override bool Equals(object obj){
            if(obj.GetType()==typeof(Region)){
                Region compare=(Region)obj;
                return compare.KeyValue()==this.KeyValue();
            }else{
                return base.Equals(obj);
            }
        }

        public string DescriptorValue()
        {
            return this.RegionDescription.ToString();
        }

        public string DescriptorColumn() {
            return "RegionDescription";
        }
        public static string GetKeyColumn()
        {
            return "RegionID";
        }        
        public static string GetDescriptorColumn()
        {
            return "RegionDescription";
        }
        
        #region ' Foreign Keys '
        public IQueryable<Territory> Territories
        {
            get
            {
                
                  var repo=SouthWind.Territory.GetRepo();
                  return from items in repo.GetAll()
                       where items.RegionID == _RegionID
                       select items;
            }
        }

        #endregion
        

        int _RegionID;
        public int RegionID
        {
            get { return _RegionID; }
            set
            {
                if(_RegionID!=value){
                    _RegionID=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="RegionID");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _RegionDescription;
        public string RegionDescription
        {
            get { return _RegionDescription; }
            set
            {
                if(_RegionDescription!=value){
                    _RegionDescription=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="RegionDescription");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
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

            
            var newKey=_repo.Add(this,provider);
            if(newKey!=KeyValue())
                this.SetKeyValue(newKey);
            
            SetIsNew(false);
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


        public static void Delete(Expression<Func<Region, bool>> expression) {
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
                    SetIsNew(false);
                    SetIsLoaded(true);
                } catch {
                    SetIsLoaded(false);
                    throw;
                }
            }else{
                SetIsLoaded(false);
            }

            if (closeReader)
                rdr.Dispose();
        }
        

    } 
    
    
    /// <summary>
    /// A class which represents the Territories table in the Northwind Database.
    /// </summary>
    public partial class Territory: IActiveRecord
    {
    
        #region Built-in testing
        static IList<Territory> TestItems;
        static TestRepository<Territory> _testRepo;
        

        
        static void SetTestRepo(){
            _testRepo = _testRepo ?? new TestRepository<Territory>(new SouthWind.NorthwindDB());
        }
        public static void ResetTestRepo(){
            _testRepo = null;
            SetTestRepo();
        }
        public static void Setup(List<Territory> testlist){
            SetTestRepo();
            _testRepo._items = testlist;
        }
        public static void Setup(Territory item) {
            SetTestRepo();
            _testRepo._items.Add(item);
        }
        public static void Setup(int testItems) {
            SetTestRepo();
            for(int i=0;i<testItems;i++){
                Territory item=new Territory();
                _testRepo._items.Add(item);
            }
        }
        
        public bool TestMode = false;


        #endregion

        IRepository<Territory> _repo;
        ITable tbl;
        bool _isNew;
        public bool IsNew(){
            return _isNew;
        }
        
        public void SetIsLoaded(bool isLoaded){
            _isLoaded=isLoaded;
            if(isLoaded)
                OnLoaded();
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

        SouthWind.NorthwindDB _db;
        public Territory(string connectionString, string providerName) {

            _db=new SouthWind.NorthwindDB(connectionString, providerName);
            Init();            
         }
        void Init(){
            TestMode=this._db.DataProvider.ConnectionString.Equals("test", StringComparison.InvariantCultureIgnoreCase);
            _dirtyColumns=new List<IColumn>();
            if(TestMode){
                Territory.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<Territory>(_db);
            }
            tbl=_repo.GetTable();
            SetIsNew(true);
            OnCreated();       

        }
        
        public Territory(){
             _db=new SouthWind.NorthwindDB();
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

        public Territory(Expression<Func<Territory, bool>> expression):this() {

            SetIsLoaded(_repo.Load(this,expression));
        }
        
       
        
        internal static IRepository<Territory> GetRepo(string connectionString, string providerName){
            SouthWind.NorthwindDB db;
            if(String.IsNullOrEmpty(connectionString)){
                db=new SouthWind.NorthwindDB();
            }else{
                db=new SouthWind.NorthwindDB(connectionString, providerName);
            }
            IRepository<Territory> _repo;
            
            if(db.TestMode){
                Territory.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<Territory>(db);
            }
            return _repo;        
        }       
        
        internal static IRepository<Territory> GetRepo(){
            return GetRepo("","");
        }
        
        public static Territory SingleOrDefault(Expression<Func<Territory, bool>> expression) {

            var repo = GetRepo();
            var results=repo.Find(expression);
            Territory single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
                single.OnLoaded();
                single.SetIsLoaded(true);
                single.SetIsNew(false);
            }

            return single;
        }      
        
        public static Territory SingleOrDefault(Expression<Func<Territory, bool>> expression,string connectionString, string providerName) {
            var repo = GetRepo(connectionString,providerName);
            var results=repo.Find(expression);
            Territory single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
            }

            return single;


        }
        
        
        public static bool Exists(Expression<Func<Territory, bool>> expression,string connectionString, string providerName) {
           
            return All(connectionString,providerName).Any(expression);
        }        
        public static bool Exists(Expression<Func<Territory, bool>> expression) {
           
            return All().Any(expression);
        }        

        public static IList<Territory> Find(Expression<Func<Territory, bool>> expression) {
            
            var repo = GetRepo();
            return repo.Find(expression).ToList();
        }
        
        public static IList<Territory> Find(Expression<Func<Territory, bool>> expression,string connectionString, string providerName) {

            var repo = GetRepo(connectionString,providerName);
            return repo.Find(expression).ToList();

        }
        public static IQueryable<Territory> All(string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetAll();
        }
        public static IQueryable<Territory> All() {
            return GetRepo().GetAll();
        }
        
        public static PagedList<Territory> GetPaged(string sortBy, int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(sortBy, pageIndex, pageSize);
        }
      
        public static PagedList<Territory> GetPaged(string sortBy, int pageIndex, int pageSize) {
            return GetRepo().GetPaged(sortBy, pageIndex, pageSize);
        }

        public static PagedList<Territory> GetPaged(int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(pageIndex, pageSize);
            
        }


        public static PagedList<Territory> GetPaged(int pageIndex, int pageSize) {
            return GetRepo().GetPaged(pageIndex, pageSize);
            
        }

        public string KeyName()
        {
            return "TerritoryID";
        }

        public object KeyValue()
        {
            return this.TerritoryID;
        }
        
        public void SetKeyValue(object value) {
            if (value != null && value!=DBNull.Value) {
                var settable = value.ChangeTypeTo<string>();
                this.GetType().GetProperty(this.KeyName()).SetValue(this, settable, null);
            }
        }
        
        public override string ToString(){
            return this.TerritoryID.ToString();
        }

        public override bool Equals(object obj){
            if(obj.GetType()==typeof(Territory)){
                Territory compare=(Territory)obj;
                return compare.KeyValue()==this.KeyValue();
            }else{
                return base.Equals(obj);
            }
        }

        public string DescriptorValue()
        {
            return this.TerritoryID.ToString();
        }

        public string DescriptorColumn() {
            return "TerritoryID";
        }
        public static string GetKeyColumn()
        {
            return "TerritoryID";
        }        
        public static string GetDescriptorColumn()
        {
            return "TerritoryID";
        }
        
        #region ' Foreign Keys '
        public IQueryable<Region> Regions
        {
            get
            {
                
                  var repo=SouthWind.Region.GetRepo();
                  return from items in repo.GetAll()
                       where items.RegionID == _RegionID
                       select items;
            }
        }

        public IQueryable<EmployeeTerritory> EmployeeTerritories
        {
            get
            {
                
                  var repo=SouthWind.EmployeeTerritory.GetRepo();
                  return from items in repo.GetAll()
                       where items.TerritoryID == _TerritoryID
                       select items;
            }
        }

        #endregion
        

        string _TerritoryID;
        public string TerritoryID
        {
            get { return _TerritoryID; }
            set
            {
                if(_TerritoryID!=value){
                    _TerritoryID=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="TerritoryID");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _TerritoryDescription;
        public string TerritoryDescription
        {
            get { return _TerritoryDescription; }
            set
            {
                if(_TerritoryDescription!=value){
                    _TerritoryDescription=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="TerritoryDescription");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        int _RegionID;
        public int RegionID
        {
            get { return _RegionID; }
            set
            {
                if(_RegionID!=value){
                    _RegionID=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="RegionID");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
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

            
            var newKey=_repo.Add(this,provider);
            if(newKey!=KeyValue())
                this.SetKeyValue(newKey);
            
            SetIsNew(false);
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


        public static void Delete(Expression<Func<Territory, bool>> expression) {
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
                    SetIsNew(false);
                    SetIsLoaded(true);
                } catch {
                    SetIsLoaded(false);
                    throw;
                }
            }else{
                SetIsLoaded(false);
            }

            if (closeReader)
                rdr.Dispose();
        }
        

    } 
    
    
    /// <summary>
    /// A class which represents the EmployeeTerritories table in the Northwind Database.
    /// </summary>
    public partial class EmployeeTerritory: IActiveRecord
    {
    
        #region Built-in testing
        static IList<EmployeeTerritory> TestItems;
        static TestRepository<EmployeeTerritory> _testRepo;
        

        
        static void SetTestRepo(){
            _testRepo = _testRepo ?? new TestRepository<EmployeeTerritory>(new SouthWind.NorthwindDB());
        }
        public static void ResetTestRepo(){
            _testRepo = null;
            SetTestRepo();
        }
        public static void Setup(List<EmployeeTerritory> testlist){
            SetTestRepo();
            _testRepo._items = testlist;
        }
        public static void Setup(EmployeeTerritory item) {
            SetTestRepo();
            _testRepo._items.Add(item);
        }
        public static void Setup(int testItems) {
            SetTestRepo();
            for(int i=0;i<testItems;i++){
                EmployeeTerritory item=new EmployeeTerritory();
                _testRepo._items.Add(item);
            }
        }
        
        public bool TestMode = false;


        #endregion

        IRepository<EmployeeTerritory> _repo;
        ITable tbl;
        bool _isNew;
        public bool IsNew(){
            return _isNew;
        }
        
        public void SetIsLoaded(bool isLoaded){
            _isLoaded=isLoaded;
            if(isLoaded)
                OnLoaded();
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

        SouthWind.NorthwindDB _db;
        public EmployeeTerritory(string connectionString, string providerName) {

            _db=new SouthWind.NorthwindDB(connectionString, providerName);
            Init();            
         }
        void Init(){
            TestMode=this._db.DataProvider.ConnectionString.Equals("test", StringComparison.InvariantCultureIgnoreCase);
            _dirtyColumns=new List<IColumn>();
            if(TestMode){
                EmployeeTerritory.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<EmployeeTerritory>(_db);
            }
            tbl=_repo.GetTable();
            SetIsNew(true);
            OnCreated();       

        }
        
        public EmployeeTerritory(){
             _db=new SouthWind.NorthwindDB();
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

        public EmployeeTerritory(Expression<Func<EmployeeTerritory, bool>> expression):this() {

            SetIsLoaded(_repo.Load(this,expression));
        }
        
       
        
        internal static IRepository<EmployeeTerritory> GetRepo(string connectionString, string providerName){
            SouthWind.NorthwindDB db;
            if(String.IsNullOrEmpty(connectionString)){
                db=new SouthWind.NorthwindDB();
            }else{
                db=new SouthWind.NorthwindDB(connectionString, providerName);
            }
            IRepository<EmployeeTerritory> _repo;
            
            if(db.TestMode){
                EmployeeTerritory.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<EmployeeTerritory>(db);
            }
            return _repo;        
        }       
        
        internal static IRepository<EmployeeTerritory> GetRepo(){
            return GetRepo("","");
        }
        
        public static EmployeeTerritory SingleOrDefault(Expression<Func<EmployeeTerritory, bool>> expression) {

            var repo = GetRepo();
            var results=repo.Find(expression);
            EmployeeTerritory single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
                single.OnLoaded();
                single.SetIsLoaded(true);
                single.SetIsNew(false);
            }

            return single;
        }      
        
        public static EmployeeTerritory SingleOrDefault(Expression<Func<EmployeeTerritory, bool>> expression,string connectionString, string providerName) {
            var repo = GetRepo(connectionString,providerName);
            var results=repo.Find(expression);
            EmployeeTerritory single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
            }

            return single;


        }
        
        
        public static bool Exists(Expression<Func<EmployeeTerritory, bool>> expression,string connectionString, string providerName) {
           
            return All(connectionString,providerName).Any(expression);
        }        
        public static bool Exists(Expression<Func<EmployeeTerritory, bool>> expression) {
           
            return All().Any(expression);
        }        

        public static IList<EmployeeTerritory> Find(Expression<Func<EmployeeTerritory, bool>> expression) {
            
            var repo = GetRepo();
            return repo.Find(expression).ToList();
        }
        
        public static IList<EmployeeTerritory> Find(Expression<Func<EmployeeTerritory, bool>> expression,string connectionString, string providerName) {

            var repo = GetRepo(connectionString,providerName);
            return repo.Find(expression).ToList();

        }
        public static IQueryable<EmployeeTerritory> All(string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetAll();
        }
        public static IQueryable<EmployeeTerritory> All() {
            return GetRepo().GetAll();
        }
        
        public static PagedList<EmployeeTerritory> GetPaged(string sortBy, int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(sortBy, pageIndex, pageSize);
        }
      
        public static PagedList<EmployeeTerritory> GetPaged(string sortBy, int pageIndex, int pageSize) {
            return GetRepo().GetPaged(sortBy, pageIndex, pageSize);
        }

        public static PagedList<EmployeeTerritory> GetPaged(int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(pageIndex, pageSize);
            
        }


        public static PagedList<EmployeeTerritory> GetPaged(int pageIndex, int pageSize) {
            return GetRepo().GetPaged(pageIndex, pageSize);
            
        }

        public string KeyName()
        {
            return "EmployeeID";
        }

        public object KeyValue()
        {
            return this.EmployeeID;
        }
        
        public void SetKeyValue(object value) {
            if (value != null && value!=DBNull.Value) {
                var settable = value.ChangeTypeTo<int>();
                this.GetType().GetProperty(this.KeyName()).SetValue(this, settable, null);
            }
        }
        
        public override string ToString(){
            return this.TerritoryID.ToString();
        }

        public override bool Equals(object obj){
            if(obj.GetType()==typeof(EmployeeTerritory)){
                EmployeeTerritory compare=(EmployeeTerritory)obj;
                return compare.KeyValue()==this.KeyValue();
            }else{
                return base.Equals(obj);
            }
        }

        public string DescriptorValue()
        {
            return this.TerritoryID.ToString();
        }

        public string DescriptorColumn() {
            return "TerritoryID";
        }
        public static string GetKeyColumn()
        {
            return "EmployeeID";
        }        
        public static string GetDescriptorColumn()
        {
            return "TerritoryID";
        }
        
        #region ' Foreign Keys '
        public IQueryable<Employee> Employees
        {
            get
            {
                
                  var repo=SouthWind.Employee.GetRepo();
                  return from items in repo.GetAll()
                       where items.EmployeeID == _EmployeeID
                       select items;
            }
        }

        public IQueryable<Territory> Territories
        {
            get
            {
                
                  var repo=SouthWind.Territory.GetRepo();
                  return from items in repo.GetAll()
                       where items.TerritoryID == _TerritoryID
                       select items;
            }
        }

        #endregion
        

        int _EmployeeID;
        public int EmployeeID
        {
            get { return _EmployeeID; }
            set
            {
                if(_EmployeeID!=value){
                    _EmployeeID=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="EmployeeID");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _TerritoryID;
        public string TerritoryID
        {
            get { return _TerritoryID; }
            set
            {
                if(_TerritoryID!=value){
                    _TerritoryID=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="TerritoryID");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
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

            
            var newKey=_repo.Add(this,provider);
            if(newKey!=KeyValue())
                this.SetKeyValue(newKey);
            
            SetIsNew(false);
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


        public static void Delete(Expression<Func<EmployeeTerritory, bool>> expression) {
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
                    SetIsNew(false);
                    SetIsLoaded(true);
                } catch {
                    SetIsLoaded(false);
                    throw;
                }
            }else{
                SetIsLoaded(false);
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
        

        
        static void SetTestRepo(){
            _testRepo = _testRepo ?? new TestRepository<Order>(new SouthWind.NorthwindDB());
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
        
        public void SetIsLoaded(bool isLoaded){
            _isLoaded=isLoaded;
            if(isLoaded)
                OnLoaded();
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

        SouthWind.NorthwindDB _db;
        public Order(string connectionString, string providerName) {

            _db=new SouthWind.NorthwindDB(connectionString, providerName);
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
            SetIsNew(true);
            OnCreated();       

        }
        
        public Order(){
             _db=new SouthWind.NorthwindDB();
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

            SetIsLoaded(_repo.Load(this,expression));
        }
        
       
        
        internal static IRepository<Order> GetRepo(string connectionString, string providerName){
            SouthWind.NorthwindDB db;
            if(String.IsNullOrEmpty(connectionString)){
                db=new SouthWind.NorthwindDB();
            }else{
                db=new SouthWind.NorthwindDB(connectionString, providerName);
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
                single.SetIsNew(false);
            }

            return single;
        }      
        
        public static Order SingleOrDefault(Expression<Func<Order, bool>> expression,string connectionString, string providerName) {
            var repo = GetRepo(connectionString,providerName);
            var results=repo.Find(expression);
            Order single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
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
        public IQueryable<Customer> Customers
        {
            get
            {
                
                  var repo=SouthWind.Customer.GetRepo();
                  return from items in repo.GetAll()
                       where items.CustomerID == _CustomerID
                       select items;
            }
        }

        public IQueryable<Employee> Employees
        {
            get
            {
                
                  var repo=SouthWind.Employee.GetRepo();
                  return from items in repo.GetAll()
                       where items.EmployeeID == _EmployeeID
                       select items;
            }
        }

        public IQueryable<OrderDetail> OrderDetails
        {
            get
            {
                
                  var repo=SouthWind.OrderDetail.GetRepo();
                  return from items in repo.GetAll()
                       where items.OrderID == _OrderID
                       select items;
            }
        }

        public IQueryable<Shipper> Shippers
        {
            get
            {
                
                  var repo=SouthWind.Shipper.GetRepo();
                  return from items in repo.GetAll()
                       where items.ShipperID == _ShipVia
                       select items;
            }
        }

        #endregion
        

        int _OrderID;
        public int OrderID
        {
            get { return _OrderID; }
            set
            {
                if(_OrderID!=value){
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
        }

        string _CustomerID;
        public string CustomerID
        {
            get { return _CustomerID; }
            set
            {
                if(_CustomerID!=value){
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
        }

        int _EmployeeID;
        public int EmployeeID
        {
            get { return _EmployeeID; }
            set
            {
                if(_EmployeeID!=value){
                    _EmployeeID=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="EmployeeID");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        DateTime _OrderDate;
        public DateTime OrderDate
        {
            get { return _OrderDate; }
            set
            {
                if(_OrderDate!=value){
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
        }

        DateTime? _RequiredDate;
        public DateTime? RequiredDate
        {
            get { return _RequiredDate; }
            set
            {
                if(_RequiredDate!=value){
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
        }

        DateTime? _ShippedDate;
        public DateTime? ShippedDate
        {
            get { return _ShippedDate; }
            set
            {
                if(_ShippedDate!=value){
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
        }

        int? _ShipVia;
        public int? ShipVia
        {
            get { return _ShipVia; }
            set
            {
                if(_ShipVia!=value){
                    _ShipVia=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="ShipVia");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        decimal? _Freight;
        public decimal? Freight
        {
            get { return _Freight; }
            set
            {
                if(_Freight!=value){
                    _Freight=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="Freight");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _ShipName;
        public string ShipName
        {
            get { return _ShipName; }
            set
            {
                if(_ShipName!=value){
                    _ShipName=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="ShipName");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _ShipAddress;
        public string ShipAddress
        {
            get { return _ShipAddress; }
            set
            {
                if(_ShipAddress!=value){
                    _ShipAddress=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="ShipAddress");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _ShipCity;
        public string ShipCity
        {
            get { return _ShipCity; }
            set
            {
                if(_ShipCity!=value){
                    _ShipCity=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="ShipCity");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _ShipRegion;
        public string ShipRegion
        {
            get { return _ShipRegion; }
            set
            {
                if(_ShipRegion!=value){
                    _ShipRegion=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="ShipRegion");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _ShipPostalCode;
        public string ShipPostalCode
        {
            get { return _ShipPostalCode; }
            set
            {
                if(_ShipPostalCode!=value){
                    _ShipPostalCode=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="ShipPostalCode");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _ShipCountry;
        public string ShipCountry
        {
            get { return _ShipCountry; }
            set
            {
                if(_ShipCountry!=value){
                    _ShipCountry=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="ShipCountry");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
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

            
            var newKey=_repo.Add(this,provider);
            if(newKey!=KeyValue())
                this.SetKeyValue(newKey);
            
            SetIsNew(false);
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
                    SetIsNew(false);
                    SetIsLoaded(true);
                } catch {
                    SetIsLoaded(false);
                    throw;
                }
            }else{
                SetIsLoaded(false);
            }

            if (closeReader)
                rdr.Dispose();
        }
        

    } 
    
    
    /// <summary>
    /// A class which represents the SubSonicTests table in the Northwind Database.
    /// </summary>
    public partial class SubSonicTest: IActiveRecord
    {
    
        #region Built-in testing
        static IList<SubSonicTest> TestItems;
        static TestRepository<SubSonicTest> _testRepo;
        

        
        static void SetTestRepo(){
            _testRepo = _testRepo ?? new TestRepository<SubSonicTest>(new SouthWind.NorthwindDB());
        }
        public static void ResetTestRepo(){
            _testRepo = null;
            SetTestRepo();
        }
        public static void Setup(List<SubSonicTest> testlist){
            SetTestRepo();
            _testRepo._items = testlist;
        }
        public static void Setup(SubSonicTest item) {
            SetTestRepo();
            _testRepo._items.Add(item);
        }
        public static void Setup(int testItems) {
            SetTestRepo();
            for(int i=0;i<testItems;i++){
                SubSonicTest item=new SubSonicTest();
                _testRepo._items.Add(item);
            }
        }
        
        public bool TestMode = false;


        #endregion

        IRepository<SubSonicTest> _repo;
        ITable tbl;
        bool _isNew;
        public bool IsNew(){
            return _isNew;
        }
        
        public void SetIsLoaded(bool isLoaded){
            _isLoaded=isLoaded;
            if(isLoaded)
                OnLoaded();
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

        SouthWind.NorthwindDB _db;
        public SubSonicTest(string connectionString, string providerName) {

            _db=new SouthWind.NorthwindDB(connectionString, providerName);
            Init();            
         }
        void Init(){
            TestMode=this._db.DataProvider.ConnectionString.Equals("test", StringComparison.InvariantCultureIgnoreCase);
            _dirtyColumns=new List<IColumn>();
            if(TestMode){
                SubSonicTest.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<SubSonicTest>(_db);
            }
            tbl=_repo.GetTable();
            SetIsNew(true);
            OnCreated();       

        }
        
        public SubSonicTest(){
             _db=new SouthWind.NorthwindDB();
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

        public SubSonicTest(Expression<Func<SubSonicTest, bool>> expression):this() {

            SetIsLoaded(_repo.Load(this,expression));
        }
        
       
        
        internal static IRepository<SubSonicTest> GetRepo(string connectionString, string providerName){
            SouthWind.NorthwindDB db;
            if(String.IsNullOrEmpty(connectionString)){
                db=new SouthWind.NorthwindDB();
            }else{
                db=new SouthWind.NorthwindDB(connectionString, providerName);
            }
            IRepository<SubSonicTest> _repo;
            
            if(db.TestMode){
                SubSonicTest.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<SubSonicTest>(db);
            }
            return _repo;        
        }       
        
        internal static IRepository<SubSonicTest> GetRepo(){
            return GetRepo("","");
        }
        
        public static SubSonicTest SingleOrDefault(Expression<Func<SubSonicTest, bool>> expression) {

            var repo = GetRepo();
            var results=repo.Find(expression);
            SubSonicTest single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
                single.OnLoaded();
                single.SetIsLoaded(true);
                single.SetIsNew(false);
            }

            return single;
        }      
        
        public static SubSonicTest SingleOrDefault(Expression<Func<SubSonicTest, bool>> expression,string connectionString, string providerName) {
            var repo = GetRepo(connectionString,providerName);
            var results=repo.Find(expression);
            SubSonicTest single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
            }

            return single;


        }
        
        
        public static bool Exists(Expression<Func<SubSonicTest, bool>> expression,string connectionString, string providerName) {
           
            return All(connectionString,providerName).Any(expression);
        }        
        public static bool Exists(Expression<Func<SubSonicTest, bool>> expression) {
           
            return All().Any(expression);
        }        

        public static IList<SubSonicTest> Find(Expression<Func<SubSonicTest, bool>> expression) {
            
            var repo = GetRepo();
            return repo.Find(expression).ToList();
        }
        
        public static IList<SubSonicTest> Find(Expression<Func<SubSonicTest, bool>> expression,string connectionString, string providerName) {

            var repo = GetRepo(connectionString,providerName);
            return repo.Find(expression).ToList();

        }
        public static IQueryable<SubSonicTest> All(string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetAll();
        }
        public static IQueryable<SubSonicTest> All() {
            return GetRepo().GetAll();
        }
        
        public static PagedList<SubSonicTest> GetPaged(string sortBy, int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(sortBy, pageIndex, pageSize);
        }
      
        public static PagedList<SubSonicTest> GetPaged(string sortBy, int pageIndex, int pageSize) {
            return GetRepo().GetPaged(sortBy, pageIndex, pageSize);
        }

        public static PagedList<SubSonicTest> GetPaged(int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(pageIndex, pageSize);
            
        }


        public static PagedList<SubSonicTest> GetPaged(int pageIndex, int pageSize) {
            return GetRepo().GetPaged(pageIndex, pageSize);
            
        }

        public string KeyName()
        {
            return "SubSonicTestID";
        }

        public object KeyValue()
        {
            return this.SubSonicTestID;
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
            if(obj.GetType()==typeof(SubSonicTest)){
                SubSonicTest compare=(SubSonicTest)obj;
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
            return "SubSonicTestID";
        }        
        public static string GetDescriptorColumn()
        {
            return "Name";
        }
        
        #region ' Foreign Keys '
        #endregion
        

        int _SubSonicTestID;
        public int SubSonicTestID
        {
            get { return _SubSonicTestID; }
            set
            {
                if(_SubSonicTestID!=value){
                    _SubSonicTestID=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="SubSonicTestID");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        int _Thinger;
        public int Thinger
        {
            get { return _Thinger; }
            set
            {
                if(_Thinger!=value){
                    _Thinger=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="Thinger");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _Name;
        public string Name
        {
            get { return _Name; }
            set
            {
                if(_Name!=value){
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
        }

        string _UserName;
        public string UserName
        {
            get { return _UserName; }
            set
            {
                if(_UserName!=value){
                    _UserName=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="UserName");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        DateTime _CreatedOn;
        public DateTime CreatedOn
        {
            get { return _CreatedOn; }
            set
            {
                if(_CreatedOn!=value){
                    _CreatedOn=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="CreatedOn");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        decimal _Price;
        public decimal Price
        {
            get { return _Price; }
            set
            {
                if(_Price!=value){
                    _Price=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="Price");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        double _Discount;
        public double Discount
        {
            get { return _Discount; }
            set
            {
                if(_Discount!=value){
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
        }

        decimal? _Lat;
        public decimal? Lat
        {
            get { return _Lat; }
            set
            {
                if(_Lat!=value){
                    _Lat=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="Lat");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        decimal? _Long;
        public decimal? Long
        {
            get { return _Long; }
            set
            {
                if(_Long!=value){
                    _Long=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="Long");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        bool _SomeFlag;
        public bool SomeFlag
        {
            get { return _SomeFlag; }
            set
            {
                if(_SomeFlag!=value){
                    _SomeFlag=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="SomeFlag");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        bool? _SomeNullableFlag;
        public bool? SomeNullableFlag
        {
            get { return _SomeNullableFlag; }
            set
            {
                if(_SomeNullableFlag!=value){
                    _SomeNullableFlag=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="SomeNullableFlag");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _LongText;
        public string LongText
        {
            get { return _LongText; }
            set
            {
                if(_LongText!=value){
                    _LongText=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="LongText");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _MediumText;
        public string MediumText
        {
            get { return _MediumText; }
            set
            {
                if(_MediumText!=value){
                    _MediumText=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="MediumText");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
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

            
            this.CreatedOn=DateTime.Now;
            
            var newKey=_repo.Add(this,provider);
            if(newKey!=KeyValue())
                this.SetKeyValue(newKey);
            
            SetIsNew(false);
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


        public static void Delete(Expression<Func<SubSonicTest, bool>> expression) {
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
                    SetIsNew(false);
                    SetIsLoaded(true);
                } catch {
                    SetIsLoaded(false);
                    throw;
                }
            }else{
                SetIsLoaded(false);
            }

            if (closeReader)
                rdr.Dispose();
        }
        

    } 
    
    
    /// <summary>
    /// A class which represents the Products table in the Northwind Database.
    /// </summary>
    public partial class Product: IActiveRecord
    {
    
        #region Built-in testing
        static IList<Product> TestItems;
        static TestRepository<Product> _testRepo;
        

        
        static void SetTestRepo(){
            _testRepo = _testRepo ?? new TestRepository<Product>(new SouthWind.NorthwindDB());
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
        
        public void SetIsLoaded(bool isLoaded){
            _isLoaded=isLoaded;
            if(isLoaded)
                OnLoaded();
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

        SouthWind.NorthwindDB _db;
        public Product(string connectionString, string providerName) {

            _db=new SouthWind.NorthwindDB(connectionString, providerName);
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
            SetIsNew(true);
            OnCreated();       

        }
        
        public Product(){
             _db=new SouthWind.NorthwindDB();
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

            SetIsLoaded(_repo.Load(this,expression));
        }
        
       
        
        internal static IRepository<Product> GetRepo(string connectionString, string providerName){
            SouthWind.NorthwindDB db;
            if(String.IsNullOrEmpty(connectionString)){
                db=new SouthWind.NorthwindDB();
            }else{
                db=new SouthWind.NorthwindDB(connectionString, providerName);
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
                single.SetIsNew(false);
            }

            return single;
        }      
        
        public static Product SingleOrDefault(Expression<Func<Product, bool>> expression,string connectionString, string providerName) {
            var repo = GetRepo(connectionString,providerName);
            var results=repo.Find(expression);
            Product single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
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
        public IQueryable<Category> Categories
        {
            get
            {
                
                  var repo=SouthWind.Category.GetRepo();
                  return from items in repo.GetAll()
                       where items.CategoryID == _CategoryID
                       select items;
            }
        }

        public IQueryable<OrderDetail> OrderDetails
        {
            get
            {
                
                  var repo=SouthWind.OrderDetail.GetRepo();
                  return from items in repo.GetAll()
                       where items.ProductID == _ProductID
                       select items;
            }
        }

        public IQueryable<Supplier> Suppliers
        {
            get
            {
                
                  var repo=SouthWind.Supplier.GetRepo();
                  return from items in repo.GetAll()
                       where items.SupplierID == _SupplierID
                       select items;
            }
        }

        #endregion
        

        int _ProductID;
        public int ProductID
        {
            get { return _ProductID; }
            set
            {
                if(_ProductID!=value){
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
        }

        string _ProductName;
        public string ProductName
        {
            get { return _ProductName; }
            set
            {
                if(_ProductName!=value){
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
        }

        int? _SupplierID;
        public int? SupplierID
        {
            get { return _SupplierID; }
            set
            {
                if(_SupplierID!=value){
                    _SupplierID=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="SupplierID");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        int? _CategoryID;
        public int? CategoryID
        {
            get { return _CategoryID; }
            set
            {
                if(_CategoryID!=value){
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
        }

        string _QuantityPerUnit;
        public string QuantityPerUnit
        {
            get { return _QuantityPerUnit; }
            set
            {
                if(_QuantityPerUnit!=value){
                    _QuantityPerUnit=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="QuantityPerUnit");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        decimal? _UnitPrice;
        public decimal? UnitPrice
        {
            get { return _UnitPrice; }
            set
            {
                if(_UnitPrice!=value){
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
        }

        short? _UnitsInStock;
        public short? UnitsInStock
        {
            get { return _UnitsInStock; }
            set
            {
                if(_UnitsInStock!=value){
                    _UnitsInStock=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="UnitsInStock");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        long? _UnitsOnOrder;
        public long? UnitsOnOrder
        {
            get { return _UnitsOnOrder; }
            set
            {
                if(_UnitsOnOrder!=value){
                    _UnitsOnOrder=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="UnitsOnOrder");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        short? _ReorderLevel;
        public short? ReorderLevel
        {
            get { return _ReorderLevel; }
            set
            {
                if(_ReorderLevel!=value){
                    _ReorderLevel=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="ReorderLevel");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        bool _Discontinued;
        public bool Discontinued
        {
            get { return _Discontinued; }
            set
            {
                if(_Discontinued!=value){
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

            
            var newKey=_repo.Add(this,provider);
            if(newKey!=KeyValue())
                this.SetKeyValue(newKey);
            
            SetIsNew(false);
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
                    SetIsNew(false);
                    SetIsLoaded(true);
                } catch {
                    SetIsLoaded(false);
                    throw;
                }
            }else{
                SetIsLoaded(false);
            }

            if (closeReader)
                rdr.Dispose();
        }
        

    } 
    
    
    /// <summary>
    /// A class which represents the Employees table in the Northwind Database.
    /// </summary>
    public partial class Employee: IActiveRecord
    {
    
        #region Built-in testing
        static IList<Employee> TestItems;
        static TestRepository<Employee> _testRepo;
        

        
        static void SetTestRepo(){
            _testRepo = _testRepo ?? new TestRepository<Employee>(new SouthWind.NorthwindDB());
        }
        public static void ResetTestRepo(){
            _testRepo = null;
            SetTestRepo();
        }
        public static void Setup(List<Employee> testlist){
            SetTestRepo();
            _testRepo._items = testlist;
        }
        public static void Setup(Employee item) {
            SetTestRepo();
            _testRepo._items.Add(item);
        }
        public static void Setup(int testItems) {
            SetTestRepo();
            for(int i=0;i<testItems;i++){
                Employee item=new Employee();
                _testRepo._items.Add(item);
            }
        }
        
        public bool TestMode = false;


        #endregion

        IRepository<Employee> _repo;
        ITable tbl;
        bool _isNew;
        public bool IsNew(){
            return _isNew;
        }
        
        public void SetIsLoaded(bool isLoaded){
            _isLoaded=isLoaded;
            if(isLoaded)
                OnLoaded();
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

        SouthWind.NorthwindDB _db;
        public Employee(string connectionString, string providerName) {

            _db=new SouthWind.NorthwindDB(connectionString, providerName);
            Init();            
         }
        void Init(){
            TestMode=this._db.DataProvider.ConnectionString.Equals("test", StringComparison.InvariantCultureIgnoreCase);
            _dirtyColumns=new List<IColumn>();
            if(TestMode){
                Employee.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<Employee>(_db);
            }
            tbl=_repo.GetTable();
            SetIsNew(true);
            OnCreated();       

        }
        
        public Employee(){
             _db=new SouthWind.NorthwindDB();
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

        public Employee(Expression<Func<Employee, bool>> expression):this() {

            SetIsLoaded(_repo.Load(this,expression));
        }
        
       
        
        internal static IRepository<Employee> GetRepo(string connectionString, string providerName){
            SouthWind.NorthwindDB db;
            if(String.IsNullOrEmpty(connectionString)){
                db=new SouthWind.NorthwindDB();
            }else{
                db=new SouthWind.NorthwindDB(connectionString, providerName);
            }
            IRepository<Employee> _repo;
            
            if(db.TestMode){
                Employee.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<Employee>(db);
            }
            return _repo;        
        }       
        
        internal static IRepository<Employee> GetRepo(){
            return GetRepo("","");
        }
        
        public static Employee SingleOrDefault(Expression<Func<Employee, bool>> expression) {

            var repo = GetRepo();
            var results=repo.Find(expression);
            Employee single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
                single.OnLoaded();
                single.SetIsLoaded(true);
                single.SetIsNew(false);
            }

            return single;
        }      
        
        public static Employee SingleOrDefault(Expression<Func<Employee, bool>> expression,string connectionString, string providerName) {
            var repo = GetRepo(connectionString,providerName);
            var results=repo.Find(expression);
            Employee single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
            }

            return single;


        }
        
        
        public static bool Exists(Expression<Func<Employee, bool>> expression,string connectionString, string providerName) {
           
            return All(connectionString,providerName).Any(expression);
        }        
        public static bool Exists(Expression<Func<Employee, bool>> expression) {
           
            return All().Any(expression);
        }        

        public static IList<Employee> Find(Expression<Func<Employee, bool>> expression) {
            
            var repo = GetRepo();
            return repo.Find(expression).ToList();
        }
        
        public static IList<Employee> Find(Expression<Func<Employee, bool>> expression,string connectionString, string providerName) {

            var repo = GetRepo(connectionString,providerName);
            return repo.Find(expression).ToList();

        }
        public static IQueryable<Employee> All(string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetAll();
        }
        public static IQueryable<Employee> All() {
            return GetRepo().GetAll();
        }
        
        public static PagedList<Employee> GetPaged(string sortBy, int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(sortBy, pageIndex, pageSize);
        }
      
        public static PagedList<Employee> GetPaged(string sortBy, int pageIndex, int pageSize) {
            return GetRepo().GetPaged(sortBy, pageIndex, pageSize);
        }

        public static PagedList<Employee> GetPaged(int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(pageIndex, pageSize);
            
        }


        public static PagedList<Employee> GetPaged(int pageIndex, int pageSize) {
            return GetRepo().GetPaged(pageIndex, pageSize);
            
        }

        public string KeyName()
        {
            return "EmployeeID";
        }

        public object KeyValue()
        {
            return this.EmployeeID;
        }
        
        public void SetKeyValue(object value) {
            if (value != null && value!=DBNull.Value) {
                var settable = value.ChangeTypeTo<int>();
                this.GetType().GetProperty(this.KeyName()).SetValue(this, settable, null);
            }
        }
        
        public override string ToString(){
            return this.LastName.ToString();
        }

        public override bool Equals(object obj){
            if(obj.GetType()==typeof(Employee)){
                Employee compare=(Employee)obj;
                return compare.KeyValue()==this.KeyValue();
            }else{
                return base.Equals(obj);
            }
        }

        public string DescriptorValue()
        {
            return this.LastName.ToString();
        }

        public string DescriptorColumn() {
            return "LastName";
        }
        public static string GetKeyColumn()
        {
            return "EmployeeID";
        }        
        public static string GetDescriptorColumn()
        {
            return "LastName";
        }
        
        #region ' Foreign Keys '
        public IQueryable<Employee> Employees
        {
            get
            {
                
                  var repo=SouthWind.Employee.GetRepo();
                  return from items in repo.GetAll()
                       where items.EmployeeID == _ReportsTo
                       select items;
            }
        }

        public IQueryable<EmployeeTerritory> EmployeeTerritories
        {
            get
            {
                
                  var repo=SouthWind.EmployeeTerritory.GetRepo();
                  return from items in repo.GetAll()
                       where items.EmployeeID == _EmployeeID
                       select items;
            }
        }

        public IQueryable<Order> Orders
        {
            get
            {
                
                  var repo=SouthWind.Order.GetRepo();
                  return from items in repo.GetAll()
                       where items.EmployeeID == _EmployeeID
                       select items;
            }
        }

        #endregion
        

        int _EmployeeID;
        public int EmployeeID
        {
            get { return _EmployeeID; }
            set
            {
                if(_EmployeeID!=value){
                    _EmployeeID=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="EmployeeID");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _LastName;
        public string LastName
        {
            get { return _LastName; }
            set
            {
                if(_LastName!=value){
                    _LastName=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="LastName");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _FirstName;
        public string FirstName
        {
            get { return _FirstName; }
            set
            {
                if(_FirstName!=value){
                    _FirstName=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="FirstName");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _Title;
        public string Title
        {
            get { return _Title; }
            set
            {
                if(_Title!=value){
                    _Title=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="Title");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _TitleOfCourtesy;
        public string TitleOfCourtesy
        {
            get { return _TitleOfCourtesy; }
            set
            {
                if(_TitleOfCourtesy!=value){
                    _TitleOfCourtesy=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="TitleOfCourtesy");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        DateTime? _BirthDate;
        public DateTime? BirthDate
        {
            get { return _BirthDate; }
            set
            {
                if(_BirthDate!=value){
                    _BirthDate=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="BirthDate");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        DateTime? _HireDate;
        public DateTime? HireDate
        {
            get { return _HireDate; }
            set
            {
                if(_HireDate!=value){
                    _HireDate=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="HireDate");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _Address;
        public string Address
        {
            get { return _Address; }
            set
            {
                if(_Address!=value){
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
        }

        string _City;
        public string City
        {
            get { return _City; }
            set
            {
                if(_City!=value){
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
        }

        string _Region;
        public string Region
        {
            get { return _Region; }
            set
            {
                if(_Region!=value){
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
        }

        string _PostalCode;
        public string PostalCode
        {
            get { return _PostalCode; }
            set
            {
                if(_PostalCode!=value){
                    _PostalCode=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="PostalCode");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _Country;
        public string Country
        {
            get { return _Country; }
            set
            {
                if(_Country!=value){
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
        }

        string _HomePhone;
        public string HomePhone
        {
            get { return _HomePhone; }
            set
            {
                if(_HomePhone!=value){
                    _HomePhone=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="HomePhone");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _Extension;
        public string Extension
        {
            get { return _Extension; }
            set
            {
                if(_Extension!=value){
                    _Extension=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="Extension");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        byte[] _Photo;
        public byte[] Photo
        {
            get { return _Photo; }
            set
            {
                if(_Photo!=value){
                    _Photo=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="Photo");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _Notes;
        public string Notes
        {
            get { return _Notes; }
            set
            {
                if(_Notes!=value){
                    _Notes=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="Notes");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        int? _ReportsTo;
        public int? ReportsTo
        {
            get { return _ReportsTo; }
            set
            {
                if(_ReportsTo!=value){
                    _ReportsTo=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="ReportsTo");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        string _PhotoPath;
        public string PhotoPath
        {
            get { return _PhotoPath; }
            set
            {
                if(_PhotoPath!=value){
                    _PhotoPath=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="PhotoPath");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
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

            
            var newKey=_repo.Add(this,provider);
            if(newKey!=KeyValue())
                this.SetKeyValue(newKey);
            
            SetIsNew(false);
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


        public static void Delete(Expression<Func<Employee, bool>> expression) {
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
                    SetIsNew(false);
                    SetIsLoaded(true);
                } catch {
                    SetIsLoaded(false);
                    throw;
                }
            }else{
                SetIsLoaded(false);
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
        

        
        static void SetTestRepo(){
            _testRepo = _testRepo ?? new TestRepository<Category>(new SouthWind.NorthwindDB());
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
        
        public void SetIsLoaded(bool isLoaded){
            _isLoaded=isLoaded;
            if(isLoaded)
                OnLoaded();
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

        SouthWind.NorthwindDB _db;
        public Category(string connectionString, string providerName) {

            _db=new SouthWind.NorthwindDB(connectionString, providerName);
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
            SetIsNew(true);
            OnCreated();       

        }
        
        public Category(){
             _db=new SouthWind.NorthwindDB();
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

            SetIsLoaded(_repo.Load(this,expression));
        }
        
       
        
        internal static IRepository<Category> GetRepo(string connectionString, string providerName){
            SouthWind.NorthwindDB db;
            if(String.IsNullOrEmpty(connectionString)){
                db=new SouthWind.NorthwindDB();
            }else{
                db=new SouthWind.NorthwindDB(connectionString, providerName);
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
                single.SetIsNew(false);
            }

            return single;
        }      
        
        public static Category SingleOrDefault(Expression<Func<Category, bool>> expression,string connectionString, string providerName) {
            var repo = GetRepo(connectionString,providerName);
            var results=repo.Find(expression);
            Category single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
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
        public IQueryable<Product> Products
        {
            get
            {
                
                  var repo=SouthWind.Product.GetRepo();
                  return from items in repo.GetAll()
                       where items.CategoryID == _CategoryID
                       select items;
            }
        }

        #endregion
        

        int _CategoryID;
        public int CategoryID
        {
            get { return _CategoryID; }
            set
            {
                if(_CategoryID!=value){
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
        }

        string _CategoryName;
        public string CategoryName
        {
            get { return _CategoryName; }
            set
            {
                if(_CategoryName!=value){
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
        }

        string _Description;
        public string Description
        {
            get { return _Description; }
            set
            {
                if(_Description!=value){
                    _Description=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="Description");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
            }
        }

        byte[] _Picture;
        public byte[] Picture
        {
            get { return _Picture; }
            set
            {
                if(_Picture!=value){
                    _Picture=value;
                    var col=tbl.Columns.SingleOrDefault(x=>x.Name=="Picture");
                    if(col!=null){
                        if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                            _dirtyColumns.Add(col);
                        }
                    }
                    OnChanged();
                }
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

            
            var newKey=_repo.Add(this,provider);
            if(newKey!=KeyValue())
                this.SetKeyValue(newKey);
            
            SetIsNew(false);
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
                    SetIsNew(false);
                    SetIsLoaded(true);
                } catch {
                    SetIsLoaded(false);
                    throw;
                }
            }else{
                SetIsLoaded(false);
            }

            if (closeReader)
                rdr.Dispose();
        }
        

    } 
}
