


using System;
using System.ComponentModel;
using System.Linq;

namespace WestWind
{
    
    
    
    
    /// <summary>
    /// A class which represents the Products table in the SubSonic Database.
    /// This class is queryable through SubSonicDB.Product 
    /// </summary>

	public partial class Product: INotifyPropertyChanging, INotifyPropertyChanged
	{
        partial void OnLoaded();
        partial void OnValidate(System.Data.Linq.ChangeAction action);
        partial void OnCreated();
	    
	    public Product(){
	        OnCreated();
	    }
	    
	    #region Properties
	    
        partial void OnProductIDChanging(int value);
        partial void OnProductIDChanged();
		
		private int _ProductID;
		public int ProductID { 
		    get{
		        return _ProductID;
		    } 
		    set{
		        this.OnProductIDChanging(value);
                this.SendPropertyChanging();
                this._ProductID = value;
                this.SendPropertyChanged("ProductID");
                this.OnProductIDChanged();
		    }
		}
		
        partial void OnSkuChanging(Guid value);
        partial void OnSkuChanged();
		
		private Guid _Sku;
		public Guid Sku { 
		    get{
		        return _Sku;
		    } 
		    set{
		        this.OnSkuChanging(value);
                this.SendPropertyChanging();
                this._Sku = value;
                this.SendPropertyChanged("Sku");
                this.OnSkuChanged();
		    }
		}
		
        partial void OnCategoryIDChanging(int value);
        partial void OnCategoryIDChanged();
		
		private int _CategoryID;
		public int CategoryID { 
		    get{
		        return _CategoryID;
		    } 
		    set{
		        this.OnCategoryIDChanging(value);
                this.SendPropertyChanging();
                this._CategoryID = value;
                this.SendPropertyChanged("CategoryID");
                this.OnCategoryIDChanged();
		    }
		}
		
        partial void OnProductNameChanging(string value);
        partial void OnProductNameChanged();
		
		private string _ProductName;
		public string ProductName { 
		    get{
		        return _ProductName;
		    } 
		    set{
		        this.OnProductNameChanging(value);
                this.SendPropertyChanging();
                this._ProductName = value;
                this.SendPropertyChanged("ProductName");
                this.OnProductNameChanged();
		    }
		}
		
        partial void OnUnitPriceChanging(decimal value);
        partial void OnUnitPriceChanged();
		
		private decimal _UnitPrice;
		public decimal UnitPrice { 
		    get{
		        return _UnitPrice;
		    } 
		    set{
		        this.OnUnitPriceChanging(value);
                this.SendPropertyChanging();
                this._UnitPrice = value;
                this.SendPropertyChanged("UnitPrice");
                this.OnUnitPriceChanged();
		    }
		}
		
        partial void OnDiscontinuedChanging(bool value);
        partial void OnDiscontinuedChanged();
		
		private bool _Discontinued;
		public bool Discontinued { 
		    get{
		        return _Discontinued;
		    } 
		    set{
		        this.OnDiscontinuedChanging(value);
                this.SendPropertyChanging();
                this._Discontinued = value;
                this.SendPropertyChanged("Discontinued");
                this.OnDiscontinuedChanged();
		    }
		}
		

        #endregion

        #region Foreign Keys
        #endregion


        private static PropertyChangingEventArgs emptyChangingEventArgs = new PropertyChangingEventArgs(String.Empty);
        public event PropertyChangingEventHandler PropertyChanging;
        public event PropertyChangedEventHandler PropertyChanged;
        protected virtual void SendPropertyChanging()
        {
            var handler = PropertyChanging;
            if (handler != null)
               handler(this, emptyChangingEventArgs);
        }

        protected virtual void SendPropertyChanged(String propertyName)
        {
            var handler = PropertyChanged;
            if (handler != null)
                handler(this, new PropertyChangedEventArgs(propertyName));
        }

	}
	
    
    
    /// <summary>
    /// A class which represents the Orders table in the SubSonic Database.
    /// This class is queryable through SubSonicDB.Order 
    /// </summary>

	public partial class Order: INotifyPropertyChanging, INotifyPropertyChanged
	{
        partial void OnLoaded();
        partial void OnValidate(System.Data.Linq.ChangeAction action);
        partial void OnCreated();
	    
	    public Order(){
	        OnCreated();
	    }
	    
	    #region Properties
	    
        partial void OnOrderIDChanging(int value);
        partial void OnOrderIDChanged();
		
		private int _OrderID;
		public int OrderID { 
		    get{
		        return _OrderID;
		    } 
		    set{
		        this.OnOrderIDChanging(value);
                this.SendPropertyChanging();
                this._OrderID = value;
                this.SendPropertyChanged("OrderID");
                this.OnOrderIDChanged();
		    }
		}
		
        partial void OnOrderDateChanging(DateTime value);
        partial void OnOrderDateChanged();
		
		private DateTime _OrderDate;
		public DateTime OrderDate { 
		    get{
		        return _OrderDate;
		    } 
		    set{
		        this.OnOrderDateChanging(value);
                this.SendPropertyChanging();
                this._OrderDate = value;
                this.SendPropertyChanged("OrderDate");
                this.OnOrderDateChanged();
		    }
		}
		
        partial void OnCustomerIDChanging(string value);
        partial void OnCustomerIDChanged();
		
		private string _CustomerID;
		public string CustomerID { 
		    get{
		        return _CustomerID;
		    } 
		    set{
		        this.OnCustomerIDChanging(value);
                this.SendPropertyChanging();
                this._CustomerID = value;
                this.SendPropertyChanged("CustomerID");
                this.OnCustomerIDChanged();
		    }
		}
		
        partial void OnRequiredDateChanging(DateTime? value);
        partial void OnRequiredDateChanged();
		
		private DateTime? _RequiredDate;
		public DateTime? RequiredDate { 
		    get{
		        return _RequiredDate;
		    } 
		    set{
		        this.OnRequiredDateChanging(value);
                this.SendPropertyChanging();
                this._RequiredDate = value;
                this.SendPropertyChanged("RequiredDate");
                this.OnRequiredDateChanged();
		    }
		}
		
        partial void OnShippedDateChanging(DateTime? value);
        partial void OnShippedDateChanged();
		
		private DateTime? _ShippedDate;
		public DateTime? ShippedDate { 
		    get{
		        return _ShippedDate;
		    } 
		    set{
		        this.OnShippedDateChanging(value);
                this.SendPropertyChanging();
                this._ShippedDate = value;
                this.SendPropertyChanged("ShippedDate");
                this.OnShippedDateChanged();
		    }
		}
		

        #endregion

        #region Foreign Keys
        #endregion


        private static PropertyChangingEventArgs emptyChangingEventArgs = new PropertyChangingEventArgs(String.Empty);
        public event PropertyChangingEventHandler PropertyChanging;
        public event PropertyChangedEventHandler PropertyChanged;
        protected virtual void SendPropertyChanging()
        {
            var handler = PropertyChanging;
            if (handler != null)
               handler(this, emptyChangingEventArgs);
        }

        protected virtual void SendPropertyChanged(String propertyName)
        {
            var handler = PropertyChanged;
            if (handler != null)
                handler(this, new PropertyChangedEventArgs(propertyName));
        }

	}
	
    
    
    /// <summary>
    /// A class which represents the OrderDetails table in the SubSonic Database.
    /// This class is queryable through SubSonicDB.OrderDetail 
    /// </summary>

	public partial class OrderDetail: INotifyPropertyChanging, INotifyPropertyChanged
	{
        partial void OnLoaded();
        partial void OnValidate(System.Data.Linq.ChangeAction action);
        partial void OnCreated();
	    
	    public OrderDetail(){
	        OnCreated();
	    }
	    
	    #region Properties
	    
        partial void OnOrderDetailIDChanging(int value);
        partial void OnOrderDetailIDChanged();
		
		private int _OrderDetailID;
		public int OrderDetailID { 
		    get{
		        return _OrderDetailID;
		    } 
		    set{
		        this.OnOrderDetailIDChanging(value);
                this.SendPropertyChanging();
                this._OrderDetailID = value;
                this.SendPropertyChanged("OrderDetailID");
                this.OnOrderDetailIDChanged();
		    }
		}
		
        partial void OnOrderIDChanging(int value);
        partial void OnOrderIDChanged();
		
		private int _OrderID;
		public int OrderID { 
		    get{
		        return _OrderID;
		    } 
		    set{
		        this.OnOrderIDChanging(value);
                this.SendPropertyChanging();
                this._OrderID = value;
                this.SendPropertyChanged("OrderID");
                this.OnOrderIDChanged();
		    }
		}
		
        partial void OnProductIDChanging(int value);
        partial void OnProductIDChanged();
		
		private int _ProductID;
		public int ProductID { 
		    get{
		        return _ProductID;
		    } 
		    set{
		        this.OnProductIDChanging(value);
                this.SendPropertyChanging();
                this._ProductID = value;
                this.SendPropertyChanged("ProductID");
                this.OnProductIDChanged();
		    }
		}
		
        partial void OnUnitPriceChanging(decimal value);
        partial void OnUnitPriceChanged();
		
		private decimal _UnitPrice;
		public decimal UnitPrice { 
		    get{
		        return _UnitPrice;
		    } 
		    set{
		        this.OnUnitPriceChanging(value);
                this.SendPropertyChanging();
                this._UnitPrice = value;
                this.SendPropertyChanged("UnitPrice");
                this.OnUnitPriceChanged();
		    }
		}
		
        partial void OnQuantityChanging(int value);
        partial void OnQuantityChanged();
		
		private int _Quantity;
		public int Quantity { 
		    get{
		        return _Quantity;
		    } 
		    set{
		        this.OnQuantityChanging(value);
                this.SendPropertyChanging();
                this._Quantity = value;
                this.SendPropertyChanged("Quantity");
                this.OnQuantityChanged();
		    }
		}
		
        partial void OnDiscountChanging(decimal value);
        partial void OnDiscountChanged();
		
		private decimal _Discount;
		public decimal Discount { 
		    get{
		        return _Discount;
		    } 
		    set{
		        this.OnDiscountChanging(value);
                this.SendPropertyChanging();
                this._Discount = value;
                this.SendPropertyChanged("Discount");
                this.OnDiscountChanged();
		    }
		}
		

        #endregion

        #region Foreign Keys
        #endregion


        private static PropertyChangingEventArgs emptyChangingEventArgs = new PropertyChangingEventArgs(String.Empty);
        public event PropertyChangingEventHandler PropertyChanging;
        public event PropertyChangedEventHandler PropertyChanged;
        protected virtual void SendPropertyChanging()
        {
            var handler = PropertyChanging;
            if (handler != null)
               handler(this, emptyChangingEventArgs);
        }

        protected virtual void SendPropertyChanged(String propertyName)
        {
            var handler = PropertyChanged;
            if (handler != null)
                handler(this, new PropertyChangedEventArgs(propertyName));
        }

	}
	
    
    
    /// <summary>
    /// A class which represents the Customers table in the SubSonic Database.
    /// This class is queryable through SubSonicDB.Customer 
    /// </summary>

	public partial class Customer: INotifyPropertyChanging, INotifyPropertyChanged
	{
        partial void OnLoaded();
        partial void OnValidate(System.Data.Linq.ChangeAction action);
        partial void OnCreated();
	    
	    public Customer(){
	        OnCreated();
	    }
	    
	    #region Properties
	    
        partial void OnCustomerIDChanging(string value);
        partial void OnCustomerIDChanged();
		
		private string _CustomerID;
		public string CustomerID { 
		    get{
		        return _CustomerID;
		    } 
		    set{
		        this.OnCustomerIDChanging(value);
                this.SendPropertyChanging();
                this._CustomerID = value;
                this.SendPropertyChanged("CustomerID");
                this.OnCustomerIDChanged();
		    }
		}
		
        partial void OnCompanyNameChanging(string value);
        partial void OnCompanyNameChanged();
		
		private string _CompanyName;
		public string CompanyName { 
		    get{
		        return _CompanyName;
		    } 
		    set{
		        this.OnCompanyNameChanging(value);
                this.SendPropertyChanging();
                this._CompanyName = value;
                this.SendPropertyChanged("CompanyName");
                this.OnCompanyNameChanged();
		    }
		}
		
        partial void OnContactNameChanging(string value);
        partial void OnContactNameChanged();
		
		private string _ContactName;
		public string ContactName { 
		    get{
		        return _ContactName;
		    } 
		    set{
		        this.OnContactNameChanging(value);
                this.SendPropertyChanging();
                this._ContactName = value;
                this.SendPropertyChanged("ContactName");
                this.OnContactNameChanged();
		    }
		}
		
        partial void OnAddressChanging(string value);
        partial void OnAddressChanged();
		
		private string _Address;
		public string Address { 
		    get{
		        return _Address;
		    } 
		    set{
		        this.OnAddressChanging(value);
                this.SendPropertyChanging();
                this._Address = value;
                this.SendPropertyChanged("Address");
                this.OnAddressChanged();
		    }
		}
		
        partial void OnCityChanging(string value);
        partial void OnCityChanged();
		
		private string _City;
		public string City { 
		    get{
		        return _City;
		    } 
		    set{
		        this.OnCityChanging(value);
                this.SendPropertyChanging();
                this._City = value;
                this.SendPropertyChanged("City");
                this.OnCityChanged();
		    }
		}
		
        partial void OnRegionChanging(string value);
        partial void OnRegionChanged();
		
		private string _Region;
		public string Region { 
		    get{
		        return _Region;
		    } 
		    set{
		        this.OnRegionChanging(value);
                this.SendPropertyChanging();
                this._Region = value;
                this.SendPropertyChanged("Region");
                this.OnRegionChanged();
		    }
		}
		
        partial void OnCountryChanging(string value);
        partial void OnCountryChanged();
		
		private string _Country;
		public string Country { 
		    get{
		        return _Country;
		    } 
		    set{
		        this.OnCountryChanging(value);
                this.SendPropertyChanging();
                this._Country = value;
                this.SendPropertyChanged("Country");
                this.OnCountryChanged();
		    }
		}
		

        #endregion

        #region Foreign Keys
        #endregion


        private static PropertyChangingEventArgs emptyChangingEventArgs = new PropertyChangingEventArgs(String.Empty);
        public event PropertyChangingEventHandler PropertyChanging;
        public event PropertyChangedEventHandler PropertyChanged;
        protected virtual void SendPropertyChanging()
        {
            var handler = PropertyChanging;
            if (handler != null)
               handler(this, emptyChangingEventArgs);
        }

        protected virtual void SendPropertyChanged(String propertyName)
        {
            var handler = PropertyChanged;
            if (handler != null)
                handler(this, new PropertyChangedEventArgs(propertyName));
        }

	}
	
    
    
    /// <summary>
    /// A class which represents the Categories table in the SubSonic Database.
    /// This class is queryable through SubSonicDB.Category 
    /// </summary>

	public partial class Category: INotifyPropertyChanging, INotifyPropertyChanged
	{
        partial void OnLoaded();
        partial void OnValidate(System.Data.Linq.ChangeAction action);
        partial void OnCreated();
	    
	    public Category(){
	        OnCreated();
	    }
	    
	    #region Properties
	    
        partial void OnCategoryIDChanging(int value);
        partial void OnCategoryIDChanged();
		
		private int _CategoryID;
		public int CategoryID { 
		    get{
		        return _CategoryID;
		    } 
		    set{
		        this.OnCategoryIDChanging(value);
                this.SendPropertyChanging();
                this._CategoryID = value;
                this.SendPropertyChanged("CategoryID");
                this.OnCategoryIDChanged();
		    }
		}
		
        partial void OnCategoryNameChanging(string value);
        partial void OnCategoryNameChanged();
		
		private string _CategoryName;
		public string CategoryName { 
		    get{
		        return _CategoryName;
		    } 
		    set{
		        this.OnCategoryNameChanging(value);
                this.SendPropertyChanging();
                this._CategoryName = value;
                this.SendPropertyChanged("CategoryName");
                this.OnCategoryNameChanged();
		    }
		}
		

        #endregion

        #region Foreign Keys
        #endregion


        private static PropertyChangingEventArgs emptyChangingEventArgs = new PropertyChangingEventArgs(String.Empty);
        public event PropertyChangingEventHandler PropertyChanging;
        public event PropertyChangedEventHandler PropertyChanged;
        protected virtual void SendPropertyChanging()
        {
            var handler = PropertyChanging;
            if (handler != null)
               handler(this, emptyChangingEventArgs);
        }

        protected virtual void SendPropertyChanged(String propertyName)
        {
            var handler = PropertyChanged;
            if (handler != null)
                handler(this, new PropertyChangedEventArgs(propertyName));
        }

	}
	
    
    
    /// <summary>
    /// A class which represents the sysdiagrams table in the SubSonic Database.
    /// This class is queryable through SubSonicDB.sysdiagram 
    /// </summary>

	public partial class sysdiagram: INotifyPropertyChanging, INotifyPropertyChanged
	{
        partial void OnLoaded();
        partial void OnValidate(System.Data.Linq.ChangeAction action);
        partial void OnCreated();
	    
	    public sysdiagram(){
	        OnCreated();
	    }
	    
	    #region Properties
	    
        partial void OnnameChanging(string value);
        partial void OnnameChanged();
		
		private string _name;
		public string name { 
		    get{
		        return _name;
		    } 
		    set{
		        this.OnnameChanging(value);
                this.SendPropertyChanging();
                this._name = value;
                this.SendPropertyChanged("name");
                this.OnnameChanged();
		    }
		}
		
        partial void Onprincipal_idChanging(int value);
        partial void Onprincipal_idChanged();
		
		private int _principal_id;
		public int principal_id { 
		    get{
		        return _principal_id;
		    } 
		    set{
		        this.Onprincipal_idChanging(value);
                this.SendPropertyChanging();
                this._principal_id = value;
                this.SendPropertyChanged("principal_id");
                this.Onprincipal_idChanged();
		    }
		}
		
        partial void Ondiagram_idChanging(int value);
        partial void Ondiagram_idChanged();
		
		private int _diagram_id;
		public int diagram_id { 
		    get{
		        return _diagram_id;
		    } 
		    set{
		        this.Ondiagram_idChanging(value);
                this.SendPropertyChanging();
                this._diagram_id = value;
                this.SendPropertyChanged("diagram_id");
                this.Ondiagram_idChanged();
		    }
		}
		
        partial void OnversionChanging(int? value);
        partial void OnversionChanged();
		
		private int? _version;
		public int? version { 
		    get{
		        return _version;
		    } 
		    set{
		        this.OnversionChanging(value);
                this.SendPropertyChanging();
                this._version = value;
                this.SendPropertyChanged("version");
                this.OnversionChanged();
		    }
		}
		
        partial void OndefinitionChanging(byte[] value);
        partial void OndefinitionChanged();
		
		private byte[] _definition;
		public byte[] definition { 
		    get{
		        return _definition;
		    } 
		    set{
		        this.OndefinitionChanging(value);
                this.SendPropertyChanging();
                this._definition = value;
                this.SendPropertyChanged("definition");
                this.OndefinitionChanged();
		    }
		}
		

        #endregion

        #region Foreign Keys
        #endregion


        private static PropertyChangingEventArgs emptyChangingEventArgs = new PropertyChangingEventArgs(String.Empty);
        public event PropertyChangingEventHandler PropertyChanging;
        public event PropertyChangedEventHandler PropertyChanged;
        protected virtual void SendPropertyChanging()
        {
            var handler = PropertyChanging;
            if (handler != null)
               handler(this, emptyChangingEventArgs);
        }

        protected virtual void SendPropertyChanged(String propertyName)
        {
            var handler = PropertyChanged;
            if (handler != null)
                handler(this, new PropertyChangedEventArgs(propertyName));
        }

	}
	
    
    
    /// <summary>
    /// A class which represents the Shwerkos table in the SubSonic Database.
    /// This class is queryable through SubSonicDB.Shwerko 
    /// </summary>

	public partial class Shwerko: INotifyPropertyChanging, INotifyPropertyChanged
	{
        partial void OnLoaded();
        partial void OnValidate(System.Data.Linq.ChangeAction action);
        partial void OnCreated();
	    
	    public Shwerko(){
	        OnCreated();
	    }
	    
	    #region Properties
	    
        partial void OnIDChanging(int value);
        partial void OnIDChanged();
		
		private int _ID;
		public int ID { 
		    get{
		        return _ID;
		    } 
		    set{
		        this.OnIDChanging(value);
                this.SendPropertyChanging();
                this._ID = value;
                this.SendPropertyChanged("ID");
                this.OnIDChanged();
		    }
		}
		
        partial void OnKeyChanging(Guid value);
        partial void OnKeyChanged();
		
		private Guid _Key;
		public Guid Key { 
		    get{
		        return _Key;
		    } 
		    set{
		        this.OnKeyChanging(value);
                this.SendPropertyChanging();
                this._Key = value;
                this.SendPropertyChanged("Key");
                this.OnKeyChanged();
		    }
		}
		
        partial void OnNameChanging(string value);
        partial void OnNameChanged();
		
		private string _Name;
		public string Name { 
		    get{
		        return _Name;
		    } 
		    set{
		        this.OnNameChanging(value);
                this.SendPropertyChanging();
                this._Name = value;
                this.SendPropertyChanged("Name");
                this.OnNameChanged();
		    }
		}
		
        partial void OnElDateChanging(DateTime value);
        partial void OnElDateChanged();
		
		private DateTime _ElDate;
		public DateTime ElDate { 
		    get{
		        return _ElDate;
		    } 
		    set{
		        this.OnElDateChanging(value);
                this.SendPropertyChanging();
                this._ElDate = value;
                this.SendPropertyChanged("ElDate");
                this.OnElDateChanged();
		    }
		}
		
        partial void OnSomeNumberChanging(decimal value);
        partial void OnSomeNumberChanged();
		
		private decimal _SomeNumber;
		public decimal SomeNumber { 
		    get{
		        return _SomeNumber;
		    } 
		    set{
		        this.OnSomeNumberChanging(value);
                this.SendPropertyChanging();
                this._SomeNumber = value;
                this.SendPropertyChanged("SomeNumber");
                this.OnSomeNumberChanged();
		    }
		}
		
        partial void OnNullIntChanging(int? value);
        partial void OnNullIntChanged();
		
		private int? _NullInt;
		public int? NullInt { 
		    get{
		        return _NullInt;
		    } 
		    set{
		        this.OnNullIntChanging(value);
                this.SendPropertyChanging();
                this._NullInt = value;
                this.SendPropertyChanged("NullInt");
                this.OnNullIntChanged();
		    }
		}
		
        partial void OnNullSomeNumberChanging(decimal? value);
        partial void OnNullSomeNumberChanged();
		
		private decimal? _NullSomeNumber;
		public decimal? NullSomeNumber { 
		    get{
		        return _NullSomeNumber;
		    } 
		    set{
		        this.OnNullSomeNumberChanging(value);
                this.SendPropertyChanging();
                this._NullSomeNumber = value;
                this.SendPropertyChanged("NullSomeNumber");
                this.OnNullSomeNumberChanged();
		    }
		}
		
        partial void OnNullElDateChanging(DateTime? value);
        partial void OnNullElDateChanged();
		
		private DateTime? _NullElDate;
		public DateTime? NullElDate { 
		    get{
		        return _NullElDate;
		    } 
		    set{
		        this.OnNullElDateChanging(value);
                this.SendPropertyChanging();
                this._NullElDate = value;
                this.SendPropertyChanged("NullElDate");
                this.OnNullElDateChanged();
		    }
		}
		
        partial void OnNullKeyChanging(Guid? value);
        partial void OnNullKeyChanged();
		
		private Guid? _NullKey;
		public Guid? NullKey { 
		    get{
		        return _NullKey;
		    } 
		    set{
		        this.OnNullKeyChanging(value);
                this.SendPropertyChanging();
                this._NullKey = value;
                this.SendPropertyChanged("NullKey");
                this.OnNullKeyChanged();
		    }
		}
		
        partial void OnUnderscored_ColumnChanging(int value);
        partial void OnUnderscored_ColumnChanged();
		
		private int _Underscored_Column;
		public int Underscored_Column { 
		    get{
		        return _Underscored_Column;
		    } 
		    set{
		        this.OnUnderscored_ColumnChanging(value);
                this.SendPropertyChanging();
                this._Underscored_Column = value;
                this.SendPropertyChanged("Underscored_Column");
                this.OnUnderscored_ColumnChanged();
		    }
		}
		

        #endregion

        #region Foreign Keys
        #endregion


        private static PropertyChangingEventArgs emptyChangingEventArgs = new PropertyChangingEventArgs(String.Empty);
        public event PropertyChangingEventHandler PropertyChanging;
        public event PropertyChangedEventHandler PropertyChanged;
        protected virtual void SendPropertyChanging()
        {
            var handler = PropertyChanging;
            if (handler != null)
               handler(this, emptyChangingEventArgs);
        }

        protected virtual void SendPropertyChanged(String propertyName)
        {
            var handler = PropertyChanged;
            if (handler != null)
                handler(this, new PropertyChangedEventArgs(propertyName));
        }

	}
	
}