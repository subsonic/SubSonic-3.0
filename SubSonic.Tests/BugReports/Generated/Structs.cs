


using System;
using SubSonic.Schema;
using System.Collections.Generic;
using SubSonic.DataProviders;
using System.Data;

namespace SouthWind {
	
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
	                IsForeignKey = true
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
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("ContactTitle", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Address", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("City", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Region", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("PostalCode", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Country", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Phone", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Fax", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
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
            
            public IColumn ContactTitle{
                get{
                    return this.GetColumn("ContactTitle");
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
            
            public IColumn PostalCode{
                get{
                    return this.GetColumn("PostalCode");
                }
            }
            
            public IColumn Country{
                get{
                    return this.GetColumn("Country");
                }
            }
            
            public IColumn Phone{
                get{
                    return this.GetColumn("Phone");
                }
            }
            
            public IColumn Fax{
                get{
                    return this.GetColumn("Fax");
                }
            }
            
                    
        }
        
        /// <summary>
        /// Table: Shippers
        /// Primary Key: ShipperID
        /// </summary>

        public class ShippersTable: DatabaseTable {
            
            public ShippersTable(IDataProvider provider):base("Shippers",provider){
                ClassName = "Shipper";
                SchemaName = "dbo";
                

                Columns.Add(new DatabaseColumn("ShipperID", this)
                {
	                IsPrimaryKey = true,
	                DataType = DbType.Int32,
	                IsNullable = false,
	                AutoIncrement = true,
	                IsForeignKey = true
                });

                Columns.Add(new DatabaseColumn("CompanyName", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Phone", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });
                    
                
                
            }
            
            public IColumn ShipperID{
                get{
                    return this.GetColumn("ShipperID");
                }
            }
            
            public IColumn CompanyName{
                get{
                    return this.GetColumn("CompanyName");
                }
            }
            
            public IColumn Phone{
                get{
                    return this.GetColumn("Phone");
                }
            }
            
                    
        }
        
        /// <summary>
        /// Table: Suppliers
        /// Primary Key: SupplierID
        /// </summary>

        public class SuppliersTable: DatabaseTable {
            
            public SuppliersTable(IDataProvider provider):base("Suppliers",provider){
                ClassName = "Supplier";
                SchemaName = "dbo";
                

                Columns.Add(new DatabaseColumn("SupplierID", this)
                {
	                IsPrimaryKey = true,
	                DataType = DbType.Int32,
	                IsNullable = false,
	                AutoIncrement = true,
	                IsForeignKey = true
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
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("ContactTitle", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Address", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("City", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Region", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("PostalCode", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Country", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Phone", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Fax", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("HomePage", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });
                    
                
                
            }
            
            public IColumn SupplierID{
                get{
                    return this.GetColumn("SupplierID");
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
            
            public IColumn ContactTitle{
                get{
                    return this.GetColumn("ContactTitle");
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
            
            public IColumn PostalCode{
                get{
                    return this.GetColumn("PostalCode");
                }
            }
            
            public IColumn Country{
                get{
                    return this.GetColumn("Country");
                }
            }
            
            public IColumn Phone{
                get{
                    return this.GetColumn("Phone");
                }
            }
            
            public IColumn Fax{
                get{
                    return this.GetColumn("Fax");
                }
            }
            
            public IColumn HomePage{
                get{
                    return this.GetColumn("HomePage");
                }
            }
            
                    
        }
        
        /// <summary>
        /// Table: Order Details
        /// Primary Key: OrderID
        /// </summary>

        public class OrderDetailsTable: DatabaseTable {
            
            public OrderDetailsTable(IDataProvider provider):base("Order Details",provider){
                ClassName = "OrderDetail";
                SchemaName = "dbo";
                

                Columns.Add(new DatabaseColumn("OrderID", this)
                {
	                IsPrimaryKey = true,
	                DataType = DbType.Int32,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = true
                });

                Columns.Add(new DatabaseColumn("ProductID", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Int32,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = true
                });

                Columns.Add(new DatabaseColumn("UnitPrice", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Currency,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Quantity", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Int16,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Discount", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Single,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });
                    
                
                
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
        /// Table: CustomerCustomerDemo
        /// Primary Key: CustomerID
        /// </summary>

        public class CustomerCustomerDemoTable: DatabaseTable {
            
            public CustomerCustomerDemoTable(IDataProvider provider):base("CustomerCustomerDemo",provider){
                ClassName = "CustomerCustomerDemo";
                SchemaName = "dbo";
                

                Columns.Add(new DatabaseColumn("CustomerID", this)
                {
	                IsPrimaryKey = true,
	                DataType = DbType.String,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = true
                });

                Columns.Add(new DatabaseColumn("CustomerTypeID", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = true
                });
                    
                
                
            }
            
            public IColumn CustomerID{
                get{
                    return this.GetColumn("CustomerID");
                }
            }
            
            public IColumn CustomerTypeID{
                get{
                    return this.GetColumn("CustomerTypeID");
                }
            }
            
                    
        }
        
        /// <summary>
        /// Table: CustomerDemographics
        /// Primary Key: CustomerTypeID
        /// </summary>

        public class CustomerDemographicsTable: DatabaseTable {
            
            public CustomerDemographicsTable(IDataProvider provider):base("CustomerDemographics",provider){
                ClassName = "CustomerDemographic";
                SchemaName = "dbo";
                

                Columns.Add(new DatabaseColumn("CustomerTypeID", this)
                {
	                IsPrimaryKey = true,
	                DataType = DbType.String,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = true
                });

                Columns.Add(new DatabaseColumn("CustomerDesc", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });
                    
                
                
            }
            
            public IColumn CustomerTypeID{
                get{
                    return this.GetColumn("CustomerTypeID");
                }
            }
            
            public IColumn CustomerDesc{
                get{
                    return this.GetColumn("CustomerDesc");
                }
            }
            
                    
        }
        
        /// <summary>
        /// Table: Region
        /// Primary Key: RegionID
        /// </summary>

        public class RegionTable: DatabaseTable {
            
            public RegionTable(IDataProvider provider):base("Region",provider){
                ClassName = "Region";
                SchemaName = "dbo";
                

                Columns.Add(new DatabaseColumn("RegionID", this)
                {
	                IsPrimaryKey = true,
	                DataType = DbType.Int32,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = true
                });

                Columns.Add(new DatabaseColumn("RegionDescription", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });
                    
                
                
            }
            
            public IColumn RegionID{
                get{
                    return this.GetColumn("RegionID");
                }
            }
            
            public IColumn RegionDescription{
                get{
                    return this.GetColumn("RegionDescription");
                }
            }
            
                    
        }
        
        /// <summary>
        /// Table: Territories
        /// Primary Key: TerritoryID
        /// </summary>

        public class TerritoriesTable: DatabaseTable {
            
            public TerritoriesTable(IDataProvider provider):base("Territories",provider){
                ClassName = "Territory";
                SchemaName = "dbo";
                

                Columns.Add(new DatabaseColumn("TerritoryID", this)
                {
	                IsPrimaryKey = true,
	                DataType = DbType.String,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = true
                });

                Columns.Add(new DatabaseColumn("TerritoryDescription", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("RegionID", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Int32,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = true
                });
                    
                
                
            }
            
            public IColumn TerritoryID{
                get{
                    return this.GetColumn("TerritoryID");
                }
            }
            
            public IColumn TerritoryDescription{
                get{
                    return this.GetColumn("TerritoryDescription");
                }
            }
            
            public IColumn RegionID{
                get{
                    return this.GetColumn("RegionID");
                }
            }
            
                    
        }
        
        /// <summary>
        /// Table: EmployeeTerritories
        /// Primary Key: EmployeeID
        /// </summary>

        public class EmployeeTerritoriesTable: DatabaseTable {
            
            public EmployeeTerritoriesTable(IDataProvider provider):base("EmployeeTerritories",provider){
                ClassName = "EmployeeTerritory";
                SchemaName = "dbo";
                

                Columns.Add(new DatabaseColumn("EmployeeID", this)
                {
	                IsPrimaryKey = true,
	                DataType = DbType.Int32,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = true
                });

                Columns.Add(new DatabaseColumn("TerritoryID", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = true
                });
                    
                
                
            }
            
            public IColumn EmployeeID{
                get{
                    return this.GetColumn("EmployeeID");
                }
            }
            
            public IColumn TerritoryID{
                get{
                    return this.GetColumn("TerritoryID");
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
	                IsForeignKey = true
                });

                Columns.Add(new DatabaseColumn("CustomerID", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = true
                });

                Columns.Add(new DatabaseColumn("EmployeeID", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Int32,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = true
                });

                Columns.Add(new DatabaseColumn("OrderDate", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.DateTime,
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

                Columns.Add(new DatabaseColumn("ShipVia", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Int32,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = true
                });

                Columns.Add(new DatabaseColumn("Freight", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Currency,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("ShipName", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("ShipAddress", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("ShipCity", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("ShipRegion", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("ShipPostalCode", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("ShipCountry", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
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
            
            public IColumn CustomerID{
                get{
                    return this.GetColumn("CustomerID");
                }
            }
            
            public IColumn EmployeeID{
                get{
                    return this.GetColumn("EmployeeID");
                }
            }
            
            public IColumn OrderDate{
                get{
                    return this.GetColumn("OrderDate");
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
            
            public IColumn ShipVia{
                get{
                    return this.GetColumn("ShipVia");
                }
            }
            
            public IColumn Freight{
                get{
                    return this.GetColumn("Freight");
                }
            }
            
            public IColumn ShipName{
                get{
                    return this.GetColumn("ShipName");
                }
            }
            
            public IColumn ShipAddress{
                get{
                    return this.GetColumn("ShipAddress");
                }
            }
            
            public IColumn ShipCity{
                get{
                    return this.GetColumn("ShipCity");
                }
            }
            
            public IColumn ShipRegion{
                get{
                    return this.GetColumn("ShipRegion");
                }
            }
            
            public IColumn ShipPostalCode{
                get{
                    return this.GetColumn("ShipPostalCode");
                }
            }
            
            public IColumn ShipCountry{
                get{
                    return this.GetColumn("ShipCountry");
                }
            }
            
                    
        }
        
        /// <summary>
        /// Table: SubSonicTests
        /// Primary Key: SubSonicTestID
        /// </summary>

        public class SubSonicTestsTable: DatabaseTable {
            
            public SubSonicTestsTable(IDataProvider provider):base("SubSonicTests",provider){
                ClassName = "SubSonicTest";
                SchemaName = "dbo";
                

                Columns.Add(new DatabaseColumn("SubSonicTestID", this)
                {
	                IsPrimaryKey = true,
	                DataType = DbType.Int32,
	                IsNullable = false,
	                AutoIncrement = true,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Thinger", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Int32,
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

                Columns.Add(new DatabaseColumn("UserName", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("CreatedOn", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.DateTime,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Price", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Decimal,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Discount", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Double,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Lat", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Decimal,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Long", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Decimal,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("SomeFlag", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Boolean,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("SomeNullableFlag", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Boolean,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("LongText", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("MediumText", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });
                    
                
                
            }
            
            public IColumn SubSonicTestID{
                get{
                    return this.GetColumn("SubSonicTestID");
                }
            }
            
            public IColumn Thinger{
                get{
                    return this.GetColumn("Thinger");
                }
            }
            
            public IColumn Name{
                get{
                    return this.GetColumn("Name");
                }
            }
            
            public IColumn UserName{
                get{
                    return this.GetColumn("UserName");
                }
            }
            
            public IColumn CreatedOn{
                get{
                    return this.GetColumn("CreatedOn");
                }
            }
            
            public IColumn Price{
                get{
                    return this.GetColumn("Price");
                }
            }
            
            public IColumn Discount{
                get{
                    return this.GetColumn("Discount");
                }
            }
            
            public IColumn Lat{
                get{
                    return this.GetColumn("Lat");
                }
            }
            
            public IColumn Long{
                get{
                    return this.GetColumn("Long");
                }
            }
            
            public IColumn SomeFlag{
                get{
                    return this.GetColumn("SomeFlag");
                }
            }
            
            public IColumn SomeNullableFlag{
                get{
                    return this.GetColumn("SomeNullableFlag");
                }
            }
            
            public IColumn LongText{
                get{
                    return this.GetColumn("LongText");
                }
            }
            
            public IColumn MediumText{
                get{
                    return this.GetColumn("MediumText");
                }
            }
            
                    
        }
        
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
	                IsForeignKey = true
                });

                Columns.Add(new DatabaseColumn("ProductName", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("SupplierID", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Int32,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = true
                });

                Columns.Add(new DatabaseColumn("CategoryID", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Int32,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = true
                });

                Columns.Add(new DatabaseColumn("QuantityPerUnit", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("UnitPrice", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Currency,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("UnitsInStock", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Int16,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("UnitsOnOrder", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Int64,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("ReorderLevel", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Int16,
	                IsNullable = true,
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
            
            public IColumn ProductName{
                get{
                    return this.GetColumn("ProductName");
                }
            }
            
            public IColumn SupplierID{
                get{
                    return this.GetColumn("SupplierID");
                }
            }
            
            public IColumn CategoryID{
                get{
                    return this.GetColumn("CategoryID");
                }
            }
            
            public IColumn QuantityPerUnit{
                get{
                    return this.GetColumn("QuantityPerUnit");
                }
            }
            
            public IColumn UnitPrice{
                get{
                    return this.GetColumn("UnitPrice");
                }
            }
            
            public IColumn UnitsInStock{
                get{
                    return this.GetColumn("UnitsInStock");
                }
            }
            
            public IColumn UnitsOnOrder{
                get{
                    return this.GetColumn("UnitsOnOrder");
                }
            }
            
            public IColumn ReorderLevel{
                get{
                    return this.GetColumn("ReorderLevel");
                }
            }
            
            public IColumn Discontinued{
                get{
                    return this.GetColumn("Discontinued");
                }
            }
            
                    
        }
        
        /// <summary>
        /// Table: Employees
        /// Primary Key: EmployeeID
        /// </summary>

        public class EmployeesTable: DatabaseTable {
            
            public EmployeesTable(IDataProvider provider):base("Employees",provider){
                ClassName = "Employee";
                SchemaName = "dbo";
                

                Columns.Add(new DatabaseColumn("EmployeeID", this)
                {
	                IsPrimaryKey = true,
	                DataType = DbType.Int32,
	                IsNullable = false,
	                AutoIncrement = true,
	                IsForeignKey = true
                });

                Columns.Add(new DatabaseColumn("LastName", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("FirstName", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Title", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("TitleOfCourtesy", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("BirthDate", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.DateTime,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("HireDate", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.DateTime,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Address", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("City", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Region", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("PostalCode", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Country", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("HomePhone", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Extension", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Photo", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Binary,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Notes", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("ReportsTo", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Int32,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = true
                });

                Columns.Add(new DatabaseColumn("PhotoPath", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });
                    
                
                
            }
            
            public IColumn EmployeeID{
                get{
                    return this.GetColumn("EmployeeID");
                }
            }
            
            public IColumn LastName{
                get{
                    return this.GetColumn("LastName");
                }
            }
            
            public IColumn FirstName{
                get{
                    return this.GetColumn("FirstName");
                }
            }
            
            public IColumn Title{
                get{
                    return this.GetColumn("Title");
                }
            }
            
            public IColumn TitleOfCourtesy{
                get{
                    return this.GetColumn("TitleOfCourtesy");
                }
            }
            
            public IColumn BirthDate{
                get{
                    return this.GetColumn("BirthDate");
                }
            }
            
            public IColumn HireDate{
                get{
                    return this.GetColumn("HireDate");
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
            
            public IColumn PostalCode{
                get{
                    return this.GetColumn("PostalCode");
                }
            }
            
            public IColumn Country{
                get{
                    return this.GetColumn("Country");
                }
            }
            
            public IColumn HomePhone{
                get{
                    return this.GetColumn("HomePhone");
                }
            }
            
            public IColumn Extension{
                get{
                    return this.GetColumn("Extension");
                }
            }
            
            public IColumn Photo{
                get{
                    return this.GetColumn("Photo");
                }
            }
            
            public IColumn Notes{
                get{
                    return this.GetColumn("Notes");
                }
            }
            
            public IColumn ReportsTo{
                get{
                    return this.GetColumn("ReportsTo");
                }
            }
            
            public IColumn PhotoPath{
                get{
                    return this.GetColumn("PhotoPath");
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
	                IsForeignKey = true
                });

                Columns.Add(new DatabaseColumn("CategoryName", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = false,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Description", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.String,
	                IsNullable = true,
	                AutoIncrement = false,
	                IsForeignKey = false
                });

                Columns.Add(new DatabaseColumn("Picture", this)
                {
	                IsPrimaryKey = false,
	                DataType = DbType.Binary,
	                IsNullable = true,
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
            
            public IColumn Description{
                get{
                    return this.GetColumn("Description");
                }
            }
            
            public IColumn Picture{
                get{
                    return this.GetColumn("Picture");
                }
            }
            
                    
        }
        
}