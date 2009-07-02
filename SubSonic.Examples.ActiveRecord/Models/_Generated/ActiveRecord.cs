


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

namespace Blog
{
    
    
    /// <summary>
    /// A class which represents the Posts table in the Blog Database.
    /// </summary>
    public partial class Post: IActiveRecord
    {
    
        #region Built-in testing
        static IList<Post> TestItems;
        static TestRepository<Post> _testRepo;
        public void SetIsLoaded(bool isLoaded){
            _isLoaded=isLoaded;
        }
        static void SetTestRepo(){
            _testRepo = _testRepo ?? new TestRepository<Post>(new Blog.BlogDB());
        }
        public static void ResetTestRepo(){
            _testRepo = null;
            SetTestRepo();
        }
        public static void Setup(List<Post> testlist){
            SetTestRepo();
            _testRepo._items = testlist;
        }
        public static void Setup(Post item) {
            SetTestRepo();
            _testRepo._items.Add(item);
        }
        public static void Setup(int testItems) {
            SetTestRepo();
            for(int i=0;i<testItems;i++){
                Post item=new Post();
                _testRepo._items.Add(item);
            }
        }
        
        public bool TestMode = false;


        #endregion

        IRepository<Post> _repo;
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

        Blog.BlogDB _db;
        public Post(string connectionString, string providerName) {

            _db=new Blog.BlogDB(connectionString, providerName);
            Init();            
         }
        void Init(){
            TestMode=this._db.DataProvider.ConnectionString.Equals("test", StringComparison.InvariantCultureIgnoreCase);
            _dirtyColumns=new List<IColumn>();
            if(TestMode){
                Post.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<Post>(_db);
            }
            tbl=_repo.GetTable();
            _isNew = true;
            OnCreated();       
      
        }
        
        public Post(){
             _db=new Blog.BlogDB();
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

        public Post(Expression<Func<Post, bool>> expression):this() {
            _isLoaded=_repo.Load(this,expression);
            if(_isLoaded)
                OnLoaded();
        }
        
       
        
        internal static IRepository<Post> GetRepo(string connectionString, string providerName){
            Blog.BlogDB db;
            if(String.IsNullOrEmpty(connectionString)){
                db=new Blog.BlogDB();
            }else{
                db=new Blog.BlogDB(connectionString, providerName);
            }
            IRepository<Post> _repo;
            
            if(db.TestMode){
                Post.SetTestRepo();
                _repo=_testRepo;
            }else{
                _repo = new SubSonicRepository<Post>(db);
            }
            return _repo;        
        }       
        
        internal static IRepository<Post> GetRepo(){
            return GetRepo("","");
        }
        
        public static Post SingleOrDefault(Expression<Func<Post, bool>> expression) {

            var repo = GetRepo();
            var results=repo.Find(expression);
            Post single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
                single.OnLoaded();
                single.SetIsLoaded(true);
            }

            return single;
        }      
        
        public static Post SingleOrDefault(Expression<Func<Post, bool>> expression,string connectionString, string providerName) {
            var repo = GetRepo(connectionString,providerName);
            var results=repo.Find(expression);
            Post single=null;
            if(results.Count() > 0){
                single=results.ToList()[0];
                single.OnLoaded();
                single.SetIsLoaded(true);
            }

            return single;


        }
        
        
        public static bool Exists(Expression<Func<Post, bool>> expression,string connectionString, string providerName) {
           
            return All(connectionString,providerName).Any(expression);
        }        
        public static bool Exists(Expression<Func<Post, bool>> expression) {
           
            return All().Any(expression);
        }        

        public static IList<Post> Find(Expression<Func<Post, bool>> expression) {
            
            var repo = GetRepo();
            return repo.Find(expression).ToList();
        }
        
        public static IList<Post> Find(Expression<Func<Post, bool>> expression,string connectionString, string providerName) {

            var repo = GetRepo(connectionString,providerName);
            return repo.Find(expression).ToList();

        }
        public static IQueryable<Post> All(string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetAll();
        }
        public static IQueryable<Post> All() {
            return GetRepo().GetAll();
        }
        
        public static PagedList<Post> GetPaged(string sortBy, int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(sortBy, pageIndex, pageSize);
        }
      
        public static PagedList<Post> GetPaged(string sortBy, int pageIndex, int pageSize) {
            return GetRepo().GetPaged(sortBy, pageIndex, pageSize);
        }

        public static PagedList<Post> GetPaged(int pageIndex, int pageSize,string connectionString, string providerName) {
            return GetRepo(connectionString,providerName).GetPaged(pageIndex, pageSize);
            
        }


        public static PagedList<Post> GetPaged(int pageIndex, int pageSize) {
            return GetRepo().GetPaged(pageIndex, pageSize);
            
        }

        public string KeyName()
        {
            return "PostID";
        }

        public object KeyValue()
        {
            return this.PostID;
        }
        
        public void SetKeyValue(object value) {
            if (value != null && value!=DBNull.Value) {
                var settable = value.ChangeTypeTo<Guid>();
                this.GetType().GetProperty(this.KeyName()).SetValue(this, settable, null);
            }
        }
        
        public override string ToString(){
            return this.Title.ToString();
        }

        public override bool Equals(object obj){
            if(obj.GetType()==typeof(Post)){
                Post compare=(Post)obj;
                return compare.KeyValue()==this.KeyValue();
            }else{
                return base.Equals(obj);
            }
        }

        public string DescriptorValue()
        {
            return this.Title.ToString();
        }

        public string DescriptorColumn() {
            return "Title";
        }
        public static string GetKeyColumn()
        {
            return "PostID";
        }        
        public static string GetDescriptorColumn()
        {
            return "Title";
        }
        
        #region ' Foreign Keys '
        public IQueryable<Category> Categories
        {
            get
            {
                
                  var repo=Blog.Category.GetRepo();
                  return from items in repo.GetAll()
                       where items.CategoryID == _CategoryID
                       select items;
            }
        }

        #endregion
        

        Guid _PostID;
        public Guid PostID
        {
            get { return _PostID; }
            set
            {
                
                _PostID=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="PostID");
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

        string _Title;
        public string Title
        {
            get { return _Title; }
            set
            {
                
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

        string _Slug;
        public string Slug
        {
            get { return _Slug; }
            set
            {
                
                _Slug=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="Slug");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        string _Body;
        public string Body
        {
            get { return _Body; }
            set
            {
                
                _Body=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="Body");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        DateTime _PublishedOn;
        public DateTime PublishedOn
        {
            get { return _PublishedOn; }
            set
            {
                
                _PublishedOn=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="PublishedOn");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        DateTime _CreatedOn;
        public DateTime CreatedOn
        {
            get { return _CreatedOn; }
            set
            {
                
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

        DateTime _ModifiedOn;
        public DateTime ModifiedOn
        {
            get { return _ModifiedOn; }
            set
            {
                
                _ModifiedOn=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="ModifiedOn");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        string _CreatedBy;
        public string CreatedBy
        {
            get { return _CreatedBy; }
            set
            {
                
                _CreatedBy=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="CreatedBy");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }

        string _ModifiedBy;
        public string ModifiedBy
        {
            get { return _ModifiedBy; }
            set
            {
                
                _ModifiedBy=value;
                var col=tbl.Columns.SingleOrDefault(x=>x.Name=="ModifiedBy");
                if(col!=null){
                    if(!_dirtyColumns.Any(x=>x.Name==col.Name) && _isLoaded){
                        _dirtyColumns.Add(col);
                    }
                }
                OnChanged();
            }
        }



        public DbCommand GetUpdateCommand() {
            if (!_dirtyColumns.Any(x => x.Name.ToLower() == "modifiedon")) {
               this.ModifiedOn=DateTime.Now;
            }            
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
        
            this.ModifiedBy=Environment.UserName;
            this.ModifiedOn=DateTime.Now;
            
            if(this._dirtyColumns.Count>0)
                _repo.Update(this,provider);
            OnSaved();
       }
 
        public void Add(){
            Add(_db.DataProvider);
        }
        
                public void Update(string username){
            
            this.ModifiedBy=username;
            Update();

        }
        public void Update(string username, IDataProvider provider){

            this.ModifiedBy=username;
            Update(provider);
        }
        
       
        public void Add(IDataProvider provider){

            
            this.CreatedOn=DateTime.Now;
            this.CreatedBy=Environment.UserName;
            this.ModifiedOn=DateTime.Now;
            this.ModifiedBy=Environment.UserName;
            this.SetKeyValue(_repo.Add(this,provider));
            OnSaved();
        }
        
                public void Add(string username){
            
            this.CreatedBy=username;
            Add();

        }
        public void Add(string username, IDataProvider provider){

            this.CreatedBy=username;
            Add(provider);
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

                public void Save(string username, IDataProvider provider) {
            
           
            if (_isNew) {
                                Add(username,provider);
                            } else {
                                Update(username,provider);
                
            }
            
        }
        

        public void Delete(IDataProvider provider) {
                   
                 
            _repo.Delete(KeyValue());
            
                    }


        public void Delete() {
            Delete(_db.DataProvider);
        }


        public static void Delete(Expression<Func<Post, bool>> expression) {
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
    /// A class which represents the Categories table in the Blog Database.
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
            _testRepo = _testRepo ?? new TestRepository<Category>(new Blog.BlogDB());
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

        Blog.BlogDB _db;
        public Category(string connectionString, string providerName) {

            _db=new Blog.BlogDB(connectionString, providerName);
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
             _db=new Blog.BlogDB();
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
            Blog.BlogDB db;
            if(String.IsNullOrEmpty(connectionString)){
                db=new Blog.BlogDB();
            }else{
                db=new Blog.BlogDB(connectionString, providerName);
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
            return this.Description.ToString();
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
            return this.Description.ToString();
        }

        public string DescriptorColumn() {
            return "Description";
        }
        public static string GetKeyColumn()
        {
            return "CategoryID";
        }        
        public static string GetDescriptorColumn()
        {
            return "Description";
        }
        
        #region ' Foreign Keys '
        public IQueryable<Post> Posts
        {
            get
            {
                
                  var repo=Blog.Post.GetRepo();
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

        string _Description;
        public string Description
        {
            get { return _Description; }
            set
            {
                
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
}
