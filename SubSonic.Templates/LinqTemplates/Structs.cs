


using System;
using SubSonic.Schema;
using System.Collections.Generic;
using SubSonic.DataProviders;
using System.Data;

namespace WestWind {
	
        /// <summary>
        /// Table: Products
        /// Primary Key: ProductID
        /// </summary>

        public class ProductsTable: DatabaseTable {
            
            public ProductsTable(IDataProvider provider):base("Products",provider){
                ClassName = "Product";
                SchemaName = "dbo";
                

                Columns.Add(new DatabaseColumn("ProductID", this)
                {
	                IsPrimaryKey = true,
	                DataType = DbType.Int32,
	                IsNullable = false,
	                AutoIncrement = true,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Sku", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Guid,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("CategoryID", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Int32,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("ProductName", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("UnitPrice", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Decimal,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Discontinued", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Boolean,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });
                    
                
                
            }
            
            public IColumn ProductID{
                get{
                    return this.GetColumn("ProductID");
                }
            }
            
            public IColumn Sku{
                get{
                    return this.GetColumn("Sku");
                }
            }
            
            public IColumn CategoryID{
                get{
                    return this.GetColumn("CategoryID");
                }
            }
            
            public IColumn ProductName{
                get{
                    return this.GetColumn("ProductName");
                }
            }
            
            public IColumn UnitPrice{
                get{
                    return this.GetColumn("UnitPrice");
                }
            }
            
            public IColumn Discontinued{
                get{
                    return this.GetColumn("Discontinued");
                }
            }
            
                    
        }
        
        /// <summary>
        /// Table: Orders
        /// Primary Key: OrderID
        /// </summary>

        public class OrdersTable: DatabaseTable {
            
            public OrdersTable(IDataProvider provider):base("Orders",provider){
                ClassName = "Order";
                SchemaName = "dbo";
                

                Columns.Add(new DatabaseColumn("OrderID", this)
                {
	                IsPrimaryKey = true,
	                DataType = DbType.Int32,
	                IsNullable = false,
	                AutoIncrement = true,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("OrderDate", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.DateTime,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("CustomerID", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("RequiredDate", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.DateTime,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("ShippedDate", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.DateTime,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });
                    
                
                
            }
            
            public IColumn OrderID{
                get{
                    return this.GetColumn("OrderID");
                }
            }
            
            public IColumn OrderDate{
                get{
                    return this.GetColumn("OrderDate");
                }
            }
            
            public IColumn CustomerID{
                get{
                    return this.GetColumn("CustomerID");
                }
            }
            
            public IColumn RequiredDate{
                get{
                    return this.GetColumn("RequiredDate");
                }
            }
            
            public IColumn ShippedDate{
                get{
                    return this.GetColumn("ShippedDate");
                }
            }
            
                    
        }
        
        /// <summary>
        /// Table: OrderDetails
        /// Primary Key: OrderDetailID
        /// </summary>

        public class OrderDetailsTable: DatabaseTable {
            
            public OrderDetailsTable(IDataProvider provider):base("OrderDetails",provider){
                ClassName = "OrderDetail";
                SchemaName = "dbo";
                

                Columns.Add(new DatabaseColumn("OrderDetailID", this)
                {
	                IsPrimaryKey = true,
	                DataType = DbType.Int32,
	                IsNullable = false,
	                AutoIncrement = true,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("OrderID", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Int32,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("ProductID", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Int32,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("UnitPrice", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Decimal,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Quantity", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Int32,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Discount", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Decimal,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });
                    
                
                
            }
            
            public IColumn OrderDetailID{
                get{
                    return this.GetColumn("OrderDetailID");
                }
            }
            
            public IColumn OrderID{
                get{
                    return this.GetColumn("OrderID");
                }
            }
            
            public IColumn ProductID{
                get{
                    return this.GetColumn("ProductID");
                }
            }
            
            public IColumn UnitPrice{
                get{
                    return this.GetColumn("UnitPrice");
                }
            }
            
            public IColumn Quantity{
                get{
                    return this.GetColumn("Quantity");
                }
            }
            
            public IColumn Discount{
                get{
                    return this.GetColumn("Discount");
                }
            }
            
                    
        }
        
        /// <summary>
        /// Table: Customers
        /// Primary Key: CustomerID
        /// </summary>

        public class CustomersTable: DatabaseTable {
            
            public CustomersTable(IDataProvider provider):base("Customers",provider){
                ClassName = "Customer";
                SchemaName = "dbo";
                

                Columns.Add(new DatabaseColumn("CustomerID", this)
                {
	                IsPrimaryKey = true,
	                DataType = DbType.String,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("CompanyName", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("ContactName", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Address", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("City", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Region", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Country", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });
                    
                
                
            }
            
            public IColumn CustomerID{
                get{
                    return this.GetColumn("CustomerID");
                }
            }
            
            public IColumn CompanyName{
                get{
                    return this.GetColumn("CompanyName");
                }
            }
            
            public IColumn ContactName{
                get{
                    return this.GetColumn("ContactName");
                }
            }
            
            public IColumn Address{
                get{
                    return this.GetColumn("Address");
                }
            }
            
            public IColumn City{
                get{
                    return this.GetColumn("City");
                }
            }
            
            public IColumn Region{
                get{
                    return this.GetColumn("Region");
                }
            }
            
            public IColumn Country{
                get{
                    return this.GetColumn("Country");
                }
            }
            
                    
        }
        
        /// <summary>
        /// Table: Categories
        /// Primary Key: CategoryID
        /// </summary>

        public class CategoriesTable: DatabaseTable {
            
            public CategoriesTable(IDataProvider provider):base("Categories",provider){
                ClassName = "Category";
                SchemaName = "dbo";
                

                Columns.Add(new DatabaseColumn("CategoryID", this)
                {
	                IsPrimaryKey = true,
	                DataType = DbType.Int32,
	                IsNullable = false,
	                AutoIncrement = true,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("CategoryName", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });
                    
                
                
            }
            
            public IColumn CategoryID{
                get{
                    return this.GetColumn("CategoryID");
                }
            }
            
            public IColumn CategoryName{
                get{
                    return this.GetColumn("CategoryName");
                }
            }
            
                    
        }
        
        /// <summary>
        /// Table: Shwerkos
        /// Primary Key: ID
        /// </summary>

        public class ShwerkosTable: DatabaseTable {
            
            public ShwerkosTable(IDataProvider provider):base("Shwerkos",provider){
                ClassName = "Shwerko";
                SchemaName = "dbo";
                

                Columns.Add(new DatabaseColumn("ID", this)
                {
	                IsPrimaryKey = true,
	                DataType = DbType.Int32,
	                IsNullable = false,
	                AutoIncrement = true,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Key", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Guid,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Name", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("ElDate", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.DateTime,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("SomeNumber", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Decimal,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("NullInt", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Int32,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("NullSomeNumber", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Decimal,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("NullElDate", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.DateTime,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("NullKey", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Guid,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Underscored_Column", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Int32,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });
                    
                
                
            }
            
            public IColumn ID{
                get{
                    return this.GetColumn("ID");
                }
            }
            
            public IColumn Key{
                get{
                    return this.GetColumn("Key");
                }
            }
            
            public IColumn Name{
                get{
                    return this.GetColumn("Name");
                }
            }
            
            public IColumn ElDate{
                get{
                    return this.GetColumn("ElDate");
                }
            }
            
            public IColumn SomeNumber{
                get{
                    return this.GetColumn("SomeNumber");
                }
            }
            
            public IColumn NullInt{
                get{
                    return this.GetColumn("NullInt");
                }
            }
            
            public IColumn NullSomeNumber{
                get{
                    return this.GetColumn("NullSomeNumber");
                }
            }
            
            public IColumn NullElDate{
                get{
                    return this.GetColumn("NullElDate");
                }
            }
            
            public IColumn NullKey{
                get{
                    return this.GetColumn("NullKey");
                }
            }
            
            public IColumn Underscored_Column{
                get{
                    return this.GetColumn("Underscored_Column");
                }
            }
            
                    
        }
        
}