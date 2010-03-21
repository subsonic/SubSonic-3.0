# SQL Manager 2005 for MySQL 3.7.0.1
# ---------------------------------------
# Host     : dev2
# Port     : 3306
# Database : Northwind


SET FOREIGN_KEY_CHECKS=0;

CREATE DATABASE `Northwind`
    CHARACTER SET 'utf8'
    COLLATE 'utf8_general_ci';

USE `Northwind`;

#
# Structure for the `Categories` table : 
#

CREATE TABLE `Categories` (
  `CategoryID` int(10) NOT NULL auto_increment,
  `CategoryName` varchar(15) NOT NULL,
  `Description` longtext,
  `Picture` longblob,
  PRIMARY KEY  (`CategoryID`),
  KEY `CategoryName` (`CategoryName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Structure for the `CustomerDemographics` table : 
#

CREATE TABLE `CustomerDemographics` (
  `CustomerTypeID` char(10) NOT NULL,
  `CustomerDesc` longtext,
  PRIMARY KEY  (`CustomerTypeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Structure for the `Customers` table : 
#

CREATE TABLE `Customers` (
  `CustomerID` char(5) NOT NULL,
  `CompanyName` varchar(40) NOT NULL,
  `ContactName` varchar(30) default NULL,
  `ContactTitle` varchar(30) default NULL,
  `Address` varchar(60) default NULL,
  `City` varchar(15) default NULL,
  `Region` varchar(15) default NULL,
  `PostalCode` varchar(10) default NULL,
  `Country` varchar(15) default NULL,
  `Phone` varchar(24) default NULL,
  `Fax` varchar(24) default NULL,
  PRIMARY KEY  (`CustomerID`),
  KEY `City` (`City`),
  KEY `CompanyName` (`CompanyName`),
  KEY `PostalCode` (`PostalCode`),
  KEY `Region` (`Region`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Structure for the `CustomerCustomerDemo` table : 
#

CREATE TABLE `CustomerCustomerDemo` (
  `CustomerID` char(5) NOT NULL,
  `CustomerTypeID` char(10) NOT NULL,
  PRIMARY KEY  (`CustomerID`,`CustomerTypeID`),
  KEY `FK_CustomerCustomerDemo` (`CustomerTypeID`),
  CONSTRAINT `FK_CustomerCustomerDemo` FOREIGN KEY (`CustomerTypeID`) REFERENCES `customerdemographics` (`CustomerTypeID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_CustomerCustomerDemo_Customers` FOREIGN KEY (`CustomerID`) REFERENCES `customers` (`CustomerID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Structure for the `Employees` table : 
#

CREATE TABLE `Employees` (
  `EmployeeID` int(10) NOT NULL auto_increment,
  `LastName` varchar(20) NOT NULL,
  `FirstName` varchar(10) NOT NULL,
  `Title` varchar(30) default NULL,
  `TitleOfCourtesy` varchar(25) default NULL,
  `BirthDate` datetime default NULL,
  `HireDate` datetime default NULL,
  `Address` varchar(60) default NULL,
  `City` varchar(15) default NULL,
  `Region` varchar(15) default NULL,
  `PostalCode` varchar(10) default NULL,
  `Country` varchar(15) default NULL,
  `HomePhone` varchar(24) default NULL,
  `Extension` varchar(4) default NULL,
  `Photo` longblob,
  `Notes` longtext,
  `ReportsTo` int(10) default NULL,
  `PhotoPath` varchar(255) default NULL,
  PRIMARY KEY  (`EmployeeID`),
  KEY `LastName` (`LastName`),
  KEY `PostalCode` (`PostalCode`),
  KEY `FK_Employees_Employees` (`ReportsTo`),
  CONSTRAINT `FK_Employees_Employees` FOREIGN KEY (`ReportsTo`) REFERENCES `employees` (`EmployeeID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Structure for the `Region` table : 
#

CREATE TABLE `Region` (
  `RegionID` int(10) NOT NULL,
  `RegionDescription` char(50) NOT NULL,
  PRIMARY KEY  (`RegionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Structure for the `Territories` table : 
#

CREATE TABLE `Territories` (
  `TerritoryID` varchar(20) NOT NULL,
  `TerritoryDescription` char(50) NOT NULL,
  `RegionID` int(10) NOT NULL,
  PRIMARY KEY  (`TerritoryID`),
  KEY `FK_Territories_Region` (`RegionID`),
  CONSTRAINT `FK_Territories_Region` FOREIGN KEY (`RegionID`) REFERENCES `region` (`RegionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Structure for the `EmployeeTerritories` table : 
#

CREATE TABLE `EmployeeTerritories` (
  `EmployeeID` int(10) NOT NULL,
  `TerritoryID` varchar(20) NOT NULL,
  PRIMARY KEY  (`EmployeeID`,`TerritoryID`),
  KEY `FK_EmployeeTerritories_Territories` (`TerritoryID`),
  CONSTRAINT `FK_EmployeeTerritories_Employees` FOREIGN KEY (`EmployeeID`) REFERENCES `employees` (`EmployeeID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_EmployeeTerritories_Territories` FOREIGN KEY (`TerritoryID`) REFERENCES `territories` (`TerritoryID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Structure for the `Shippers` table : 
#

CREATE TABLE `Shippers` (
  `ShipperID` int(10) NOT NULL auto_increment,
  `CompanyName` varchar(40) NOT NULL,
  `Phone` varchar(24) default NULL,
  PRIMARY KEY  (`ShipperID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Structure for the `Orders` table : 
#

CREATE TABLE `Orders` (
  `OrderID` int(10) NOT NULL auto_increment,
  `CustomerID` char(5) default NULL,
  `EmployeeID` int(10) default NULL,
  `OrderDate` datetime NOT NULL,
  `RequiredDate` datetime default NULL,
  `ShippedDate` datetime default NULL,
  `ShipVia` int(10) default NULL,
  `Freight` decimal(19,4) default '0.0000',
  `ShipName` varchar(40) default NULL,
  `ShipAddress` varchar(60) default NULL,
  `ShipCity` varchar(15) default NULL,
  `ShipRegion` varchar(15) default NULL,
  `ShipPostalCode` varchar(10) default NULL,
  `ShipCountry` varchar(15) default NULL,
  PRIMARY KEY  (`OrderID`),
  KEY `CustomerID` (`CustomerID`),
  KEY `CustomersOrders` (`CustomerID`),
  KEY `EmployeeID` (`EmployeeID`),
  KEY `EmployeesOrders` (`EmployeeID`),
  KEY `OrderDate` (`OrderDate`),
  KEY `ShippedDate` (`ShippedDate`),
  KEY `ShippersOrders` (`ShipVia`),
  KEY `ShipPostalCode` (`ShipPostalCode`),
  CONSTRAINT `FK_Orders_Customers` FOREIGN KEY (`CustomerID`) REFERENCES `customers` (`CustomerID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Orders_Employees` FOREIGN KEY (`EmployeeID`) REFERENCES `employees` (`EmployeeID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Orders_Shippers` FOREIGN KEY (`ShipVia`) REFERENCES `shippers` (`ShipperID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Structure for the `Suppliers` table : 
#

CREATE TABLE `Suppliers` (
  `SupplierID` int(10) NOT NULL auto_increment,
  `CompanyName` varchar(40) NOT NULL,
  `ContactName` varchar(30) default NULL,
  `ContactTitle` varchar(30) default NULL,
  `Address` varchar(60) default NULL,
  `City` varchar(15) default NULL,
  `Region` varchar(15) default NULL,
  `PostalCode` varchar(10) default NULL,
  `Country` varchar(15) default NULL,
  `Phone` varchar(24) default NULL,
  `Fax` varchar(24) default NULL,
  `HomePage` longtext,
  PRIMARY KEY  (`SupplierID`),
  KEY `CompanyName` (`CompanyName`),
  KEY `PostalCode` (`PostalCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Structure for the `Products` table : 
#

CREATE TABLE `Products` (
  `ProductID` int(10) NOT NULL auto_increment,
  `ProductName` varchar(40) NOT NULL,
  `SupplierID` int(10) default NULL,
  `CategoryID` int(10) default NULL,
  `QuantityPerUnit` varchar(20) default NULL,
  `UnitPrice` decimal(19,4) default '0.0000',
  `UnitsInStock` smallint(5) default '0',
  `UnitsOnOrder` smallint(5) default '0',
  `ReorderLevel` smallint(5) default '0',
  `Discontinued` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`ProductID`),
  KEY `CategoriesProducts` (`CategoryID`),
  KEY `CategoryID` (`CategoryID`),
  KEY `ProductName` (`ProductName`),
  KEY `SupplierID` (`SupplierID`),
  KEY `SuppliersProducts` (`SupplierID`),
  CONSTRAINT `FK_Products_Categories` FOREIGN KEY (`CategoryID`) REFERENCES `categories` (`CategoryID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Products_Suppliers` FOREIGN KEY (`SupplierID`) REFERENCES `suppliers` (`SupplierID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Structure for the `Order Details` table : 
#

CREATE TABLE `Order Details` (
  `OrderID` int(10) NOT NULL,
  `ProductID` int(10) NOT NULL,
  `UnitPrice` decimal(19,4) NOT NULL default '0.0000',
  `Quantity` smallint(5) NOT NULL default '1',
  `Discount` float NOT NULL default '0',
  PRIMARY KEY  (`OrderID`,`ProductID`),
  KEY `OrderID` (`OrderID`),
  KEY `OrdersOrder_Details` (`OrderID`),
  KEY `ProductID` (`ProductID`),
  KEY `ProductsOrder_Details` (`ProductID`),
  CONSTRAINT `FK_Order_Details_Orders` FOREIGN KEY (`OrderID`) REFERENCES `orders` (`OrderID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Order_Details_Products` FOREIGN KEY (`ProductID`) REFERENCES `products` (`ProductID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Definition for the `CustOrderHist` procedure : 
#

CREATE PROCEDURE `CustOrderHist`(IN CustomerID CHAR(5))
    DETERMINISTIC
    SQL SECURITY DEFINER
    COMMENT ''
SELECT P.ProductName, SUM(Quantity) as Total
FROM Products P, `Order Details` OD, Orders O, Customers C
WHERE C.CustomerID = CustomerID
      AND C.CustomerID = O.CustomerID
      AND O.OrderID = OD.OrderID
      AND OD.ProductID = P.ProductID
GROUP BY P.ProductName;

#
# Definition for the `CustOrdersDetail` procedure : 
#

CREATE PROCEDURE `CustOrdersDetail`(IN OrderID INTEGER(11))
    NOT DETERMINISTIC
    SQL SECURITY DEFINER
    COMMENT ''
SELECT P.ProductName,
       ROUND(Od.UnitPrice, 2) as UnitPrice,
       Od.Quantity,
       CAST(Discount * 100 as decimal(9,0)) as Discount,
       ROUND(CAST(Od.Quantity * (1 - Discount) * Od.UnitPrice as decimal), 2) as ExtendedPrice
FROM Products P, `Order Details` Od
WHERE Od.ProductID = P.ProductID
      AND Od.OrderID = OrderID;

#
# Definition for the `CustOrdersOrders` procedure : 
#

CREATE PROCEDURE `CustOrdersOrders`(IN CustomerID CHAR(5))
    NOT DETERMINISTIC
    SQL SECURITY DEFINER
    COMMENT ''
SELECT OrderID,
       OrderDate,
       RequiredDate,
       ShippedDate
FROM Orders O
WHERE O.CustomerID = CustomerID
ORDER BY OrderID;

#
# Definition for the `Employee Sales By Country` procedure : 
#

CREATE PROCEDURE `Employee Sales By Country`(IN Beginning_date DATETIME, IN Ending_date DATETIME)
    NOT DETERMINISTIC
    SQL SECURITY DEFINER
    COMMENT ''
SELECT Employees.Country,
       Employees.LastName,
       Employees.`FirstName`,
       Orders.`ShippedDate`,
       Orders.`OrderID`,
       `order subtotals`.`Subtotal` as SaleAmount
FROM Employees
     INNER JOIN (Orders INNER JOIN `order subtotals` ON Orders.OrderID = `order subtotals`.`OrderID`)
           ON Employees.`EmployeeID` = Orders.`EmployeeID`
WHERE Orders.ShippedDate BETWEEN Beginning_Date AND Ending_Date;

#
# Definition for the `Sales by Year` procedure : 
#

CREATE PROCEDURE `Sales by Year`(IN Beginning_Date DATETIME, IN Ending_Date DATETIME)
    NOT DETERMINISTIC
    SQL SECURITY DEFINER
    COMMENT ''
SELECT
      Orders.`ShippedDate`,
      Orders.`OrderID`,
      `Order Subtotals`.Subtotal,
      YEAR(Orders.`ShippedDate`) as Year
FROM  `Orders`
      INNER JOIN `Order Subtotals` ON Orders.OrderID = `Order Subtotals`.OrderID
WHERE Orders.ShippedDate BETWEEN Beginning_Date AND Ending_Date;

#
# Definition for the `SalesByCategory` procedure : 
#
DELIMITER ;;

CREATE PROCEDURE `SalesByCategory`(IN CategoryName VARCHAR(15), IN OrdYear VARCHAR(4))
    NOT DETERMINISTIC
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
     IF (OrdYear <>  '1996' AND OrdYear <> '1997' AND OrdYear <> '1998')
        THEN SELECT OrdYear = '1998';
     END IF;
     
     SELECT
            P.`ProductName`,
            ROUND(SUM(CAST(OD.Quantity * (1 - OD.Discount) * OD.UnitPrice as DECIMAL(14,2))), 0) as TotalPurchase
     FROM `Order Details` OD, Orders O, Products P, Categories C
     WHERE OD.`OrderID` = O.`OrderID`
           AND OD.`ProductID` = P.`ProductID`
           AND P.`CategoryID` = C.`CategoryID`
           AND C.`CategoryName` = CategoryName
           AND YEAR(O.`OrderDate`) = OrdYear
     GROUP BY P.`ProductName`
     ORDER BY P.`ProductName`;
END;;

DELIMITER ;

#
# Definition for the `Ten Most Expensive Products` procedure : 
#

CREATE PROCEDURE `Ten Most Expensive Products`()
    NOT DETERMINISTIC
    SQL SECURITY DEFINER
    COMMENT ''
SELECT
      Products.`ProductName` as TenMostExpensiveProducts,
      Products.`UnitPrice`
FROM  Products
ORDER BY Products.`UnitPrice` DESC
LIMIT 10;

#
# Definition for the `Alphabetical list of products` view :
#

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `Alphabetical list of products` AS
  select 
    `products`.`ProductID` AS `ProductID`,
    `products`.`ProductName` AS `ProductName`,
    `products`.`SupplierID` AS `SupplierID`,
    `products`.`CategoryID` AS `CategoryID`,
    `products`.`QuantityPerUnit` AS `QuantityPerUnit`,
    `products`.`UnitPrice` AS `UnitPrice`,
    `products`.`UnitsInStock` AS `UnitsInStock`,
    `products`.`UnitsOnOrder` AS `UnitsOnOrder`,
    `products`.`ReorderLevel` AS `ReorderLevel`,
    `products`.`Discontinued` AS `Discontinued`,
    `categories`.`CategoryName` AS `CategoryName` 
  from 
    (`categories` join `products` on((`categories`.`CategoryID` = `products`.`CategoryID`))) 
  where 
    (`products`.`Discontinued` = 0);
    
#
# Definition for the `Product Sales for 1997` view :
#

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `Product Sales for 1997` AS
  select
    `categories`.`CategoryName` AS `CategoryName`,
    `products`.`ProductName` AS `ProductName`,
    sum(cast(((((`order details`.`UnitPrice` * `order details`.`Quantity`) * (1 - `order details`.`Discount`)) / 100) * 100) as decimal)) AS `ProductSales`
  from
    ((`categories` join `products` on((`categories`.`CategoryID` = `products`.`CategoryID`))) join (`orders` join `order details` on((`orders`.`OrderID` = `order details`.`OrderID`))) on((`products`.`ProductID` = `order details`.`ProductID`)))
  where
    (`orders`.`ShippedDate` between '19970101' and '19971231')
  group by
    `categories`.`CategoryName`,`products`.`ProductName`;

#
# Definition for the `Category Sales for 1997` view :
#

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `Category Sales for 1997` AS
  select 
    `Product Sales for 1997`.`CategoryName` AS `CategoryName`,
    sum(`Product Sales for 1997`.`ProductSales`) AS `CategorySales`
  from 
    `Product Sales for 1997`
  group by 
    `Product Sales for 1997`.`CategoryName`;

#
# Definition for the `Current Product List` view :
#

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `Current Product List` AS
  select 
    `Product_List`.`ProductID` AS `ProductID`,
    `Product_List`.`ProductName` AS `ProductName` 
  from 
    `products` `Product_List` 
  where 
    (`Product_List`.`Discontinued` = 0);

#
# Definition for the `Customer and Suppliers by City` view :
#

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `Customer and Suppliers by City` AS
  select 
    `customers`.`City` AS `City`,
    `customers`.`CompanyName` AS `CompanyName`,
    `customers`.`ContactName` AS `ContactName`,
    'Customers' AS `Relationship` 
  from 
    `customers` union 
  select 
    `suppliers`.`City` AS `City`,
    `suppliers`.`CompanyName` AS `CompanyName`,
    `suppliers`.`ContactName` AS `ContactName`,
    'Suppliers' AS `Suppliers` 
  from 
    `suppliers`;

#
# Definition for the `Invoices` view :
#

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `Invoices` AS
  select 
    `orders`.`ShipName` AS `ShipName`,
    `orders`.`ShipAddress` AS `ShipAddress`,
    `orders`.`ShipCity` AS `ShipCity`,
    `orders`.`ShipRegion` AS `ShipRegion`,
    `orders`.`ShipPostalCode` AS `ShipPostalCode`,
    `orders`.`ShipCountry` AS `ShipCountry`,
    `orders`.`CustomerID` AS `CustomerID`,
    `customers`.`CompanyName` AS `CustomerName`,
    `customers`.`Address` AS `Address`,
    `customers`.`City` AS `City`,
    `customers`.`Region` AS `Region`,
    `customers`.`PostalCode` AS `PostalCode`,
    `customers`.`Country` AS `Country`,
    ((`employees`.`FirstName` + ' ') + `employees`.`LastName`) AS `Salesperson`,
    `orders`.`OrderID` AS `OrderID`,
    `orders`.`OrderDate` AS `OrderDate`,
    `orders`.`RequiredDate` AS `RequiredDate`,
    `orders`.`ShippedDate` AS `ShippedDate`,
    `shippers`.`CompanyName` AS `ShipperName`,
    `order details`.`ProductID` AS `ProductID`,
    `products`.`ProductName` AS `ProductName`,
    `order details`.`UnitPrice` AS `UnitPrice`,
    `order details`.`Quantity` AS `Quantity`,
    `order details`.`Discount` AS `Discount`,
    cast(((((`order details`.`UnitPrice` * `order details`.`Quantity`) * (1 - `order details`.`Discount`)) / 100) * 100) as decimal) AS `ExtendedPrice`,
    `orders`.`Freight` AS `Freight` 
  from 
    (`shippers` join (`products` join ((`employees` join (`customers` join `orders` on((`customers`.`CustomerID` = `orders`.`CustomerID`))) on((`employees`.`EmployeeID` = `orders`.`EmployeeID`))) join `order details` on((`orders`.`OrderID` = `order details`.`OrderID`))) on((`products`.`ProductID` = `order details`.`ProductID`))) on((`shippers`.`ShipperID` = `orders`.`ShipVia`)));

#
# Definition for the `Order Details Extended` view :
#

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `Order Details Extended` AS
  select 
    `order details`.`OrderID` AS `OrderID`,
    `order details`.`ProductID` AS `ProductID`,
    `products`.`ProductName` AS `ProductName`,
    `order details`.`UnitPrice` AS `UnitPrice`,
    `order details`.`Quantity` AS `Quantity`,
    `order details`.`Discount` AS `Discount`,
    cast(((((`order details`.`UnitPrice` * `order details`.`Quantity`) * (1 - `order details`.`Discount`)) / 100) * 100) as decimal) AS `ExtendedPrice` 
  from 
    (`products` join `order details` on((`products`.`ProductID` = `order details`.`ProductID`)));

#
# Definition for the `Order Subtotals` view :
#

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `Order Subtotals` AS
  select 
    `order details`.`OrderID` AS `OrderID`,
    sum(cast(((((`order details`.`UnitPrice` * `order details`.`Quantity`) * (1 - `order details`.`Discount`)) / 100) * 100) as decimal)) AS `Subtotal` 
  from 
    `order details` 
  group by 
    `order details`.`OrderID`;

#
# Definition for the `Orders Qry` view :
#

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `Orders Qry` AS
  select 
    `orders`.`OrderID` AS `OrderID`,
    `orders`.`CustomerID` AS `CustomerID`,
    `orders`.`EmployeeID` AS `EmployeeID`,
    `orders`.`OrderDate` AS `OrderDate`,
    `orders`.`RequiredDate` AS `RequiredDate`,
    `orders`.`ShippedDate` AS `ShippedDate`,
    `orders`.`ShipVia` AS `ShipVia`,
    `orders`.`Freight` AS `Freight`,
    `orders`.`ShipName` AS `ShipName`,
    `orders`.`ShipAddress` AS `ShipAddress`,
    `orders`.`ShipCity` AS `ShipCity`,
    `orders`.`ShipRegion` AS `ShipRegion`,
    `orders`.`ShipPostalCode` AS `ShipPostalCode`,
    `orders`.`ShipCountry` AS `ShipCountry`,
    `customers`.`CompanyName` AS `CompanyName`,
    `customers`.`Address` AS `Address`,
    `customers`.`City` AS `City`,
    `customers`.`Region` AS `Region`,
    `customers`.`PostalCode` AS `PostalCode`,
    `customers`.`Country` AS `Country` 
  from 
    (`customers` join `orders` on((`customers`.`CustomerID` = `orders`.`CustomerID`)));

#
# Definition for the `Products Above Average Price` view :
#

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `Products Above Average Price` AS
  select 
    `products`.`ProductName` AS `ProductName`,
    `products`.`UnitPrice` AS `UnitPrice` 
  from 
    `products` 
  where 
    (`products`.`UnitPrice` > (
  select 
    avg(`products`.`UnitPrice`) AS `AVG(UnitPrice)` 
  from 
    `products`));

#
# Definition for the `Products by Category` view :
#

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `Products by Category` AS
  select 
    `categories`.`CategoryName` AS `CategoryName`,
    `products`.`ProductName` AS `ProductName`,
    `products`.`QuantityPerUnit` AS `QuantityPerUnit`,
    `products`.`UnitsInStock` AS `UnitsInStock`,
    `products`.`Discontinued` AS `Discontinued` 
  from 
    (`categories` join `products` on((`categories`.`CategoryID` = `products`.`CategoryID`))) 
  where 
    (`products`.`Discontinued` <> 1);

#
# Definition for the `Quarterly Orders` view :
#

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `Quarterly Orders` AS
  select 
    distinct `customers`.`CustomerID` AS `CustomerID`,
    `customers`.`CompanyName` AS `CompanyName`,
    `customers`.`City` AS `City`,
    `customers`.`Country` AS `Country` 
  from 
    (`orders` left join `customers` on((`customers`.`CustomerID` = `orders`.`CustomerID`))) 
  where 
    (`orders`.`OrderDate` between '19970101' and '19971231');

#
# Definition for the `Sales by Category` view :
#

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `Sales by Category` AS
  select 
    `categories`.`CategoryID` AS `CategoryID`,
    `categories`.`CategoryName` AS `CategoryName`,
    `products`.`ProductName` AS `ProductName`,
    sum(`order details extended`.`ExtendedPrice`) AS `ProductSales` 
  from 
    (`categories` join (`products` join (`orders` join `order details extended` on((`orders`.`OrderID` = `order details extended`.`OrderID`))) on((`products`.`ProductID` = `order details extended`.`ProductID`))) on((`categories`.`CategoryID` = `products`.`CategoryID`))) 
  where 
    (`orders`.`OrderDate` between '19970101' and '19971231') 
  group by 
    `categories`.`CategoryID`,`categories`.`CategoryName`,`products`.`ProductName`;

#
# Definition for the `Sales Totals by Amount` view :
#

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `Sales Totals by Amount` AS
  select 
    `order subtotals`.`Subtotal` AS `SaleAmount`,
    `orders`.`OrderID` AS `OrderID`,
    `customers`.`CompanyName` AS `CompanyName`,
    `orders`.`ShippedDate` AS `ShippedDate` 
  from 
    (`customers` join (`orders` join `order subtotals` on((`orders`.`OrderID` = `order subtotals`.`OrderID`))) on((`customers`.`CustomerID` = `orders`.`CustomerID`))) 
  where 
    ((`order subtotals`.`Subtotal` > 2500) and (`orders`.`ShippedDate` between '19970101' and '19971231'));

#
# Definition for the `Summary of Sales by Quarter` view :
#

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `Summary of Sales by Quarter` AS
  select 
    `orders`.`ShippedDate` AS `ShippedDate`,
    `orders`.`OrderID` AS `OrderID`,
    `order subtotals`.`Subtotal` AS `Subtotal` 
  from 
    (`orders` join `order subtotals` on((`orders`.`OrderID` = `order subtotals`.`OrderID`))) 
  where 
    (`orders`.`ShippedDate` is not null);

#
# Definition for the `Summary of Sales by Year` view :
#

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `Summary of Sales by Year` AS
  select 
    `orders`.`ShippedDate` AS `ShippedDate`,
    `orders`.`OrderID` AS `OrderID`,
    `order subtotals`.`Subtotal` AS `Subtotal` 
  from 
    (`orders` join `order subtotals` on((`orders`.`OrderID` = `order subtotals`.`OrderID`))) 
  where 
    (`orders`.`ShippedDate` is not null);

#
# Data for the `Categories` table  (LIMIT 0,500)
#

INSERT INTO `Categories` (`CategoryID`, `CategoryName`, `Description`, `Picture`) VALUES 
  (1,'Beverages','Soft drinks, coffees, teas, beers, and ales','/\0\0\0\0\r\0\0\0!\0ÿÿÿÿBitmap Image\0Paint.Picture\0\0\0\0\0\0 \0\0\0PBrush\0\0\0\0\0\0\0\0\0 )\0\0BM˜)\0\0\0\0\0\0V\0\0\0(\0\0\0¬\0\0\0x\0\0\0\0\0\0\0\0\0\0\0\0\0ˆ
\0\0ˆ
\0\0\b\0\0\0\b\0\0\0ÿÿÿ\0\0ÿÿ\0ÿ\0ÿ\0\0\0ÿ\0ÿÿ\0\0\0ÿ\0\0ÿ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ppp\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0%67wwwwwwSS\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\045wwwwwwwwwwwwww\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0!awwwwuuu555%wwwwwwwP\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Awwsv7cwwWgw u''wwwv4a!\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0P6wWuqpP\0\0\0pqwuwwwwS4\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0W50\0\0\0\0\0\0\0\0\0\0\0\0\0wwwwG\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 !\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\045\0\0\0\0e45wupGttp\0\0wWwqq\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0AGq5u\0 w0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0AvWw \0\0gwwwwe`@@ 746@\0$\0\0\0\0\0\0\0 @\0\0 \0\0Gvww\0 7wWwwwSr\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0vvGg\0\0@\0WtpAgGt!@P\0CA@40\0VQ Q\00\0! pp7wwwwWwwq1wwwwwwuwq\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0G@Dq\0twwgwwv\0t%$\0wwwGdgvu `%\0swwwwwwwttw''WGw\0wwwwwg3p0\0\0\0\0\0\0\0\0\0\0\0\0\0\0B` \0wBtwvwwwwugwwtdtefvwwfWFwgWSPqfswws7FwuwwwwW''vw\0Qwwwwgw`q1A\0 \0\0\0\0\0\0\0\0\0\0t@@GvwvwvpggwvtvVsGWPWg7VdtgWwrq%!gqw3w7wgwgugGewWq!7uwwwwgwS\0\0\0\0\0\0\0\0\0 g\0wgGwgvwwVwgwwww$wg`gwtgGGGggwVRVSww7dwwuvuwwtw wwwvww@4\0\0\0\0\0\0\0\0\0\0\0\0\0\0we@f`PwvwewwgtpwGwwgGfF wsvttvwwwgw757wswGwwwwwtwGpq wwvwwv1qsR\0\0\0\0\0\0\0\0\0\0\0\0\00vwWggu pvtwwGtwwttwpGgwegtgwewwwwwwwwww7fwwGetwGwwwwwvvwA7q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0W D%geav\0gg\0GpGg p gw\0\0GwGsFVDgEgvvwwwwwwwww7Vgwwwwwwwws\0wwwwwwwSR\0\0\0\0\0\0\0\0\0\0wwq!RP0g\0wwGgBpG$wvWudp\0vswGgt''wwwwwwww6wwwwewwwwwwCGwu WwSwvvvwrw1\0\0\0\0\0\0\0\0\0\0\0\0\0qpp @F\0wFvtpwAgt6Vww@ wvt FVwgwwwwwuwww7Gguqaa$400wwwwWwu!\0\0P\0\0\0\0\0\0\0\0\0!\0%gPp C@g\0\0@vp W Wwwgw\0wtGFFegwvwwwwwwwwwswgwa\0\0\07wSP1www7wswPp\0!\0\0\0\0\0\0\0\0\00\0gwwaePG`G`tdwdpVVwgp wduttvwwwwwwwwwss7Gwws5wwwwwwwwWwwwwwgA A\0\0\0\0\0\0\0\0\0\0wtA@\0 @gvvvwgwwdwuggwtGp t fFvGwVwwwwwww7777vFwtwSRwwwgwwwwwcesSSQ00 0\0\0\0\0\0\0\0\0\0 \0\0aGvvtd`@@@@fgvvwwTvwpFdFDDVwggwwwww3ssswgwwgt$Gw7wq''wSWWu4$ @\0\0\0\0\0\0\0\0\0\00\0P\0Ff@\0\0 45!\0egwg wpvwCwggwvwwwww77737VGvW Sw pwwwe%''s\00\0\0\0\0\0\0\0\0\0P\0\0F\0\0%45\0\0\0\0\0 t\0\0wDs777wWgwwwww7777w7egWwww71ggpwwwVqw0\0\0\0!\0\0\0\0\0\0\0\0\0\0 t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 wwwssswgvwwwwwssss3sVwgww7wwwqwtpRqvs@0\0\0\0\0\0\0\0\0\0\0\0\0V`\0\0\0su``\0\0\0\0\0\0\0\0\0\0\0\0\0s ww73777wwGgwwww73sSvfwwwsw7wqgpw57wWG51\0\0\0\0\0\0\0\0\0\0\00\0e@\0\0\0\0T\0\0\0\0\0\0\0\0\0w7wgswsss7wgwwwwwgvFteeugGwwsw0wvVT5''5w\0\0\0\0\0\0\00p@\0f\0\0\0\0\0\0\0@\0\0\0\0\0\0\0\0\0\0\0\0\0wwQFs73sswwwtvwwwwttdGdfgvwwww''vs 7CWGssA\0C\0\0\0\0P\0\0p\0\0\0\0gB\0\0\0\0\0\0\0\0\0\0\0\0 wvgww7sw773swgwwwwwgdVvPutwvWa\0WsWGwcw5RpR\0P!\0\0p!e\0\0\0@\0\0\0\0gv@gvF@\0ACAwwwgfvss73sswwwvvwwwvVGgGFdftwvu''a\0#1!''!a aAs Vw\0\0W\0G@\0G@F\0\0\0FwpPGwvqsW7Vvwvvw7swssswwgwwwwwedtgeGuvwqvp tedts\0\0PRqappwqswt\07p\0\0vg`\0\0\0 @v\0wpgwwwgggggg3s37777wGgwwwwvvwGBFvtvwwgvwga1371%0s wwww\0uwp\0\0\0`v\0\0d\0\0dtg@wwwwvvvvvsw7wsswwwvwwwwwgGFvtgGwwt6pS2SRRq53SSCACqaq0wqwwww\07w\0vvgpGDf@\0Gd\0wtwwwwggggg7s733ssswgFwwwvTggGtvtvSua 1w5su%4stp5010\0Bwwww7w\0Gwwpt`pFDD\0\0F@pvpwwwwvvvvvs7sww77wwvwwwwwfVVeg gvwu p V1S4sps!6CCCC ww7www@%w7p\0''Dp\0@\0\0\0\0d\0d\0g`wwwwggvwgw3s33sswwGgwwwwtgegDdtwgv4wqru7WwuwW5qqqqqqt3aacwwwsW7@ 7w4\0F``\0\0\0\0\0@\0`vtwwwwvvgfvsw7ww777wwGgwwwgVVtgtgewq73Sw7wwwwwwwwwwww7uw7W7ww7sw GwsP\0tF\0D\0\0\0\0\0\0Gw@ ww\0fvwgv3333377wwfvwwwwwftvVFWGg``\0 53u71wwwwwwwwwwwwwww7wsws7Sww@\0qww\0\0f@$d@\0\0\0\0\0dg\0Gww\0wgfvfwwwwwsswwwwwwwvwtFFueggwSSsRSqwwwwwwwwwwwwwwwwSww7Sw7p\0vssP\0\0\0GFdfVFdD\0@d\0\0wp\0ggvww33333777wfvwwwwwgwwfvwegwqq1u!p77wwwwwwwwwwwwu7Sw7Swsww7\0ww\0@ GvgvGfvvgFv\0\0\0w\0\0vvgffwwwwws7wwugwwwww&\0wa557wwwwwwwwwswSwwwwwSw7sStp\0\0PpDfwwwvwwvwwvVf\0\0ggvww311\0wwwfegwugp@@PQ@wwScSqsSqwwwwwwwwwWuwwwwwwwwsSu7w7\0\0\0w`@@@@@F ggwap\0p\0\0q\0\0\0\0\0\0WwvwwvG$\0S\0wq0u57wwwwwqssww7w7wSw752RSvDd&W\0@\0\0\0\0\0\0@@\0vw@\0D\0\0wu\0u\0\0\0\0\0\0\0\0sGvgwted\0\0\0\00RQ50u3 7wwuwwwwwwswwwwswwSup55141q7153\0\0FD\0\0\0D\0\0\0\07p\0\0\0\0\0w41\0\0\0\0\0\0\0\0\0WwwVv`\0p\0\0\0@D!0R153q5ww7w7swuwwwW7Wwww52P1aaqcRW%p\0\0g\0\0B@\0\0\0Rsq\0\0\0\0\0\0uw\0\0\0\0\0\0\0\0\0SwveDt$@\0\0\0@100rSSw7wWwWwSswswwwwwwp543C1q1s7\0\0g\0\0\0\01u`\0\0\0\0\0\0\0 wq!\03uFgGFW p\0 S455u7sssSww7wwwww7SwP3S 5a410p0RSppC7\0\0\0\0\0\0\0\0\0\0w\0\0\0dsssvtVFwwwwsWsQ74511psswswWww7wWsusW7Www43u7ssg0q1cRs17\0\0 ssRq5t\0\0\0\0\0\0\0\0\0\0\0\0F@\0\0\0Fs7774Fdwwwwwt\0 777457sVSsSuwsuswwwwww3SswSWrwSqqcssWw\0\0 57wp\0\0\0\0\0\0\0\0\0\0\0\0`\0@gasssttWwwwwwpc 1!111s7w7www7wwwwwwwwwwu7w7wsw757sWGsswawqgwsW\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\03s3FFswwwwwt\0w373\0Sw7wSw7wwwwwwwwwwwswwW7w7wwsgqw7sqgSSC75%w7\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0s77D377wwwwp\0 t\0113173sWu7wwwwwwwwwwwwwww7swu7W7776qqe75rsg7GSsqt\0\0\0\0\0\0\0\0\0\0F\0\0\0\0\0\0\0\0ss6Cw3swwwwt 0\0\0\0\0!7377wwwwwwwwwwwwwwwwwWwsswsuuusS''3SSWSW77uv0\0\0\0\0\0\0\0\0\0$@\0\0\0@\0\0 73us3733wwwp\0 \0\0\0\0\0\0\0\0\0pGwwwwwwwwwwwwwwwwwswsuwSussswwwSW''6s77sSW75p\0\0\0\0\0\0\0\0\0@`\0\0\0\0@@s737ssw77wwp\0\0\0\0\0\0\0d7wwwsuwwwwwwwwwwwwwsw77w7www775qqu%sG7!ws@\0\0\0\0\0\0\0\0\0\0dF@\0\0\0\0\0C73s37373s7wq\0\0G4\0ewwGqwuwwwwwwwwwwwwwsuwWw5w5wwWwWsww7w77Wwqwp\0\0\0\0\0f\0\0d\0Gg@\0\0\0\0\0ss773w3ssswt\0wv\0\0\0\0@swwwwwwwwwwwwwwwwww7sw5w7ww7sw7swSqwSWW757q\0\0\0\0\0\0@@\0F@`F\0\0\0\0\0\0 73ss737777wp\0\0twB\0\0\0\0\0CWwwwwwwwwwwwwwwwwwwWwwwwwwwwwwwwwwwsw77uwwp\0\0\0\0\0F\0\0`F\0\0\0\0\0\0\0s7373ssssswv\0\0\0\0\0P6wwwwwwwwwwwwwwwwwwwwswwww7wwwwwwwwwwwwwww7sww\0\0\0\0\0\0\0\0\0\0@\0\0\0@@\0\073sss777777p\0\0\0\0wsWwwwwwwwwwwwwwwwwwwwWwwwww7wW7wWwwuw7wwwwwwwW4\0\0\0\0\0\0\0\0@\0\0\0\0\0\0\0 3s73733ssswu\0\0\0\0\0wwwwwwwwwwwwwwwqwwW7Ww7wwwsWww7ww7swSw7w5sW57W7sp\0\0\0\0\0\0\0F\0@``\0\0\0\0\0\0c73s777w773wp F\0\0\0wwwwwwwwwwwwwwwwsw7wswwswww77u57Su7wwwwwwwww7qwP\0\0\0\0\0\0\0\0\0\0D@D\0@\0\0\0\0cs773s33ss7wtt\0\0\0\0wwwwwwwwwwww7WswwWwqwswsWwwww7wwwwwwwwwwwwwwwwwp@\0\0\0\0\0\0\0\0\0\0f`\0\0\0C733s77s37wwpv\0@@wwwwwwwwwwwwwwusW7Swwwuww7wwwwwwwwwwwwwwwwwwwwww \0\0\0\0\0\0\0\0\0\0@D@\0\0\0\0sss73s77wwww`tf\0wwwwwwwwwwwwwswwwwww7sw7wwwwwww7swww7wwSwwwwwwwwP\0\0\0\0\0\0\0\0\0\0\0F`\0\0\0\0cs73s73swwwwptdp\0wwwwwwwwwwwwwwwwwwwwwwwwwwqsqwwwW7swu7wwwwswWw77\0\0\0\0\0\0\0\0\0\0Dd\0\0F\0\0\0\0\0 3ss73s7wwwsu`v\0wwwwwwwwwwwwwwwwwwwwwwwwwwwww77swsW7u7w5sww7wWwr@\0\0\0\0\0\0\0\0\0`d\0\0\0\0\0\0\0\0s77ss7wwwwsvtd\0@`WwwwwwwwwwwwwwwwwwwwwuwWqs757wWquswSsu7wwWwwwwwP\0\0\0\0\0\0\0\0e@\0\0\0\0\0\0\0\0 3s337wwwwwq`ggGggwwwwwwwwwwwwwwwswwww7w7wwusussw6777Wswsssswwsq \0\0\0\0\0\0\0\0\0F\0\0\0\0\0\0\0\0\0 7777wwwwww7pVGddawwwwwwwwwwwwwuuwwwuuuw5w75775w7WSWcW3WswWwww7wwP\0\0\0\0\0\0\0@d`\0\0\0\0\0\0\0 3s3wwwwwwwq`dv@\0wwwwwwwwWwusWwwwuuw7suwwuswwWw5ssw75w7W 77Wwwsp\0\0\0\0\0\0\0\0FvFVTd\0\0\0\0\0\0 s77wu7wwwwwtGD Fp wwwwwwWwuswsW7qw77wwsww7ssssw5wSSsCpsswWWw757wp\0\0\0\0\0\0gdt&f@\0\0\0\0\0\0s3wpttwwwwwwegd''fwwuu7wWw75wwwWwwwuwwwu7wwwuwWwwswwWw7uwW777wwuwp\0\0\0\0\0\0t `@@\0\0\0\0\0\0\0\0wwqqaswwwsvvfVFGwuswwWw7Wwwqw7wwwww5sWwwsswwwsqsW7w75u777www5w7sp\0@\0\0\0\0\0fBF\0\0\0\0\0\0\0\0www\0vwGwwwwggggG@Wwwwwswwwwwwwwsw5swsww7wwuww7wwwwwuw7wusSu5w5www\0\0\0\0\0\0@@d\0D\0\0\0\0\0\0\0 w7AGugwwwv$vvv`wwwwswwwswswwSwwwwwwwwwwwww7wwww7Sg7su5sgvwgsvsGq@$\0\0\0\0\0\0F@\0f\0\0\0\0\0\0 su  wruwww\0@vgvqwwwWwwwwwwWw7wwWwwu7qwwwwWu555wwwWuwwwSWSsWWsW\0P\0\0\0\0\0\0\0\0@@vDd\0\0\0\0ws@WWwwpD\0vBVwsw7Wu7W5swwww7sw7w7wwwww7wwwwwwqwwwwwwwswWw7uww0\0\0\0@\0\0\0\0\0\0\0\0\0\0g@\0\0\0\0ww%wsgww\0@\0`\0ge7ww7ww7w7wwwsW5wwwwwwwwwwwWwwwwwwwwwwwwwwwwww7sw57p \0@\0\0\0\0\0\0@\0\0@@\0\0\0\0\0\0 wpRWewww\0@@WswW7wwwswwwwwwwwwwwwwwwwwwwwwwwwww777u7wswVWRwwP\0\0\0\0\0\0\0\0\0\0D$$@\0d\0\0\0\0 wr@wWgwp\0`\0 \0susswWu7Suswwwwwwwwwwwwwwwwwww7wsw75wWWwwusWSss7qss\0p\0\0\0\0\0\0\0\0FFD\0\0g$@\0\0\0wu VvWwP\0D@@d@GwswwwswwwwwWwwwwwwwwwwwwwwwuswww7Wsssssssw3wu5u7uw@\0\0\0\0\0\0\0\0\0\0@\0\0@d\0\0\0Gw@wWww\0@BFF7Wwuw7wwwwwwwwww7wwwwwwwwwwwswwWsWW7WWWW%3rsCrw0 \0\0@\0\0\0\0\0\0\0\0\0\0F\0F@\0\0\0 w%%gww\0GB@CswswWwwwwwwwsw7wwusWwwwwwuswssswssww76scrsssSV7qu\0\0\0\0\0\0\0\0\0\0\0F\0\0\0\0\0\0wGwwpv\0eddwwwwwwwwwwswswwwWqwwwwwwwwswsWuwSwuqsqu55qt5%7sssqws\0p\0\0\0\0\0\0\0\0\0\0@`\0\0\0\0\0\0www5pG`FP\0rwwwww7www7wwwusW7wwwwwwwwwwsww7swswuwswswsww45t5gssw\0@@\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0wqqSVwF\0$puwuw7wwswuw5sWswwwwwwwwwwwwsWw7wwwwwww7W5wu55wswsqtu''q`\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0wq57wvv\0d@''577u7suw7wwwwwwwwwwwwwwwwwwwwwwwwwusww7w7w7ww5wu7Wssqw\0@\0\0\0\0\0\0\0\0\0D\0\0\0\0\0\0\0wWwvt\0`d!CWWwuswWwwwwwwwwwwwwwwwwwwwww7wwwwwwwwwwwwwwww7wssww7Www0$\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0wqtwwVvT%775swwwwwwwwwwwwwwwwwwwwwwwwwwwwwwswwuwwwwwwwwsuww7wsSwq\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0wuwvGg@@awwwwwwsw7wwwwwwwswwwwsu7wwwwwwwuwwwww7sww7wSwuwssSu77w 7\0@\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0wqqwwtgv\00SwWwwwwwwwwwww7wwwwwwwwwwwwwwwsssSqwwuwqwu7www7qwWwSuu5sSa\0\0@@@@\0\0\0\0\0\0\0\0\0\0\0\0ww vp\077sw7swWswsw7wwwwwwwwwwwwwwwwwuwwwwww7w7wwwwwwwwwsw77ssw5wS\0\0 \0\0\0@@\0\0\0\0\0\0\0\0\0wsSwwP@Cuwusuww7wwwww7wwwwwwwwwwwwwwsswwwwwwwwwwwwwwwwwwwwWwww7sswr\0P@@@@\0\0\0\0\0\0\0\0\0\0\0w5ww\0\0`u7Ssww7wwqwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww7SsWqwW550\0\0@\0\0\0@\0@\0sSWwp \0 ''swwu7wwSuwwwwwwwwwwwwwwwwwwwwwwwwwwwwWwwww7wWwwwSwSw''WcwqrRsA \0@@\0\0\0\0\0\0\0w557w\0PSSWww7wswswwwwwwwwwwwwwwwwwwwwwwwW7wswww7wwwwswwwwwSu75u''qwQsP\0 \0\0@\0\0\0@\0@\0\0wqqwwP57wssww7wwwwwwwwwwwwwwwwwwwwwwwwww77usw7wwsWw7wwswwsw7ww7qw1647\0\0a\0@\0@\0\0wSww\06wqsuwSwWwwwwwwwwwwww7wwwwwwwwwwwwWWqwwwwwsqwWswwwuwwswsSqwswvSSSq`\0p\0@@\0\0\0\05qwwvwuswwwwwwwwwwwwwwW7Wwwwwwwwwwww77swsu7wuwswwSu7swwuwwwwqusrSw7''\0% \0@@`@\0wSwqwwwwwwwswwwwuwwwwwwwwwwwwwwwwwwwwWqwSuwu7w7swswwwwwwwwwqsww7u7pwScwC \0RA\0\0\0@\0w7wwwww7wwwwwwwsw7wwwwwwwwwwwwwwwwwwwwswswwswwwwuwusw7wwwsw7wwu77u7qwSuuswWv\0\04\0wWSwwwwwwswswww7wwwwwwwwwwwwwwwwwwwwwwwwSww7wwwwwwswwwwwwwwwww7wwW7wwsw77u77570\0\0\0\0@\0\0\0w7www7wwWuuqwwwwwwwwwwwwwwwwwwwwwwwwswswwwwwwwwwwwwwwwwwwwwwwwwwwwswuwww7wuwwwwqaa!acwwwqwwwwqw7wwwwwwwwwwwwwwwwwwwwqwWswWwWwwwwwwwwwwwwwwwww7wwwwwwsw7wWsswqwqsw7SwwwwwwwwwWwwwwwww7wswwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww7swwswwwwwswWqwSwwwssuw7sw57w5sw77w7wWswswqqwwwwswwwwwwwwwswwwwwwwwwwwwwwwwwwwwwwwsWSu7wuww7uu5sWuwSswswSusWusWWSwqqsW5wSWSw7WwwWwwwww7Ww7W57swwSwwwwwwwwwwwwwwwwwwwwwwswwwsu7W7swww7wwwwwswswsw7ssw7Swww7W57swSw7wwwwwwwwuwW7uw7wwwuswwwwwwwwwwwwwwwwwwwwsWwwwwwwwwwwwwwwww7wwwwwwwwwwwwwwwwSww7wwwwwuwwwq7wqssswwswwwwswwwwwwwwwwwwwwwwwwwwwwsswwwwwwwwwwwwswwwww7wWwwwwuwwwSsswww7w7swSw7wwwqAwwuwW7www57wwwwwwwwwwwwwwwwwwwwwwwwwwwswwww7swwwwwwuwWuwW7wwqsqsSwWW577WSeswww77wwww67sswW7w7wwwwwwwwwwwwwwwwwwwwwwwwwwswuqwW77wuww5u75ssw7wwsw77wwwwwwssswqu3v75sSwwWwwwSwWwwSwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww77w7wW5su7wswwwwww7swuwWw75755wRCwSWsw7wqsssw7w7Sw7SwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwuqSGssssw7qswqsswwwwwwsww7Wwwwww7w7s777w7wwwWww7Swwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww77w7quuwW5w7wwuuqswwwwwsww7575ququwqwSwquw7sSwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwSG557ssqsSqqqsSsswwwwwwwwswwwwwww7sw757577sww7wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww7wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww55\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ç­þ'),
  (2,'Condiments','Sweet and savory sauces, relishes, spreads, and seasonings','/\0\0\0\0\r\0\0\0!\0ÿÿÿÿBitmap Image\0Paint.Picture\0\0\0\0\0\0 \0\0\0PBrush\0\0\0\0\0\0\0\0\0 )\0\0BM˜)\0\0\0\0\0\0V\0\0\0(\0\0\0¬\0\0\0x\0\0\0\0\0\0\0\0\0\0\0\0\0ˆ
\0\0ˆ
\0\0\b\0\0\0\b\0\0\0ÿÿÿ\0\0ÿÿ\0ÿ\0ÿ\0\0\0ÿ\0ÿÿ\0\0\0ÿ\0\0ÿ\0\0\0\0\0\0\0wwwww7SS171w5C0%S21sCqq57ss1qqqq!Sa1!wwwwpge GGwegagtweew@@77sw\0\0wwwwwqt55sSS4000!apSS1sS47Sq7qw774P1RwwweDrGgwgttvWpwvGt4 5uq\07 Swwwwwwww1ss571pC!C10S1AqsTsSSsq1p01qwwwpfEv egGdwaGggwgAt G@W3A6wwwwwwsSqqsS7511%50qs7 71ss571w7775R7wwu$Ptttt wwwvvWwWGGtV\0u\0SQ0wwwwwww7qC5qsSF1 1103C51q1ssqw1qswSSqspssP1sWww4G`Tpa`G`wwwwwwvFww` G t0\05!!\0wwwwwwwqsV553SqsS   QSCw45wq0qsqwAq3S7wtv@ `GDp\0wwwwwwwwufupFw`w@@0Swwwwwwwsq%13S75011143A553a7PsS1sq7pq7571st3s7www`@\0 dvwwwwwwwwwFGt5eGv\0wwwwwww55asu4qs7Rqqss5q7sW1qqsS75qsSswwt`FGFwwwwwwwwwwp@fwFw` u\0S0\0wwwwwwwss q7RA10q`QS5u53W7741sSsssSsw7wwwpFdtuwwwwwwwwwwdwtWwp\051 \0ww7wwwu541a75q1c 1q75171qssqq#SS555rSwwwwwwwwwsswwVtpd%gwwwwwwwuwwwRFWwwvw510wwsWwwwssPw17Q1 Qa75SC0W75sw70wwwwwwwwwwwwwwe@dgwwwwwstwswwwtvwwtwq `5\075wwww550q1qssQ2C5s 1q3Sq%qsPs3SW5wwwwwwwwwwwwww`d@wWwwwwwswwwwwBEwugqwAaq\0sWs5wwwssR%2Q 5!3 pq3Ss72ssW77wwwwwwww7swwwwvFd`@FG7wwwwwwwww7wugwfWvGB!\05wW77wwWa513sS75SQq11G15qaqw7Swwwww7wwww7wwwwwG@@VttwwwwwwwwwswsqvVwW7ppp!\0s51quwwsqsAsSSS51 wc57qsqsSq 7sswwwwwswsw7qq7wwwtD\0f@FFwwwwwwwwwwwwwugwwGGwAqa\00W7sww71 151sSRGsSp7571cu5wwwwwwww7sw73qwwwpvP@`GwwwwwwwpwwssCwwwggGv!a1qq55wwq2SBSCRSS1qssSqqaqq7u7swwwwww77sw3q57wwwtDed@FwwwwwwwwwswwwwGdGtG q05%0wwwW51177u4r57773ssCSwwwwwwwwsw7u7swwwd`FFVWwwwwwww7w70wutwwdGv0!\0q57ws1sSS\053Sqqe1sqq5s7wwwwwwwsusS3s57wwwFT\0d\0vwwwwwwswsP\0wvvdpv@4\00\05%5!puwRqe51sqas7u3SsS7W1gswwwwwww7sssww7ww`\0@gWwwwwwww7\0wugdt1\0Rsww1Rw1q7qSwW7s53S3wwwwwwwwwsw7731153Swwvv@ dV\0gwwwwssq\0\0WfDVeegA!10\05!p1p 75701sq5''57s577%5sSuqwwwwwwwwww777qs1qsw7w4Eddf@DDdwwu70\074`gFv@3R R1RqwsSPCsWp3RS s777wwwwwwwww3w7171q353Sww@\0@v\0@gtq\0\0dvtDV@10Rq\00p1!51q051a''3sqqqw1s@qsqqww7wwwwwwwwwsswsS3S7wwtfTpFD\0Dpep\00\0VD@gfSq1\001R1@!qsa50CSQ51! 16SSwwWwwwwwwww7753377wwsDf@@G@@\0\0p$F@\0VA00!CA0P0q5!w\051!SC@1RQp57 S7w5swwwwwwssssqq3s1qqwwqE@D\0d`d GdTt dGdGFaq!0!1133Sq1 1p 13S0 1sSwRwwwwwwwwsss7711711w 7wvdf\0\0\0\0@d\0d`\0\0Gda!!!cCCA5 SSsCS4R@sSSw7sswwwww757q1713Sq7w7wt\0\0\0\0D\0@\0\0FVF\001310415CR3@1%qq 52qq101s77wuwwwwwwwsqsq777qq1wCSswwwfFDF\0\0`\0dBVFpQ40p\0!1RS\0C%15 5117\0qSQ05!qc5sw7wwwwww7773s51113q7 7W7swWGFd F@eFD$A!01!S101141Qq@q5  12S ss57wwwwwwww7sssqss153SwSsWwwswwWGFDVRA5Q\0!!1R1RS%\0SacC505!1CSQaA577wwqswwwwwws7ss15175 775%sqw7577C !!\0!0111qA!q514S551a\0SSsSspwwwwwww7w7773175s@SqSqsRW77Qs@ps50! 11%1q%7$0Sqq5R''qp10100p5577wuswwwwwwssW3qqq1q31s5757 %pS''RQ3 !5qScS10S1s551 \0\0 sqw7swwwwwwsw73w31q13SSCAr1ps551pq52P00q 1C073557q1 1`1p10q7qw4wwwwwwwsw7s77153q$355\0qpSS \0qCQ1q0P0Scus1! \01q7777q7wwwwwwwwwwwsw731SqtpSS!pWrSSPs1!a!1!q\0 %103%!qaa7C151 sVSwwwwwwwwwwSA0pq3\0`10A00S101A!0uswsRQ5%0\051s7sW1wwwwwwwwwuqq17551q\0%52a1aQ1\0001P s0qp1q!5S51q55q77swwwwwwwww71\0QS150\00\0q!$0\0\0Q1\0000\0wswqu 1s15 01S!053s7Sw1wwwwwwwwwwQ\0\0\03S1qCA01001\01!\0s7w71sS\01aS aP13Su3wt7wwwwwwwS!\0Vr\011! 1\00\0!0\01wqwwqGR70SRS1p7!W7u7w7wswwwww5SU71Q\0qw101\0!\0\0\007ww77s57S3151q1P05sSwsw7qwwwwwwsQ53Qq\0pSa0pP1\0\0wwwwwSq1spqc1SR5#! 3Cw7w7SwWwwwwwq1q15771R\01a12 !1\0\00w7wwsqq7113 500%3SW5sqswssw7www1wSS53SW11 %!RqQA!cR!!\0\0wwswwV7qs1spqsR1sC41sswwwwwWwwwws11qswu1sqP010Cq3S1wswwss10!!\0wwww73 1551p11qs5%wwwe!''ww7w1q5545575uq1\0Q52P1Q1swWu%5w001swwwwus5sS1sCSqsq7 CSpP\0@@www7q715wwwS7P\0\07Q1Gq7wuq4\0\0\0\0\0\0Au11010Q\0\0wwwwwsE3551%537SC!5517wp\0\0\0wwwsQqsQ Swu5s1\0S527wwC@\0\0\0\0\0\0\0\0SQA\0wwwsw53W1sR3Asq754SSwG\0gV wGw5772Qu7Ww1w5\0 1sQgwqa@\0\0\0\0\0\0\0\0 \00\0wwwwww4311q 531q041 77w w@dVUpGwu1SQwsqq\0qsww \0\0\0\0\0\0\0\0\0\00wswww7qsSs0Su77S1qwuudgGgefugw7W uwww7s\0\0 q7wwQaP\0\0\0\0\0\0\0\0\0\02r\0 \0wwww7wqs5414131qqqp50qsw7wwWG@VUgVpsswCWW\0\0wwwwsW4044\0\0P\0\0\0\0\0\0!\0!\0wwwwww57SsSCSSS75CSSwwwp\0`G`fwg@swwww1su0\0\0\0\0wwwu50QA\0\0\0@p\0\0\0\0\0\0\0P\0\0wwwwwssSp730571q7R1sw77wwwtvPFGFVwwwwwwwwwwws\0\0\0\0\0 wwusS07Au51 s\0\0\0\0\0q\0q\0wwwwswu7q5sqa73S5 Swwwwwtd@veGwwwwwwwwwuu\0\0\0\0\0\0\0\0 wwwu5wWP1RW0 p\0\0\0\0\0\01\0!\0\0\0ww7WwssCqqqu53Cqsw7wwuvp fpDebWwwwwwwwwwwsp\0\0\0\0\0\0\0 wwwwsSpwWuav5q\0\0\0\0\0\0\0S!\0\0\0www7wwsS3Sas%773sq57wwwwuPFVDvvtwwwwwwwwwwwq0\0\0\0 wwwSWwSq'' B \0p\0\0\0\00 \0\0\07WqwssSCq531Qqs 57w7wwwGfGFwdGGwwWwwwwwwww7\00\0\0\0 wwwwww5t\0% \0\0\0\0\0\0!\00\0\0w77ww7Rqq2S577770swwwwwwu$$FGegwwwwwwwwwwwwqA\0\0\0 wwwwww  0ap\0\0\0\0\0S1\0qw5qwwa171qasSSSsswwwwtvTGgDdGwwwwwwwwwwww\0\0 wwwwwupWAAa`\0q\0\0\0\0Ap\00q\0\0\077wss471q7sssw7wwwwwwwwFtD`Fwwwwwwwwwwwwqp\0\0\0\0wwwWwW50RC\04\0\0\0\0q\05qws7SSsSq1a71qsw7wwwww` B eegwwwwwwwwwwwsq\0\0\0 wwwww0W%%@\0p!\0\0\0\0\0P71\0\0\077wW75!5#s5 ssqw7w7wwwwwvPFT`FFwwwvuwwwwwww71\0wwwwwW0pP\0P\0\0\0\001\0\0\0qw777sSWQqs455777sWswwwwwugtfDewWwuwwwwwwwwP\0\0\0\0wwwwwuqS0@\0\0\0\0\0 1\0\0\0\07sSW577s3q3ssusw777www7vVGE FFuwtwwwwwwwws10\0 wwwwuwwP4RB\0\0\0\0\0p5!\0\071qsssSqq451s7SsWwww7swudpDewwwwvVwwwwwu\0\07wwwwwWqaRR\0\0\0\0\0\0\0\0sSw3Wsw5571s3Ssw7sw77777su7wwDtvpFwwwuwwwwwwwq0\0wwwwwSuwA@\0\0\0\0\0\0\0\0p\03\0\0\01q5s1w7R1q53qssqqwwSqswvvt`D`DwwwFwtwwwwwq1\0wwwwwwuwua41\0\0\0\0\0!!\0\0\0\0w3s5ssw7173SSsscW75777sS71wuap\0FVwwwwWGwwwwwq1\0\07wwwwwwvqsQAE\0\0\0\0\0\0\0\0q\0\0\05sqw1wsSqa537SSsssw51sq7wVTT\0\0FwwwtpwWwwwsS7wwwwwwwSWWR\0\0\0\0\0\0!\0\0\0s57sw57sS SS73qsSsssSw1sweg\0\0\0@wweeewwwwwu11wwwwwwwwu65!A\04\0\0\0\0\0\0\0\0\01\0\0\0qwS57sssqps75qu7777751ssqwurVP\0tgwWwwgwwwwsq17wwwwwwwwwwWWWP\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\07s5sw7ww715qs73qsssSSsw1573wg\0\0 @\0wwvwwuwwwwsSwwwwwwwwwwwW571\0\0\0\0\0\0\0\0\0\0\01\0\0\0S53Swsq50S3S577777w7wwpa@t\0wwWwwGwwwwu17wwwwwwwwwwwusGu7wqt\0\0\0\0\0\0\0\0\0\0\0\00\0\0\0\05sc5sW7s''77753qqssSws3sswqa@G7wwgWFWwwwsSwwwwwwwwwwwwwuwWv\0\0\0\0\0\0\0\0\0\0\0\0\01\0\0\0\03qsw7ssqsSSSsG777wwwwwu  swwwVwwwwwwwwwwwwwwwwwwwwwwww\0\0\0\0\0\0\0\0\0\0\0\0\00\0!cC57sw7''3s7Sssswsw7ww3q@\077wwwwwwwwwwwwwwwwwwwwwwwwWwwaB\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 q1sSswssSsq747w777sssw77777wswwwwwwwwwwwwwwwwwwwwwwwwwwwwP!\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\00C57ssS56s573Ss3wws7773sssssw777wwtt$gwwwwwwsqs0!7wwwwwwu454\0\0\0\0\0\0\0\0\0\0\0\0\0\01sassusu3SCSsS7w33ww3sss73s773swswwV\0Pwwwwwwwv\0\0wwwwwwSRR%\0\0\0\0\0\0\0\0\0\0\0\0\0\0!\0015w773q2377s377s373373s773w7sww\0  Gwwwwt\0\0\0\0\0\0%wwwwW \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0as5s157wqR5s3w373337377777sswsw7wwCWwptwWwww\0\0\0\0\0\0\0\0SwWwwqaqC\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0! 1Ssqsss%33s3733s73733s7s7737swwq wwPwWG ww\0\0\0\0\0\0\0 7wWu7 P\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\01\05sqq%57s50Ws773333333ss73777wswwwwuGW%wwpGwp\0\0\0\0\0\0\0\0\0WwgwWqpp!\0\0\0\0\0\0\0\0\0\0\0\0\0!\01SS477s3773s33s333ss33sssss77wwwww4p%twwp\0\0\0\0\0\0\0\0\0wWWwwQ`\0\0\0\0\0\0\0\0\0\0\0\0\0\0\00100qq543SSw71qss3333s73337737777wwwwwwwGSRuvWw\0\0\0\0\0\0\0\0\0PWwwu5q%%A\0\0\0\0\0\0\0\0\0\0\0\0\0\0sww323#3#7333377733ssssw7wwwwww\0W@w\0\0\0\0\0\0\0\0A\07wwww5q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 0\00q054Cpqw773333333333333ss77777swwwwwwsurW@ G\0\0\0\0\0\0\0\0\0uwuwWS PQ\0\0\0\0\0\0\0\0\0\0\0\0\0SQp1s373s333#333s73s3s33ssssswwwwwwwwGtg\0gwp\0\0\0\0\0\0\0\0\0 t4www7SP\0\0\0\0\0\0\0\0\0\0\0\0\0\011!!0CSg3w73#33333#33333s3777777wwwwwwwvtv@B@\0GGu \0\0\0\0\0\0\0 WW pWSU1AA\0\0\0\0\0\0\0\0\0\0\00Rp173s32333#33333333s773ssssw7wwwwwwugw\0GtwvpW\0\0\0\0\0\0vwwwwsG\0\0\0\0\0\0\0\05\0\0\0\0\0\0P5!pPSs73333#3233323s3333s77777swwwwwFFDd\0tpwPP\0qauewp\0WSW1aS\0\0\0\0\0\0\0\0\0\0pq%732s1323233333#3s33777773s77swwwwweg@\0\0tv@\0uvw\0Ae\0Agwwwuwwwqu5!@\0\0\0\07\0\0\0\0\0BA3SQ0!0s3223333333333#33333333w3w777wwwutt\0\0eepGVR@WG p WwwwwwwWq41\0\0\0t0\0\0\0\0tu0qA2s33232333#23333s73s7773w3swwwwwBFt\0G\0\0dpGv\0w utwGtWwwwwwwwu4q1\0\0\0R\0\0\0utC1000322333333#333333333733ss3sssswwed@@@\0GD\0Atw$t vwgwwwwwwtsSCQ\0P5p\0\0\0\0d$@133233233#333233#337377377777www@\0\0g\0\0\0\0 pGwwWptuwWwwwwwugWup Q!\01P\0\0\0\0p\0@a23332333!332332333733s3sssssswwDG\0\0\0@Ad`gGGwWUgwAvwpwwwwvVtgSA0\0aC4\0\0\0 @\0\0F@!\03203321333#333333737777773ssw7tgg@F\0\0dF@gVwtwwguwFuDt wgt$gtrW%1CRPq\0\0\0\0\0d''\0G!01!3332332333333#33337333333s773wdD\0@\0\0@\0\0FwwppwVvwugwweut%dwVpW5pWqqA \0\0\0\0F@gg@\0033123323#33323733777777777ww@@\0\0\0F@\0pvwCDuGtCGtuvpVWt\0dW7wSC\0!G0\0\0\0\0\0\0D!0322333333333333373s33s3s7777d \0\0\0`@B\0@ggvtw$Wpt wew@gvG@Acquu%\0sP\0BVE\0\0e\0!031123#33333333733s3ss773sswwE@\0D\0@@\0DwGtuww@P`@wDwGFWeGG`GvDWwwR\05FtG@\0\0F023s333#23#233#3733s373sss77tfD\0\0\0\0\0\0FgvvvwgpgT$w GrPFVVwe@G`dSQwwwwwp\0TpG@\0\0G\0 12333333333333333773ss7377ww\0\0\0\0\0\0\0@\0\0vtwggwvWW`vTwd\0Fp@\0wwwwwwwu\0v\0\0\0\0\0 @vF\0s303#21333332333733737ssssst@@\0\0\0\0\0@dt\0GvvvVWeedvE eged@ud%g@p@Gwwwwwwww@\0 dv\0T\0De\0033331323#21#333s3773ss3777wp\0\0\0\0\0\0\0\0Et\0gdrG\0Ag@t\0$GVpBGGgwwwwwwwwv\0pDF\0\0@03s#33333333333s33s77777swe@\0\0\0\0@\0F\0F\0@\0@\0Tpp@ `\0G\0Gdd\0G@\0Cwwwwwwwwp@ pGpt\0t\0\0t!33173#333333#3333ss3s3sss7wd\0\0\0\0@\0t\0`6t\0@vdt\0v@E`tepWdtTwwwwwwwwp@D\0td@Ft`sq323#3#377373373w777wpF@\0\0@\0@@\0\0@@gD\0gdG@RG\0\0tfEdwBwwwwwwwwp\0ppFp@t017p2233333333#3733ss7377sst\0\0\0\0\0\0\0tVr@`\0\0 @dpgve`edd\0@ $pDewwwwwwwwp@F\0Wp`\0@\0g@q13033333333333s373sss7w@@\0@\0\0\0F@Dptt@ed\0`E@Edte@t@dv\0wwwwwwwww@\0gAGp  `@`0p2173323#2#3373s3ss7777w7t\0\0\0@\0\0@@\0p\0Dd`pvVGP\0` @GD\0G@ Ge\0 wwwwwwwwt\0\0\0\0GF@d @@10s3333333337333s33s3sssw\0F\0`@\0\0pFF@Pade@V\0VD@Ft edt\0@dwwwwwwww@\0B\0\0v\0\0C@ \017SS7#333332333s7777777wwp\0@d\0\0\0D\0e\0`F\0t\0F\0eDd\0Fppdpt@dp@wwwwwwp\0@\0w\0gD@D0s1''3#23#2337333333sssswFd\0@D\0e@`\0d`FGG@P\0\0F\0FG@\0Dt@dF@$R@d\0wwwegD\0@ @GwpGD`Vp\0SSs33333333337777773sswwD\0\0\0\0vv@GFT\0\0tdGFT@tpE\0Dg@@Fte@Gd\0G@egvVVB@d\0`wwDg@1''1533333333333333333sswwt\0\0D@\0dd\0FFFGggfte`@@F\0vwgggwv\0FF@efvddddD\0@@@Gw`\0@`\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0à­þ'),
  (3,'Confections','Desserts, candies, and sweet breads','/\0\0\0\0\r\0\0\0!\0ÿÿÿÿBitmap Image\0Paint.Picture\0\0\0\0\0\0 \0\0\0PBrush\0\0\0\0\0\0\0\0\0 )\0\0BM˜)\0\0\0\0\0\0V\0\0\0(\0\0\0¬\0\0\0x\0\0\0\0\0\0\0\0\0\0\0\0\0ˆ
\0\0ˆ
\0\0\b\0\0\0\b\0\0\0ÿÿÿ\0\0ÿÿ\0ÿ\0ÿ\0\0\0ÿ\0ÿÿ\0\0\0ÿ\0\0ÿ\0\0\0\0\0\0\030sW7ww\0\0\0\0\0\0\0``\0R\0\01pp@u7cu5qrQ!q5qp57\0\0R\0 p\0\0Cagwww33sqqw777w\0\00Wsw\0\0\0\0\0\0\0\0P\03113pPsC\0@\0\0  aat3QCVSuqw1qwqp`@vwgugpd%47wwssWS777SSs7311#Ww\0\0Cq vwsgwwq1Swsw pCSapqqwsV7775cwqw7tsWw qw5cw\0gwGgwsu1373Ssq77S110057P\0wSGqw171q3wwwpsGrQawwwwsRWWw5swqu7S1swq`''wgwww65g7su33qq575ssSw7q01p1g\0sgwvw31Q7wwwwpwvwwwwqu7su7sWwsW7W 5wwVwwvwwecWwgu3u573sqssS7sw111011111qpGvpwsSS13S1wwwwcwqwqwwwwwsSW7wWww7wsS55Ssw7wwwwwaw7SW3S33S77S77q15!13!17\077wq111qwwwwwwwwwwwwwwsSSw7wwwwwWs6Wwwwwwwgwtvs7s73SswqwwS1q30GvWg317wwwwvwww47wwwwwCuwwsWwwwww75u0sWwwwww`qww71sqs73S7ss771105S11sC www113q51Swwww57wwwwwwwwwu7sqwwwwwwwww7wwgwwwwwqs13s3qsw775sw1123 1\0''qs137wwwwwWSwwwwww6Ruw7WwWwwRWSqqww56w%5%ag75531q77qqsu711!111q1\0\0`Ag111q11wwwSSsw6SWw7su7RvwW7w7swwsgWwqwwwvR57533q33Ssu7777s0101 ''3S11q11qw77w5qu7sRvWvRt7sw7wwsw7Scqwww wSRsS1ssqq3qsw1qw71!0111151`\0vPw1qS1wwwqqcv7wvwSqssaacGwWqwuwWwug WwcSa47G3S71353ssssS1s13 % 1q31q1q1wsWw7u7SCSswvuue7SW67wswsw5w7w6wwwgvCqs3s1ss53Su7q3S7101!ssq114vwSSS15sussSSu7wwVwCRrSG445vwSuw7WwsWwqpqg1q1s571s3s3q73111!3P0qe1111S11suswuwwst7w77wu6sCqwsSww7Wsswwwwwwwww6SS371ss57113!50033S11!agssSs11Swswwssqu7qwwwwwrSW464wwwwwsuwWwwwwwwwwW733171s13311133Squ7wqq1111wwwwuw7qwwwwwwwv4wWswwwwwwsw7swwwwwwww7w1333sS13311!w3114s111qw7wwSq3q1117wwwwswwwwwwwwwu5wwwWwwwwwwwwwwwwwwwwwwww3q5573111311wq111s13113www1s11wwwwwwwsqwwwww7w7777ww7wwuwwwwwwwwwwsWwq133s1w3q` q!00SC7www111qwwwwwwwwwwwwsWw7wwtw 7wqsssuwwwwwwwwwwW731175113wgp\0 15131w7u111517wwww7wwww555wswwsw7usqwwwu7wwwwwwwwwswsS11113s111q`ww\0\0rC7117qww51q7qwwwwwwwu7www7wSSw5qw7wwwu7ww5wswwwwwwwwq313311gpwp\0\0\0\07113SS7wssQ51611wwwwwwsqsusw7w777qs71w7Sssw7ww7wu7wwwwww73133153Sww44\0\0\0\0\011!qsWq1q113Swwwwwsu7wswqqqqq7 SSW757w77w7ww7wwwwq1s301113w7qwpSp\0\0\0\077q11q1q17wwssW7w57q7777q353r1qsSswuwwwww7wwwwww31W1s44A\0\0q5151577S51q1Swww7wW7uw7swwsSS3S7575777wsqqswwwww13111s3sWSCSc11q733151cw7wSwws1751!11qqq1!31!wwSswwwuswwww131\001qs11u%u1s1SS7q551s1S3wsw757SSqsS31111w5sswswswwq1111q7711ssq7w1sSsQ3SWwWw71s31111su7swwsWsws133131311557sq1!q17q1537q1q71773qs11!\013q577u0wws11313113swS10ww711Ss1q7qq1Wwq1\0\0\0!wwsw0sw313q11q1P11p501w511q1q11qq1511!1q11s10\01sw5wW q3q3111RRS53s7711111!11!\07w7sqs753533P1551sS531151151q713!!qssw7we1qs535130s1!3SSSS3q5511111557Swww013S3Ss11!7113Q15!3S1qq313!1\0\01Ss7SpRq133S3S3s 3Q1qrSSq1q3Q503s1qs1111R\0\0!p01!53swsqG1131s57711q33311q37qq1111111\01031ww21113113s 01!53111q%135171551\0111151wu 113171q57A1 !1111SWsSq11S1!\01011s57ps1111qs31s7SS1q53S!1137sw q13011111151q51q5115s1sw31!1!sw103!11sa`3s53113S751s3qs11\011\0\031qswpwwWu11pp`pp\0 s1SSQsq51sWs7110\0\0\051wWw7sw7wwwwwpSG%51s171SSs1wS1Q\01\0\0#\01wp7wwwwww7wppw%wwwa40Rw555571sq7q7w111311\0\0\0\0qswpwsuuwWwwwww6wvqwu sSsq1qw5557171s1\00 3017sw wtwsw47Ww%wwwww vp6W7u757SsSss17u1q\0\01\03qwsuwwwSwwwgvwgwpwSsqq7Sw7qqq53107wQ\0\03\0\0757wwwwwWwwwwwwwwwppw5577ssw51qw773110s1\0\0\01!17u''wswwsWwgvwwwwwpRS75773Sqq31311Wq\0\0p\0\0\0\03SwutwwwwSww%pwww%1qSssssqswSWqssQ113q\0\01\01!1#ww7WwuwwwwrW Ce1q77qsu557v77300\00Sww7wwww% 5 qwSCSSs5swpquss11\0\000q7wwwwwr BWv46q%151qswWW ssu111111qwquwu5w 5u4qww SSw7sw7sSWww111\001wwsCwww BacCpvrqqwwwwwwg7sqq111wwwuwwwuRWwwww 55vwwwwwwqsW5ss\0\0\0\0\0!swwwwwwWac''wwwwwwVwsWwwwwwwu7w5511\0\0\0\0\0\017sSwqquwwRWPwwwwwsswwswwwwwwswsw31!\0\0\0\00a!q011qwqwww''ww''wwwwtwwwwwwwwwww57S1\0\01q1%1wRW7wwPwvWwwwwwwwwwwwwwwww7sq7\0\001u7wwWwww''57wwwww7wwwwwwwwww57Sq5q1!\0\0\0\010!!54!7u7SwSWvWCGwwwwwWwwwwwwwwww73555\011\05!Sp03wWwwww57t7wwwwwsw77wwwwwwwWqq1ws311Www711a560w7wwwwCGAg6Ww''Wwwwwwwwwwss17111 sw7w1SS65qs1q7wWwwwwt746uerw7Wswwwwwwwww77151 \0w7wWs\01!3C7!pswwwwwAAasswvwswwwwwwwwwwwwq1111ss117sw''1\01q51S!1uwwwWww46!agVu5wwwwwwwwwwwwqssS1 7wu711wq1su!qsq1q11Sq377wwwwwAaRPqcRw7wwwwwwwwwwwww110sQ3S553pSsq57uS0WwWwwww!aRwwwwwwwwwwwwwwwwssWsQ13S051w''w7wq%77051 !17wWwwwwwRPu4wwwwwwwwwwwwwwwwwW37s51A0!%Q7sS10Sww5!1p!7wsWwwwRvsGwwwwwwww7wwwwwww7qq1u111R1!Q1%Q4ww1Sq1qR1q3WsWwwwwu4st7ww7wswwwwwwwwwww77553q3111S51S7www55wvsuwwwwwwwwwwwwwwwwwwws0S1!1!1%15\01Q1q0101%wwwWww7stwcGwwwwwwswwwwwwwww7wq11S11!111705 01wwwwWwwuw7W7wswwwswwwwwwwwwwsS10!!!0wqss1011!qwwwwwWwcW''Wwwwswwww7wwwwwwwwwwq11q117sSq!q0!0u!1wwwwwww7WrW''wwwwwwwwwwwwwwwwsw7151001!wwq000s!sWwwwwwwwW''u5ww7swww77swwwwwwwswSSqqp1wwqWq01sqq7wwwwwwwrW''cSwwwsw7wwwwwwwsw7qw77SsQ\011w7170SQ17101wwwwwwuwu5Wwww7wwww7wwwwwwwwswww\01wsS1 Rwq121CqqsSwwwwwwww''cswsw7w77w7wswwswwwwsWw11q1%5007w11!!515!0!130q1wwwwwwwwWwwwww7wswwwwwwwssssw7wq01qw1Rs!0P1S7q7wwwwwwwwswwwww7ssw7wswwwwwwwww3wwS11!wqs1011 q011!wwwwwwwwwwwwww7w7w7wswsw77w7777ww115 SQ s!r%0!7wwwwwwwwwwwwwwwwsssW7wswwww7wwww7www!110q7!7q5%5!0q1q0175wwwwwswwwwwwwww77w7swwqssww777qwww1W7sS5q1sW1111RQW7wwwwwwwswwwwwwwwsssCw7swwwswcwssswwww11sW551!0w1qRS1QpsR1sW773wwwww7wwwwwwwwwwsw55wwwwsW7sw77w7ww1wws5551!\0\01 w50500153usWwwwwwwswwwwwwwww5ssswwwwwwwwwqsssw1wwqss51sSq0p01\0P1qR!51p7S511aqS1swwww7wwwwwwwwwwwsw''77 wwwwqwws77wwww1sw1sS1w1!!SS131swwsw7wswwsw7wwwwww SW545ww7wqqwRsswwwwww1S1sW51s1A q011!Sqw557wwwwwwsSww7wwwwwwwwsw77''7747uwwwqsswwwwwwww1sS755500!57qw7qq7www7w7wwwwwwwwwwwwwwpwsSCesw7SW77wwwwwwww17qswSSSsQ1q1 00qqwSqw3Swwwwww777wwwswwwwwww7 s52wwqAw7''7wwwwwwwwww3SSsq77w0001sq157sw7wswwswwwsww7wwwwwswwsssv3SSQw0PsSswwwwwwwwwws7557Ssqsq77 03qw51qwW53SW7w7wsswsswwswww7wwwww7w451r7''w541swwwwwwwwwwwwsSSsSqwSw1105WWsSSSq713W73q1wwwwwwwwswwww7wwswwwwws67557swu577wwwwwwwwwwwwq17qqwq7575sSC Sq7w777577wq3Rwww7ww77swwwswwwwwww7wwwqpscW502RV77wwwwwwwwwwwwwwQ77swqw53W51qqqu5757SqsSwSWwqsqcqwsww77wwwww7wwwwwww7ww7ww7%7#cSS517wwwwwwwwwwwwwwssSSu1w7SwsWwssSqsSu777357qsSqpgRBGwswww7sw7wwwsw7wwwww7www7qw7%!cwwwwwwwwwwwwwwwwuwsw7w1sQ757w75u77757SWS131ss\0$sCwsswwwww7w7wwww7ww7wwwww77wwwwwwwwwwwwwwwwsgwSSsqsSqwww3575qqw7s17\0\0\0t4w5wsw7sww7wwswwwwwwww7wwwssswwwwwwwwwwwwwwwwwwsGW77pqu7577usWSqsswss5551!at!0\0\0\0\07sqw7ww7wwwswwww7wwwwwwwwwwwswwwwwwwwwwwwwwwwuw4rwusqw SqsSSs73qsSu1qqusss54q\0\0BqbG677cswssssww7www7wswww7w7wwpwwwwwwwwwwwwwwwwswSWwwwwpsS77SsW57w773517\0pqBS`\0\0wqw7swwwwssw7www7wsw7wwwws wwwwwwwwwwwwwwwwwwvqwwwwwP@`1!1qw7qs1wq1141 4t54AawrvSccqw7777w7w7wwwwwwww7w7wswwwwwww7wwwwwwwwwqgwwwww''7 Wgsw1`7cCC@4w7vwa qa\0pwW77qwcugRqsSwwswwsw7w7w7wpvwswwwwwwwwwwwwwwwwwwwwwwRVw Sg151w`rww t4wgwwtvpww7gwarr3w7777swwwwswwww7W7w7 aswwwwwwwwwwwwwwwwwwwwwwwwwsWu''wqrSpq usugcrSw4wwwwru4wwvwwp7wWsssR5#swSwswsrwsSSww5wswsww7wwwwwwwsw7wwwwwwwqwarWwwwv  ppwvwwswVGwwww SgewwwwpP327Cppsw5ws67wsww46wvp\0vw7wwwwwwwwwwwwwwwwww7wwwwAv''pwgw0pw  swgwC7'' wwwwQ$7vwWwrwe05777Swqp7t7sSR\0 swswwwwwww7wwwwwwwwwWwwww6!GwwSW@ %%wwv4PPCw `qw''P\0\043\055677u7wcGv7vp \0u''7sw7w7swww77wwwwwwwwwwwa\0  ''c\0\0\0 %v\0\0\0 twg`6\0SG \0\0c407\0qpw u%57 \0 swwwwwwwwwwwwwwwwwwwwwwws\0u%4\00CRCpPpWg`\0\0P\0''pC@@ QCppPC7@pwrsCvppp\0Cw577wwwwwsw7swwwwwwwwwwwww wrR  awg  @6Ww$cg 7#\0rpRW \0w 0p pqcp  `\0 Sgwwswsswwwwwww wwwwwwwwwwwwS  u`!qvwaaS''vpwag ''pvqPp%%rW%pP @p40  wgwppg777swwsw7qgwwqqqwwwwWwSWwwwRRRP``qaapR!cW p4rWwwwq a wwww% p0pwp\0qaawwwww  psswwwwwwwww77wwwwwqwwwwwww  wwwww  wwwwwwsW5wwwwwwww5wwwwwww wwwwwRWw4\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0á­þ'),
  (4,'Dairy Products','Cheeses','/\0\0\0\0\r\0\0\0!\0ÿÿÿÿBitmap Image\0Paint.Picture\0\0\0\0\0\0 \0\0\0PBrush\0\0\0\0\0\0\0\0\0 )\0\0BM˜)\0\0\0\0\0\0V\0\0\0(\0\0\0¬\0\0\0x\0\0\0\0\0\0\0\0\0\0\0\0\0ˆ
\0\0ˆ
\0\0\b\0\0\0\b\0\0\0ÿÿÿ\0\0ÿÿ\0ÿ\0ÿ\0\0\0ÿ\0ÿÿ\0\0\0ÿ\0\0ÿ\0\0\0\0\0\0\0wwwwwwwWswW7w7swwwWwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww44qat65psSCeqqsw#W\0\0wwww7ww7ww7e7wusww7Su7wwwwwwwwwwwwwwwwwwwwwtvW%!$4wwwwwwwwwwwwsWw7St6%426 W''wwwswwww7wwwwwwuwuwwsW7wwwwwwwwwwwwwwwwwwww%$\0\0@`@\0\0\0\0\0wwwwwwwwcSG6Spw5''WwWww7WwwwwswwsuwqwqssswqwwwwwwwwwwwwwwwwwwwwwpRC\0@ \0\0\0\0\0\0\0\0\0\0\0\0\0wwwwwwqwgsqr7 pRprqsW5gswssWwWsWw7wwwwwwuwSwwwwwwwwwwwwwwwwwwwRQ eA\0@`\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 wwwwqqugWWs 7 g4sqwwwwwwsWwwwswwwwwwwwwwwwwwwwwwwwwwwwwwwwga A B\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0wwwww7scpu5%%asWsuvsWwsWww7WwwwSqsW7wwwwwwwwwwwwwwwwwwV\0\0\0p\0@\0@\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 wwwwww7vww7erWrswwwwwswwwsW5swwwwwwwwwwwwwwwwwwwwwvSawwwwe\0`\0\0\0\0\0\0@@\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 wwwwW7vqqpu7wwWuswswwwwwwwwwwwwwwwwwwwwwwwwwwwwwww%wwwwqww\0@\0\0\0\0@\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0www7WuwwwrqqwssWwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwVu7wWgwV\0$qB\0`@@@@@@\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0wwwwssppuggwtw''wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwWW%6Ww''uw\0\0d%\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ww77ug7sqsSw5wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwV7cWaggWwwp\0\0P \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 wwwwqt4wwwSRqwwwwwwwwwwwwwwwwwwwwwwwwwwwww7CWcW7WagR\0u`@\0\0\0\0\0\0\0\0\0@ \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 wuswswwguwwwwwwwwwwwwwwwwwwwwwwwwwwwwwvSt5t4wpwu!a%pCBF\0\0@\0\0\0\0@@\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Gsw4ucwpqsswwwwwwwwwwwwwwwwwwwwwwwwwwwwwQaCBCe%''wwV\0 @4\0\0B\0\0\0\0\0\0\0\0\0 \0@@\0\0\0\0\0\0\0\0\0\0\0\0\0wuw75awwwVwwwwwwwwwwwwwwwwwwwwwwwwwwwv64'' RVwWwwwwwp\0\0\0\0BR\0\0\0@\0\0\0\0@@\0@\0\0\0\0\0\0\0\0\0\0\0\0\0 ssRV''sSwwwwwwwwwwwwwwwwwwwwwwwwwwuAC@VAgG www45v\0\0\0\0u$@\0@\0@\0\0\0\0\0\0B$\0\0\0\0\0\0\0\0\0\0\0\0\0wVwsaWwrWwwwwwwwwwwwwwwwwwwwwwwwwwwwpsc@p1gp%  wur% \0\0\0R\0\0\0@@\0@\0\0\0@\0@\0\0\0\0\0\0\0\0\0\0 sR56477wwwwwwwwwwwwwwwwwwwwwwwwwwg% FC\0@CCBuq\0PrQ\0\0\0\0p\0\0\0\0\0\0\0\0\0@@\0 \0\0\0\0\0\0\0\0\0\0\0\0\0wwWCStwGgwwwwwwwwwwwwwwwwwwwwwwwww rCRt!$ BB\0$\0ABp`\0RG4\0\0\0\0B\0\0\0\0\0\0\0\0\0\0\0@@@\0\0\0\0\0\0\0\0\0\0\0 qr56SqsSwwwwwwwwwwwwwwwwwwwwwwwwtw4%@\0\0C`t\0a%0Ca \0\0\0@d\0\0\0\0\0\0\0\0\0\0\0\0$\0\0\0\0\0\0\0\0vwRSwwwwwwwwwwwwwwwwwwwwwwwwwwwwe74qrBB$\00C@V B@C4\0\0\0\0`\0\0\0\0\0\0\0\0\0\0\0\0$\0\0\0\0\0\0\0\0\0\0\0sPw%4455wwwwwwwwwwwwwwwwwwwwwwwwsFwCB@\0@\00e!`@\0\0\0\0\0\0!`4\0\0\0%\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0''CCSprwwwwwwwwwwwwwwwwwwwwwwwpt556\0``4@pCG\0\0\0\0@\0BAC@ \0\0\0ee\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0qCcRw 5wwwwwwwwwwwwwwwwwwwwwwwwSGvQ`a\0@rE$\0P@B\0\0\0\0\0\0\0 00P`\0\0\0\0aa`\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\04q qwwwww7w7wwwwwwwwwwwwwwwWwg4w$$ @pE%!` \0@\0\0\0\0\0\0@\0@\0p\0\0\0\0BG\0@\0\0\0\0\0\0`@\0\0\0\0\0\0\0\0\0aRpw1gwwwwwwwwwwwwwwwwwwwwww7RWwRFPcG%$\0@@@\0\0\0\0\0\0\0\0@\0@@!% \0\0\0\0\0G\0$\0\0\0\0\0!@\0\0\0\0\0\0\0 VuwwwwwwwwwwwwwwwwwwwwwwegwA`u!VaRCC\0\0\0\0\0\0\0\0\0\0\0\0\0@5s@\0\0\0\0P\0\0\0\0\0\0\0\0\0\0\0\0\0\0 %5surwwwwwwwwwwwwwwwwwwwwwu7wv$tp%arV%\0@Dd\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0qg \0\0\0RB\0\0\0@t\0\0@\0\0\0\0\0\0rScurWwwwwwwwwwwwwwwwwwwwwwvVqgP2DpvWVRP\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ae \0`T`\0\0 \0\0\0\0\0\0\0   Wrwwwwwwwwwwwwwwwwwwwwwwwsqgude&E!wqa`p!e%gGt0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0p w\0 4a\0\0p\0\0\0\0\0\0\0pprWu7wwwwwwwwwwwwwwwwwwwwwvVSRSR GwCCAtpu57S\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0pPw@\0F\0Sd\0\0\0\0\0\0\0   7w7wwwwwwwwwwwwwwwwwwwwwwqst$ BG5e447Cw6vW0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0rRWww\0\0@d7@\0\0\0\0\0\0\0pquwwwwwwwwwwwwwwwwwwwwwwwwvVSCCAe 4w6tsCt5qwwA\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 1wwwBwt\0\0\0\0\0\0 %$''7SwwwwwwwwwwwwwwwwwwwwwwSstp$0GgpW4wSvwqw0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\04!wwwu\0\0Vw\0\0\0\0\0RSuwgwwwwwwwwwwwwwwwwwwwwwwvWC\0CA1wsewqgWww\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\00\0awwwv\0`\0\0BV\0\0\0\0aRswwwwwwwwwwwwwwwwwwwwwwSct%$$!GWe%6Www''sWg\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0!7www\0p\0\0\0\0B@\0\0\0aCWawwwwwwwwwwwwwwwwwwwwwuu%BPRRu7VSrW5wWsW0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 www\0w\0\0\0\0\0\0\0\0%0\0 !awwwwwwwwwwwwwwwwwwwwwwrwr%%%6t54uwww''wwA\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0www\0\0\0\0\0 \0\0\0\0p@4Wwswwwwwwwwwwww7wwwwwwwwuwBRBVwvwrsGwwGw\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0! www@\0\0\0\0\0\0\0\0CC@444wwwwwwwwwwwwwu7wwwwwww p%$%%cWRWWwuwqw0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0!www\0\0\0\0\0\0\0\0\0\0\0pSscwwwswswwwwwwwwwwwwwwwwqg&4sWcwruswwwtq\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Wwwp\0\0\0\0\0\0\0\0\0\0 aa%5wwwwwwwww7wwwwwwwwwwwwwvqAaA`  aug5rtswww0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0''ww\0\0\0\0\0\0\0\0\0\0\0\0 wv7wssW57W5wwwwwwwwwwwwwwu4\"PrApwCwWuwuuwwP\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0$\0\0\0\0\0\0!w`\0\0\0\0\0\0\0\0\0\0\0g 45uwwwwww7wwwwwwwwwwwwwwwwgE$%qvSg''qwswsp\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@@p\0\0\0@\0\0@\0\0\0ww7sWwwwwwwwwwwwwwwwwwwwww0pbPBQgewWvqgWWp\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0v\0w\0 p5%%4wwwwwwwwwwwwwwwwwwwwwwwwvV %%$5cRpwwww''wq\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0R@\0 a\0t\0  vSw7wwwwwwwwwwwwwwwwwwws uwu0t\0CF5''WwWu5wpp\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0%$\0\0\0p\0p\0\0wauwwuwwwwwwwwwwwwwwwwwwwtqgsweSAe$Vu'' gwguwp\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0aB\0\0\0\0\0\0\0\0\0\0 ''wwwwwwwwwwwwwwwwwswqvtwwp$6R`t6Wu7wwrWs\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0%WpRwwwwwwwwwwwwwwwwwuw wW wea@VAae%''ewuwwq\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Vp`\0\0\0\0swCR\0 a 5wwwwwwwwwwwwwwwqwwpspRuaw4s`V%vSV4wwpp\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0!a\0\0\0\0\047wwwwu5wwwwwwwwwwwwwwwwwwwuww %6g aaBRAe%wsewq\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\06\0\0\0\0\0\0\0\0\0$447v0qwwwwwwwwwwwwwqwwwwrGWW wrP64%$6RRWwww\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@@\0\0\0\0\0\0\0\0\0\0\0\0\0\0W''wwwuwWuwwwwwwwww5w5wspQ t0e5$PpABRAae% GC\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0   `\0\0\0\0\0\0\0\0\0\0\0\0tw7Wwwwsw777wwwwwwwuw5vwwRPpGw@rC@RVsqw3\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0p\0\0\0\0\0\0\0\0\0\0wvwwwuwwwwwswwwwww7wwwqqat5  aFW $`PRVV6ss\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0uw\0\07@\0\0 \0\0ww% wwswwsW7Wwwwww5ww7wp \0sBp5%seppR@ \0$45qs73!\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0wv\0w \0 `\0\0u\0\0t7V7wwwswsW77www5wwwvS p5%a`p''%$%%`pCA  Gsw6\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 www\0w@\0p\0v\0 wt!guwwwww7sSWwwww7wpu4\0` !rRPWwRR@pp`@t47332\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\07wwp\0w\0\0gp\0 w\0WwBV!wwsswwqssswwwwCwwwAw0%aAe%%Ru%v@CG CBww720\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\07www\0 \0p\0w\0''wpVswwWsSsQqu7wwwpPSw644 A`put4444ppV7sss!!\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0wwwt0\0\0\0W\0\0waeww0Wsw6447 wwwu0''wprSCA`46stppaa6abRRC@a  %asw776\0\0\0\0\0\0\0\0\0\0\0\0\0\0wwww\0\0\0\0\0\0\0\0uBSgpV7WsqrsSpswwsaAwwAA\0A''''\0@RU5%4`RP$7sw7371 \0\0\0\0\0\0\0\0\0\0\0\0wwvt\0\0\0\0@p%vwsG6wwWuwCAwwpRWw!qaew''40@ %45! v!ag7agSB3swsv1!\0\0\0\0\0\0\0\0\0\0\0\07wwww\0\0\0\0\0@\0Ru4pCGqr57scwsswww%''uvPqwwPA%5B\0R@R!GPpwwwws3s3s73\0\0\0\0\0\0\0\0\0wwwuvp  \0\0!Ae''RC%cwwwu5usuwRww RWww7wqq 0 PvpPGw%7!a!%''Agwwwsww7w7rs3\0\0\0\0\0\07wwwww\0W@\0\0`\0 V4Ru57sSw75wsww@0wgqwwwrQA wwwwWa$pA'' wuswssw373sss2P\0\0\0\0wwwwvw\0'' \0\0t\0uw\0gRwuWguwsuwSwGvqqwwwsq 7@Bw@!w7rp` \00@wWswsW73wsw77#s341\0\07wwwvWvWP\0\0 w\0w@$RwsS57qsqwwswswu5wwwwweuqv0qA5aCCC\0 7wuwwww3s3ssw7733#\007wwwwwwW`p\0\0\0w@0PWs\0%WgwqwtwqswwWwwwwwwwuss @\0AvQ%CB  %4\07wW7qsw7w7w7733sscs73wwwwwWwrwp7\0\0 w\0\0&wt\0\0cW57wg57uwwwSwww7wswtp\00\0wW$4\0\0W%swW7wwwSW3w3777v7733swwwwwwwGuw\0\0\0\0\0w\0Qwr\04rwqwwwwwwwswwwwwuqwwWp\0u  \0\0a\0ww7u55swswswsss3s3w77wwwwwwwwwwp\0\0\0\0\0\0$7t\0CuwwwqsW57wwwwwwwwww7Qs@\0\0v0\07pp @@\0p7w7wst5577777s7s7wwwwwwwwwwvwe \0\0\0\0GC@t7wwwwwusWwwwwqwwwwwu5gr7\0\0\0t0   5 7B\0Puvwwsrqsssss7s7wuwwwwwwwwwWp\0\0\0\0\0\00v\0twwwwwwwwwwwwwwwwwwwws C\0\0 S@\0\0`1\04\0w7wSwwSRw77SCwwwwwwwwwwwwwA\0\0\0\0\0C A\0VswwwwwwwwwwwwwwwwwwwwR4P7p\0\0\0  \0\0\0qswSuqrq6cRs0w1wwwwwwwwWwtwwr`\0\0`\0\0p\0t6\0 twwwwwwwwwwwwwwwwwww$A 5p r\0\0\0\0p\0pwW767SssSqSpWwwwwwwwwuwwwuu\0\0\0\0 \0G\0\0t7wwwwwwwwwwwwwwwww7SwwR$wrww\0\0\0\0\0\0\0\0p\0\07Sct5cSqR1pq%715s7wwwwwwwwwwwwpav\0\0w\0\0w\0$7\0\0Vwwwwwwwwwwwwwwwwwww!CA PCAp \0`\0\0\0\0\0u''5sw577VSSRSC1pwwwwwww7wwwwwvC\0\0w\0G@SWp\04swwwwwwwwwwwwwwwwwsSAcP40u!B\0%\0 `\0\0\0\0\00sqwSSAsQ3W6551t1wwuwwwvWwwwWwpt\0\0wp\0wp$vq\0CewwwwwwwwwwwwwwwwwWvrPwawBCq\0`\0\0\0\0\0\0\0psRq''776S%541rRCwwwwwwwwwwwwww@w\0\0wp\0wpWv\07wwwwwwwwwwwwwwwqswat7\00@pPpPa\0 %\0w57SRSaq53S1rSww7wwwwwWwwwwt0\0\0\0 \0\0wp`wu\0BVwwwwwwwwwwwwww7wwpqqp\0\0u\0!a\0!\0aA%!sG57qsSCRWG1ppvwwWgwwwwwwwvWs\0\0\0\0\0\0\0''7v\0!awwwwwwwwwwwwwwwwqq\0$6\0\0pPuuv@ptWcwrW437u1w#RwCwwuwwwwwuwwt0\0\0\0\0\0\0\0P''\0\0RVwwswwwwwwwwwwwWqg\0S\0\0\0\0\00`0$As wt47Wppq#RqS RpwwwqwwuwwwwwwwB\0\0\0\0\0\0\0p0\05wwwwwwwwwwwwww7wqa\0 P$a\0p \05@0$5$wwSpsq17Q5r5qq5wwwWvuwwRwwwww\0\0\0\0\0\0V\0acswwwwwwwwwwwwuwwq`\0!\00\0aar@pA\0awwwrSSRVQsCa1sQ!!C%wsWgwvwgwuwWuvr\0\0\0\0\0 p \0\0twwwwwwwwwwwww7w \0\0\0qa\0 pww7qap717%0w%#qs5wwwwuswqww7gww\0w\0\0\0''\0\0 \0\0Pwwwwwwwwwwwwww7w00\0$% \0 \0\0\000 te wwwwww SqsgQ 2Swww7swWwvwwwwwtu`\0\0 p\0 p\0\0$$wwwwwwwwwwwwwWws@ \0004\04P\04 swwwwwqps15''7R16qcQwwWwwwWwWuwwwgp\0\0p\0\0Gt\0\0swwwwwwwwwwwwwsu4\0\0\0 C!!w\0P1wwWwwu5w 1GRQap1saa6wwwvWwrwwwwww s@\0\0wp\0\07R\0`twwwwwwwwwwwwwwws\0\0\0\0\0541qsA!Gqwwwwwswq 01c csaAwwwwwGuvwwguw\0T0\0\07v\0\0ww\0P wwwwwwwwwwwwwusW\0\0\0\0\0!SSV75w5ww77w7wwwpqaCRrP7wwqwwwwwsGwwwp \0\0\0 w\0 w\0`pwwwwwwwwwwwww7ws\0\0\0\0\0\0\0\05155rqw7wuwwqww1ap7swuwwwgwwwu7wWsWww\0\0\0\0\0\0  w\0\0p wwwwwwwwwwwwwWsP\0\0\0\0\0\0!3CW''57sWwWwswwwwas!cWwwwwwwwwwSGu7wewwwwvwa\0\0\0\0\0p\0\0$\0 \0wwwwwwwwwwwwwwswp\0\0\0\0\0\0\01p1qwWqsssuwwwwwSWsswW7wrwwwwsvuwwv7Wwqw\0\0\0\0 \0\00R0`wwwwwwwwwwwwwwSs\0\0\0\0\0\0\0\0!0557sqw5uuw75wwwu!sw7www7wwuwwwwuwwuwwvqwwa`\0\0\0\0\0$At#wwwwwwwwwwwwu7wp\0\0\0\0\0\0\0\0\0aRPsu%w5g777uswwwww57w5swwuswwwwwv5rv7wwwwwwp\0\0\0\0$\0\0RP4Twwwwwwwwwwwwwww\0\0\0\0\0\01470SSsVqus4wwwwwwqqw5wwwuwwwww5wwwWwpwWgww@\0g\0C@ BpCwwuwwwwwwwwwww4\0\0\0\0\0\0\0\0\0\05#35sw757suwwwwwwwww7wwwwwwwwwuw uwwewwsuwpwp\0u w Rt0Rww7sSwwwwwwwsWw\0\0\0\0\0\0\0\0\01ArQ#P57RW7wwwwwwwwqwwwwwqwwwwwwwqawwwuwwpRw\0''vtwV\0wG%uwwwwwwwwwwwwswp\0\0\0\0\0\0\0\0007Q75#pq77SuwwwwwwwwwwwwwwwwwwwvW''wwwwSgwwpwRwGwaewppR7swwwwwwwwwwwwS\0\0\0\0\0\0\0\0\0\0QqqqpaSW7WqsCwwwwwwwwwwwwwwwwwswu7Wwwwwwwwaec@wwD%wRCwpp''wwqwwwwwwwwwqssP\0\0\0\0\0\0\0\01##5a0qS17wwwwwwwwwwwwwwwwwuwwwwwwWwwwwp!Gw!wawe$wwwwwwwwwwwwwt5! \0\0\0\0\0\0\0\0\0a#Q553tw3SwwwwwwwwwwuwwwwwwwwwwuwwvwwwwV!B!BPwwpppqwwwwwwwwwwww1p\0\0\0\0\0\0\0\0RQ56SE3cW wwwwwwwwwwwwwwwwwwwwwwwwwwwWwwsC42R R  wwwwwwwwwwww!a0C\0\0\0\0\0q51p5uqq5wwwwwwwwwwwwwwwww5wwwwwwuwwwwt\0CCDp% Ra`$4wwqv7qwwwwwwwP5 pR0\0\0Sq5u541!4S57wwwwwwwwwwwwwwvuwwwwwwwwwwwwwwpp44C PCaBpawwwwWwqcwwwwwu5a %\0\0qg553asW5qwwwwwwwwwwwwwww77Wwwwwwwwwwwwww\0a`4 ''0a%qvww7wwuwwwwwwwwRp5cRVw#Ru 47WwwwwwwwwwwwwwsWwwwwWwwwwwwwwwwtw\0V0`% wwwwwwwwwwwwwwwwww0pAa wwwwqqq5%5sSsSqqwwwwwwwwww7wwSwwWwwwwwwwGwwwwwwvw`AGw p``wwwwwww7wwqwwwwwwwwwA0wwwwwwwwwqqp%47wwwwwwwwwuwwwwuw7Wsw7wwwwwwwwGwp%pw$0w`aBwA`Raww57wuwwwwwwwwwwwwwwvwwwwwwwwwwwwwwq''wwwwwwwwqwwwwww7w7wwwwwwwwwwwwwwB@Gwu$4w4wwwu77wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwWwwwwwwwwwwWwwsVwwuwwwwwwwwwwwww7aa\0wpRCwv\0&57wgwwswwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwSuwwwwwwwww7wwwsSwwu%wwwwwwwwwwtv w%%w@Pwuwu1wwuwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwggwwwwwwWw''wwwwwwwwwwww `w!`Rw4 2@wwww7wsSwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwu55grwwWswSawwwwwwwwwww \0 `\0@@''wuwww7wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww55uswwww WwwwwwwwwwwwCCC C !`pa$wwwwwswwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwswwwwpswwwwwwwwwwww\0\0@$\0`B\0\0\0 ww\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ö­þ'),
  (5,'Grains/Cereals','Breads, crackers, pasta, and cereal','/\0\0\0\0\r\0\0\0!\0ÿÿÿÿBitmap Image\0Paint.Picture\0\0\0\0\0\0 \0\0\0PBrush\0\0\0\0\0\0\0\0\0 )\0\0BM˜)\0\0\0\0\0\0V\0\0\0(\0\0\0¬\0\0\0x\0\0\0\0\0\0\0\0\0\0\0\0\0ˆ
\0\0ˆ
\0\0\b\0\0\0\b\0\0\0ÿÿÿ\0\0ÿÿ\0ÿ\0ÿ\0\0\0ÿ\0ÿÿ\0\0\0ÿ\0\0ÿ\0\0\0\0\0\0\0wwwt\0Cs@t7777 7wpCpwwwwwwwCwwwwp\0S@@g5wwu\0t\0\0@\0P\0BP\0\0wwp\0B 7777sww0  3w0ssrP\03t0\0\07777w7v CwwsGsswv7wwwwwwTwwwww@ P%swwPSPp\0P\0\0\0\0\0ww7ssssw3p@\0@@pq!Cw776r\0\0swwwwww7w@D''Cs 7wwsCAwwWwwWGpwWwww@ P\0wuwwp@aC@\0\0\0\0\0\0\0ww\0\0wssw7ssw\0@\0\0 777sSas\0\077ssssu @@@E7tww777wwwgwwwwwwwwwwp\0GpGw7wwp\0\0\0\0\0\0\0\0wwp 777sw77 \0\0@@@qsssw7774\0\0 wwwwww6D@BG 77wwwswwWwwwwEvwwwwu\0w wSwwu\0e\0\0\0@\0\0\0\0ww3sssw3sw\0@\0\0cw7sssss\0\0\0@@ssssw7p\0www77swwwwWwwww BwwWuwwwwWwuwwvs@\0\0\0\0\0\0wwv7777sw0!@\0\0@77777774\0@@\0\0wwwwsu6RD@@@G777wwwwvugwwwu4uuww7wt ww wwwqVPCQu\0\0\0\0\0\0\0w\0Cssw  \00@\0\0ssssss7r@\0\0sssswcE4\0BDswww7swwuwwwwwwgRpw5wwqw7wWuwwww@\07 q\0\0\0\0\0\0@Gwpp3sw\"Ss70@\0 7ssssv@\0@@\0wwww67 D@CwsswwwwwwwWwwwwWwWGw7wwwwwsqwww@\0\0u1v\0\0\0\0\0\0\0wq\0 73Q''7s3Csa`77w7sP`\0@\0\0@ss76Sw7ss@@w#ewsswwwwwwwwWwwVwwWwwpWvwwWww\0P\0sWq\0@\0\0\0\0\0 w@63 W0\0as7p\07\0\0@\0wwwe47cw  sD''7wwwwwwwwwwwwwWRwswwwpGwswww0u7P\0\0\0\0\0\0\0\0ww\0@\0Csssp7#q`''7s73s44\0@776@Cgw7ppw74Stwwwwwwwwwwwwewu%%wwwquu@ wWww@ \00ww\0\0\0\0\0\0\0wwSw1\0\0 7s ss7`\0S6` %cR\0\03Pwepsw7psww$  7wwwwwwwwwuwWgwTWwwsv\0w7ww\0W7w\0\0\0\0P\0\0\0\0\0w4 q7R77737\03@@737%447 @C@GVpwwssRPwu''wwwwwwwWwwuwV7wwwwwq@@wwsWwpSqWp\0\0\0\0\0\0\04\0 sCQ\0P!\0w77w77sp\0\0qw70ssp@D''`7777wwwsFVWwwwwwwwwwwueTwwwwWw\0\0 wwwu\0qg7P\0\0\0\0\0\0\0\0\0Wu3WPq0cs33s4\0@@63C w750@\0`Gwwww7sstauvwwwwwwwwwwwqcw5wt''p@Awswwwq 1qw\0\0\0\0\0\0\0\0@\0 P %q0Sqww2@\0\0\0CT0w3sr4@D@Dcssw7swt4ugwwwwwwwwwwu7VWuwwq@t\0u57wwsu\0\0\0\0\0\0\0\0\0\0sAP4\03p\0@# swsss\0@@Awww7wwstCGVWuwwwwuwwwVtwwwwww7C@twwwwwwwwp\0\0\0\0\0\0\0\0\0\0w75At0u!\0\0\0\0@\0Cs77777@DD@@w777w77wagCgvwwwwwwwuegWwwwwww@Rw7wwwww\0\0\0\0P\0\0\0A7uwRqA7!w@@@77sssss@\07cwww7wwRWEwWWWwwwwwwwwqwwwwwwu5@C`@wuwwwwwq\0P%\0\0\0\0\0\0\0AgRqPpwPq0@\0\0@\0sw77777D@t@sT$7ssrwwrVwgwwwwwuwwWVWuwwwwwpq@T w5qwwww\0P\0\0\0\0\0G W5PQA@qpqq1\0@ 73ssssv0\0gw6SGswwW77wuewwwwwwwwwvwwwwwwwwww aw7ssSWww\0\0@@\0\0pww W0 %Sw\06\07BSsss@t@w77@t2wqcgwwwwwwwwwwwwuwuwwwwwwwwSSuwWewwu7www5\0\0\0\0\0\0B\0wPSW1AA6P453\0  p\0''7723gsww4\0GvwwwwwwwwwwwwwwuwuwwwwwwwwwwwsWww5www P\0\0V\0\0\0W4!VQp sRps70BSw5#sWw7w77swsSD wwwwwwwwwwwwwwwwwWwwwwwwwwwt pwwswwpP\0\0@\0\0\0P SuaS4q5177sR@70BPs#swwwsw7w$@erwwwwwwwwwwwuwwwwwwWwwwwwwwwQwwu7ww\0\0\0 0@ w6SPs1qqAwSC73ssC0@\0077w7sswsw$DRwWwwwwwwwwwwwwwwwwwvwwwwwwwwPgWswwwq \0P@\0 qAu\0w1A% pRW7q$sws67r@\0@CCqwwwww7p@@t@ewwwwwwwwwwwwwwuwwwwuwwwwwqwwpW''wwwwwRP\0\0qp wPsS4e%SSCR7s7\0\0\04ss777qt$CG GwwwwwwwwwwwwwwwuwwwwwwwwwwwwqwwwwpC\0\0s\0\04p5`sAPQ 1p1ap\0\0wwwwwv7t@dt7wwwwwwwwwwwwwwwwwwW wwwwwwwwwvWwwwwq\0\0PT\0\0\0@@ qpSC5gWv557q\0\0\0\0@w77ssqae%4d wwwwwwwwwwwwwwwwwwwvWwswwwwwwp@wsWwwwq@ \0\0\0\0\0\0wRqa\0qSqq \0\0pW44\0@\0\03wwwwV7ssdBSwwwwwwwwwwwwwwwwwwWWqtwwuwwwwwu Wwwwwp\0@P\0\0@''VSA5@PqpqCA\0$\0\0swssqsaswwSTGwWwwwwwwwwwwwwwwWvwewCGwswwwwwwv55Swp@\0\0\0\0\0Tse5DC 15 1\0 \07\0@763wwvw77v7wwrWwwwwwwwwwwwwwwuwwVT5wwwwwwwwpu tp\0@p@\0 P@qEwsawu@s@3`0\0pBqscSwvw7sGwwwwwwwwwwwwwwwwwWwwVwwwwwwwwwt0@q!t\0\0P\0 ppWQsA@SA501Bw\0Sw\00v@DvRswwwwwwwwwwwwwwwwwwwwwWwuacWwwWwwwwpCTwqsS@\0PR\0pWqD\0pasS01 4wAC\0\0\04w33\0@@BCwWwwwwwwwwwwwwwwwwwwwwwwwwwWwww7wwwwu 7wp7wWw7wPRS3WPu57pBV5@0S\0wv@D@ 7wwwwwwwwwwwwwwwwwwwuwwwWWuewwwwwwwqwwwwuwswt\0Wpu%Awr@QqAq%\0@BP7PA@\0\076S@DBDww7wwwwwWwwwwwwwwwwwwwwwwwwwswwwwwwwwwW755wpvuww45pQAv4 qA0AA\0\0\0@\0sss @@@V7ww7wwwwwwwwwwwwwwwwwwwwwuewWwwwwwww@%wwWvw7sWAGswwwQ@C$QAq5Q \0 %\01\077 @DBD$7w7wwwwwwwwwwwwwwwwwwwwwwWwwguwwwuwwwwVaA@pvWwwwqACAS0Aqq0\0 QAsq@\0@r@WsvwwwwwwwwwwwwwwwwwwwwwwwwwWWwwwwsWwww\0aaa@D\0 w51t7wwuwACAqaA\0\0G@\0P 72@Dst5''7wwwwwwwwwwwwwwwwwwwwwwwwwGWwwwwwwqGPpa\0PegSSCSW wwpCWp\0q\0@1\0A@\0$ \0r@wswBVWwwwwwwwwwuwwwwwwwwwwwwwWwuwvwwwwwwpCCC w 57u7wqqwwwu54Fs\00P\0\0@\0P05swsuaawwwwwwwwwwwwwwwwwwwwwwwwuwwWwwwwwwuA@@P@Aeqqe7wwwu57wwqq PqpR @\0 \00 sr\0wswswswwwBWwwwwwwwwuswwwwwwwwwwwwwWuwwwwwwpp44%!wSwSSqwwwwwWwwww5SpPAq3 50swswswwwatvwwwwwWwuwuwwwwwwwwwwwwwwwuu7qwwpA@PWAgu53WwwwwwwGewqp%5 4a7\0\0ss2\0wswsww7$Gwwwwww7qwwwwwwwwwwwwwwwwwWwwwwPgwG 0w%wqwpwwwwwwwwww54wSQ@@t\0\0@P\0\042Pswsww7tTeuuwwwwuww7wuwwwwwwwwwwwwwwWwGW WW5psTW575w7wwwqsGwwwSPww1@PP\0\0\0!Cswswswwse$wgewww7wuuwwwwuwwwwwwwwwwwwwWw%pw%gWGwswwSwqsSqSwswuwW5wWwww@W\0a\0 q\0w7swswsVRWtuwwwwusWw55wwwwwwwwwwwwwwwwwWWwWWSwWwwvW5w1uw7wwwwwwww50\0Q\0\073swswsvswwugwwwwuwwwsWwwwwwwwwwwwwwwwwwwwwww7u3aww3Sqwwswu5wwwqswwwqu7W@\0\0w77swswqwswwuwwwwwwWsu7wwwww7wwwwwwwwwwwwwwwuwu1qqwW5swwuwwwwwwWVW W41@P@\0\0rsswswCg''wwwwwwwwwssWwSW5wqwwWwwwwwwwwwwwwwusswq5wwsusA77qsqqwwwwwquA@CP\067677swpSWwwwwwwwwwwWws45wwwuqwwuswwSwwuw7ww5u5qR5wwwSu7pwWuww5wwwww 5 R 507\0sswCd6w7wwwwwwwwusw7qwswwwwwuwwwWswwusWs1sSqw7SwwwswSsS wwwwwwWWqP\01\0r@\0 77p@@D wwwwwwwwwswsCWwwSWqu557wwwSwSwspqwqqqqqu75qwSwWwSRWwwwvqwqWw0s1\0prdtWwwwwwwwwwWw555su1qw7wsSwwu7wSuu70111wswwwQwwu7755%gwwwqwPw7\0WQ7r0\0 4\0@@DRBwwwwwwwwwu7usSww5su5qwwSWsuww57wS1S0qwuqqu''wwwuuwqSpwwwwAD50\0us753p\0\0@Fuwwwwwwwwwwu75wSWqR7W5557swSSWwqu3qq0sP1QwqsSwqGw57SsqwqGWuwws\0Asss6\0\0\0Dt7wwwwwwwwwqwuwSws1qqqqqaquw1 7u7sWqu77wwWw7Sw1uwsquwqw%7wwwAsss6\0\0@Fc@GwgwwwwwwwwwqwwsqSWqwWwq51 wqwS5qqqww7Su1qq7WW7qu7wpPTu5wwwqq777S\0\0@\0u%7wWwwwwwwwwwwu57wsWqw57su57w5us3qwwwswW7wwswWw1w7ww gwwRWRWssp \0\0\0@c@Rwwwwwwwwwwwwquwsqu557SSusp1Ssu1wW71q5SSp1wwu5qw3SW55ww1770G7sww5\0Psr\0P\0\0u%wwwwwwwwwwwwww5uqcWwu57S715777W51wwwww5u5q7wwu7WSSP\0Cw7wwwq@S\07673 \0\0Rw7swwwwwGwwwwwuqww555q7w705wSW5w5571CqwwwqwswSSSwW3u51@\07sA''7w642C3Cs@\0wwwwwwwwWwewwwww5qwsaww7SsuwSSSSq51u71q1qq151swwwwqwSqcwwwSsWSS B7ww7wwsP\0C730\0777swwwwwGgWWvwwwqw7WwsqsW7710Su5150sQ1 wwwu5557wW75q751\0\0Ssssw7w4\0\07C''\0sCwwwwwwwwVvwuwwwwWW7usWwWswWQsQ5151%7A11177wwwsw7Ww7WSwQsS7777sw6@\0\03Rss7wwswwwwwuuvwwwwww5wsSww5qu7531q0155q1wqqS!wwwwwqu5qswwwswSw\0sssss770\0\0@@@#773wwwwwwwwwguwwwwwwW555 Qswqq751QSSSS55!wwwww7wswuwwu7SCq\0s''7777sBP@\0\0ssscsswwwwwwwwuwwwwwwWsWsqsqwSq2SQ15q15SwwwwwW7qwwww7qsqR P 77700\0@\0\0777777wwwrwwwwwwwwwwwwsWsWSQqp5wqww55aq1SWwwww7qwqwwwwwuw51sp\07723@\0\0wssss77ww7GGwwwwwwwwwwww757501wwsswS1qqq10q057wwwuw7wwwwWwsqsSA70\07%$rs7\0! 77770wrD4VWwwwwwwwwwwuuwWWCSqWwwwwqqaqsq0517wwWwwwwWwwwwwqwSQ!sr\00\0''3s@\077\00sw0\07GCG''wwwwwwwwwwwwsu77Wswwwqu71%w5q1q30usW7wwwwwwwwwwwu1W3s72\0@a70CsP7723D4dTu Gwwwwwwwwwwu7WSSqa55awu7sSSQ5%q5qsw7sw7wwwwwww773w77\0\0\0CC 3sc\0\03r\0rCG %gvwwwwwwwwuwwwSswqsSwqSSqqQ70S7q!53  SquwW777wwwwssWWsWw3sp\0\0\0\0@\0 7w77p\0\03dTtVuwwwwwwwwvwwwwWSW5q51w 57A75SSu57Wsswuwwwwwwwuss33w7\0\0@@\0\0 3s3ss7p\0@s %qegwwwwwwwwwutwwu757WsqqSuq7sW51%17Sww77Wswuu7Swwww7uw7w0p\0@\0\0@77sw7sp\0@\0\0\0\0tVwrWwwWwwwwwwwwwwwusSswu5511 543SSW%q5wSquw77swuwWvu3s3p0q\0\0\0\0!#s73s7\0\0\0@@\0qetwwwwwwwwwwwwwWwwwwu5wqsQ3SSW#q3SU051715svsSwwswwSWu7Cw7 \0swps2P\0!777ssw1`\0\0\0\0wrswwwwwwwwwwwwwwwwwSSSwW3Q1u''Q5q3SSwwSSwuwww7w55u0 4\00s470\0r@\02770`\0\0\0\07twwwwwwwwuuwwwwwwwwqwwwsqu5CSRS7SsSSspwqw7wwsqsqqqwssws0\0ss\0sw\0\0ssp%3\0sswwwwwwwwvvwwwwwwwwwswQwWSq51q554555553Wqw ue57WwuwswW5s@7#0p72p\0\074%67 \0\0140wwwwwwwwgWWWwwwwwwwwWWswwq55sS1%571qp4qwqcwwwwSsqu7qs7qsw5\0\0P073s04 4\0Rss\0!r\0\0wwwwwwwvugggWwwwwwwwwwuqqwq55!qqSSq1wq4qgSSu77WW7q7uqv sp\00ssssss0\0\07% ''7 \0wwwwwwwwVwWWgwwwwwwwwSw7qsSS 571%GSqwW7qww7wWwursWw7qw55s@7777770@\0\0\0`R3sr\0wwwwwwwwwVwewwwwwwwwwwwwqqtqu57SSQ51a3ugv7W WsasuucpqsSRSw 77777`\0@\0\0w772ww wwwwwwuewwwwwwwwwwSquwSSwwsS7RqSWsWAussqqswwuwWsSWSRRu5su7v7777773\0\0\0\0\0 s7ssss`wwwwgwwwwwwwwwwwwwwwwwwwwwSuwu515q1q1qwWswSuug ww5%7wqeu5%55qs77p4@\0@\0s7s7770\0 ww44wwwwwwwwwwwwwwwwwWqqu1uq7swW51sWwwsusCG7qavWWwup146!rw7Rssp0\0@\0s3w3w3s@\0wwugGVwwwwwwwwwwwwwwwwwww7u07Suqq7qwwqquwWuGw v7wSCWqWVqu5PsCsp!c7701B3w3G\0\0\0w4$4uwwwwwwwwwwuwwwwwwwwSwqSuswSS57wwwwww5sCqwquww5w5p RCAq%t555\03s \0w\0\0C7s02B\0ugedt6GwwwwwwwwwGwwwwwwwWwWqq%ww557wuwuu%5vuwWaqwsqwww %''W RsSss\0ag7\0770\0\03aq1\0$PG E5wwwwwwuetwwwwwwwwwSswSSqw7wu7ww7wwaqwppwWupspSR5p\0PS!uaqapP007ss`\04\07#r\0edw4dvwwwwwwwwvwugWwwwwwwwu5squ7wwWWuwwwSAWCGuww7swW51RSSA%W S0@CCw77752\0\0@Ss1PG7u4wwwwwwwwWGgTwwwwwwwwwsW77WwwWp%gwwWww5545suwquwWqaeP1454445t41S\0 73ss3s@\0@\0 4 cw4wCGwwvwwwwwwwutwwwwwwwwugwwWwwwww WuwwWRRW5puwawsqwSq0@SRQ\0rQR51R577w77w\0\0\0\0@\0@37uw7wwtwwwwwwww CwwwwwwwwwuewwWwWwwu6uwuwswSRW wwu7Ws@\0S@rSPP5%7Q%!03s3ss1 \0@\0\0@33wwCtww7sqwuwwwwwwwwuwwwwwwwwwewwWwwuwuwww5wStw4 upW7\0\0SA440 qA Pq7w75`\0\0\0\0\07w3w77wwwwwwg Gwwwwwwrwwwwwwwwuwwwwwwwuw5wwWwSWSAu7wQwC@\0\0 4!aaqA\0pq%''77@\0\0\073#stww7wwwwttwwwwwwwwWwwGwwwwwwwwwWwwwwwwuw7qwsWuw7wu\0\0A p\0\0 Qq@7rP 73\0\0\06 777wwwwwwveE47WwwwwwwwewwwwwwwwwwwWwwuwwwwWVqucGWwewS@\0\0GpPapqe\0\001%0g6p\0\0srs\0\00\0\03sw7wwswwu`V6GFww7wwwwwSewwwwwwwwwwwwWwuuwwwsWcu55qsGwt\0\0SeP!APuQs@77702p\0\07 wwswww66VAdswwwww6FGVWwwwwwwwwwwwwwwwwwwWquwww U557Pu6wq\0\0RP\01q%\0\0\07\0w10\0\0\0wwwswwGW4d4Cwwwwww6u5t5gGwwwwwwwuugwwwwwwSw wwWwu''wGt4RRSSQaV AA\0\04P\0\0\0sw2sc1 \0\0swCww7sswPD7V4wwwtuwFVpwwwwwwwVWgwWwRTwwwqw5wWSW7W4WvRQaru\0@\0\0Qqe\0\0\0\077s773\0\0\0wst77pwwp77wasCwwww75uaGwwwwwwwwwWWgWwsGWww7uwv7gwwWw5sPqqu WR@P\0 P\0\0\0cw7ss7 \0\0\0Cww`G77wGsstFww7 7ww%GwwwwwwwwwVwgWwuwpuqtuwSWSWqw%%vWugVqaa51!@\0\0P\00@\073ss7p\0\0\0\0t7wp@agsCswwsqspewwwtw7swSwwwwwwwVWwwwuwrwsCwwtsWquww 5qpVa@Pp\0A\0\0700@7 rw77s\0 \0\0\0wp77ww77wtFV''ssswwwGgwwwwwwwwwwwwwuuuut1Ww5wwPuw5wWSSRW\0S@\03s@\01q\0\0w7 \0\0\0wpt@D$''w77ww4Pwtw7wwsWwuwwwwwwwwwwwwwwwSWwwuwvWw74wSwu%e%Pt4@e\0g77 7#@@''3prs\0\0p\0@@Swwsw7w`pd47wwwswwtrVwwwwwwwwwwwuwSe%sWq uawWSVu%wSupqCpSvP@\00@sss\0\0s@57\0t@`DT 7sswst4tDGw7wsww6uuwwwwwwwww7wwwSAegw evusWWwwRW5q\0@@\0@@7w777sw\0@usrc6\0`7g7ww5cC@BBF77w7wwwEevpgwwwwwwwwtuwwwwwqqAAAGSWusrRwuqeqwRW\0\0 73ssw3@\0\0\0sss`D74Cp\0G77rSw7@DGwww7sarRAGPwwwwwwvtwvvwwwwwwwwwpwwtTuuwsGswG!@\0\03sw7sst\0@@@@pssss\0spsppwBV77qw sppswwGwwug@wwwwwwwwWGWW wwwwwwwwWGWww7w7t770sw1`\07Rw777p@\0\0\0 777774w\0sw47p@awsG 77BV7st7777prwwwwsu%44%wwwwwwwppppsw7w7w5$ t  27\0C`\0\07sa 44\0@@qsssssspwsssssp\06swww5awCwwwwwwwuwwwwwwwGGWwwwwwwwGEeeFWwwwsssp\0\0\0ssp1s70\0sRss0\03ssssw\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0å­þ'),
  (6,'Meat/Poultry','Prepared meats','/\0\0\0\0\r\0\0\0!\0ÿÿÿÿBitmap Image\0Paint.Picture\0\0\0\0\0\0 \0\0\0PBrush\0\0\0\0\0\0\0\0\0 )\0\0BM˜)\0\0\0\0\0\0V\0\0\0(\0\0\0¬\0\0\0x\0\0\0\0\0\0\0\0\0\0\0\0\0ˆ
\0\0ˆ
\0\0\b\0\0\0\b\0\0\0ÿÿÿ\0\0ÿÿ\0ÿ\0ÿ\0\0\0ÿ\0ÿÿ\0\0\0ÿ\0\0ÿ\0\0\0\0\0\0\0s41$wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww%wwwwwwwwwwwwugwP5 wwwqvwwwv477sqrscscS773srs\0\0$ Gw7wsw7wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwvvwwgwwwRGuwwwguv 777#srsqsqsw77w677s4wwwwwwwwwwwwswwwwwwwwwwwwwwwwwwwwwwww7wwwwtwww7wwwwvwwggw`CWwwug3rssssw77777773ss3qss$ wswwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwswu$\0\0\0\0\0\0\0Aewwwwwwwu''u5gwww74ssqsss7777''7''63G73swwwwwwwswww7wwwwwwwwwwwwwwwwwwwwwwww6\0\0\0\0\0\0\0\0\0\0\0\0\0@PwwwwwwwpWwwws77''677csscssssq73sv7wswwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww4\0\0\0\0\0@A`tg@\0\0\0\0@ewwwwwwRAgww7w777773srsw77757ssr77wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwsR\0\0\0Ggw7wWsSwwwe @\0\0Cwwwwwtwww7rSssSg7771sqsr3777sswwwwwwswwwwww7ww7wwwwwwwwwwwwwt7\0\0\0w7SBG4ttwsp\0\0@wwwww\0Cwwww777773sqsw67''7wcss77wwwwwwwww7wswwwwwwwwwwwwwwwwwV7 \0\0\0WvPda@tt\0C@``@t7v\0\0\0Wwwwu$wwsssscsw7763ssss35''5sswwwwwwwwwwwwwwswwwwwwwwwwwwsww\0\0 w0RPp\0\0\0@%%u4\0\0SwwwS@wwww7''771sssw7777W3sscwwwwwwwwswwwwwwwwwwwwwwwwwu44wp\0\0\0wupG\0@\0@\0@\0@\0@@@@e$w\0wwwtpwwsw57rw6773ssss#w7773wwwwwwwwwuwwwwwwwwwwwwwwCrCw%\0\0wrRB@@\0@\0\0\0\0@\0\0\0\0\0\0@\0PA$ w \0wwwt Gwwsss3s7676SsCsws7777wwswswwwwswwwwwwwwwwwwu76 4gP\0\0Gu\0\0\0\0\0\0\0\0@\0\0\0C@wp\0 www\0www7''w7ssSs677737scsCwwwwwwwwwwwwwwwwwwwwqv7%wtwp\0\0wrRW\0@\0\0``ptT$\0@\0\0\0@aaw\0\0Gwwtww7ss73qssw777''w%777swwwww7wwwwwwwwwwwv6%4v4sp\0\0gtP@@\0\0\0WGWWuwWwwWwwp@\0\0\0@ w\0wwwuGwww7Sw''7''3ssss3g76WGwwwwwwwWwwwwwwwwwSSu6g5gv\0\0GqC@\0@$VSSwwwsu''cwwuwt\0\0\0\0@CC p\0Gwwp7wwsw63sssw773qwsVWrswwwwwwwwuwwwwwwsSrp6WcVRRq\0@wVD\0@$W77erW0WwWuuwWwwwv@\0@\0Pw`\0wwwAGwwssw7771rRu6rW''75wwwwwwww7wwwwwssC`qgSdt3cw\0\0 r4\0@\0ewpqawW5Gaw47w77vw7wt\0\0\0@\0CAp@ wwt4www73ssscs76qw7wecGwwwwwwwwwwww%%47vqds2VWt\0w@@\0\0GSR WpsRwpwu%%rSuuwWt\0\0\0\0BW0wwwwwwww75%swGw7pw777wwwwwwwwww5!7V7gt7s5eww\0\0wt \0@usg!qevSw sSsW5wWwwww`\0\0@ t\0 wwpwwssqcsswCsqg rsCGwwwwwwwww7qcvV%pu''Cq%gwgv\0w`D\0VSCWSpqg7 S 45%wCrw7wuw@\0\0\0BP7` www\0www77Gwswewsww77wwwwwwwwPs   uvw''rWwtwvp\0 pV@\0\0Wpq%47asCW%4w w551e77ww\0\0\0@w\0WwwwWwwww7Wssru7w#ws7wwww7s''4rwv1!qwGwVvww\0\0wa\04wVV@sSG5cCWRqpsC w@\0\0\0C@7\0 www wwwwwg656Ssg7Ww7www744vwG7AacvvVwfwGw`\0 u$\0@\0SG14sw%4qr7rq %45tqagu\0\0\0Gp\0wwwuwwww7www7ssw3sw7wwrpsww4t674wwwggWgwep\0w\0S@\0\0GwCRCW PSSCcqrWq7pSRp7`\0\0\0 \0w\0WwwwewwwwwWw77w77w77S7AwGFqcCGggVugWgWt7\0\0wV@@@\0453V77w0W qw 5'' Gwwwwuw\0\0\0P`@ wwww''wWWGwwssw7w7sswrpw`rsc wwwWugvvvtr7v\0 p \0\0w t1ppupq@s ''sSe61qqCWwwwuwwwt\0\0pwww7WWwww7Www7qcv5v7Awg 40pvevwggwggu7 7F\0WU`\0\0w  RpwS Sw447wW1qwwWww\0\0\0\0@Gq\0wwwwwwwwsu7wsw7wwsWw`qagwwwgGtvvwW647 7p\0sA`\0\0EvCSwpu%77a7w1cww5w6Cagwp\0\0w\0wwwwwww7\0ww5g7sswwg agwvwegwvwweg4qcGtw\0w\0\0\07qc441pSqRSVSV5swpSs 7ww\0\0\0\0@ p wwwwwsPq@P ww7wwtrsqwugGVVwggrp75''6u'' c\0Cpu`@\0TsWCRR t40677!wS%!uw %471rSCauw@\0\04 pwwwws%\0\0wwuav5wagvvwwgwvV5CvtwRts\0 @@\0\0cqu1!sWsQqqWw3SWsq55!RW477sp\0\0@A p wwwupRCGp\0www7swwwwuwGggwrW1cw4ew %2340@\0\0 uw''e45!v52  7gsu446W a%7%!sCrRWt\0\0\0B@q\0wwu!  \0Wu\0 wwwwwwwvvvwwe'' 0g@ve652S3p\0wG\0\0 RSQsCRQrU05%54ssSWw1t0qqpSqS7wP\0\0w\0WwwV%u%wp\0wwwwwwwwGwsCRprG5g7%2a!c760\0sB\0\0uersuqa4rW2WWw''1q%wCSRps6`\0\0`S\0''wwqaCwrT7twwwwwwvwt4saCusFsBS 73a3s\0t%@\0\0@SqRW04%5w0%7quwawv5%%5$6SAqswP\0\0g\0Wwwwt5GwRWwwwwwwwwws3s%''tbVq41''3rsS773@qD4\0 AtV5!wSRG5sqqcwsq7wqqaCSSC`Q'' 5wp\0\0\0B0 wwwq`5wt0wp wwwwwwt4adwV7W!&ssc73''3ps0r@\0\0\0tsusRPqq4s ''VWuw%6446U7%qps t\0\0@T P wwwwWCGwG wPwwwwww3sWsds@!cq71s5sSs37\0uG\0\0Ce%7vWCqucWswwW7SSqq2PR   su\0\0\0\0  wwwwwwpWw\0WwwwwwadbVS43773s''2s#63sss\0Gp`P\0\0@`GSu!qwgWR1wwSqgwcpSCesSqss5p\0\0t'' wwwwwtvWu\0wp wwwwwWsW3%#ss''3s53ssR71s@ p$\0\0 t0t7 Upw75w wwww!a57 5u%%%%%wp\0\0Cp wwwwww5waGtwwwwwbV pss6''3a73s5371r3\0u%\0@\0\0pWqqGgprpSSCCusWuwSuqv 5''p753Rt\0\0\0@ 0 wwwwwwtVwtw\0wwwwwW3ss7573s72s63csr770 rC@\0\0GgV7qqw6Ruw7 5wwwwsw1t5w PppRP5w\0\0\0@$ P wwwwwww%wwpwwww p33a2s63cs72S75#3qs\0pT\0\05qw CAce5qWsV7wwwSVS!sq''75''wp@\0\0\0PS  wwwwwwwTgw`t wwwwss63w1s3q73s35727\0p $@\0\0GvWAsWsUsGw#W7SWwWsv77cV47SSCSpwp\0\0\0''Gwwwwwwwwwu w\0wwww333ss3r73ss63s ''2qw3pw\0\0@4qsrS%7W45%A%sww7wwqwSW5sRqappww@\0\0\0PW\0 wwwwwwwwaGw@wpGwww6s67C73c''3ss''3s73#0\0q`d\0\0G6WpSau''uws7Su0qwwqwswssCw7Swqu\0\0\0\03\0wwwwwwwwww wpWt7www3s3q33c1s63s71sssrp7P\0\0\0Guwau0Uwe5t2RWwwwwsvW%u7pqaguww\0\0\0@@4\0wwwwwwwwwwAww w wwws663w77#s3q7''5s''3c32\0G@`@\0\0r5s wp52SrsW77wwwSsScu7www04\0\0\0\0q\0wwwwwwwwwwt wpwuwww3q3r3ass''073s273a72ss\0p @\0W \0wCS4u5uwwvwwwwwwWwwwwwwCS\0\0\0pwwwwwwwwwwwPwt7wwww63s737sss''771s73s5\0 p`T\0\0wqe''upsSwcsesSSWwwwwwwuswu0t\0\0\0  \0 wwwwwwwwwwwpWwGwww73r3c3Sc6''3S1c63s61r''\05\0\0@\0Wqp usPw %7wwuwwspstwWC \0\0\0\0Pq\0Gwwwwwwwwwwww ww7RSgss7673ssqc7''3s7416Sp\0W$@\0\0 u wp%7wwwwwVwwwwwuwVww5%\0\0\0@@\0q\0wwwwwwwwwwwwwwwwcwwW3c7s3q37373sq73GCc''W\0 pS@\07Sw!0RPqqwu67wwwwwwwww5 @\0\0\0$p\0wwwwwwwwwwwwwsCsWwwws7r6567''sss#a%G25uqc\04@\0\0GppqpA!057wsSuwwwwWwwwwwwRQp\0\0\0P \0 wwwwwwwwwwww7 wWwgrs73s3s3s770rVR6V667@\0w\0p\0\0\0wWRSRRwSwwwwwwwwwwww%6@\0\0@@\0q\0gwwwwwwwwwwwSGwwgw57Vr6s563w73 5 0vwwvww5w7\0Ct`@\0\0Gqa qp 57guwwwwWwuwwwwwsSq\0\0@\0@Cp\0wwwwwwwwwwSsgwww7%www3s7#3s44&w555swuwws@7\0P@\0\0w0wwuu7Wau7GWwuqEsWwwwwwwt\0\0\0@\0\0 wwwwwwwwwswWwwqauwwvws53ss47%aCsqcSCrsuswwwwp\0W$\0\0Wuw6t!sCV7wwu4sWwwwwww\0\0 q\0wwwwwwwqcSe6wu47wgwvww7#43CpC #BV5''757susw7ww\0 pA`\0\0 wuwwuwSWGw7W7u5wuwwWwS@\0\0\07\0 wwwwwwwwwwwww''wwwwwwww3s3aar 6qG75w7Ssswrwwwwwp\0W$ @@@\0wwwWwwwssw7Gwu5WWwwwwWt@\0PBq\0 wwwwwwwwwwwG7Wwwgwgwvw43@rRW4qc\0 sqsw757ssWwwww@SA`P\0 wwwwWwwtsGSwu5Suwwuwwsa\0@wwwwwqewwwwwwwwwwwwwwwS73a7%''!cswg63Csaw7swwwwp@w \0wwwwwuwwu7wWWRuwWwu7qwu\0Aa@ q\0GwsRVRSWwwwwvwvwww567G@rrRV0ss7Rw377sqw7wwwww\0 wAB@\0wwwwwwuqwwwwwU5wu6WWWSG%s v\0P07Wwwwwwww%vwww7%5%#aw4wwSss77wwwwwwt\0rAB@wwwwwwwwutu7wwU5wwt%`Sp\0 \0\0\0\0@AA%7wwww7wwwwwrR 3qw7#sw7w500tqepu77wwwwB@WQd4\0\0Wwwwwwwp\0RWWwagWw  @w\0P\0\0\0\0\0\0\0RRuwwwwwwW%435%sss3s77sq0cw7777rTwWwwwu\0 we@E%%t4RT\0@4WwwwWQwwPG@Ww\0\0\0\0\0\0\0wwwwwv7ssw 37 7rsw77RP4771swwwpwWwwwt\0 w@R@\0\0\0\0\0\0\0\0 PsWWwqwwTpp7\0\0\0\0\0\0\0\0\0\0\00q! Wwwwu77ssssssc57CS1%75CAC1puWWewwwwt\0CwPP@@C@\0\0\0\05eswwt%pRTwP\0\0\0\0\0\0\0\0\0\0!ASP1wwssw2777 7773arwpCsGwug@qwwwwwwpwpAae$\0@\0CWWWwWV@ w0\0\0\0\0\0\0\0\0P!% www7usssssqrV%!''S\0GtG vWwt5\0Wuuwwwww@ w4Ae! $qwwu4\0E7w\0F\0\0\0\0\0\0\0\0\0\0\0\0\0!0q7sww77''770cacsWu0WwpdpGu5twpa5wwwwwwww@\0ww\0@DDT%uwR@usu \0Dq@\0\0\0\0\0\0\0\0Aaq Wwssssssqg7 ce0 \0CtG vFRWDCwwwwwwwwt\0\0ww5\0\0\0\0\0\0uwwt\0\0Gw@\0\0\0\0 \0\0\0\0Sq1wwsss0c7Ccp47Cp@tw@`VW5eeq`dpuwwwwwwwww@\0wwwvqcPtwwww%\0\0Gww@\0\0\0PAACP7psw7w77gw 6wp4\0wV\0wDv@@CSwwwwwwwwwwD\0\0\0Aau7WwSRPp\0\0 wwwp\0\05% 5! Ppqsw7rs7!%%www P\0aw\0VwWuwetduwwwwwwwwwwww@@\0\0\0\0\0\0\0\0\0\0@Gwwwww\0 pq0APp5qGwsw7w wwwwww$pwPv\0WaGGVvWwgwwwwwwwwwwwwwwvVD$egGwwwwwwt%0 SPqquswsss!%wwwwww5\0B\0B d@evtpuwvWwqwwwwwwwwwwwwwwwwwwWwsWwwwwwww4\0\0\0\0\0\0\0QS1q0q5%T7wsw77wwwwwwwt6WpB ECGGegvVWwwwwwwwwwwwwwwwwwG0CTwwwwwwwwA\0\0\0\0\0\0\0\0\0\0aq Su!wswscswwwwwwwsP@\0A` pp%$$`VVWeegwwwwwwwwwwwwwwue5\047wwwww\0\0\0\0\0\0\0\0\0\0\0\0P\01qpsPswsssswwwwwwwtp\0  t\0\0AGgwuwwuwwwwwwwwwwwwwwwwpRq 4SuuwwwwwqA\0\0\0\0\0\0\0\0\0 445557wswsswwwwwwwww5@@@@w\0GBVuwwwW4uwwwwwwwwwwwwwwww ''wuwwwwR\0\0\0\0\0\0\0\0QCSW0sw7sr7wwwwwwwwp\0`@\0vwuvuwW4qwwwwwwwwwwwwSt4ppBsAsGwwwwwwS\0\0\0\0\0\0\0 A40540w7Cs5wwwwwwwwwR@\0@d\0A@RGuwWuwu5U5uwwwwwwwwwww SWe1u tsswWwwww@\0\0 @P0ASA w7Vwwwwwwwwwwwq$`@D$$4SvSWV7CRWwwwwuwwwww\0sAp@qutWwwwwwwP\00\0\0@\0AA0a  swwwwwwwwwwwwwwwR@\0@RP$\0CAeupu4uwWuwwwwwwtwwww\0q@0pP pssw WWwwwwppP\00R wqwuw7w77wwwwwwwww0\0@\0P%$5qauqu7W7Cuwwwwwwuwwp%BPw\0eGqwwwwwwwwP\0Caa!ACwwwwvw''wswwwwwwwwwwwqt$g@D PCW RuuuuwwwWWWwwwwwP5\0\0\0sG!wWwwwwwwwwqa\0\0PR7wwWwswwswwwV7wwwwwwwwwwGwww\04UpRwwwWwwwww7wwww@0\0\0@qGpspWsWwwwwwwwwwpqa%%%%wwwwwuwwsww77wwwwwwwwwwwq%wwwW@$ SqaawuAuwwwwwwwupwwww@4\0  @rqG6Wquwwwwwwwwwwwswwwwwqv7sw7usWwwwwwwwwwwwwv56SPtu PBQqgW5ewwCuuwwwwwwwSWwu`\075wqewgswwwwwwwssw7wwwwrSgwwwwuswwwpwwwwwwwvsqqvwp44r\0paPq0uEw7wwW7wwwwwwwwsww@\0 rSgSAw5uwwwwwwswwwwww7swww7ww7swwspwwwwwwwRStwvwgwsPup4@%4wSsW5wvWwwwWwwwwuwwA\0\0qG4qwt5wvw7wwwwwwwwwwwwwww7u76wwgsGwwwwwwg6wewvw7 GwqGCu7300w Wuuwswwwwwwsw4t\0as\07qapw7vqwWwwwwwwwwwwwswswW7wwwg5wwwwwwwwuwWww%4ugwwvwqsw3q 5q1q5wwwuwwwwwwuwR\0\04 u w sWqwwswWwwwwwwwwwwwswswwwqsWwwwwwsSg6vw''cawgvwvwesBW6S s`e7Wwwwwwwwwww`R\0qaRWwqe4wwuuwwwwwwwwww7swWqwwwswwwwwwww7wuwwwsuvWwwwwgwWsS3wssSuwwwww5wwwwpr 7asRSGvw swwwwwwwwwwww7wwwrWwwwww7W7wwvwt7Gwwgwggwww`w75cw# gu0147wwwwwwwwwwwpAqatvwqw uwWwwwwwswsw7wwrSwwwwwwwSwwVwwwwwwwgwgwwgqvrSc57qASWwwwuwwwwuw@sPwg5wpw7wwWswWwwwswwwWwgswwwwwww''swwtwt7wgwvwwwsqqgaw7SawGe!01q3qCwwwuwwwwwwwtB#e0wqCvrWqw7uwwwwwwwwwwsSwwwwwwrsqgvqg3vwwwwvwwvwWgww477v535w 5757wwwwwwwwsw7pA`WS7puqwu%wuw wwwwwwwwwswwwwwwsw7WwwuwstwwgwwwwpwwgwggWu''w2Q6ws!0CSwwwwwwwwwwww571%wps ww 7wwwwwwwwww7wwwwwwsv7wwgvsrWwwwwwt7wwwwwSqs''SqwsSsQqWt!%1 wqwswwwwSwwsVqGw0 wWwqwWwu7wwwwwwwwwwwww75wGwqqvWwgwwwwwwgww 7677Wsscqc07pSgwVuuwwww7w7wwsgw7sGWsCwwuwwwwwwwwwww7rWgwww77wwwwwgwtwwwww3sCsrs75%1''57SCq51wS1%wwwgwwwwwwwwwwwqawqspwWw wwwwwwwwwwwwwCwwwwgsewvwwvW7wwwww57Cs777''w3SSCw15SSwRwwwwwwwqwwwwwwqvpwwAgu%r7WwwwwwwwwwwW57wwwwqsGwgwwt77www7%rsswssssWw07qqqprp1s51%wwwwwwqwwwwwwwwqw7qww5w7uwwwwwwwwwsrwwwWcRwwwwwwsspvwwwsGw77773csssw34w 51w5uSwwwwwwwwwwwwwwwprwwqwwwwwwwwwwwW7wwwrwwwwwws%74wwrw7wsssw7cwsrss45#q0wsGsSp47141GwwwwwWwwwwwwwwwwW  wqgwsvwwwwwww77uwwtw7wwwvwcwsewwsWsGswww77777776ssVC Gsu0wwwwpWwwwwwwwwwwwwsu%7wwwwwwwW7wuvwwsuwvwwwsW7Www4v7wswsssVsSssqss773q7sSw05305 waWwwwwwwwwwwww77wSwwgrWwwwwwu7wtwvwsRwvwwwsCw7gw7wcqwsww7ww77757757sS5sRScW!cS4pwwwwwwvwwwwwwwwwwwwwqasuwwwwww7wwwwsw7wwwvww7wRwswv5wwws7Ssssscrscrs3cs%755''1s45rSgwwwwwu7wwwwwwwvsWwwwvwwWwwwwwu7wvwwvw5gwwww57qruwWrSwwwww7sw7777777777cs1W73C!srqsWwwwu7wswwwwt7swswwsqwwwwwwucwwwwwsqwwwwww7sagwww6wwwww7Sw7srssssssss77''5!R73cw51wwwwscwwwww7wswwWwwgRwwwwwwwsswwwwu7 wvwwgqpwwwur47wwwwwSswss%7575757sSsscw%u51q asw7svuwwswwesWwswwgswwwwwwwrwwwwgw7wwwwwwsv7www7r5wwwwwww7w7w7ssrscrs''6767773s3awqswwwcVwssswwSswgwwgwqwwwwwwsswwwwu7wgwgwwRwqvww7RwwwwwwrScss7sw777777ssssssss777 Cwww7%!w7w7wwVqswwwwwG47wwwwwwru''wtwCvwwwwwwcu4wsw CwwwwwwqcW7Ww7w77ssssss77777 04rVRswCCaasws77w7777wwww777wwwwwww7 7wgvsswwwwwwq''''w6Wsswwwwwwq77sw77sswsssssssssssssww7sw77w77777w7wsswwwwwwwwwwwwwwwww7wwwwww7wwwwww77wwwww77wwwwww77wwwwww7\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¢­þ'),
  (7,'Produce','Dried fruit and bean curd','/\0\0\0\0\r\0\0\0!\0ÿÿÿÿBitmap Image\0Paint.Picture\0\0\0\0\0\0 \0\0\0PBrush\0\0\0\0\0\0\0\0\0 )\0\0BM˜)\0\0\0\0\0\0V\0\0\0(\0\0\0¬\0\0\0x\0\0\0\0\0\0\0\0\0\0\0\0\0ˆ
\0\0ˆ
\0\0\b\0\0\0\b\0\0\0ÿÿÿ\0\0ÿÿ\0ÿ\0ÿ\0\0\0ÿ\0ÿÿ\0\0\0ÿ\0\0ÿ\0\0\0\0\0\0\03''3s3ss73s!wvVw4w!&WwwvVwvwwwtpwwwwwwwwwwuwwuGWwwwwwwwww7wwwwwwwwwww7wwwwwwww!6w\0 w\0\073s72373s7!sa7wvwsawrWwwgwwvwwwwwwwwwwwWwwwpwFuwwwwwwwwwwwwwwwwwwwwwwwswwwwwwwRA%vp`3''s71sssr73ss07cG wgVrs 7gwwgwgwwwwwwwwwwwwwWwtGWVwwwwwwwwwwwswwwwwwwwwwwwwwwwwwwwRcv733s73733s773ssswVWwWGw''Vwwgwgwwwwwwwwwwuwwp`pueGwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwpCws7s72ss73s#773su#cw''gwavw7CGwwwggwwwwwwwWwwwtwew%wwwwwwwwwwww7wwwwwwwwwwwwwwwwwwwww03s72s77#ss73ssc755''WRwwu6swwGwwwwwwwwwwWwwwtwtWFWwwwwwwwwwwwwwwswwswwwwwwwwwww7wwwwps7sw3s773''3sw7373ss1#7VVvutsswvwwwwwwwwwwuwtTgFu\0tuewwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww723373s3ss73237sw777sCswwvwtwssWwwwwwwWuwwu`eBWuwPGVVWwwwwwwwwwwwwwwwwwwwwwwwwswwwwwwwwwswsss''3w3737sss733rs7747 wwwaewswwwwwwwwww`GVwpdeuegwwwwwwwwwwwwwww7wwwwwwwwww7wwwwww337373s3ssv37773sv77ssssw vwwwwwwwwwwwwwwpRS@@GGR@CGV''gwwwwwwwwwwwwwww7wwwwwwwwwwwswwwss3rs73r733ss7#s''3ss7777swqwwwwwwwwWwWuwtdRVVdWVtvq7Ggwwwwwwwwwwwwwwwwwwwww7wwwwwww73773q73r7773s77773ssssw7swwwwwwwwwwWwwq@BP5a@D@gtGTu''v5wwwwwwwwwwwwwwwwwwwwwwwswwwsw3rs3s7#s73s7''7sss7777773sw7swwwwwwwwwwwd$\0@@@D\0GwwFV5&rRGwwwwwwwwwwwwwwwwwswwwwwwwww777773s71s73s3s77776777w77swwwwwwwwWwwtP@BA\0\0\0\0t@wwpGWGGRW57wwwwwwwwwwwwwwwwwwwwwwwwwws33s3s73s63s7s7s73sssss3w77swwwwwwWwwp@g\0\0@\0\0 @wutttwebG!gewwwwwwwwwwwwwwwwww7www7ww777673s63ssss3s3sg7777swsww7w7wwuwwwwtuvEe\0\0\0D\0WvV7etRwwRVswwwwwwwwwwwwwwwwww7wwwww3s3ss''7373737''7''73sssw7sw77wwwwwwwww@RGGu4pPW\0wutGu\0vTCGw%$gs\0gwwwwwwwwwwwwww7wwwwwww76w7733ssw3sssssssssw3sw7wsw7wwwwwwpD$gWGDew`@wwF DgtGed4$wqpwsWwwwwwwwwwwwwwwwwwwwww3s33sss733r73ss777773w7ssswwwwWuwwtpBPEv@G@ wtD\0Ep@VTw vw@FsVwwwwwwwwwwwwwwwwwswww77w772s677773sssss77sw7wwsswwwwwt\0G@@@RFu\0E@@@up@d\0EBegGcscBVwsDsvwwwwwwwwwwwwwwwwww3333sss73s3s773s776sw77ssswwwwwww@TdBD44@WvD@@Vq@tEGu%cGGrV%c wwwwwwwwwwwwwwwww7w%!777sw777''7''7''73w3ssw7wswuuwwp\0@a`@@V@Dt@ww@\0\0D@@DFTVRugse&sG5cF$0f7wwwwwwwwwwwwwww33sw!#S733ss33ssssw3w77sw77swwwt\0B@GA4\0GPwVt @\0\0 peeGwgSq$vVtqe''Vwwwwwwwwwwwwwww%!tpw73s7w37ww777737sw77swwwWwt\0D4\0Gp\0Gwteu \0\0@tuwDeeewvRS!&vSe$c gwwwwwwwwwwwwswsw4pr703ws33ssssww77wswswwws@\0dwQ\0\0t\0\0Fwt@t\0\0\0\0 @GwqGBVvwwvVcGtvwrspWwwwwwwwwwwwtp5swuasS#Wwssssw3swssw7wswwt4\0@A`\0d\0\0WwpAWp\0\0\0wwvueegwwwf0rGw4 605wwwwwwwwwwswwCgRswg''33sssw7w777wsw7wwt\0\0G\05@\0D@\0w`tevw\0\0\0\0\0@wwwuPFTtvvvtwvS%rwVVWC  ''wwwwwwwww5rwt7Wwwv7u67sssswwwswwwww\0t@P@\0\0\0Wt@VPt@\0\0D$wvWe$GVRWgGgdgwCGecv4v2SwwwwwwwwwC547wrRw57ecqswwwwsssww7wwp\0\0 G\0\0@ v$ V\0w\0@\0@\0WuuuW\0eedwewwvwwwsrt Gqd6sGwwwwwwrww7Rwwtvwswww77sswwww7wwww\0@GC@\0\0wTte\0@V@@\0GwdwBPueVVwvwvtvwww''q`gwCFc0wwwww54sww7%7wqwwwwww7wsww7wwwwwp\0\0\0@\0@\0Wpg\0\0V\0\0Ew`S`Gt@EdtvwdvVwgggvw\0Cwqcc4gwww7wsswwwwwwwwwwwwwww7wwwwwwq\0\0@\0@P@\0GwtDA\0\0@D\0\0\0vqEvTVS@GpGGCVwwgdvwGGwa\06vFGg6RCrgwsw37w7ww7wwwwwwwwwRTFDdwwwwww\0@w\0wC@\0t\0\0@BPtwuDu\0\0D\0wDt7''gwwewvvwwsSqdqg7 $1wwswwwswww7wwwwvu`@@\0\0\0\0\0evwwwv\0\0\0\0tTt\0\0\0@wwwst\0w\0\0wgG4u7Vwvwwegwvtpq&gGGesC37s7ssswww7wwu%\0\0\0\0\0\0@\0@www\0\0\0Wt `@D\0\0 \0\0 wwAD@GP\0\0\0 wtwG''ag4wggVudgggrQ!44qrtvswwww7wwswwwwe\0\0@P %eerW\0@Swp\0\0Dqee`E\0@\0\0\0Wwu@q\0\0\0DwupGvwVsV6VwgggwtvwvsCs&gGsVs7vwwwwwwwu\0\0  uwwwWvwwu%\0w\0\0\0GtG \0\0\0p\0@dww@GP\0 ww\0wVwgcW GwvvwwGGwtvcFeww7sswwwwwu\0\0WwuwGWweuegWwwA`p\0\0p@@A@@P\0\0D\0 Dw\0D\0\0\0wwD\077vVut624''qegfvvegggaa756vwwwwwwwq@\0 wvVVWww5wvTuduwwA@G\0\0\0@B@t@\0\0\0wDged\0A\0\0\0 u@\0\0swwwvweecS vtwwgVwwgwvSC7swwwwwww\0 wGGwWwupVSWd WgWwp@\0\0G4\0P\0@G@@WP@q\0\0u\0\0wwwww  VVSa`vCgGwfwWGgwvw3wwwwwwwwt\0\0twtWpwS57WDeEgwWe\0\0\0\0P@w@@@t@gP@@@ut@\0wwwwwwv7''egwat6qgwggvWggFGwwwwwwww\0\0wwDwdRWu%40PqtPWWwwtP\0\0@@@@@\0\0De@e`V@\0\0wt\0\0\0gfVwgwwugSwC`vrSe''gvwgVwwvwwwwwwwp\0uCGDSEwWQA\0Vegeeeww\0\0\0\0@\0\0G@GP\0@P\0G@ut\0\0\0TtPdegwgCwWG gRG''74gwwgwwgwwwwwwq\0EwVt@Eewu1Wsp@WWWWWWwwu\0\0\0D\0\0 Wtq\0\0R@7wWC@\0 GfFFGdtF@B@ww@csFT6sCBCqGgvVfVwwwwwwt\07vFVWwWqwSQR7wwwwwVWwt\0\0\0Dts@D\0\0\0DGae\0\0DttugVVGefTdFwpCs''ettw42sqgewgwwwwww\0wduwuw5wUq55Wwwwwwwuww\0\0\0wt Da\0\0\0\0 D\0wT\0\0VvvVgFdgdtVdtB@dw`50rvgegGacCrwwwwwwwt\0ttugWtuwww40AwwwwwwwwgWt\0\0GP`P\0\0\0p@GP@@\0GtttedwGVVfgGFtddurs RV56%6Gwwwwwww GGuwwwwSQqQwwu5wW7uuww\0\0\0t`@\0\0\0GTpu\0\0gGggwwvwgguttgFTd\0d53%#rVevVpr00wwwww\0 wuwqwqwwwu  wwwwwwwwwWt\0\0\0w \0\0`G@@\0gwwwwvvwwwwgggttfVF@Gf73p0qrVagGgwwwwt\0wtwWwau5wwquSUwuququwwwwww\0\0\0EpDa@P@@W@\0\0wwvwgvwwvwgwwwvvvVedtas3s !vTg%6wwwwpwWwwu57www51!P''wW77 SQwueuwt\0\0 D\0\0`@w@@\0\0wwwwwwwwwwwwgvvwwwvVed`Dd''773r1''4Wewwww\0GuwqqwwuwwwQW1\0WwwuASSGuwwwwp\0\0p\0@wT\0\0wwwvwwwwwuwwwwwwwgggvVed`ps3733RRrVwwwu\0 vuww5qusWwq01q uw15eqqwuwWw\0\0\0\0@@Ww@\0\0 wwwwwvvvFfVttwgwwwwwgefVF@F773qss3!%''wwww\0wuwu5pwsWqwvC !wwuSCwV5sGuwT\0\0p@ wT\0\0 wwwwwed@TAG @t`egwgwvVee`D`sp367773wuwp\0wWwSwWsVu0QqSQu5w5wwWtuwwp\0\0@Ww@\0\0 wwwwv@Au7wsQEBFwvwetd\0E#7733#373wwwPwwwwPuwsuqsq!C wwqP7w wuwuwpGp\0\0DT\0\0 wwwwd\0Ag7wwq5us5PDgwvdVTcs373SsS7wpwp wWW5quuwwqaqSppqqW5wSGWGqgww\0w\0\0\0\0\0\0wwwwd\055w7w113S7WwwFd\0G3rSc3#63wPwP wwwuprSWwwqW!u\0\0ww5wwA5u5twWuwPWp\0\0\0\0wwwwtAqqsuwwqS%s51w@Gvuadd 3373s3swpw\0 wWwSqQusWwws0uwwww7w0wwuwWw` w\0\0\0Wwww`@wssw75Q1Sw''vtgDc77373s3wPw\0WwwqpW7V5wwwqAqpwP\0uwwqWWWVwwwPWwp\0 wwwd5wQq57wu07q!sQ11151w0gv@g@Css1c5#7w\0w\0 uwWq1qaqWwuwW SpwwwusWwwwwWWwp ww4wwwwA%7sSW7s11SS15w\0wwD`D32w7373w\0w\0GwWwWPWwqSSuquu5 \0WwuwW%wwWwwWwwwGwwwDSsqq13Sw!105q1177spvpeCs33s3sw\0w\0 twusSW5wwQ!QCw7P5wwwwwWtuwwwuwu wwwwwt q%usCQ711SS1P755\0gvD$ 777''73w\0w\0Gwwwu5wWwu1Q5uwu5u 7wwwwwsSRuwWwwpGwvwwvAq753qS11C71501qpwp\0vv@C3r3327w\0w\0 quuwwwwws\04wwwsWwwwwwWPASwwuwwwuwwu7Sw71%1q43QqSS1SswP tds773w\0w wwwwwwwwu7wWWQwvWCWwww54twwwwuwwwwD5sqp1111q!0111015w77\0gt@3s33sw\0w@ wWwuswwwq1\0 WwwwwwqqSGwwAAquwwWvwwwt75Sss11!7SQqs0s1uwGgcs7673wwwwwuu7wP\0PwwwwwtP4wu5 GwwwwqWwwwA55sq!SsQCSsSSwqvD3c3s''w@wp\0wWWSwwww1wwwwww\0sRP7Wuwt wwsAqs7S51sA57sq551!57wwbCs773wwt\0wwu SWwqq\0u1q7wuwWwu4Wu4 WwwwuGwwT11Sq1Wqq17wq1q7sw10Swpt7333swpws\0 uwqwww1PWwwu7wS@7SAwwuwtwwCSSq71173sW71q7Cq1q15%7w\0vC3ssc3wtwu\0 wwW%ww57wwswqSp\0u5%wuwwwwp1ss7s1051sSq1s70WwPv 7273swsww\0w7wwwqp5Wwwutq4AspSWvWwdwwT5!505337715SWw1AswwpR3sss7wuwwp\0 wWWVwwqS\0P5sWvqq7\0euqewwwwQwwaq153S1111sqq!11S55517wwQ5wwwwRe#3373wwwwp\0ucw7WWwS\01SuwQSssWswuwu ww5515111qq71157 wwwq7s5577\0p5 3swwwww\0\0SsQqwqGq\05q75AAwuusuuwRWwpSs1!5wSq110755111SQ1uwgB323wwwwwp\0\0EwwCSwPS5wwwuwvwwtwT7Qqwq3q1s11w1q1Cq7BG12wwwwwu\0\0@\0Stq\0 @G5%5q\0wawWwWuwwQwwpsq31170S111sss1q 7u7Cw4 awwwwww\0\0\0 SPAw55a1wQ\0wWWwWvWwu wwq5311ssq qw51101wQQ57wsCCVwwwwwwp\0\0wSeqpwtwwu5uwuwq wwUwwdww CS55701Sq3w557S05qq15RwWw\044sacwwwwWww\0\0\0WwWwQuwQwwwwwwpWu5vwwuQwwtS1q513S7751s7w111Spwsq57wPccwwwsrwwt\0\0BVU7wwpwvWwwwwwwW5wUwup wwu%q1S1RQ51175ssSq053ww51qusWwwt5c`wwwwwSgs\0\0W\0AeuwwwwqwwwwWtwwptwwVwwwpS1q1q311p11SS15115w5''5SS737wwp''sR4wswWwwqwP\0\0u\0GSwwWP@wwWWwWuSWWwqaSwwwCqSS0Q577Qs17ssQSWWwqw7sSsww3wwwww7\0\0\0wFWSPwp$ wsqu5stqwwtPwwwwtw11151q0110sq3S0W1wqwps337wWw477wwwq@\0w0\0BWSu\0TFWuwpTwwp@wwwwPwS57q1q1!53wwC7wrs3w3sqgwvww0\0\0u5C5$5CGtt wwtwwwwwpq1114141Q!17SW0Pss77w4w777wuww@\0\0 wu5\0FDDdDPQuwwP@CWwwwww q53S1ss30555351q5731%3QWq''2ss33s3rssrSsgwsP\0\0www51QAaSSwwww\0wswwwwp!1515111s1ss51q5u!Q77q1t\0q47sw7w77777 5sWsp\0\0\0@Www7wwwwwwt@@\0WwwwwwwwV51511uqsq1wwSwsqS5SWww3rW3r3sssss3r5''7wp\0\0\0\0@VWWWGD@@\0\0swwwwwwwwpW1S3SSPsS11wW3w11qaswwQ110swp cF2w77sssssw7s7%7w\0\0\0\0\0\0\0\0\0\0\0\0\0Vwwwwwwwwwwps1QWw1SWsq1ws1wwu115wpw5a6%3ss777773s7ssscqw5!\0\0\0\0\0\0twwwww7SwwwwwpG61q75551uwS7571!ww1wPag7CV7s7773sss73ssssrwwwwppq477wwwwwwwwwsw%www sAww3w7WwSq10sqq5w`rRRv7s7sssw72sss777773 wwww7gwvwwwwwwwwwwwswu wSWsQq71C515wwq151wS50w5%''RR773sss77677w77777s wwwwwvSsswwwwwwwwwwwswwq111773Sq3ws11w5577wQqGww5!ass77''3ss3sc373sss7spwugwwwwwSuwwwwgwwwwww0wsS01q1111Q51wSWw75517www wwww73ssssw77s77w''sssws7747sGswgWwswwvwwwwwwwwqGW511!sSS1111S1sqww73wwtwwwwww777773rs73s3s77737sssp4stwwvwwsGwwwvwwwwwt3sS11115s11q1SwsS0wwPwwwwwwssss77sssw3w7s777s3w77s3C0swwwww77wwwwvwvwq1q53s310q 1q57wq1!wu''wwwwww773sss73s#73s7sss7w3ss77775#Rwwwwwwwwgwwwwp7S11!q111w171Swuw371wvWwwwwwwsss737sw7sssw3s7737ssw3ssssw747wwwswwwwwwwu551qqw73q71 51qq1S1wwwpwwwwwww3s63ws33s7773w63sv3773ss73s3sssCVwwwu7wwvwv 1Qsqqq3S7w1q11u1ww wwwwwwws717#3ww3sscw3sw737ssw''3s77w777ssWuwww47wvww1505SS5311w7Ww51R1W7wwqwwwwwwww63cc73w7773w73sss''73s67sc3sss777''6wwwsswwt sqsSs1151SSq1wQ%wqqsS7wwwtwwwwwwww17wacss73ssw3ss77777s7s3s7sssw77ssSsgwwwqvw`u5 5511 517w7WsSq51wwww wwwwwwwwccswwu%''1g773s77c3sss7s7s7s7773ss3ssqqwwgvqs SSSsS11SSS 1wwwewwwwwwwwwwtv7swug3777ss3g73sw3s3s3w77''srwssssaauwwwt\0q511!q550sw1S50sS5wwwwwwwwwwwwsw7CGwssVq3ss7773s773w7''3w3sss77377''77767wvwp sSSSS77S1q\01qwwtwwwwwwwwwwtvwwsrRwwsvu47sss7rsw3sss7''77777w7''777ssu''5cw@w511q11s10w7qSA5q1ww wwwwwwwwww7sssw7w7sRs2r7773773w7763sssssS3ss773773sC4w0 w555S51w1S1WwTwwwwwwwwwwwwwpssswssGwwue7Cssssw3w777777773w3ssswssw3ss0u\0Gw11113Swqs7wwwTW6wwwwwwwwwsssvwWww7sGrw7G7t45773w3ssssscss73W7773773w3773s\0ww5557W77w51q wwsCv4swwwwwwwwwps47277sssu''w7g7w''#S3w77777776ss7773w3ss3wssssp\0gs50q0wsSQ7swwWCcCCawwwwwwwsvwwwGSswwwsqaawwswwW''73s773ssss763scs#s77s377777SS1ue5qw1WwSwp\0cvwWww%''swwww47qew7''aqcsww7746tw7rRR3ssw7777ssss3ssscs#scs''3''7\05q17w1!7wu55wwwUu56ggw''4444wwwww7 Gqw''77777wsq7 Gwwwpr753ssss777773w3s3w7373sss70\0 WwuwWuu5wwwwwwvtGgwapsugVtwvs&qewwspwwwtwCGsswwsssCw7wuars7777ssssss3s7s3ssss737777\0wwwwwuwwwwwww Gwvwvwe''qgcGwGprw7wwww44t7777%673wswptscw%%!css777777773773s73sss73s7@DuwwwwwwsVVvwvvvwvwwcCCTw`vWewwwwwwwsswwwwwsswwsww7swwwwww73ssssssssssss73s7373s73s731aCEettueeaacwwvwwwgwvwwvwcrWwvwww\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0’­þ'),
  (8,'Seafood','Seaweed and fish','/\0\0\0\0\r\0\0\0!\0ÿÿÿÿBitmap Image\0Paint.Picture\0\0\0\0\0\0 \0\0\0PBrush\0\0\0\0\0\0\0\0\0 )\0\0BM˜)\0\0\0\0\0\0V\0\0\0(\0\0\0¬\0\0\0x\0\0\0\0\0\0\0\0\0\0\0\0\0ˆ
\0\0ˆ
\0\0\b\0\0\0\b\0\0\0ÿÿÿ\0\0ÿÿ\0ÿ\0ÿ\0\0\0ÿ\0ÿÿ\0\0\0ÿ\0\0ÿ\0\0\0\0\0\0\0!1!!\00 Q\0\0\0\0\0\0 \04''Pa1aq 3RRCAa!@0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0!!C%%\0 p0p\0\0\0\0\0\0\0 1!S4046CSQC5#BR`\0 \0 \0\0\0\0\0\0\0\0\0\0\0!1AP0p04R\00s\0\0\0\0\0\0!\0\01 0q@prSSSqsAu%467acCR5%%$p\0\0\0!\0\0\0\0\0\0\0\0\0\0\0\0\00\0!! CC\01!!q\0\0\0\0\0\0 \0p!1aa0''544746sw75%%vqq6\0\0\0!\0\0p\0\0\0\0\0\0\0\0\0 \0\0!BP0%Cv\0\0\0\0\0\00SCu\0qssSWsSGSSwwqt !eQp \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0!Q\0q\0!! #040q\0\0\0\0\0\0\0\0a$%!4417Cwu777ww swu7Sw7wwu2sS''@\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0!001Rq!7P\0\0\0\0\0  CQ3SCqwp7SswSSwsGww7w7SucG4qdR \0\0\0\0\0\0\0\0\0\0\0\0\0QC A a%0\0\0Cw \0\0\0\0  T06577G7ww7ww4wwwwwwwV5wwwqw%!A\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0!00001!!41w\0\0\0\0\0\0\0SQsCSwwpwwwwwwwuwwwwu\0@\0\0\0CqgRRA\0\0\0\0\0\0\0\0\0\0\0\0\0\0CS\0%\000\04w\0\0\0\0\0!@p6su7w7wwwwwwwgg%%\0BADt p@F\0A\0@550p! \0@\0\00\0\0\0\0\0\0\0!\0\0001Q CRABP57w\0\0\0\00 u5swwtwwwwwwRpTdFFvf@DdddFF CGP\0\0\0\0\0\0\0\0\0\0\0\00\0!!A000\07Wp\0\0\0\0esusswwwwwwww@@dDfVv\0@d\0\0\0\0\0GgFBD\0!%40\0\0\0\0\0\0\0\0\0\0\0\0\00\01R$cP1CS7p\0\0\00!a45swwwwwwwttdt`@`@ @\0F \0\0\0@$gP@@P\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0!\0 1ap0@!Cwp\0\0!  Gsw7wwwww''\0ggd\0\0\0pGd\0\0DFDd\0\0\0Fdd\0 \0 \0\0\0\0\0\0\0\0\0\0R1!1A1S!Ssw\0\0\0 41!pw7wwwwwv\0DFd@@@ \0\0\0u\0\0\0\0\0\0\0\0d\0V\0\0gD\0B\0\0\0\0\0\0\0\0\0\0\0 \0\0\0RP`0a a\0!q57w\0\0 \0!qswwwwww@@Ggg@\0\0 d\0d%gR\0\0\0\0\0\0\0@\0d@\0\0Fvt\0\0\0\0\0\0\0\0\0\0 1!1!!A1 Q%7p\0\0$! 754wwwwwdgd@\0 \0\0G@@ www\0\0\0\0\0\0\0\0\0 tv\0gF@\0Ft\0\0\0\0\0\0\0\0\0\0\0\0\0\0R\0\0!\0p!1swp\0 \0qsSwwwRDvwv\0pF@@s1ww1\0\0\0\0\0\0wwp@@\0\0\0FdA!\0\0\0\0\0\0\0!1!pR1!5 70\0@0474wwDFvF \0d\0d!1Sq310\0\0\0\0wp\0\0\0g@\0\0g@\0\0\0\0\0\0\0\0\0\0\0A\0\0$0\0!0!C3qq\0\0aqswWudwg@\0G@p\0 Aq33q11S1\0\0\0\0\0\0\0\0\0\0PFt`\0\0@\0\0\0\0\0\0\0\0$0R 3\0q5567\01C45777gGfvP\0Bv\0\0eq37313s3ss\0\0\0\0\0\0\0\0\0d\0FT\0\0\0 \0\0\0\0\0$0aC51%0SsQq\0\03SSSwtvd\0@g`t\0@GwR1533w773733\0\0\0\0\0\0\0\0\0f \0\0\0\0\0\0 \0 \00Q\01a!!S453Ssp\0pa7577wvFw\0 DF`\0\0wv371ssswqs110\0\0\0\0\0v@\0`\0\0\0\0\0@\00!!aBSPq0S57\0\071sswwvwwd\0Ft\0\0G''wp!1sRq\03w31w03q0\0\0\0w@\0\0\0\0\0\0 \0 0QP\053 A75''\0 TsW7wwwwFF@\0\0d`\0www01 111\07w71rs010 \0\0\0Ft\0@\0\0\0\0\0\0\0\0\0!01%!A61qsSs77wwwvv@\0\0 P\0\0\0Wwwv13ss71\0wsw1rq71011\0\0\0F\0\0\0 \0\0\0B\0\010@q!% ssap\07Swwwwwgg\0td`\0 sssw01773w0qp\0\03ws7!s010\0\0\0g@\0\0\0\0 \0\0000 %40 7\0u7''wwwwwvt\0 @wsw 7sPws71\0\00\0\0ws3s10011\0\0t\0\0\0\0\00\0 \0\01!ApCCSssc3wwwwwf@\0dp1331sw 1ww7p\0\0\0s\0\0\0 w773\0113103\0\0v@\0\0\0\0\0\0\0 \0!R\0''0pr 7wwS7wwwwgP\0\0\0S11sqsss77wsw3\0\0\0CsS\03757!\0@wd\0\0\0\00\0\05!rQ1wwwwpsq7wwwtw``\03 73770\01ww7ww\0 \0\0\0\031\0\01177s\0w@f@\0\0\0\0\0 \00\0\0! a#77Wwwqwwwwv\0e\0 s33773sw13wwwws\0\0\0\0\013su\0\0\00F\0G@\0\0\0\0\0\0 \05015!pq%0wssswwwvfD das7307s3p\03psww0p\0\01170\077s\0\0\0\01\0\0\0`\0\0\0\0\0   !! 50q Swwwwwww@\0d\07s!373qs0\00Q77ws3!\0wpC\0\0wsqqp\0\00vR\0\0\0\0\00!Rq1%0uwssqwwv\0\0\0\0ss7775!37p\0\010\04ww0s ww\0\0\0w7771\0F v@\0\0\0\0\0 \0!!000 2!CR pGwwwwwwvgv\0 353s35133qs0\0\0w71w1\0\0''w7wwp!\0pv\0\0\0 !\0\00p \0ww7wwwGv\0ta73s73351q33p\0\0\00\07s7S03sp\07w7w7gG@\0\0\0\0 \0\0000!0C10qp7\0p qw7wwf\0\01ss73ssq003RSs\0\0\0131w11Sww\001\0\0ws7\0\0d \0\0\0\0 A!\0\0\0!0Pw\0p \0w\0swwwv@t@C3s71s313!33\0\0\001ws37www77s\0\0\0 d\0\0\0P\0\0!\0!%A0q%7qwpwswwt\0\0\01u3S7753q000550\0\0\011w1577ww \01w0\0v@\0\0\0\0 00\0 \0!417p psp swwvg\0t''S3s7s33q75#3S\0\01135773swwssq1\0 \0g`t`\0\0\0\0\0\0\0% !p0s0 p \0wwwww@\0@D!Sw3773#\0\0\03ws17w777sw3\0@p\0gA\0\0\0 !! \0\040p Sw\0s \0w\0w77wv@\0\0\0S33sss710131!11 !5#3w7wssw7s1!\0\0dVDf\0 \0\0A @\0@\015!srppswwwF\0G@1qw73q37a7\0!103537s33ss3ssr743\0\0fBvA\0 ` \00p41 qc puwwvt\0$d d773sSs3qq135!110q07ws1#ww73sp3\0\0@e`0\0\0\0 P\0\0  !!qssp%`P \077wwg\0@`Ss3151330s1!001q1!#S0773w11120qw55 3\0\0\0v@\00\0\0\0!!!!411\0CpSp7\0qswwtgdp\0 \0S7777371qs3S!37s33\01\0\0@\0\0\0 P\0\0\0\0@  a3Sss0 \0pswwwvtF@Fe3SsS11q7312q%!1210517771!sq\0\0\0\0\0\0\0\0\00\0V\0D0!\0\0\0$41!555\0p 7777wv@\0g\0\0B133ss3Ss11100s#013w0\0\0\0\0\0\0\0\0\0B\0dfv50B  !sA!ss\0q\0CSwwwe`\0V@ Dssqq17133S#313q73ww\05\0\0\0\0\0\0\0\0t@\0vCGwwwww5\0`0\0P!3q!p 0 1sswwvp\0`\0d %133sq773s3s1!1011!q31113w\0\0\0\0\0\0\0V\0@g\0gwwss777w50\0 \0A4!!s B p \0p57wwGd\0\0R\0fSSSS73s373SS1!3S7311157p\00\0\0\0\0Fd`\0\0$wss3sss73ae%\0`\0q31s\00!Cqswwwg\0\0e\0@3377753s731703!s3\0ww3\0\0d\0 tDGw73s3333372a\0C\0 !!!A''p@1057swv@\0\0\0\0W573qssss71qs1711311113w7wwwr\0F\0\0F`vssss77773s31  $Bpqq3Q!P\0\0qasswwt\0\0\0FFcS15373s53s31s3s1110s173wwwws11\0\0F@\0Ggwss7333373s0 0 !! C4S \0p#57wwG`P\0\0\0wSs3s73s7771!sSS111\0vqwwwsB$\0 \0\0gwwsss7777333\0 \0ppq01q414101sSw7vgd\0a!''753ss1q733s33Sqwwwsw\011\0\0\0aFwww73733333'' fv !  P6C \00SR7wuv\0\0p\0AS3s3sS71sssS5113wwwpww 1111\0vwwwssw3sss3gvGGGgdaa@0103Qp0pq41sSw7vd\0G``\0q#s7711s771111375ww7pwp\0\00\0wwww7737333vvvVGgGA` 7c3PR577ww@\0@\0\00153ss3sss7357111ww3ww@\0\01110\01\0\0gwwwwsssssrvvwgvvvvV$4\000341ap1aqsSw5wv`@\0pS 1353757777715313wwwwp\0\0\0\0111`dwwwwwww7337w Fwgwww`47q\0R11a07SCwswug\0\0\0\0a3qs333s13s3S\0s17w\0\0\0\0\0\00wwwwwwwwwwwwWVRRtwvwtP@\00q 5CPRqsSsWGwd`\0v@\0 ss377577s73SS\077 1\0@\0\0\0\0\0\010ggwwwwwwwwwu% \0 wvG 0\0q5\0C#SS57sssV\0\0dw173S33S3S5311!#110\0G\0\0\0\0`\0@DwwwwwwwwwwrR@@@apppawvA\0qq%7!a%4$ssqswstwwwD\0\0 `573ss1ss3s311\07W t`\0@\0gtgwwwwwwwwwwDB@\0   R G@0\0\05\0P0BR1q7qaqu7wwwwwwwtv@\0 q5733337!\0@`F\0\0\0fgwwwwwwwwwue%`@@ACPquppt\00q3Qa550q%777wwwwwwwwwFp\0\0qq53qqsSs33\0\0@\0e\0g\0g@BFwwwwwwwwwwwvVFe''BDpt7   \0P0CSCsSW4cwwwwwwwwwwwt`\0Cs1557333Q37\0gPde`''wFgwwwwwwwwwwvEdeGFD RTRRWu\0\03Q#5P571sWwwwwwwwwwwwwt@D\0 1111qqq3 \0dD`p\0\0GfwwwwwwwwwwwwGvVVF$\0%''55%7t\0\00ps7wwwwwwwwwwwwwwwwgg`\0\05753S111`\0\0 `G\0\0\0@tDgwwwwwwwwwwwwwwwwwtd@`@aaPgapWsAa #5r 777wwwwvvwwgggfwvwtFV\0\0q53q13 PF@\0\0\0\0\0\0wfvwwwwwwwwwwwwwwwwwwwttRV7G%w\0A01qaqwwwwwwdwwvvwwGGvgvwtdwvS511q1wP dg\0\0\0\0ffGwwwwwwwwwwwwwwwwwwwwwtSE rSWwprSssswwwwgwwwwwvvvvwwgvwwtdg@sp`\0\0`\0\0 wvGwwwwwswwwwwwwwwwwfgegwwww@e%rt5w w1qsR7wwwwwwwvteDTeDeDvwggwwFFGgu!v@\0v \0ggDfFwwwwww7773sswwwwww EdFGFvwww RWGwP\057777wwGwwtdvvggFgFe''fvwgwwtvGFTggBGg@Dtdvwwwwwwwwsssw77wwwww EdDtveGGwtaepRSggwpsRspwwwwwwwwGgwwWwggtvVDG\0GvwgwwtwgftdeDtdvGewwwwwwww77sss77wwwwtfFggedddww V %ww \0555g77wwwwGgwwvdvVVFVDvtt\0 gvwwwGwwwwvvrWEgw7wwwwwwwwss777sswwww\0FTeggfVFDFwV5pW4rwwPasp73SwwwwwvwwtvTvVGe`edFFGdD$vwwwwwwwwqwWg''wwswwwwwwwsw7ss  wwwt\0vdvvvvdtdGubStsUww\055qt7swwwvwwwGd&D$$DBG@edFvVGvwwwwwwqgpwSe7w7wwwwww77rt4wwwww@eggggdtdBFVgC7wu%!7373Swwwwwwtdf@DFT''e$ B@GGe\0wgwwwwpu pw7SVwwwwwwwwwt7wwwwp\0vVvwgggFDd@@w55gww 2qtstwwwwwwvFp@G t@g@dp\0FVVdvt vwwwwVws`wwSv5wwwwwwwwvA wwww@ggwfvtdeFDdd uwCWwt !737swwwwvtd@\0Dg\0Ft\0eg`dt$ gdwwwww\0wWwwvBWwwwwwwwe!A wwwwFgvgwggvfddD`sCWwwp 00RstsqwwwwwG`\0dB\0DGFFtFBGEwPdwt''gwww Wvwtu%w77wwwwwvwwwtugwgvvgfgD\0\0\0\0uwwwtAC77wwwwwtd@F\0\0$fpgGddttfdefTwdwwwvRwWusswawVwswwwsPwwwvwgggfwgP\0\0\0\0\0\0wwwr\0RCsqsqwwwwF@t`dD@@d@`FttpGu''wwp w7spWw''swwwwwuRwwvGegwwwwvvd\0\0\0\0\0\0wwwA\0\0@7w77wwvV@ d `\0\0\0\0d$gFW$GwGwwu$wtus pwpw7wwa\0 wwqevwwwBF\0\0\0\0\0\0\0\0\0wua\0\0\0! sqw5wwwtdD\0`Dt$\0d`@GDG $Gtegdwwp  wswq qgvwwwww4!% 0!7wVwgwT\0@\0\0\0\0\0\0aC\0 \0\073wwwwd\0BF@FfT$\0\0edvFvVE''BVGwwwttwwwcwwQw77wsAWv vw` `R$pt!`B\0\0\0\0 \0\0w5u7wwwG@@ptfE`\0\0FVdvGgvVt pwGwswwww7swgCww74RBwwVwp@AE$WFpp\0@\0\0\0\03w7qwwv`tt\0DBDdFv\0\0ededw` \0dgwwtwwwwwwwe7wwa!PQp7pww@g$rBVBVAGG\0\0p%\0a 0\0Au7swwwuFFF\0`dG@F@\0\0GFpBv4vRWVwwpwwww3s7w3t1ss7S@40! 0 WTw`vCAe  t$4v\0\0\00p\0p\007q77w7v`G \0a@@dddp`r\0\0\0gFAGadvgwwwwwwwwwwwwW751u \0Ascpg`V%P`vGBWBW\0G\0\0%!\0 swSuwwuGDDFD\0@Dd@d\0\0\0\07wwvttw twwwwwwwwwswsrQswsu\0WVV4G$5`t$vp 17777wwvF\0@\0`t\0\0vtVv\0\03wwwwwGtwwwwww7ws7wwww6w7!B\0!!w\0G`t C4 RPFCV t\0B\0p\0C\0a`Su7w7w@gDd\0gF@`F\0B\0\0Gwwwe@gGvwwwwwwwww7!7sSswSt@  \0\0pCe CGcCD$Bpt4aeds @077qwwwwF\0DDdFt@@wGa\0 gwwvvwvwWwwwwwwwwuGwsu''7w\0\0\0P0!CRRRp4444CC Ead4pet\0P\0  4775swwDp`FPe@BFB@ddq\0gwwwGVtvwwwwwwwwws13W5sWwsp\0\0\0 4`tpVGBC@`t4e&SFVw00!qw6W7svFV$dFDd@`$RF0w wwgeewwwwwwwwwww7w1sw7qwu`\0\0!PVRa`t4444a`VRG CGw\0\0\0\0q@7577wwted@g`gB@dt \0dwp@Wwwwtvwwwwwwwwwww7wwesu7w7\0\0\0\0\0!$aae  C@eaFWpGu%gu$! aP16sGw77w@v@F@@`$@Rgwe3 wwwvwGvwwwwwwwwwswww5sw6w\0\005dadpRpRV0cB@wr \0a747wwwD`D\0`\0DD$dVgww1wwww@vWwwwwwwwwww3wwvRqaeu%aaAavBSFtRudt%%epwwu!!!\0r#sGsWsSwsqd\0$edDdd`FFDVwwswwwtggwwwwwwwwwwwwwsu7p3S7swwwwwVGCBRPa@Rc@GwC@0A0P45%57swwGt@VFD@@`dvwwswwgtwwwwwwwwwwwsww7P%%swat5`tDe%GRP\0`RVa@ ww00@p0CsWRRww7wwvFFd@\0fF\0\0FFPGww4wvwGGwwwwwwwwwwwwwws rRRG RqwBWBp\0V g$ 6wwpa4@P045%3Gqqssut@\0DT\0@@\0Df`wwwwtgvwwwwwwwwwwwwqwww0pP1!Cw57w t$B\0TprPRSVT\0www5!a !RRW qswwW6wdV` @vd\0\0EFwwvvtwwwwwwwwwwwwswwwq%57W p1@@@B\0@@$$$\0WGwa Aq60R3G0pw5777W7Wf\0ddDBF@v@etGwweGwswwwwwwwwwwwwww2PR1pcSaw!s4\0\0!\0\0wegwA2Q#\0Ap!W  G5sW''W7D@d\0 \0tDVdwwww''wwqsGwwwwwwwwwwsp4 prSRqepa\0\0@@a%pgFWeaa` 1!pR0p0a51s3V7swwG`G@\0\0FDdGFwwwEsqww5wwwwwwwwwwp%#PSq6q!%!\0\0\0BFtwRRR%000RP! aecCG5sAC57u4ud`@@\0BFtgwwcww5swwwwwwwwwww!pP6  %''SF  \0\0\0d G$ P%\0\0!!a R0a51a%''7Sqsw6VDtd FDucWsvqssS wwwwwwwwwqpRQ@q5!sS$!Q0$ Bpp0 !1a!#\0aR0Sae4psC qaq66ewsGeAeg657qe74qsqtwwwwwwwq0445RR0P2 PB44  0C\01ppSSSsp754577w 7Ru4swsCRpwwwwwwwv%5CT51arW0a0q%!1\0CA04p4$%cA#p1q$CrSsCSwsqg53pG5q50q4!u7wwtwsRRSS0p0%!\0!p\0q\0 0C!p040\0\0q$%5V%5%5''C cW sR4657\0G0sw7wPqAp50pCC5%0a  A\0!A!!0@\004 q!a!A04$ % a07BSsCS 5%!aq''qp%7SqSaas w40F23C  sRRS@00\0BR a \0!00 Pq \0q@6\0pRPSaCAqa%%1asCpCRR5`rS aq\0qqsw3R 50p0$441q!%c\0\0!!0r\0P!%4Ca0C $%2! \032@qqa0qqpa5554351q07 ''0p1`00!\0q5qCSSC\004q\0a\0Q\0AA0140\0P%!\0@6CCP%%%% C Cp C GRR  P$1pSG4C$''BCRCC Bq 0 00RQBS ApR4 $!!\001q0q57\0q50q517SSA5!01! !!0qsPq51p1!\00!\0\0!010\0!!\00CC\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0”­þ');

COMMIT;

#
# Data for the `Customers` table  (LIMIT 0,500)
#

INSERT INTO `Customers` (`CustomerID`, `CompanyName`, `ContactName`, `ContactTitle`, `Address`, `City`, `Region`, `PostalCode`, `Country`, `Phone`, `Fax`) VALUES 
  ('ALFKI','Alfreds Futterkiste','Maria Anders','Sales Representative','Obere Str. 57','Berlin',NULL,'12209','Germany','030-0074321','030-0076545'),
  ('ANATR','Ana Trujillo Emparedados y helados','Ana Trujillo','Owner','Avda. de la Constitución 2222','México D.F.',NULL,'05021','Mexico','(5) 555-4729','(5) 555-3745'),
  ('ANTON','Antonio Moreno Taquería','Antonio Moreno','Owner','Mataderos  2312','México D.F.',NULL,'05023','Mexico','(5) 555-3932',NULL),
  ('AROUT','Around the Horn','Thomas Hardy','Sales Representative','120 Hanover Sq.','London',NULL,'WA1 1DP','UK','(171) 555-7788','(171) 555-6750'),
  ('BERGS','Berglunds snabbköp','Christina Berglund','Order Administrator','Berguvsvägen  8','Luleå',NULL,'S-958 22','Sweden','0921-12 34 65','0921-12 34 67'),
  ('BLAUS','Blauer See Delikatessen','Hanna Moos','Sales Representative','Forsterstr. 57','Mannheim',NULL,'68306','Germany','0621-08460','0621-08924'),
  ('BLONP','Blondesddsl père et fils','Frédérique Citeaux','Marketing Manager','24, place Kléber','Strasbourg',NULL,'67000','France','88.60.15.31','88.60.15.32'),
  ('BOLID','Bólido Comidas preparadas','Martín Sommer','Owner','C/ Araquil, 67','Madrid',NULL,'28023','Spain','(91) 555 22 82','(91) 555 91 99'),
  ('BONAP','Bon app''','Laurence Lebihan','Owner','12, rue des Bouchers','Marseille',NULL,'13008','France','91.24.45.40','91.24.45.41'),
  ('BOTTM','Bottom-Dollar Markets','Elizabeth Lincoln','Accounting Manager','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada','(604) 555-4729','(604) 555-3745'),
  ('BSBEV','B''s Beverages','Victoria Ashworth','Sales Representative','Fauntleroy Circus','London',NULL,'EC2 5NT','UK','(171) 555-1212',NULL),
  ('CACTU','Cactus Comidas para llevar','Patricio Simpson','Sales Agent','Cerrito 333','Buenos Aires',NULL,'1010','Argentina','(1) 135-5555','(1) 135-4892'),
  ('CENTC','Centro comercial Moctezuma','Francisco Chang','Marketing Manager','Sierras de Granada 9993','México D.F.',NULL,'05022','Mexico','(5) 555-3392','(5) 555-7293'),
  ('CHOPS','Chop-suey Chinese','Yang Wang','Owner','Hauptstr. 29','Bern',NULL,'3012','Switzerland','0452-076545',NULL),
  ('COMMI','Comércio Mineiro','Pedro Afonso','Sales Associate','Av. dos Lusíadas, 23','Sao Paulo','SP','05432-043','Brazil','(11) 555-7647',NULL),
  ('CONSH','Consolidated Holdings','Elizabeth Brown','Sales Representative','Berkeley Gardens 12  Brewery','London',NULL,'WX1 6LT','UK','(171) 555-2282','(171) 555-9199'),
  ('DRACD','Drachenblut Delikatessen','Sven Ottlieb','Order Administrator','Walserweg 21','Aachen',NULL,'52066','Germany','0241-039123','0241-059428'),
  ('DUMON','Du monde entier','Janine Labrune','Owner','67, rue des Cinquante Otages','Nantes',NULL,'44000','France','40.67.88.88','40.67.89.89'),
  ('EASTC','Eastern Connection','Ann Devon','Sales Agent','35 King George','London',NULL,'WX3 6FW','UK','(171) 555-0297','(171) 555-3373'),
  ('ERNSH','Ernst Handel','Roland Mendel','Sales Manager','Kirchgasse 6','Graz',NULL,'8010','Austria','7675-3425','7675-3426'),
  ('FAMIA','Familia Arquibaldo','Aria Cruz','Marketing Assistant','Rua Orós, 92','Sao Paulo','SP','05442-030','Brazil','(11) 555-9857',NULL),
  ('FISSA','FISSA Fabrica Inter. Salchichas S.A.','Diego Roel','Accounting Manager','C/ Moralzarzal, 86','Madrid',NULL,'28034','Spain','(91) 555 94 44','(91) 555 55 93'),
  ('FOLIG','Folies gourmandes','Martine Rancé','Assistant Sales Agent','184, chaussée de Tournai','Lille',NULL,'59000','France','20.16.10.16','20.16.10.17'),
  ('FOLKO','Folk och fä HB','Maria Larsson','Owner','Åkergatan 24','Bräcke',NULL,'S-844 67','Sweden','0695-34 67 21',NULL),
  ('FRANK','Frankenversand','Peter Franken','Marketing Manager','Berliner Platz 43','München',NULL,'80805','Germany','089-0877310','089-0877451'),
  ('FRANR','France restauration','Carine Schmitt','Marketing Manager','54, rue Royale','Nantes',NULL,'44000','France','40.32.21.21','40.32.21.20'),
  ('FRANS','Franchi S.p.A.','Paolo Accorti','Sales Representative','Via Monte Bianco 34','Torino',NULL,'10100','Italy','011-4988260','011-4988261'),
  ('FURIB','Furia Bacalhau e Frutos do Mar','Lino Rodriguez','Sales Manager','Jardim das rosas n. 32','Lisboa',NULL,'1675','Portugal','(1) 354-2534','(1) 354-2535'),
  ('GALED','Galería del gastrónomo','Eduardo Saavedra','Marketing Manager','Rambla de Cataluña, 23','Barcelona',NULL,'08022','Spain','(93) 203 4560','(93) 203 4561'),
  ('GODOS','Godos Cocina Típica','José Pedro Freyre','Sales Manager','C/ Romero, 33','Sevilla',NULL,'41101','Spain','(95) 555 82 82',NULL),
  ('GOURL','Gourmet Lanchonetes','André Fonseca','Sales Associate','Av. Brasil, 442','Campinas','SP','04876-786','Brazil','(11) 555-9482',NULL),
  ('GREAL','Great Lakes Food Market','Howard Snyder','Marketing Manager','2732 Baker Blvd.','Eugene','OR','97403','USA','(503) 555-7555',NULL),
  ('GROSR','GROSELLA-Restaurante','Manuel Pereira','Owner','5ª Ave. Los Palos Grandes','Caracas','DF','1081','Venezuela','(2) 283-2951','(2) 283-3397'),
  ('HANAR','Hanari Carnes','Mario Pontes','Accounting Manager','Rua do Paço, 67','Rio de Janeiro','RJ','05454-876','Brazil','(21) 555-0091','(21) 555-8765'),
  ('HILAA','HILARION-Abastos','Carlos Hernández','Sales Representative','Carrera 22 con Ave. Carlos Soublette #8-35','San Cristóbal','Táchira','5022','Venezuela','(5) 555-1340','(5) 555-1948'),
  ('HUNGC','Hungry Coyote Import Store','Yoshi Latimer','Sales Representative','City Center Plaza 516 Main St.','Elgin','OR','97827','USA','(503) 555-6874','(503) 555-2376'),
  ('HUNGO','Hungry Owl All-Night Grocers','Patricia McKenna','Sales Associate','8 Johnstown Road','Cork','Co. Cork',NULL,'Ireland','2967 542','2967 3333'),
  ('ISLAT','Island Trading','Helen Bennett','Marketing Manager','Garden House Crowther Way','Cowes','Isle of Wight','PO31 7PJ','UK','(198) 555-8888',NULL),
  ('KOENE','Königlich Essen','Philip Cramer','Sales Associate','Maubelstr. 90','Brandenburg',NULL,'14776','Germany','0555-09876',NULL),
  ('LACOR','La corne d''abondance','Daniel Tonini','Sales Representative','67, avenue de l''Europe','Versailles',NULL,'78000','France','30.59.84.10','30.59.85.11'),
  ('LAMAI','La maison d''Asie','Annette Roulet','Sales Manager','1 rue Alsace-Lorraine','Toulouse',NULL,'31000','France','61.77.61.10','61.77.61.11'),
  ('LAUGB','Laughing Bacchus Wine Cellars','Yoshi Tannamuri','Marketing Assistant','1900 Oak St.','Vancouver','BC','V3F 2K1','Canada','(604) 555-3392','(604) 555-7293'),
  ('LAZYK','Lazy K Kountry Store','John Steel','Marketing Manager','12 Orchestra Terrace','Walla Walla','WA','99362','USA','(509) 555-7969','(509) 555-6221'),
  ('LEHMS','Lehmanns Marktstand','Renate Messner','Sales Representative','Magazinweg 7','Frankfurt a.M.',NULL,'60528','Germany','069-0245984','069-0245874'),
  ('LETSS','Let''s Stop N Shop','Jaime Yorres','Owner','87 Polk St. Suite 5','San Francisco','CA','94117','USA','(415) 555-5938',NULL),
  ('LILAS','LILA-Supermercado','Carlos González','Accounting Manager','Carrera 52 con Ave. Bolívar #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela','(9) 331-6954','(9) 331-7256'),
  ('LINOD','LINO-Delicateses','Felipe Izquierdo','Owner','Ave. 5 de Mayo Porlamar','I. de Margarita','Nueva Esparta','4980','Venezuela','(8) 34-56-12','(8) 34-93-93'),
  ('LONEP','Lonesome Pine Restaurant','Fran Wilson','Sales Manager','89 Chiaroscuro Rd.','Portland','OR','97219','USA','(503) 555-9573','(503) 555-9646'),
  ('MAGAA','Magazzini Alimentari Riuniti','Giovanni Rovelli','Marketing Manager','Via Ludovico il Moro 22','Bergamo',NULL,'24100','Italy','035-640230','035-640231'),
  ('MAISD','Maison Dewey','Catherine Dewey','Sales Agent','Rue Joseph-Bens 532','Bruxelles',NULL,'B-1180','Belgium','(02) 201 24 67','(02) 201 24 68'),
  ('MEREP','Mère Paillarde','Jean Fresnière','Marketing Assistant','43 rue St. Laurent','Montréal','Québec','H1J 1C3','Canada','(514) 555-8054','(514) 555-8055'),
  ('MORGK','Morgenstern Gesundkost','Alexander Feuer','Marketing Assistant','Heerstr. 22','Leipzig',NULL,'04179','Germany','0342-023176',NULL),
  ('NORTS','North/South','Simon Crowther','Sales Associate','South House 300 Queensbridge','London',NULL,'SW7 1RZ','UK','(171) 555-7733','(171) 555-2530'),
  ('OCEAN','Océano Atlántico Ltda.','Yvonne Moncada','Sales Agent','Ing. Gustavo Moncada 8585 Piso 20-A','Buenos Aires',NULL,'1010','Argentina','(1) 135-5333','(1) 135-5535'),
  ('OLDWO','Old World Delicatessen','Rene Phillips','Sales Representative','2743 Bering St.','Anchorage','AK','99508','USA','(907) 555-7584','(907) 555-2880'),
  ('OTTIK','Ottilies Käseladen','Henriette Pfalzheim','Owner','Mehrheimerstr. 369','Köln',NULL,'50739','Germany','0221-0644327','0221-0765721'),
  ('PARIS','Paris spécialités','Marie Bertrand','Owner','265, boulevard Charonne','Paris',NULL,'75012','France','(1) 42.34.22.66','(1) 42.34.22.77'),
  ('PERIC','Pericles Comidas clásicas','Guillermo Fernández','Sales Representative','Calle Dr. Jorge Cash 321','México D.F.',NULL,'05033','Mexico','(5) 552-3745','(5) 545-3745'),
  ('PICCO','Piccolo und mehr','Georg Pipps','Sales Manager','Geislweg 14','Salzburg',NULL,'5020','Austria','6562-9722','6562-9723'),
  ('PRINI','Princesa Isabel Vinhos','Isabel de Castro','Sales Representative','Estrada da saúde n. 58','Lisboa',NULL,'1756','Portugal','(1) 356-5634',NULL),
  ('QUEDE','Que Delícia','Bernardo Batista','Accounting Manager','Rua da Panificadora, 12','Rio de Janeiro','RJ','02389-673','Brazil','(21) 555-4252','(21) 555-4545'),
  ('QUEEN','Queen Cozinha','Lúcia Carvalho','Marketing Assistant','Alameda dos Canàrios, 891','Sao Paulo','SP','05487-020','Brazil','(11) 555-1189',NULL),
  ('QUICK','QUICK-Stop','Horst Kloss','Accounting Manager','Taucherstraße 10','Cunewalde',NULL,'01307','Germany','0372-035188',NULL),
  ('RANCH','Rancho grande','Sergio Gutiérrez','Sales Representative','Av. del Libertador 900','Buenos Aires',NULL,'1010','Argentina','(1) 123-5555','(1) 123-5556'),
  ('RATTC','Rattlesnake Canyon Grocery','Paula Wilson','Assistant Sales Representative','2817 Milton Dr.','Albuquerque','NM','87110','USA','(505) 555-5939','(505) 555-3620'),
  ('REGGC','Reggiani Caseifici','Maurizio Moroni','Sales Associate','Strada Provinciale 124','Reggio Emilia',NULL,'42100','Italy','0522-556721','0522-556722'),
  ('RICAR','Ricardo Adocicados','Janete Limeira','Assistant Sales Agent','Av. Copacabana, 267','Rio de Janeiro','RJ','02389-890','Brazil','(21) 555-3412',NULL),
  ('RICSU','Richter Supermarkt','Michael Holz','Sales Manager','Grenzacherweg 237','Genève',NULL,'1203','Switzerland','0897-034214',NULL),
  ('ROMEY','Romero y tomillo','Alejandra Camino','Accounting Manager','Gran Vía, 1','Madrid',NULL,'28001','Spain','(91) 745 6200','(91) 745 6210'),
  ('SANTG','Santé Gourmet','Jonas Bergulfsen','Owner','Erling Skakkes gate 78','Stavern',NULL,'4110','Norway','07-98 92 35','07-98 92 47'),
  ('SAVEA','Save-a-lot Markets','Jose Pavarotti','Sales Representative','187 Suffolk Ln.','Boise','ID','83720','USA','(208) 555-8097',NULL),
  ('SEVES','Seven Seas Imports','Hari Kumar','Sales Manager','90 Wadhurst Rd.','London',NULL,'OX15 4NB','UK','(171) 555-1717','(171) 555-5646'),
  ('SIMOB','Simons bistro','Jytte Petersen','Owner','Vinbæltet 34','Kobenhavn',NULL,'1734','Denmark','31 12 34 56','31 13 35 57'),
  ('SPECD','Spécialités du monde','Dominique Perrier','Marketing Manager','25, rue Lauriston','Paris',NULL,'75016','France','(1) 47.55.60.10','(1) 47.55.60.20'),
  ('SPLIR','Split Rail Beer & Ale','Art Braunschweiger','Sales Manager','P.O. Box 555','Lander','WY','82520','USA','(307) 555-4680','(307) 555-6525'),
  ('SUPRD','Suprêmes délices','Pascale Cartrain','Accounting Manager','Boulevard Tirou, 255','Charleroi',NULL,'B-6000','Belgium','(071) 23 67 22 20','(071) 23 67 22 21'),
  ('THEBI','The Big Cheese','Liz Nixon','Marketing Manager','89 Jefferson Way Suite 2','Portland','OR','97201','USA','(503) 555-3612',NULL),
  ('THECR','The Cracker Box','Liu Wong','Marketing Assistant','55 Grizzly Peak Rd.','Butte','MT','59801','USA','(406) 555-5834','(406) 555-8083'),
  ('TOMSP','Toms Spezialitäten','Karin Josephs','Marketing Manager','Luisenstr. 48','Münster',NULL,'44087','Germany','0251-031259','0251-035695'),
  ('TORTU','Tortuga Restaurante','Miguel Angel Paolino','Owner','Avda. Azteca 123','México D.F.',NULL,'05033','Mexico','(5) 555-2933',NULL),
  ('TRADH','Tradição Hipermercados','Anabela Domingues','Sales Representative','Av. Inês de Castro, 414','Sao Paulo','SP','05634-030','Brazil','(11) 555-2167','(11) 555-2168'),
  ('TRAIH','Trail''s Head Gourmet Provisioners','Helvetius Nagy','Sales Associate','722 DaVinci Blvd.','Kirkland','WA','98034','USA','(206) 555-8257','(206) 555-2174'),
  ('VAFFE','Vaffeljernet','Palle Ibsen','Sales Manager','Smagsloget 45','Århus',NULL,'8200','Denmark','86 21 32 43','86 22 33 44'),
  ('VICTE','Victuailles en stock','Mary Saveley','Sales Agent','2, rue du Commerce','Lyon',NULL,'69004','France','78.32.54.86','78.32.54.87'),
  ('VINET','Vins et alcools Chevalier','Paul Henriot','Accounting Manager','59 rue de l''Abbaye','Reims',NULL,'51100','France','26.47.15.10','26.47.15.11'),
  ('WANDK','Die Wandernde Kuh','Rita Müller','Sales Representative','Adenauerallee 900','Stuttgart',NULL,'70563','Germany','0711-020361','0711-035428'),
  ('WARTH','Wartian Herkku','Pirkko Koskitalo','Accounting Manager','Torikatu 38','Oulu',NULL,'90110','Finland','981-443655','981-443655'),
  ('WELLI','Wellington Importadora','Paula Parente','Sales Manager','Rua do Mercado, 12','Resende','SP','08737-363','Brazil','(14) 555-8122',NULL),
  ('WHITC','White Clover Markets','Karl Jablonski','Owner','305 - 14th Ave. S. Suite 3B','Seattle','WA','98128','USA','(206) 555-4112','(206) 555-4115'),
  ('WILMK','Wilman Kala','Matti Karttunen','Owner/Marketing Assistant','Keskuskatu 45','Helsinki',NULL,'21240','Finland','90-224 8858','90-224 8858'),
  ('WOLZA','Wolski  Zajazd','Zbyszek Piestrzeniewicz','Owner','ul. Filtrowa 68','Warszawa',NULL,'01-012','Poland','(26) 642-7012','(26) 642-7012');

COMMIT;

#
# Data for the `Employees` table  (LIMIT 0,500)
#

INSERT INTO `Employees` (`EmployeeID`, `LastName`, `FirstName`, `Title`, `TitleOfCourtesy`, `BirthDate`, `HireDate`, `Address`, `City`, `Region`, `PostalCode`, `Country`, `HomePhone`, `Extension`, `Photo`, `Notes`, `ReportsTo`, `PhotoPath`) VALUES 
  (1,'Davolio','Nancy','Sales Representative','Ms.','1948-12-08','1992-05-01','507 - 20th Ave. E.\r\nApt. 2A','Seattle','WA','98122','USA','(206) 555-9857','5467','/\0\0\0\0\r\0\0\0!\0ÿÿÿÿBitmap Image\0Paint.Picture\0\0\0\0\0\0 \0\0\0PBrush\0\0\0\0\0\0\0\0\0 T\0\0BM T\0\0\0\0\0\0v\0\0\0(\0\0\0À\0\0\0ß\0\0\0\0\0\0\0\0\0 S\0\0Î\0\0Ø\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0€\0\0€\0\0\0€€\0€\0\0\0€\0€\0€€\0\0ÀÀÀ\0€€€\0\0\0ÿ\0\0ÿ\0\0\0ÿÿ\0ÿ\0\0\0ÿ\0ÿ\0ÿÿ\0\0ÿÿÿ\0ÿ°É\0
\t\t\0\0\n\0\t\0\0\0\0\t\t š
\t\0\n \0\0\0ÿïÿÿÿÿÿÿÿÿËœüþúÿÿÿÿíÿþÞÿÞþüÿÿÚÚ\0Ù\0\0\t\0\0\0\0\0\t\n\0\t
À\0\t\0\0\0\0\n\0¬ àààðéÊ\0©Ë\0\0à\0\0\t\t
\0\0Ð\t\0\0\0\t\0\0š\0ÿÿÿÿÿþÿÿÿÿü­ëÛßßßÿÿÿÿïíÿþÿÿÿþü¯š\n\r\0\0š\0\0\0\0\0\0\0\t\t\n\0
\0š\0\t\0\0\t\0\t\0ú­ \0°
\0\0\0\0\0\t\0\0\0\t©°\t\0š\0\0\0\0À\0¿ÿÿÿþÿÿÿÿÿÿÏŸ¼¾ûÿëÿÿÿþýÿþýÿÏþÿù¼
\0\0\0\t\0\0\0\0\0\0\0\0\t À°\0\0°\0\t ü­ É\0\0Ë\0\0\0šš\t \0°\t\0\r\0©\t\0\t\t\n\0\0ÿÿÿþÿþÿÿÿÿÿððÿßí­ýÿÿÿÿþþýïïüýïìšÀ\n\0 \0\0\0\0\0\0\t\n\n\0\0\0\n\0\0 \t\0ù\0Ú\0š\0Ú\0Ð\0\0\tÀ\0\0°\0©©°\0\0\0¬\0\0
ÿïÿÿÿÿÿÿÿÿí©ßùÿÿÿðÿÿÿÿýþÿÞÿïßù© \t\t\t\0\0\0\0\0\0\0\t\n\0š\0©\r\t\0\0©\0
¬ úé©Ê\0\n™©
\0\0\0°\0\0\t\0Ð\0\t©\0\0\0\0ŸÿÿÿÿÿÿïÿÿþÚÞ¼ýïý­­ÿÿÿÿÿïïËïÞÛïÊÐÐà\n\0\0\0\0\0\0\0\0\0\t\0\0\0\0\t\0\n\0\0\0\0\0\0š\rðÊ\t\t
\0\t\n\t\0\0°\t š\0\t
\0\tÿÿÿÿÿþÿÿÿÿý\téÏ¿¿ÿÿïýïÿÿÿýÿßëþý©
\n\n\t\0\0\0\0\0\0\0\0\0\0\0\0©\t\0\n\0\0¬°
\nðð¼\t\0\0\t­©\t\0\0\t\0\0\t\t\0™\t© \0\0\0\0\0ÿþÿÿïÿïþÿÿêžŸ¿ÞßÿßÿßÿÿÏÿÿïïíüýïÀ\0Ð\0\t\0\0\0\0\0\0\0\0\0\0\0\t\0\n\0\t\0\0°\t\0\0\0À\n\tÀÿ
Ê
\n\0\t\nš\0°\t\0\t\0\0°Ð©\0\0š\0
ÿÿÿÿÿÿÿÿÿÿÐùéðûï¯Ëþÿßÿÿÿÿßúÿ¯žûÀ©À \t\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0
\0\0\0\n\0\0\0°É\n\0ð°ð\tÀ\0\0°\tÀ\0°\nÐ\0°\tšš°\t\0\0\tÀÿÿÿïÿïþÿÿü©ÏýýÿßÿßÛïÿßÿÿïÏÏßïÀ\t\0©\0\0\0 \0\0\0\0\0\0\0
\0\t\0\0\0\t\t¬\0\n\0 Àœð\0Ú\0\0\t\tð¹\tÀ\tš\t\0š\0\0\0š\0\0š\tÿÿÿÿÿÿÿýÿþéœðý¾žúü¾žûïÿÞ¿Ûÿÿÿðþß\n­\0\t\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0š\0\0\0\r \n\núÚÛ\0šÉ\0\0\0\t\0\n\t­\0\t\0›Ë\tÉ\0\0šÿÿÿÿþÿþþþÿÚËÚßûßŸýýýýÿÿÿïÿÿïÏ¾Ðé\0œ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0š\0\0\0°Àœ\0ý©šÉ ©\n©©\t­\0›\nÐ©\0\t\t
\n\0\0½ÿÿÿÿÿÿÿÿÿü\t­

í¯éï¯¾¿Úýÿý¿ÿÿÿüÿé\0š
\0\0\0©\0\0\0\0\0\0\0\t\0\0\0\0\0\t\0\t°\0\0\0\0°\0\nÐúÞ¹é\0\r\0\t\0Ð°™© ð\t\0°™\0\0\0\0žÿÿÿÿÿïÿüÿÀðÚüùýŸßŸùýýþÿÿïßíÿÿïÏþÞž\t\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\tœ\0\0\0ð\0\t\0\0ýºÜ­©\0©\0\0\0°\tÊœ\tš\0°\t\nž
\0 \0\tûÿÿÿþÿÿïïü
\t­\t­ëïéïËïŸ½ÿÿÿÿÿÿÿÿïð\0\0\0\t\0\0\0\0\0\0\0\0\t\0\0\0\0\t\0š\n\0\0\t\0\0\nÊ\núí«ù­©\0Úœžš™©É©™\t\0\t\t™\0\0\0\0¼ÿÿÿÿþÿýÿËÀðÚžÛýùÿûÿŸíÿëßþÛÿÿþÿÿì\t¬°\0\0\0\t\t\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0 \0\0\0Ðý¾ÚÏ¼¼º\t  \t\t¬›©ž\nš\t
\0¼©\0\0\0\0›ÿÿÿÿÿÿþÿ\0žœ¹í¯ÏëÏéûÏßûÿÿÏÿÿÿÿÿà\t\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0š\t\t\0\0\0\0\0
ÿéý¼ž›É\0™\0°›\rš\t™À\0š\t\t\0\0\tÿÿþÿÿïÿü©\0°ÚÛß¿ý½¹ý¿Ïûÿíý¿ûÿÿÿÿþ
\0\t\0\0\0\0\0\0\0\0\0\0\t\0\0\nÐ \0š\0\0\0š\tùÿëëëÚÛ­
Ê\tÀ¼°¼›\0©\t
\t°\0\0\0\0¹ÿÿÿÿÿýïÊœ­\r­¾¾ÚÛí¯Ëü½¼ýÿïüýÿÿÿÿí\0\0š\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0Úþ­¿Ûß­\n°°\t

Ð¹\0\0\0\t\0\0\0\tÿÿÿþÿïÿÐš\0°ðýùÿí¿ß¼¿ÿÿ¯ûÿûûÿÿÿÿÿà\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\nššùÚÚü¿¼¿Ÿ
\t
šœ¹¹\t°\0\0\0\0¿þÿÿÿÿïà\t\t­
ËÚþŸÛËéÿÚÚýùýýÿÏŸÿÿÿÿÀ\0\t\t\t\0
\0\0\0\0\0\0\0\t\0\0\0\0\t \t©\0\0\0
\tàþ­­ûðÛÚð¼\t\0

\r¹
\0\t\0\0\t
\0\0\0\0\tÿÿÿÿÿïÿ\t\nÉ­½¯Ûþ¾ÿßðÿÿÛÿïûÿÿïÿÿÿþ°\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°\0\0\t\0š\0\0\0©ðß¯éëëÛé°°¼\t
Ðšš\t©\0°\0\0\0\t\0›ÿÿÿïÿýü\0\nùï½¾ÛýùþŸûÛïÿÛüÿŸŸÿÿÿý\0\0\0\t\0\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\tÀ\0\nš\0\0\0\t \nœþ Ðý¿¼œ­¿\t\r
\0™
\t¹é\0°\t\t\t\0\0\0\0\0ïÿÿÿïï\0\t\r¯žÞÛüûþŸúßïßËÿÿÿþùÿÿÿþ\0\t\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\t
\0\0\t\0\0\0°ð \0\r
ýÿ¯¯í¿¿žžðºšÚ\nœšÐš\t\0\t\0\0\0\0\0\0\0\t½ÿÿÿïÿþ\t\0©\tðûûý¿Þÿÿßûß¿ÿéý½ùþÿÿÿÿÀ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0š\t\t\t­\0\0\0ûïßý¿éé©¹½\tÛÐ›\t
\t\0
\t\t\0\0\0ÿïÿÿÿí\0\r¼½­íïÿÿŸÚÿŸþßŸßïïÿùùÿÿù°\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0
\t\0\t\0\t\0\0Ÿ\nÀ\0\0 ¼üð¾ÚÿŸšßúš°
\té©©é\0\t\0\0\0\0\0\0\0ûïÿÿÿíð\t\0›ß¿¿ËßþÿÞþß¿þûùûßþÿÿþ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tð\0\0\0\t¼©\0°\t\t ­\r\túžÉ¯žð­ºÐ½ùÉð°™š\n\t\0\0\t\0\0\0\0\t\tÿÿÿïþü\0°àùÿ¯ßßÿúý¿ûß½üùüÿß¿ûÛÿÿýš\0\0°\0\0\0\0\0\0\0\0\0\0\0\0
Ë
\0\0\t \t\0\téà\0\t\0  ÿËþÚù¿ÚÛ¿

°™ÚŸ
Ë\r\0\t\0\0\0\0\0\0°ßÿïÿÿð\0\tŸß¯ëßýÿüÿÿþ¿ÿûÞ¼ùü½­ÿúÐ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ð\0\t\0°\tð°\t\r\tþ¿Ë­¾ð½­©ý¼Ÿ ¹\0\tš\0 \0\0\t\0\0\0\0\t¯íÿÿïÀéùûëßÿûÿÿÿ½éÿßûß¾ûÿÛÿÿ\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¹© \0\t\t\0ú
Ê\0\0°°à ðð¾ßï›ÊÚß©©©\tž™°¹©\0\0\t\0\0\0\0\0\0\0šßÿýïý \0ð½¯ÏßÿŸüÿéÿÿÿùëýÿ­ëý¼¼¾žðš\0\0œ\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0\n
\0\r\0\t\rúÏí¯Ÿž½¹©½½½°¹©\tÐ°\t\0\t\0\0\0\0\0\t\t­ïïÿï\0\tðùûü¿ïÿùÿùüùïý¯ÛýÛÛÙùÿ\0\0 \0\0\0\0\0\0\0\0\0\0\0\0
\t\t\t
œš\0àÀ\n\0
°ý°ððûéËÏžÚššÛËšÚ
\t\t©\0\t\0\0\t\0\0\0\0\0›ýÿÿÿÀ\t¬½¯Þ¿ýûÛÿýïûÿŸ¯ßðùëûïï­­¾\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\t \0\0°«Ð
\n°éðí¯žž›¼¹ë½½½°šÐ™\t\0\t\0\0\0\0\0\0\0\0\t ÿþþð\0\0ÛËß¿ß½ïÿûÿÞßïß­­þŸËÛÙûÐ½
\0\0Ë\0\0\0\0\0\0\0\0\0\0\0\0œ©\0©
ÉÐ\n\0
\0\tÀ°šÀð¹­­¿
Ë¼¹ÚÚš½©°© š\0\0\0\0\0\0\0¾ÿÿÞ\t\r°ûûíëÿÿÿÚßß¿¿½úÛÿ­¼½­¾ù
Ð\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\t \0\t™©
\n\t
œð
À¬
û\t­©ý¿Ëž»›ÛÛ¹\tœ\t\t\0\0\0\0\t\0\0\0\0\nßíþð\0\nŸÏÛßßß¿ÿÿ¾ýüúß¼šÚÛËðù¼¾šÀ\0¬\0\0\0\0\0\0\0\0\0\0\0\0š\t ž\t\0¼© 
\0\t\0\tý»\tð°¹¼¹Éé°¼¹ËÚ›\t\0°\0\0\0\0\0\0\0\0\0©úßï\0éùúÿ¾¾¿ßÿÿýþ¿ß¼ÿí½­¼½¯Ðù\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\tž\0™\tÉ\0\0\nšžûÍð¾›ÛÚÛž›½­¹\t»\t\t\0\t\t\t\0\0\0\0\0\0\t\tíþÐ\t­¼¾ŸÚßßÿïÛÞÛýü¿ËËÚÚÛž™¯
Ú\0°\t\0\0\0\0\0\0\0\0\0\0\0\0\t\0©°\t\t°šÚ\0 \r
\r\0\0ð›©ù¼»
é»Ëù°ù­°\t\t\0\0\0\0\0\t\0\0\0\0\0\0žžùà\0Ù­½ý¯ÿ¿Ÿûÿÿÿúûü½½­­¬½­¼ùž\r\t\0\0 \0\0\0\0\0\0\0\0\0\0\0\0°\0\0°š\0\0\0\0\0\0\0
\0©ÿ­œ°ù­»ÛŸ\r¿šÛ
¹šš\0°\t\0\0\0\0\0\0¹éï\0ššÛËëý½ïÿýÿûÿßÞŸËàùéÛËŸ
\r©š\0\0\0Ð\0\0\0\0\0\0\0\0\0\t\0\0\t©\t\0\0\0\t\t\t
\t \0\t\0ùú»ÛšÐ¼¹°šù©¼»ËÉ\t\0\0\0\0\0\0\0\0\0\0\0\0žœð\té­½žŸëýÿÿÿÏÚûÿúý½­¾œ¼°ð¾ž \0\0\0\0\0\0\0\0\0\0\0\0\0©\t\0\0\0\0\0\n\0\n\0\n\0\0\t\0\0ÿŸß¾›ù¿›žŸ½›ÙË°\0\0\0\0\0\0\0\0\t
\të\0œðþ½ûßÛÿ¿ùÿÿßËÏ\r©éË\r\t\t \0\0š\0\0\0\0\0\0\0\0\t\0\t\0\0\t\t\0\0\0\0\t\0\0\0\t\r­úÿúÛÚÛðùéºÛ¾š°Ÿ›°\0›\0\0\0\0\t\0\0\0\0\0\0ÚÐÐ šÛËß­ûïüýïÿùþ½ùðððÚž¼šÚž\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0š\0š\0\0\0\0\0\0\0\0\0\0\0\t\0

ùëÿð½©ûÛšÙ¼ù¹›
\té\0\0\0\0\t\0\0\0\0\0\0\0\t\t­ \0ù­½­úýÿÿÿ¿ùþ¿ÛïËÚÐððžð™\t\0\0\0\0\0\0\0\0\0\0\t\t\0\0\0\0\0\0\t\0\0\0\0\0\t ©½¿ûßŸÿŸûÛëÛ¼»Ÿ\r¹°\t\t\t\0\0\0\0\0\t\0\0\0\0\0\0ž\0\t¼¿ûß¿½¿ÿÿþÿß­¼¼¼ºžžðžž
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \t\0\0\0\0\0\0\0\0\t©
ËŸþ¾ÿ°úŸ¯Ÿ½
ðú›šž™©©\0\t \0\t\0\0\0\0\0\0\0\t
É\t¬›žž¿ÞÿýÿßÿýëßëÛËÍËÉë\r©\t\0Ð°\t\0\0\0\0\0\0\0\0\0\t\0\0\t\0\0\0\0\0\0\0\0\0\0\nð¿ïùù¿¹ÿùûË¿Ÿ™ùé
ž\0\0\0\0\0\0\0\0\0\0¬\0\0\t ùéýý¿ßÿÿÿŸÛýþ¬¼°©
\r\0ž\t©\0\0\0\0\0\0\0\0\0\0\0
\t\0\0\0\0\0\0\0\0\0\t\t

\tùùûïÉù¹¿¹ùé¿©Ÿ™\t\t\0\0\0\t\0\0\0\0\0\0\0\0\t\t\0\t\0ÙŸ¯¾ÿ¿ÿÿÿÿïúùþùéžœ °ž\t\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\n\0\t\0\0\0\t\t\0\0\n°\t\t\r¿¾¿ýûþ¿ùÏÛùúÛûËÛ©­°°°\t\0\t\t\0\0\t\0\0\0\0\0\0\0\0\0\0š
ÚÛßý¿ÿÿÿÿÿÿßþŸ Ð©ÐË\t\0°\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\t­©©ŸžúžÛÛž»¯š½¾¹°Ûš™É\t\0\t\0\0\0\t\0\0\0\0\0\0\0\t\t\0\0©\r
ðûËýÿÿÿýéùïðððÞšÐ© ùé\r\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0
\0žœšùééùÿ¯¾ý½ý¿Ûùûéé°½°š\0©\t\t\0\0\0\0\0\0\0\0\0\n\0œšüŸý¿ÿÿÿÿÿÿïùý­­\r©¬žœœ\0\n\t\0\0\0\0\0\0\0\0\0\0\0\0š\0\t\0\0\t\0\t\t\0\0\t
\0°¿žšÚð
Ûù»ëúÛ½«Ÿ›ž©
\t\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0\0
\r›é¯ýûÿÿßÿùùï¯ÚÚšœ
\0°© ½\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0š\t\nœ
ð½ ¿­ÿßŸŸ¼¿Ûéé¹©Ÿ°©\0\t\0\0\0\0\0\0\0\0\0\0\0\0°éÿÛÿÿßÿÿùïïœÚÛÏ\r©Àž\rœ\n\0š\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\t\0œ°šû\tð°ÿ¿¿ëûÛð½»ÛÉð°°Ð°\t\0\t\0\0\0\0\0\0\0\t\t\0\t©É½­¾Ûÿÿÿÿþùðû½¯\tàÐ©àš

\tÉ\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\t\0\0\0 
\t

½œ°ðžù­¹ÿËŸùëÛÛí°»\tŸ\t\t\t\t\0\0\t\0\0\t\0\0\0\0\0\0\0\0\0šÚÛßÿÿÿÿÿßŸ¼Úðž
\nÐ\t\0ÐÐÐ\n\t\0\0\0\0\0\0\0\0\0\0\t\0\t\0\t\0\0\0\0\0\t\t\t\n\nšœŸÚú›Ëéðùþ›ÿùëÛ¾¿›ù\tð°šš\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0ŸŸ¾ûÿß¿ÿŸ¾ðùË­\r ÐÐ\r\nÛ
\n
\t\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0é\t\r©©­\tü¹Ëé¯ŸÿšÿŸ½½ðð¾Ú›Ë™
\0\t\t\0\t\0\0\0\t\0\0\0\t\0\0\0\0ðÛßŸ¿ýÿþÙÿ\r
Ë\n\nÐÊœ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°\t\nœ°šÛÚð
ÊŸ°Ÿé©ÿÛþžŸ»Ÿ››É¹Ë\0
\t\n\0\t\0\t\t\0\0\0\0\0\0\t\0\t©­¿¯ÿüûü½¾¼¹é¬œœ\r°©©\t\n\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0°\t\0\t\0\t
½©©
ÐùÿÐ¾šÞ½¾ùûûéðü¼š°©œ\t\t\0\0\0\0\0\0\0\0\0\0\r
ûÏßéûþÛý­žÚž\tÉ

°°
œ\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
°ËÀ¼¼½¯Ÿÿ°½½¹ëý¿­½¼››¹Ë™Ú
\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0šÙ­»ùÿÿŸ½ëÛé©ÉÚž°\t ðÐé\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\néÉ°½¹éþßÿÿð\nÚÛÛëßŸ¯ûËËù
ð™\t\t\0\t\0\t\0\0\0\0\0\0\0\0\t­ŸÏïŸŸÿÿŸðßž¼¼°\t©­\t\0©\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0
\0\t\t Ÿ\nß
ýÿÿðÛËðùŸ¾ùùù¿ð¹\t °\t \t\0\0\t\0\t\0\0\0\0\0\0\0\0žšðùùÿÿýÿþŸ°ý\téÉ Ð\0\t À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
\0
\0\tÚš™éù ùýÿÿÿ°°¿¾úÛÚûËé©ëœšÙ©\0\t\0\0\t\0\0\0\0\0\0\0\0\t\t©Ÿ¿¿ÿÿÿýùþßð½¾\t É Ð°\t\0\r¬ \t\0\0\0\0\0\0\0\0\0\t\0\0\0\0\t\t\0\t\0\0š\0œžšž½ºÿÿÿßð\r­ðù½¿¿Ÿ½›Û©
\t\0\t\0\0\0\t\0\0\0\0\0\0\0\0\0ÐùéýÿÿÿÿûÿŸ¼½ëÉðÐ¼\t \r \0\t©
\n
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\t
\t©­
ÚßŸÿÿÿð©úŸËÚÛéûéé©Ÿ\t
›À°š\t\t\0\0\t\t\0\0\0\0\0\0\0°­¿¿ÿÿÿÿýÿíÿÛÞ¼½­\tàœ\0\0š\0\0À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t \0\n\0šŸ
¼½¯ÿßÿÿðŸ\téé½¯¿Ÿ››Úðš\0™\0\t\0\0\0\0\0\0\0\0\0\0\0\0\tÛßÿÿÿÿÿÿÿŸŸ­½ßšÚé©°šÚ\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0¼ððÙúŸ½¿ÿÿ°žžš›úùùí¿­­©™©É
š\t°\t \0\t\0\0\0\0\0\0\0\0\t\tŸ¿ÿÿÿÿÿÿÿýÿïßþ°ý­ž©\0\0\0\0© \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\n\0
\0­©é«éýûïßýð
ð½¬ŸŸ¿»ËÛ›œ¼°\0\t\t\0\0\t\t\0\0\0\0\0\0\0\0¿ÿÿÿÿÿÿÿÿÿùùúÛßšÚÏ\t­©\0ž
\t\t\tÀ\t\n\0\0\0\0\0\0\0\0\0\0\0\0\0©\t\0ÐšÛ
ÞšûžÛÿÿð\0½©ûËí¼ûù¯Ë
š›\t\t\t
\0\0\t\0\0\0\0\0\0\0\0\0™ùÿÿÿÿÿÿÿÿÿÿÿßü½éù°ðœ¼\t¼ à\nÐ\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0°
Ë½½­ëŸËà\0šÚÚ½»ûŸŸÛŸ½
Àð\0©\0\0\t
\0\0\0\0\0\0\0
¿ÿÿÿÿÿÿÿýÿýüùëÛÚßÍšÚÚ\t¼©\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0°\0ðšÞšùëþ°\t­½­Ÿ­ððú›Ë¹\t°™©\0\0\t\0\0\0\0\0\0\0\0\0½ÿÿÿÿÿÿÿÿÿÿÿ¿¿Ý­í°ý°­\t¬šÀËÉ\0\tÀ
\0\0\0\0\0\0\0\0\0\0\0\t\0\0\n\0\t\t\0¼°»
ïÀð\0\n
Ûéÿ¿ŸŸ­½°°\t
\0©\0\0°\0\0\0\0\0\0\t¿ÿÿÿÿÿÿÿÿÿÿýýý¯ùûÏ
ËÙ­
É
Ê\n\0©\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t
\0\n\t
œœ°ððš°ý¿é
É\0½¾ŸÚð¹ð»éŸ\r\t
\0\0\t\0\t\0\0\0\0\0\0ŸûÿÿÿÿÿÿÿÿÿýÿÿËÙþŸ½ðü¾šÐ¼°\r\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0œ
\r«
Ï

ÉË\nÚ°À°©ééûûÛÞŸœ›é°°©
\t©\0\0\t\0\0\0\0\0\0\tûßÿÿÿÿÿÿÿÿÿÿÿý¿þùðúŸ›É\r©Ë\r  š
Êœ \t\0\0\0\0\0\0\0\0\0\0\0\0š\n\0\t\0šœ¼¹ËÀ°°ý­ð
ÀÛËûÚùë
›
ð™\0\t\t\t\0\0\0\0\0\0\0\0›ÿÿÿÿÿÿÿÿÿÿÿßùëüŸžß\tü¼šÚœ°Úž™àÐ\t\0œ \0\0\0\0\0\0\0\0\t\0\0\0\0\t\0\t\0\0°
ËËž©
žššð\0
\0°ÚýÿŸÛéù
Ê™©É \t\0\t\0\0\0\0\0\0\0\tÿÿÿÿÿÿÿÿÿÿÿÿÿÿßŸðù©Þ\t­­¼Ÿ\r­\tÊ\t­¬°\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\t\0\0\0ðéðù°ððð\tÀ¼šŸ¿¿ûéð¿›™ Ð°š
\0\t\0\0\0\0\0\0\t½¿ÿÿÿÿÿÿÿÿÿÿÿùéùíÚ¹é
é °šÚœžÉ \0\0\0\0\0\0\0\0\0\0\0\0\0\0°\n\0\t\0

›ÊÊŸ

°\0©\n\téËßŸ›ÐðÚÙ
\t\0\t\t\0\0\0\t\0\0\0\0\0¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿž¿š½œ½\r­©é©ËËšÐÚ\0\0\0\0\0\0\0\0\0\0\t\0\0\n\t Ð½\n¹à¹ð¼ð œ°Úž¿¯½¿¯
\t©°°š\t\0\0\0\0\0\0\0
Ûÿÿÿÿÿÿÿÿÿÿÿÿý½­œÐð\té¹\nÐúÚœšœ©\0
\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\t
À©ÚŸž\0°¾ü
À¼¹ùùûËÛÛŸœ\0
\0\0\0\0\0\0\0
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿùÙ©š\t\t\tðÊÙ¯\téé­ žžš\té\0\0\0\0\0\0\0\0\0\0\t\0\0\0¼°Ð©ù­­\t°¬°Ú\r¯Ÿ¼¼¼°ùé­©\t©\0\t\0\0\0\0\0\0½ÿÿÿÿÿÿÿýÿÿÿÿý¾œÙÐš\0\té°­\téžžÛÉ©Ééà\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \tË\tÚ¿\0°°ðÐ
\0ð©úŸ¯¿Ÿ¿ŸŸ
¼\t\0\0\0\0\0\0\0\tûÿÿÿÿÿÿÿý¿ÿÿÿýŸÉù½©
ÉÐ\0ÉÀðžŸ\té ¼¼©\0Ð\0\0\0\0\0\0\0\0\t\0\0\0\0\0š\0š
ÛÊž\té\0 ŸË\0™éËùý­½°°¹é
\t\t\0\0\0\0\0\0\0\0\0
¿ÿÿÿÿÿÿùûÿÿÿý½ÿŸÐÙ\t\0\0š›
Ë\r\t\tÚËËÊ\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\t©\0é\r ùééðžðÐ\0°ð\n›ùÿ¯ûÚùùË›Ðšš\t\t\0\0\0\0\0ýÿÿÿÿÿÿÿÿß¿ÿÛÛ™Éé\t\t\0\0\tœ½ðùé
ÊÚ\0\0œ\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\t\0°™žžž\r© \0°\0žžéúÛùú½¾šœ°¹\t
\t\t\0\0\0\0\0\0\0\0
ûÿÿÿÿÿÿÿŸ¯ßý½\r\0™ùË¼ž\t\t\t\0©\nÛËÛé\r\r­\n
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\nšð¹ ðÉ\0Ú\0\té¬šŸ¿ß½úÛß›œ°\0\t\0\0\0\0\0\0\0›ßÿÿÿÿÿÿÿÿÛÿ\0šŸ¾ÿþùËà\0\0\0\0ù­¼¼žšš°\0\0\0\0\0\0\0\0\0\0\t\0\0\t\0\0\0\t
É\t­­œ\t\0\0© 

Û
ËÞ»ÿ½¿©°™«\t\r©\t\0\0\0\0\0\0\0\0ÿÿÿÿÿÿÿÿý­­\t\0™¿ÿÿÿšÿ\tàð\0\0\0\0ù­©©ÉéË¼\n\0\0\0\0\0\0\0\0\0\0\0\t\0\0\t\0ð°ÚÐðé
\0\0ð\0\t­­é¿¿ýùëÛŸ
ÙÚ\0\0\0\0\0\0\t½¿ÿÿÿÿÿÿÿûÚ\0\0ýûý¿ëÉéà\0\0\0\0­¯ÛÜÐ°šœ©\nœ\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\r Ú\t©\0š\0\0Ÿ©\t©¼ùúÿŸ­û›Ðº™©\t\0\0\0\0\0\0\0\0¿ýÿÿÿÿÿÿÿŸùÊÐ\t
\r­›Ð°\t\0\0\0šÚ«ËËÉéÚÐ©é \0\0\0\0\0\0\0\0\0\0\0\t\0°©\t\tÚž\r\0\0\0\0é\0©¬ž
ùûÿÛÿÛ­é
¼°©\0\0\0\0\0\0\0
Ûÿÿÿÿÿÿÿýÿž™™\0\t\t\0\t\0\t\0\0\0\0
É­Ù­\0š©©É\0Ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\t¬° É\0 \0\t°©\0\t ¿žÿÏ¿ð½Ÿ¹½

\t\0\0\0\0\0\0\tÿûÿÿÿÿÿÿûðÿÿÿ™\t\t½™É\0\t\0šÚÐ
Û\nÐ½¼žœž\n\n\0\0\0\0\0\0\0\0\0\t\0\0\0šÛ\t\r°°É\0žù\nšÚÐ\0ûŸ½ùÿúù¼°½½©é\t\0\0\0\0\0\0\0›Ÿßÿÿÿÿÿÿýÿ½¿ÿÿß™¼š
ÀÉ
ÀÚ\t
Ð¼½\0\nš\tœ\0\0\0\0\0\0\0\0\0\0\0\0\0°\0\n
Ë\0\0°À\t\0\0°ð \t©¬žÿûþŸ½¼¹Û
š
\0\0\0\0\0\0\0ûÿÿÿÿÿÿÿÿŸúßÿÿÿÿÛÛÉý©É¹­­°\r\0­
Ë\tùÉééà©¬\0\0\0\0\0\0\0\0\0\t\0\0\t\t\t\t­¼É©Ê\nËËð
\n\0© 
Ÿ­ûûÛûÚšÙ­¹©\t\t\0\0\0\0\0\0\t¿ûÿÿÿÿÿÿÿÿŸûÿÿÿÿÿýÿ
ß½àÐ\r °ŸšÜ°ð\0°™ÀÐ°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0šš\t\nšÐ°Ê °\0°Ð\0°ÿÿ½¼¿œ¹ùšÛÐÐ\0\0\0\0\0\0\0Ÿýÿÿÿÿÿý¿Ûùý½ÿÿýÿßÿ°ŸËË\tžžššÐð\r»\r\té\r

\0\0\0\0\0\0\0\0\0\0\0\t\0\t©éÉ\t©\0
ÀÊú\0©

À\r¿ùïÿðûÚšÛ›š\0\0\0\0\0›ÿýÿÿÿÿÿÿÿÞ¿ÿÿÿÿÿûÿÉé½¼ž\t\0ÐÐšºÀùéžš\t\0°\0\0\0\t\0\0\0\0\0\0\0\0\0\0š¼°À\t©­úð
\r©\n\0°° 
ÿŸŸ¿ÚŸ™­­°š\0\0\0\0\0\0\0\tûûÿÿÿÿÿÿÛùðùýÿÿÿýÿÿžŸ
\t\n›
\r Ù½\nžœ°ðË\t­\0\0\0\0\0\0\0\0\0\0\0\t\0
É\t\t©\0Ð¯ýûÀú©
\r­\t­ëÿëß¿ð¼››½©\t\t\0\0\0\0\0\0Ÿßÿÿÿÿÿÿß¿ß¿ÿÿÿÿÿý½\tðÐžœÐ°Û
ý\t\t\r\t©Àž\0¼\0\0\0š\0\0\0\0\0\0\0\0\0\0°ðž š
ßÿì°°\n\0 

Ê\t½é½ûÿ›Û°ÛÐš\0\0\0\0\0\0›ûßÿßÿÿÿÿýúÛü¿ÿÿÿÿûü¾ž\0\0¹­
\r°ðœ°ð
Ë\nœ
\0Ÿ\0\t\0\t\0\0\0\0\0\0\t\0\t
ËÚðšÉ¼ÿþÛÊË\0°ššðððûÿúžŸþ°Û©¿ž\t\t\0\0\0\0\0½ÿÿÿÿÿÿÿý¿½¼›ÛýÿÿßÿÛÙé\0\0
\r
Ëœ»ËÉ
ÐÉ
\0Ú\0\tÀ\t\n\0\0\0\0\0\0\0\0\t\0\0©Ë
À¼°ß¬°¼°\n\0\t
Ÿí¿ûùû\r¼°™\t \0\0\0\0\0\0
Ûÿ¿ÿÿÿÿÿýùûÉ½ÿÿÿ¿ß¿ùž\0\t°Ðœ¹É½¼¼­©¼\r
\té\nž\tÀ\0\t\0\0\0\0\0\0\t
\t¼œ¼
Ë
ðéùàë\0 ©  ðšðûÛËŸ½»™ÿ°°™\t\0\0\0\0\0›ÿýÿÿÿÿÿÿÿÿ¹ËŸ½ý\t¹ý°ù\0\0\0\t\0\t ùžž™Ëœ\t°\té
\0
\0\0\0\0\0\0\0\0\0\0žž°\t­©à
Ê\n\t
\t\0\0šš\0Ÿ­¯ùÿÿÚÐÿ¹\r\t\0\0\0\0\0\0\0½½¿ÿÿÿÿÿÿý½¾œ½ÿÿùŸŸÛÐéššÛÉùéËž½°°Àð© \0Ë\tð\0\0\0\0\0\0\t\t\t\té©
¼¼¼°°°ðšû\0\n\n\n\t¬ž\tÿý¾Úûÿ¿šŸ¹­
\t\t\0\0\0\0›ÿÿÿÿÿÿÿÿÿÿß›\t\tÿÿÿÿÿÛûÚÉ\r \0ŸŸ½éÐ¹ÉË\t\tÊÚà\t\0\0\0\0\0\0\0\0\0°šž¼¾šÚË\n \n\0©\0 š\t šúÛ¿ßûÛùùé\t\0\0\0\0\0\0½½ÿÿÿÿÿÿÿÿ½ýùùÿÿÿÿÿý­¹¬°Ðš½¼¼šÚŸËšœ°°\tà\t\t\tàð\0\0\0\0\0\0\0
É\tËËÏ
œ°š°ð\n\n\n\n °\tŸÿß¿½þŸ¾Ÿš\0\0\0\0\0
ÿÿÿÿÿÿÿÿßÿß¿ŸÿÿÿÿßÿÍ™éË\0œžšÛÛý½ºœ\r°œ\tà© š\t\0\0\0\0\t\0\t\0šÚúÏ
\n\0 \n\0°\t\0\n\t\nÚðûËúÿÿ½½½¹\t\t©\0\0\0\0\tŸŸ¿ÿÿÿÿÿÿÿßûýùùÿÿÿÿÿÿÛ›œ°
\téý­­
ËÉÛÛ°°°Ð©\téÐùà\0\0\0\0\t\0\t©­©¬½­ð°ð°¼¼°ú\n\n\n\n\t\n°šÛÿßÿŸûúûð°\0\0\0\0›ýÿÿÿÿÿÿÿÿûýûÿÛÿýÿÿÿÿþÞ™­Ú©ûÛýùþ¼¼›ÉÊœ\0\r\0©\0\0\0\0\0\0\0\0°Ðšœ
ÚÚÊ\0éééê\t\0\n\0 \n¿¿Ÿðÿùý¿ÛÉ\0\0\0\0\0­¿ÿÿÿÿÿÿÿÿýÿýûý½ÿÿÿÿýý½àš\t­©ðÚÐ°ð™Û°
Ë\nœ 
\t\0\0\0\0\0\0šÙ«Úü­ ½»¯ßð   © š\t©à°¼ÿÿ¿¿ß»ù°š\t\t\0\0\0\0™ý¿ÿÿÿÿÿÿÿÿÿßýÿÿÿÿÿÿÿûÚ¬

É½¿ßŸþžù\r­ \nœÐ¼°\0\0\0\0\0°¾Ð¿\0\n°ðÐê°
\t\0\0 š\0\t\0ÿûÿÿß¿žÛË\0\0\0\0Ÿ¿ÿÿÿÿÿÿÿÿÿý¿ÿûÿÿÿÿÿÿýéÚ\tœœ»ÿž­«Ë\tŸšÛÉ\tÊÀ\t\0\0šÐ\0\0\0\0\0š
\tù¯ÀÐëÚšÛ¬¾¯½Ë\0     °°é\0ÿùÿ¿ûû¿šÐ\0\0\0\0›ÿÿÿÿÿÿÿÿÿßÿÿ½ÿÿÿÿÿÿÿÿ½­ž\0°œùëÛý½ÿùé­šÚ\tš\0°\0
Ú\0\0\0\0\t\0úÚÐ°©\t Û\t\0\n¼°\t\0š\0

°šÿÿûýýûÛšš\t\t\0\0\0\tŸÿÿÿÿÿÿÿßÿÿýÿýÿÿÿÿÿÿßËÚ\t¹ËËùéÚßÚ¯žÚéé\r É\0\0\t\t\0œ\0\0\0\t\0Ÿ­¬\0°°ðš\0à¼š\0    \n\nš\0°­ûÿßŸ¿šÛÉ\0\0\0\0›ÿÿÿÿÿÿÿÿÿ¿Ûßùÿÿÿÿÿÿÿÿ½­¼°°žž½°ù­úÙé½žšÚÐ°\0\0\0\0\t© \0\0\0\0
\r°ššÊÀð
É­
\n\né\n
\t
\t©\t šÚÚ\t½ûûûð¿û©\0\0\0œ¿ÿÿÿÿÿÿÿÿßÿÿÿÿÿÿÿÿÿÿßËÉ\0›\r\réùÛÏÚß©Úùéé­\t©\0\0\t\0œ\0\0\0\0š¼¼\0\n\t
\0°\n°\t©ž\t\0\n\0 \n\n

\n\0ëÿÿÚŸ™°ù\0\0\0\0›ÛÿÿÿÿÿÿÿÿÿýûýÿÿÿÿÿÿÿÿùšÛží°½©Þ½žšÚ¼žš\0\0\0\0©à\0\0\0\0\0ùË
À\r\0\0šÉ­¬\0© ©\0°š\t  °é\t\r¿Ûÿ›ðÛž©\t\0\0\0\t½ÿÿÿÿÿÿÿÿÿÿýÿý½ÿÿÿÿÿùïð°Ð¬½¹¾ý¯Ú™ëÚÛÞ©éÀ\0\0\0\t\t\t\t\0\0\0\t
\n¼\0\t \0¬ °ššš°Ú\t\n\n\0 °Ëœ©\n\0
ÿ¿ùé
¹éš\0\t\0\0Ÿ¿ÿÿÿÿÿÿÿÿÿÿÿ¿ÿÿÿÿÿÿÿù\r\t©ÛÉïÉ
Ð½éœ­¬¹éË\t©\0\0\0\0
À\0\0\0
\0š\0\t\t\0éí¬\nÀ©\n\0\t\n\t©\0°\nœ 
ËÛÿ½¹\r¹ \t\0\0
ÛÿÿÿÿÿÿÿýÿÿßÿßÿÿÿÿÿÿÞœðš\n¬ºÐ›þËÚšËù½¼¼¼žœ\0\0\0\0\nœš\0\0\0\n›\n\0Ëš\n\nšš\t©
Ú\0© © \n
\t© š\t\tÿÿ¿šÐ¹™\t\0\0\t\0¹ÿÿÿÿÿÿÿÿÿ¯Ûëßßÿÿÿÿÿû\r\0ÙÊÛÍ­¬\t›Éí¹ËËËË\té \0\0\0\0š\0\0\0\0É©\0\0\nš\0\t\t\r¬ž\n\0­
\0\0\0
\tàêÚš\t \0
Úßù¹\t¹­°\0\0™›ÿÿÿÿÿûÛéý¼½ß¯¿ßÿÿÿÛÍ°° °\t©ÚÛÊÀ©\0úœ¼½­úœž\0\0\0É°\0\0\0\0°À¼
\t   °š\0°ð 


\0ê
\t é\nÚÚšÿ¿¾žšœ›\t\0\0\0\0›ŸÿÿÿÿýýÿŸ
É\nÙí¿ÿÿÿÿûÀ\r\tž©\0¹\r©ÛÉðœº\0\0\0\0°É\0\0\0\t©\0°\0
\t\0\t\nœ° \0
\0 \0\0\nšÊš©©\0ËÛýù™\t\t¼š\0\0\0™ðÛýÿÿÿÿûðü½
ÉšÛÿÿÿÿü¼¬
\t\tœ
ËÊÀÀËž¼ºÉëÉÊ\0\0­\nœ°\0\0\t\0\0Ë\tË\0ð\t © ­\n
É\nð°° ° à°é©žšË\0½úÿ©°°››\t\t\0\0™©¿ÿÿÿùýÿ›ÚÐš\tŸÿÿÿÿÚÀ \0ž\nÐ\0°°éË\rºÐžœ\0\0œ°
\0\0šÊ\té­ \0ššÐ\n¼\0 \n\t\né\n°ð¼¼šÛÛÚÐœ°¼\t\0\0\t\t©ÛËý¿ÿ¿ûËÀ\t\0\t\t­°ùÿÿÿýù\r
ÉË\t\0\0\0\0\0\t
\tàÐ¼°°\0\0\0\n
\0\0\0\0\r©½ \0\n\n\n\n\0©\0©\0 Ë\n\t \n\n\t šÐ°\n



ÿ¿ù›\t\tÛ\t\0\0\t\t©½¿ý¿ß\t\tà©À°Ð¿¿ÿÿÿ¬  
\0ÚÐ°\0\0\0\0\0ž›
ËË\0\0\0œÐ
\0\0\t šœ œ¾\t\t
\0­
É°°\n\t©\0š
à«É©ðððÐ½½¼°›\t© \t\t¹›ùûÚ°ž\0\0Ð\tÉ\nÛßÿÿÚÙ\tà\0\0À\0\0\0ðé\r\0\0\t \r©\t\0\0\0\t©Ë
\0\0    \n© \nð\t© \n\n\0\0
ÀªÐ©ª

ûûŸ\0›\0\0\0\0šÐž½½ \tÿ\0À\0\n\0\tûÿÿÿÿ \0\0¼\0\0\0\0\0\0\0\0\tàž°ðš\0\0\0\t©\0\0\0\0\t\0ž¼ð© \0\0\në\0\té \0š\0© \0°š
ËÙ¼°ùéÿ›°Ÿ\0ð\t\t¹™ž½\0›ÿà\0\nÉà\t\0ŸŸÿÿýý \t©\0\0ï\n\0\0\0\0\0\0\t Ÿ\tË\r\0\0\0Àð\0\0\0
É
ð­\0\0° °©\0é  ð
\n\0° \0\t °°ªË
Ëûùëù\t\0™\t\0\0\0¼¹ûé\0\0œ\tà\0\0\t\0›éÿÿÿÿ\t\t\0
\t\0\0\0\0\0\0\0šœ ¼°ËÊ\0\0\0\0š\0\0\0šüš\n
\0\0\0 \n
\0\t\0\t  š\0
\0 \t

\n¹ÚÛÛÿ½ð™ \t©\t\t

Û\tÿ
\0\0\0\0\0\0\0¼ŸûÿÿððÀ
\0\0\0\0\0\0\0\0\tÀË\tÚœ°\0\0\0\t \t\0\0\0\t¯Ë\t\0\t\0\nš\n\t 
\n
úš\0š\0©\0  Ê\0°«­ºý¿Ÿ©\t\0\t \0\0Ù
ÛŸúÿ\0\0\0\0\0Ÿ›ùÿÿÿÿ

\0œ\0ž\0\0\0\0\0\0\nšœ¼¬©ÊÀ\0\0\0\0œ\t\n\0\0°ù\0\n\n\n\n\0\t\t \0  \0\0ž\n\t  °\n\t\0šð
\t°»ÿùû\t°
\t\t\t©¹ýù\téÀ\0\t\0\0ýŸÿÿßéÀ\t\t \0\t\0\0\nÉ©
™Ë°\0\0\0\0°\0\t\0\0\0¯\0É\t\0š\n\n\nš\0© ð°\n\0\0°\n\n\0\n\0 \nššúßùûùð\0\t\0\0
ùðŸûí©\t©\t\0\0\t½¾¿ÿÿßëÐ°ž\nœ\t\0\tà\0\0œšÀðÊ¼­\0\0\0\0\0\r­\0\0
Ð\0  ©  \0\0\0š\n\0\0
\0 š\n
\0 \t\0°
\t©©­\tÿ¿ÿÛ\t\t\t\0\t\n™\t

ŸŸ›ý­\0¬\t\tºÛËßŸŸÿ½
À\t\r\t\0\0\t©\té©\r›¹Àš\0\0\0\0\0\t©à\0\t ¼\0\0š\0\0šš\n\0 \0 ð š\t© ©\t  
\0  °¿ùûÿ¹
\0\t\0™\0\0°™Ù
ÿýëûÿ™¼°Ùéù¼¿ÿ¿Ï­\0\0 ð¼\0©\0ÊÚÐð¬
ÊŸ\0\0\0\0\0\0Ÿ\0\0\0\r\t š\n\0\n\nš\0\0\0©\0° \0­\n\0 \0ðÊ \0š\0 š¾ŸŸÿÿ½ú™\0\0\n™›

™¹ûßŸŸï
Úž¼›ÚßùùÚð\t\0\0\t©ÊÛœ¼­
\ršÐž\0°\0\0\0\0\0\0\0\0\0\t\0¼\0\t© °\0  ©\n\0\0\n\0š°šš
©Ë© ©
Ê\0 \t«ûùÿ½›\0\t\n\t\r\tœ
ß½½éé\t\0Ÿ\té­¿Ïûéðð\t\0\0\0\0ééÚðð­
ÉÚÀ\0\0\0\0\0\0\0\0\0\0©
\0Ê\0Ë\0®
\t\r\0 š
\0šð \0 \nÚÐ \0\0œ  ššž¼Ÿ½ÿûð¼›\0\0™š›\t½©œ°š\0\0\t Ÿ›ß½¿¼ŸËï\t\0\t\0\0\0\t œšÐ¼° \0\0\0\0\0\0\0\0\0¼\0°°°Ê\n\n\n \0\0 ­\n\n\n ®ššš\nš\0\0©
¾ÿ¿½ÿ›\0\0
É\t¹\tž¹
\tËÉËÉéÛÚß
ßÿßé½™ËË\0\t\0 \0°Ðð¼¼
ÀÚ\0\0\0\0\0\0\0\0\0
\0Ë\n\0°   °¼\nÉ  \0š° š \t  ©à°šðÛÿÿûÿÚÐ¹\0\0šš™ËšÙËÉË\t©¿ššÛý¯Úùü¾úÚÜ°ðÚ\tÉ\0É©
Ð°\r\0\0\0\0\0\0\0\t\0\t\0šÐ °°ðÚ\0
\0 šÚ¼\n\n\nš\n\0°š\n
À
\nÀ
©ûý½ûù¹\r\t\0\0¹\tË™¿¹°ùÉ¯ÚýÿŸùëý¿ß»Ûß½»ß­¾Ÿ\nßéðð­\r \0\0\0\0\0\0\0\0\0\nÐ \n\0°  ¬°à©

\0 ð©\0°\0°
\n ð\0 °À°ðŸýûÿ¿ß\nš\0\0\tœ\t¹
­¼ð¿ž›ý¿Ÿ›ÏŸŸ›ßðüýéÞüðúÙéù¼½ðŸ\tÚ
\0\0\0\0\0\0\0\0\0\0\0\0\n°š\0š\t
\nšœ  \n
\0 \nš\n\0 \n\nšš\nš\n
éúÿÛËûÙ\tš\0›
Ù™›Û™ùðÛýûÏùïýïðÿÛûþ¿ŸŸëßËéàð¼­\0\0\0\0\0\0\0\0\0\0­­\0°Ê š\0\n\0\0\0\n\t\0°Êð°
\0 °š\n°\0 \t\0©\0šŸ¿¿¿ž¿
É\t\0\0™°°°Ù½«Ë›žŸ½¿Ÿ¿Ÿ¼ý½ðþÚðÞ¼ùýÿùùéé°°\0\0\0\0\0\0\0\0\0\0©
\0\n
\t©\n\0©\0 
\n\t¬°Ê¾\0 ©
\n\n\0°\0°\0  \n\n\n\r­ÿýùÿÛÐš\0š™¬\t™Û
ËÙ¹ùÉùûÛÛËùûúß­ëÚÚßÛý¿¹Ûü¾žžžžœ\r\0\0\0\0\0\0\0\0\0\0\t¯\t­\0\n\0©©\0©\t \t\n\n\0°\nÐš\t\0 ©©
\0š\0
\0°\t š›ûÛ«Û¿š\tž™½©©\t›
ËË›ùéúý¿ËÚÙùß½¿ÿ¿¾ÛÏÏïËéùéééÊš\0\0\0\0\0\0\0\0\0\0\0ÚÐ\0°©\nÊ\n\n\n\0  \t\n\nº\0\n
\t \0 \n\0\n\0\0 \0  ¼Ÿÿý¿Þ½°\t\0\t©\tŸ›\téù›ùé›Ý¹é¼½¯ž¼ŸËÛÞß­½¿¿ÚÞŸœ¹À\0\0\0\0\0\0\0\0\0\0\t©\0š\0\n\0 °\0\0©\0
\n Ë©\0\0 š

\t \0 \n\t\n\0\t
Ëÿž›ùûÿš\tŸšš\t\t\t
Ÿ›Ï¹ÿŸÛÛÚùûëŸí¿½ÿëÏëËß½­¼ºÊ\0\0\0\0\0\0\0\0\0\0\nžžšÉ©\0°\0\nš\n\0©\0\0  \0¼š\n\0 š\0 \0 ©\0\n\0
\0 ›Ûÿý¿½½­\t\0
\r¹ûš™½½\t­¹ï
Û­­ùÚßŸïŸÏß­½½½ûéêÛËÉœ\0\0\0\0\0\0\0\0\0\0\t\r\t \0°\0 \0° \0\t\nš\0© \0\t ð \0\n\n 
\0 \0\0  °
\0
\tžÿûÚ¿Úû™©\0™û\r°\t
\t©»ÛŸ›ÛËßŸ
ÿùíùï¿¯ßÞÚþžÛÝ¼¼ž\n\0\0\0\0\0\0\0\0\0\0\0\n
ÉË\0 \0\n\0©  \0\n\0\0š\n\0›\0°\0©
\0©
\n\0\0\0\0\0\n\0\n\t©ÿ¿ËÿúÚ™ ºŸ\0™ùÚÐžžœ½½©éÿûÿŸßÛúûý½ùí«ËÉ©À\0\0\0\0\0\0\0\0\0\0\t\tðº\0 šš\t  \0
\n\t\n\n\0\0\0é \0 \0\n\0©\n\0\t\n\t\n\n\n\t \0Ûýûý½ùý½­ž
Ý¹ù

™¹ù›ù¼¹ù½­½ùü¿ûëüýý¯ËïŸÞžžÚ\0\0\0\0\0\0\0\0\0\0 ŸÀ°\n\0\0\0\t\n\n\n\0\t \t\0 ° ¿
\n\0 \0
\n\t  \0\n\0\t\0\0 ¹ ¿ÿûÿ¾ŸúÚ¹ºž°°¯
¼©¼¼ûÛË¼ûÞŸßÛÛËùýÛééùé¬\n\0\0\0\0\0\0\0\0\0\0\t\té
Ê\n\n\n\n\0\0\n\0\0 ©\0\0\0à\0\t\0© \0š\t\0 \0\n\0   \t\0Éÿ½¼¿ý¿½½\té½û\t
š™œ¹\tºŸËÛ¼¼ûÏ½ûü¿¯þÿÏþ¾ŸŸšÐÐ\0\0\0\0\0\0\0\0\t\t¬ž¼ \0\0©\0\0\0 
\0\0 \0
\nš¹    \0\0°   
\n\0\0\0\0\n
\0ÿÿûÿðûËÛž›Ÿšœ½ž›Úž
ŸžÛÛýûÚüûßùùùðùýï­ùí ©\0\0\0\0\0\0\0\0\0\0©\0À°°\0\0 \0°\0\0\0 š\nš\0\0\0Ë\t\0\0\0 °\0\t\0\t\0\0š
\0°\n\t\0š¿½½¿ÿßš¼¹ééùé©
©\t­™©ððù¼½¯žý¿Þ½ÏïÿžŸœúÚžÙ\0\0\0\0\0\0\0\0\0\0\t
À°\0\n\0 \0 \0\n\0©\0\0\0\0°\n\0¼   \0\0 °©  \0\0\0\0\0 \n\t¬
ßÿëÚÛúýùðùûË™½Ÿ\t¾Ÿ
Ù¼½¾ŸëÚý¿ß¿Ÿý­ïðÿŸ­é¬°\t\0\0\0\0\0\0\0š\0¼ \0  š\0 \n\t\0\0\n\nš\n\0©\0Ú\0 \t \0\0\0\0  \n\n\0\t\0\n\t\0¿Ÿ½¿¿ÿÚ™©°ùùé
Ëé
É½
éðùý½ÿŸéúýüúß½ððß
É\0\0\0\0\0\0\0\0\0\0\0©\0š \0\n\0\0   \0\0\0\0\n°  \0  \n\n\nš\n\t\0\t\0° ©\0šÐÿÿËÛß¿ïÚÛ¿šÉ¹š™\tš½žŸžðÿéþßÚûßËúŸËð¼°\0\0\0\0\0\0\0\0\tÉ\nÐÊ\0  \0\nš\0\0 \0\0\t\n\n\nš\n\0Ï\t
\0\0\0\0\t\0\0  \n\n\0\0\0\0 \0\n½¿ùë¼ùûý­¹ÚùšÚÙ ž™½\nÛœù¿ùÿŸ¾ýü¿ùüýéü¼ÚÉé\0\0\0\0\0\0\0\0 \n©\té\0
\n\0\0\n\t\nš
\n\t\0\0\0\0°\n\0\n\nš\n
\n\0\0\0©\0
\nš\0\t©­\0¿ùÿŸÛÿðûÛË½¾›šÐ¹ É\0¹­«žßùÏïÛÚÛü¼¿ž¾ÛÛ­š\0\0\0\0\0\0\0\0\tËÀª\n
\0\t\n\n\t\n\0\0\0\0\n
\n\n\n\nË\0\0 \n\0\0\0\0\0\n \0© \0\0š\0\0\0\téûëü¿ŸÚÚûËùùé\t\tÉ°éÐÛœûžûû¾ÿ¿ËßùïÙðàÐ¬\t\0\0\0\0\0\t\0°°šÉ\t \n\0©\r\n\0\t °©  \t \0\0¼© \0°\0©\n
\0\0\t \0\n\nš\0 ©©À›ßßŸ©úûÿ½½½©
™ð°\0\t©°û\rðûÜüúßžÛÿëÏ½¯¬\0\0\0\0\0\0\t\n\tÀÚÉ\n\n\0°\n\n\0  \0\0\0\t\t \0°°°\0\0  \0©\n\0\0\0 \0\t \0 \0\n¿¿ûÛ¼½úÚûŸÚùé\0Û\t\0\t\0É\r°¿¿›ß©ùü½ßžÛÚÚË›\0\0\0\0\0\0\0Êš\t Ð¼\0 \n°©\t\nš
\n\n\n\nš\0\0Ë\n\0\0\n\0\0
\n
\0  \0  ©\0  \n\tËý­üûÉúý¿Ÿð¼ššŸ\0\0©\0\t°ÚÛÉùËÏ­ýï¯Þ¿í¼ùéðÀ\0\t\0\0\0\0\0\0°\0\0ž \nš   \n\0\0\0\t\0\0\0\n\n°\0\n\0\n\0© \0\0\t\0\0\n\0\t\0
\0 ©\0¿ÿ¿¿©ž½¿éþ›ý½­\0\0›\0°ž¼úÛÚÚùùëÚÛí¼½\n\0\0\0\0\t\t©\0©\n©
\0°\0\n\t\0œ°\t  °  °  °Ë\0\0š\0\0©\0\0
\n\n\0
\0
\n\n\0\0 \t\0ù\tÿýûÞùËËß›ý¹ë\n\0\t\0\0ÐËÉË¼½½žýïŸ\nÉÊ\t\0\0\0\n\0\0\tÀœ\nž\0°\nš\t\n\n\n\t \0\0\0\0\0\0 ¼\n\0\0\0 \n\n
\0\t\0\n\0
\0\0\t\0 \0 š\0à½ûËùúù¿¯ý¿ïœûÉ\0\0\0
\0
\t©œ¬­­¯ŸÚÙ©ðððÙ\n\0\0\0\0\0\tÉ\n©\téÊË\0  \0\t  \nš\n\n\nš\n\n\n\0\0š\n\0
\0\0\t\0\n\0 \n\0\n
\n\n©\0 ššÿý¿ý¾ŸÛËéùëšœ\0\t\0\0\0\0\0é™šÚÐð­¯ÞŸ\nÉ\0\0\0\0\0\0š\0°\0¼¼©\0 \0© \t\0°\0\t\0\0\0\t\0\0š\nà\0\0\n\0\0©  ©\n\0 \0\0©\0\0\0\0\0\n\t \tßûëÚýü¿ÿŸ¿½\t\n\0\0\t\0¬¬ššÛÉ
žŸ\0\0\0\0\t\t\t\t\0›\r\t\0\nš\n\0\0\n\n\0\n\n\n
\n\0 \n\0  \0 \0\0\0\0\0\0°©\0  °  \0\0
\0»ßý½¿¿ý¿ÿËÚ°¼\t\0\0\0\0\0\0\0\0\t\t
ËÉÉ\0žœ\t\0à\0\0\0\0\0\0\nÊž\n°ð¼\n\n\0\0\0
\0\n\t\0\t\0\t \n\0 é\0\0 \0\t ©©    \0\n\0\t\0\0\t\0°\n\0°ËûßëÞÛëðûÿýù
\0°\t\0\t\0\0\0\0\0\0\0\n\0ð\t©àðé\t\0\0\0\0\0
\t\t\t°ðù\0\0\0\n\0© š\0   
\n\n\0\0\0 \0¼©\0\0© \0\0\0\0\0 \0
\n
\n\n\n\0©\n\0\0ÿûß¿½ÿßÿùûéé\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0À¼°\té\t\0ðð\0©\0\0\0 \0\t\0 \0 \0\n\n\n\n\t Ë\0  \0\0
\n\n\n\n\n\n\t\n\0\0\0\0\0\0\0\0\nšŸ¿ûËÏŸÿŸÿŸ™à\t\t \0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\n\t›\tž¼¯\t\0 \0\n\0 \0\n\n\n\t
\0° ©\0\0\0\0\0°\0\0\0\n\0\0\0\t\0\n\t  °\n\n
\n\0\n\t\0ýÿÿûé¿ÿûËûË\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0œš\0\0©©­
Ù¬\0\n\t\0\0\0\t\0\t   \0\t\0© \t  Ë  \n\n\t °    ©\0 \t\0\n\0\0\t\n\n\n\t\t¯½ûßþÚÿÿÿß¼¼°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\téÉÉÀšÐ¬
\0\n\0\0 š
\n\n\n\t\0š
\n\0\0\t \0¼\t\0\0\0\0\0\0\t\t\0\0é\0  \0\n\t \0 \n\0\0šŸÿ¿ûÛÛÛÿÛëÛœ\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\nšºš¹éëÚœ\n\0 \0\0\0\0\t\0\n\n\0\0\0
\n\n\0  É\n\0 \n\n\0 °  ©\nš
\0\t  \n\0 \0\0\t\n\0\t½ý¿ÿü¼¿ÿßûËÊ\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0š\tÉ
ÉÚÜ°
\0\0 \0 \0\n\0 °\t\0°© \0\0\0\0º\0©\n\0\0\t\0\tÀ\0\n\0\0© \0\t\0\t\n\nš\n\0
\núÿü¿ûÿÛÿ¿›\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð°ðù¾½»
\0\0°\0\n\0\n\n\t\0\0\0  \0\0\0°©   Ë\0\0\t\n\t  \n

\0© °\0\nš\n\n\n\t\0\0\0
\0\t Ÿ¿¿ÚßûïßÿûÉð\0©\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0Ú›ÏŸÉéðÀž°\0\n\0©\0\0\n\n \0\0©  \0\0\0\0\0¼
\n\n\0\0\0\t \0\0\t\0\0\0 ð\0\0\t\0\n\n\nš\0\n\0
Àýÿ¿¿ßûÿùÿ¿\tð\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0žð½þ¹éð¾›Ê¹éÊ\n\0\0 \0\0\0\t 
\0\t\0° © Ë\0\0\0\t ©\nÉ    \nš\0 °  °\t\0\0\n\t\n
šÿýí¿ÿÿÿðü¿\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0©žÛéùü
Üð©\0\nš\0\0  \0  \t \n\n\n\0\t\0\0 ° \n \0\n\t \t\0\n\0© \t\0\0\0\n\n\n\n\0 °é¯ÿûéÿûÿÿÛÉ­\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ÚûÞÿ­ùï
Ðú\nš\0\0\n\0\0\t \0\0 \0\0\t\n\n\0 \0é
\0 \n\t\0 \n\n\n\0\n\0\0\n\n\n\nš
\0\t\0\n\0\0\0\t\t¿ýûÉïßÿ¾½°ð©\0\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0«Ï¹ùúÿžÚÿ\0\0\0 \n\0š\0\0\0 \0  \n\n\t\0 \t ž\0\0\0\n\0°\t\0\n\n\0š\n\t\0\0\0\n\0 ©\nš\t  àÛÿü¿Ÿ¿ÿýúÛ\tÀ\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÛÉß½ïïýðÿ¿Ú\0© \0\t\n\0\n\n\0\n\0\0 \0\n\0 \0é\n
\n\n\0\n\n\0\n\n\0\0š\0\n\n\n\n\n\n\t\n\t\0\0\0\0\0\t

Ûÿü¼ÿÿÿ¿ÚÞš\0\0\0\0\0\0\0\0\0\0\0\0\t\0\t\0°¿ëËÿŸž¿ùíàË\0\t \n\n\0\0\0\0\n\0 
\0 \n\0\0  š\0\0\0\0\n\0
\0\0
\n\0\0\n\0\t\0\0\n\t\n\n\n\0\n\t\nðþŸ¿ß­¿þÞ¿›ÉÊ\0\0\0\0\0\0\0\0\0\0\0\0\0¼ËßÿþÿÚÞúû\0\0 \n\0\0\0 © \0\0\0\0 \0 \t °\n\0\0é©  \n\0 °\0\n\t\0\0\n\t    ° \0 \0\0
\0\n\0 š›þÞùÿËß½üð°\0\0\0\0\0\0\0\0\0\0\0\0\t \n\0

Þ¼¿ùÿžÿðÀð°\0\0\n\0©\0\0\0° š\0\t 
\0\0\0\0  ¼\0\0\0\0\0¼©\n\0
\0\n\0\0\t\0\0\0°\0©  \0\0 \0\0 œ©ûÿéÿÿÿ¿ŸËËÉ\0\0\0\0\0\0\t\0\0\t\0\t\t\t\r­«ÛýþùÿÚ\tàº\0\0© \0\0\n\0\0\0\0\0\n\0\0\0\n\0\n\t\0\0Ë\0  ° \n\n\0\0\0\n\0
\0\n\t    š\0
\0\0\0 ©\0š
\t ŸýÿÿéïþÞúŸ\0š\0\t\0\0\0\0\0\0\0\r Ð\0\0\nÐ½ïž¿žù Ú\tÉ\n\n\0\t \n\n\0\n\0 \n\n\t\0  \0
\0\n\t ° \0\0\nš\n\n\t \0\n \0\t\0š\0\n\0\n\n\0\n\n\0\0\0
\0
ÿÿÿŸŸùýðÛ\r©\0\0\t\t\t\0\0\0\t š\nžžËÚýðùàú\0\n\n\0\0 \n\0\0\n \0\0  \t\nš\0
\0\0\0ðš\nš\0\0  \0\0\0
\n\0\0\0©  \0\n°\t\n\0\0\0 \n\n\0
\0\tùÿïÿÿûï­éœ°°œ\0\0©\t\0Ÿ\t\r\0\t®¹ð½¯¿Ëù\té©\n\n\0\0\n\t\0\0\0© \0\0\n\0\0\0 \0\n\n\0ž\0\0\0
\0\0\t  ° \0\0š\nš\0\0\0© \n\0   \n\t\0\0\0\n\0
ÏÿÿÿÿýùûšË\r\r °àšðð½¬™Ï­þÛËðÊÀ\n\0\0 \0\n
\0\n\0\n\t\0\0 \0\0\n\n\0 \0\0é\n  \n
\nÀ\0\0   \0\0\0© \0\t š\0\0\0\n\n\t š\0\0©\0ûÿßÿ¾ÿÿííûÚš\t\r\nÚ™ð½ï
Ê½¾úß©¼¼¼°\t
\n\n\0\0\n\n\0\n\0\n\0 \0°
\0\t\0 \0 \n\nš \t\0\t\0\0°°  \t\t\0° °\0\t   ° \t \0\0\0\0\0©\0\0\0Ÿ¾ÿßÿÿÿûÛí½žšùœ¾ŸË¹ùý½Úý¼¼ýéééà\0  \0
\0
\n\0\0\0\0š\0\0\t \n\0\0\0 \0 š\0\0à 
\n\n\n\n\0\0\0   \0\n\n\0\t\n\0\0\0 \nš\0 \n\0 \0\n \0ûßÿúÿÿÿí¾¿­ùþ¹Û
ßÏ
úý¯ÛÛà¼½¬ž\0
\n\0\n\0\0š\0 °\0\0\n\0\0\0\0  \n\0\0\n\0ÛÉ \0\0\nš\n\nš\0\0  \0\n\n\t\nšÚš\0\0\0\t\0\0\n\0 ©\0\0\tëÿÿÿÛÿÿýüûïéþ¼ÿ¯¿ÿÿÏšý¯í¿ËÊ\t 
\n\0\t\n\n\0\0\t\0\0\0 ©\n\0  \t\0\t\0  \t\0 \nÀ°   ­ \0\0šš\n\0° ©\0\0 \0\0\0
\0\n\n\t \0\0\0\n\0\0\0\tÿÿÿïÿÿ¿ÿ¿ÛÛÛÛùÿßùéûïÚÿü°ðÚÀ\0\0  \0°\n\n\n\0  \0\0\0\t\0\0 \n\n\0\0\n\nÛ\0°\0\0\t\0 ©  \t\0\t \0\t\0 °
\n
\n\0\n\t\0\0\0©\n\0\n\0 \0\0\týÿÿÿÏü½ÿÿþþÿÿÿ¾ÿÿí½­¼ÿ
À\0\0\0°  \0\0 \0\0\0\0\0\0\0   \0 
\0\0\0š\0\0¬°\n\n\n\n\n

\t\nÉ\n\n \0 \n\0\n\0\t\0\r\n\0\n\0 \t\0\0\n\0 \0\0\0\0\nùÿÿÿÿÿÿÿùùÿÿÿý¿Ÿÿïþÿ¼\0\0°\0\0©\0š\0 ©\n
\0š\n\0\0\0\0 \0\0\n\0š\0\n\0ù\n\t\t\0\0\t\0\0\n\0š\t\0\n\0°\t š\n\0š\0  ©\n\0\t\0 \n\0\0\0\n\0°\n\0\0\t\0ùÿÿÿÿéðÿÿÿúß¿þÿÿßÿ
ùð\0 ©\0  ©\0 \0\n\0\0\0\0\n\0\0
\0 \0° \0š\0\n\t\0 é\0 ©©\n\n
\0 \0 ©\n\0\n\0 \0š\0\n\t\t\0©\0  \0\0\n\0\n\t\0\0\0
É¿ÿÿÿÿÿÿÿßÿÿÿÿÞ¿Àž°\t\0\n\0\0\n\0 \0  \n\0\0\n\0\0 \t\n\0\n\0\n\t\n\nù \0\0\n\0\t\0  \t©\t\n\n\0\0\t\n\0\n\t\0  \0©\0\t\n\0\t\n\0 \0   \t \0¿ËËùÿÿÿÿÿÿÿÏýþ©ðð\tý°\n\n\nš\n\0\t\n\n\0\0\0\0 \0 \0\n\0\n\n\n\n\0\0Ê°
\t \0
\0 
\0\n\0 \t©  \0\n  \0Ë\0\0 \n\0
\0\0\0 \0\n\0\0°\t\nÐüÿÿýíÿÿûÛÿþŸÞÊ\0¾ß\0\0\0 \0\0
\n\0\0  
\0©\0 \0\0\n\0\n\0 \0 \0\n½\n\0\n\t© 
\t  
\t­©\t \0\t\0©\0\0\0\t© © \0\0\0 \n\0 \0\0\n\t\0\n\0°­


Ê¿ÿïïËÉà
Ë\tËËúÚš\0°   \0
\0\0\0\0\0\0\0 š\t\n\0\nš\0°\0° \nÀ  \n\0\0°\n°úÚž\n\0\n\0 \0  ° \0\0\0\0š\0 \0\0\0\0©\n\0\n
\0\n\n\0¬½ûË\0ž¼¼\0¼ž°½­ \0\n\n\0\0\0
\0\n\n\n\0 \n\n\0\0\0\0\0­\0š\0\n\0\t »\0 ššËé©¯Ÿÿðœ
\t \t \t\0\0š\nšÚ\n\0\0\0°© \0\0
\0\0\n\0\0 ¬°\0\0\0\0\0\0\0\0\0ð\0©\t\nËÚš\n\0\n\nšš\0©é\0\0\0\0\0\0
\0 \0 \nš
à¾\0 \0Ï\t\n\0 ©½¼°Ûÿÿÿÿ© ¬\t \0   \0à\0 \n\0 \0\0
\n\n\0
\0\t\n\0°\n\n\0\0\0\0\0\0\0\0\0 
Ë\n\n\t ¬\0\t  \0\0\0°\nž°°©\n\t\0\0\0 \t \0½Ëéé\nš\n\t šÛÿÿÿÿÿÿÏ\tË\n\0©\0\t\0  \t   \n\0  \0\0\0 \n\n\0\n\0\t\nšš\0\0\0\n\t\0°œ°\0\t\0š\t

\0\0\0 š\n\0\0°ùð\0\0 \n\n\0 \0\0\n\r ¿Ëÿ\n\0\néé\0©\n\t­ÿü½¿ÿÿÿÿúžº\r©\0© ©\0\t\n\tÀ\n\t\0\t\0 \0  \0\0\0\0\0\0 \n\0\0\0\n
\t\0\0 \0\n\n
\n\n\0\0 \0\n\0 \0 \t\nšß¿\n\0\0\0\0\0\0\n š½ü¿ýÿ­© °\0©\n\tÊš½ûðûÿÿÿÿ½ùýú\0 \0\0\n
\n\0\n
\0\n\n\n\0©\0°\0
\0š\0©  \n\0© \n\t\0\0 °\t­©\t\0\0\t °
\n\0\t\0°\0\n\0\t©ü°\n\0 \0\n\0\0¬ž¿ÿÿýðà\0Û©\n °\r¯¼»íûûÿýûÿÿý­\n©\0\0\0š\0©\0\0\0 \0 \n\0\0\n\0\t\0\0\0\t\0\n   \0\n\n\0\n\n\n\n\0\0\n\0\0
\n\0\0©\0\n\nž›Ê\0\0\0\0\n\0\0 \n\0š¹éýÿÿÿŸ\0¼\0©éË\0°Ÿ›ýéûëýÿÿžš\0\n\0© ° \n

\n\t \0\0
\0\0\0 \0\0 \t  \0\0\t\t ðš\0\t\n\0\0š
\0\0\n\0\0 \0ÚÚ\t\n\t \n\0\n\0\0\n\0Ÿÿÿÿðà Êž°°

ððÛ¾š›ŸŸ¿ÿí 
\t
\0\0\0\0°\0\0\0\0 \0\nš\0\n\0 \0  \0 \0\0  °\n\n\t\0  \n\0 \n\0\nš\0\0\0
\0š\n\0 © °ð \0\t\0\0 \0\0\n\t\0ùÿÿÿûÎ¹©¯\t¬žŸûï\r­­ùë
ßýºÚ\0 ¬  °°\0  °  \0
\0\0\0\0\t\0\0\0\0\n\0\0\0\0\0  \0\0\0\0\0
\0\0  \n\0\n\0\0\0\0ŸÿŸ\0\n\0 \0\0 š\0\n
\n¿ßÿí°  Ï\t\nàš›ÿÿŸûÛûûÚÚ
¾Û\0š
ËÀ\0\t\0š\0\n\0   \0 °\0©\n\0 ©\0\n
\t\t

\0   °\0\n\0\t\n \0\n\0 © ©ÿéé\0\0\0 \0\0\0\t\0\0¼›ÿÿÚÉ\0\0ºšùë ÿÿÿÿ­ýÿË
ßÛðé \n\n\n\nÚ¼°© °   \n\t\0\0\0\n\0\0\n\0 \0\0 °\0\n\n\0\0\n\0\0\0 ©\n\0\0\0\t\n\0\0\0\t¿ÿÿ\n\0 \0\0©\n\0  ©
íþý °© ¯°ÊŸ¿ÿÿÚŸŸ¿ý¾Ÿ¿ÿü°\0©éÉ­«ß¾ž\0\0\0\0\n\n\0 \n\0\0\n\0\0\0\n\0 \0\0\n\0\0\0 \0\0\n \0\t\n\0 \n\t\0\n\0 
íùð\0\0\n\0\0\0\0\0ëÛùú\0\0\0ë\tëË\t©ÿÿÿÿ\nŸÿÿùÿÿÿûÀ°º¾›ßÿß\t
\n\n
\n\n\0\0\0\t\0š\0°\nš\0\0
\n©\0°
\n\n\0 \n\n\n\n\0 š\0 \n\0°
\0›¾\0© \0\0\n\0 š\0š\nëÏ\r   \0ž¹
ž\nšßÿÿ\r¼©ÿÿÿÿÿÿß¼\0¬½ÿÿÿþú\0\t\0\0\0\t\n \n\0 \0\0\0\0\0\t \n\0\0\0\0 \0\0\t\0\0\t\t\0\t\0\0\0\0\0\0\n\t©\0\0\n\0\0\0\0\0\n\0©\0°  ùž\t©Ë¿ÿûú\t¿ÿÿÿÿÿÿÿ


¿ÿÿÿÿÿœ° © °  \n\0 \n\0 \n\0 \n\n\0 \n\0 \n\0                   °šš\0 \n\0\n\0 \n\0 \n\nš
\nš\n\n\n\0°© š\0¹ÿÿÿ\0
ÿÿÿÿÿÿÿž\0½ÿÿÿÿÿÿ\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0´­þ','Education includes a BA in psychology from Colorado State University in 1970.  She also completed \"The Art of the Cold Call.\"  Nancy is a member of Toastmasters International.',2,'http://accweb/emmployees/davolio.bmp'),
  (2,'Fuller','Andrew','Vice President, Sales','Dr.','1952-02-19','1992-08-14','908 W. Capital Way','Tacoma','WA','98401','USA','(206) 555-9482','3457','/\0\0\0\0\r\0\0\0!\0ÿÿÿÿBitmap Image\0Paint.Picture\0\0\0\0\0\0 \0\0\0PBrush\0\0\0\0\0\0\0\0\0 T\0\0BM T\0\0\0\0\0\0v\0\0\0(\0\0\0À\0\0\0ß\0\0\0\0\0\0\0\0\0 S\0\0Î\0\0Ø\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0€\0\0€\0\0\0€€\0€\0\0\0€\0€\0€€\0\0ÀÀÀ\0€€€\0\0\0ÿ\0\0ÿ\0\0\0ÿÿ\0ÿ\0\0\0ÿ\0ÿ\0ÿÿ\0\0ÿÿÿ\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿà\0\0\0¿à\0\0\n\0ÿÿÿÿÿÏÿÿÿÀ\tÿÀ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ŸÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÛ\tð\0\0\0Ëÿéà¿ÿÿÿÿðÿÿÿÀŸÿà\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿà\0\0\tðŸü
ÿÿÿÿÿÿÿÿþÿü\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
\0\0ð\0\0\0¿ÿÿÿÿÿßÿÿðùþ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿàŸÿÀ©ð\0À
ÿÿÿÿÿþ¿ÿüÿïÀ\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\tËàœ\0\0\0\0¿ÿÿÿÿÿÿßÿËü\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿü\0\tÿ
úŸ\n›ÿÿÿÿÿÿþÿÿÿÀ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\0ŸËÀßÿýÿÿÿÿÿÿÿÿŸÀ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\nð\0\0\0\0
ÿÿÿÿÿÿÿþþ\0\0\0\0\0\0\0\0\0\r\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿéü\0¿\0¿ÿÿÿÿÿÿÿýü\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÐž¿É­¯ÿÿÿÿÿÿÿÿÿà\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\0\0\0\0\tÿÿÿÿÿÿÿÿÿü\0\0\0\0\0\0\0\0œ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð¿Ûÿÿÿÿÿÿÿÿÿÿÿð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿŸŸÛŸÿÿÿÿÿÿÿÿÿÿÿà\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿßÛÿûÿùŸÿÿÿÿÿÿÿÿÿÿÀ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ŸÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÛ¿ÿŸß½ÿù¿ÿÿÿÿÿÿÿÿÿ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿùûÿß½ÿ¿ÿ¿ÿùÿÿÿÿÿÿÿÿÿ\0\0\0\0\0\0\0\0\0\0\0\0\0 \0œ°Úššùé¾\n\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿùÿÿÿ¿ûûýûÿÿù¿ÿÿÿÿÿÿÿþ\0\0\0\0\0\0\0\0œ©\nð½©­©ÿŸž›Ù°ÉÀð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿùÿÿ½ÿùýŸûÿÿùÿÿÿÿÿÿÿü\0\0\0\0\0\0\r­©ž\tË›ËÚÙù½°¼¹­¯ËšŸð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿýûÿ¿ŸûÚŸ\nÐ° ¹¿ÿ¿ÿÿÿÿÿÿþ\t\0\0\0\tË
›Ú™ù½°ù°¹«šß›ÚÛ™¼½©ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ÿÿÿÿÿÿÿÿÿÿÿÿý¿¿Ûüððýü½­\rŸ
ïß¿ÿÿÿÿÿÿÿü\0\0\0\0\0\tËÏ
Ë
ÛžŸž¹é°ð½°þ›šÛð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿ÿÿÿÿÿÿÿÿÿÿÿý¿ÿùÿŸûË
Ðù©à\r\t
ß¿ÿÿÿÿÿÿü\0\0\0
Ÿ¹¹½¹ù½©é¹éšžšß™ù­¹Ÿžð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tÿÿÿÿÿÿÿÿÿÿÿûÛÛÚÞ­½©ÉùðûÚÚ°ðùéÛÿùÿÿÿÿþ\0\0\0°©ËÏ\té©éù½šÛÛŸšžšÚÛéðùð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÿÿÿÿÿÿÿÿÿûéûûéý½¼¼¿¼žŸž\r½ Û\tàžœ¹ÿÿÿÿÿü\0\0\0©û™¹ðŸŸ›
™é­­©éùù¹­š›ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿ÿÿÿÿÿÿÿÿßŸß¼ßÚÚž¹ÉËûËý¿Ÿ¼ž™é­ÿùÿÿÿþ\0\0ÀÛÛ\r­
É¼¼ù¼¼›Û›ÛŸ
›ééùð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tÿÿÿÿÿÿÿÿÛ»ÿ¹Ï°¼°ðŸÞŸ©\r¹ËÐùéËùžù©
ÿŸÿÿü\0\0
ššÛ›ð½»Ë››ËÛ½©í©é¹ùð¼›Ÿšð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ÿÿÿÿÿÿÿùù½ü°Ü°ÛÉÛÛð©éŸðü°ûžŸ¼ž°ðžÛÏ›ù¿ÿð\0œ½½°ð›Ë\r½­­¹©ËÛ›Ÿžžš›Ûü°ùùððÐ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÿÿÿÿÿÿÙ¿ŸûŸË
Ë\r¾žÛÛž\tË\t­\r½©ÛÙÉž™é°ðÿÿÿü\n›ËËËŸ
°°ù¹éÛ›\r©ùùùé©¹Ûùù›¿™\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÿÿÿÿÿ°¿ðûÍ­¼ž›Ë\r\t¯\tàÙù©ðÚž\tÐ 
ËÚŸ¹ÿð\0\tËÛŸ›Ëß
Ÿü¼°ðù¿Ÿ
ËŸŸž°ùû
Úý¼ù­\t ËË\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿ÿÿÿÿ
ÙÿŸœšÚ\tðœœ°¿Ðž™úšÙéùùŸŸ™½›ÐÿŸžŸÿð\t­©°ð¼¹°°ùé¯››Ÿ
ù
Ÿ›Û
ËË°ùð½š›ðÛŸð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tÿÿÿûÉùïŸ
É©Ú™é©ËÐ¿Ùé\rý©ù¼¼¼½¼¾Ûíù¿™ðùé¿ü\0\0œŸ›ÛžŸ
ŸùééðÛ¼ð¼¼Ÿ›üšŸ¼½«ÛÉ¹ë›­¿©¯\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÿÿþ½­¿žÐ¼žé½
©ÿ¹©ùéùùùðÛÛËŸ¾žð¿žžŸð\t\t

Ë\r›Ë©¼°ù¼¹šŸ
Ð›Ÿ››©é›é©ÿ­°Û­›ÉÛÙÀ\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÿÿý\t½ûŸ
Éé©É©œ°½©ùß\týŸÚÛËÛÞ›ûß½ËÙÛŸßûýŸà\0à\0Ð¹û­½ÚÛŸ
ËÚÙð¼¿¼¹ééÛŸ­›Ûù©ú¹\r©ð¹­¹¾š¼\0\0\0\0\0\0\0\0\0\0\0\0\0
ÿÿË›Ï°ý\r\nœ°œ¹ËÛËßž½¿
é½½¿ž›ÿÐûß¿°ÛðÿÛé\0\t\t

\r°Ù©©žÚÙ½©º¹ù¹ËžŸŸ
ËÛ­©ùÚž›ž›Éúž™ùËÀ\0\0\0\0\0\0\0\0\0\0\0\0Ÿÿé­°ß

Ð
©À¹Û\r½©ùŸÿÛÛÿßùý½¿Ÿ¿ÛÿŸ¼¿Ÿ¯Ÿ¼\0\nÀšÛ
ÛÚÛ›
ÚÙÏ
Ï½ù°°ù½­›Úú½«Ù­¹é¼Ÿ™é¯™°\0\0\0\0\0\0\0\0\0\0\0\0ÿùž½½û\téÀ\tüÛÛ\rºÛÐ¿ùùŸ¿ý¹¹ÿ½ûÛùùý½ý½ßýÿ¯Ûð\t\0\t©ð¼¹­­¹ð½«›ÛŸ
ÛÛ
ËšÐ½ùÚ«Ð½½
ž›Ù­\0\0\0\0\0\0\0\0\0\0\0
ÿ\téšÛ\r°\0š™ð\t½¼°ù©Í¼¿Ûßù½¿ßÿùÿ½ÿßÿ¿ÿ¿û©ûùùü¼\0š\tœ›Ûœ¹ùËŸ­­©ùù­­½¿
Ë½©ú
Ëš¹ù©¼¾›ù°\0\0\0\0\0\0\0\0\0\0ŸàŸ­šÚ\r\rž\tÿ
Ÿžº½¹ëý¿ßý¿ŸŸÿŸ¿¿Ÿý½ÿŸß½ÿÚûû\0\0\0\t\t­©Ë¼°»ËËë›ÛŸžšÛ›É©ù½¹ÛÚºù¼½\r©ðÛ™é\r\0\0\0\0\0\0\0\0\0\0ÿ™¼°ðé\r °©Û\tùýééÚëÚßý¿ÛûûÿÿÿŸÿÿß½ûÿŸÿùÿ½¿ÛÏð\tË\0¬™ûœ›ÛÉù¹ü°ðù½°ð›ß
É­ü¹éÙ›Ú›ÚŸ\r©ž¹¼°\0\0\0\0\0\0\0\0
ð\r°Û›\0¼
ËÚš›žšŸ¿ŸŸ¹ûÛýýýÿŸÿÿÿßÿÿß¿ûÛûý¾ûÿ½Ÿ\0\0\t\0¬Ÿ«É­°¼ž››ÛŸŸ©©ù¿šûž›ëÐ½­¼¹ð¹ðùž›ß\0\0\0\0\0\0\0\0À½ÐÐ\r\t©ù½­½ðùùðÐùûßýùÿ¿¿¿ÿùÿŸûýÿ¿ßýÿÿÿùý½ûëð\t\t\t°Ù¹ù›ð¼¼°ù½¹é½Ÿ\téùéž™
ÚÛ
ž™½­¹éŸ
\0\0\0\0\0\0\0\0¿
Ú™­ °šŸ\téûËŸœ¼Ÿ¿Ÿ½ûÚ½¿ßýýùÿ¿ÿÿûùÿÿ¿¿ßý¿ûþ¿ýð\0
\0©­ºžž›\tÛÛŸšÚž›Ú›ÚÛžŸÛù¼¼½°ÚÛËË™ž©ùð\0\0\0\0\0\0\0ü\r­¼\tÉàùËŸŸŸ\tý­¿Ÿ½½ÿž½¿ÛÛÿŸ¿ÿÿßŸŸßÿÿ¿ßÿ¿ûÿý½ùúÿ\0\0œš½¹éùù©¼ðý¹ùð½¼¹ðù°¾Û
\t
Û°½½¯š™Úž¼\0\0\0\0\0
ü\tÐšÐÚ\0™ ¼°ðùù½ùËùéðŸùÿŸ½½¿ùýùùÿûÿ½ûßÿûßÿÿý¿ûß½½ð\0\té©éšžŸž››
ÏŸš›Ú›Ÿù°ù½
Û
ÛÐšÙéð¹ù™¬\0\0\0\0\0àš›É
\0ðÙÛÛÛÛüû¹¹É½¿ùý½½½½ù½¿¿ÿùý½ÿ¿ûßŸûÛûßÿßûßûþ\0°šœÛŸ\r½°¹ððù¹½©éð½¼¹éû›À¼°ù¼½©¿š›žšÚÛ\0\0\0\0\0ÿ\r©ð\0Éé­¹ë½¯›¿Ïü»ÚÛÛËŸŸÛÚŸÛùÿÛŸûÛûý¿ûÿ¿ÿßûûû½¿ùÿ\0\0\0
ºÚÛ
žŸŸ›ËËŸŸ
ÛËž›ß™­½\t½¼»ÛÚÐ½›Û\t
Ð\0\0\0\0ÿðœž\té°Ÿ\t¯™ðùùýÛÛ›ßÛß½½ûÚß›ÛŸŸŸ½ûßý¿Ûß½½ý¿ûÿßýÿðÿ½ð\0\r\0¹©ùðùù©­½°ððž›ü¹¼¼ùÚšœ½¹Ð°½½«ÐûÉ­½¼¹\0\0\0\0Ÿü›\t\0\0\tùÛéùÿŸ«Û¼ÿ›é¼ŸûÛÙ°ý­½½ùÿŸ½¿ß¿½ÿûûûÿûûûùÿŸûÿ\t\n\té©éÐ¼¹
ŸŸŸ›Ÿ¹é½¼»ûš½©
Ë
ÛÚ›Ð¹›Û
\tðà\0\0\0
Ê\tðÉ\r\t¼ŸŸ
ýß¿É›í¿ÛùÙëûÛŸ›ÛÛŸùýûÛûßÿ½½ýýùÿÿßŸ¹ÿß\0\t\0\0ŸŸ
ÛžŸ›ËË¹é­©ŸšÛÐùéúÚœ½½¼½
ž›Ûé¯žœŸ°\0\0\0\0\tŸ\0°°¾›ÛÉð¿Ÿ
»ß›ÿÛÛŸŸ»ùÉùùŸÐ½ûŸûÿÿýùûß¿ûûÿÿŸ¿ÿŸùûûÀ\0\r\té°½©éÚž››Ï™ùùù­­¾Ÿù°™½
žš™©ðÛÉ©Ÿù°©ËÀ\0\0\0\0°°\0ÛÉËÉ¿¿ÉùÿÝùÿ›¿½ûùýŸ¿ŸŸû½¹™ùùùù¿¿Û¿Ûßÿÿÿÿûÿÿ¿ÿÿð\t  œ½
Ÿš›Û\r­¹¯
Ë›ù½©þÛËËÐ›ÛËÚŸ
žžù­›™¼\0\0\0šÙÀÚ\t¿™¿ÛÙûÿ›û¿Ÿýý¿ŸŸ¿½½¹ùýŸŸùùùÛßÙùýûÿûÛÿŸ¿ßÛÿÛ¿Ûÿ\0\t©ëÐðù­­¹ùéÛÛžšÛ
ÚÛ¹ù©é¼šŸ½©›Û
Û
­¯\t¬\0\0\0\tš\t\tÚÐðù¼¿½­ÿŸÛûÛûÛÿùýûÛÿŸ›ùðŸž½¹ÿŸûÿûÿÿÛÿÿ¿¿Ÿ¿ß¿ÿ\0\t™©½°ÛÛ
Ÿ©­¹ù½¹ùéûËžšœ¹é¹Û
ÚŸ¼°œ°ðÙùž\0\0\0œ¼

ŸŸÚßŸÛÛùý¿½½ýÿù›Û½½ùûÿÙùùùùŸŸù¿½½ÿ¿¿ÿûÛßùÿýûßÿ\0
\0°úÐð¼ºšÛÛËÛÛ›ùž™½©Ÿžž°ðŸŸž›Û™«œ¹ù\t\0\0
œ™¼šŸ½»Ûù¿ŸûýÿûûŸŸÿ½ûÿ¿ŸŸ¿ÛÛÛùùûýÿÿ½ÿßûßÿùûÛûÿÿŸð\0\0É\t»Ÿ›Ùý©­¹½©ù¹½¹ð¼¾™ééž
›Ùù½©û
™é­­œ»Ë\n\0œ¼©¬ŸÐðß¿ßŸù½ÿŸŸý¿ùùûý½¿ÿùû½½½™½¼¿Ÿ¿ÿûûßûÛûÿÿßÿûÿû\tÉ\nÐÐðð°¹ùùéëÛ›ËŸ›ý¼››É½­©©éŸ\r½é›Û›
œ¹ùùË›Ù¹ð»Ûùùûûßûûûûßù¿ÿŸÛûý¿ŸýûÚÛÉË›ûÛýÿÿ¿ÿ¿¿ûßß¿ûùÿÿ¼\0 \t

ŸžŸžšžŸÛÛÐ¼½©éû\t¾ž›ÚÛŸŸ™ë›ð¹­­ ÛËžš°À½ žšÚÛßÛÛÿ½Ÿÿ½½½ý¿Ÿý¹ý¿ŸÛý¿Ÿ½½¿¹ý½½ûÿ¿ßŸßß½ûûý½ÿÿùÿ\0¼›Ë\t¹é½½¹©ù©«ÛÚŸŸùÚÙùÚ¼šÛËœ¼›ÚÛÛÙ©½
ÛÛÛÚÐ\tùùð¹ú½ûý½ÿÿÿûý½¿ÛûßûÿÛß¿ÿ½½½ŸÛÛÛý½ÿûÿ¿½ûÿÿÿÿ¿ûÿÿ\0\0à
ŸŸŸ
ËŸŸ¼¹ð°ÿ©©º©»Ù©¼¹ûÚ™©©­œ¹ð¼°¼°™\r©ËŸÚß¿Ûß¿ûÛÿ¿ß¿¿›ÿŸ¹ý½¿½½½™ùÛÛÛÙý›ûÿÿŸÛÿ½½½¿¿ß½ûÿð\t\t\tÉ©é°ùù½°ùððð»ËŸÛðŸŸÉÚŸ\r©ÛËž½¼½š›ž™ùŸ™\0¾šœ½¹é¿¿ÛÿûßŸ¿ùÿ¿ÿßûÙûßŸ¿ùûÛŸÿÿÿùùû›ýÿÿûÿ¿Ûßÿÿÿÿûÿÿûð\0\nÉ©ù¹ËžžšÛž¹û›ß½©­ùðš›©ûÛž°¹Ë›ËË›é©ËÉ¿
ððùÉ›œ½ŸÙÙ¿ÛŸûÿßÿÿÿ½»¿½û¿ÛŸ\rùý¿ý½ý¿ÿÛÿùÿù½¿ÿ¿Ÿùÿ¿ÿÿÿð\0œ¼¼¹ùù½°ùŸ\téé
ÛÛû\r½¼œ½­©ÛÉ½éù½­›Ú™¿\tð›\t\t¼¹¬¹úù¿¿Ûÿùý¿¿¿¿½ÿýûßŸŸÙðÙ¹ý›ÛŸ›ùýûÛÿÿþ™ÿý¿¿ßÿÿýÿûùÿù\0À ¹½©ËžšÚÛÛé¿Ÿ›ü¼°¼ºšÛ››ÚŸž›šž›Úð­ðŸ\r½\tð\r›Ë¼ùûùùß»ßÿßýûûÿ½»ùûð›Ÿ›Ùý½ý½¿Ÿýÿÿù\0Ÿ›Ùû¿¿¿¿ÿÿÿ½þ\t©
Ûž›ÛŸ
Ÿ
Ë›ÛÛß½¼­¹þ™ð¹ž¹ð¹Ÿ°››Ú›
°š\r½»ÛžŸùÿ¹ýûùûÛÿýûÛßÛÙÛÙË™½¿›ÛŸÛ½›Ù\0\t\t­¿ýýÿÿ¿Ÿÿÿ¿\0\0\t\t½©é¼¼ðùù­¹ù½é©­úšÚÛ›Ÿ\tž›Ðùû
Ûé\téù¼¹ðœ¹ÉéÛðý©ý¿Ÿ¿ßÛÿÿÿÿùÿ½ùù\0\0\t\t¹ËÙÙœ\t\t\0½ËÙùÿ¿ûýÿÿÿ¿ÿÿ\0œ°¹é½šÛÛ›Ÿ
Û
Ë›ÛÚùÉ¹­\r­½©­©¯\r¹ù­›Ú¼¹é\r°Ÿ\0™©Ûùÿ›ý¿›ûÿ½ÿ½¿ÿùûÛ
\t\t\0\t\0\t\tÉ­\t\tœ°Ÿ›Û½¿¿ùùÿ¿¿Ÿÿß¿ÿ\0\0\0ËžšÛÛ©ééý©ù½¹ü¼¹û¼Ÿ››Û
Ð›Ù›ðð½»Ë½¹Ëž\t
ù­ŸÛžÛÛßý½½ÿ¿ÿùÿ¿ß½©Ù½°Ù\r\t\t¹ÛÙ½™ùùùÛÙùý¿Ÿß¿¿Ÿÿÿÿÿ¿ÿ¿Àšùù©­ŸŸ›
ÚžšÚ››Ëü›©ðð½ù©ð°ð›Ÿœ¹é
¹é\0\0ý\0Ú¼¹½ù½¿¿¿Ûûÿÿÿ¿ûß¿ŸŸ¿Ûß›Û½Ÿ™½ŸŸ›ÛÛ½ûß¿ùÿ¿ýÿÿŸŸ¿¿ÿùÿ°\n
Ÿ›é©éÿ›ÛÛŸžž™¹¼œ¹
ÚšÙ
\r½¿ËËûžùÛœ\0\t›\t¹ÛŸ›ÛùÛßûýûÛùý½¿ùùûý¿›ý¹ûÛÛÛß½½ŸÛùûßŸùÿŸ½¿ÿÿßÿÛÿÿÀš™½ùé¼ŸŸ›Ë
ËË›Ëý\t»ÚÐ¹ù½š›É½°ùù\n¼›ŸŸé
É­ùü¿ðÿ¿ùùûÿÿÿûÿùÿÿý¿ßý¿ß½½½½ÿûß½¿½¿ÿ¿ùÿÿÿÿÿŸ¿¿ûÿÿ¿ð\0\0ËË
ŸŸ©©­¹ù¹½½°ü°¾¼œ¹¹ËšÙé¿
ËŸ
›Ùýùùžœ¿šž›ÐûÙÛûÿŸÛý½ý¹ÿŸ¿ÛÛùùùÿùÿÛßÿÿÿûßùÿÿÿùÿ¿Ûý¿ÛýýûÿÿŸûð\tË\0½¼°ùý½šß

Û›Ûù›
žœ¹ùéùºŸ\tù¹é½°š¿ûÿÿ\t\nùùù¿Ÿ¿ùýÛÿ¿¿ûûÿùÿý¿ùÿûÛùÿŸŸûûŸ½ûßÿ¿ÿÿùý¿ÿÿ¿ûûýÿ¿ÿ½ÿ\0\0\t°ùùúšÚ½¹ùù½½­­©ððÙé
žš™©ÉÚŸ¼¼¹é\r­Ÿùßý¿ùßžž½ùùÛß¿»ùýûßŸßŸûÛý¿ûŸùùùù¿Ÿ½ûÛÿŸÿ¿ßÛÿŸûÿŸ¿ÿŸŸÿ¿ÿ¿ÿÿ\t Ÿ›½Ÿ›Ù¯žšÚðù¹ðÛ\t«Ÿœ¹ùéÚ°½°Û™ËŸ››ùÿ½¿ýðžšÙ¹ËŸ¿¿Ÿßÿûß¿ÿ¿ûßûÛÛýùÿŸ¿Ÿùýùý¿Ÿ¿¿Ûÿ¿ŸÿŸŸÿßŸÿÿ¿ýÿýûÿÀœ\0›ÉûËé­¯ž›Ÿ›Û
½¼©©é
šŸ
Û©¼°ðÙÿŸûÛÿù\tù­Ÿ½éùýŸù¿Ÿÿ½½¿Ûß½½¿ý›ÛÛùÛùÿ¿ÿ¿ßÿßÛß¿ÛÿŸÿÿŸ¿ùÿŸÿÿûÿ¿ÿð\t
À»\r½½›Ùùððð½¹ùùû\t°ùÉ›ÛÉð°½©ùÚÛŸ™ûÛù½ùûðÛ
ÛÉù½¿›ÿŸùÿ›ßÿùûûûÿý»ýžŸž½¿ùÿ\tÿ¿ý¿¿ûÛýùûÛÛÿý¿½ûÛûÿÿÿŸð\n\0›ÐûŸšðºž›ÛŸŸ
ËðÛ\r°¹¼°›\tÚ°½¹éùÛßÿ¿Ð°ý¼»ùùùÿÛŸŸùÿÿ½¿½ÿßßŸ½Ûù½ŸŸŸùûÛÛ›ýŸŸý¿Ÿ½ÿÿÛÛÿÛÿÿŸÿ¿ÿÿü\t\r©½ëŸù¼°ðð¹ý¹Ûœ»\rž›ÛÉùúŸšÛË¹ÛÛŸŸûß\r½šÛ
Ûþ›¿Ûùÿ½½ûÛÛÛûûùÿ½»ûÛùéûß¿ŸßÛûùûßùÿ¹ûÿ¿Ûÿ½ÿÿÿÿŸ¿ÿ\0\0°ûË½ù°ú°ùù½»Ï
Ï­©Éº™­°°°©ù©½°°Ÿ¿ý¿ùÿ¿°
Û\r«ß™ýŸ½¿Ÿûûý¿ÿ½ŸßÛÙûßß\r½¹Ù¿ÿžûûý½ÿÛûßŸÿý½ùý½ûûÿ¿ÿÿùÿ \t\t½šžŸ½©¼°Ù¹ù¹ûÐ¹ÉðÙ­œŸšŸ\tÛË\r½½™¿ùÿùýÉðŸ
Ù©ùÿŸ½ûý¿ŸßŸý½ÿû¿¿ÿ½½¹ûŸ¿Ùùù½ûÿûý½¿ûÛÛÿ¿¿ÿ¿ßÿÿÿÿ½¿À\0ÚÛËùùùëÛŸŸ¾Úžžù
ž›\tºÙ©¹éðŸ°¹Ú›Ûÿýÿ¿ÿÛ
\tð½¾Ÿ›ùûÛ½ÛýÿûÿŸû™½ùÿŸŸŸ½½ùý½¿ÿ\tËŸÿ½Ÿÿý½ÿ½ùýýûßÿÿÿÿ¿ýŸð\t ¿
¹éË›šÙ¹ùùžœ™­šÙ°ÚÚ½°Ùð¹ýý½¿ŸÿŸ¿\tþŸž™ùü¿½¿Û½¿ŸŸŸûßÿý¿ŸùùùùÛ™¿Ûý™ù¹Ûù™ÿ½½¿ÿ¹ûÿûûßûûÿ¿ÿÿûÿð\0\t¹ùù­¿°ðù¾žž›ù©ëšÙ­
\t½½
Û©­©»ÿùùÿŸÿÛÐ\t­¹éÚŸŸËÛý¿Ÿûÿùÿ½ù¿¿¿ûùþ¿Ù½¿\0ŸÛ¿À›ÛÛßÿßŸŸÿ¿ßÿÿÿÿ¿ÿûý\0ž«ÚžŸŸ\tù½¼›ÛŸþ™éšÛ½¼šŸ\tÛÙý½¿ŸûÿŸ
ÛÛ\r›éûÛŸ½¿ŸûßÛßùÿ¿ùÿŸß½ÿ™°¼\0\tÛ›Ÿûß¹Ÿ¿Ÿù½»ÿûßÿ¿ÿÿÿÿÿ½½þ\t »Ûž›ÿ
Ë
ð¼¹ù¹Ÿž­©É

ùð¼°šŸ¿ŸùßŸÉ\tû\r­Ù¾Ÿ¿ÛÛùÿ¿¿ùÿùÿŸ½¹ûß¹ŸÛ\t¹Ù­Ÿý½»ÿùûÿÿ¹ÿýý½¿Ÿÿÿÿÿÿÿÿÿÿ\0\0šü°ù¼¹ŸŸŸŸÛž›ü°¹°›ÛšÙð½›ÛÉûßùÿ©ù›ý©¹°ºÙ›ûù¿ùÿŸ¿½ùÿûÿŸýûßŸ½ýùÿ½½½½›ýŸÿßùÿÿÿÛß¹¿¿ÿÿÿÛÿÿÿ¿ÿ½¿ÿ\0é¿›ßž›Ëé¼°úšÛŸ\r\t¼¹©ŸŸ
É©©ŸùÛÿÛ¿Ûüœ½éÉ¾©ÿÙ¿Ÿùýûÿùÿßÿûß½»ß›ÛÛÛÿÛËÙûÿ¿½ÿ›ÿÿù½ßßÿŸÛßÿ¿ÿÿÿÿÿŸÿé\0Ðð°½½½¼¹ùŸ½­¹ûš™¹­©ðÚ°ŸšÛÙÿŸ¿ù¿ÿŸù©Ú¿Éûß›ÿùù¿¿ŸÛÿÿ¿ÿŸûÛÝ»ý¹ûßÙ¿™¿Ÿÿßûÿÿÿÿ™û¿ûÛÿÿûÿÿÿÿÿÿÿ›ÿÀš›ŸŸšÚ¿›ÚšùûÛËù\r¼¼›Ÿ\t¹ËÙù­›
ûÛÛÙûßùÿÐ©¾™›ùùÿÛŸ¿ßýÿ½½½ÿùÿŸùûýðŸÙûŸýŸùÿÿùÿÿÿÿÿŸÿßŸÿß¿Ÿÿÿÿÿÿ¿ûßûð\nÀžÚÚŸ›ÐžŸŸžœ°½¼¹
\tðððÚ°¼›\rŸÝ¿ý›ß¿ÿÛð°ÛÙ¼½¼¿Ÿ½ûß½¿ŸŸÿûßÿÿý¿ùŸŸ™ÿ™ù
ùÿŸùÿÛÿÿ¿ùÿŸûÿŸ¿ÿÿÿÿÿÿÿÿÿŸßðš›››Úð¿ù¼°ùûŸÛûËÛÚ™¹›\tùÉ›Éº›ûŸûù½ùÿ¿ùË¼¾ŸšÛÛùûß½ûÛýùùÿùûßÿùÿ½½°›ý½½¿ŸùûÛßÿÿÿûŸùÿÿÿÿÛÿÿÿÿÿÿÿÿŸÿú\0\tÊÚÚ½¼¹ù¿
ù¹ËËÀù
›éšÙÿÙÿýÿÛÿûŸÐ\tÉ™ðŸŸ½ûÛùûýÿŸ¿ÿ½¿ýûûßùÿûÙù›ËÛÙùŸý¿ûÿ½¿Ÿÿ¿ÿŸý¿ÿýûÿÿÿÿûÿ¿ûý\tà™½½ºšÿ¹ð¼°ùý¹½©ëœ°››ðð™é›Û›ßûŸŸÛýÿð½°ÿ
ðùŸ½¿ÛßÛ½¿ý¹ÿÿÿ¿ßûùý½Ÿ\tý¹ùÛùÿÛý¿ÿÿÿùûýûÿ¿ÿÛÿÿÿÿÿûÿûßŸÿ\0\t©é©ùùù
ÛŸžšŸùÉœš™ðÐË™
ËùÿŸ¿ýûÛÿŸ™ðû\tùÛŸûÛß¿¿½ûÙŸÿÛßŸÛûßß¿ÿ½½©Éù©ÛÛý¿ÿÿÿ½¿ýûßÿÛÿ¿ÿÿÿÿÿÿÿý¿ùÿ\0ËŸžžŸ
ùù­¾›½éëš
Ùé
›œ°ùšÛ\t½ùÿûß½ÿûÿŸ\rŸŸž½¹ùÿ½ŸÛûßÿ½½ÿûûýÿûùùûÛÛÛ¹ŸŸ½¿Ûÿÿÿÿÿûÿ¿ŸÿýÿûÿÿÿÿÿÿûÿÛÿš\nð¹ù©ý­­°ÛÍ©¿ùÉÐ°ùé

\r\tŸÿ\tûÿùù¿ß\tðšùù›ËŸ½ûù¿ßûÛÛûù½ÿÛùýÿ¿ýÿý½ß™ùùÛùÿÿÿ¿ÿÿŸýÿÿŸûÿÿÿÿÿÿÿÿÿýùÿ\r\t›Ð¿ßšÛ›Ë½»ÛËù

­°½
\tÚù¹Ÿ½ÿÿùÿùŸ\0ÛÛÚý½ÿŸŸ½ý½½ÿÿÛÛß½¿½»ùý›ûùù«ŸßŸ¿ß½ÿÿÿÿÿûûÿÿÿ¿ûÿÿÿûÿÿ¿ûÿ½¿ð\0›ù°¿šÞ›Úœ¼½¾œ¼°¼
Ðù©©Ÿßùÿÿ½½Ÿü¹ù©›ù¹ù¹ûùý¿¿ÿ¿ù½ûûÛùÿßŸ›ùý¿Ÿù¹½ùùûÿÿÿûß½ý¿ÛÿÛßÿÿÿÿûÿÿÿ
ÛÿÀšËÛ›žŸÐù¹­½ûŸ›Ù©™­©©›\t©\0ÙÐ›ùù¿½ÿÛ
ýŸ\0ÛÛÉý
ŸÛÛÛûÛÛÛÛßûßßÿ›ÿŸý½¿Ÿ½°½Ÿ›ÛŸŸ¿ÿùÿùÿ¿ß¿Ûÿ¿Ûÿ¿ÿýÿûÿÉ¿þ\t\t¼¼¿š¿žŸššŸ
Ë¿éÐœéÚÚ›š\0¿ùý™ÿ¿¿Ù›ð\0\té¹šÙë½ÿŸŸÛÿ½ÿ¿ß¿¿ûùý½¿›Ÿ¿ÛßÛËß¿Ûßÿÿ¿ù¿ùÿ»ÛÿŸÿÿûÿÿÿ¿ÿÿð›ÿÐ­©ù°ùðùðùÿšÛŸðË™©°¿›\t™ÉÉ¹Ÿùù¿ûßÿÿ›Ûß›ÙÏ¹ûÛ¿ÛÛùùûÛÛŸŸŸ¿ùýùûŸ›Û™ùù¿ûÿÿßŸÿŸùýý©ý¿Ÿýÿùÿÿÿÿ\0ÿ\0ÛŸšßŸŸš›½°ùÛ¾œ\r¼°°¼\0›ùý
ßùÿ½ùð\t­©¹ùû¹ýŸ½ý¿ÿß¿ùùýùùùùÿ¿¿½¼›ËŸŸ¿ùŸÿ¿¹ûÙù­©¹ùûÛûûÿÿ¿ÿ¿¿ð›ÿ\0©©ð½°ððùéðûÚÛË¼½\t¹ ù­\tÉÉ›Ÿý¿™»ßŸù¿\0\0\t™ýÛÚù¿ŸÛ¿Ÿ›½›ÚÛ
ž¿Ÿ›ÛÛùðûËß½ùÿûÿÿÛß¿Ï›ßÛŸŸ½½ÿÛÿÿÿÿÿ\0™ÿ\r\0žŸËù»ù¼°›žŸ
ŸÛ\0¼œ™
Ú›ššÐÐ›ùý½ýûÿ
ý\0é\0ùšŸ\tûŸÛÿ½ûûýûý½½½ù½™Ûý½½ÿŸ™ù¹ûÛŸ½ÿÿð¿ùé½½¹½¿ŸŸûÿ¿ÿ¿ÿÿûðÿ\0\té¹½¯\r¿ËÛËß¹ý©¼›Ù°°½\t\r­\t\t©ý¿Ù¿¿ßð\t\0é¼ûÛŸŸÛ¿ÛŸŸÛ¹ÚŸŸŸ›Ûž°™¿ÛÛŸŸ›ý­½ÿŸ¿ÿÙü›Ùù½¿ÿÿÿÿ¿ÛÿŸÿûÿÿÉÿ¿\nž›ËËÙûð¹°½«
ŸûÀ
\r\ršŸ
œ½\0›ÿŸžŸÿý¿°\0\t\0Û¼ùé½½½ùûù¼Ÿ½¹ûÛÿ½ùÛÚÙ¯¿ÛÛÉÛÛÛÛÿ›ÿ­»ŸŸ›Ûß›Ûÿÿûÿÿûÿÿÿÿ
ŸýÉ\t½½¹úœ½½­
ÛÛÚÛÛ™­°°ù\t\r©©
ùŸùùŸÿ¹ý­\0\t­«ÛŸŸŸŸûùÛß›ðÛÛÛý½ûÛù½½™Û½­¹½½½½½ÿÿß½½Ÿý¿ýšŸÿùŸŸÿÿÿ­
úžšÚÚÚŸûžšÛ\r­­½­ùà™\r\t\0ð¹œ¼\t
ÿ™ý»Ûß
Ð\0\t\0›©ùûÛý½ûùºðÛ›ËÛÛÛ\r½™ÛÛ¿ŸÛÛÞ›ÛûÛÿ¿ðŸ¿ÚÛÿÿý½½ûÐ\0
Ûûÿÿÿ\0¿­©\r›ù½ð½é½©ù¹ù¯›ð\t¼°°ÛÐð¼™°¹ßŸùœ½ù½ \0\0\tÞÛŸšÙûÛ¿¿›Ù™¹é›ÉÿŸÛùÿùÛÝ½½½¹¿¿¿ßù¿™\t\0ÿù\0\0¿ÿÿ¿ðžÉ\r«¯šÚ›Ú›ËŸ
ÏšÙ¼Ûœ\tÐ
\té
\t\t­\tÉ¿ùž›Ûð\t\0\0\0\0¹­½½¿­½ý½½¼ðÐŸŸð\tùÿŸ\t
éëûûûß
ÙûßÛÿéÛÀŸÿ\0\0\t\tÿð\0ûý¿Ÿÿÿ\té\0©½¹ü½¼¼°Ÿ°½ºÛ¼¹ ¹Éðš¼š°™ÿ›Ûý½\0\t\0\t\0›ÚÛÙùû¿ùí¹\0\0™›ð\0\0\tÿÙ™™\tý½½ù¿Ÿ¿½¿Ú™»\tÿ\0Ÿà\0ü\0Ÿÿ\t»ßûÿý\0\0©Ê
ééé½©ù¹ë\tùéß­ùÀ\t©
ÉË
™Ÿ\0ùý½©\0\0\0\0\0\0Ð½½ëŸŸÛŸ›Éé\0\0¿À\0\0ÿÿý\tŸ›Ð¹½ùùùÿÿýÙÐ\0\t\0\0\0¿ð»ß¿ßÿð­¼\tÉ›ù½«Û¼šÛ©›ð¹°¼ù°\tž\tŸ¹ÿÐ\0\0\0\0\0\tË¹ù½¹ýé¿Ûÿ›©ÉÀ\0\0\tü\0¿ð\0½½ý»ßÛ¿ÿÿÿÿ°›ûûÛÐÀ\t\0ŸŸð\0½½úß¿¿à›\0\n©¯
Ë°ðù
Ë¿šÙï½\0\r
Ëé\r°°¹é­š\0Ÿ™\0\0\0\0\0\0\0\tËŸ
ß»Ÿùû™ü½šé\0\0\0\0\nÙŸ›ð¹½ÿŸûùÿß\t\r­¿Ÿÿÿ›ú¹ûÿŸ›ÿÿ\0à\r\tÙ½¼¾Ÿ›šð°Ð½¯›ûÙ©ùššÙÉÉšœ\0\0\t\0\t\0\t\t\0œ½½½\t
ßé½¾Û\r°ÿÛÀ\t¼™¿™ðŸ­½ûßÿŸÿÛÿžš™ÛÙûÿ½\0ÐŸŸÉûÿùÿÿðŸž\t\n\0©Ú›ÛËÞ™¼›½©šÙ½\nÙéË\téÉ°°°ù\0\0\0\0\0°À\0\0\n\r»Ðùûý›ßŸŸ™»Û\tË™ÿùÿÛÿÛË\tùùÿ½¿Ÿÿÿ¿ùù½
\t
™\t\t¿›ùûÿœ¿ûÿ¼\0ðÚÉ
ž›ù©ðÛ\r
ÚÙ¾ð¹š°Ÿš›\r\tÉ\0¹°\0\0\0\0\0\0°\0\tÀ›É›ùÛ­©
ùéßËß½ÚšÐšÐŸŸ›ÛÛÿÿùÿÿŸ°Ðü½¼žÛÛý¿ÚÙéù©¿ÿÿÿ\tû\0\0Ð¹ËŸŸ°Ú½­ºùù\r©\t\r\r
¼¹œ
\0\0\0\0\r\tÀ\0\0ð½¹ü¿©ÛÚÙ\0ŸŸ\t½ûß½¿Ù»ÙŸŸŸð™éùÿý¿ÿÿŸýß»™\tù¹¿ý¿Ûý¿½¿ÿ\r¿ÿð
Àð\té
Ú½­¹é°Û­
šÙË¿¹ž™úš›œ°™›\0ÐÀ\0\0\n\0\0\tËÚ›Ùÿ¹ Ùé\tð™­¹ûÛÿß¿ù
™Ÿ½½¿ŸÿÿŸûû¼œ¹ð\0É\0›Ûù½\t\0\t\0\t¿ÿÿðŸà\0 \r
ÛËžŸ\tÛÚÙ«ŸùËÉé\n™É\té\r ¹\r \0\0\0À\tÀ\n\0Ÿ›ŸÛûÛúÐÙ ð
ðÙéŸý¹ûÐùË\tÚ›Éû¿ŸŸÿŸßÙ\t\r\nÐ\0\0\0\0\0\r\0\0Ÿÿ¿ð
ðð\t\tÉ©­©½é°¼°½¯©ð°›ùÚšÚ°ð¬\0\0\0\0\0\tÉ©¼½¹ùûÉû\0\t\0½\t¿\t
\r\0\0ð°É°ß›ÿßÿÿÿÿûûà\0\t\0\0\0\t\0\0¬°©\t¿½ÿþœ\té\0 ÐÛŸÚ›ËÛËÚšß½
Ðé\t­\tùÉ©é\t\0\0\0\0\t\0°ÚÛÚü½½Ÿð\0\t\t\0ž\tð\r\0\0\0\0É\0É›ûßûÿý½½™\0\0\r\0\0œ›ÿÿÿù
ðž\0\núŸ°›\r¼½«ûÐ¹›šÛ°ÐžŸ\0\0\0\0\0\t\0 \0\0ÀŸžù½¿ÚŸ°½\0\0\0Ð\tÀ\t\t\n\0ÐŸ\t\0\t\n\tÿ™ÿûÿ½ÿÿÿð™à\0\0\0À \0ðÀšŸÿ¿ÿÿ­
ðð¼\0¼©ðûËËÚ›
Ùù
ÉàÙ­\0ÛË\t©©\0\0\0\0\0\0\0œ
\t

ÛŸÛÛŸ›ßÛù\0\t\0\0\tàÀ\tÉ À\0\0\0\0\rŸùÿùÿßß¿ûÛÿÀ\0\0™Éû\t»Éÿßÿÿý\t­ðð\0šÀ\tºÐ¹\t°¿\r­¯ð¼š™šÙ¹°Ð™É\0\0\0\0\0\0\0\n\r¼¹ð¹éùý¿šÙð\0\0š™©\0\0\t\t\0\0\0\t›ÿý¿ÿÿûÿýÿùÿÛ\0\0 ž¿\0­¿ûÿŸÿúžŸÿ\tÀ\0\rŸžžœ»Ðš™ù½\t°ÚÉ©ÀËÚšÚš\0\0\t\0\0\0\0\t\0™ðÛÛÛÿ›Ð½¾›Ð\0ŸëËËÉ\t\0\0›Ûýùÿÿÿ¿ÿÿÿ½½¿ÿÿ½½ù½¾™ÿÿÿûÿý

ð
\0\0¹©©\t©É
ÉË
ûÐÛ™¼¹¹\t\t\t\t\r
À\0\0\0\0\0\0ÐšËÛùý½ŸðûÛÙí¿Ÿ¼¼\0\0™Ûßÿ¿ÿÿý¿ÿßÿÿÿÿÿÿùÿŸûÿýùù¿ÿÿ¿ÿÿúœÿ\0Ð\0\0šÚœšð°°ðÚ
\tà™\r¼¼¼¼°\t\0\0\0\0\0\0\0\n\r\0©þ›ÿùŸŸ­¿™ÿð\0\0\t
ù¹ŸŸÿ¿ûßÿÿÿŸÿÿûÿ½ÿ¿ÿŸŸÿÿ¿ÿ¿ÿÿÿÿÿÿÿÿ½ ¯¼¼° \0\0œÚœž\tÉ\r\t¼ž™ðð›\té\0\0\0\0\0\0\0\0\0É¹¹ž›ùùý°Ÿ¼¿ÐžŸÛß›ßûÛÿÿÿÿÿ¿ÿÿýÿÿÿÿÿÿŸÿÿý¿ßßÿ¿ÿÿÿ¿ÿ¿ÿð›ÙË\0\0\0\0\0\0\0\0\0\0\0\0ð\0\t\0\0\0\0\0\0\0\t\0\0\0\0\t\0\0\0\0
ßùýù¿›ý­Ÿ›ÿ™ÛŸûßÿÿÿ½ÿÿûßÿùÿÿ¿ÿßÿÿ¿ÿÿÿ¿Ûÿ¿ÿÿÿÿÿÿÿÿÿÞ\0úý\t©\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0Ð°Ÿ¹­½ù½»ùÿŸûÿùŸ½ûßŸÿ¿ùÿÿÿÿÿ¿ÿÿûÿÿßùý¿Ûÿÿÿÿÿÿÿÿÿ¿ÿÿ¹\0¾žÞ\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0Ð\0\0\0
À›ÙûßÙ©ûÞÛßŸùùý½¿ÿÿ¿ûÿŸÿÿÿÿÿÿùÿÿÿÿÿÛÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿœ°\tð¹©éÀ\0\0\0\0\0\0\0\0\0\0\0ž\0\0\0\0\0\0\0\0\0\0\0\0\0š\0\0\0\0\0À\0
\0šðÛ
ß½¹¿ùÿŸ¿ûûßù›ßÿÛÿÛÿÿûý¿ÿÿŸÿŸÿ¿ÿÿ¿ÿÿÿÿÿÿÿÿÿÿÿÿÿûË\0
ËÞß\0\0\0\0\0\0\0\0\0\0\0\0\0é \0\0\0\0\0\0\0\0\0\0À\0\t\0\0\0\0©\0\t\r\t¹ý»ËÿÛÛ›ÛßŸÛùÿÿ½¿ÿÿÿ¿ÿßÿÿŸÿÿ¿ÿ¿ßÿ½ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¼\0ŸŸ

Ë\0\0\0\0\0\0\0\0\0\0\0\0¼\0 \0\0\0\0\0\0\0\0\0\t\0\t\0\0\0\0\0\0\0\0\0­
Ð¿›Éù™ùÿÛÿ½ûýÿ½½ÿý¿ÛÿÿÛûÿ¿ûÿÿßýÿûÿÿ¿ûÿÿÿÿÿÿÿÿÿÿÿÿý©\0\0¾Ÿ\tðÀ\0\0\0\0\0\0\0\0\0\0\0Ë\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tÀ\t\0\t\t\0
É½­¿Ÿþß½¿ÛÛý¿¿ßÿ¿ûÿ¿ÛÿÿýÿÿŸûùûûÿ¿ùÿÿŸÿŸûÿÿÿÿÿÿÿÿÿûð\t
É¼
À°\0\0\0\0\0\0\0\0\0\0\0¼\0\0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¬›ÉÛÙý¹»Ûß¿ÿ¿ýý¿¿ýÿýÿÿùÿÿûÛÿßÿÿÿÿý¿ÿ½¿ÿÿßÿÿÿÿÿÿÿÿÿ½\0ÚÀ¿
Ð\0\0\0\0\0\0\0\0\0\0\0Ë\0š\0\0\0\0\0\0\0\0ž\t\0\t\0\0\0\0\0\0\0\0Ÿ\tÉº›û
ßý¿¹ù½ý¿¿ÿýûß¿ÿÿÿ¿ûßÿÿÿÿÿý½¿ÿÙÿÿûÿý¿ÿÿÿÿÿÿÿÿÚðàšùð\r®\0\0\0\0\0\0\0\0\0\0\0¼\0\0\t\0\0\0à\n\0\0\t\0\t\0\0\0\0\0\0\0Ð\0
¼ŸœŸÛù¿ÿß¿¿ßÛùûÿ¿ÿŸ½¿ýÿ¿ý¿ûÿý¿ÿÿù¿™Ûýûûÿÿÿÿÿÿÿÿÿù\t\0Ÿ\0­¿
Ð\0\0\0\0\0\0\0\0\0\0\0é \0\n\0\0
\0\t\0\0\0\0\0\0\0\0\0\0\0 \t\0\té
ûÚŸŸÙûù¿ßÛûÿŸÿÛßŸÿÿýÿ½ÿÿÿÿÛûÿ¿ùýéŸ¿Ÿ¿ýùÿÿÿÿÿÿÿÿžš\t\r°Ðð¿à\0\0\0\0\0\0\0\0\0\0\0¼\0\0\0\0\0\0\0\0\0\0\0\0\0\0À\0\0\0\0\0\0\0\r\0›ÉŸÛŸ¿¿Ûý¿¿ý¿ÿùÿ¿ÿ½½ûûÿÿ¿ÿûÿÿßÿŸ\0™éŸùÿÛ¿ÿ¿ÿÿÿÿÿûð¼\n\0¾›Í\0\0\0\0\0\0\0\0\0\0\0\0Ú\0 \0\0\0¬ \0\0\t\0\0\t\0\0\0\0\0\0\0\t\0¼¼¿½¿ŸÛýûùý¿ý½¿¿ý½ÿûÿýÿ¿ÿÿßÿÿ¿½\t
Ÿ™ùÿù¿Ù™É¹ŸÿÿÿÿÏ\t\0\t\r\tÀ¾\0\0\0\0\0\0\0\0\0\0\0éÀ\0\0\0\0\0\0Ê\0\0\0\0\0\0\0\0\0\0\0\0\t\0 šÜ›½œ¹žÙùý½¿ß¿ùÿÿÿùÿûÛÿŸ¿¿ßÛù¿ùùÿÉ™ð›ý¿Ÿù¿é\0¼¿ÿÿÿŸ\0ü
ð¼ð\0\0\0\0\0\0\0\0\0\0\0ð \0\0 \0\0\0
\0\0\0\0\0\0\0\0\0\0\t\0\0\0œ\t©\tÀ¹ðù¿›ùûý½ý¿ûÛÛÿûÿÿßÿßý¿ÿßÿ¿ÿð°¿\týûÙðŸð¹Ù\tŸÿÿù ¼\n¼\0›
À\0\0\0\0\0\0\0\0\0\0\0¬\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0œ¼›œ½¹ý¿ß¿Ûûûý½¿ÿß½ÿŸûÿ¿ÿÿûÿßð°\t\t¹Ð»ÿ½›\tù\t\t ÿÿÿðùÉ\tË\t¬\0\0\0\0\0\0\0\0\0\0\0Ú\0À\0\0\0š\t\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0
Ð©
œ¹ËÙûÉ½ý½½½ûÿßŸ¿ÿ¿ûÿŸÿÛÿýÿ¹ùÙŸ\tß
\tûÚÐ¼\t\0›ÿÿÿù\0 š¼›\n\0\0\0\0\0\0\0\0\0À\0\0ùà \0\0\0\0\0ž\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tÀûË›ËËÿ›ûÿÛûßÛ¿ýùÿßýÿÿÿÿÿ¹¹ù\0°É›ðŸ\tûŸÚŸ\0\t\0°\0Ÿ¿ÿÿ\tÀ¼šÉ¾ðùð\0\0\0\0\0\0\0À\0\0\0ð\t\0\0\0\n\0\nÀ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tÀŸ\t\tùé¹ùÛßŸŸ½ÿûŸß¿¿ùÿ¿ÿûûÿð\t\0Ÿ\0šù\t¹ÿ\tÉ\t\0\t\0›ùÿÿÿð\0°\0\tšÉ\r \0\0\0\0\0\0\0\0\0\0\0\0à\0\0\0\0\0š\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿\t
ÛÏŸ¿ùùûÛ½Ÿÿûùÿß¿ÿ¿ÿßûÐ™½
ð½œŸž°›É\0\0¼žŸ¿ÿù\t\tÀ\0Ð¬Ÿ
\r\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\nÐ\n\t\tËž¹ùùŸ¿ý½ÿ½ûßß¿¿ùÿý¿¿ð™¼šœ

\t¼™\0\t
À\0\0\0›ÿÿ¿ž\0\0\0©
\0¼š\0\0\0\0\0\0 \0\0\0\0\0ð \n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\t\0ý\t©ùùÿùù¿ÛŸûß¿¿ýÿÿÿŸÿý\0ÿœ¹ \tý
\0 ¼\0\0\t©\n¹ÿ™ÿù\0\0\0é\0Éðšœ\0\0\0\0\0\0\0\0À\0\0­\0\0\0\0\0\0 \n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t©\r©¿Ÿ¿™½¿ÛÿÿŸ¿ßŸûÿÿùÿ™ð°Ÿ\tœ\tŸ\0\r\tÙ\n\t\t\0\tàÀ\tÚß
ÿ\0\r \t\0\0
\0àÚ\0\0\0À\0\0\0\0\0\0Ú\0À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0ðœ°é›ÞŸÿ½¿ŸŸ½ý¿ÿŸùÿÛùŸ\tÉé\t¼\0\tù°°\n\t\0\0\0°\t\tÀ¹ú\tÿ\0\0\t\0\0¼
™°\0\0\0\0\0\0\0\0\0\0\0\0­\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0œ\0\0\0 ›
ùýùùùÿùÿ½ÿ¿ÿŸÿÿû
Ëð\t\0
\0¼ \0\r\0ÐÐ­\r\r\0\0›\t\tðš\0\0\0\0 \t\0¬\0\0\0\0\0\0\0\0\0\0\0\0ð \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ð\rœºž›½¿¿›ý¹ûÛÛŸûÛÿý½™ð›Ð\0™œ°
\0\0é

\0šž\tððŸ \r\0\0\0\t\t\0\r›\0\0\0\0\0\0\0\0\0\0\0\0\0ðÐ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0
À\0
\0°¹ùûÙÛý¿ÿý¿ÿÿýÿÿ\0ð\0\0ð\0\nÀ\t¬\t\0\0œ\t
\0ðÉË­\t›é\0ðš\0\0\0\0ð¬¼\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\tÉ\tûžÙÿ¿ÛÛÛÛûÛÛÛùù\tù\0\0œ\r\t žÉ\0°Ù­­½\0\t\0\0\0\0\t\t\t\0Ù\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0À\0­¼\rùù¿½½¿¿ûÿßùÿùÿð\tù\t\0\0\0\t \0\0¬\0\0\t\t­©É¬™°é\n\t\0\nÐ\0\0\0à\0
\nÐ\0\0\0\0\0\0\0\0\0\0\0\0­\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0›
Úß\r¿ÚÙùß›ùÿ›ÿ¿Àœ°\nÐ\0\0\0°\r\0\t\t\0\0\0\0›œ\0œ\0\0\0\0©\0\t\r \0\0\0\0\0\0 \0\0\0\0\0Ú\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0À\0\t\0\r°½¹ûÚý¿Ÿ¹ÿŸùý¹ý
\r©\0\t\0\0\t\0\tÀ\0\0Ð\0\0\0\0\0\0
ù\n\0š\n\t\0 \0\t\0\0° ­\0\0\0\0\0\0\0\0\0\t\0à\0­\n\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\tà\t
\r½½ù½›ý¿Ÿùû½¿ÿÐœ\0\0œ\0\t\0\0\0\0\t\t\0\0\0­œœ\0É\t\n\0\0À\tÐ\0\0\0\0 \0 \0\t\0\0\0Ú\t\tÊ\0\0\0\0\t \0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\t\0\r¹éúŸÛÿŸžŸŸŸÛûÛð¼š\t\0\0\0\0\0\0\t\0\0\0\t\t\t\0\0\0\t\0
\0°\0\t ÀÐœ\0\0\0\0\0\0\0°\0\0\0\0\t\0\0\0\0\0\0éà \0\0\0\0 É À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\téŸŸ›ß›ù½¿ûÛüŸŸÉ\r\0\0\0\0\t\0\0\0\t\0\0\0\0\0\t\0\0\0ùà\t\n\0\0\0\0\0\0\t
À\0\0\0\0\0 \n\0\0\0Ê\0\0ð\t \0š\t\t \0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ÿ\0ùü¹ü½ÿŸŸ¿ß½¿\0 Ð\0\0\0\t\0\0\0\0\0\0\0À\0\0 \0\0\0½\0\t\0é\0\0\0\0\t\0¼\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0
\t\n
\0\n\n\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tù¼¹ž›Úù½½ý¹Ÿð™É©\0\0\0\0\0\0\t\0\0\0\0\t\0\t\r\0\t
Ð­\0\0é\0\t \0\0\0\0
À°\0\0\0\0\0\0\0\0\tà\0\0\0ð\0\0\t
\nœ\0Ð\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\t\0\tùðùý½ŸÛÿ¯¼½\n\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0ð\0\0½\0\0\0\0\0\0\t\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0 © š\n\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ŸŸ™ëšÛùŸ›ËÐ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0°\0\0œ\0\0\0\0š\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0  œ\0   \t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0©é¯ûŸŸûùý°\0¬\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0›Éð\0\0 \0\r\0\tð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0œ\n
\t\tÊ\0Ðà\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0šÛÛÛÛ½ŸŸÚÛÀ\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\t\0\0\t
\0\nÐ\t¬\0\0 \0\0ž\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ðÚÀ\n\t\0\nÊ\0Ð \0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t½©ðüž™úÛý¼°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¼\0\0¼\t\0\0\t \0\tË
\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0Ú\0š\0  Ð\t \0\0\0\0\0\0\0\0\0\0\0\0À\t\0\0\0\0\0\0\t\0\tÚÛŸ™éý¿Ÿ›À\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0\n\té\0\0\0À\0\n\0Ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0­\0 \r\t\r ¼\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\t\n½¯Ë\t½¼¼\0\t\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0š\0\0\0°\0\0\t\0\0É©\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0ð°Àš\n\n\0\0\0\0\0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tÊž™¼›ù\tÉ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\t©é\0\0\0
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\nš\0\tÉ\0\0\0\0\0\0 \0\0\0\0\0\t\0ð\0\0\0\0\0\0\0\0\0\t\0\t\t¼\tÀ\nÐ°ù\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0À\0é\0\0\0\0\0
\t \0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\r­ \n\0\0\0\0\0\0\0\0\tÀ\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\t\n¼\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ê\0\0Ð¹\0é\0\0¼\t\0Ð\0\0\0\0\0\0© \0\0\0\0\0\0\0\0ð\n\0\0\0\0\0\0\0\0\0\0\0\n\0\0\n\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\r\0\r\0¼\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\nÀ\r\0\0\nÀ\0\0©\n\0\0\0\0\0\0\n\0À\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\tÀ
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0À\0°\0¼\t\n\t š\t\0\0\0
\0\0°Ë\n\0\0\n\0\0\0\0\0ð°©\0\0\0\0\0\0 \0\0\0\0š\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
À¬\t\0\t \t\0\0À\0ð\0\0\0\0 \0\t \0\0\0\0\0\0\0\0¼\0\0À\0
\0 \0\0°\0\0\0\0\0\t\0\0\0þ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0ËÀœ\0œ\t\0\t\0\0\0\0\0\0\0àšÊ\0\0\0\0\0\0\0\0úÊ
\0\0 \0\0\0\0\0\0\0\0¬\0\0\0\0Ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\t\0\0\0\0\0\0\0\0š\0\0\0\n\0
À\0\0\0\n\t\0\0à\0\0\0\0\0\0\0\0œ\n\0\n\0 \0\0\0\0\0\0\0\0\0\0\r \t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\nÀ\0\0\0\0\0\0\0\0\0\0\0\n\0š\nšÀ\0\0\0\0\0\0\0\0ëÀ\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0É\t
\0\0°\0\tÀ\0\0\0\0\t\0\0\0œ\t \0\0\0\0\0\0\0\0Úš\0\0\0\0\n\0\0\0\0\0\0\0\0\0\n\0
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0Ú\0\0\0\t\0 \t\0°°\0\0\0\0\n\0\0\0 ¬\0\0\0\0\0\0\0\0\0ðÀ\0\0\0\0\0À \0\0\0\0 \0\0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0ž\0\n\tÀ\0\0°\0\0\0\0\0\0\0\0\0 \t\t \0\0\0\0\0\0\0\0Ú\0\0\n\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0¬\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\t\0\tÀ\0\0\0\0\0\0 \0\0\t\0 \0\0\0\0\0\0\0\0\0ð\r\0\0š\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0À¬\0°\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0 \0\0\0\0¯\0 \0\0Êð\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0š\0\0\0°\0\0\0\0\0\0\0\0\0 \0 \t \0©À \0\0\0 \0ð\0\0\n\t\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\t\0\0\0À\0\0\0\0\0\0\0\0\0\0\0 \0\t\0\0\0\0À ð\0°œ\0\0\0\n\0\0\0\0\0\t \0\0\0\0\0\n\0\0
\0À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\r\0\0\0\0\0\0\0\0\0\0\0\0\0à½©\tà
À\0\0\0 \0\0\0\0\0\0\0\t \0
\n\n\0\0 \0ð\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tÀ\t\0\0\0\0\0œ\0\0à\0
À\0\0\0\0\0\0\0\0\0\0\0\n\0\0 \0\0\0\0
\0\0­\0\0\0\0
\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\nž\0°\0\0\0ëÀÚ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0œ\0\0\0\0\0\0\0\0\0\0\0\0\0
Ê\0\t¬°\0\0\0\0\0\0\0\0\0\0\0\0\0\0 ž\0š\0\0\0\n ©\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\t\0œ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0œ\0\0\0\0\0\nÐ\t\0Ë\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 °°¬\0\0\0\0Ú\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0©\0\tÊ\t
\0\t\0À\0\0\0\0\0\0\0\0\0\0\0\0\0 ° Ð\0\0\t\0\0\0­ \0ð\0\0\0\0\0\0\0\0\t\n\0\0\0\0\0\0\0 \0 \0\0ð\nÀ°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t \0\0\0\t\0\0\0Ð\0°\0\0\0\0\0\0\0\0\0\0\0\0\t\0ÀËÊ\n\0\0\n\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0É\0\t\0\0\0\0\0\0\0\0\0 \0\0œ\0\0\0\0\0\0\0\0\0\0\t\0\0\0\t\0\0\0\tà\0\0\t\0\t\0\0ð\0ÉÀ©
\0¼\0\0
À\0\0\0\0\0\0\0\0\0\0\0\0\0Êš\t\0š
\0\0\0\0\0°\0\0\0\0\0\0\0\0\0°\0¬\n\0\0\0\0\0\0Ú\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0 \0\0\0\t\t\0\0\0\0\0\0\0\tÀ\0
\t\0\0°ð\0\0\0\0\0\0\0\0\0\0\0\0\0 ©\0\0 \0\0\0\0\0©\0š\0 ð\0\0\0\0\0\0 \0\0°\t\0\0 \0\0 š\0É\0Ê\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0Ð\0\0\0\0\0\0\0\0 °\0\t\0\0\0\0É\0\0\0\0\0\0\0\0\0\0\0 \0\0\t\0\n\0\0\n\0\0\0\0\0 À\0\0\0\0\0\0\0\0\r\0\0 À \0\0\0\0\0
\n\0\0\0\0
\0\n\t\n\r\0\0\0\0\0\0\0À\0\0\0\0Ð\0\0\0\0\0\0\0\0\0\0\0\0\0¬\tÀ\0ÛË\0\0\0\0\0\0\0\0\0\0\0\0\0\0š\0 \0\0\0\0\0 \0\0\0\n
Ë\0ð\0\0\0\0\0\0\n\0\0\0©\0\0 \0\0\0\0\0Ë\0\0\0À\0\0\t\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\nÐ\0\t\0\0\r\0àÚÚ\0\t\0\0\0\0\0\0\0\0\0\0\0\0 \0\n\0\0\0\0\0\0\0\0\0š\0\0\0\0\0\0\0\0\0\tà\n\0\0\0\0\0\0\0\0\0°Ë\0\0\té \0\0\0\0\0\0\0Ð\0\0š\0À\0\0\0\0\0\0\0\0¼\nË\0 \0\0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \n\0\0\0\0\0\0\0\0\0©¬š\0 ð\0\0\0\0\0 \tÀ\0\n\0\0 \t\0 \0\0\0\0\0\0\0\0š\0\0©\0\t\0\0\0\nà\0\0À°\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0Ë\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\n\0 \0 š\0©\0ð\0\0\0\0\0\0 À\n\0\0\0 \0\0\0\0\0\0\0\0\n\0©à\0À°\0\0\0\0\t\nœ\0\0Ð©\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0É\t\0ð\r©\0\0\0\0\0\0\0\0\0\0\0\0\0à\0\0\0\0\0\0\0\0¬\0°ššÐÚ\0\0\0\0ð\0\0\0\0\t\0\t \t\t\0\0\0\n\0\0\0\n\0\t\0
Ë\0\0\0\0°\0à\0\0\0\0
\0\0\0à\0\t\0\0\0\t\0\0\0\0\t\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0š\0° À  \0\0\0 \0\0\0\0\n\0\0\0\0
\0\0\0\0\0\0\0\0\n\n\0\0¼\0\0°\0\0\0°\0 À\0œ\0 \0\0\0\0\0\0\0\0\0\t\0\0©à¼
À\0\0\0\0\0\0\0\0\0\0\0\0\n\t\0\0\0\0\0ššÀà
š\t\n\0
\0\0\0ð\0\0\0é\0\r \0\0\0\0\t\0\0\0\0\0\0\0\0\0©\nš\0°\0°\0 °\0¼ \0°Ð\0\tÀœ\0\0\0\0\t\0\0\n\r\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\nÀ\0«
\0\0\n\0\0\0\0\0\0\0\t\0\t\0\0 \0\0\0\0\0\n\t \0\0\0\0\0\0\0\0\0žœ\0ð\0\0À¬\nÚ\nÊ\t\r À\0\n\0\0\0°\0\0\0\r\t\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0°\0°éÀ°š\t\0\0\0\0\0\0\0\0ð\0\0 \0­\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 °\0\0°\0 š\0¼\0ÐÊ\0\t\0°\t\0\t\0\t\0ð\n\n\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\t\0\0\0°\0š
\n\0 \n\0\0\0\n\0\n\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0©\0\0\0\0\0

À \0\0\0\0\0\0š\n\n\t\0©À \0À \0
\0¼œ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0  \0š\0\0\0\0\0\0\0\0\0\0\0\0\0 ð\0 \0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0©\0À©É\0\tà\0\0\n\0œ\nÀ¬\0\0\nÀ\0\nœ\n\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \t\n\0©\n\t \0\0\0\0\0\t\0\0\0\0ðð\0Ë\0\n\0\0\0\0¬\0\0\0\0\0\0\0\0\0\0\0\0\0°°\n\n\0 \t\t\n\t\tš\0\t\0\0©
\0\0\0\0\n
\0ð\0\0Ú\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0ð\0\t \n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0ð\0\0\0\0 \t\n\0\0
\0©\0 \0\0\0\n\0\0\0Àé\0
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¬\0É\0\0\0\0\0\0 \0\0\0\0\0\0\0\t\0\t\0\nÚ\0\0\0\0
¼¼©\0\0\0\0\0\t\0Ú\0\0\0š\0\t
\0\0
\0\n\0\n\0\0
À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0ð\t\n \0\n\0\0\0\0\0\0\0\0\0\0\0\0\n\0\n\0\n\0\0°\0
°\n\t¬°
À\0\0 \n\0\0\0\0\0\0\0\0\0\0
\0\0\0Ð\0\0\0šÀ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\n\0\0\n\0\0\0\0\0\0\0\0\0\0\0­ \0\0\0à\0\0\0\0\0\n\0\0\0ÚšÀ\0\0\0\0\0\0\t\0°
\t \0\0\0\t\0\0\0\0\0\0\0\0\0\n\0à©\0©\0Ú\0\0\0\0\0
À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0ð\0\0\nÀ\n\0 \0\0\0\0©\n À\t©\0š\0\nš\0\0 \0\nÐÊÉà\0\0
\0 \t\n\0\0\0\0\0\t\t
\t\0\0 \n\0\0\0\0\n\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0
\t\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\nÀ\0\0\0  \0\0 \t\0\0\t©É š\0 \0\0\0\0\n\t\0©é °š\0\0\0\0\0À\0à\0\0\0\0\0°Ê¬\nË\0\0\0\0\0\0\0\0\0\n\0 \0\0\0\0\0\0\0\0\0\0\t\n\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0ðš\0\0\0\0\0Ð\0\0\0 \0\0\nš \0\0À\0\0\t\0À\0\0\0\0\0\0\0\0\t š\0\t© \0\0\0\0\0\0\t\0\t
É\0é\0\0\0\0\0\0\0\0\0\0\0 À\0\0\0\0\0\0\0\0\0\n
À\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0ð\0\0\0\0\0 \0\0\0\0©\0\0À­\0°°\0\0\nË\n \0\0°ð\0¼\0Àš\0\0É
\0
\0\0\0\n\t \0 °\n\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0ž\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\nššÚ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°
\n\0\0
\n\0\0 \0\0\0\0\0\0°œ¼\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0‰­þ','Andrew received his BTS commercial in 1974 and a Ph.D. in international marketing from the University of Dallas in 1981.  He is fluent in French and Italian and reads German.  He joined the company as a sales representative, was promoted to sales manager in January 1992 and to vice president of sales in March 1993.  Andrew is a member of the Sales Management Roundtable, the Seattle Chamber of Commerce, and the Pacific Rim Importers Association.',NULL,'http://accweb/emmployees/fuller.bmp'),
  (3,'Leverling','Janet','Sales Representative','Ms.','1963-08-30','1992-04-01','722 Moss Bay Blvd.','Kirkland','WA','98033','USA','(206) 555-3412','3355','/\0\0\0\0\r\0\0\0!\0ÿÿÿÿBitmap Image\0Paint.Picture\0\0\0\0\0\0 \0\0\0PBrush\0\0\0\0\0\0\0\0\0€T\0\0BM€T\0\0\0\0\0\0v\0\0\0(\0\0\0À\0\0\0à\0\0\0\0\0\0\0\0\0\0T\0\0Î\0\0Ø\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0€\0\0€\0\0\0€€\0€\0\0\0€\0€\0€€\0\0ÀÀÀ\0€€€\0\0\0ÿ\0\0ÿ\0\0\0ÿÿ\0ÿ\0\0\0ÿ\0ÿ\0ÿÿ\0\0ÿÿÿ\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿþÿ°\t \n\t©ªš\0\tªš¾ž°°»\t «\nš› ú¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿é šž¾¿»
°«\t¬«
Ë
©éªš°\0\0š«\t\0›ë
­¹éù°À°úÛ
ëËÀ¼¿°ð»à°› »¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿú«ëÿúßúÛð¾»¯¯»«šÚºÛà«
ËûÀà©¯©¼»šú¾à»©«ëé°û©«šš°ž
Úú\r¾Ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿°ú¿ÿ¯¯ê¼º©ðšð¹»Ëéëé­©©ú°\0
ú°ž
¯\0©­«›Ëéð¼ð¾Ÿ©ëœ©¾¯
û©­ºš¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿŸéšŸ¯ÿþ½©­¼¿©ºž¯¬°¹¯ššúë\t\0»š\0\0©¯
¼°¹éºÚú°º¾»¼žªž¾«¾¹°°¼¾šŸ­¯ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ºû©¾¾\t«þºº°ððùÛûºú°úð°¼¼\0\t

\n
¾›
Êšù©¼žŸ­\0««Ÿ©Ëœ°ú¿ðšÛþ°
ŸÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿËé«ÞûÛ¿ü«\r°» «ðý©ð©\0\t š
\0\0\0\0Ð½©¯­©½¾¿««ºÚ¿½©à¾¹ë«é©ëé«\túû¯ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ›žŸ«­¯ë
½éº»©þÛ¿
ú¼\n
þ
À
\t


úþšš\n
œðÀ°ðÊÚ¿\n»Ë

Ëë\nšúšž›ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ«©ùúðü¼«
éÚ»«Ëú\t
\t¿ï\0š
\0 \0ð°

éë¯Ÿ¿»»«°Ÿ«°ù¯©ûÏ¼°é¹©úÉð¼Ÿ
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿËðÚ\n¾º»Þù¯»­©Ë\n
Ê\0ºð¿þ›©\0°šËºÿ
­° ºÚËÞœ ¼
ªðû®°

šž¹«¯««¾¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿû
©¿ºËžÚ°ºù®šŸ©\t\0\t

ûþ\0° \0\t©°­°¾\n™­«û«ê™ ¿šðÿ
úÚ›«¾¼¼ž
Ïÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿúžšð¿ë©ë¼š\t¼ \0 šš¼¹¿þé¯
\0ºûë›¯
¯ù¬°¿¬½»àÛúùë

é\t©›\0¿
\n«Ë«Û¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿû
©¯¼¼»ë¼«­\0\0\t¬°ªŸð°°\n
É\tž¼°¯š¿
›ªœ° ª¼¾½¯¯\t¾ûùË°¼ ßÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûðûÚ
«é¹°úš°\0 
\nššŸž¿à¼\0\t\t\0º›ë
«Ë°¼°ûëÛúž›úÛË© ¾»°é¯© 
é©¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð °ëûËž»¯
É
\0\0\t\t©à»þé\0°Ú\0\t\0ú


¾›
ë
\n° ð»À©šºÐ¿ùë\0šžºžŸ
ÊÛÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿé½¿»\0¾
¬šúš¿àš\0š
Ë©®¾«\0©\nš¿¾Ÿ\0üšëÉ\t­¹ëû
À°šéË\n\n¹ë\t«© ú«ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿû\n\0¾›é›úð«\0\0\0\t\t
ûþ
\r©\0\t
Ë©\n°¾¹
¯­º°ëë«ëÉªšš¿ú\0šž°žšúÚœ©Ïÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿü¹ûššé¾úù©«ëž¼°\0\0 °¾šÿ °\n°úÛ\0›®šÛ«û¿\t¿\0°Ððë\0«\të\r©\nšð°°Ë\0¹ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿû\n\0ëË›ë
 ð°šé
\0°\0©\tÿð\t \0 ù©º°°¿­ Ðð°ºšž\0¯\n
©¼žš°š\t©ÊšÚÊ°¼ÿÿŸÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿþ››°¾žžŸ
Ëë¹Ë\0
°ú«î
ž\t

Ûºðéšé

«\t¯Ú¾šÛššž\0©Ð ž
\t©  \0\t¿à\0Ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¬¾
©©«\0°°¼
Ê°°\0\0\t¯¾šž\t\n\0\t«ï«º°\tºÚðš¾š»Úû¯©é­\t
\n ©Ë\t\0°ÚÛ
\0\t\0¼\0\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ»šÛéúžž°šž
Ë
ûí© ©©
ÀÛ
\t¯°
ËË
Ëë
Úž
À ¼\t\n°š›\0° \0\t\0\t\0\0\0\0\0Ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\0©ªš
ð°¿º¬°°ð°°\n«¯é\nÚ\n\0Úû
 ¼\núÀ¼°ºÚ°°þº°
\t\0¼©Ë\n\0 \0
\t\t\t\0\0\0\0\0\0\0›ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿþ›ðùúÚ
¿ðé\n™«Ë\t
\0¹þé\0\t¯ªššŸ\n›»

É©ëÛ
ž
Ê\0º\0š\0°š\n\0\0\0\0\0\0\0\0\t\0\tÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ©©«
¿

ž½®°à¼šð°Ÿ\nšš\t\nšŸ¯Ë°°°¯š°°º°ð»ð°©©\t©\t\n\0\0\0\0\t\t\0\0\0\0\0\t\0\t\0\0\0¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¼¾šððšúð©ê©
\t
\t©

¯\t\0\t ›éºšû¼\nð°©Ë\r¯«à\0\t\0\0\0\0 ©\t\nš\n\0\0\0\0\0\0\0\0\0\0\0\0Ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\t©­¿
¾›
¾»Êš\0ššÉ ¾º\0\t ¾»àŸ\0\t©
«à°°º»Ë\t
\0\0\0\n\t\0\0\0\t\0\0\0\t\0\0\0\0\t\0ŸÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿþšŸ\n\0«é°ú\t«À¹à©ù­©©éÐ©\0
Ú\r û¾ž\tùú

ËË­\n\0\0\0\0\0\0\0\t\0\0\0\t\0\0\0\0\0\0\0\0\0\t\0\0
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿý© ¹Úœ¹ë
ÚÐ»À°\0©
ðº©©©\0šº¯ú» ©©  ½¬›\t©¾š\0\0\0\0\0\0\t\0\t\0\0\0\t\0\0\0\0\0\0\0\0\0\t\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿþšÚ\n\t«\n
à°©à°


\n\tà\0°\0°¿ð°ùù¾šž›ê› Úž\té\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\t¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿþ\t©¼šœ¾žŸ
\t©­\0°œ


Éªš\0ššÚ¿­ªº¼¼°ž¹À\t© ›\n\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0œŸÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿðšœ\0©\n\t©  ¼º\r\n
É©©\0¾šÉ\0¼¿¯«Ë­©ºš\n›Ê°ð° \t\0\0\t\t\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¾ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿŸþ©©\n°šš\rº\t°
ž\tð© š\0

ýëéûëï­\0°\t\n
Ë\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿
ÿÿÿÿÿÿÿÿ¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿþ¿ú\t\0\0\t\0\0\0\t\t \t  
\0©\n\0š\t©­ ºÛ°©ð›š
­°©¼°\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tþ
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ©\t\t\0\t\0\0\0\0\0\0\0\0\t \t\t ›À¿ðšÀ\t
ÿ®
ù«¾à°©ð\n\n\t\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ðŸÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\0\0\0\0\0\0\0\0\0\0\t\0\t
ð\tà

 ©
\nšúšº›úºÐ
ÿ\t\0º ð°°\0\0\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t©íÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\0\0\0\t\0\0\0\0\0\0\t\0\0\0\t\0\0\0°°°¾ËÚ\0Ëž¿ðð\tËº°¾¾ž\n\t\0
\0\t\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0š\t¿\n\t\n
\n»ëï¯ë¼¹­¯\0©¯\t\nšž\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\tÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\nš\0Ÿê›Ê»ÿú¿
Ëê°¿ë\té ©\0\t\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\tÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÀ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0šðÚ\tÿëíúžº™¯
ðš¾\t\0šš\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\0\0\t\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0š\0¿
 š™»ú«ÿ»
é¼ºðþ\t
Êš\0\t \0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\t\0\0\0\0\t\r
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿþ\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\n
É­\0 \0¿¼¼¾ðºûË«
«Ë¯\t\0šš\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\nŸïÿÿÿÿÿÿü¿ŸùÿÿÿÿÙŸŸÿÿÿð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t¾¾©\téð»ÿ©ëÉ°°¼ðžð¼š\t \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\n™ëÿÿÿþù©¿Ÿùùðð½¿ÿ°ûŸ\tÿÿà\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t
®\nº»¯¯êž°º¯ë\0¯¾š\t\0š\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0œ\nŸÿÿÿ¹ÛßÛý¿¿Ÿ½¾™Ûœ¹š™ð\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tû¯\t žžž¼°éëÚ°ÚùÊÿéà° \t\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0°
ÿþÛ¿ý¿ßŸ½Ÿ›ÿ«ÛûÛÛ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\nž Ÿ
úúþ»Ëžž¿
¯\n¹ºúš\t\t \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
Ëü™\t°ûÛÿùûéÚùý¹Û½½¼¿™­ \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0›ï š\0¿
é©à°©©à°\tïé¬ \0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0°\t¬¿½¯Ÿ½ÿ¿šÛŸûËÛÛðŸ\t\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t©©\t­
\0­Ë\t\0ššž\n¿úž° \0\0\0\0\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t ™\tùûÿùùÿ™ùýùû½©¹°¹\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\nðé\n¼¿¾°é °\n\0\t\0É\0\0¾ðù­ \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0©ð›Ÿ›ûÿ›ÿŸ»ÛßûŸŸŸ«ÙË\t\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t©\nÚ\0›Ë°ð\t\t\0°\0
\0\t¯\nð\t©\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\t\0›ûËý½ùü¹ûßŸ¹­ùù°Ù©¹\0\0\0\t\t\0\0\0\t\0\0\0\0\0\0\0\t\0\0\tà°ð©úê°Ë
\0\0\0\0\t\0Ð\0\t¯\0°\0\0\0\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0½¼™ûÛûùûžùûÿŸšß›½žš\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\nš
Ë\nÚ\0Ÿ°\0š
\0šÀ\0\0\0\0\0š\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0¹¯½¿ý¿ŸÛßùùÿÛù½¹½
\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\t­ ¹
Ë\0\0\0\tÀÐ\0\0\0\0°\0\0\t\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¹Ë¿ùŸŸ¹ù¹ÿû›ù¾Ÿ
ËÐ¹¹\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°©©© šž\nÐ°\t¬ \0\0\t\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\t¹ëÛŸ¿ûÏ¿ÿ½½ÿžùùý»›ÐÐ°\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0\0\0\t \n\0\nš\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\t\0\n©ùùÿ›ÛŸ›Ûëù½›ž›œ™© \0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0 
\0°šš\t ©©\t\t\0\t\0\0\t\0\0\0\0\0\t\0\0\t\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0™©Ÿ››ùý¹ùÿùùÿÿ¾ÛÏ›œ›\t \0\0\t\0\0\0\t\0\t\0\0\0\0\0\0\0\t\0\t\n\0\t\0\t\0\0\0\0°\0\0\0à\0\0\0\0\0\0\0\0\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0žšÛ½ù¹¹ð¿›Ÿ¿›™ùù¹í¼¹\tÀ\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\t\0š\0\t\t\0\t\0\t\0š\0 \0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0šÙ½¹ÛžŸŸ›ß›ÛýïŸÛ››œ°¹\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\n\0\0\0\0\0\0\0\0\0\t\0ÀÐœ\t\0\0\0\0\0\0\0\0\0\0\t\0\t\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\t›Ûž¹ùù°¹ùûŸ
¹­¹°žžš \t\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0\0\0\0\0\0\t\0\t\0\0\0š\t\n\0À\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\tššž™Û››ÛÛž™ù©½½ù¯ß›™É°\t\t\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\t\0\0\0\0\0\0\0\0\t\0\0š\0\r\r\t\t\0\t\0\0\0\0\t\0\0\t\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tÛ™ûÚÚ›ŸŸ¹¹ù½ºŸ™©í°°Ù©\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\t\t\0\t\t\t\0ÊÀÀ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t©©ùù¹›Ð¹\t\rŸËÙð¾Ÿ™›\nœ©\0\0\0\0\0\0\0\0\t\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0œ\0\0\t\0\t\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\t\tÙ­¯šÐ½
Ð½¹ù©¹
\rùºðÙ\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0°\r\0š\0\t\0\0\0\0\t\0\0\t\0\0\0\0\0\t\0\0\0\t\0\0\0\0\t\0\0\0\0\0\0\0\0š›Û™\tŸ
½›

Ðùù¹­«Ù›Úš\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\t\0\0\t\0Þ\r\r\0\0\0\t\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
É¼›
Úù
¹
\tË™Ð°œ¹\r
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0šÚÐ\0\0\tÀ\0\0\0\0\0\t\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0›
œ™\t
Ÿš¹ù°»Ð¹ù¹


\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\r­\tÀ\0\0\0\0\0\0\0\t\t\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\t
Ù©¬°½\t\tÉ

Ù
Ð\nœ½©™\t™\t\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0žÏ\0À\0\t\0\0\t\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0ù¼™ššÚšÐššŸ½
Ÿ\nÐ
Ë\t\t\t\t\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0œÐ\0\t\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\t\t


\0¹\t™š›\tÉ\t
Ðù©™
\0š\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\téÀ¬\tÀ\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°°\tœ›Ðð°ùùÛ›Ú›Ðð©É\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\té\t\0\0\t\t\0\0\t\0\0\0\0\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tÐ\t½©©
›Û°ù¹­­¹éë›\t­©°\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0À\0ÀÀ\t\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\t
™›œ™œ½™¼Ÿ›ÛÞ­©\t\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\t\0\0\t\0\0\0\0\0\t\0\0œ\t\0\tÀÐ\0\0\0\0\0\0\0\t\t\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\t
\0›é\r¹¾›šß››Û½¿ÿ
›ÚÉ© \t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0¬\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t ™°™¹¹™¹ù¹½½½ÿùðý­©šœ
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\t\0\0\0\0\t\tÉÉ©\0Àé\0\0\t\0\0\0\0\0\t\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0™
\r
Éùù›ß›ßÛ›ÿûßÿ°™ù­°\t\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ì¬\0À\0\0Ë\r\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\t\0\0\0\t\0\t©›™›\t½½¹ù»ÿßŸß¿ŸßË©\0\t\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\t\t\0\0\0\0°Éé\r\r
¼\0\0\0\0\0\0\t\0\0\t\0\0\t\0\0\0\0\0\0\0\0\0™½\tûß›Û›ÛŸÙ›ÿÿÿßÿ¿½°ùžš\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t \0ÉðÀÊÀ\tÉÀà\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\tðš›\t¹ùùù¹Û¿ÿÛý¿ÿûßÞÛž™\tÀ\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\tœÀÉ\t\tÉÎžœ\0\0\0\0\t\0š\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
\t½½ŸŸ¹½½¿Ù½½ÿÿùýÿ½°ù¼°°\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0ËÊ¬¬ÉËÉé\0\0\0\0\0\0\0\t\t\0\t\0\0\0\0\0\0\0\t\0\0\0
°›\t¹›Ÿ›Û™¿ÛûÿÿÿûùþŸ
É\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\t\0\0œ\rÀðÐéÊÀÀÀÉ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0°Ÿ\r¿
Ð»™ù½½›½½¿\r¹ŸÿÛÿ›Ù°¼\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0Àüœ\r\tÉ \0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t©™¹¹\t¹Ùé
Ú›™ùéûßÿŸ¿ÛüºÛÉ \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÀÞÀÚÐ\tÉÊž À\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0šÚÙéùû
›™¹\tš›\t™½»½¿ùéé½›\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\t\tÉéÀéìœ\tÉ\0œœ­\0\n\0\0\0\t\0\t\0\0\0\0\0\t\0\0\0\0\0\0
Ù¹
››\tÛéÛË¹™\rŸŸßÛùÿ¿Ÿž¹üž\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¼ÍÀðÐÚÐéÊœ\0\tÊÐ\0\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0Ð°Ÿ©›Û™›\t™Ë¹ë°¹¹é¿ùûßŸÚÙé«\t™\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0É¬¼ÊÞ­àÐ­\nÀ\r\r\n\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t
Ÿš›Ÿ\r¹­¼›Ë™Ð™Ùùù¿ŸŸýûž½»ÛÙü \0\t\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\tÜÌ½àÐÉÊÐÍ
Àž\r\0š\0\0\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0¹Û½©›Ÿ›™¿›Ÿ
Ú›\tÿýÿÿÿ½ÿŸ¼½¿
Ð\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Í
°ÎÊÚÐ\0Éàð\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0½ž¹
\t¹ùðŸŸ™\t™™™Ÿ™ÿÿÿŸÿ½¹ùûÉùé\0\0\0\0\t\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÚÌÉéÀü­\0ÚÐšËÀÐ
À
\0\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0
™¹ù½Ÿ›Ÿ›¹ù©¹½›ß™ùŸÿÿÿßðð›ËùËÚ\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\r­žœ­
Ï\r­Ëœš\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t½­ž›ð°½¹½Ù™™ÙÙù™Û½ÿÿýÿŸ›ÿ½¿¿\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÀÜÀàÐìÊÀàÚÉÉÀé\t\0 \0\0\0\0\0\0\0\0\0\t\0\0\0™é¹¹Ÿ™½¹½¹¹Ÿ™™™\tŸßßÿÿ¹ûŸ›Ûðùù\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0ËÀ­\r\tì¼¼œ\r Ðí ¼\n\0\0\0\0\0\0\0\0\0\0\0\0\0\t
ŸŸÛù¿™ÛÚ™Ë\t™››\t¿™™Ÿÿßýý¹ÿ½ùÛÛé\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0œðžÀàÀÉÊÐéÜ\0é\0\0°\0\0\0\0\0\0\0\0\0\0\0½©ù½½›é™½ù™™\0¹ù¿ÿð™\týûûÛÛŸûÿ½­ðð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0ÍÉéÉž\rÀËœé©­\0ð\n\0\0\0\0\0\0\0\0\0\0\0\0\0ŸŸšù¿½›é¹¹¿¿ÿ¿ÿÿùÙ¹ý¹
ÿßÛÿÿ¿\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0žž\nÀÉÀðœÉàÀÐ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tù›ß™ùÛ­™Ë\t
ŸŸÿÿ¿ÿÿÿÿ\0™›ûÙùÿÿÿÛßÉÉ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0ÐËìÍ\r\tàðÀÊÀ¼ž
À\0\0\0\0\0\0\0\0\0\0\0\0ššù¹¿›½››\t¿ùÿÿŸÿûÿÿð\0\t™©›Ûûùÿÿÿ° \0\0\0\t\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0íüžšÀÚœ\0œ
ÀÐ\tÀ¼é\0\0\0\0\0\0\0\0\0\0\0\0\0\0½½½¿›ýûÐð\0›Ûù¿¼
ÛÐ›¹\t\0\t½½ýÿÿùýù\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0éìžËÜÐ\r©ÌžÀ\t\0\0\0\t\0\0\0\0\0\0\0\0\0Û™½¹Ÿ›¹\t\0\0°\t\t\t™\t\t\0\0\0š\tù¿ÿ¿ý¿þž\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0ÞÐœÉàÐ¼Ê\nÐÌé ÐÉÐ\tà\0\0\0\0\0\0\0\0\0\0\0\0\0™©ûÛ©¹û\0\0™\t¹\t™°ù½ï™Ÿšœ™™¿›ßÛÿùð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0š\0\r­ì¼œ­à¼Ü­©Ü­¬¬ü\0\0\t\0\0\0\0\0\0\0\0\0\0\tù\tùûÛß¹
Ÿ\t\t\t\t™™™ŸŸÿý°Ÿ
Ûýû¿Ÿß½©\0\0\0\0\0\t\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0Àð
ÊËÀÜË\r\0ÎšÐÐ\t\0\0\0\0\0\0\0\0\0\0\0\0\0
Ÿ¹š™¹¹¹ž¹ù¼¹Ú¹ý½ùÿÿÿùÿÛ\t½½»ŸÝ¿¾ÛÐ\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\t\0\0\t\0\0šÏÜœœœÊ\r\tÌËÉ\0\0\0\0\0\0\0\0\0\0\0\0\0\0ùÛÙ½Ÿ›É½›¹Ÿ™›Ÿ›Ûÿ¿ßÿÿù©Û\t›Ý¹ûýÿÛË\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\tÊÐÊ¼\rÚ©¬ðÌ\0\0\0\0\0\0\0\0\0\0›ð\t›¹¹¿Û¹¹¹›¼›™ùÛùù½¿ùÿÿŸ™¹Û½«ý½ûÿþ\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0É­\rÀðÉÊÐÊ\tÉÐ\r©íé\0\0\0\t\0\0\0\0\0\0\0\0
ð\0½\t¹ÉùÚ½™©ù¹¹›¹™»ÿÿßùùðÐ¹ÛŸ¿Ùý½ù\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0œ¼ÞÐ\0ðœ­\ršÀÀ\0\t\0\0\0\0\0\0\0\0\0\t\t\t
™¹½›¹šŸ›\tÐ›ÉŸ©\t¹ý½ùš™¹Ÿ¿ûÿÿûí©\0\0\0\t\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÀÀéïÉÉÀÐ\n\t\tÀÐÚžÎ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0½½Ÿ›\rŸ¹¹\t¿›Ð›
›™ù
Ÿß½úŸŸŸ\r¹¹ùÿ½ÿÿßÛ\0\t\0\0\0\0\0\0\0\0\0\t\0\t\0\0\0\0\0\0\0\0\t\r\rœœ\nÉ¬°é¼œ¬­¬éÌ\0\t\0\0\0\t\0\0\0\0\0\0\0\0›™ËšÙùð›šÐ›Ù\t
™™Ë\t¹ÿÿÛýð½\t»ŸŸ½ÿßÿýÿí\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0ÀðÊÞÍ\r\0ð©\tÀÐœ°É\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\tË¹ùÛ›™ùÙ›››™éš›Ù½Ÿý½½¹¹¹ùÛßÿÿÿý»À\t\0\0\0\0\0\0\0\0\0\0\t\0\0\t\0\0\0\0\0\t\0žœÍ©¬žÀðÏ\tÎÚž\ràÍ \0\0\0\0\0\0\0\t\0\0\t\0\0\t\tÿ›™ùù››Ùù\tÙùš™\0›\t

ûß›Ù›ÛÛÿÿÿÿÿÿÞ™\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0ÉÀ¼üÐéÀž\r Þ\t\0ÉÊœ°\0\t\0\0\t\0\0\0\0\0\0\0\0\0\0»™½¿Ÿ™ù½©°™\t\0™\t¼\t¹½°™ŸŸŸŸßÿÿÿýûÊ\t\t\0\0\0\0\0\t\0\0\0\t\0\0\0\0\0\0\0\0\0\t\rœÉËÊÐéàÚÍàÚÊÐéÀÀ\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t©½›ÛÙ½ûÛÛ©¹\t°œ°™Ë™ð››É\t¹ù¹ûÿÿÿÿÿÿí\t\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\t\0\0\t\0šÀÉž¼\r¬œž­­©\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0ÛùùûÛ½½¹ÐšÙ\t°\r›
™ù™½ÿÙ¹¹Ÿ™ÿýÿÿÿÿÿÿßð\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\t\0\0ÀÜ¼ÚÍÏœšËÀðéÀð¬\nÐÐÀ\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0›™¹ûß½¿›ÛÛ½™
\t™°™¹›ßÿÿðÐ¹ùŸÿÿÿÿÿÿÿüÚ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0œ\tÀÍ©àÊÐž\r¼\rÉí\t\0\0\0\0\0\0\0\0\0\t\0\0\0\t\t\tÿù½½½½½¹ùÙ©™\t›Ù¹½ßŸÿÿÿÉ¹ù½¿ÿßÿÿÿÿÿÿÿ°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0©ìž¼ÞŸ\tÉ àÚËÀÚšÀðÜ\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0›ù½ùûÛÛÛßŸ›°™­›ÛùûÿÿÿÿÛ¹ù½½ÿÿÿÿÿÿÿÙ\r\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÜÚðÐðüÀ¬\r
ÉžÍ­šÐ \0\t\0\0\0\0\0\0\0\0\0\0\t©ŸŸŸ½¹½½¹ûùù
\t™½½›½ÿÿÿÿ\r›Ÿÿÿÿ¿ÿÿÿÿÿÿÿð\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\t­­ÉïË\r\tàÐí\t
\0ÚÜàÀ \t\0\0\0\0\0\0\0\0\0\0\0\0Ÿ›ûùÛßŸ›ßŸ›Ùù
ÛÙûÿÿÿÿ›ß›ÛßŸßÿÿÿÿÿÿü¿\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0Úþžðþ\0\r­\0àÊÀÚ\r
Íé\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0°½ŸŸ½¹¹ùùûù½¹é™½¹½™ÿÿÿý›»ýÿûÿÿÿÿÿÿÿÿûÐ\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\tíðÿ­šÚÀÞœœšœ¬Úœ\0\0\0\0\0\0\0\0\0\0\0\t\0\tŸŸÿŸŸŸŸ›ÛùÛÛÛ™©ÙŸ›Ÿÿÿÿÿýýÿ¿ßÛÛßÿÿÿÿÿßž\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0°þðÿÀ\r\0À \r
Êßð\0\0\0\0\0\0\0\0\0\0\0\0š™ùŸ½½½¿ÛŸŸ½¹½½›¹ÛÛßÿÿÿÿÿ¿ß¿ÿÿÿÿÿÿÿÿýé\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\tÏùý¯ÚÉž\0Ú\ršÀœ\0ðÎ\0\0\0\0\0\0\t\0\0\0\0\0\0\t©ÿ½ùùýýùùù½¿››ù™ÛÙ½¿ÿÿÿÿÿßÿßŸ™ûßÿÿÿÿÿð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t¬œ¯¯Úÿ\0ÉÉí¬ËšËÏÎ\0\0\0\0\0\0\0\0\0\0\0\0\0ŸŸß¿››ÙûŸŸ›Ùùù
Û™¹Ûßÿÿÿÿßÿÿùùÿ½ÿÿÿÿÿýé\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tÉëÜð¿Ëžœ\rÉ¬œ¼\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0™½½»Ý½½¿Ù¹¹ŸŸ›™ù©ŸŸ›ÿÿÿÿÿÿûŸŸŸ›Ûûýÿÿÿþ\0\0\0\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÞžÍ¼ü¿Ð\r\r\nÚÐ\r ÐéÊÞ\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0›Ûý»ÛÛÛŸÝ½¹›ùßŸ¹™ù¿ÿÿÿÿýíðùûÿýýÿÿÿÿŸ\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0É
ÉÍ«Ïð¬ÐÀìÐÚÉÎœ\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\t
½¿Ûùù½©»ÚŸ\tš›\t¹ŸŸŸßÿÿÿÿË›ŸŸÿÿ¿ÿÿ¿ÿé\t\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0üÜ¼¼Ü¼\t\rÉ­­\t¬ž\rËÞ\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tÿ½½»ÛÛ\t\tÐž™ùÙù½¹¿ÿÿÿ™½¼¹
›ßýÿÿÿÐ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0ÀÉéïÊÀ Ì¼ÉéàÐ¬\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t¹ù¹½¹½šš™
\t°¹«›ÛßÿÿýÐ¼™\n°¹þÿŸ¿ß©\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\r­\r­Éœœœ°ðÀ¼\r¬Ðü\0\0\0\t\0\0\0\0\0\0\0\0\0\0ŸËùùš™Ùš©\t\tÐÙ½¿Ÿÿþ¹\t ™\tÉŸŸŸŸÿÛûÛ\0\t\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\t\0\0\t\0ÀÀÚÉï¬\0É\r¬
ËÀÚÍ\0à\0\0\0\0\0\0\0\0\0\0\0\0\t
½¼¿¹Ù°°™©¹¹ÛÛÿÿý\0š\t°ýûÞ¼½¼\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\r Í­ðÐžœ ÐÐÐÞ\ršß\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t››™Ûš\t
\0\0©\t\tŸ¿½ÿÿÚ™\t\t
š™œß¿™™¹ \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Í\0ÞžÀÊÉÀÍ¬¬¬ ÐìÀ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¹ð°°½›É
Ð™°ù›ßÿýð°\t\t\0\0¯°Ð™ šÛÉ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0íéí\r\0­ ÉÉÉÍ¬žžÐš\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0°ð\0¿ \t\t©›ý¿ÿþ™ð\0ð\0ß\0\0™ù°°\0\0\0\0\0\t\0\0\0\0\0\0\0\t\t\0\0\0\t\0\0\0\0œÌœ\rëÐÊÉÀÐšÀü¼ÚÉéÊ\r\t\0\0\0\t\0\t\0\0\0\0\0\0\0\t

°\0\tß\0™»Ûÿùà™\t
É\0\0\0©\0›\t\r\t\0\0\0\0\0\0\0\0\t\0\0\t\0\0\0\0\0\0\0\0\t\t\0\0É ËËÍÊÐœ\t àž\0À­ðÌ°Ú\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0™

\0
À\0
à\t©\t©ùÿÿÿ™ \t \t\t\t\0\té\t¹
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0É\r\rÜ¾\tÀà¼\r\ržÚÜÛÍà°É \0\0\0\0\0\0\0\0\0\0\0\0\0šÐ\t\0š\t\t\t
»Ûÿùà\t\0\0\0\0\0\0žžœ°\t\0\0\0\0\0\t\0\0\0\0\0\0\0©\t\0\0\t\0\0\r ÀÀ\0ÐËËí¼œ
ÀÊž\t\rÊý¬ž\0\n°À\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t©\0™À\0\0\t\0\0\t\0\t›Ÿûùÿ\t\0\0\0Ÿé\n™©\t\0\t\0\0\0\0\0\0\0\0\0\t\0\0\0\t\0\0\0\0\0\0\t\0\t\0žœœ¼ŸéÊÉÀÚœ\tÎÊœÛéÉðÝë\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0šÛ
\t\t\0\0\t›\0ù¹ùÿ½ùÊ\t\0\0œŸ½\0™
Ë\0\0\0\0\0\0\0\0\0\t\0\t\0\0\0\t\0\t\0\0\0\tœ\0ÉÀÉÏÐÚœ­Àü©\rËÉàÞžËúü\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\t\0›ÚÙËš\0\t ›™ÿ¿ùð¹°\t\t°¹ \0›Ëð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0œ\0\r¬¼üÊÊÀÎœ¯Àœü¬žÍéì½¯À \0\0\0\0\0\0\0\0\0\0\0š°\t °\0\t°Ÿ¹ŸŸùð\t\0\0\0\t\t \t\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\t\0\t\0\0\t\0ÐÀÐÉËË\r\r­\tÊÐ­à\tËíÛïÿ\rœ\0\0\0\0\0\0\0\0\0\0\0\0\t\tÙà™\0\t\t¹Ÿ¿ùù\r°\t\t\t\t\0°\0\0\0\0\0\0\0\t\0\0\0\0\0\t\0\0\0\t\0\t\0\0\0\0À\0\r¬ðþœ\nÚÐüúÞÞœšÚùíûïï\nš\0\0\0\0\0\0\0\0\0\0\0\0\0\0©©°\0™\t\0\0
\t™ù¹é°\0\0\0\t\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\t\0\0\0\0\t\0Ðœ\nÐÐÐÞŸÉÊÜÀ\r­¬­ïýï¿¯ûÚßí\0\0\0\0\0\0\0\0\0\0\0\0\t\t©\t\t\0\0\t\0\0Ÿ¹¿ŸÿŸ­\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0œ\0\réœ­\0¼ðÐþðéÞ¾¾¿ïÿÿíúÚ\t \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t™¹™ùûùÚ›™©\t\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0œœ\0ÀœððÞžéÀüÉ\r­\rÐéýÿÿ¿ÿïúß­\0\0\0\0\0\0\0\0\0\0\0\t\t°\0\0\0\t\t
éÚÛŸŸŸ¹ðð\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\t\0\0\0\0\0°\t\0\t\0\0œ\0\0ÐÀ\rðÿËí
Î\nÚÛíàËïþÿïûÿëÚ\0\t\0\0\0\0\0\0\0\0\0\0\0›š\t\0\0Êœ››ŸŸ½ùùÛŸ›Ùð\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0Ð\r\0©\0\0\0\tÍ\tÀœž­ËìÚÜ¬šÜ¼¿¿ÿÿþÿ¿àÐ\0©\0\0\0\0\0\0\0\0\0\0\0\t\tÉš½©™¹ûŸß›ÛÛÿ›½¹é
\0\t\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0É©úžÐ\t\t\0\0À \tÀ
\0¼éÍ­ß¯ÉíàÉéÉíËÏßïÿûÿÿïé\0\t\0\0\0\0\0\0\0\0\0\0¹¹¹Û›ùûß¹Û›Ÿ¿ÿùÿÛß›\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0úßËÞð\0\t\0ÐÐ\t\rÀœúßêÛþžœ¼žž­É¯ÿïþÿÿÿž\0š\t\0\0\0\0\0\0\0\0\0\0\t\tšÛ\tù›ùûßûýùùùÿù¿
ŸÉ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\rëþûï\rË\0\0À\0\r\t\tÀË\rúì¿ëíËÉ\rÊÏÉÿÿÿÿëþþþ\t\0\0\0\0\0\0\0\0\0\0°Ù½½¿¿Ÿ¹½Ÿ¿¿Ÿ¹ÿŸŸ\t°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ß¿þžÚÌœ©\tÀ\0ÀÀ\r\0ÜðßÊÛðÿú¼ÚÚœ¼¾¿ÿÿÿÿÿ¿É\0\0\t\0\0\0\0\0\0\0\0\0\t\t¹
›™ûÙûßûûÛÛÛË©½°\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0úÿûý­œ\tÉ\0ÀœÚÍž¼œžÏÿÍéÉïÉíþÿïþÿÿü°\0š\0\0\0\0\0\0\0\0›\tùÿŸ¹ûÛÛ™ùýÿ½½š\t\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\r½úüúÚÐÉÀÉ\0\r\tÀ\0ÚÉËÏËÏžžðúžÞ¼À¼ÚÛÿÿÿÿþûÀ\0\0\0\0\0\0\0\0\0\0\t\t\tÚ›™¹Ûß½½¿Ÿ››ÛÛÉ°š\0\0\t\0\0\0\t\0\0\0\0\0\0\0\0\0\0\t\0\0úÿ¿ÀÉÊÉ\t\r\0 Ü\r­íðí¬¼ùïÞËÉËÜÊÜ­ûÿÿþÿþð\0\t\0\0\0\0\0\0\0\0\0\0\t©™ðùû½¹û›ÛŸŸœ¹©°\t\t\t\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ßÿÿðýàÜ°À\0ÐÐÐÐðÿúßÏŸ¯¼úÌ­­­Ï¯ÿï¿ÿÿðð\t\0\t\0\0\0\0\0\0\0\0\0\t©››\rÛÛÛÛùÛž¹Ÿ\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\t\tëÿëÏ\r\0œÐ\0Àœœ­ÿúûþðÿÏÚÚÐÀÚßïÿÿ¾ûï\0\0\0\0\0\0\t\0\0\0\0\0\0©ÛÛ»›ŸŸ™»Ù°›\t\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿ÿ½ðÚÐéÀ\tÀ\r\0ÐÀÊÜðÿûÿþûÿëéï\r\ràùí­¿ÿïÿÿýð\t\0\0\0\0\0\0\0\0\0š›ÛŸŸ½½¹ÛÉš›\t \0\0\0\0\0\0\0\t\0\0\0\0\t\0\0\0\0\0\t\0\0\0\t\0
ßÿþ¾Ü\r\tÀ\r\tàž\r­\r­­ðþÿÿþûßžž¼àÜÌ\0ÞËÿÿÿÿúü\n\t\0\0\0\0\0\0\0\0\0\0\0\t\0¹¹»Û›Û¹¹½\t\t\0\0\0\0\0\t\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\t¿ÿÿËËÀÐÀœ\0àœ\r\0ÐàÐðÿÿþ¿ýþëïýí½­©ü­ŸËÿïþÿð\0\0\0\0\0\0\0\t\0\0\0\0››ÛÛÉ¹ù½ŸšŸ\t©\0\t\0\t\0\t\0\0\0\0\t\0\0\0\0\0\0\0\0\t\0\0\0\t\0\0\tïÿÿ¼¼ËÀ¼Àœœ\0ÐÍéÏÿ¿ý¯­½ûúúÎÊÜÀÐì¾ÿ¿ÿúÚÀ\0\0\0\0\0\0\0\0\0\t°Ð™¹›Û›é¹°Ù\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°\tÌŸÿþûÏÌÉÀ©À\0Í\0ðÎ\réüžü¾ÚÚúþÿÿ½½­­éÉÍÿÿÿïœ\0\0\0\0\0\0\0\0\0\0\0\t›ËÛ½½­™¼™ \t°\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\t\0\0\0\0\0\0
Ï¿ûþùéí\r\tÍ\nœÐÐÞžûéëÉííÿûÿÿþþÚÚÞžÉï¾ÿúûÀ\0\0\0\0\0\0\0\0\0\0\0\t\n\t°œ›››½›É™ \t\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\t\0\0žÿÿûþœ\0ÐÀÉÀ\nÐÉÉ¬­©éÏÏÉï¿¯ÿëþÿ¿ÿÿéí¼¼½ÿÿ¿ü©\0\0\t\0\0\0\0\0\0\0\0™\t¹¼›ÐÐ¹
\0\0\0\t\0\0\0\t\0\0\0\0\0\t\0\0\0\t\0\0\t\t\0\t\0ËÿÿÿËííÐ­\rœ¬ÐÜÞžûéûïÿ¯ÿÿ¿ÿ¯úÿûíðþûþþÚ\t\0\0\0\0\0\0\0\0\t\0\0\0\n™\r\t½››š
\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\r¿ÿÿþ¿\r\0ÐÌ\0ÐÀÉàÉÉééí¼ðùÿïÿ¿ÿÿÿþÿÿÿûïûïÛïÿûÿÀ\0\0\0\0\0\t\0\0\0\0\0\t\t\t\0¹°™©\tÉ\t\t\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\t\0\0\t\0\t\0\0\0\0\nÛÿÿÿüðÏ\r\t­\rœœ­Ï\rêÿÿï¯Ÿ¯ïÿÿÿÿÿÿÿÿÿÿûïûÿþûð\0\0\0\0\0\0\0\0\0\0\0\tË\r›Ú™ \t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0ïÿÿÿ¿ÀÀÀÀÐÉéÀéëßúûÿïÿ¿þûïÿûþÿïÿïÿûÿïÿ¼ð\0\0\0\0\0\0\0\0\0\0\0\0\t
\tšœ™\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\t\0\t\0\t\0\t\r¿ÿÿÿÿééË\r\r­\rœžœœéÿýÿÏ¿ÿÿÿÿÿÿïÿ¿ÿûÿïÿïÿ¿Ï°\0\0\0\0\0\0\0\0\0\0\0\0\0\t
\t
\t©\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\t\0\0°ïÿÿÿÿþœÐÐÀÀÐàÉÀÍ­Ïï¿ú¯¾ÿ¯ÿÿÿÿ¿ÿÿÿÿÿÿÿÿÿ¿ï¿À \0\0\0\0\0\0\0\0\0\t\0š°\t\0\t\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0 \t\0­Ûÿÿÿÿÿþœ¼\0ÐÐÐðÍ ÚÚßûþÿ¿ÿþ¿ÿ¿ÿÿÿÿÿÿûÿ¿ÿÿÿëð\0\0\0\t\0\0\0\0\0\0\0\0\0\t\0\t\t\t\0\t\0\0\0\0\0\0\0\t\0\t\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0ÚÚÿÿÿÿÿÿùððÀÉÉ­\r¬Þœÿ¯þÿ¿ïÿÿÿïþÿÿ¿ï¿þÿÿïÿÿÿÿÉ\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\t\0\0\0\0\0\t¯ÿÿÿÿÿÿÿþÍœÊÉéÀÀÐðûËßÿ¿ÿÿÿ¿ÿÿÿ¿ïÿÿï¿þÿÿþûúü¼
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0\0\t\t¬\0žÿûÿÿÿÿÿÿéð\r¬œœ\r\rì¿úÿþÿûþÿÿûÿÿ¿ÿÿÿÿÿ¿ÿ¿ÿÿûé\0
\0\0\t\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\t\0
ÿÿÿÿÿÿÿÿüÀÐÐÀÉÉÊÐÌúÛü¿ÿÿÿÿÿÿëÿÿÿÿÿûÿÿ¿ÿÿÿÿÿïð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\t\0\0\0\t
Úÿÿÿÿÿÿÿ¿ÀÐÀË¼œ\r©Í¬¿Ïÿ¿ûïûÿÿþûïÿúÿÿþÿÿþÿúÿ½¬\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\t\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\t\0\0\t\0¿ÿÿÿÿÿÿÿí­\r\rœ\rÜ°ý­¿ÿÿÿÿÿÿÿÿÿÿ¿ÿÿï¿ÿëÿÿÿþÿé\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¬\0°\0ÛÿÿÿÿÿÿÿúÚÐÀÀÀÐÉÀÚÉÊÞÚÿúÿúÿûþûÿ¿ÿÿïÿÿÿÿÿÿÿúÿÿúÐ\0\t \0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0š\0\0\0¼¿ÿÿÿÿÿÿÿ\rÀÐÚÐË¼\rËÚßÿÿÿÿÿÿþÿÿÿÿÿûÿÿÿÿûÿÿÿÿïÀ\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\t\0\0\t\0\0\0\t\0\0\0\t\0\0\0\0\0
ÿÿÿÿÿÿÿïðÚÉÀÉÌœ\rœÊÞÚÿ¯ÿÿûïûÿÿÿëÿÿ¾ÿÿÿëÿÿÿÿïÿð°\0\0\0\0\t\0\0\0\0\t\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\t\t\0\t\t\0\0\0ßÿÿÿÿÿÿÿûÏž\r\tÀÐðé­Ëßÿÿÿÿÿÿûÿÿûÿÿÿï¿ÿÿïûÿ¿ÿÀ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\t\0\0\0°Ÿ¿ÿÿÿÿÿÿÿýéíœœœÜðü¿úûïÿÿÿïÿÿÿÿÿÿ¿ÿÿÿÿÿþÿÿïûÞ\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\t\0\0\0\0\t\0\0\0\t\0\0\0\0\0\0\0\0\0¯ÿÿÿÿÿÿÿÿïÐÉÀÐÀÐÉÉÎËðÿÿÿ¿ÿ¿ÿÿïÿþÿÿÿÿÿÿÿ¿ÿÿÿ¿ï¼©\t\0\0\0\0\0\0\0\0\0\0\0\t\0\0\t\0\0\0\0\0\0\0\t\0\0\0\t\0\0\0\0\0\0\0\t\0
\0\0\tÿÿÿÿÿÿÿÿÿûð­¬ž\r¬\r¬žððüÿÿÿþÿïûÿûÿÿûïÿÿþ¿ïÿÿ¿ÿÿûÏœ\n\t\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\tŸÿÿÿÿÿÿÿÿÿÿÏÐÉÀÐÉÀÐÀÍÉÏšÚÿÿÿÿÿÿÿÿÿûÿÿûï¿ÿÿÿÿÿþÿÿ¾ûÊ\0\0\t\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\t\t\0ÿÿÿÿÿÿÿÿÿÿþ¼œ­œœ¼­ëÏÿûÿûÿ¿ûÿûÿþÿÿÿÿïÿÿ¿þÿÿûïÿüù\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\t\0\0\0\t\0\0\0\0\0\0
ÿÿÿÿÿÿÿÿÿÿûËËÉÀÐéÀÐéÉÞœûËÏûïÿÿÿïþÿÿÿ¿ÿÿÿ¿ÿÿûÿÿÿÿÿ¿¯°\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0Ÿÿÿÿÿÿÿÿÿÿÿýüœœ\rœ\r¬\réÏ¿¿ÿÿÿïÿûÿûÿ¿ïûÿÿÿþÿÿÿ¿ÿÿ¯ÿýéà\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\t\0\0\0\0\0\0\t\0\0\0\0\0\t\0\0\t\t\0\0ÿÿÿÿÿÿÿÿÿÿÿÿ­éËÀÐ\rœœœúžðüÿÿÿ¿ÿÿÿÿÿÿÿÿïÿÿÿÿÿÿÿïþ¿ÿï¾¾\t\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0š\0\0¿ÿÿÿÿÿÿÿÿÿÿëÍœ\r¬ÚÉÀéí\rÏ¿úÿÿÿÿ¿ÿûþÿÿÿÿÿÿïÿ¿úÿÿÿÿÿÿÿÛÚ\t\0\0\t\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\tÿÿÿÿÿÿÿÿÿÿÿßÊÚÉÀÐ\rœœËÎ°þÚßÿÿÿ¿ÿþÿÿÿ¿ûÿÿïÿ¿ÿÿÿÿÿÿÿûïï­¼\t\0\0\t\0\t\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÉÉ¿ÿÿÿÿÿÿÿÿÿÿÿ¾\r¼\rœ­\rœÞŸ¿¿ÿ¾ÿÿïÿÿÿ¿ïÿÿÿûÿÿïÿÿ¿ûþûÿûûÛÊ\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\t\0\t\0\0\0\0\t\0\0°\0° 
ÿÿÿÿÿÿÿÿÿÿÿÿïÎÐéÀÚÐéÀð­é­éíïÿÿþÿÿ¿ÿÿÿÿïÿ¿ÿûÿûÿÿþÿÿþÿÿÿïé\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\t\0\0\0¼\0\tÿÿÿÿÿÿÿÿÿÿÿÿÿùéœ\rœ\rÜžÞžûûÿÿ¿ÿÿÿþ¿ÿÿ¿ÿïÿþÿÿþÿÿÿûÿþ¿ï¿žð\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\t\0\t\t\nÿÿÿÿÿÿÿÿÿÿÿÿÿþœðÉàÉÉÀÚÉËÉéÿÏÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ÿÿÿÿ¿ÿ¿Ïùí \t\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\t\0\0\0\0\0\t\0\0ßÿÿÿÿÿÿÿÿÿÿÿÿÿÿéÍœœ¼\rœü¼ûÿÿÿÿûÿÿ¿ÿúÿÿÿÿûÿÿÿÿÿûÿïÿÿÿÿûïúÐ\0\0\t\0\0\0\t\0\0\0\t\0\t\0\0\t\0\0\0\0\t\0\0\t\0\0\0\0\0\0\t¿ÿÿÿÿÿÿÿÿÿÿÿÿÿûÏœ\r\r\rœËËÏðü¿ÿ¾ÿÿÿïÿÿÿÿ¿ëÿþÿÿï¿ÿïûÿÿÿþÿ¯ý¼ðÀ\0\0\0\0\0\t\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ËÿÿÿÿÿÿÿÿÿÿÿÿÿÿüðÉÊÐàÐÐ­¬¼œ¿¿ÿÿÿûïÿÿÿïÿÿÿÿûÿÿ¿ÿÿÿÿÿÿþûÿ¿ÿ¾ûú\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0
¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÐ\rœ\r¬ÐÉÀþÐýéëÿÿÿÿûÿûÿ¿ÿÿÿÿÿÿÿÿÿûÿÿÿ¿ÿÿÿÿÿ¼ü¼ \0\0\0\0\0\t\0\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\t¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ÀÏœ\rÉÊÝ\tï¿ÿÿÿÿÿÿÿÿÿÿúÿÿÿûÿÿÿþÿÿïÿÿÿÿþ¿þÿ¿Ë\t\t\0\0\0\0\0\0\n\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿïŸž\r\0ðÍ¬ÞœúÞŸÿÿ¿ûÿÿÿÿÿÿÿÿÿïÿïÿÿÿÿÿÿÿþÿÿþÿ¿ü¼œ\0\t\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\t\t\0\nËÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÙàÉÀÚÍð\r¬éËËéûÿÿÿÿÿþÿÿÿïÿÿï¿ÿÿÿ¿ÿÿÿÿ¾ÿ¿ûÿÿ¿þ¿ÿûé\0\0\0\0\0\0
\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\t\t¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ®ÐÚÉÉÐÉÞœðßÏ¿ÿþÿþÿÿÿ¿ûÿÿÿÿÿÿ¿ïûþûÿÿÿÿÿÿÿÿÿþ¼¼¼¼\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\t\0\t\0à\0\0\0¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÛÍ\rÐËÌéÊ\réï¯½ïÿ¿ÿ¿ûÿ¾ÿÿÿÿ¿ÿ¿ÿÿÿÿÿÿÿÿ¿ÿÿï¿þ¿ûÿÿûé­\t\0\n\t\t\0\0\t\0\0\0\0\0\0\0\0\0\0\0\t\t\0\0\0Ûÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûí­àÐ\réÀÜÞžœÛÏ¿ÿÿÿÿÿÿÿÿÿþÿÿÿÿ¿ÿÿÿÿÿÿÿÿïÿÿïÿÿÿÿ¿¿ÿð°\t ™šÀ\0\0\0\0\0\t\0\0\0\0\t\0Ÿ¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿþÚÐÉÀÞ\rœ\r©éËÞ¾ûÿþÿ¿ÿÿÿÿÿÿûÿþ¿þÿÿ¿ÿÿÿëÿÿÿûÿÿÿÿÿ¯ÿÿ¿¿ëÀŸ¬¹é¼\0\0\t\t\0\0\0\0\0\0\0\0\t
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¼¼œ¼\tÀðÀðÍ\rééùí¯ÿÿÿëÿëÿûÿÿÿÿÿÿÿþÿþÿÿÿÿÿûÿÿÿ¿ÿÿûÿ¿ÿÿ¿¹©ÚËž¿©àÀ\0\0\0\0\0\0\0\0\0\t\0ÏÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÉàÉÌœ\r\r\r¬ðÞžÏ¿ÿÿ¿ÿÿÿÿÿÿïÿÿ¿ÿûÿÿÿûÿûÿþ¿ÿÿïÿïþ¿ÿûÿÿ¿ÿþÚ½¿ïÚÞŸ¼©©\t\0\0\0\0\0\0¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿðüœž\tÀœ¼\r\r\r­é¼ðûÿÿÿÿÿÿÿÿÿÿÿÿÿÿûÿÿÿÿÿÿÿÿÿÿÿ¿ÿÿÿï¿ÿ¿ÿÿ¿¿ÞŸ¿¿ûÿËÚÀ\n\t\0\0\0\0\0\0ðÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿïž\ržÉÀÀðËËÏÏ¿ÿÿþ¿ÿÿ¿ûÿûÿ¯ÿ¿ÿïÿÿÿÿïÿÿÿïûÿÿÿÿÿ¿ÿ¿ÿÿ¿ÿúûïÿí¯ëÿí¿\tÀ\0š\0\0\0\nËÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¼\rž\r\0œ­\rœééí»Ï¿ÿÿÿÿ¯ÿþÿÿÿÿÿï¿ÿÿÿÿûÿÿÿÿ¿ÿÿÿÿÿÿÿ¿ÿûÿÿûÿÿ¿¿¿Ûß¯¾žð½­\0À­\t\0\r\tÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÎ\rÜÉÀÚÐðÜÞžÏ½ïÿ¿ÿ¿ÿÿÿûÿÿÿÿÿÿûþ¿þÿÿúÿÿÿþÿþÿÿþûÿ¿ÿÿÿ¿ûûÿþÿ¯ûÿÿÿÊÚð¿Ê¬Éšÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð½š\0œ\tÀÐÍ­©éðûûÿÿÿÿÿûÿÿÿÿÿ¿ÿÿÿÿÿÿÿÿÿûÿÿÿûÿûÿÿÿûÿ¿ÿ¿ÿÿþûûûÿ¯ÿ¾ðÿ­¿Ëü¿ß¿ïÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÌËÍÏÀ¼ÉÊÚÚÜý¯Þÿÿÿþÿ¿þÿÿï¿ÿÿÿûÿÿÿ¿ÿ¿ÿÿþÿ¿ÿÿÿïûûÿÿÿ¿ÿûûûÿïþ¿ÿ¿ûÿ¼ûÎ½ëÏ¯ëÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿüšœ\0\0\rÉ¬\rœúÚÞ½¿ÿ¿ÿÿÿÿÿûÿÿþÿÿïÿ¿ÿÿÿïÿÿÿÿÿÿÿÿÿÿÿ¿¿ÿÿÿÿÿÿûûÿÿ¿ÿÿúÛÏ½ëß¿ûÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿþŸÍ\ríÍ\0Ìœ¼¼ðÜ¼½ëÿÿÿûÿÿ¿ÿÿÿÿ¿ÿ¿ÿþÿþÿÿÿûïÿÿïÿïÿÿþÿÿÿ¿ûûÿÿ¿¿ÿûÿÿÿÿïþ¾Þ¼¯ËÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿðéàšÉ\tÉÐÏ
ËÞ½ëÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ÿÿÿÿÿ¿ÿÿûÿÿ¿ÿ¿ÿÿ¿ûÿÿÿÿûûÿÿÿÿÿÿÿÿûééëËý¾ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿœ\rÌÌžÌ¬É¬ùííéëÿÿûÿûÿÿÿ¿ûÿÿÿÿÿûÿ¿ûÿÿÿÿÿÿÿÿÿÿÿÿûÿ¿ÿÿÿÿÿÿÿÿÿÿÿÿúþžÛÏžÚÿ¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿüéÀ
\tÉ\tÉ¼ÙðžŸß¿ÿþÿÿï¿ïþÿÿÿÿïÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿúÿï¿ÿ¿¿¿¿ÿÿÿÿÿÿÿÿý½éì¼éí­ï¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûÐüÜÀÌÐÌ\0ìðÏËËéÿÿÿÿÿÿÿÿÿÿþÿ¿ûþÿþÿþÿþÿëÿëÿï¿ëÿÿ¿ÿ¿ÿÿÿÿ¿ÿÿÿÿÿÿï¾ðü½éü¼ûÿï¾ûÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¾Ï\0\t
\t Ý\tÏœ¼þŸëÿûÿ¿ÿÿûÿ¿ûÿÿÿÿ¿ûÿ¿ûÿ¿ÿÿÿûÿÿÿÿÿÿûÿÿÿÿÿÿÿÿÿÿÿûûÏžÚÚ\nÚžšÛí¾ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿíÜüÌÌÍìÊÍéÊÜ¹í¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿúûÿÿ¿¿¿¿ÿÿÿÿÿûþÿ¾Ë\rÎÜíÎÜïÎžÛÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿðì\0\t\t\t\0œ¼íÏûÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿¿ÿÿÿÿÿÿÿÿûÿ¿¾ÛüúÙéÚÙéÚÛÉì¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿíÌÜÌÜÍ\rËÛÚÚÚÞ¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¾žœ¬ž\r¬ž\r¬žŸÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿðÊ
\0°
\0à\r­­¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÞýïÞýïßÿÿÿÿÿÿÿ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0©­þ','Janet has a BS degree in chemistry from Boston College (1984).  She has also completed a certificate program in food retailing management.  Janet was hired as a sales associate in 1991 and promoted to sales representative in February 1992.',2,'http://accweb/emmployees/leverling.bmp'),
  (4,'Peacock','Margaret','Sales Representative','Mrs.','1937-09-19','1993-05-03','4110 Old Redmond Rd.','Redmond','WA','98052','USA','(206) 555-8122','5176','/\0\0\0\0\r\0\0\0!\0ÿÿÿÿBitmap Image\0Paint.Picture\0\0\0\0\0\0 \0\0\0PBrush\0\0\0\0\0\0\0\0\0 T\0\0BM T\0\0\0\0\0\0v\0\0\0(\0\0\0À\0\0\0ß\0\0\0\0\0\0\0\0\0 S\0\0Î\0\0Ø\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0€\0\0€\0\0\0€€\0€\0\0\0€\0€\0€€\0\0ÀÀÀ\0€€€\0\0\0ÿ\0\0ÿ\0\0\0ÿÿ\0ÿ\0\0\0ÿ\0ÿ\0ÿÿ\0\0ÿÿÿ\0ý¹¿¿ûûŸ½»¿ÛùûûûûûûÛûÛû¿¿¿ý\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0»Ûù½¿›¹¿¹ûûŸ¹»û»¿»ûŸ›Ÿ¹¿›ù¿»û¿½¿Ÿ½¿Ÿ›Ûûûùû¹½»›¿›¿¿¿¿¿¿¿¿¿¿¿¿ûûûº\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0›ûŸ»›½¿¹¿¹¿ûÛù½½»Û¿ûûûÿ»ÿ»ùù½¹»û¿»ûûû¿ûŸ›¹ûû¹ûÛûûûùûûÛù¿¿¿¿¿ŸûûÐ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿¹û¹ûÛ¹»ûÛù»¿»û»Ÿ»Û¹¿¿›½»Ÿ¿»ûûÿ›ÛŸ¹½¹ùûû¿¿½¹û›¹¿¿Ÿ¿½¿¿¿¿Ÿ¿¿¿¿¿Ÿ°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0›ÿ»Û¹¹ûÛÛ¿»ùûß›Ûûß»ûù¿¿ûûûÛÿ›û›¿¿¹ûû¿»ù½¹û»û½½¿›ÛûûûûûûûûûÛûûûûð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t»ù½¿›Ÿ»½¹ù¿›»û¹»»ù¿¿¹»Ÿ½¿»›ûŸ¿›ÛûŸŸ›Ûûû¿½¿¹û»›¿»½¿¿½¿Ÿ¿¿Ÿ¿¿¿¿û\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ÛŸ»›¿¹½»¿»ûûÛ›Ûùù¿ùûÛÿ¿»ûÛûŸ»Ûû»›û»¿»û›Û›ù¿¹ùûù¿ûûÛûûûÛûûûûÿ¿›ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t»û¹ûÛ›û»ÛŸ›Ÿ»¿»Ÿ»ù»¿¿¹»Ÿ›¿¹û½»½½¿¹ûÛŸûû¿¿¿¹û»¹»ù¿¿¿¿¿¿¿¿¿¿½ûûÿ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿›Û›¹ûŸŸ»ûûûß›Ÿ»ù»ûù¹ûûûùùû½»ùûûùûÛ¿¹ý¹ù¹ùû½½¿Ÿ¿½»ûÛùûùûûûûûû»à\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0›û¿½»Ÿ»¹ù¹½»»½¹ù¿Ÿ½¿¿»Ÿ›¿»Ÿ»Û¿››»›½¹ûû¿¿¿»½¿»¹»›ûù»ûûûûûÛûûÿ½ÿ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0½½¹
Ÿ»ŸŸ»ûûùùû¿»û¿»ùùùûûÛÛûŸ»Û¿¿Ÿ¿›¯›ûÛ›Û›Ûû›Û½¿¿¿ÿ¿¿¿¿¿¿½¿¿¿¹ \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0›»»ûù¹û»ŸŸ›Ÿ»¹ù½¹ù½»»¿»Ÿ»¿¹û½»Û¹ë¹ûù¿û¿¿¿¿»›û¿›¹ûÛ»ÛûÛùûûûûûûÿ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ÛÛ›
ûŸŸ»»ûûÛÛ»û¿»ûÛÛÛÛùùùû½»Û½¿Ÿž›Ÿ©ý¹ù¹ùûûŸ›ùû›¿ûûÛûûûûûûûû¿\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t»½½¹½»¹ù½»›¹½¹»ÛÛ›»¿»¹»¿»Ÿ»Û¹û›»»ð¹ûû¿»ûû½¹û¿››ÿûŸ¿¿¿¿¿½¿¿Ÿ½ù \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0½»»Ÿ¹½¿»û½¿Ÿ›¿½»»ûÛÛŸŸ½¹½»Ÿ¿Ÿ¹ùùé»ú\0ùûŸŸ¹û¿¿Û»û››û¿¿Ÿ½¿¿¿¿¿¿»\0\0\0\0\0\0\0\0\0\0\0\0\0¼¼Ÿ\nž\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0›ùðû›û›Ÿ›Û¹¹»ù»ûß½»¹ûû›¿šùú¹«Ÿ«
Ÿ¼\0\0ûŸû¹ûŸ›Û¹ù½¿¿»ùûûûùûùûûûù\0\0\0\0\0\0\0\0\0\0\0\0Ú
Ëðýùûþ°\0\0\0\0\0\0\0\0\0\0\0\0\0\t»›¹û›ûûû½¿›ù»Û›¹»ùû¹¹ùéû›ŸŸ½«¿ \0\0\0ð°½¯Ÿ»û¿¿¿»›ûß¿¿¿¿¿¿¿¿Ÿ½¾\0\0\0\0\0\0\0\0\0\0\0š½ýÿ½ÿŸ¯ßŸßúð\0\0\0\0\0\0\0\0\0\0\0\0ŸŸšŸ½»›½»›ù¿Ÿ¿½¿››Ÿ¿š»›Ÿ¿©°»Ûë\0\0\0\0\0ð\0\0°½­¹ù¹ùûŸ»Û½»Ûûûûûûûù\0\0\0\0\0\0\0\0\0\0žÿÛúŸß¹ýùúÿ¿Ÿž\0\0\0\0\0\0\0\0\0\0
°¿››½¿›½¹›¹»››°¿¿©©½¼¿©©¿Ÿ¼ \0\0\0\0\0\0°\0\0\0\0\0
¿ÿ¿¹¿¿¿ûÿ¿¿½¿¿¿¿°\0\0\0\0\0\0\0\0\t»ÿ¼¾½ÿúßë¿½ùùÿûÿ¬\0\0\0\0\0\0\0\0\0\0
Ûù»ûÛ›¾›
ûÛùùûÛð››ÛË»››Ûð \0\0\0\0\0\0\0\0ð\0\0 \0\0\0\0\t©½¿ûùû¿›ûÛûùûûù¼\0\0\0\0\0\0\0\0¾ßŸßÛß¿Ÿù½ýûÿÿÛßËÛË\0\0\0\0\0\0\0\0\0\0¹»Û›¿½¹ùù¹»›»š¹»ùé©°ùûé \0\0\0\0\0\0\0\0\0\0ð\0 \0\0\0\0\0\0\0

Ÿ¿¿ŸûûûûûÿŸ¿»\0\0\0\0\0\0\0¼›ÿëûý¯ßùÿÛëßžŸÿ¿ý½¼½¬\0\0\0\0\0\0\0\0
½¹û›û››Û½½½½ž™©½¿¿š\0\0\0\0\0\0\0\0\0\0\0\0\0Ð\0\0\0\0\0\0\0\0\0\0\0
½»¿Ÿ¿Ÿ¿»ûûÐ\0\0\0\0\0\0
ËÿÛÛÞ›ùúß¼½½ûÿ¿
ß›ëËÚÛ\r\0\0\0\0\0\0\0™½›¿¹û™é»›Ù»

¹¿¿
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\t¿¿Û¿Ÿ¿¿Ÿ¿½ \0\0\0\0\0\0­½ý¯ýûÿß½ºÛûÛŸùýÿùÿÙù©ðð©\0\0\0\0\0\0
û»ù¿½¿¹ðû
­½»Ûà\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0 \0\0\0\0\0\0\0
û¿ûûûûûùú\0\0\0\0\0\tÉðûûý¾ŸÚûßý½¼¿ðÿûùÿ¿žŸŸž\0\0\0\0\0\0¹ù¿››°››½¿š›é \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0¹ûûûŸ¿¿¿\0\0\0\0\0\nžŸžß¿Ûðý¿­¿ÿŸÚßŸß¿½ùùùù
ËËË\0\0\0\0\0\0šŸ¹û¼Ÿ½ \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tû½¿Ÿ¿½»ð\0\0\0\0\t¼¹¼ûûß½¿¿ýûÙéù½»ÿ¿ßÛûËžž½¹ù­\0\0\0\0\0Ÿ»Ÿ¹û°°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿ûûûûûÿ\0\0\0\0ËÞÿŸßëÚýûß½¯¿šÛÛý¿¿\r½éùÐ¼¼½ ž\0\0\0\0¹¹ûŸ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t¿½¿½¿»\0\0\0\0\0\t¼ûËúùùý»Þ»ËÛÐ½©ù½ûí­¿
ŸšûÛŸ
Ÿ\tÀ\0\0\0¿Ÿº\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0
ûûûùÿà\0\0\0\0›ß½ý¿ÿ¿ß½ý½­¿
Ð
\r½°ÛÚÚÙžž›Ððð°\0\0\0\t›¹ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ð\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\tŸ½¿¿»\0\0\0\0\t\tþ¿Úûý½ù¿ËúûÛÉ¼¹ðœ°š ™©é¹ð¿›žž\0\0\0
ùû\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿¿¿¿½\0\0\0\0\0
ËÚÿýúÿ¯ý¿Ÿœž›É\tûÛéÚ›ÛúŸ\t\tùËÐ\0\0
›°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿ûÛû\0\0\0\0\0Éÿý½¿½½ùúÙðûùéûùÿ\t©\t©É©\r
½¹ù­¹¹é­\0\0\0ûÀ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t¿¿¿À\0\0\0
\n›ÿïýÿûÿŸ¾ûÐùûÛÚ™ðÛÛÚŸž›œšÛšÚÚŸ\nÀ\0
š\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ûûÛ \0\0\0\0\tÿéùúùý¿ùùðûûß­­¾Ÿ¼½½ùé¼ù½¼¹é½¹é½ \0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0à\0\0\0\0\0\0\n\0ÀÀ\0\0\0\0\0\0\0\0›ûûÐ\0\0\0\tÏïŸ¿ÿßûýžžŸŸ½ëÛùý¼Ÿ¼¿
ÛÛ›ËËŸ›É­¹Ê\0
\0\0\0\0\0\0\0\0\0\0À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ðÀ\n\0\0\0 \n\0\n\0\0\0\0\0\0\0\0\0Ÿ½ \0\0\0\0¹¿ÿÏŸ¿½ºûÛÿ½ÿ¿ß
ûý¿Ùý½­­¹°ð½¿šÚ¹à\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð \0À\nÀÀ\0\n\0\nÀ¬\0\n\n\0\0¬\0
ûð\0\0\0\nÛËûÿùÿÛÚù½ûËûË½ýŸŸÛý¿ÛÛÚßŸŸŸéž\0\0\0\0\0 \0\0\n\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0 œ\0 šÀ\0\0é¯°\0\0\0\0Úÿÿßùÿðý½¿ÿ½ùý¿Ûûÿÿ½ûùùùù°ðùùùü»Ÿ©\0\0\0\0\0\0\0\0\0\0\0\n\0 \0À\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0à\0 \0\0\n\0\0\n\n\n\nÀ\0\0
\0 \0Ûð\0\0\0\0¿úÛþŸý¿»ëÿËß¿ûý½¿ÛÛß¿ßŸ¼½½¼°°û¼ÚÐ\0\0\0\0\0\0\nÀ \0À \0\0\0\0Ê\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\n\0\n\0  ¬\0ÀÉ\n\t¾\0\0\0\0ûßÿŸûúÛßŸŸ¿½ùýûÿÛÿÿÿý½¿ÞŸÛËŸŸŸŸÛ½¾\0\0\0\0\0\0\0\0\0 \0\0\0 À\0\0¬\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \n\0À
\0\0\0\0ž¿Ëûßß¼¿ÿûßûÿ¿ßŸýùÿùûÿÛùù­½ééé°ü»Ùð\0\0\0\0\0\0\0\0\0\0¬\0\0\n\0¬\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°\0\0\0 \0\0 \0\0\0\0\0\0\0\0\0\0\0\0\n\0 \0\0\0\0ýÿ¿ßûéûùùý¿ŸŸß¿ÿŸ¿ùÿýùý¿ŸÛËŸŸŸ›Ý¯ž\0\0\0\0¬\0\0\0\0à\0\n\0\0ÀÀ\n\0\0\0\0\0\0 \0\0\0\0\0\0\0\0À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\t¿úßûÏŸ¿ß¿ûùÿÿûýùÿßßÿŸ¿ùý¼¹ùùËÚÛŸûùé\0\0\0À\0\0Ê\0\0\0\n\0\0Àà\n\n\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ûßûß¿ûß¿ùýÿùùýûÿÛÿ¿ŸÿÛÛéùÿÛËðùðð¼Ÿ½ð\0\n\0\0 \0\0à\0\0\0à\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0þûßùùÿ½ùÿ¿Ÿÿÿ¿ßŸ½½ÿùùùý½½š¿½¼½½¿½»ËÀ\0\0\0\0\0\0\0\0À\0 \n\0\0 \0\0À\0\0\0\n\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\nÛÿëþ¿ùÿ¿ùÿÿŸŸß¿ÿßÿŸŸÿÿŸŸÚýùûËÛÛËÙþß½ \0\0\0\0\0 \0\0\0 \n\n\0\0\0\0\n\0à\n\0\0\0\0\0\n\0\0À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tÿßŸÛßŸ¿ý¿ûÛÿÿûýùûÛÿÿùùÿ¼¿ŸŸéùððùëùûÚÐ\0\0  À À\0\0\0\0 \0\0\0\n\0\0\0\0\0 \0 \0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
¿¯ûÿûÿý¿ÛßÿÛùýûÿßýùùÿÿŸÛÙðý½¼½¿ŸŸŸ½ûÚ\0\0À\0\0\0\0\0¬  \0 \0\0\0\0\0\0\0\0\0\0\0À\0\0\0\n\0ð\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÿÛÞŸ½½¿Ûÿ¿Ÿýÿ¿ý¿¿¿ÿÿûßùÿ¿½¿Ÿ½¾Ÿ¼ùéûß½¾\0\0\0\0\0\0\0\0\0\0\0 \0\0 \n\0\n\0\0\0\n\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tûÿûûßÿÿ¿Ÿÿÿ¿½ý¿ýýý¿ýýûß½ýûÚÛËÛÚÛÛý½¿ÚÐ\0\0¬\0\n\0à\0 \t °\0©\0\0\0\0\0\0\0\0 \n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0žýé¿ßÿ¿ŸßÿÛÛßÛûýûÿ¿ý¿¿½ûÛ½½½½­½½¿Ÿý¿ž\0\0\0 \0\0\0à ÀÀàÀà °À\0\0\0\0\0\0\0\0\0 \0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ûþß¿Ÿßûùûÿÿûÿýûý¿ß¿ýýûÞ½ùÚùðùùëÛÍ¿ð¿ùéà \0\0\0À\0\0\0\0  \0  \n\n\n\n\n\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ý¿ùÿûûßÿýùý½½¿ý¿ÛýùûÿŸ½ûÿ½žŸ¿¿ÛßŸÿŸÀ\0À\n\0 \nœ
ÀÐ©Êš\rœ\r\0 \n\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t¿é¿ùýÿûÛÿ¿ûÿÿý¿ÿÿûÿýùÿÛßÿ½½½½¯Ûÿ½½¿ùë\0\n\0\0\0À\n\0Ê\n\n\nÀ ÀË\n\n\n\n\0\0œ\0\n\0àÀ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ïŸßŸûÿŸÿÛùýùùûÿß½ÿÛß¿ý¿ðû©Ëððð½½¿ŸÛËý¼½\0\0\0\0\0\0\0\0\0Ð©šÉ\n\0ÀÀ\0À¼ ¬ ¼\r\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
Ûÿ¿ûßŸûÛýÿ¿¿ÿýÿ¿ûÿÿ¿ý¿ý¿Ÿß½ŸŸ›ÛÛßûÿ¿ÿžšÀ\nÀ 
\0\n\0\0 \n\0\nÉà°­ é¬\0\0  ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ž¼½ùÿ¿ùÿý¿Ûßß½¿½ÿßÛýý¿ÛÿÛù½¾¼¼½­­¹ý¿¾Ÿùùé\0\0\0\0\0\0\0\n\0\0\0\0\0\0\t\0\0¬ ¬š\0Àð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0éÿ¿¿ùý¿ùûù¿ûûßýÿûÿ¿Ûûß½ùý¯ËÙÛÛÚÙùï¿ýù½¿ý¼ \0\0\0\0\n\0\0\0\0\0\0\n\0\n\nÀ¬\nÉ\0œ\0¬
š\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n›ùÿßŸûÿŸÿßý¿ßûûûßùý¿Ý­™é½ëúÛËŸ
ùýûžßßšÚœ\0 \n\0\0\0\0\0\n\0\n\0\0\0\0\0\0\0\0\nÀ\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ýïŸ¿ÿŸŸûÛùûÛûßßß½¾ÛùûÛÙ­™é\tœ™é½­½Ÿûßùº¿ý¿\0\0\0\n\0\0\0 \0\0\0\0\n\0\n\0\0\0\0\0\n\0¬\0¬\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0»ÛÿßŸÿûßý¿ßÿßûûÿÞÛÐßßÿýÚÙ¼›ÉðÛÚÛùÿ½ÿÝ½¿ÙúÀ\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\t\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\nÞ¿ÛûÿŸŸûÛÛûÛûßýùùÙý¿ÿßŸšÐÙ¼š¼¹¼½½ÿ½»Ûü¾ \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\n\0\0\0\0 \0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ÿùý¿ýùÿÿ½ûÿ½ÿ½þŸ½ž™ùÉ\t\r
\r\t ÉÉÐ
ÚÛÛûÛÛüÛÛùÚ\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\n\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0­¿¿ýûÿ½½ÿ½ùÿ½ÿ½ðÛÐÙý\t¹ý¹½ûûßš°
Ð½¾ŸÿûÛ½½¾½¼\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0Ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0šßÛûýùÿûÛÛÿŸûßùß\r
\t¿ýÿ¿ÿÿÿß¿ýÿ\0ž›Ùù½ÿýëßÙð°À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÿ¾¿ßÿ¿ùÿÿ­ŸÿŸðß\t\0½ÿÿûÿÿÛÿÿ¿ÿûðð\t\r¼¿ßÛùûŸ
¿Û\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0›ùùý¿ùÿŸùùß¯ùÿŸùÿ¿ÿÿÿÿ¾ÿÿÿÿ½ÿ°
\t½°¿ß½ý½í½ \n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0­¯ÿ¿ùÿÛûßŸ¹ùÿ¼éï¿ßÿÿ¿ÿù¿ÿÿÿÿÿÉàÛËÿÛùÿšÛ›ÚŸÀ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
Ûßùÿ¿ýÿ¿½éŸžÛÙ
Ÿùÿ»ÿýûüðÛŸ›ÛÚÛðÀ\t™ùÿŸý¼ðý©¬\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¼¿¿Ÿÿß¿½ýù½»ùð\nŸÿžÿÏž›\r›¼É\r­¼\nœ­¿½ûÛÛŸšÙð \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ÛýýÿŸ¿ßßŸšÚüŸ\t\rÿéé¹½ÙéË\t­™é\t\t™\t©›éßŸŸ©Úßž\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0­¿¿¿ÿÛûûûß›À
\tð™ÉéÚß
Ý½ýÛ­›ÚÛùððÛÉŸ°½½½ž½©é¼\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0à\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\túßýùÿÿßŸß½ºÐù›ÐðŸé¿ŸŸŸß¿ÛûýûÏŸœ½­›\r½©ßÛËÛÙ
ÚžÚ \0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ê½ûÛÿûÛûÿ¿ž¹­­¿Ÿù¿ßÿÿÿ¿ß¿ßŸŸùðûÚÛÉðšŸ¹­½©¯©ù©À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0à\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0š›ß¿ÿÿŸÿýûßŸ›ËÛÛéÿŸýûùý½ýûýûÿý½­ðùÚž›ùßÛÛŸÙšžžœ \0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ÿÿ¿ßŸŸÿ½¿Ÿùé½¼½ÿÚý¿½ÿ¿ûûýûÞŸšÛÛÛÐ½¹\r©ð¹ðù¼½™
Ë\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0à\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0šÛùùëÿûùýûßùéûÙÚÛÛŸ½¿ßûßÛßß¿Ÿ½ÿÿðû¿ËË›ÙùŸžŸž›ÚÚšÐ \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0­ÿßïýùýÿûý¿ŸŸœš½ŸžùßùûßûÿûûßÿÛùùÛùÉ½é©
ÛÛÛÛÉ¼œ¼°Ð\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\n\0À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ß¿ûùûÿÿ¿ŸÛùùùé¹Ù¾ŸŸ¿Ÿýÿ½ý½ýÿ½¿ŸùúÞûÚš›Ûù½ŸžŸ›Ë

É \n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ÿ¿ÿýÿß¿ŸßûýŸŸ›ÚšÙùùéý¿½ÿ¿ÿ¿ŸÚÙðž¹¿½½­½½½½­›ÉàÀ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0à\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\nßß¿ûûïßûùý¾ÿ½ü½ù©ŸŸ¿ÛÛùùÿûÛžŸ™éüý\tË
Û™ùí¿ÛÛÚÜ°œ°¼\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ŸûûýÿßûûßÿûùùùÛ¹ù­¹éùéÿÿûÿÿùß¼»ÚÚ™
ŸšŸ½\r¯»ÛËÙù»ÉëÀÚ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0à\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
¿½ÿÿ¿ûßßÿŸŸßŸ¿ûßÛß
ŸŸŸ½½½½ŸŸúÛÜ¿Ÿž\tÉ\tðºÐ»Ùÿ½ý½¯œš
 \n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\rýÿ½ÿýÿ¿ÿ¿ÿûûý½½ù¿›ùÐ½½ùûÚßŸ¹ùùýûùðùð°ð»ÙûÛß›ùùùé­\0Ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0 \n\0à\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ûýÿ¿ûüÿ¿ßŸŸßŸÿÛÿßýûùË
ÛßÿšÐÚÚß¿ŸßùðŸŸ©©Ð¼Ÿ½¿ý¿ŸŸŸšÐ­­\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ŸŸÛÿýÿûùÿûÿï¿ý½½½¿ŸŸŸ¹ßŸ¼™ý¿ûÛûßÿ¿Ÿž™éœŸ
ß¿Ûý¿Ùí­­­ Ð\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\t\0À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿ÿ¿ùÿÿŸÿùÿÛÛÛÛûÿÿÛÿùýžšŸŸ¿ûý½ÿýÿÿßÿŸ\t¹é°ùùý¿Ûý¿ùùùù\0¼\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0 °\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ý½ÿÿûÿùúÿûÿÿÿÿßÛÛýùÿûùùËÙùý¿ÿùûÿÛùùéððÞÛŸŸ¿ÛÉ
ÛŸŸ¼\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\t\0à\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿ûùÿÿùþýûý½¿ŸŸ¿ÿý¿ÿ¿ßŸ›ž¹Ï¿ß½¿ßŸýÿŸŸ\r
™éŸý\t\0¼¼\r
ËÙùé
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tûßßûý¯½¿üÿÿýÿÿý¿¿ýÿßÿÿýùÚ›ß¿ßÚùþŸ½ü¼°¼¼\tùé
ËÛÛÛð¼úÚœ¬\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0 \n\0à\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ßûûÿß½ÿÿûûùûûÛÛýÿÿ¿ûÿŸŸ™­½ùý¾½ŸùÿÛÛÛÉÉ
Ÿœ½½½¿ßŸý\tÛËž\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ûßßÛùÿùëßýÿßÿÿÿûßŸýÿßÿûÿÛË›ÛÛÿŸ½¼½­°žœšÐùéðûß¿ýŸ½é ¼Ê\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÿ¿½½­¿ÿÿ¿¾¿ûßŸûß¿ÿÿûùðý½½½¼ðý½­ýûÛÛÚÚ°ð›ËÛÛß½ùûéð¼œ
¬
À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ßßÿûÛÿ¿Ÿíýý¿ÿÿßÿßÿŸœÚßžÛËÚÛŸŸÛûß¿ÚÛÉéÉ\téùùÿ›ß¿ùÿŸÛð¼ \t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ÿûÿ½½¿ÿÞÿûûûýûÿ¿ÿ¿¹üÿ¿›ß½ÿùùðûý¿ùí½¼š©ŸŸðùÿûßŸùÿ½ËÀð¬ \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ßŸÿËßÛûûßÿßÿýýÿ½üÜ»ùýÿûßŸÿÞ½½ûýï¿ÛÚÚž›Ûé½¿Ûß¿ùÿ›Ë½½à\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ÿÿÛÛûÿßß¯ž¿Ÿ¿ûýÿ
¿ßŸŸŸŸ¿½¿ÿÛÛÍ¿ŸÛý½½é¹\tééßÛÛÿ½ùÿŸýýéëü°ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ûûÿùÿþ¾¿ßÿßÿÿÿÿéýùùÿûÿÿßß½½þ¼»ÛùÿÚÚÚÀùŸŸ¿¿ÿŸÿ¿ùÿ½¿Ûß\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿¿ßÿ›ÿûßýûÛÿ½½ÿžŸ¿Ÿ¿Ÿ½ý½¿ûßûÿÙùËßý¿Ÿž›
éûÛÛÛÿÛý¿ùûÛü¼¾\0¬\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ŸßÿùüŸž½«þÿ½ÿÿ¾ùýùùý½ÿ¿ÿûßûßùëÏ¼¿ùðý©ŸŸÿÿÿÛÿÿý¿½üûÚÙà\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ûùÿ¿°ùïßŸ½ÿ½ÿý¿ÿÿ¿ûýùûß¿ßùÿý¿ÛßùÿÛ\0ÚšÚÚùùÿŸÿŸÛËÚÛ¿žŸ¬¼\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÿßßýùÛÉ°¾ÿÞ½ÿ¿Ûÿß½¹ùýûÿÿûÿ¿¿ùÿü¿½¿ÚßÛ­\r«Ûß¿ùÿŸÿ¿ûý¼ùééÛÀ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0½ûûÿ¼­«ÏßŸ¿ÿ¿ý¯Ûûßÿÿûýûý½ýýÿŸûËÛËý¿ð°Ð
Ý½»ÏŸÚÿ½ÿŸšÛžŸž¾\tÀ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tûÿÿùùšœ°¿ÿûßý¿ÛÿßûÛÛß¿ý¿ÿ¿¿Ÿûßÿ\r½¿ÛÛË\0ÐºÚÝùëý½ûÐðý­
žŸ\tì\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0à\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ý½ÿÿÿð©í¿ß¿¿úßÿ¿¿ÿ¿ûß¿Ûýùÿùÿ»ßËËý¼ùðÚ­ÛÛ©¿ŸŸûßûÛ
ÚÐùéðš\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿ÿ½ÿÿ­\0š¿Þ¿ßßÍ¯Ÿýý½ý½ûÛÿÛÿŸŸ½ý¿ùûÛÿ½­©Ú¼½ÿùÿÿÿëß­ü\t°¼½­¬\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ý¿ÿùýðšúßûþûûûÿÿûûÿûûÿÿý¿™éûËÛï\r­ÿÛÞŸ\téßÿŸžý¿½ðý©¿ÉúÚ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tÿýÿÿûÞ\0\r©ÿÛßÿÉùùýý½½ÿŸÿûÛÿ¿¿ÿ›éû¿½°žž¹ðûÙûÏþð½
ÉÉð¿\r¼\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¹ú¿ÿÿ­ ðÚÿÿûÛþÿ¿›¿ûûßÿûßü½Ÿ¯ŸŸýðßùýùïÚÐÚÙ¯žœ©ü°¼½
ðËÀ\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0à\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tÿŸßý¿ß\0\0¿žÿ¿ïÉ½éíùÿßûÛßúÛÛéÿÿûß¿ž\0
\nÛœ\0àà\0œ©\r
Àð›ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ÐŸ¿¿ü°\0
ðÿ½ÿÛûÏ¿¹¯ý¿½þü½¼¼™ë\t¹ûÚœûý \0¼Ùý°Ï\t\0éÊœ\0½
\tì\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0à\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ûðŸý¿¾¿ÿûÿ\r¿ßßÛÚÛß½¿ÚŸŸ™þÞŸéëýÿÐšÚÛé¿ÿ°ÊÞ\0\0­\t©ÊÉÊ™ à\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ßŸ\t¾ÐÐà
\0ý¾ß¿þŸ¿¯šùÿü¼\0¼°ð››ÚÛß¿ûÿùùéÿÿÿÚ\0\0\0\0\0Ú°œ¬\t\0\0\0\0\0\0\0\0\t\0  \0\0\0\0\0\0\0\0\0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ûü¼\t©©\0\0
Úý¾Ð\tëßŸýšÐ À©\n
ß\r
Ï\r­ûß¿ÛÞŸ½­ûÿÀí­\nÀšÚ\0ËËË\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0 À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿Ë\0šÐ\0\0\0­¯Ÿ­
ÿ½éÿ
í
ý°œ­\r Úž›ž¼¿Ÿÿß¿ûùí¿ÿÛ¼­\t­¬œ¼\t\0\r \0\0\0\0\0\0\0\0 \0\0\n\0\0\0\0\0\0\0\0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¼\0\0\0\0\0\0\0\0 ûüÿÏ¿éý›ýÿÿà\0\nÐ\tùüùËßÿ¿¿ý½Ÿ›ÛÛþÚËËÚËÀ©\tàšÉÀ\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\n\0Àð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0š\0\0\0\0\0\0\0\0ËÞ¿ëðùÿ¯é
ÿÿ\0\0
ËÏ›Ë¿Ÿßùÿÿ­ùéðùÿ­¼¼­\0\0ðù  \0\0\0\0\0\0ž\0\0\0\0\0\0\0\0\0\0\n\0\0\0 À\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\nÀ\0\0\0\0\0\0\0½½¯ÞŸÿÚßžùûýý­­¼¼¹í¬Ÿßÿ¿ßù½ù¾Ÿ›ÚœééÀ\0\0\0\tŸŸœ\0\0\0\0\0\0\0\0\0 \n\0\0\0\0\0\0\0À\n \0°\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\téëÿûÿÚÞ¿ùéžßþúßŸŸžÚ™ûûÛß¿Ÿß¿ý¿Ÿ›À \r¼¼ðùéë\n\0\0\0\0\0\0\t \0\0\0\0\0\0\0\0\0\0  Ð\0\0Àð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ÿÿüÿž¿ËÏžý¾½¯Ððàðœ¾ŸŸÿ¿ßûûÛÛßŸùð¼¹Ùùé¯Ÿ¿žÉ\0\0\0\0\0\0\0Àš\0\0\0\0 \0\0\0\0\0\n\nÀ  à\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\n\0¼ûþýûü¼ðéêÛëÏÚéùð›ß½ùýûùý½ÿ¿¿ùðùùï­­¼šÐÚÚ\té à\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0À\0 \r\0Ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\tËÿ¿Ûÿ­»Ëß½ýþÜ¹­ž\0ðü¹ÿ¿¿½ÿûÿ½ýý¿¿žž™›ÚÛÉ©¿\tð\0\0\0\0\0\0\0\0\0\0\0¬\0\0\0\0\0\0\0\0\nÀ\tà °\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0 \0\0\0\0\0\0
ÚßïÚßÏÿ¯Þ¿ÿÛüí¬½½¹ÿùýýÿùÿÛÛûûýýùûŸïšÚÚÀž\r©à\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\n\t\nÊ\0à\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tà\0\0\0\0\0\0\0\0¼¿ûûÿ¿½½ü½ïÿËÚÛËÉ©ÿùÿ¿ûÛÿÛÿÿÿýûûÿßùùùÿŸŸ›É\t À\0\0\0\0\0\0\0\n\0\0\0\0\n\0\0\0\0\0\0ÊÉ ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tà\0\0\0\0\0\0\0\tËÏÞÛÞÛËÛûÙù­¼¼°½¿ßŸÿ½ùÿÿÛÿŸŸ½ûýý¿½ÿÿÿùþÛ­¬šžž\0\0\0\0\0Ê\0\0\n\0\0\0\0\n\0\0\0\0\0  ©\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0 ¿ûûþûÿ¿¼¼¾žÚÛÛßÛùûÿŸßÿùùÿßÿÿÿÿûÿýÿ½½½ÿžùüÚÛÉéÀ\0\0\0\0
\0\0\0\0\0 \0\n\0\0\0\0 \0\t\0àà\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\nÐ
À\0\0\0\0\0\0\r­¯ßûßÞÛß½¿½¿½ûÿÿÿßÿÿ¿Ÿÿ¿¿¿ŸÿùÿÿÛûßÿÛùÿž›¿šË\0 \0\0\0\0\0\t\0\0\0\0\0\n\0¬ \0\n\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0šÛßúß¿ûûÿ¼ÿýÿßÿÿýÿß¿Ÿ¿ßÿŸßßßÿßÿý¿ÿßûÛý¿ËÛíÉí¼½\0\0\0\0\0\0\0\0 \0\0\0\0\0¬¬\0\tÊ\0œ\0\t ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
\0\t \0\0\0\0\0\0°ÿ¿éÿßŸûÛÿûÿÛÿûÿ¿ÿÿßùûûûûûÛûÿÿÿûûß­¿Ëß­¿¾žšÊÀ\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0  \0\n\nÚÀÀ\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\nš\0\0\0\0\0\0\0\nÿ½í¿ðûéýÿûßûÿýÿÿÿßûûÿýýýýÿÿÿß¿ùÿýûßß½¿ÛËÛùï°\0\0\0\0\0\0\0\0\0\0\0 Ú\n\0 \0\0\n\nà\0\0 \0\0\n\0\n\0\0\0\n\0\0\0©­\0À\0\0\0\0\0\0\tËÛÏûýÿÿß¿ûßÿßÿÿ¿ßÿ¿ßýùûûÿ¿½¿ß¿ýÿý¿½ûûßé­ùí\t\nÀ\0\0\0\0\0\0\0\0\0 \0\0\0ÐÀ©\n\n\nÀðÀð\0\0\0\n\0\0\0\0\0\n\0\0\0\0\0\0\0  \0\0\0\0\0\0\0©ëÿžÿ¿Ÿ¿ÿß¿ß¿ùÿÿûßÿÿÿÿýý½ýÿÿ¿ùûûÿßÛùý¯Ÿü½ûðÚÉ\0\0\0\0\0\0\0\0\0\0\0ð\0\0 ¬\nÉ \0°ð\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0É\0\0\0\0\0\0\0\0\0ž›ùÿÿÿÿŸÿÿ¿ÿÿýÿÿÿý¿Ÿ½¿¿ûûûßÿÿÿýûûýÿŸÛùûëžŸ© \0\0\0\0\0\0\0\0\0°À\0¬ \0š\0©  ÊÀÀ°\n\0\0\0\0\n\0\0\n\0\n\0\0\0\0š\0\0 \0\0\0\0\0\0\téíÿðÿùÿÿ½ÿÿÛß¿ûßÿ¿ÿÿÿýùÿßßûý¿ßÿ½ýûùÿ¿ÏŸéüœ\0\0\0\0\0\0\0\0\0\0\0 \0\0œž °š\nà\0\n\0¬\0\0\0\0\0\0\0\0\0\0 À¬š\0\0\0\0\0\0\0\0°©ûéÿùÿÿÿÿûßÿÿÿÿÿ¿ßý½½¿¿Ûûûßÿÿ¿Ÿÿ¿¿Ÿðý¹éþ½© \0\0\0\0\0\0\0\0\0\0\0©À  \0 \n°\n¬ð\0\0\0\0\n\0\0 \0\n\0\0\0\0\0 \0\0À\0\0\0\0\0\0\0Ùéÿ¿ÿÿŸ½ÿÿûÿ¿ûßÿßÿ¿ÿÿßÛÿßÿÿÿŸÿÿŸßßý¿ÛïŸ›Úœ\0\0\0\0\0\0\0\0 \0\0­\0\0 Àžž°Êœ \0°ð\0\0\0\0\0\0\0\0\0\0\0\0 \0\0žš\0\n\0à\0\0\0\0\0\0\nžžÛÛÿÿÿùÿÿýÿßûÛÿ¿Ûß¿¿ÿŸ¿ý¿ŸÿŸÿûûùûÛ½½­éý©\0\0\0\0\0\0\0\0\0\0 \0\0À\t©\0 \0°Ê ÚÊÀ\n\0\0\n\0\0 \0\n\0\n\0\0\0\n\0
\0\0\0\0\0\0\0°ùûÿÿÛýûÿÿßÿÿÿÿÿùýÿÿßßŸÿßÛÿÿÿÿŸÿßÿýíûÚÛÿ\nœ\0\0\0\0\0\0\0\0\0\nÉ\n\n\n­­\n \nà\0\n\0\0\nÀ\0\0\0\0\0\0\0\0\t©¬\0\0\0 \n\0\0\0\0šþŸ¿ÿûÿÿûÿûÿ¿ýÿÿÿ¿ûÿûÿÛûÿÿûÛÿÿŸÿŸŸ»œ½½°\n\0\0\0\0\0\0\0\0\0\0\0À\r\0\0
\0 à
\0©Ë\0à¼ð\0\0\nÀ\0\0\0\n\0ð\0\0\n\0¬
\n\0\0\0\0\0\0
ËÛüùÿÿýÿßÿßÿß¿ÿŸÿÿýûßÛÿÿÿ½ÿÿùÿÿ¿ÿûÝûËÚß\n\0\0\0\0\0\0\0\0\0\0\0 \0
ËÀàÀ
ÀàÊ\0Ë\nð\0\0À\0\0\0\n\0\0\0 \n\0 \n\t\0\t\0\0\0\0°ùûÿûßûûÿûÿ¿ÿÿ¿ÿÿýÿÿûýûßýÿÿùÿÿÿýûß¾ŸŸù°ÐÉ \0\0\0\0\0\0\0\0 \0\0\n\0\0©
\0 
 ¬\tÀ°\n\0\0\0 \0À\0\n\n\0À\0\0\0\n\0 š\n\0 \0\0\0\0\0\r­­¿Ÿûÿÿÿÿÿßÿßÿÿ½ûÿý¿ûÿÿ¿ÿ¿ßÿ½ÿûýûÛý°¼ð© \0\0\0\0\0\0\0\0\0\0\0\0\0¬ ÊÐàË\0¬ à\0\0\n\0\0 \0\0\0\0\0\0\0\0©À\0\n\0\0\0\0\0\0\0\nÚŸ¿ßÿÿßýûßÿÿ¿ÿßÿÿÿÿ¿ýÿý¿ß¿ßÿ½ÿ¿ßûùÿšßÛÀ\0\0\0\0\0\0\0\0\0\0\nœ\t\n°
À°\n À\nÚ\rð\0\0\0\0\0\0\0\nÀ\0À \0\0\0 ©\0
\t\0\0œ\0\0\0\0\t©ðý¾¿Ÿÿ¿ÿÿÛÿÿÿûßÿÿýûÿŸÿÿÿÿÿ¿ûÿÛùýÿÛß© œ
\0\0\0\0\0\0\0\0\0\0\0\n\0ÊÉà\r¬œ à\nð\0 \0\0\0\0\n\0\0\0  \0\0\nšÀ°Ú\0°\0\0\0\0½¯ýÿÿ¿ÿÿûÿÿÿûÿÿÿÿÿýÿÿÿûÿÿÿýÿûÿÿûß¾½ùÐ›\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°\0 \0 Ë\0 žšÚÐÐ\0\0\0 À\0\0\n\0\0\0\n\0\tÀš\n\0\0\0\0\0\0\0\0

ùûÿ½ÿÛýÿÿŸýÿÿÿÿý¿ÿ¿ÿŸßùÿÿûýÿùÿŸûßŸ
\0¬\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0ÀðÚÀéÊ\0àÊÀ \n \0\0\n\0\0 \0\0\0\0 \0\t
Ê\0°\0\0\0\0\0\0\0\0\tÉžýùÿÿÿûÿÿÿÿýÿûÿ¿ÿŸý¿ÿ¿ÿÿ½ÿûùÿùÿ½ûý¼ù\0\0\0\0\0\0\0\0\0\0\0\0 š\n\0 \n\0¬ž°\nàð\0 \0\0\0\0\0\n\0\0\0\0à\0\0°À \0\0°\0\0\0\0\0\0 ðùûÿÿŸ¿ÿý¿ÿÿÿÿýÿÿÿÿÿÿÿÿÿýÿ½ÿÿùÿ½ÿ½úß
\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0Àœž¼¼š\0¬\0àÊœð\0\0\0\0\0\0\n\0À\0 \0\t\0à\0\0°\0
\0\0\0\0\0\t
ËËÛÿÿýÿ¿ý¿ûÿÿÿÿßÿÿÿÿÿý¿¿ÿÿ¿ÛÿŸûýûÐ\tÙé\0\0\0 \0\0\0\0\0\0\0\0\0\0 \n\0ð\0\nÀ¬š\tàš ð\0\0\0\0 \0\0\0 \0 \n\0 \0\0\0\0\0\0\0\0 ŸŸÿŸ½¿½ÿÿÿÿß¿ÿûûý¿ùÿýÿýÿùÿý¿ÛÿŸÛððë\n\0\0\0\t\0\n\0\0\0©\0ð\0\0\0\0 Ê\0éà°ÚÀà
Àé \0\0 \0\0\n\0\0 \0À\0\0\0\n\0\0
\0\0\0\0\0\n\0\n\0\0Ùð¾þßÿÿÿûýÿÿý¿ßÿÿý¿ûûûÿùÿùûý¿ùÿ¿
ûœ\t\0\n\0\0\0\0\0\0\0 \0\n\0\0\0Ð°\n \n¬\nœ©ð\n\0\0 \0\0\0\0\0\0 À\0à\0Ð¼¼œ\n\0\0\0\0\0\0\0 \n
Éÿ›úÛÛûßÿÿ¿ÿûÿýûÿÿÿßÿŸÿùÿýûý¿ŸÛ\r¼ù¬\0\0\n\0\0\0\0\0\0\0À\0\t\n º\n¼ðÊÀð\0\0\0\0\0\0\n\0\0\t\0\0\0  \0\n\n\0š\t\0\0\0\0\0\0\t\t\r°šÐ½¿ýÿÿÿ¿ß½ÿÛûýûßŸ¿ŸûÛÿŸ¿ý¿ýû­
\t\0 \0ž\0\t\0\0 ž\n\0À\0é\0©ÊÐÀÐ°\nÐ¬\n°Ð\0\0À\0\n\0\0\0¬\0\0 \0\0\t°¼À\0\0\0\0\0\0\0\0\nÊ\r­¯žý¿½¿Ÿÿÿÿ¿¿ßÿ½ÿÿýÿŸÿÛÿÛŸùëßÐÙÐš\0 \r\0Ð\0\t\0\tÀÀ\0 \n\0éÊ\0  ªÀà\nÉ¬¬ \0 \0 \0\0\0\0\0\0\0 \0 
À  \0\n\0\0\0\0\0šÐš\t\tË›ëßÿÿùûßýÿÿŸÿûùûùÿ½½½¾ÿŸ©
\n\nÀ\r\0 \0 \0\n\0\0\n\t ¬°\t\0\0 ž\rš­\nÉ\0ðð\0\0\0\0\0\0à\0\0\0\0À\0\0\0\nšÚ­\0À\0\0\0\0\0\0\0\n\0\0ðð½í½¯Ÿùÿÿûÿ½¿ûÛýÿÞŸÛÚý¯Ÿ™é¯žœ\tÉ\t\nÐ°\0
\n\0\0\r\0\0¬ž\0\0  ¬\0é\nÊ\0ð\0\0\0\0\0\0\0\n\0\0 \0\0\0\0œ\0\r\nÀ\0°\0\0\0\0\0\0\0\0\0\t
žŸŸðÿ½¿ßŸÿùÿí¿
ùûùý¿žŸéÿÐðš\0\0¬Ê\0À\0\0\0\0Ð­\n\0\t\0 ¼\n\0éàÊÐÊ\tà\0¼°ð\0\n\0\0\n\0\0\0\0 À \0\n\0\n\nÙ© \0\0\0\0\0\0\0\0\0\t ð\r©¼½½þý¿ÿžžŸ›Éý
ÐŸ
ðùðŸ\t­\0à \0\nš\0\t\0\n\nÊ\n\0 Ð éÀÀ­š\t  °ð
ËËÀ \0\0\0 \0\0\0\0\0\0\0\0\0\0\n\n\t\n\0\0\0\0\0\0\0\0­\0\0\nÉ\0úÝééûÚÛÛùðùùð¼¼°½¯ðÿ\té­úÛË\t\0\0\r\t­\nÀ\t ÊÉ\0É\0\0\nÀ\0\n
À ÀÊÉ\0¬\0\0¬°ð\n\0\0\0\0\0 \0à\0 \0\n\t\0\t\nÚüš\0\0\0\0\0\0\0\0\0 \0\0žð
›žù½¼úÛÉ¬¹Ë
ËÚŸ\tßÚ\0à\0\0\0 \0É\0\0\0\0É \t \0\t éà\nÉ ©¬©\nš\nÀð\0\0\0\0\0\0\0\0\0\0À\0\0\0\0À\t\nÉ­¬ \0\0\0\0\0\t¬\0\t\r¬©é­¬¹\0¿œžœ¿\tú ðœ©ð©\0\t\0\t\0 \0\0\0 À¬\0\0\t É\0\t¬\0ÀÊÐ°É© É Ð\0\0 \0\n\0\0\0\0 \0 \0\0\nÚ\t¬½°À\t\t\0\0\0\0\0¬\0\0¾š\t©\0ðÛŸ\0ËÉ
\t
É\rŸ\tàœ\0Ð\n\0\0 \0\t\0\0\n\0 \0¼\0\0\0À \0\n\0­© \r \0\0\0\0\0Ê\0\n\0\0\0\0\0\0\0\0\nÉ\nšž\nÀ\0\0\0\0\0\0 É\0\0\0°É©àÉ°šððð­šÚÛà \t 
\0\tÀð\0\n\tÉ à\0°\0°
Àé\0àÚÀ\nÀé\t \t ©\nð\n\0\0 \0\0\0\0\0\tà\0\0\n\n\t éé­éÉ\n\0\0\0¬\0\0¿é\0\0\0\tÊÚ¼œ°¼œ\r°š\r°\0Ð\0\t \0\nà\0\nš\r\0\0\n\0\0\0\0\0\0\0°\nÊšÊ\0°à°\nÊÉêÉÊÀð\0\0\0\0\0\0\0\0\0\0\0\0\0\0Êœ\0Ë\0ž\t¯®œ \0\r\0\0\0\0\0þÀž\0\t\nœ\r
éË
É©àË\0É ËËÊ\t\0\0
À
\0œ\0\0\0 
\0
À\0\0¬¼\0œ Êœ\nÐ© \r ¼°Ð\0\0\0\0\n\0\n\0 \n\0\0\0\0\n\nËé®œŸ
\r \0\0\0\0\0¬žš\0\0\n\0
\nÐÚºÚ›\0ÚÐ°Ê\0\0\tÀ\t­\0\0\0°­\0à\0\0\n\0 ©\0°\0¼ª\0à­\nÀËÊ  \0\n\0\0\0\0\0\0\0\0\0\0\n\0 \0œ\0 É
¯Ê\0 \n\0\0¼\t©ü\n\0\0œ¼­šÚÛ\r\r
\t
À é\0\0\0\0\n
\0
\0\nœ\0\0\0\0\0\0\0\0\0\tÀÊÀàšÀ\tÀ
À¬°°©Ë\0úð\0\0\0 \0\0\0\0 \0\0\0\0œ¬©àœ¾°éÀð½­\0\0\0\0\0\nËËÀ\0
\0 \t\t©­\tàÚ\nšÐÊ\t\0\tÉ\n\0\0\0\0\r\t\0šœ©¬\n\0 \0œ\n\n\t\nà à¼ ÀàÊÀ¬ž\0ð\0\0\0\0\0\n\0\0\0\0\n\0\0\0\0\0š\0\0Ë°þ­\0\0\0\0\tžž\0\t\n
àš\r­\0
\r \0\0\0\0\0\0 \t \r ©\0¬\0\0\t\0\0\nœ¼ Àà\r
\nÚàš\r©Ê\0ðÐ\n\0\0\0\0\0\0\0\0\n\0\0\0\0\n\n\n\0¼°ð\tððÚ\0\0\0\0\téà\0ÊÀ\r\t
\tàð­¬\n\0\0Ð\nÐ\0\0\0\0 \r \t\0\0
\t\0\0\0 Ê\0\n\0\n\0ž
\n©¬\0é
Àð\tê\0 \0\0\0\0\0\0\0\0\n\0\0\0\0 Ðœ

Ê\0ð¯ž¾Ð©\n\0\0\n
\0°¬ Úž\t\0àÐ\t\0\0\0\0\0\0\0\t\nÀÐÚ\t©\nÀ \n\0\0\0œ\0Ðà\0À¬
\0Êžœ©¬\n\0é\tð\0\n\0\0\n\0\0 \0\0\0 \0\0¬©àÀšÚÚ\0Ð½éÉ­\0\0\0©î\t¼¬\t\tàð \0°°
\0\0\0\0\0\0š\n\0\0 \0É\0 À\0\0\n\n\0à©\nË\nÉàà¼ \nÀËÉË©ààð\0\0\0\0\0\0\0\0\0\0\0\0\0\0À\nš\t
¬¾š\n\0\nÐš\0©à\0°à©Ë°\0\0\0\0\0\0 \0\r\r\0\0\n\n\t\t\nÀà\0\r\n\t ÊÉ¬\t œž\0Ú\r© ª©Ê\r Ð\0\0\0 \0\0 \0\n\0 \0\n\t \nÐÀ\0ÚÐšÐéËÉ¬¬\0\0\nÊ\t\r\nÐ\téÀà°\0\0
\0\0\0\0\0\0\0\0\0ð  \n\0Ðœ\0©\0\0\n\0\0 ° Êž  ¾\0ðÊÉÉéÊ\r °\0\0\0\0\0\0\0\0\0\0\0À\0\n\0ð\0°à©¯©à­šð\nÉ À¼\0à \r ž\0 Àž\0\0\0\0\0\0\0\0\0\0\0\0Ð\0\0\0©  \0
\0\n\0
\nœ°à
Àž\0©\n\n©Ê
Ëà \0\0\0\0\0\0\0\0À\0 \0œ\0\0 À\0žÛÊ\t­
É¬\0\n\0\0à\0\tÉà\t­\0\t\n\0\0\0\0\0\0\0\0\0\0 š\0\0\0\0À\r ©\0\0¬\0
À\n
\nÀ\r¬\0é¬ ËÊÉàÉÀ­\0ð\0\n\0\0\0 \0\0\0 \0\0\0 \0¼
\nž\0­­¼\nÐ¬šž\n\t\0\0ž\0 šÀþ\n\0ž\0\0\0\0\0\0\0\0\0\0\0\0ÀÚ\0\0 š\0©\0­ \0\0\0À\nš°­ \nÚ
Ë© 
\n\n\tàÐ\0\0\0\0\0\0\0 \0\0\0\0\nÀ°\0\t\0\t\0Ÿ\nÐé­©Ë¬\0ÊÊ\0\0\n\0\0Àš\tÉÊ\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0 \0\tÀ\0\0©\0À\0¼

\0\0À
\n\n¼ ð¼\nËÀÊÐéÊÉà
°\0\0\0\n\0\0\0\0 \0 \0\t\0\0À¬ à àà­ªÚÚ\r Ð°Ê\0\t\0 \0\0š\t¬ž\n\tÀ\0\0\0\0\0\0\0\0\0\t š\0\0Ê\0 žœ\0© ¬\0\0\0©\n\0é Ú\0œ\nÀ­\0 ¼\n©\n\tàà\0\0\0\0\0\0\0\0\0\0\0\0\0à\0°\0\0ÐšÚœ¼½ Ë\nË\0\0 \0À\0\0ËéÀ\0\0 \0\0\0\0\0\0\0\0\0\0°š\t \0œ\0\0 ¼\t\t©à\0 À°é\nÐ­ é\0¯\téËÊÉÊœð\0\n\0\0\0\0 \0\0\0\0\n\0\0à\0\nš\0à\0\r Ú\0ð°à¬É \0\n
\0\n\0\n\0\0\0\0\0\0\0\0\0\0\n\0\0ššÊ š\r\0\nš\0\t \n\0\0\nÀ¬\nÚ\0é\0à\n\0© ¬ Ð\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0°À
\0 \n\r©\t­¬\0ð\0\n\0\0\0\0œ\r\0\0\0Ð\0\0\0\0\0\0\0\0\tššÊ\0\nÀÐ\n\0\0Àà¼\n¼šË¬¬àžœ¼¼\tà°\0\0\0\0\0\0\0\0 \0\0\0\0 \0 \0°
\tÀ°ÚÀúÊÐš\0° Ú\0\0\0\0\0°\0 \0 \0\0\0\0\0\0\0\0°éš\n\tÉ\n° °Ê\n\0\0\n\0¬Ë\0šà°ð\n\nÀ° Ê\tà\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\nÀ  \0À º\r©î\r\0ÀÊ\0\0\n\0\0\0\0\0ðÐ\0\0\0\0\0\0\0\0\0À¼­žšÉ  \tÊ\nÀ¬°\t\0Àà\nÐÊÐà¬¼¬°ÊšÀ°ËÉ­ð\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0 \0\0Ð\0 \0\r ðšðð°\t­ \0 \0 Ê\n\n\0\0\0\0\0\0š
ËšÙ©é¬Éà\0\t
\nÊ°à¬¬  \0À\n©\nÐ\nÊœ\t¬ \0°\0 Ê\0ð\0\0 \0\0\0 \0\0\0\0 \0\0\t\0\n\0\0œ© °É­\n\nÊðÀ\0\0\0\0\0\tÀ\0\0\0\0\0ÀÚÀàÐ\0À À\0\0\0\n\0­\0¬\r\n\0Ê\0\0\0\r\0\n¬­¬¼¬¼ ¬
ËÊÊÐ¼ð\0\0\0 \0\0\0 \0 \0\0\0\0\0\0é\0\nÀ\0\0ÀºàÀ­ß\r\0úÚ\n\0\0\0\0\n\tà­ \0\n
\0š\nÚšœšœ\t \0\t\0 Ë\0¬°É¬¬° \n\0\0\0©
À\n\0Ú\0šÐ¼\0¬\nÀ°\0à\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\nÀ\0\n\n\nžšÉÉ¯\n\nÚË\r¬\0Ð\0\0\0\0\0\r\0©É\0\t À\0\n  Ê Ë\0\0¬\0 \t\0\0\0©°ðð ðà¬\néé\r žð\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0 \n\0\n\0\0\0Ð\0é ¬\0Ððé¬ ÚÚ\nÀÊ\0\0\0\n\nÚž­­©\r©É\0\0\0\t\0
ÊÀšÀÚÊ\0\0\0\n\0\0éª\0\nœ
À°ê\n Ê\0ð\0 \0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\n\ržšž\n\0šÚÚ\r©É\n\0\0\0\n\0\0\r\t ¼­¬°àÐ\0\0à\0 àœ°ž\n\0\t©àš\0À \0°\t\0ÉÀ­ àðà¬Ðàžð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\n
À­àœ­¬\t Ú\n\0\0\0¬\0À\n\tÀšÉ\t ËË\t\0 \0àœ\t\nÀ\0¬\nÀ \0 \0\0\n\0\n\nÉ

É \n\né \0à\0\0\0\0 \0 \0\0\n\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0¾
\n
ÊÉ¬°ÐðÐà\0\0\0\n\tÊ\nÀ\n\t\0Ë\0\0À­\0à
\0Ð©\0\0À\0 \0\n\r É¬¬
à¬œ°ðË°Êð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0é\tÀðœ°À \0 \0© \0\0Ð©\r\0Ê\0ð \t\n\n\0 àð¬©\0à\n\0 \0\0À\0\0É Ë\t\nÀ\r\n À\n© Êð\0\0 \0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¬¯\0à°šÐà\0\0à\0 \0\nÉ Ðà ©\0\0 \0\nÀÚ\0É\0à\0\t\0\n\0\0\0\0\n\0\0¬  Ë\0é­¬ ­ž\nÐð\r Ê\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 Úž\tëé¬\nà \t\0\0É\0\nÀ\n
É\0àÐéÀš\0À°\0¼\0Ê\0\n\0\n\0\0\0\n\0\0\r¬é\0
\tÊÊ\0¼\n\0é\n\r¬à\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0àéà\0ž
ÐàÀ\0  \0 à\tÀ\nð \0 \0\0°\0\0\n\n\0\tÀ\0\0Ê\0\0\0\0\n\t Ê­¬¬ ÚÉàË­\nú\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 
žšÚ\tà šÊ¬œ\0°\0\0à\0à¬œ\0\0à\0©\nÉà\0¼¬\0\0°Ê\0 À\n\0\0\0\0 \0Ðà\té\nÐ\nÚ\0 °\nÀàÐ\0\0\0\0\0\n\0\0 \0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0Ð\t\n ÞÊÐ ¼¼°\0ð\0¬   \0Ð\t\n\0À\0\0\t¬\0À \0\0\n\0\0 \0  šÐ¬\nÀ ð\0é\r \n¼š\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0  éË\r àð­©\nÉÊÚ\0\0¼\nË\r\rš\n\n\0¬\t ¬
\0©\0\0\0\0\0\0\0\0\0\0\0\t¬\nÀ¼šœ\nžà\n\0éÊ\0¬žà\0\n\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0É\0¬\nœ¬
Ê¼ž°\téé\0¬\nÐ\0\n\nšÀ\r\r­\t¬\0š\0 \0À \0\0\n\0\0\0\0¬°šÀ°ÊÀàðÀà\nÉé\n\r¬š\0ð\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0šÐ š\0œ
Ê\tÏ\0\r\0\0¬¼\t­  \0 \0 À°¬\0\0\0\0\0\0\n\0\0\0\0\n\0\0ÊÀ¼\n\t \n\t \r \nÀðÐ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0 \0À¬\nÚÀðž\nž\r¬ \t­© ­ \t\nšš\0\0\nÀð\r À\0 \0\0\n\0\0\0\0\0\n\0\0\0\0©\nÀðÚÀàéààÊÀð\n¼š\0°\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¼\0š\0à\té\n
\nÚÀ\0ËÀ\r¬ À\n\n\0°é\0\0 \0\0 \0\0\0\0\0\0\0\0\0\0\nž­
\0 
\0\n©
\0ðË\0¬à\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\n\0\0
\0Ë
Ê\tÀÐ\0šÚ\0¼ \0É\0 \0\r\0\0\0\n\0\0\0\nÊ\0\0 \0\0\0 \0 \0\n\0\0\0°\0¬\r ¬¼¬\n¬\nð\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0é¬\0¼\tà ®À\0\t\0 àÚ\t\0\nÀ\0\0\0Ê\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0œ
\t Ë\nÐ\n\t\0°
É šÐàÐ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0À®œ\0¬\0 \0ÐÐ\n\n\0ààà\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0àé ¬\r À éÊÊÀà\nÀà\n\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0Ð\n\0
\r
\n\0À\0\0\0\0\n\0\0\n\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0 \t\0ÊÐ š
\r\0 °
\0¼
\0­à\0\0\0 \0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0šÊ\nÀÀ\0 \0
\0\0­ \0\0 \0\0\0\0\0\0\0\0 \0\0\0\n\0\0\0 \n\0\n\0\0\0\nÊ¬ž©¬\nœ¬\n­\n\0ð\0 \0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0 \0\n\0\0à\0 \0\0\0\0\0 \0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Àœ¬š\0°Ê\tà \0 šÉ \nÉàÐ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\n\0\0\0\0\0\0À\0\0\n\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0 \0\0\0\0\0\0 \0 \n\nž­¬œ¬\nÉà\n\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \n\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0éÉÀ 
\0 
\t \0 \nœ\n\t¬žð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\n\0 \0\0 \0\0 \0\0\0\0\0\0\0\0\n\0\n\0\0\0\0 \0\0\0\0\0\0à\n\nžž¬¬¬žœ ¼¬\n\0ð\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\n\0\0\0\n\0\0\0\0\0\0\0\0\0\0 \0\0\0\0ðÀ \0°š\0©\nš\0\n\0šÉàÐ\0\0\0\0\0\0\0 \0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\n\0\nšÊÊÀàÚÀààààéé¬  \0 \0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tàÀ  š\t\0\t\t\0\0\0\ržð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\n\0\0à\t¬¬­¬­¬¬¬¼­   ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\n\0\0\0\0\0\0à\t\n\0©\0 \0\n\0\0\n\0ËÀÐÐ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\n\0\0 \0 \0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0š\0àéÊÀààÚÊÊÐÚÚÀÚ\0\n\n \0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\n\0\0\0\0\0\0\0\0\0\nÀÚ\0 š\t\0 \0°\0 \0 ©Àð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n­¬ž¬­¼¬
Ê\nð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\n\0\n\0
\0\n\0\n\t
\t\t\0\t\0\0Ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¬­¬¼­¬­¬¼­¬¬¬¬­¬­¬ ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 ­þ','Margaret holds a BA in English literature from Concordia College (1958) and an MA from the American Institute of Culinary Arts (1966).  She was assigned to the London office temporarily from July through November 1992.',2,'http://accweb/emmployees/peacock.bmp'),
  (5,'Buchanan','Steven','Sales Manager','Mr.','1955-03-04','1993-10-17','14 Garrett Hill','London',NULL,'SW1 8JR','UK','(71) 555-4848','3453','/\0\0\0\0\r\0\0\0!\0ÿÿÿÿBitmap Image\0Paint.Picture\0\0\0\0\0\0 \0\0\0PBrush\0\0\0\0\0\0\0\0\0 T\0\0BM T\0\0\0\0\0\0v\0\0\0(\0\0\0À\0\0\0ß\0\0\0\0\0\0\0\0\0 S\0\0Î\0\0Ø\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0€\0\0€\0\0\0€€\0€\0\0\0€\0€\0€€\0\0ÀÀÀ\0€€€\0\0\0ÿ\0\0ÿ\0\0\0ÿÿ\0ÿ\0\0\0ÿ\0ÿ\0ÿÿ\0\0ÿÿÿ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0À\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0é\0\0\0\0É\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\r\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\n\0\0\0\0\0\0\0\0\0\0 \0\0\0é\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0À\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\n\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0É\0\0\0\0\0\0\0\0Ê\0\0\0\0\0\0\0\0\r\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0¬\0\0\0\0\0\0\0\0\n\0\0àà\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0Ê\0\0\0\0\0\0\0\0°°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0À\0\0\0\0\0\0\0\0\0\0\0Ê\0ð\0\r \0\0\0\0\0\0\0\0ÊÊ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0œ \0\0\0\0\0\0\0\0\0\0\nÊœ\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0À\0
\0\0\0\0\0Ê\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0 \t\0\0\0\0\0\0é\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0É\0\0\0\0\0\0\0\0\0\0\0\0\0\r \0\0\0\0\0œà\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0À\0\0\0\0\0 \0\0\0°Ð\0\0\0\0\0\0\0ê\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 °\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°\0\0\0\0\0 \0\0\0\0À\0\0\0ÀÐ\tË
\t\0\0\0\0\0\0Þ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ð\0\0\0\0\0\0ÊžŸ

œ¼°Ð\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¹ÀÐ©É­ËšÐ°\0\0\0\0\0\0ï©\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0À©\0\0\0\0\0 \0\0\0\ré¹­œ°Û\r¼\0\0\0\0\0\0\0\0À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0à\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
\0\0\0\0\0\0\0\0\0œ©šÐÚšÙ­ð
Ë\t\0\0\0\0\0\0À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0© \0\0\0\0
\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0
Ü°ù©©É
É­œ\0\0\0\0\0\0\0à\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÀÉ\r­
\rœœ¼¼šœ¹Ë\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°
\0\0\0\0 \0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0à\0\0\0\0\0\0\0\0\0\n
ššÐð¹©©\t\t­ùœ¼™Ê\0\0\0\0\0ÀÀ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°\n\0\0\0\0\0\0\n\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\t\0\0\0\0À\0\0\0\0°ÐÙ©œ\r\ržžœËÛéœ\t\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0À\t\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0À\0\t\t\r©¬œ©°°\t\t
¼\rž›\0\0\0\0\0\0\0Ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t©\0 \t\n\0\0\0\0\0  \0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\nÚÚÛšùàðÙ\r¿­¬\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\r \0\0\0  °\t\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\nË\0\t\0\0\0\0\0\0\0­\t\0Úœ\r\0¹é\0™
ÛÀÛÛÉ\0\0\0\0\0ÚÐ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0Ë\0\0\t\0\0 \0\0\n\0\t \0©\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0É\0\0\0\0\0\0\0\0\0©\0\nÚÚœ¹©¼\0°ÙëÉùí­°\0\0\0¬ \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\n
\0\0°Ú\0\n\0Ë \n\n\0\0\0\0\0 \0\0\0À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\t\r\t\t
\t©\r\t\nœšËšÛÏ\0\0\0\0\0\0Ð\0\0\0\0\0\0\0\0\0\0\0\0\n
°À\0\t\0\0\0\0ÐðÉé\t\n\0\0\0\0\0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0°\0\0\0\0\0\0\0\t¼°¼¼œ›\0ðÐ
šÐ\tÉ¼ŸÍ¾›\t\0\0\0\0í \0\0\0\0\0\0\0\0\0\0\0­¬\t\0\t\0\nË\0\0à\n\0ëê\nÊ\0\0\n\0 \t \0\0é\0\0ë\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0œšš\0É\t©Ð\nÐ\tð¼\nÚ›Éü°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ïß½­ \n\0š\0\0š\0š\0žù¬ \0\n\t\0\0\0\0\0¬°\0\0\0\0\0\0\0\0\0\0\0\0\0Ê\0\0\0\0\0\0\0\0©ð°ð\r\tÚšÉ\0©Ð©à\r
Ù­éþŸÉ\0\0\0\0\0\0\0\0\0\0\0\0\0žÿÿëË\0\t\n\0\t\0š\0\0\0À\0\nï\t\0\0 \0 \0 \0\0\0Ë\0\0°\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0ž\0\0œ\tÉ\t œ©É\0ù©À™ððÐž\r¼»\0\0\0\0Ê\0\0\0\0\0\0\0ïïÿÿ½ðÚ\0\0\t\n\0\0\t\t \0\0Þ¼š\0°\0\n \0\0\0\0þ\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0ð¼°°°šÙ ¹\0©ð\0šÙ©éùíé\0\0\0©\0\0\0\0\0\0ÿÿÿþýï °é\0
\0©\0\t\0\t\0\0 ë\0 \t©\0\0\t\0\0\0\0ð\0\0à\0\0\0\0\0\0\0\0\0\0 \0\0\0\0 šž\0\0\r\t\tÉ
É\0É­©ÊÐ\0ùŸ\r ÚÐúÛÞ\0\0\0À\0\0\0\0\0ïÿÿÿÿûùý\0©\0 \0\0\0À\n\0\tà\0\0\0\0\0Úà\0 © \0\0\0\0ì¼\0
\0\0\0\0\0\0\0\0\0\0\t\t\0\0\0\0ÀÀ\0\t°°Ú\tÀ°š\t\0
Éð\0\0°Ú­Ÿ\0\0\0\0\0\0\0\0\0ÿÿÿÿÿÿÿï
É\0\0\t\0\t\0 \0\0\0 àšÊ\t\0\0\0\0\0\0û\0\0°\0\0\0\0\0\0\0\0\0àà\0\0\0\0š\0\0žœš\r\té \t
ÉÉ©ËËÍ¿Ú\0\0\0à\0\0þÿÿÿÿÿÿïÿùúš\t©À \0\n\t\0\tÀ \0\n\t ©¬° \0\0\0\0\0ïé \0\n\0 \0\0\0\0\0\0\0\t\0\0\0\0\0\0­©é\r©©É¬\0É\t šÐ\0àžœ¼¼°í­°\0\0\0\0ÏÿÿÿïÿÿÿÿÿíúÀÐ\0\0\t\0\n \0Ð\0\0\0\0\0ÿêÀ\t\0\0\0\0\0ÿ\0\0\0 \0\0\0\0\0\0\nÚ\0\0\0\0à\0™©\t\t\n©›\0°\t\0\tÀ\t©\t\0ððžßžßÀ\0\0\0\0ïÿÿÿÿÿÿÿþÿÿûý»\n\0\0
\0\n\0\0°  \0\n\0\0\nÊÛ\n\n\0\0\0\0Àÿë\0\0 \0\0\0\0\0\0\0\0\0Àà\0\0\0\0\r©ËÉÉ¬šÉ\0\t\n°š¼\0ð\t\t ù©°\0\0ÿÿÿÿÿÿïÿÿÿÿÿëÉÐ\r©\0\0\n\0\0\0\0 \t\0\0\0\t\0\0\0 \0\0ïù\0°\0\0\0\0\0\0\0\0\0©\0\0\0\0\0\0¹\t°š™°šðÉ\0\0\0\0\0šÀ\tàðüý­üù\0\0\rÿÿÿÿÿÿÿÿÿÿïßŸú
\0\0\t\0œ\0 Ðà\0\n\0\0\n\0\nš\0\0\0\0\0\0Îÿé \0\0©\0\0\0\0\0\0\0Ë\0\0\0\0\0\nËÐðÉ\tš©\0\t\0\0\n\0\t\0\0\nÚ\t\r
šžž\0\0Êïÿÿÿÿÿïÿÿÿÿÿëï\0Ðš\t \0\0\0\0 \n\n\0\0\0\n\0\0\0\0\t\0\0\0ý°\0\0\0\n\0\0\0\0\0\0\0\0ð\0\0\0\0\t¹›¼\r¬°À¼\0\0\0\0\0Ðéííééð\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÛù \0\0\t\0\t\n\0\0\0\0\0  \0\0\t\0\0À\0\t\0\0
\0\n\t Ð°\0\0\0\0\0\0¬\0\0\0\0ÊÛËÀ¼™ ™\0\t©\t\t \t\0\0\t\0\0\0\0\0©
\0°ü¼û\0\0Ïÿÿÿÿÿÿÿÿÿÿÿÿÿ­­
\t\tÊ\t \0\n\tà\t\n\t\0\0\n\n\0\0\n\0\n\0\0
\0
\0\0\0\n\0\0\0\0\0\0\0Þ\0\0\0›™™\t  \n\0\t\0\t\0\0\0\0\0\0\t\0žÞŸ\t\0\0ïÿÿÿÿÿÿÿÿÿÿÿï¿ÿ°° \0\0\0\n\r©À\t\n\0\0\nš\0\0\0\0©\0
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0é \0\0\0é½ššÙ\r\t
À\0\t\0\0\0\0\0\0\0\0\t\t©­\t®žžÿÿÿÿÿÿÿþÿÿÿÿÿí¹ËÉ\0\0\t \t\0\0\0°\0\t\n\0\0
\0\0\0 \0Ðš\0 \n\0\0ë\0 ë\0\0\0\0\0¼\tÀ\0\tŸ\t¹É™\t\0š\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\nÙéé\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿï©\0°\0©
\0\t\0\0°À\n\n\0šš\0\n\0\0\0\0 \0\0\0\0Êð°ÿù\0\0\0\0\nËà\0\0™ùËžšš\t \t\t\0\t\0\0\t\0\0\0\0\0\0\0\0\0\r ­žÎÿÿÿÿÿÿÿÿÿÿÿÿÿûý¼°\0\0\0É\0à\n\0°\t\0\0 \0\0 \t\0\t é\t °\n\t¾\0ÿû\0\0\0\0Àð\0\0ù¿›™\t\r
\r\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\r\nÐí ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÚÛ\0š\0É©\n\t\t\0\t\0\n\t\n\0\0\0\t \0šÊ\0\0\0\0 \t\0\0ïÿÿð\0\0\0éà\0¹éÚÚÚšœ°\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0¼ž›\rïÿÿÿÿÿÿÿïÿÿÿÿþûëðË\0°\0\0š\0\0\0¼\0\0\n\t\t\n\0 À \0ðì½­ ©\0
\0\nÿÿÿÿ°\0\0àð\t\0Êý½¹™\tÉ\t©\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t¬\0éìþÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¼›\0\0\0\0\0\0°\0°
\0\n\n\0\0\0©\0\0\0°Ê\0\0 \0\n\0ÿÿÿÿÿù\0 \0ŸŸ›ËÚš°Û\0\t\t\t\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\tÀšŸÿÿÿÿÿÿÿÿÿÿÿÿÿÿýûé¹\t©\0š
\0 \t\0\0\0
\0\0\0\0\0é\0 \0©à¬\n\t \0ïÿÿÿÿÿÿ\0\nð\0ùûù¹©ÐÐ
\0\t\0\0\n\t\t\t\0\0\0\0\0\0\0\0\0\0\0\0©ÀÚÌÿÿÿÿÿÿÿÿÿÿÿÿÿÿûü¼\0 \0©\0
\0 \0 \0©\0\0  \n\0É\nœ©\0°\0\0\0ÿÿÿÿÿÿÿ°\0ÿ½Ÿ\tÙ©

\t\0š\0\0\0\0\0\0\0\0\0\0\t\0\0\t
\0ûÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿËÐ°Ð\t\t\0\0   \t\0\n\0\0
\r \nÀ\nÞú\tà°ÿÿÿÿÿÿÿÿù \0ÏŸŸ¹ð¼šÐœ\0©\0\0\0\0\0\0\t©\t\0©\0À
­ÿÿÿÿÿÿÿÿþÿÿÿÿÿûû©\0\0 \0 \n\0š\t\0\t\0ž\0 \n\t\0\0 \0\0°\0\0íð\0ÿÿÿÿÿÿÿÿÿÿ°Ð\0Ÿÿ½½½›\t
\t°\t\0š\t\t\0\0\0\t\0\tÀ\t\0\0Ú\0\t©À\0°Ïÿÿÿÿÿÿÿÿÿÿÿÿþýí­¼°°\t\0 \0©
\0 \0 \n\0\t©\0©©\n ÿÿÿÿÿÿÿÿÿÿÿÿù \0ï¿ÛÛ\t­ž\t\0\0\0\t\t
\0\r Ð\0\t\tÉÀœ©é­\r¯ÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ûÚ\t\0\0\0 \n\0\n\0\t\0œ \0\t Ð\0
\nÊ\0\nœ\0¬œ¾ÿÿÿïÿÿÿÿÿÿÿûÀÿý»ËÛÐ©\t\0©\t\t\0 \t\0\t©\t©é\tšÐ°©Êœ\0À\nÞÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¼¼š\0°°É\0© ž\t \0\n\0œ\0\0à¼š\nËßÿûÿÿÿÿÿÿÿÿÿ¼\0ÿûý¹\t©šË \0 \t\té©©¼°É\t\rž\tËË
É\rÿÿÿÿÿÿÿÿÿÿÿÿÿÿÛ
\0\0 \0Ê\0\n\0\n\t\0ž\tà\n\nœ
\0  °\0ž\n\r\nëï¼ÿÿÿÿÿÿÿÿ©
ÿÿ›ß½ž™\t\0\t\t
É\t\t\nÙ\r\t¹­
ËÐÛ\r°ð¹þœ¼Ð¼ ÿÿÿÿÿÿÿþÿÿÿÿÿûïðš\t\t\tÉ\t\0\t\0\0\0Éš\nœ
\t\0\0\n\0ðÚ\0\r\0Ëÿÿÿÿÿùú\0
ÿÛý¹Ë\t\t\n\0\t\t©™\nÚžœ™ù½
›\rÞëÚšÉ\rïÿÿÿÿÿÿÿÿÿÿÿÿ¯Û\r©\n\0\0 \0©\0\n\t\n© \0 \r\nÀ š\0©Ëú¼°°žœ­\n\n\0\0\0\0¼ÿ¿Û½¹ž™
š\r°œ½™É
ÚÐ½\t°ÛùËÞ½ì¼šÚÿÿÿÿÿÿÿÿÿÿÿÿýºÛ\t\t©\t©\0\0\0\0\0©ÀÉ \n\n\té©\n\0\r\n\rë\0 
\n\0\0\t\0\t\0ÿý¿Úž™\n\n\0\t¹ËËšÚ›Ð½½šÛË\r¼ÿÚÛËÉ\r¬ÿÿÿÿÿÿÿÿÿÿÿÿûý \t \0\0\0Ðš\0šÊ¬à\0  \nü°àù ÿË\0\0\nš\0úÿ¿½½¹Ð\t
\t\0ž\r\n™¼™­½©\t
É\ršÐÐðý­ð¼°šÏÿÿÿÿÿïÿÿÿÿÿÿ¯Û\0š°\n\0\0\0\t\n  \0°°
\n\0\0­\tàš\0ÏÿÿûË\0\0ÊšË\0\0ÿÿß½¼¹œ
\t\nœ¹©š¼›ž››½½½¹©éŸŸŸúßÚÚÐžÿÿÿÿÿÿÿÿÿÿÿíù­©\n\0\0\0 \n\t\t\0ž\r\n\t\0\n\tÀðÉ\t \0¯é¬ÿÿÿÿÿÿÿ¹ÐÚ\0\0\0ÿ½»Û\t\n
©Û\tùÉ\tÙ\rššÛÉ¼Ÿ™ééí­ðÿ
É\téÿÿÿÿÿÿÿÿÿÿÿûúÐ\0\t\t\t\0\n\r\0 
\t\n\r\n\n\tÊš\0°à\t©À¾ Ëïÿÿÿÿÿÿ
ï\0ÿÿý¹ÛË\t\t\n\t\nœ™°Û\tð¹ù­¹ùÙ\t°ÙùïŸŸŸžŸéí°ðšÏÿÿÿÿÿÿÿÿÿÿÿŸ
\nÐ©  \0
\t\0\nÐ\0\n\n\r\t
\0ÊïÚ\0šÚÿÿÿúÚÿù\0\0ûùûÚÚ™À™

\tð½½\t™šŸÛ
\rž½ËËÐßžÛž\ršÿÿÿÿÿÿÿÿÿÿ¿éðÐ\t\0œš\0\0\0 \0\t\nž\0À° Êœ\0¼¼¿ÿÿÿûÀ\0\0Ë
É©Ïÿð\0\0ÿÿý½¼°ð\t\0›¼™\t\t½¹­¹\rŸ\0ÐÚ™ùŸ¯ðùÉð¬ßÿÿÿþÿÿÿÿÿÿ¿

\0\t\0\0 œššž\t\n\r\0š
©ÊŸËËÿïÿÿÿÿÿþ¼þžž¿ý©\0ÿ½¹©\t\t\0¹
\0

Ë
žšŸ
\tÙœš\t\0°Ùí½éü½Ðð›\0Ùïÿÿÿÿÿÿÿÿÿðð¼\nš\n\n\0\0¬\n\t\t\nÐšš\rš
Ê\r žýïÿÿÿÿÿÿÿÿÿÿûÏûÚ\0\0ÿûýð°\t™\t\tÙÛ

\0šÐ°›É¼»Ëù¯­­ žÿÿÿÿÿÿÿÿÿÿÿ \0œ\n\t\t\t\t\t\r\0Ê\nÀ\r °ÉÀœ°ÚÉ¯ÿÿÿÿÿÿÿÿÿÿ½ÿœÿù\0ÿß»É\t\t\0©Ë\r©é­©¼°°¹\tÙÐÙ\0\0É©Éé¼½ÛÐüÛÐÚœÿÿÿÿÿÿÿÿÿÿ½éÚ\tÀ\t\t\0 \0 \0 °©š\r\t °ð­¯Ïïÿÿÿÿÿÿÿÿÿÿùëÿð\0ûûÛšðš\t\t\0Ù\r\tœ¹©\t \0°ÛÚðÿŸ­©éé¼ðžÿÿÿÿÿÿÿÿùëš\0š
\n\0©\t\t\t \0œ\t\nš\r\0ðÐðÿÿÿÿÿÿÿÿÿÿÿÿëßÿ
\0\0ÿß¹ÀÚÛ\t©
šššžšš›œ™©\t\t\t\0\0\t\t\r­­ŸùðÛžœšÉ
Ïÿÿÿÿÿÿÿÿÿùé\t\0\0\0 \t\0ð
Ê\r
\tš\t\0úÞÿÿÿÿÿÿÿÿÿÿÿûßšË\0ÿùð›\t\t
\0\0Ð \r\tÉ™™À›Ðœ\0
ÉßýžŸùé
\ržœ¼ÿÿÿÿÿÿÿÿ¿
\0°\0\n\r©\t©\0é\t\0\nœ\n
\r¬°ðïÿÿÿÿÿÿÿÿÿÿßþûÞù\0\0ÿ¿Ÿ\t¼°Ð™¼
\t\r\n°à°Û™É
\t
©\tÐúúýù­žœ°©éËïÿÿÿÿÿÿÿÿÿ°\tà©\r\0\0\0\0°\0 ž\nÐ\nœœ\t\n\tÀ\tïÿÿÿÿÿÿÿÿÿÿÿúÛÐ°\0ÿý©¼™™© \t™™Ù°¹ùÛ\r\tœ½©ŸÿŸÛÞÛ\t
\ržž½ÿÿÿÿÿÿÿÿ½¯\0\t\0 
\t \0šÐ\0\t\té\n\t¬¼œ°ðþÿÿÿÿÿÿÿÿÿÿÿÿÿžžœ\0\0\rû›™É\nÙ\r\t š\t©éé
\r›É\t©ËÛ›ËÛßžŸ¼ý¼»¼¼°éËÐÿÿÿÿÿÿÿÿûÏ
Ê©\0\0\t \tà\0é \0É¬
\n\0ùïÿÿÿÿÿÿÿÿÿÿÿÿûÚ\t \0ÿùÊš™\0\r\0œš™›É½½Ÿ™\tÉœŸœ°ÛÞÛðÿ­\tðÉ›ÊÚÞÿÿÿÿÿÿÿÿºž\t\0©
\0\t \t©°œšéÀÐðßÿÿÿÿÿÿÿÿÿÿÿÿü½°\t\0\rûÛ½™ùé°¹
\t©
\t\tÊ›\t½\tš™éÛ©ðùÛí½ýÿŸéðŸž­¼¼¹ÿÿÿÿÿÿÿÿý© \t\nœ©\0Àš\0\0À\0\n\0š\n© ð¾ÿÿÿÿÿÿÿÿÿÿÿÿ¿ðð\0ÿÚž™É

É¹ÐÛËÛÙÛ™©Ë\t\r­ŸÏ­éù©\r­©ÚÛÛÏïÿÿÿÿÿÿÿœ°©\0\t©\0œ\nš\t\t­\0Éœ\0ðýïÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\0\0Ïù­½™
Ú›\r\t°ž°\t
\t\t©™\t¼¹\0\0\t\t\tÊßŸŸ
Ê©½½­¬¼°ÿÿÿÿÿÿÿùû

À
\0°\0\t\n\tÀ
\nÀ\0\0

\0éÿÿÿÿÿÿÿÿÿÿÿÿÿ½½é\0\0ûÚšÚÙ­\t°°\t\t­\t°œ¹­¼™\t\t\0\0™\0\0\0\t\tÀ\0Ð™\0Úœ¼ŸÛÏ\tïÿÿÿÿÿÿí­\0\0°Ë\t\n\t\0
ÀÐšÚšÀéÀðž\0ùïÿÿÿÿÿÿÿÿÿÿÿÿÿëÿ\0ûß¹­›ÐÐ›Ë\t
\r\0\r°\t\t\0\0\0œ\nÐ¼œ\n\0\0šŸ©ŸŸžÿÿÿÿÿÿ¿šš
\0\t\0\n\0š°\n\0\0šÀ©\0éŸÿÿÿÿÿÿÿÿÿÿÿÿÿÿ™é Ï¼¹û\r›É©¹ÉÚ™Ú›\t\0\t\r\tÉÉ™\t©œžš\0\0Ð\tÐððùéðýÿÿÿÿÿûùéÀ
\0šÀ°\0À\0\tÉ\t 
œ\tàïÿÿÿÿÿÿÿÿÿÿÿÿÿùï\t\t\0½©Û¼›\nš\t©É©\0\0\0\0\t\t°°š›ŸŸÙé½­
\t\r°¿ŸžÛÏÿÿÿÿÿÿÿË\t
\n
\0\n\t©°°ž\n\n\0\0\r\n¼žÿÿÿÿÿÿÿÿÿÿÿÿÿÿ°¾¹\0¯ùù¼™½
\t¼™©™\t\0\t\t¼°›ÛÙÐ™\té¯ŸËÛ\r\r­\tÉ¹ÚÚß­¼ýÿÿÿÿÿûûÚÐ
©\r\0\0\0\n\tÐœšž\nš
žÿÿÿÿÿÿÿÿÿÿÿÿÿÿý™ý\tœ›ËÚÛÚÛÐ¹ž™éž\0\0\0\0œ™
É\t©©éœùðý°©
ðžÚùý­ðùÿÿÿÿÿÿÿ­­ © š©\t\r \n\0\0
\tÀðïÿÿÿÿÿÿÿÿÿÿÿÿÿÿûù¹¹\tý½½°¿›
À¹
¹\t\r\nž
™™›œÐ
ËËÚßË\rí\té½žžÛí¼½ÿÿÿÿÿÿÛ°œ©©©\t \n¬\0\tÉ©
© ðÎžšßÿÿÿÿÿÿÿÿÿÿÿÿÿÿûÛÛÐœûÛÚÛÙü½›Ðù©\tÀ\tÐšÐ­
\t\0\0\tÐœ½­¼¹é¬¹°™í¯ŸžÛËÛÿÿÿÿÿûûÉ© \0\0 \r\0\t©¬\0 Ê\t\0Ð\t© Þžÿÿÿÿÿÿÿÿÿÿÿÿÿÿý½¹›
Ûž½½¾›\t©©žœ°š\t©\t\r\t\t\0­­­žËÞ›ÐÉï›ÐÚý¾ÞŸýÿÿÿÿÿË­\0›\nžÐ\t \t \0\tðš\nÚ
ÀÐÚ\nßïÿÿÿÿÿÿÿÿÿÿÿÿûûŸŸ™Ÿÿ½¹éùùùÐÚ™¹¹\t\r©\t\t­
Úž™©\0\0ÚÛÚ ü¹\tðûý
Ëùéÿÿÿÿÿÿ½º°œ\t\n
À œ \0à¬\0Ð\0Ðš\n\rÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¹ùùÏ½ûÚŸŸ

™ðÐ\0œž™
\t\0Ð\0Éé­\r­ðÙ\t\0ùŸœžýýßùÿÿÿÿÿÿ\r\t°© °
\0œ\n\n\nš\0é àÐððûßÿÿÿÿÿÿÿÿÿÿÿÿûÛŸŸ¹ûß½½ùùûÙùË\t¹ù 
\n°ÚÐ™
\0\t\r°Ü¼½
œ©
ËœúÛûÚÚÿŸïÿÿÿû
šž\0\tÀ\n
\0©É\0œ\0Ê\r\t\0Ðš\0ðÞÿÿÿÿÿÿÿÿÿÿÿÿÿ½½¹ÛßûÛË›Úù©
™ðÐ™\t\0\t\tÉ\t\t\0Ð\0\r
ÚÐ¼©É›¼Ðý½­û\rÿÿÿÿÿü½\tË
Êš©À\t\0\0ð©
\t\nš\r\0ð¾ïÿÿÿÿÿÿÿÿÿÿÿû©ùûÛ›ß¿ùùðùßŸœ°››\t\0ð\0\tàš°Û\t\t©\t\t\nÜ½­ÙÚ™\t¹Ééûý¾ÿÛÏðßÿÿÿÿ¿
 \0\t\r\n\n°\0\0\nÉ\tšË\r­¿ÿÿÿÿÿÿÿÿÿÿÿùÙÙ½½ÿý¿ŸŸ¹ù¹ŸÐÛ™\t\0°™\r\t\t\0
ÐÛ
\tÊÐ¹ÛÍûÏœ¾ù\tÿÿÿÿûý¼©é ° \n\0°\n
\0àéúÞÿÿÿÿÿÿÿÿÿÿÿÿ›
»ù›ÿûùéùûšÙéù›Ê\t\0œ°Ÿ™\t\r\t
ÐðùœðùÐ™É
Í­ûíùûýŸ½ïÿÿÿÿË šÐ\r\t \0©
É\0\nË\t\0ðœ­\n\r­ïÿÿÿÿÿÿÿÿÿÿÿù½›ÿÿÿŸŸŸ½ùù½¹šÐ¹™\t°\t©É\0\t\0\t©¹Ð¹žÛ™\t
\0š›ÛýùÿÏ­ùßÿÿÿÿ½Ÿ\0°©°°°œ©\t\0\0\0š\tÉ\0ÊÐ\tàšÐðúÿÿÿÿÿÿÿÿÿÿÿÿ¹\t\tûÙ\rÿÿùùðÛÿŸ
ÚÙ¹É©Ð\t\t\0\t\t™\t\tœÚžšÛý­ž\r©éýŸÿùý°ûÿÿÿÿ¿¾°°\tÀ\0\t©\0àð° Ë\t\nÚ\tà­­\rïÿÿÿÿÿÿÿÿÿÿÿÛÛÛÿùÿŸ½¹ûÛŸ›Ù¹Ù©°°\0°ÚÛŸ°ùÿßßß¹\t\tŸÿŸßžÚßùÏÿÿÿÿù¼œ°°ð°° \0\0
°\nÉ\0žÚž¾ÿÿÿÿÿÿÿÿÿÿÿû¹\t\t
ÿÿùý¿Ûßùùù½°Ù©™ÉÛ¹½½»½½¿ÿûÐÚ™\rð½ÿýÿûí¿Ÿ¿ÿÿÿÿ›Êš\t\tÀ\0\n\n\0\t\t­\0\tÀ\tÉ\0­ ÛÏÿÿÿÿÿÿÿÿÿÿÿù\t™ßÿÿ¿›ß¿ùŸŸ›ÐÛ½Ÿ\t\t™
\0\t\tÛÙùÛûÛßýÿýû™\r¬»ŸÛßÿßßÛÞžûßÿÿÿûþ¹\0š\n
\t\t
 \0ž\0©  \0žÚàðÿÿÿÿÿÿÿÿÿÿÿûœ¼°Ÿÿÿßÿ½ùÿ½ùù»›\tÛÚšš™½Ÿ½¹½½ÿýÿù\r©™ÐÚßýÿûÿ½½¹ýÿÿÿþ›ËÛ\tÉ\0\nÀ\0œ°\0œœœ ðàž­ÿÿÿÿÿÿÿÿÿÿÿù›™™\t\tÿÿÿ¿ŸÛÿŸÛý¹Ý»Ùù©™Ð\n\tÉÛÐ½ŸŸ›ÛÛßÿý½©œ¼½½¿ßÿÿÞßï\rûŸÿÿÿûÿš\0Ëššž\n°\n\0\0\t¬\n\n
\r\0\tàðÿïÿÿÿÿÿÿÿÿÿÿ¹ÉÛ\tŸÿÿýÿ½ùù¿›ß›››É©š™›\t©¹Ûùù½­ýÿÛÛÐÛŸŸŸßÿÿßûý¹ÛùÏÿÿÿÿð¼°\0\0\t\t\t \0\t\t
¬
\tÉ\nðÿÿÿÿÿÿÿÿÿÿÿ™Ÿ¹\t\r½ÿÿûÛÛÿ¿ùý¹ùù½šÙ¹œÐ™ÐÛœŸŸ™ÛŸÿÿí½¿ÛÛÏýýÿýý¿Þ½ûÿÿÿÿŸ\t­\nÚžš\n\0ž\0\0œ\n\0°\tà\0ððþÿÿÿÿÿÿÿÿÿÿûù\tÛÐ™¿ÿÿÿÿÿŸŸÛŸÛŸŸ›Ù½ž›¹©Ë›œ¹ùùù½ýýý½­¹ðý½ûÿß¿ÿÚùéÿ¼ÿÿÿ¿úðš\t\0\tÉ\n\t
\0\n\0šÀððžÊžŸÿÿÿÿÿÿÿÿÿÿÿ™Ÿ¹\t\0œ½ÿÿÿÿùÿŸ½ù½ùù½›Ù©œš™¹ÉÛ½¹ÛÛŸÿ¿ÿÛëÞÛÛÛßßÿßßÿßŸù™ÿÿÿÿœ°šš \t\n\0\0\t \r
ÊÀ\t\0Ê\0à¹éïïÿÿÿÿÿÿÿÿÿûšÛÙ¹\tÿÿÿÿŸŸùÿŸ›Û››Ùù
¹¹Úž½¹ûÛŸ¹ýýýý¿ù½½ýÿÿ½ÿûÙðÿûßÿÿûû
\0É\n°\0\t \0\n\0\t
\nË\r­\rÿÿÿÿÿÿÿÿÿÿùÙŸ½šÿÿÿÿÿý½¹ù½›Ý½»\r½¹ÐÚ™™
›ÙÉŸÙÛûßÿÿÿýÿŸËÞŸ½½ÿßßþ¿ßý™ÿÿÿÿðð

\nœ\0\0\0\n\0œÚ\0 ššÚÐüÿÿÿÿÿÿÿÿÿÿûùû\t\0›ÿÿÿÿ¿ÿÛŸÛÛ›ÙÙ¹™Ë›¼½œ»Ÿ¹¿ŸŸÛßÿŸÚÛùùðßÿŸÿ½½žÿûÚßÿÿÿŸ
œ\0
\0°\0 \n\0Ð°¬œ¬\r©­¯ÿÿÿÿÿÿÿÿÿÿù™½¹¹\tÏÿÿÿÿý¹½ù¾½¹¹ÛÛ™Ð›\t°¹ÙùÛÙ»ÙýÿÿŸÿ½½Ÿ›ÛùùÿŸþÿýÿÿ™ÿÿÿðû©
\n\0\t\0\0©\0\r\t\nÀ°\t\núžÚÞÿÿÿÿÿÿÿÿÿÿ™éûûÙšŸÿÿÿÿÛÿÛ›Ù›™Ÿ\r°™¼¹ùŸŸŸ›Ù½¿ŸŸÿßýÚÛß­ŸßýÿßÚÚÿùžßÿÿÿðœ°°\tÉ
\0\0\0 \0\0\nË\nÐË\0Ð­ïÿÿÿÿÿÿÿÿÿÿ¹™½¿Ÿ™Éÿÿÿÿÿù½½½½½¹¹­™Ù\t\t
™ð»ÛÙù½ÿß½¿½¿\tÛÙùËéÿÿûÿÿŸÿ\tÿÿÿûß©\t\0Ë\n\n\0\0 \0©\0Ð©¬¼¯
ÿÿÿÿÿÿÿÿÿÿùž™ûÛù¿Ÿÿÿÿÿ½ÿŸ›Û™ÚÙÛ™š›
™ù½½­©ù½›ßýÿÞÛÙð°©½ÿŸßßÛßÿŸŸÿÿÿ­«š\0Ð\0\0 

\0©©ÀÉËÀüþÿÿÿÿÿÿÿÿÿÿ¹\tŸ¹ÛÙ¹ßÿÿÿÿ¿Û¹ð¹›\tË™Ð
\tÉ™¹½ŸŸ™ýÿÿùù½©\tÉÚÙÏ½ÿ¿ÿÿðüùùÿÿûûÐÉ\t
\n\n\0\n\0 \0
\0ÀœÀ °°Û¯ÿÿÿÿÿÿÿÿÿÿùûý»Ÿ¿ÿÿÿÛý»Û\r›ÙùÙ¹Ë
šœ››ËÙ¹ŸŸ›ÿŸ©Ð\r
\t©\nÛÏ\rý¼ù\0Ÿ°þÿÿÿé
š\0œ\0\0\0\0\0° é­\rž ðýÿÿÿÿÿÿÿÿÿÿ»™\tŸ›ùð\0ÿÿÿûý½›Ð°°ÚÉ\t
™É™¹ùù¹ßßûÙ\tšÐœž­ùûÿÿÿ°íÿŸÿÿùùà\0°¬\0\0\t\0\0\0À­\t\0\nšÉí­®ÿÿÿÿÿÿÿÿÿÿù\t­›Û››Ÿ\t\0ÿ½ý¿›Ð¹¹\t\t\tÉ\t œ\0°žŸŸÛŸÿß¼½ \t©\t
ÚÞÞŸßŸÉÿù\rÿÿ¿ëžž\tÉ\t© \n\0\0\0\0\t\0\n\r\r ðßÿÿÿÿÿÿÿÿÿÿÿ™Ù­½½ûÙ\0\tßÿÿ»ùû›œš\r°š\t\t
\t\tÉŸ™ù½½ÿù™\0\0¼½­½½ðÿÿ°éÿÿÿÿÿÿ›É\t\n\0\n\0\t\0\0\0\n\0\0¬¼š\n\t©\r®ž¾ÿÿÿÿÿÿÿÿÿÿûù¹š
ËïÿÿßÛÙÉË™™\t­\t\n\0\0\t
\t¿›Ûßù°ð\t\t\t\téÉÊÛËí­ûÏ\r¿ÿÿÿÿûü© ©
É\r\0\0\0\0\0°\0\t\r¬žËÉ¬ÿÿÿÿÿÿÿÿÿÿÿÿ™\t
ÛŸŸ\0Ð\0ßÿÿû¹»›¼šš™\r\t\t\t\t ùÉ½½½ÿÙ\0\0\0\0\0š¼šÚýÿ°ïÛßÿÿÿý©°É\0À \0 \0\0\0\n\0¬©
\0š\t ðù©ïÿÿÿÿÿÿÿÿÿÿû›Ý½¹ùûý½œ\t›\r½\tÚ\r\t\0°\0\0\t
ŸŸŸŸûûšÛÐ½›É\nÛÙ\rëíùïÿÿÿÿÿ¿ðð°Ú° \0\0\0\t©\t
ÀÚÉ­Þÿÿÿÿÿÿÿÿÿÿÿÿý»›Ÿ\0\0\0ÿÿÿûÛ©¹\0›\t°\tš
\r\t\t\tÉ\0›ÛÛßßÙ\0\t\t\0\0\0ðÞœ Ëßß°Ïÿÿÿÿÿþ¿\t\0 \nÀ\0À\t\0\0 Ð\0\0\0°°šÀ\t¬šÐ¯ÿÿÿÿÿÿÿÿÿÿÿÿû½\0\0 Ÿÿùý¹ÙÐ\t°Ù\0\0\0š™éý¹ùÿûÉ  \0\0\0\r© ¼ûïÀÿÿÿÿÿÿùðé\r\t
\t©\0\0\0\0 šœ\0\n\t­¬¼ðÿÿÿÿÿÿÿÿÿÿÿÿÿû\0\0ÉÿÿÿûÐ°¹\t\0\t\n\0\0©\0\0\t\0›Ÿ½½ù°Û\0\0\t\0\0\0ÊÐ\0ËÍÿ¹ïÿÿÿÿÿÿ­©\0  \0À\0À©\0\0\0
\r\tÀ\0šÚË\0àžžÿÿÿÿÿÿÿÿÿÿÿÿÿ\t\0\0\t\0\0ÿÿÿÿ½Ÿ
Ð\0\t\0\0\0\0Þ¹\0\t\0½ÙÛßÿ›\0\t\0\0\0\0¬°\tÏ¾ŸðÏÿÿÿÿÿûÛÊÚ°\n\0\0\0\0\0
\0\n
ËÀ\0ðéïÿÿÿÿÿÿÿÿÿÿÿÿù\0\0\0\0\0ðÿÿŸŸ¹©œ›\t\0\0\0\0\0\r©\0\t\0\t\nÉ¹»ùûßœ\0\0\0\0\0\t\0\t½\rï\0ÿÿÿÿÿÿ½ë\t\0\0\n\0\0\t\0°\0\0\nÐ\0šË\túßÿÿÿÿÿÿÿÿÿÿÿû\0\t\0\0\0\0ÿÿÿÿŸ
°Ð\0\0\0\0\0\0\0\t\0\t™­ýŸýû\t \0\t\0\0\0\0\0éü¿Ïÿÿÿÿÿÿ°œ©
\tÉ \n\0\0\0\0àœ\0 šÉž\t­þÿÿÿÿÿÿÿÿÿÿÿù\0\0\0\0\tÉïÿûßù
Ù°\t\0\0\0\0\0\0\0\t\téù»ùûý½\t\0\0\0\t\0\0šËßý©ïÿÿÿÿÿ¼½©\0\0 \t\0\t\0 \0\0\0©\r\t\0\t\n¬\t¬\nÐÿÿÿÿÿÿÿÿÿÿÿÿù\0\0\0\0\0\nŸÿýûûÐð¼½½\0\0\0\0\0
\0\t\tŸŸŸš\n™\0\0\r\tžûùðïÏÿÿÿÿÿÿÚÚœ°°\n\r\0\t\0\0\0
 ¬©\r
É¬\t\r­­ÿÿÿÿÿÿÿÿÿÿÿû\0\t\0\0\0Ïÿûýÿ¹\t\t\t\t¹ šš\t š
Ùûý¿ùé\nÊ\0š›ðý¼ž\rù Ïÿÿÿÿÿûé\0\0\0\0Ê\0 \0\0 \0\0œ\0š\0\0\0šÊÿÿÿÿÿÿÿÿÿÿÿÿù\0\0\0\0\t\0ÿÿ½ÿ½œ°Ëžœ°™°Ð›\t\0\t\tÐšÙÛß›™\t\t\t\n\t­­­\r©éàÞ¾ÿÿÿÿÿ¾é©\r\nÀ\0\0\0\0À°°\nÀ\nš\0ðšÚ\t\túßÿÿÿÿÿÿÿÿÿÿÿù\0\0\0\0\0\0ÿÿÿÿ¹\0\t©
ËË
\0\t\0Ÿºù¹ððð\0\0°Ð\0\t­ù\0ÎÿÿÿÿÿûÛ\0Ê\n\0\0°\0\t\0\0\0\0\0\t\t
É\r\0\nÀ\t\0Ï¯ÿÿÿÿÿÿÿÿÿÿÿû\0\0\0\0©ÿÿ¿ÿÿ›\0©\0\t\t\t\t\t\0\t\0\t ÙŸžŸ™\tš\0\0\0\0\0\0\t\r¬žï\0ÿÿÿÿÿß­°\t\0°°\0\n\0\0\0\0
 \0\0 ­\t
\0É­ÿÿÿÿÿÿÿÿÿÿÿÿù\0\0\t\0\t\0ÿÿýÿŸœ\t\0\0\0\0\0\0\0\0\0¼½©ééý½°Ð\t\0\0\0\0\0\0\n\0\tíù\0ÿÿÿÿÿúÚ\r À°\0\0\r\t\0\t\n\0\0\0\0œ°œ\nÀÊšÚÛÿÿÿÿÿÿÿÿÿÿÿÿû\0\0\0\0\0\0éÿÿÿÿÿ¹\r\0\0\0\0\0\0\0\0\0\t\tÉ\t
\tŸ›ÛÛ
É©œ\t\0\0\0\0ÉšÞß°\0ÿÿÿÿÿ¿Ú©\0É\n\0\0\0\0\nœ°\n\0À \nÐš¾þÿÿÿÿÿÿÿÿÿÿÿÿù\0\0\0\0\0\t\0ÿÿûÿÿŸ°™\t©\0\0\0\t

ËÙúÐý½­½ŸŸ
œ\t\0ðüÿÿù\0ÿÿÿÿÿù©Ê\r\0\n\n\0\0\0\0\t\0\0\0\t\tË\tË\0 À©éÉÿÿÿÿÿÿÿÿÿÿÿÿÿù\0\0\0\0\0\0ÿÿÿÿùù­œ\n\0\0›Éù¼¹¼¿›ËùéðùëéËÊÚßÿÿÿú\rÿÿÿÿÿþÚ\n\t\t\0\t
\t\0\0\0\0\t\0 \0\0ÉÉ©À¯ïÿÿÿÿÿÿÿÿÿÿÿÿù\0\0\0\0\0šÀ½ÿÿÿÿûÛÛ

Ù\tË\tùéûËÛÛûÏÛýý½¿›ùÿŸŸ½½ÿÿÿÿÿ\0ÿÿÿÿÿûùË\t \0 \0\0\0\0\0\n\t\t\0ž° 
Ëßÿÿÿÿÿÿÿÿÿÿÿÿÿ°\0\0\0\0\0ÀÐÿÿ¿ÿý½ûÛÙ¼ù¼½½½¹ù½­½½¿››Ûßßßùÿýÿÿýÿÿÿýé\0Ïÿÿÿÿÿ¼š\0\0©\0
\0Ð\0\0\0\0š\0\t\0 Ú\0à\r
¼ëÿÿÿÿÿÿÿÿÿÿÿÿÿù\0\0\0\0\0š©ÿÿÿÿûû½½¿›ù¼¹¿žŸŸžÛÛÛùùÿßûûûùÿùÿÿýÿÿÿÿ¿°\0ÿÿÿÿÿÿ­\r\0
\0š\0É\0\t\0\0\0\0ÉÀ\t\t\t \0\0šËÞÿÿÿÿÿÿÿÿÿÿÿÿÿ°\0\0\0\0\0\tÊ›ÿÛÿÿßŸ›ÛÝ¿ÛßÚÛÛË›Ûùý¿ŸŸ¹ýý½ÿÛßŸÿÿÿÿÿÿßû\0ÿÿÿÿÿ½«\0\nÀ\0\t\n\t\0\0\0\0
\0
\n\0É©éàž¯ÿÿÿÿÿÿÿÿÿÿÿÿÿù\0\0\0\0\t\t ýÿÿÿÿ¿½¿Ÿ»Û½¹½¹½½½½ùûßÿùÿŸŸÿ½¿ûÿýÿÿÿÿÿÿœÏÿÿÿÿÿÿœ°\n°\t\n\0\0\0\0\0\0
\0\nÚšÀ\0\téßïÿÿÿÿÿÿÿÿÿÿÿÿ°\0\0\0\0\0\nÉËùÿßùùÛùùý¹ÛŸÛŸÛÛßŸŸ½ûÛÛùûÿŸßùýýÿÿÿÿÿýûË\0ÿÿÿÿûëË\0ÊÉ\0\0\0\t\0\0\0°\0\t\0œÀ\0É\téà­ÿÿÿÿÿÿÿÿÿÿÿÿÿù\0\0\0\0\0ž\t­ÿûÿÿŸ¿ŸŸ›Ûùù½ù¹­¹ûßŸ½½½¿ŸŸûùÿûûÿÿÿÿÿÿí½\0ÏÿÿÿÿÿÛœ°\t\0 Ë\t\t\0\0\t\0\0\0\nÀ\n\0°°\0à\0ž®ÿÿÿÿÿÿÿÿÿÿÿÿÿù\0\0\0\0\0\r\tÀšÛßÿÿ½ŸŸ›ý½ŸŸ›ßŸÛÛÛùùùûÛÙùý½ÿÛýýÿÿÿÿÿÿÿúÐ\0ÿÿÿÿÿþ°É \0\0\0\n\0©\0\0\0\0\0š\0À°ð\0¯ÿÿÿÿÿÿÿÿÿÿÿÿð\0\0\0\0\0\0°ùÿûÛùû¹ùù»Ûù¹ý¹ÛŸŸŸŸ¼¿Ÿ½¿½»ß½¿Ÿ¿ÿÿÿÿÿýÿû\0ÿÿÿÿÿ¿œ°É
À°\nÀ\0\0\0\0\t\0\0©Àà\0­­®ÿÿÿÿÿÿÿÿÿÿÿÿÿù\0\0\0\0\0°\ržŸ½ÿÿ¹Ý¿Ÿß›Ûß›Ÿ¹ùùùÿ½ùùùÛýûÛýÿýÿÿÿÿÿÿÿÐÿÿÿÿÿÛË\0š\0\0\0\0\0\0\0 Ë\0\r\0©\t­\0ÚÛÿÿÿÿÿÿÿÿÿÿÿÿÿù\0\0\0\0\0À\t\nÛùÿ¿ŸŸ»Ùù¹ý¹¹ùùŸŸ›Ûùûù¿ŸŸ½Ÿ½¿Ÿ½¿ýÿÿÿÿÿÿÿ\0ÿÿÿÿûððš°š\0 \0\0\0 \0©\t\0\t\nœ\0¬\nž\níïÿÿÿÿÿÿÿÿÿÿÿÿû\0\0\0\tà¼¼ŸŸßûùÛ½¿Û›ßÛÛŸùùý½ÛÙÿ½½¿½¿ß½ÿÛÿÿÿÿÿÿÿðð\0ëÿÿÿÿÿ
É\n\0À\0\0°\0\0\0\0\0\0\0\t\n\0\nœœ\0œžÿÿÿÿÿÿÿÿÿÿÿÿÿù\0\t\0\0\0\tÉûÿ¿¿ŸŸ½Ÿ›Ÿù¹½½¿ŸŸ›Û½¿ŸûÛÛÛÛÛ¿Û½¿ßÿÿÿÿÿÿù\0\nÞÿÿÿÿù¼ \t\t¬\0\0\t\0\0°Ð\n\n¯ÿÿÿÿÿÿÿÿÿÿÿÿÿû\0\0\0\t\0àžž½ùýýûùÛ¹½ù›ÛÛ›ùù½»Ùùù¹ùùù½½ý¿ßùÿÿÿÿÿÿÿà\0\rÿÿÿÿûËÉ\tà\t\0\t\n\0\0\0\0\0\0\0\0É\t\0\n
\r\t\r\0\tÞÿÿÿÿÿÿÿÿÿÿÿÿÿû\0\0\0\0ž½ûÿ¿¿½Ÿ¹ßÛŸùý¹ùù¹½¿Ÿ¿Ÿ¿ß½¿ŸÛÛ›Ûùÿÿÿÿÿÿÿÿ™\0ùïÿÿÿ¿
\0
\0°\n\t\0\0\0\0\0°\n\0
\0\n\nÚÊïÿÿÿÿÿÿÿÿÿÿÿÿÿ°\0Ð\0\0\0ðÚßŸßßûùû›Ÿ¹ù¹ùûŸŸŸ™ûÛÛÛùûÛùûßùý¿Ÿßÿÿÿÿÿÿð\0\0ïßÿÿÿŸ\r©\0À\0\0\n\0\t\0\0À\r\t\t\t\t\0Ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\0 \0\0Ë¿ûûûßŸŸ½ùù½¿Û™ùùùûÛùùÛÛÛýŸ½¿ŸŸýÿÿÿÿÿÿÿÿ
\0ûïÿÿûï°©
\0¬š\0\0\0\0\0 \0\0š\0\n\n\0àéàïÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\0\t\0\0\0\r¿ßŸßßûùùÛ›ÛÛù›ß¹¹ù½½Ÿ½¿½ûÛÿŸùÿÿŸŸÿÿÿÿÿÿû\0Ûùïÿÿÿù°\0\0\0\0\0\0\0\0\0\0°\0\t\r\t\t\t\0Þÿÿÿÿÿÿÿÿÿÿÿÿÿÿ°\0\0\0\0\r
Ï¿ûûÿ½ŸŸ½½¿½Ÿ½¹ßŸ›ÛÛ½¿ùßŸ½½ù¿ŸŸÿýÿÿÿÿÿÿü\0\0ðßÿÿ¿°\n\0­\n\0 \n\t\0\0\0\0\r\0\0 \nž\nÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿù\0\0\0\t\nœ½ùÿß½ûùùûÛÙûùùû¹ùý½½ùÙ¿¹ùûÛÿßÿý½¿ÿÿÿÿÿÿÛ\0\0ËïÿÿÿðùÐ\0\r\t\0Ð\0\0\0\t\0\0\0\t \0°ÐÐÐ\0Üïÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\tÀ\0\0\0\0ÿûÿÿ½¿Ÿ½¿ŸŸŸŸŸŸ›ÛÙ¿¿Ûß¿Ûý½¿ŸŸÿýÿÿÿÿÿÿ°\0\0ðÿÿÿÿŸ\n\0Ê \nÉ\0\0\0\0\0\0\0\t \0À\0 \n\0éëÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¹\0\0\0\0\0žÛÛýÿûÛùùûûù½¹ùùù½¿žŸùù½½½¿ÛÿÛý¿Ÿßÿÿÿÿÿý\0\0\0þŸÏÿÿùï\r©\0À\t\n\0°\0\0\0\t\0\0\0œ
\0©
\té\0íïÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\n\0\0\0\0\t©ý¿ÛßÿŸŸ½ŸŸÛÛÛŸ›ÛùùúŸŸùûß½¿Ûýûßûÿÿÿÿÿÿû\0\0ëÿÿÿÿ¹°\n\t \nÀ\0\0\0\0\0\0\0Ð\n\0\tÀÀÀ\0ðšÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿû\0\0\0\0ºÛÿ½½ûùûùûŸ½¿›ß½ŸŸ½¹ÿŸ½ûÛ½¿Ÿ½ÿßÿÿÿÿÿð\0\0ðßïÿÿÿí­\tÀ\0š\0\0\0\0\0\0\0\0
\0\0\0
\t ¼\0íþÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\0À\0\0\0\0½½ûûßŸŸŸŸûÛÛý¹ûùÛûÛßŸùÛ½ÿßùÿß½¿ÿÿÿÿÿ\0\0\0
ïÿÿÿÿ¹é \n°\0œ©\0\0\t\0\0\0\0\0šÚ\0\n\tÀ
Ëïÿÿÿÿÿÿÿÿÿÿÿÿÿÿû\0\0\0\0\0\0\0ÚŸ½½¹ûùûý¹ùùÛŸŸŸ¿™ùûûŸ¿ß¹ûŸùûßÿßÿÿÿ½\0\0\0\0þÛÿÿÿûÞ\0\0\0\0\0\0\0\0\t\0\0\tà\0\t\tÉÀ
¼ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÙ\0\0\0\0\0\t­©ÛÛÛÿ½¿Ÿ›ÿŸ¿¹ùù½½¿ŸŸùùûß½ÿŸý¿Ÿÿÿÿüð\0\0\0\rÿÿÿÿÿ©¬šÀ \té©\0©\0\0\0\0\0\t\0\0\0à š\0ËËïÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ°\t\0°\0\0\0\tÉ­¹éžŸÛùý¹ùùý¿ŸÛÛÛÛÛûß¿Ÿ½ûùù¿ßùý­ÿÿ¹\0\0\0\nÏ¾ÿÿÿ¿ßš\0\r\0\0\0©\0\0\0\0\0\0\0 \0°\0\0ÀÐ°¬ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿû\0à\0\0\0\0\0
ÉŸùÛ½Ÿ»ß¿Ÿ›Ÿ¹½¹ùûùÛûÙùûßŸ¿Ûùÿÿÿðù\0\0\0\0ûÏÿÿÿÿºÉÉ \n\n\0\0\0\0\t\0\0\0À¼\0Ð°\nßÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿù\0\0É\0\0\0
É
™ûß¿¹ù½½ùÛÛßŸ½Ÿ¿¿¿½¹ùý¿ŸþŸŸ\0\0\0­­ïÿÿÿ¿\r° ÀÀ
\0\0\0\0\0\0\0\0©\0\0° \nœž¯ïÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\0\0\0\0\0\0\0šÙËœ¹ÙûÛÛÛÛŸ½½¹¿ÛûÝ¿ŸÛÛþ¿ÛÙéùðð\0\0\0\0žùÿÿÿÿÿúÉ\0¬\0
\0\t \0\0\0\0\0\0\t\0©\0\t\r\n\tÏÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÀ\0\0\0\0\0\0\0\t\nœ¹û­Ÿ½­ºÛðùùÿ™¼Ÿ»Ûù­ù½¾¿žŸ\t\0\0\0\0\0Ëîÿÿÿÿùù¼° ©\0À \0\0\0\0\t\0\t¬\0\0À\n\t\r¾ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ°\0\t\0\0\0\0\t\0\t
\r\tÛ\t››Ù½ŸŸŸ™ÿÛùÏ½ŸÛ¿Ûûðœ°\0\0\0\0\0\0üŸÿÿÿÿÿ¾\0\0©\t\0\t\0\0\0\0\0\0\0\t\0
\n\t Ïÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿù\0 \0\0\0\0\0\t\0½°¼¼
Ð½¹ð¿°›¹°šÐšÐÚ\tÊ\0\0\0\0\0\0Îûþÿÿÿÿùé Ð\0\n\0\0\0\0\0\0\0\t\0
\0\tÀ©\r©ïÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿû\0\0À\0\0\0\0\0\0\0\0\0\0\t\t\t\nÐ
ÚžŸ\0¼œ¼œ½°ð
\t\0\0\t\t\0\0\0\0\0\0¿¼ÿÿÿÿÿÿ¾ °
ÀÉ \0\0\0\0\0\0\0\n\0\0À\tÀ Àþÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\0\t\0\0\0\0\0\0\0\t\0\nš\t\t\tð°
°\t \0\t\0\0\t\0\0\0\0\0\0\0ïÞÿÿÿÿÿþÛéÀ\0\0\0\n\0\0\0\0\0\t\0\t \tÀ\t  \t¾ÿÿÿÿÿ¿ÿÿÿÿÿÿÿÿÿÿÿÿÿù\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0\0\0\t\0\0\0\t\0\0\0\t\0\0\0\0\0\0\0\0\0\0°ÿÿÿÿÿÿ¿¼š\t\nË\0\0 \0\0\0\0\0\0\0\0\0\t¬\t\r éíÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ°\0À\0\0\0\0\0\0\0\t\0\0\t\t\0\t\0\0\0\0\t\0\t\t\0\t\0\0\0\0\0\0\0\0\0\0\0œëÏÿÿÿÿÿÿýé©\nÉ\0\n\t\t\0\0\0\0\0\0\0\0š\0\0\0\0\t\0þÿÿÿÿÿ¿¿ÿÿÿÿÿÿÿÿÿÿÿÿÿ\0š\0\0\0\0\0\0\0\0\0\0\0\0\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÿþÿÿÿÿÿÿû¿\0\0\t \0\0\0\0\0\0\0\0\0\0\nÊÚŸÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿš\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÀðœÿÿÿÿÿÿÿÿÐ° š\nÀ \0 \t\0\0\t\0\0 š\0\t\0ïÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿù\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÎþÿÿÿÿÿÿÿùëÉÀÀ\t\0\r\0\0\0\0\0\0\0\0\0\0À 
Ëÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¬ÿÿÿÿÿÿÿÿÿÿþ½\n\0\0\0\t \0\0\0\0\0\0\0\0 \0\t
\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¼\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ïÿÿÿÿÿÿÿÿÿÿ½º© 
\nÀ\0\n\0\0\0\0\0\0\0\t \t\0°ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûÚÉ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÚÐÀ\tÀ\t\0\0\0\0\0\0\0\0\0\0\0\0\nÉ
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ïÿÿÿÿÿÿÿÿÿÿÿû¯
\0š\0\0
\0\0\0\0\0\0\0\0\t\0\0\0\nïÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿù\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÿÿÿÿÿÿÿÿÿÿÿÿ¼Ù\0\0\0\t\0\0\0\0\0\0\0\0\0\0àš\0
Ëÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿþš\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ïÿÿÿÿÿÿÿÿÿÿÿÿû®šž\0\n\0\t \0\0\0\0\t\0\0
\0\0\n\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûÍ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÛ\0À\0 \0\n\0\0\t\0\0\0\0\0\0\0œ\néïÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿº
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿù­
\0 \0\0\t\0\0\0\0\0\0\0\0\0žÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\rœ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ïÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¾Ú\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0 \0©\n
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð©à\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ïÿÿÿÿÿÿÿÿÿÿÿÿÿÿûÛœ œ
\0\nÐ \0\0\0\0\t\0\0\0 \0\0ÉÀÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿\0À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ïÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿï¹ \nÀ\0\0\0\0\t\0\0\0\0\0\0\0\t\0 À ïÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿùé\nš\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ïÿÿÿÿÿÿÿÿÿþÿÿÿÿÿÿÿ½­©\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0üÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿúœ­\0Ð\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ïÿÿÿÿÿÿÿÿÿÿÿ¾ÿÿÿÿÿ¿ÚÐ\0\t\0¬\t\0\0\0\0\0\0\0\0\0\0\t\n\0\0 ž
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ½©\0š\n\r\0\0\0\0\0\0À\0\0\0\0\0\0\0\0\0\0\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûû
\0à\0\0\0 \0\0\0\0\0\0\0\0\t\0\0\0Ð\0\0Ðÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿žž\r\n\tÉ\0\0É \0À\0\0\0\0\0\0\0\0ÞÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÀé \0\0\0\0\0\0\0\0\0\t\0\0\t\0 \nÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿý©\0°¹ Ðàð ËË­©\0¼\0\0\0\0Ëý¯ÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ÿÿÿÿÿÿû›\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0œŸÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿúœ­
\t
\r¾ŸÚ›Ëïÿÿÿÿÿÿÿÿÿûÿÿÿÿÿÿÿÿÿÿÿÿÿüÿÿÿÿÿ¿û\r¬\t\0\n\0\n\0\0\0\0\0\0\0\0\0\0\0\t\0\t\0\n\0àÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ½ šššžš\r«
Àùÿÿÿÿÿÿÿÿÿÿþÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ÿÿÿÿÿÿ¿û\t\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0žŸÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿùÛÀ\r­©©©\r Þ½¹©Ïÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¾ÿÿÿÿÿÛÞžš\t\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0Àÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿû šÚš\0œàž¹ééÞÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿýÿÿÿÿûþ¹©\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¼\tà\t\n
ðÞÛùëÿÿÿÿÿÿÿÿÿÿÿßÿÿÿÿÿÿÿÿÿÿÿÿðÿ¿ÿÿ¿þûž\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿùð\tšœœûÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¾ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûÿùûÛÉà\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\nšËÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿúž\r¬© ­©àÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¼ÿÿùÿÿ¿°š\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\rÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ½\t\tšœœÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ùÿÿÿÿÿÿÿÿÿÿÿÿûÿÿ½ÿëùééé\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¯ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÚÚ\t\0à ­¯ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿïûïÿÿÿÿÿÿÿÿÿ¿Ï¿ÿ¿½ÿ¿š\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\r­ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¹\t\t¬°°œœÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿžÚß¿ÿÿÿÿÿÿÿÿÿß¼ðûíûéé­\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\nß¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿþž\r¬©à©ïÿÿÿÿÿÿÿÿÿÿÿÿÿÿûë\r­ðûÿÿÿÿÿÿÿÿëûÿý»í¿Ÿš\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0­¯ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ°°š\nÚš\t\0\tÀÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÙÊš\rëïÿÿÿÿÿûýü¿¿ý»Ûé­\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ðÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ½\0é\r\0\0Ðà¼¯ÿÿÿÿÿÿÿÿÿÿÿÿÿÿ½ ©¼¾½ÿÿÿÿÿÿÿûëýúÛü¾›Ú\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0­­¿ÿÿûÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿý©é\0 ©é©\r\t\rÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿŸœ°\t\0žšÛÿÿÿÿùí½¯Ÿ­»ùé\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ËÛÞ¿ÿûÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ðšœ\tÀ\0Ê\nÊ\nÍ¯ÿÿÿÿÿÿÿÿÿÿÿÿÿÿ©é\r ¼šËí¾¿¿ýÿ¿šý¿ËËžš\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t
ËûÛùÿûÿßÿÿÿÿÿÿÿÿÿÿûÿÿûÛ\nš
Ë\tÉ\tÉ«ÿÿÿÿÿÿÿÿÿÿÿÿÿþùý©àœ\0šÛÞþ¿¼ððýšÐ½¹é­\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t­¯\r­
Ëž¿Ÿ¾ß¿ÿÿ¿ûÿÿÿÿ¿¿ëÉ
\tÀÐ\0À šÍí¿ÿ¿¯ëÿþÿûÿÿûý¾Úž™©
\t­­­éûßË
ð¯
ð¼° \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0š\t­©ééàúÛÚÚÐðððùËÉéËÉ\t\n\0à° ð°Ú\0ššÉéËÙžšÛ

Ë\t À\0À\0\0\nš\r«\tÀé
Ù­ËÉé\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0 \t š\t­\n\t 
\0¼°ÉÉ\tÉ\t\0ËÊ\r\t š\0¬°ð¬°ððððð¼°ðÐ°Ð°Ð¼ÉéÀð°à­

\t°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\t\0\t\0\0\0\0\0\t\0\0\0\0° ©  © ­ \t\n\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0 \0 \0 \0 š\0©\0\0\n¼¼¼\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\t\0¼\0œÉÀ\0œ\0\0\0\0\0\0\t\0\t\0\t\0\t\0\t\0\0\0\t\0\0àÀš°\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ž\nËšÊžž\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t

ÉéË\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°š\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûß­ûÏ½ëß­ûÏ½ûí¿\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0v­þ','Steven Buchanan graduated from St. Andrews University, Scotland, with a BSC degree in 1976.  Upon joining the company as a sales representative in 1992, he spent 6 months in an orientation program at the Seattle office and then returned to his permanent post in London.  He was promoted to sales manager in March 1993.  Mr. Buchanan has completed the courses \"Successful Telemarketing\" and \"International Sales Management.\"  He is fluent in French.',2,'http://accweb/emmployees/buchanan.bmp'),
  (6,'Suyama','Michael','Sales Representative','Mr.','1963-07-02','1993-10-17','Coventry House\r\nMiner Rd.','London',NULL,'EC2 7JR','UK','(71) 555-7773','428','/\0\0\0\0\r\0\0\0!\0ÿÿÿÿBitmap Image\0Paint.Picture\0\0\0\0\0\0 \0\0\0PBrush\0\0\0\0\0\0\0\0\0 T\0\0BMT\0\0\0\0\0\0v\0\0\0(\0\0\0À\0\0\0ß\0\0\0\0\0\0\0\0\0 S\0\0Î\0\0Ø\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0€\0\0€\0\0\0€€\0€\0\0\0€\0€\0€€\0\0ÀÀÀ\0€€€\0\0\0ÿ\0\0ÿ\0\0\0ÿÿ\0ÿ\0\0\0ÿ\0ÿ\0ÿÿ\0\0ÿÿÿ\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÏšŸ¼¿ý\0\0\0\0\0\0
Ï›ßÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿðüðïÞš\0\0\0\0\0\0\0¼°ü ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð©©ùëü\0\0\0\0\0\0\nÐ¼ð½ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\r¬¾Ÿ\n\0\0\0\0\0\0\t
Ë
Ëÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ°ðÚÐ\0\0\0\0\0\0\0­­éÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÉ\t©ð \0\0\0\0\0\0\0\0
¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\n\0\0\0\0\0\0\0\0\0
ËÉÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿþ\r©é\0\0\0\0\0\0\0\0\0\0›ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\0\0\0\0\0\0\0\0\0\0\0\0°ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
\0\0\0\0\0\0\0\0\0\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿà\0\0\0\0\0\0\0\0\0\0\0\tÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\0\0\0\0\0\0\0\0\0\0\0
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\0\0\0\0\0\0\0\0\0\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\0\0\0\0\0\0\0\0\0\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿà\0\0\0\0\0\0\0\0\0
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\0\0\0\0\0\0\0\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿðÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\0\0\0\0\0\0\0\0\0Ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÀ\0\0\0\0\0\0\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\0Ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\0\0\0\0\0\0\0
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\0\0\0\0\0\0\0Ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\0\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿà\0\0\0\0\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\0\0\0\0¾ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\0\0\0\0\0
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\0\0\0\0\0šÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\0\0\0 \0Ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\0\0\0\0\0\0 ¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\0¿žÐ¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\0\0\0\0\0\0\n\nŸÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\tûÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\0\0\0\0\0
\0¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\0\0\0\0\0\0\t  \0\0¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿù\0ðßÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\0\0\0\0\0\0 ¼\t\0°\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÛÀ\t\t\0\0¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\0\0\0\0\0\0©  \0\0\0Ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿé\t Ú›\t\0Ûÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\0\0\0\0\0\0\0š\t\0\0\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð°™\t\0š¼ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð \0\0\0\0\0\0¾š\0\0\0\0šÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿý\t ©\t\t\t\0Ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿðð\t\0\0\0\0\0 \téà\0\0\0\0ªÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\0\t©š\t\0\0Ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿý ð \0°\0\0\0 šš\0\0\0\t¯
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿðšš\t©\0\t\t\0°
\0\tÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿà\0ð\t \0\0\0\0\0\0¬° \n\0\0šÐ ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿü
\r\t\t\t \0\t\0
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\0\t\0ð\n\0\0\0\0\0\0\t
ž\0\t º°¬ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿþ›\0°\t\0°\t\t\0 \0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÀ©  ð\0\0\0\0\0\0\0\n\0šš\n\0\0\tð¼\t\t\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿù
\t
\0
\0\t\0\t\0\n\t\tÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿË
\0\0\0ðš\0\0\0\0\0\0\0\0\0\t°\0 ­«  \0\tÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ š™\0\0\0\0\0š\t\0\t\t\0›ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿà° úšð \0\0\0\n\0\n\0 
\0\0\t\nšÚš\0
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿðŸ\t\t \t\nš\t\0\0
\0\n\0ûÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\n\t
\0à\nðà\0\0\0\0\n\0\0\0\0°\0\0\0©\t \0\0\0©Éÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\t\t °Ð°\t\t\0
\t\0
™\0°Ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\n¼ªžš\t ð

\n\0\0\0\0\0\0\0 \0\0\0\n

\0
Ëªÿÿÿÿÿÿÿÿÿÿÿÿð\tð™©\t©
À\n\t©ššÉ\0\0\t\t\0¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ ¬
\r ­ \0ð ÚùëË\0\0\0\0\0\0\0\0\0\0\0àš\0Ú\0\0Ÿÿÿÿÿÿÿÿÿÿÿ\t°›\tžšÀš\0\0°\0šœ°œ°ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿþÚ\0š\0 \nšðð\0©
\0\0\0\0 \0\0\0\n\0\0\0
\nš\0\0«©\0¿ÿÿÿÿÿÿÿÿð›\t°šÐž\t\0\0\0°\t\0°©©
\t\t©\t\tÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð©  \0 ÚÚ°­¬\nð\0šúð \0\0\0\0\0\0\n\t\0\0\t \0 
\r\0 \n›ÿÿÿÿÿÿÿÿð°Û\r©°°
\0\0\t\0Ðœ©©\0\t
\r©ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\nË\t\0 \0\0ð °ð\0\0\t\n\0\0\0\0 \0\t \0\0\0
°°\t\0 ¼\0\0
\0¿ÿÿÿÿÿÿ\t™©š­\0©\0  \n\t °Ú›š¹\t\tÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\t©ë¿\0\0\nÚºÚ\0°\nð\n\t \0\t \0\n\t\0\0
\0\0\n\0ÚË\0\0š
\n\t ð°\0ÿÿÿÿþ›éšù©\t©\0 \0\t\0

\tà™\t

¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\n\0
ú\0 \0À© ÊÐð\0\0°\0\0\0\0\0\0\0\0¼© \t¯©\0\0\0\0º
 \0\0
ÿÿÿÿù¼½šÚš
\0\0°\0\t\0œš›ÊŸ\t›\tÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿà\n\0©ûÿð\0œ©«ÀË© ð \0\0\0°\t\n\0\n\0 
\n\t\n \n\0
žš\0é\0\0
ÿÿÿ©ù»ð°Ú\t\0\t\0\t ššÚ°¹°™©ð›ßÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÀ\0\0\0\nßÿÿ\0\0\nà\n°\0\nð\0\0\0\0\0 \0\0\0\0
Ê\n\0  \0­©à ©\0\0¿ÿÿÿÛ
É
Ëžš›°°\t\0°
\té­›\t\tÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\0\n\0\0\t¯ÿÿð\0\0 \0°\nž°ð\0\0\0\0\0\0\0\n\0\0\0\0°¹\0
\t\0\n\nºÚš
Ê\0\0

ÿÿÿ¿ŸºÙ°¹\t©À°š\t©Ëš°›\r°›š›\t¹¹ÿÿÿÿÿÿÿÿÿÿÿÿÐ\0\n\0\0\0 \0›ÿÿð\0©Êš\0Êð
\0\0\0\0\0\0\0\0 \0\0
Ê\0\n\0\t\tëÛ© \0š\t\0\n\0ÿÿùù©\r°ðšŸš¹š›\rš°
\t­š
É­­¼šÐš›ßÿÿÿÿÿÿÿÿÿÿ\0\n\0\0\n\t\0\0¯ÿÿð\0© \t«©ð\0\0\0 \0\0\n\0\0\0\0\0½©\0\n°°\n\n \0\0\0 š\0\0

ÿÿûËùû
\tù©­™éð°Û\t °ú™©¹
™©¹›é™¯ÿÿÿÿÿÿÿÿÿ\0\0\t\0\0\0\0\0
ßÿÿ\0\0¬\n\n àÀð\nš\0\0\0\0\0š\t\0\0\n\0 °\0\0\0\0©\0\0\0©\0\0\0\0\tÿÿŸ¹
\tù›\tÛ›ë™­»\t°›Û™™ÚÚ™ëŸ
\t›ÿÿÿÿÿÿÿÿð\0\n\0\n\0\n\0\0\0\0¿ÿÿà\0
°šºð\t  \n\t \0  \0°°\0
úš
\t\0\t \0\0 ¼  \0ÿÿéëÐ°šÐºšÙž¹¹\r°Ÿ\t©¯©©¹©à°¹ðð™¹¹¿ÿÿÿÿÿÿÿà\0\0\0\n\0 \n\0
ÿÿú\0\0°\0\0 \0ð\0 ©®°\0\t \0\0\0\0\0°©© \n\n\0\0\t\0Ÿ©\0\0\0\tÿÿ›™«Û\t©¹©©žš°½©»ÛÙ›½
›Ÿ\t\n››žšÚ™ÿÿÿÿÿÿÿ\0\n\0\n\0\0\0\0\0ÿÿÿ\t \n\0«\tàð ©\n\0š\0\0\0\0\0\0
›\0ð\0\0\0ª© \0ÿü°úÙ\0ù›\n™©™¹Ð»
¼½©°¹ù½­©
›ž¿ÿÿÿÿÿð©\0\0\t\0\0\n\0\0\0\0¿ÿÿà\0­
À\t\n\0ð\0\n\nÐ°° ú\0 \0\n\0 \0°¾°» \0\0\nšÙ \0\0 \0¿ûÛ™
›\nœ™\t©°Ð°­©Ú›É¼›
\0
É©
››½»Ûÿÿÿÿÿð\0 š\0\0 \0\0 \nßÿÿ\0©\n\n   ðš\t©«\n\t©
\t\0 \0°\t\0


Ë°\0\0\0\0
¯
\0\0 
°¼\t™©©àÐ°™\tš™©¹
\tù¹¹™°Ÿð¼°šÙ¹¿ÿÿÿÿü\0\0\0\n\0\0\0\0 \0\t«ÿÿð\0\0°\t\0ð \0\0\0ðºÚ¼ºð\0ù­ \n\0šš°ú\0\0\n\0½ð\0
\t\0¹ùù›šž›\t™©\t\t\n\t\t¹šžš›

\t¯\tùù¹»ËÛÿÿÿÿ\0©\n\0\0\0\0\0\t\nßÿÿà\0\n
\0  úœ°

\t©
Ëž›šÚš\t
«\t\0\0\t
ë \n\t \n
šš¹\t\r©›\n°\t\t\0™©é›\té©¹\r°¹Û™›°°¼½¹°ÿÿÿüš\0é\n\0\n\0 °\0 \0¿ÿÿ\0\0°\t Ê\nù«
\0°ºÚð°ðú¬¯°©\n\0°¹  \0­¼š\t \t©½°ùùË\nš›
Ð™š\0š\0›\r¹›œš›\t©\0°ð¼½››Ÿ½¿ÿÿð©©\n\0\0\0\0\0\0\t\0©ÿÿÿð\0\n
\n\0 ðšÚÚ°»\0©\t
šÛÚ¼°«
\nž\0\t \nš\0\0
\0\0ëÛš›™¹­©\t\t\0\t\t\t\t°š¹°š›™¹›


ééð»›ÿÿúÀÊ\té \0\0\0\0 \0\0ÿý \0\r\0¬°š\0 ð\nš\0š\nÛÀ\0\0 \0\n\0
\n°­©«Ú\0\0\0\0\nŸ¼½°¾›Ë›™\t\n\0\t\0\0©\t\t½›Ú°ù\r©©ù½¹›¹»ßÿÿ\0°°ð\0\0\0\0°\0\0\0\0¿ÿÿð\0  \t\0š\0ð\t\0š\0\t 
\n\0 °©
°›\n\0°½ Ð \n\n\0°\t


šŸ™\0™­
šš\0°›\t©©š\tšš¹™°°ž¼½»›ÿþ\n\n\n\0\0\0\0\0\0\0
ÿÿÿ\0\t\0œ° \0 žð\0 \0\0\0
\0\0\n\t\0\0\0 Ë \t\0 
úÛ \0\té°\n\nŸ½½½°°¹©©™¹É\t\t\t©\t \t
\r¹››\tš™š¾½¹›«
Ÿ­ÿð\0­\r\t\n\0\n\0\0°\0š\0ÿÿÿ \0à \0°À ð\0\0\0
\0 °ù \0\0\0
\0Û °\0\0›éð°°ž¿\t\0¹Ëšš›Ù\t\tÚ°Û¹½¹ùÛ™Ù°°žœ½°ð½©©¹™ºšžŸŸ¹›ÿÛ
\n\n\0\0\0\0\0\0\0\n\0\0Ÿÿýð\0
\n°Êššð\0\0\0\0\0\0\tºÚ\0 \0\0» š\0\0\nš\n\0
ûß 
Û¹ùùð°ð°¹ÛšÛž›\tð¹™¹›™¹š›™\t\tÙ
\t½¹©©©¾¿ÿà¼°\n\t\0\0\n\0\0\0\0\t¯ÿÿ \0\0ÀªÊ\0\0Àð\0š\0 \0\0»­°°\0\0šÐ\t \0
\r°\0\t\0¿ÿúÚŸ\r©¹©™\tÉ¹­½¹ù½¿›žŸœ¹
\t©šš™©¹½Ÿš›ÛÛÛŸÿ\0«\n\0\0\0\n\0\n\0\0\0\nÿÿþ\0\0°©é\0 ºð\0\0\0\0°\0 ­¾ûÀ\n\0ºú\0\0 \n\0\0
Ûÿý©©¹»›ËÚºšŸ
›™½¹ùùùù°¹É½¹ÚŸ\t\t
šÚšš™½°ššŸ¿ðšÐé
Ê\0\0\0š\0\0\t¿ÿÿÐ\0\r\n\0 ¬šÀð\0\0\t\0\0\0\0°»šº\0\0\0\t\0 °\0š\t\0\0\0­¿ÿý½©ËÛ›™Ð
\t\tœùðù¹™½½½»›

¹©°°ð™¹ù¹ð°Ÿ\tù¹¿úÀ©®\0 ¼¬  °\0\0 \nßÿÿ \0\nœ°š\0 °ð\0\0\0\0\0\0
\r¯\t \t
\n\t\0\0
\0\0\0\0\0¿ÿûú›››
Ú»
š

Ÿ›\t™\0\t›ÛŸ™ù\tÙ\tÉ\t°¹¹é
Ù°›\téÿ\t
šÛÊ\0° \0¿ÿÿÐ\n\0ª\0àš\0\0ð\0©\0 \0\0\0°º¹ú\0\0\0\0\n\0\0\0\0\0\0\0
ßÿþùððð½©Ð\0\0™
É \0›Û°›
›\nšš›ž¹¹
\t°Û›à¬ é à ©\n\0\0\n\0\0\0
ïÿú\0\0žË\0à«ð\0\0\0\0\0©\nû°\0\0\t\0\0
\0\0\0 \0\0¿ÿûÚ››››™©©\0\0\0\t\n¹ð¹\t\rŸÐ™\t\t©¹¹û™É¹¼›
Ë\0šž
\t­\n š\t\0°\n\tÿÿÿ\0\0 
 
\t \0ð\0\0\0\0 \0\0°©¿ \0 \0\0\0© \0\t\0\0\r¿ý½©é­°ûÚš\0\0\0\0›ùš›Ë™©©°©
\tœ¹©›ëšœ›\t™¼°°©à¬\nœ\0\0\n\0\0\0\0¿ÿÿð\0š©à®
àð\t\n\t\0\0\0© »Ëð\t\0\0\0\0°\0\0\0\0\0¿ÿÿ¹½¹Û
š\0\0\0\0
\0¹\t\t›é
\0\t\0\0©Ÿ›­™ù¹°Ÿ

š°¼°Ð°\n\n\0\0\0\0\0\0\nßÿÿ\0\0¬°š
\t 
ð\0\0\0\t\0\n\n¼¿
\0\0\0\0°\0\0\0\0\0\tÿÿðžšš°½
\t\t\0\0°š™\0\0¼°\0\0\t\t
™°Ÿ™»©
\r°¹Àš
Ëéª\r š\0\0\0\0\0\tÿÿþ\0\0\t¬°Ê\r ð\0\0\n\0\0\t ©

\0  \0\0 \0 \0\0\nŸÿÿ¹½½™
©©©©\t
É\t\t\0™©
\0\0\0\0\0\0\nšÛ°»\r™ù°™¹É°©­­¯œºÚ\t \0\n\0\0\nÿÿÿ\0
\n°šÀ©\n\nð\0\0\0 \0š›\n\0\r©\0\n\0\0 \0\0\0\0\0\tëÿùé©
°œ°™¹©©¹\t\0©\t\t\0\0\0\t\t©ùºš›
Ëš›ºûÊûË­©¬\0\t\0\0\t¿ÿÿð\0\n\t©\n\0ð\0°\0\t\0 \0 ššššË\nÐ
\t\0\t\0\0 \0ŸÿÛ›Û¹¹
›\t©©
\tð¹Ù¼ð™\t\t™\0°\n\0\t\0ž¹›¹™½»Ð›™©É©\r­½¬¿Ë© \n\0\0\0\0ÿÿÿ\0\0
 \0à¼ ð\0\0©\n\0©¹éÉàÉ
À\n\0\0\0\0
ÿû©ð°Ð½\t
\t™©
\té»
››™°šŸš›\0°
\tš¼™¯
\t
ŸšÙºÚëþ¾¿ž°ðÀ\0\0\0 
¿ÿð\0\t 
\n\n\0ð \t\n\0š\0š\n©
\nš\0š
À  \0©¿ÿÛ›Ù¹ù

É°ðž¹šÙùéùûÛ½°¹Ð\t\0\t\t
¹›™¹›½°¹°™­¼¿ÛÏíþš°\0© \0
ÿÿÿ\0\0\0 \0 °šð\t \t\0\0\n\t\t©\n\0\t
\t\0°\0\n\t\0¯ÿ½©°šš™¹°™
\t½\n™©¹›
š¹½º›\n\t\0°¹ž™°°šÐš›Û
š¿Ëï¿¿­­\0\0\0 \0\0ÿÿÿð\0 ¼\nÚ\0\0ð\0\0\0©\t©\nº\0\t\0š\0\0\0\n
\0 \0\n\t\n
ßÿšŸ¹™ð›š™°½
Û\r©Ð\rºž\0™Ë\nš©\r©º™ù½»Ù¼°ù°ŸÞ¿ûÏÞÚÚ \0\0\0\0\n\t¿ÿÿ\0\n\0\n ž°\nð\0\t  ©\0š\0\n\0\0\t °\t\t\n\0©\tûð¹ù¹\r«\t¹©éËÉ«°š©›\r™¹°¹°°™šš™\rššš™

››É¿ëÿûë¯\t \n\0\0ÿÿð\0\t©\n \0°ð
\0Ë

\nÚ
\t\0\t\0 ™À\0\0\n\0 \0
ïûÛ

›™›É™¹¹»Ðù

š\0›

ËÉ\t
›™©°¹¹ù©½¹½©›
ÿÿÿïýð°à\0\0š\0\0
ÿÿÿ\0\0 \0à
\0û\0

ÏšÛ
\0  \t \t\0©°°
\0\0\t\0\t½ù©ùùð½©°ð¼™¹©ùœ°°\t
\t°Ð¹°°°°ù\r©š™\t
ÚšŸ
Ú¼°ÛïÿŸ¯
š\t\0\0\0 \0¿ÿÿ \0š

\t\0°°ðšŸ»Ë\0°›\t\t\n°\t\0\0\0\0\0\n\0\n\0\nŸ«Ûšš›šŸ››Ÿ›¾½¹©©\tÀ°É\t°¹Ë
ÛÙŸšš›Éš™»¹
™¹¹¹››¯ÛëþÛé¬¬\0 \0\0\0
ßÿÿ\0\n\nÐ  ¬\0\nùðž¾©
\0 \0°©
\0°©
\0°
\0\t\0\n™û°½½°Û™
\t©
Ùš¼Ð
\t\t
\t

Ð¹ùš›©\t¹™éšœ¹Ú¼¼¼°Úß¾ßé¾
Ë\t \0\0©\0ÿÿð\0\0Ð\nÀšš­©úš
›ú°ðš\0šÐ\0\0\0\0\0\0\n\t\0¼»Ÿ›
›½¯¹Ÿ™°¿½›šš
\0
\rŸŸž½©Û›\r©°šÙ›Ÿ¹›››™°°ÿ¼¿éð­ \0\t\0\0

ÿÿÿ\0\0 °°à\t\n\0ûé°ù­ 

\0 \t©©\0
\t©
\0°\0\n\0¹ûÚšÛŸ\r¹™¿©©É»Ð\t\t\0šš›
°¹¹ú°š›™©©©»
Û©ð½ûËÚÚšÚ\0  \n\0\0ÿÿÿ°\0šÀ
\n\t ð
Ë\tà\0
\0 \t\t\0š\0\0 \0\0\t
ù¹ù¹ù»ŸºÙ›™¹©
\0 \n\t©\r¹ÛÛÛ™»Ù¹›Ð°›Ù¹\r¹¹°ù©°ºûÏ¿¯©é \0\t\0\0
ÿÿþ\0\n\0° \t©\nÀð°°°š\t
\0\0\0°Ú\t\0°°šš\n\n\0¿›Ÿ¹¾›ùúÙº½
\0
\0\0\n\0\t
Ÿ«šº›É
\t©
ÛššÐ»
žŸ™ùé­¼úððžšÐ \0\0 š
ÿÿù\0\0\nÐ\0 ºð\0\0\0\n\t\n\0°\t\0
\t °©\0\0\n\0\0\0šÛ¼»™¿
¹¿›Ù›š™\t\0\0\t\0\t\0\t½\t›¹½™¹šÙ¹›Ù½¹¹«
›šÿ½¯ž°é \0© \0\0½ÿÿþ\0\t \n\n°\nÐ\0ð\t\0\t\0\n\t\0\0\n\0\t­™\tÚš\t© °\n\t½¹ùûûÛÛÛÛ»
š™
Û\t\0\n\t\t©\0\0\t\0°›
š

Ú™°Û©©©¼¹ÛÚž¯ËÚðù­­©\0\0š\0\n¿ÿÿ\n\t\0\n °ð\n\t\n\t\t\n\0\0\0\t\n °©\n\0\0\t\0°
ï¿››Ÿ¿¿¿°ùù©ù ¹©šŸ™š™\0\0©›Û\t ™¹°¹¹©¾›¹ÛŸ›
š¹¹ù°¹¿¯\nÚš\0 \n\0\0­ÿÿþ\0\0\0 ë\r šÀð\0\0\0\0\0\0\n\t ©
\t\0š\0š\n\t 
\0Ÿ›\t¿¼ûÛŸŸŸ››Û™ŸŸ©¹
É
\t©°™\t›ž›ŸŸŸ¹›Ð»
ž›ÛÚŸ

Ðð½©­«Ê
\t©\nš›ÿÿù\0
Êš\n\0 \nð\0\t\0\n\t\0\0š\t 
\0š\t\t ›\0š›½¿\tûŸ¿ûûûùë¹°¿¹
››™ù›ÛÙ¹\n›É¹››¹Ûé¿½¹¹©¹¹¹ù»›Ë­©é­\0 \0\0\0ÿÿþ\0\0à©\0°ð\n\0\0
\t\0\n\0°©­ š\0°\t \nš\0°\0°Û›ûŸ»ÛŸŸŸŸŸ¹ðÙ\tÿ«›É°ú›

¿
Ù\t°š››ž½º¹¿›¹š›ÛŸžš›Ûù¼šËš¼š\0 \0\0ÿÿÿ\0\0©
\t\0¼\nð\t\0 \0\n\t\0\0°š\t©
\n\t°\t©

Ûšù¹ûß¿ûûûû¹û›šŸ¹ùý»Û™ùùûÛù©›ÛÛÛù»ŸŸ¹éú½¼¹û›
ŸŸ­»Ûé ð­\0 \t ›ÿÿû\0\n\0 ê\t\n\nð\0©\t\n©

\t šÐ°°š\0ºš\0\t°¿›Ÿ½¹¿ŸŸŸ›ß\tð¹›ßŸû½¿¿¿¿½û™\t©¹¹°»Ÿ½ùûŸ›½›¹°°Ÿ›Ú››ŸššÛ\nÚ\n\0\n\0\0¯ÿÿü\0\tËË\0š¬°\nð°©š\0\0\0\0 š\t«
\t ›\r\0°¿Ÿ›Úùû¿Ûûûûÿ»û½¼¹»û½ûùùùùûŸð¹›ÛËùùùû»ÛûÛÛ¼ŸŸŸ°°¹ùùùûÚŸ©\0\0\n\tÿÿû\0\n\n\0°àš\nÐù\tž»\t©¹©\0©Ú\t °°š\0 °\t\t¹û½»Ÿ›ùûÛÛ›ý½»›žŸýûùûÿ¿ûŸ¹\t
Ú›½»¿¿½ûùûû½»š¹¹¹ù©¹
š›š\têÐ  \n\tÿÿÿ\0\0šž
\n\tàªð¹©°¿\0\0\n\n©\n©Ë
\t©\t\t ¿Ÿ›ÛëûŸ½¿¿ÿ›ûÛùù¹¿½¿ùûûßùÛ›™¹ùûÛÛÛÛ¿Ÿ½½úÛùÛéù¹ÛË»ÛÛð­¯\t \0 
ÿÿü\0\n ¼­ 
\0ù
››°º›\t\t\t\n›\t\nš°šš\n\n\tù›¹ÿ¿™ùûÛ½½¹ÿÙúÛ¿¿ßûý¿ýý»š¹éÚ¿¿½¿¿¿ûß¿Ÿ¿¹¹¹»›
Ë«›Ð››ž°Ú\0 \0\0¿ÿÿú\0\tË\nšž°Ëúšû¼»\t\0\n\0\n\t\0 ™©©
\t\t\n›Ÿ›Û¿¿›ùûûÿ›¿¹»ÛÛ¹ý¿ûûûùûÛ›½ù¹ûùùûÛùÿ¿›ÛÛÛéùù¹ù»½¯›ÊÚ©\0 \0 Ÿÿÿý\0\n\n\0¼¬ Ë ù\t
›°°
\t\n °ªšš°°½©ûûý¿Ÿ½¿š››ý¹ÿŸ¼½ûûÿ½ÿ¿Ÿ½¿½»ŸûùûÿŸ¿¿¹ûû½º››š›
ù°©›Ë°½\0\0 \0\nÿÿþ\0\0œ¼©©
\0šð©©

\0\0 \0\t
\n
™šž›
\0©ðŸ¹ù»ù»Û°ùùé»Ÿ¹ÿ›û½¿Ûÿ½½¿›ùûÛûŸ›ùûûÛÛß½½ûÛùùùùù
Û
Ÿ½¹ÊÊð\0\0°\0\0¹ÿÿû\0\0  ž\nÀ¯\0ð\0 \0\0\0\0\0\0\n\0\t\0¹\n©°º›
›››Ÿ¿Ÿ›ý»¹°™°ûŸ¹¿›Ûûÿ¿ÿûù¿Û½¿½¿¿Ÿ»Ûÿûù¿›¹¿›
¹¹©½°™û
™«›\0 \0\0\0ÿÿð\0šÐ\r \t\nú\t\0\t\0\0\0\t\0\0\t 
\0¹š›¹ëšûûÛ¿½»½«š›šÙ©ëÚùûûß¿Ûù½»Û½û
ÛÛŸûß½¹½»Û¿Ûù¿½›Ëš›Ÿ
›Ùàð\t\0\0\0\nŸÿÿü\0\0
\n\tà°à ù ©\0\0\0\t\0\t\n\t°š°\n°º¹°¹\tû¿Ûûü»ÛŸ\r¹©™›Ÿ›»ÛÿÿûÛý»Ÿ½»¿¹û½¿ÿ»ß½»½¿™»é¹ùé©ùû»½° \n\0\0\0\0
ÿÿû \0¬\t \nÀšú™\0\0
\0 \0 \t\n\0°

\t«›¹º\0½¹¿½ù¿Ÿ›ù¹©›\tð°¹½»¹ùÿ¿›Ÿ¿›ùû›Ÿ›ÚŸ›››ß»Ûß›ùëÙ»Ú™¹ûš™É›š\0\0\0°\0Ÿÿÿü\0\nšž\t©
\0Êù\n\0°°\t\0\0°°›\0°\0š½¾š\t›\tœ¿Ÿ»ùû½Ÿ™°™©\t\r›é©Ÿ¿ûß¿ûù¯ž¹ùð¼¹¹­½¯¹½»¹¿›¹¿½››é¹\t\0›é©ð°\0\0°\0©¯ÿÿð\0À šÀ à°ú\t \0\t \0° 
\t 
\nš\0š›­º\0°››ûý¾›Û»›
\té\t©
\tŸŸ¹ù¿¿›ŸŸ¹¹ùº›››Ëš››ÛûÛÛù¿Ÿ¹š¹éŸŸ°›\tŸš\0© \0©\nŸÿÿú\0\nžàšÐ°\0ù 
\0š\0\0
\0°» \0°©©°

Ù\tùù¿›û½­½½¹
\t\t\t

½¿ùûÿ¹¹Ûù½›\r››ÛŸŸ¹½¿½¿Û¹ûùù»
°Ÿ\tš™ù°ð\0

°©ÿÿß\0\0 ©\n  
àð\n°\0\t\0

\0 °\0šÚ
\0°š¿¿ùùš›
\0\0š°¹›¹¿½¹úÛ°¹©­›
Ð¹«›Ûû½»ù¿Ÿ›››ÛÛÉ°\0šð°°\0\nÛ\r¿ÿÿú\0\0žž\r\tËÀ
ð\n\t\n°\n\0\0°\0š\n\0
\nš©«\t\tù¿š¹ \t©\0\0\0\0°›Ÿ­Ÿùÿ¿™»°Û°
Ÿ\t½¯½¿Û¿Ûù»é¿¼°¹›\t\n™Ÿ›
\0 © úÿÿÿð\0°ë
\n\n° °ù\0š™à\t\t\n\0\0š\t\0\0\0\0\t\0©\0\r\t¿ÛûÛŸ\0\0\0\0\n\0\0\0\0\r\t›©¿¹ù¿«
\t\t
™\t½¹¹»Û¿Û»Ûù¿››\0°\t\0¹¼¼©\0\t\0Ûéÿÿü\0\0ž¼°¼\nšÀú\0©\t \0\0\0\n\t \0\0\0\0\0°\nšš°š
ù½°°\0\0\0\0\0\0\0\0šš™ùùÿ¿›©¹©\0\0\n›
ÛË½»½û¿Ÿ›ûûŸ›\t\0\t¹©à©\0\n\0¾»ÿÿû\0\nÙë
 °ð\0©Êš\t©\0\t\0\0\0\0\0\0\0\0\0\0\0\t\t\tÛŸÿ¹\t\0\0\0\0\0\0\0\0\0\tÚ›¿¹¹¼›
\0\0\0ššù»›Ûýû½½»ý¹°ðŸ\t\0\t\tŸšžš\0 \0
\0ÿÿü\0\t®
é ©\nð\0©\0\0\0\0\0\0\0\0\0\0\0\0\0°\0\0\0\0»ÿ¹¹š\0\0\0\0\0\0\0\0°\t¹»ÛŸ\t°¹\0\0\0\0\0\0
›\r¿¿›»Ûû¿›ŸŸ›°\0\0°Ÿ
À\0\0\0\0\t¿ÿÿ°\0 é¼\0\0 \0ðš\0\0\0\n\0\0\0\0\0\0\0\0\0\0\n\0
\0\0\0ž¹ðúÛ°š\0\0\0\0\0\t\t°Ù­¹¹°\0\0
\0\0\0\t\0\0š™\t¿Ÿ¹ùù¾›°°Û\t
\t™©à°°\0\0\0\nÿÿð\0\t  © ¬šÚð\0\n©\0š\0\0\0\0\0\0\0\0\0\0\0
\0\0\0\0™Ûû›°ù

\t\r™©\t\0\0\t©©¹­\tÛ
 \0\0\0\0\0\0\0\0\0\0°¹ë¿¿›ù½¹°›š°ù½¬\0\0\t \0›ÿÿÿ\0\0ÐË\0\t\0 \0ð\t\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0¹½½
š™°\0\n\t ™Ð™°°\t\t\0\0\0\0\0\0\0\0\0š™¹ûŸ›Û½»ËšŸ¼™ù™°›\n \0\0\0\0ÿÿð\0   \n\n\0 ð\0\t\n\0 \0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0»žŸ©¿\tÚ\t©\t©\0\t\t©­
›š\t\t\0\t\0\0\0\0\0\0\0\tšÛ¹¿½»Û½¹­°™°û\tž
Ë\0\0\0\0\0¿ÿÿà\0
\0°©Ë\tð\0 \0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\r»ùŸ\t°¹°Ú
\0\0\0š™\0\t›\t©©©\0ššš™\t°¹
ËÛ›Û¿šž¹©
›¹é¬ \0\0\0¿ÿÿÚ\0\0¬\0°\0  ð©\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0šÙú°Û\r
\t
\t°
\t\t\t
›Ú°\nšš\t\t°
››¿û¼¹½¹¹
Û\t°\t
š\0\0\0\0\0
ÿÿý\0\0¼
\n

šð\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t»\t\0\t©°¹
\t\n\0\t\t\0š›\t°š\t\0\t\t\t\tÉ
šš›\t©¹é¼›šÛÛù­\nÐšÙ\0™žšœ°\0\n\0\0½ÿÿú\0°\n­\0© ð\0\t\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
éð\0\0\0\0\0\0\0\0°\t©\0›É
›œš©
\0šš\t\t››
›Û¿½»»\t°¹¹\t›\t\t©©ê\0
\0\nÿÿÿ\0\0\0ð¬° šÚð \0\t\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\t›Ÿ\0\0\0\0\0\0\0\0\0\t ¹Ë\t¹ù\t©\t\0\t
\t\t©°ð¹­
Ùð¿›Û½¾™\0©\n›\0\0
šÚ\t \0\0\0¿ÿÿð\0\n\t© °  °ð\0\0\t\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ù°°\0\0\0\0\0\0\0\0\0¹
™°š›Ð›
\t\n\t\nšš™™
›™«Ÿ›é¿º›™©©\0\t\0™é¼\t \n\0°
ÿÿÿ\0\t¬°ùËË
ð\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0šÛÐ\0\0\0\0\0\0\0\0\0
Ð¹
Ë›¹°Ð°\t\0ž™

ùé­™©¿Ÿ¹½½ \0\0\0\0\0 ™Ú\0 
\0\0\0\0¿ÿÿà\0ž
\n\n\0à¬ð\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0›šš\0\0\0\0\0\0\0\0\t\t
ž¹¹ÐŸ›Ë\t©\t\0°
\nœ¹ðššÛÙ»ÚÛš\0\0\0\0\0\t°°
Ëð \0\0°
ßÿÿ°\0\0°ù©é


ð \0\0\0\0\0\0\0\0\0\t\0\0\0\0\n\0\0\0\0\0\0\0ùùÀ\0\0\0\0\0\t\0 ù°¹Ÿš¹©©™ù
\0°\t\0\t




\t
\t¹«ù¹¹¹\0\0\0\0\0\0\0\t\0\0°\r\0š\0\0\0¿ÿÿð\0©à\nÊ\0¬\nÀð ©\nš©\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0šš¹\t\0\0\0\0 \tšÙëšÙ½¹Û

\0\0\0\0\0\t\0\0\0\0\0ŸŸž›ËË\0\0\0\0\0\0\0\0\0¯ °\0\0\0\0ÿÿË\0\0žš­\n°ð\t\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0™ùšÚšŸ
™°ù¹»™ù»Ú›šŸ™é©\0\0\0\0\0\0\0\0\0\0\0\t©¹»Ÿ›\0\0\0\0\0\0\0\0\t Ðž\0\0\0°\0¿ÿÿð\0\n\n\0 Ê\0à\nð\n\0\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t©©é¹ùð¹›Úý¹­©Û©¼›ž›Û
\0\0\0\0\0\0\0\0\0\0\0Ÿ½¼½»\t\0\0\0\0\0\0\0\0\0\nÉ«à\0\0\0\0
Ïÿÿ \0\0ËÀ°š\0¼ð\0\0 \t \t\n\0\0\n\n\0\t\0\0\0\0\0\0\0Ÿ››Úž›Úù¿šŸ¹Û­Ÿ›½¹ù¹ð¹ð™\0\0\0\0\0\0\0\0šš›››\rš\0\0\0\0\0\0\0\0\0\0šÐ
\0\0\0\0\0¿ÿÿð\0°é  \n°\nð\0©\0 \0 \0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\t­©½»ù½¾›ùùû½»›ùºÛŸ
›Ú›©©\0\t\0\0\0\0\0½¼¿Ÿš\0\0\0\0\0\0\0\0\0\0 «À°\0\0\0\0ÿÿÛ\0\0\n\0šÀ ð\n\0\0\0š\n\0\0\t\0\0\t\0 \0\0\0\0\0\0\0\0©››
«ûŸ¿›ûŸŸ›ß»Ë½½¹ðÛŸ
\0\0\0\0
Ÿ«››™©©\0\0\0\0\0\0\0\0\0\0\0žœ°\0\0\n\0\0¿ÿÿà\0\0Ú\0š\0 \nð\0\n \n\0\0\0\0 \t
\0\0\t\0\0\0\0\0\0\0¼žŸ
½¹ù½¯¹ùú›ù¼»»Û
Ÿ¹»Ë\t­©\0\t¹ë™éù¾™\0\0\0\0\0\0\0\0\0\0\0\t 
\0\0\0\0\tÿÿÿ°\0 \0 À Úàð\t\t\0\t\t\0\n\t\0\0\0š\0\0\n\0\0\0\0\0\0\0\t
™\t½›Ú¿›ùÛûŸ¿Ÿ»Ÿ»ù¿Ÿ°Ÿ­½«¿›ûÛ™û›ž™\0\0\0\0\0\0\0\0\0\0\0\0\nÚž\t \0\0\0\0¿ÿÿÀ\0é\nš\n\0 šð\n\0 \0
Ê\n\0\0\0\t\n\0\0š\t\0\0\0\0\0\0\0\0š°°š¹Úù»½½¹¹ðù¹Ëž›½»ù»›ÛÙûû››û
Ú¹°°\0\0\0\0\0\0\0\0\0\0\0\0\0©¬\0\0\0\0\0ÿÿû\0\n\0à¬\n\0ð\0\0 \0\t\t\t\0\n\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°ŸŸ¹¿Ÿ
š½½»›Û¹ù½ºŸ›Ùûù¯¼½¯›½°ù¹ùé\0\0\0\0\0\0\0\0\0\0\0\0\0ºÐð°\0\0\0\0¿ÿÿà\0\0š\t  °Êð\0\t\0°° \n
\t\0 \n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t°°›Û
Ÿ¹Û
¹žšÛ»Û¹ù½¿©›ûÛÛùûÚŸ›Ëš\0\0\0\0\0\0\0\0\0\0\0\0
\n\0\0\0\0©ÿÿÿ\0¼ \n\0\0Ê\0°ð   \0\0\t\t\0\0\0°\0\n\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\t›ù­½¹É©°œ¹›™É©ÛŸº›Ûû»»›©¿››™ù\t\0\0\0\0\0\0\0\0\0\0\0\0\0°°é\0\n\0\0\0¿ÿÿà\0\t\0¼¬© à\nð\t\t\0ššÚ\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t
›šš™Ÿ›
\t©¹›­°Ûù¹¿»ÛÙùÛ›ÛË°¹ \0\0\0\0\0\0\0\0\0\0\0\0\n
\nÀ\0\0\0\0ÿÿù\0 ¬\0\t\0\t
Àð\0\0©\0\0\0š\n\t©©  \t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tûË\t\t\n
\t\0™ù›
É››¹¹ûÉÚ¹«›»Ë¹¹ÛÚ\0\0\0\0\0\0\0\0\0\0\0\0°ð\nÐ°\0\0\0\0ÿÿÿà\0\0š
\n\n\0\nð
\n\0

\0\0\t\t \n\0\0\0\0\0\0\0\0\0\0\0š\0\0\0š\0\0\0›Ú°Ù¹ºÛÛ¹»»Ÿ½¯»ÚÛ©©\0\0\0\0\0\0\0\0\0\0\0\0\0\0½ª\0\0\0\0
Ÿÿÿ\0¼  \t¬\0©ð\0\0©\0\0š\0\n\0©  \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t°\0\0\0\0\0
\t\t›Ù«šÙ°½»Ëùùû›¹«ù¹¹Û\0\0\0\0\0\0\0\0\0\0\0\0\0°°\nœ\0\0\0\0\0ÿÿÿà\0\0\0°\r 

Êù\0©à\0©¬\t
\t\t\0Ú\0\0 \0\0\0\0\0\0\0\0\0\0\0©\0\0\0\0\0\0\0\t\0šš¹›Û¹û›Û›Ÿ›ŸŸŸ›žŸš°ù°\0\0\0\0\0\0\0\0\0\0\0\0Ê© \0\0\0\0¯ÿÿð\0©¬\n\0\n\0\0\0ð\t\0\t\0\0\t \0\n\0\n\n\0\n\t\0\0\0\0\0\0\0\0\0\0\0\t\0š\0\0\0\0\0\0™

Ë\tË™é¹ûÚ½©©¹½¹°½™\0\0\0\0\0\0\0\0\0\0\0\0\0\0°ðšž\0\0\0\0\0Ÿÿÿ°\0\t š\r\nšð 
\0©\0š\0°°šš\t\0\0\0\0\0\0\0\0\0\0\0\0\t\n\t\0\0\0\0\0\0\0\0
œ¹™›¹
›¹Û¹ûðû›Ûšš\0\0\0\0\0\0\0\0\0\0\0\0
Ë\n©àš\0\0\0
ÿÿÿÀ

\n\0  àð\t\0\0\0š\0\0\0\0\0\0\n\tÀ \0
\0\0\0\0\0\0\0\0\0\0\0°\0\0\0\0\0\0\0 \t©ð¹ù\t½½¹»Û»Û››°ù­\t\t \0\0\0\0\0\0\0\0\0\0\0\0\0¼°ÚšÉ\0\0 \0ÿÿÿ \0\0À\tà\0 \0ù\n\0©\n\0°¼šžš\n\0š\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0 \0š\0\0©›

Û

ÚÛ½°¿¼½¹»šš\0\0\0\0\0\0\0\0\0\0\0\0\0\0
Ê\té 
\0\t©¿ÿÿð\0 ° 
Ê Ë\nð\t\t\0\0À\0\0\0\0 \n\0\0\0\0\0\0\0\0\0\0\0\0\0\0š\0\t\0\0\t
™©Ù¹©ù¹¹¹ËŸ™››Ÿœ¹\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0›Êžž°é¬\0ÿÿÿð\0œ¬šð©Ë\nÉð \n
\t 
\0°°°\t\t\n\t\0\0š\0\0\0\0\0\0\0\0\0\0\t\n\0 \0\0\0\0\0\0\0\nÚššž››ËŸ½»ù»ëž›
°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¹¬©é©Êð¿ÿÿÿ\0\0\n›ï\nü¾žšðšÀ\0
\0\0\0\t\n\n\t\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0›\t¹›Ùé½º›ùšÙ½¹é¹­\0\0\0\0\0\0\0\0\0\0\0\0\0\0šžžž½¯
Ëÿÿÿð\nÚì°ý«éé¯ð\0°š\t\0š
\té\0\t\t\n \0\0°\0\0\0\0\0\0\0\0\0\0\0\t
\t
\té\0\0\0\tššž»›šÙð¿Ÿ¿›ù¾šš\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°ð\nšÚËËÊœ¿ÿý \0\tžÿ¯ÚÚþÚð\0\0š\t\t\0\n\0©\0\0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t
\t \0\0\0š\t\t\t¹¼¹»›Û¹¹­›™°¹\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ËËéúÚŸ¯ÿÿÿð\0\néðùï¿
ÿð ©©\0š\n\t\0 \nœ \0\0À\0\0\0\0\0\0\0\0\0\0\0\0\0š\0\t\0\0\0\0\0š\t©­¯™½¼½¾Ÿ
ùºÛ\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¼¼°¯Ÿ­¯þŸÿÿÿ\0
Ÿ¯úðü¿àù\tÀ\0°\0À  \0 œ\0 
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\n\0\0\0\0\t\0™™­°¹›ù¹ùš™\0©\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
\n
Úðûùéðÿÿÿà\0¼ðýÿ¿í¿ð°°ð\t 
\0°\t\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\tš°°½©«Ùé°©\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0½¬¹ëÏ¾¿ÿÿÿ°\0°ûÿ¾¼ðúßð\0\0\0°\t\0\0\0°\0 \0\0 \t\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\n\t
Ÿ›™
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
 š¼ºûÏ¿ÿÿÀ\0
ÏëÏÿ¿ÿúð
\0°\0\0\0
\0\0°\t\0 \t\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0š\t\t©\0°š\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ž\tàûé­éé­ÿÿÿ\0\nž¿ŸûËïð\0\0\0©\0
\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°¹
\t©\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
Ê
\0žšž¼ºÿÿÿ \0ËÏ¯ÿÛÿÿù\0\0\0 \0\0\0\0\0\0\t\t\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 °¾\nËéà\r¿ÿÿÐ\t ¼Úðúü¾žðË
\t¬\0\t\t
É\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0º\t­­ëË\nÿÿÿ \0
ë®ž½ëéëú¹í«\t©°°úð°¿°šŸ\nÚð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ðš\0Úð¿­ ÿÿÿ\0\0ðËÉéþ¿­ýÿûßûü°Ÿ½¿ßðÿË\r­ùÿŸ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0° š½¯éú\n
ÿÿÿ\0\0\n¼®¾ùàðúûÿÿûß¿ÿ­ÿÿ¿ÿ½¿¿¿ÿÿÿð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\nÚÚ\nÛþÞÐÿÿÿð\nœ©
Ëïž¯ÿÿÿÿÿÿûÛÿÿÿÿÿý¼ÿÿÿÿà\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0

\0ð¿¯Ëú«ÿÿÿ\0\0\nž­¯Ú­­¯ÿßÿÿëý½¯ÿÿÿÿÿúÿ¿ÿÿÿð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¼¬
\0¼ÿÿéúßÿÿÿ\0\tËÊžŸ®Ú¯ûëÿ½½úðŸ¿ÿßÿŸŸ›ßÿûûð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
›À©ëÞ¾ž­­ÿÿÿ\0\n\n
íé©úßù¼Ÿ
Ÿ
\0ÚÚðûéé©©úßÏÚ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\tž¿Ëéëëÿÿÿð\0œ ü¾¾¯ð
\0©\0\0
\t©
\0°Ð
\t©© \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ððºË
Ë­®žŸÿÿÿ\0\0 ¼«üððúßð\0\0\0\n\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0


À­«Î½©ïÿÿü \t
Êýë«Ë­úð\0\0\n\0\t\0\0\t \t\t\t \n\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ðàš
ÚÎš\nÊ¿ÿÿÿ\0\nÊý¾½í¬úÿð\0°\0\0\t\0 \n\t \t\n\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð

Éà©°éé­
ÿÿÿð\0ªýë¯úý¯ð \0\n\0\t\0 \t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t©¬¼ª
ÊË\nÊþÿÿÿ\0\0 ý¯¼ð­¾ÿð\t\0\0\t\0\0\0\0\0\0\n\0 \0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ž
\nÐ°ðð¼¿Ÿÿÿû\0\nÛúßÏ¾ÿéàð\0\n\0\0\n\0\0\0\t\0
\0\n\t\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 šÐð\n\nË\nšË¿ÿÿÿ\0\0êúËÚÿ¿ðš

\0\0\0 \0\n\0\0\t\0 \0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ú\t 
À°šÚË¬¼©ÿÿÿà\t©ùý¿¾ý­ëð\0\0\0\0\0©\0\0\n\0\0\0\0\t\t\t\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
\tà\0©\0¬©¬
\tïÿÿþ\0®úàéëþ¼ð\0°\0\0\0\0\0\t\0\0\0\0
\n\0 \t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ðÊ\t ©\0šž\0°›ÿÿù\0\nËŸšÛŸ¯Ëžð\0\0°\t\n\0\0\0\0\t\0 \0\t\t\t \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0«\t É\nÊ °Ê\0­ÿÿÿ\0\t à¬¬¬©¬ ð\t\0\t \0\0\t\n\0\0\0 \0\0\0\n\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 ÚàË\n\t\0\nÊ\0ššÿÿþð\0šžšššÚšÚð\n\t\0\0\0 \0 \0\0\0
\t\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t©
\0\t\n\0 \nÊ\t\n\0ÿÿÿ\0\n ¬¬¬ à ð\0š\0\t\0\0\0\0\0\0 \t\0\n\0\0 °©\0 ¼\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
¬  \0\t\0°\0\0¬\0­¿ÿù\0\0Ë\té\nšžžð\0\t \n\0\t\0\0 \0\0\t\0\0\0Ÿð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0šÐ\n\0\0\0À
\0\0 Ÿÿÿþ\0
\nÊ\nÚÊÊ
\0ð
\t \0\0\0 \n\0\0\0\0\0\0 \t
\0\0°š
ÿ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0 Ð\nš\0  \0\n\0 ÿÿÿš\0¼°© ¼ úð\0\0\t\t\0š\0\0\0 \0\0 \0
\0\0\0Ÿÿð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¯\0 \0\0\0\t\0\0\0ÿÿÿ\0¬ ¬\nž\0ù\0š  \0\t\0\0\t\0\0\n\0\t©\0\t\0©­ÿÿ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t \n\nð
\0¼\n\0\0\0 \0\n\nŸ¿ÿð\0\n
\té š
ÊúÛé­Ÿ›šÛš°»É­©­›¼ûÿÿú\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0 \t­­
¬°\n  \0\n\0\0ÿÿÿ\0\t\0ê\0°éà­ ûŸúûËÏÚý­¹ýÿ¾Ÿÿš¿š›úßÿÿý°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\nÚÊ\0ºüš à\t\nš\r\n©ÿÿÿ é\r Ë\nžšÚÿÿÿŸÚûûÿÛûïûýÿßÿŸíðûéþŸ¿ÿÿðà°\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\té °úË
éé®š\t é°©ÊŸÿÿþ\0\0š\n
\0éà¼­ÿÿÿÿ¿ßÿÿÿýÿÿÿ¿ÿÿÿ¿¿ýûÛÿÿÿÿ½à\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0 ¾\nœ¼¼°þžšù\nÚë¬¼©ïÿÿû\0\0¬°ðêš
ÊšùûÿÿûÿÿÛÿûùÿÿÿûÿÿßÿ¿žÿý¿ÿÿð\nŸ¬\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\nœ  \t\nœžðúúÚž¹ë\néð©ï¼ûëþ¿ÿÿü\0

Ê\néà©àÿýûÿßý¿ÿÿÿÿÿÿÿÿÿÿ¿Ÿÿùû¾ÿÿÿÿ¼¬º\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ª
Ê\tª\në
ËÏ¯éïàù ©é\nûÏžŸÿÿÿ°\0Êžž© ¼\nšÿ¿ÿÿ¿¿ÿÿÿýûÿÿÿÿÿûÿÿÿ¿¼ù¿ÿÿðË
Ï\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\r¬¼©êÉé\0ðûúÚžšú›žž\nùï¾ÿ¯ÿÿÿþ\0\0°Ë©ËËË­¬ûÿÿÿÿÿÿ¿ÿûÿÿÿÿ¿ÿÿýûÿý¿¿ÿÿÿ°¬°¬\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ú\n
\nžš°ï¾¼ééëí©ÊË
\nŸžÛËÚü¿ÿÿù\0ž¾Þ¾®šÚ
ÿÛÿÿùûÿÿÿÿÿÿÿÿÿÿÿûÿÿûËÛßÿÿð

 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0

Ëàùà¾­°ðû¿¾½úÚ© àœ «¯¿­»ûÿÿþ\0\0°é©é½®šðÿÿŸÿÿýÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿¿¿ÿÿ¿\0ððéË\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¼¼°ž\nž\t«àëËíééê­¬šš
¼¼¾Þÿÿÿÿ\0 Ë¯ËÛí¯ÿ¿ÿ¿ûûÿÿÿûÿÿÿÿÿÿÿÿ½ûûÛÏÿÿÿü¿¾¼°À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
Ëàëééé¾žŸ¼¯šþ¾ŸúÚš\0\0\0\0ºÛëé«ÿÿû\0\0°ððû¾¬ºÚÿÿÿÿ½ÿÿß¿ÿÿÿÿÿÿÿ¿¿ÿýý«ûÿÿÿð°ûëÏ©\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¬¼¼©¼šž°àðúËý¯ùðúéëËÀ°Êšœ¾­ÿÿÿü\0

šÊŸ­­ÿùûßÿ¿¿¿ýÿÿÿÿý¿ÿÿßÿ¿¿ý½ÿÿùéïß¿¿ùí­\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0©
\nšÚËí«ËÛëËðúý¯¯½¿­ °\n¯­¼ºÚ¿ÿÿû\0\0š¼©¬¹êž°ÿÿÿÿ¿ýÿÿ¿¿ÿÿÿÿÿÿÿÿ¿ÿÿ¿¿¿ÿÿúúûÏËï¾¾ûé\0\0 \0\0\0\0\0\0\0\0\n\t¬\nððí©©©í®­¯¼¯¯ü¼®žÚÚ\0«\t­úûËÿÿÿ\0 À©à°œ°úÿÿ¿¿ßŸ¿ÿÿÿûÿÿ¿ÿý¿¿ýÿ¿ßùÿÿÿí¯Ÿž¿¿ÚÛßž¾ž\0 \0 \t \0¬\n 
\r\n
\nžü¯
ÛÚÚÛùëÚŸï½ë¯­ ¯¾ž½¬¾©ûÿÿþ\0œºÚšÊð«\0ÿÿßÿúÿÿŸùÿÿÿÿÿÿ¿ýÿÿ½ÿ¿ÿÿÿ›­¯ïüü¿þúûý­¯ž\t\0œ¬\t  ©É¬\0 žš½¯®¯­¯½¯þ›ÊðüšÚð›éëËëžŸïÿÿù\0\n¼­
\0ðé
ÿûÿŸ¿¿Ÿûÿÿÿÿ½ÿÿÿûÿÿÿÿÿû¿ÿÿàÚùðûûí­½ð¾ûËÛéúÚ\n™ \0©\0 \t ž\0°¹­þ¼ÛÚÚÚùúÛËþ½¯
¬°ž®
ËþŸëëÿÿÿþ\0\0ûË\n¬¯¼ ÿÿÿÿßßûÿûÿÿÿÿ¿ÿÿÿûÿÿ¿Ûýÿÿÿ¿\tëÿÞ¿úúÿËí¾¼¾ž¼¼®ž¬¼
\t \0\0°
\0º ðúð¯¯¾žž¼°þ­°ð¼¿êß¼¿ÿÿû\0°¼ðšÚù
Êÿÿÿ¿¿¿ýùÿÿÿÿÿÿÿÿÛÿÿÿÿ¿ûÿÿýð¿¼úûëÚßß¿žùëÛ­©©ùéù©°¼\n\0\n\0\0ð°¼¯\r­ªžŸž¯žùëÚéé¯
Ú\r©ëé½¾ßÿÿÿü\0°ë­­®¼©ÿÿÿýÿÿ¿¿ÿÿÿÿÿÿÿ¿ÿÿÿÿýÿŸ¿ÿÿ ðÏ½þßï¾¾¿­¯ž¼¾ÚÚÏ¿Úàð¼
\t\nš\0\n\0\n©Ë\nà½¯­ªÛð¼ªÚšßïëúÿÿÿû\0©­°úÚúÛÊžÿÿÿûùÿßÿÿÿÿÿÿÿÿÿ¿ßÿÿ¿ûíÿÿÿ°úÛéûÏÛÏÚß­¿Ë¼½ºùüûŸ
À\n\0É\nœš\n©À éŸ¬°é®ù¯ËÉ©©ïëûüÿÿÿü\0\nÊ­­®šðÿÿÿÿÿûûÛÿÿÿÿûÿÿÿÿ¿ÿÿÿ½¿¿ÿÿð°ûí­¾Ÿ¾¾¾¿­¾Ú¼éêÙë«Ï¼°ðð°°¬¼ ©À¬\n
\t\n\0°­°éšÏ

¬\nË
žÞ¿¯ÿÿÿû\0¼¾¼¾¾ž¼¯ÿÿÿÿûÿÿ¿ûÿÿÿÿÿÿÿßÿÿÿßÿýÿÿÿžžÚÛþ½¬ÛËÛËÚÚ½é¾›¯Þ¿­¯
ÊÊÉ©©
Ê

\t\0\t
Àš\n\nË©ààË\r ÿï¿Þðûÿÿþ\0\n
ËËéééËÚÿÿÿûßÛùý¿ÿÿÿÿÿÿûûÿ¿ÿûûûÿÿùë¿ÿëËëºùêùëëÞ»í¬ðùëðúÚð¼°ššÚÚüšÚÀðà°š\0«àð ÚšÐ© ° ½àûí¯Ÿÿÿÿð\nž¼¾žž¾«ëÿÿÿÿ¿½ëûßÿÿûÿÿÿÿÿÿÿ¿ÿÿßÿÿþþßëß¾ŸÏŸ°ý«ÞšÛ¾Ÿ
ËËÊ\r¬­¯
í©«\nšÊ\0é\0©Ê\0à\0Ð\0ž\n¿œ¾°úÿÿÿù\0š°úÚúééüüÿÿÿÿÛûý¿¿Ûÿýÿÿÿÿ¿ŸÿÿÿŸ¿¿ÿÿúŸ¿ßÿßúùûéðÚ\nÚ¼ú­°Ëëúðð¼°¼°›\té«ËÉéé
Ë\nž\n©
\0  ð œ\n¯\0úËÿÿþ\0\0ËËéËº¿ÿÿÿÿ¾Ÿ¿ùûÿÿ¿ûÿÿÿýÿ½ÿ¿ÿéÿÿÿ\r­ï¾úûßþÿÞû­½­
\ršË½¼½¼¾›ððšúžÚ¼ºÚž¼°éé«\n 
\t\0\0\t ¼­\0°ÿÿÿÿ\0\nž¼¾¼úûÏÊÿÿûÛý¿ßž½ÿ½ÿÿÿûùûûÿ¿ÿÿŸÿÿþšŸ¿ÿÿþþûÞ¿Ë©ëË®›ËëËëËÎ\0°©­­é©ËÏ
éÊžššðð¼
Éà\n\n\0\0\0\0\n\0
¿ÿÿð\0¼«\nÚ¼¼ú¹ÿÿÿÿ¿ÿ¿½¿¿ÿûÿÿÿÿÿýÿÿÿÛûÿÿùàþüÿßÿÿÿÿÿûÿùÿ­¬\t¬°½­©é»ÚšÉëËË­©­
©é­­­
Ê\nšÐÐ
\n\t\0\t\n\0\nŸÿÿð\0\tÉé­¯ËëÊÿÿÿýùÿßÿ½ý¿ÿÿÿÿÿÛûÿÿÿÿý¿ÿÿš›ûúúßùï½ïÞ¼¿Ûûðùí¯šÚžËéé šž¼°ðððúðð¼°úðúð¼½  ©\0À\0\n\0\t\0¯ÿÿÿ\0\n\n\nÊš¼¼°¼ÿÿÿ¿¿ûûÛÛûÿÿÿÿÿûÿÿÿÿÿ¿Ÿÿÿü¼ÿÿúÿÿï¿ÿÿþÿ¯ËË\nšž
Ë¼¼¼
Ëé¯
Ë
Ë
ËÚÚËÊžžž°°°©\n\0 \0Ÿÿÿú\0©Ë\r©ËËËËËÿÿÿÿÿÿÿÿ¿ÿÿÿÿÿÿÿÿÿÿÿÿÿûÿÿû\0¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿
ËË\0°°ð¼¼°ð¼°ð¼°ð¼¿­©©©é© \0\0\0\0\0\0\0\0¿ÿÿð\0\0 \n\0 \n\n\n\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ô­þ','Michael is a graduate of Sussex University (MA, economics, 1983) and the University of California at Los Angeles (MBA, marketing, 1986).  He has also taken the courses \"Multi-Cultural Selling\" and \"Time Management for the Sales Professional.\"  He is fluent in Japanese and can read and write French, Portuguese, and Spanish.',5,'http://accweb/emmployees/davolio.bmp'),
  (7,'King','Robert','Sales Representative','Mr.','1960-05-29','1994-01-02','Edgeham Hollow\r\nWinchester Way','London',NULL,'RG1 9SP','UK','(71) 555-5598','465','/\0\0\0\0\r\0\0\0!\0ÿÿÿÿBitmap Image\0Paint.Picture\0\0\0\0\0\0 \0\0\0PBrush\0\0\0\0\0\0\0\0\0 T\0\0BMT\0\0\0\0\0\0v\0\0\0(\0\0\0À\0\0\0ß\0\0\0\0\0\0\0\0\0 S\0\0Î\0\0Ø\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0€\0\0€\0\0\0€€\0€\0\0\0€\0€\0€€\0\0ÀÀÀ\0€€€\0\0\0ÿ\0\0ÿ\0\0\0ÿÿ\0ÿ\0\0\0ÿ\0ÿ\0ÿÿ\0\0ÿÿÿ\0þÞÍ¬þüêÞÎËÎïïìÿïÏîíïïïÍëÎÿïÏíïÏïìýïü\0\nàíþÎŸßËùùüüïÏÀ\0\0üàÎàü¾ÞÊËÊì¬ïÎÌ¬éàþíàààîÚÎÀÎÞü¬®Î®Þìü¬üíïàíïìüþßþÿüþîÎïÎþßíïþßïïé\0\0žœ­ïàü½ü½½ÏŸŸýïü¯\0\0ÀÊÜ¬žÊÌüì¬­ìíïÏì¬ì®ÞÎÎÚÏÏÎÞ¬ðþðîúÎÜ­ïíËÊÞîúîÞþïÏîþþïïïí¬¼ðïíàþþþÏîþÿðàìÞúÏËÛËßéý¹ééÿÊÀÊ\0ÀïÊÌììÊÎÎÞËÊÀàííëÍàüðéîþàéàÞÊÎýüÌ¯ÎìþïÎÎÎžÏÏïÎžïííïÞÿþÞÞÎïíþþþÿÏþýïÞÿ\0\0\réìïíéí­ý¯Ÿ\tíùœùïÿÊÀÀìœ¬éÏÀðàìüþÏÎëÊÌêÎÊÎÎÏËÏÎÎìüííîþ¼ì¼ÏÊððìíîüþþþÞþþþÿîÿêÎüüîÿÏïÏîþïþÿï°Ààð\rëÎžŸÚÛÜðùšÞ¹\rïýì \0¬ÚÀìÚÎÉììüþËì­ÎÎ¼ÎžÎÊÞ¬ìúËìžàüêÞðÎþÎþëïÎÎÚÊíêüíìþÚÏïîßíüéîßîþÞþýíþÿïÿ\0\0þüÚÙéí¼ûßœ½™Éðüýï¼À\0Ì¬ü¬ÊÌ¬ÊÊÀàüìËÎ­¬ÎžÎžžÎÞþÞüËìÞëíïü¬ïïÞÌÊÀîÎÞÏÏþÿïïþÞÿþþ®Þìþþïÿþ¾Þïïüþüð\0ÊîÞ¼¼žœ½­½é©ÉÎž\tÐþüþš\0ÊÏ\0àÌ­ÊÞ­íîÞÎîÏÎÏàìàììðì­îÏîÏ®ÞÞþÿËÊÀÎïëíï¼®þþïÞÞÏïïïÞÜ®ÚÏïýïïÏïÿîÿíïûÀß¯ËÚÙËÐýËýù\n™Éü¼¼ïÏí\0¬ìÎÚÎÊÊÀí¯ÊÉàéàÞÊÏÊÊÎÞþéàùîÏîþíÿþü¼ìêÎþÎÌìïÞþïïïïÞþþïÌìïüþþÞíîÏýïÿïï¼íËÉÉéÐý¯œ½­œ
ÐÐÙéïé\0ËËÀììàììþÎÏìïÎÎ¬íàìüàìéîÞîÞðüÿúÿíþþûÊÐÌàíðúÏþïÏÏÎÞÞþÿïïýïïíïþÿþþþþÞÿÀ°¼žžžŸ\tÙíÚÛÉÏ\rÎÞð\0ÌìàÉÎËÊÌü¼¼¬­Îœ¬ÉàüúÞÏìüëÎïë\0þþíüüíîÊœÎîÌþÎÞþúïïïïþßí¬ïþÿþÿïÎüïïïÏïþÿÎÉééÍ¼žžŸ­ðš¹\t\r\tœ¯îÚðàÎ¬àÞÏËîÎÎìîÍìàÎÏ®ìàìîúËÎüíÿ°\0ÿÏþïîþéüïþÿïííàþþÿïàìíïïïíþÞÿïþüÿïÿÏïðÐžšËÐùéÞŸ™ÉÀÚÐ¼\tÀÏï\0ÎÏÎÊÎ¬¬îÐí¬\r®ž¬¬ÀËÎÏííîúÏþðÀàþþÏüýíîïÎëÎÞíîþþþÏÏïÿþËÎþÿþþþþÏþüÿíîþþü¯\r­¼ùÚÛÉðùéàš\r­\tàþ°úÐàÀÌ\ríïïÊÎÌìÎÎÌÏÊÎÌ¬¼ðîÞÏÎÿë\0ÿíþËî¾ýì¾ÞéÀìþýïííîþþÞÏìïÏïÏÏíïþßïþÿÿüþÚÐÐðÚÙ\r\r¼\tð \r\0ðœïí\0íì¬¬ì¬ìí¬ÚÊÊÀðààì¬¬üîïéàþÿ¼àðþþïþíí®ïíîÞþàþíïîüþÿïúÎÿþþÿïïïïîÿïïïï¼­­\réÚßžŸ\r½ŸÉðœŸ\r\t\0Îÿ¬þðààÀÎžÏÊÎ¬í¬ÎÎÀÌààü¼üïïúÊ\0üüüíþþÞÞÎžþÞðìïþü­ïïïþÏïïÞþüþüþÿþÞüþÞÏÀÐðÛÉéàÙðÛÉéŸ
À\0
\0ÎÿÏéïí¬ìðí¬Ì¬ÎÀÉíëÏÏïÎýéé\0\0\0 ÿï¯îÞÏï¯ïíï¬þžïïÞÎÞÞÿìïÞþþüþüïíïïþþÿïÊœ¼ŸŸŸŸ\r¼ž\rÐ›\r©\0üïþþÌþàìü¬¬ÊÊÀÀìëîÊÌàìÊÏýïÿ  \n\0\0þüüðïÎÞÞïìÿìþü¬þî¾þÿïïïßíïíïþÿþýïÏÎü°ÉÏ\rùïËÛÙðÐùùé©ÀÐ\t©\0Þüü¾ÊÎðàÞÌàÌìþÀ¼Ëïþþþ \0\0\0\0\0ÿþîþüïéîþÞËÎÏíéÀïýíïþüïÏïîþüþÿíþïþïïïÏž¹Þ¼ùßŸœžœœ©\n\t\0Î¼þ¾íàÊéÎààÊÀàìÎìÿïíïÏð\0\0\0\0\0üÿýíîüîÞïþïïïïÿÌîïïïþþüþÿíïïÏïïßïüþÞ\t\tÉÞ½Û­éý½½™ééðùœ\r\t\0\0îýíì¬àÎ¬ÀÌÊÎ¬ìííí¯àüþþð\n\0 \0\0\0\0úÏïïéïžÎüîÞÞÚÏÎï¯\rîÞþÞÿîßÏïüþþþÞþüþÞûËÊÚÝëÍýÛÞžžžÚÐÐ
\r\0 \t\0\0Üïì¾ÚÀÏÀÊÎÀìîÀÀÊËËÎÞÞþÏÏë\0 \0\0\0\0 üðÿïÏìïéÎÚïïïþÿÞüì­ïþþüÿîÿþþÿíþÿïïïþ\0œ™ý¾¿­ùýùù½ù­­°ÐÚÐ\0êü­ìì¬¬ÀÀà­íìÎÊÞÎïïÏþº\n\n\0\0\0\0\0ÀþÿþÏþÞúííííìþïþðÎïïüþþÿþíïÎþïþýïÏàŸËÏËÙÿíÿß¾ßžùí\tËÉ\r\tÀ\0\0\0\0íÎþžîÚÀ¬ÍìÀéïÌ¬­¬¼ìúÞÞþ®\0\0\0\n\0\0\0\0\nðð\0ïþÏ®ÏÎïîþÿÏþÿïðÌþÿíïÏíþþÿÏÿÏþþðÉÀœ½½ïéûß½ý¾ÛÏÛÞšÛÐðÀ\0\0Î¼üììÎÏ­Î¾ÞÎÎÎÚíëí¯É   \0\n\0°\n¾\n\0þÿüþüýìðïïþÞüþÞ¬ÏþþÿþþþÞþþþþþÞïšœ½íí½ÿßíþŸÛý½­¹éÍ­­©\t\0\0àïÊÊÊ ÀàîìÊàðéàìþÎïÊ É\0\n\0\0\0\n\0 ð\0\0\rþþü¯êþïíïïïïïïÐïïíïïïÎÿÏïïïÏïÐ\rËÛûß¼ÿ¿ÿÿýëßŸÏŸ©ÐÚÐ™\0\0\0\0\0Ïàüì¬ÊÌ¬ìÐìíÏÎÞÏËÀÿÎ©À  \0\0\0\n\0š\nð \0\0ïþÞÿÏÏÏïÞÿÏÏïþÿüþþüþÿîþüÿÏï©œ¼½ïÞÿÿÿß½ûÏ½ééùðÝ­½\tð\0\0\0àÏÎ­¬¬¬ÊÞžÚÎêÎÏì©\0
À\0\0\0\0\0\0 ÿ\0\0žÿþÎþþþïïïÏïíþïþïÿíþÞþßïþÞþüü\téýÿŸýþßÿÿÿß¿ÛÛß\r°žœ¼\nÐÀ\0\nÏîÎÌÊÞìàì¼úÌ¼ÏÎÏï
\n\n\0©\0\0\0\0\0\0\0 þ°š\0 \0\nÿþÏÏÏþÞþþþþýïýïïþïïÏïÞÿïíï
Éýûÿÿÿÿÿÿß­ü½ùûÏÙéÛÙ\t\0\0\0žðéàÊðü¬àðí¬àÎžÊàÏéêÊ\t\0¬\n\0\0\0\0\0\0 \0þÚ\0\0\0Ïíï®þÏîÞþßïîþþþýïÞÿþþÿïíïàœžüýÿëÿßÿßýÿ¼¿ÛÛÚÚÐ¹¬šÐ\0\0\0àììüÀìÊÊÍ¬ÎÀÎÀì­Îþž\0\n\t\0 
\n\n\0  \0\0ù \0\0\0\0ÿþÞÞÿïþÞþÞÿÿÏÿïïïïïïþÞþðÐùÛÿÿßÞÿÿÿÿýÿý½í­½ŸÀÙý­ù\t\0\0Ààü¬¬ü¬íÊÀààÌÊÞëË\n\n\0\0\n\t \0\0\0\0\0\0\0¾\n\0\0\0\0îÿïïïüïïïÏïþÞþÿïþýïïïÏéËËÏïßÿÿÿÿÿûÿ¿Ÿë›ÛÉéŸžðšÐÐ\0\0¬ü­ïÊÀÞ¬ìÎðéììý \0\0\nÐ\0\n\n\n\0\n
\0ð \n\t\0\0\0\0\0ÏíþüÿüþýïïþÿïÿÏþÿïþÿþþÚ\rŸß¯ÿÿÿýÿÿýÿßùýí­¿žùíŸÉ

\0\0\0ÀÏÊÀü¬¬þÀÀàÐÎÎÏûàð \0à¯\0š\0\0\0 \0\0 \0\0ù\0\t\0\0\0\0\0\0¬þíïïïíîüÿíþÿîÿïþþÿÏïí\0ÚÜü¿ßýÿÿÿÿýÿÿÿÞùùùÉééÐšÐ½éÀ\0\0àíïÊÞÎÀ¬ÎÀþ° \0\nßÉëà ° \0\0\0\0  \0\t\0\0\0\0\0\0\0\0ïÿïþßïïïÿïþÿþÿíÿþþýé\r­¿ÿÿÿÿÿßÿÿÿÿÿŸ¿Ÿžžž™©í›À™\t\0\0\0ìü¬­àÀÀìÌðàïé\0\0 \0\0¬\n\n\0\0š\n\0\n\0\0\0\0\tð\0\0\0\0\0\0\0\0\0\0ïÿïîÿíîþþþÿíïïþïïíî\0éÞÞ½ÿÿÿÿÿÿÿÿÿßýýðùùùìðœ›Í½¼¼\0\0ÀþÏÎààÊÀÚÎÏé\0\0\0\0\0\0\0 \0àð \0\n\0\0\0\0\0 «\0\0\0\0\0\0\0\0\0\0\nÏÿÿÎþÞÏÿÿïþÿþÿþßþßœžŸ½ÿýÿýÿÿÿÿÿ¿ûï¿ý½­\t™
À°ÚÙ\t©\0\0ËÊü¬ÎîÎÏü°\0\0\0\0\0\0\0\0\0\0\n
 \0\nÀ\0\0\0\0Ð\0\0\0\0\0\0\0\0\0\0\0¬þþÿÿïïïïÿïþýïïïïà\r­üÿÿÿÿÿÿÿÿÿÿÿßßü¿ïŸùí¹ÍŸ¼¼\0\0ÉÎÏÀÀààíï°\0\0\0\n\n\0\0\0\0\0\0 é\0\0 ¬\n\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0ïÿþþÞÿþÿþÿïþÿÿþÚÚÞÿÿÿÿÿÿÿÿÿÿýÿÿ¿Ûýùùž\r© ÙÙÉ\0\0\0Ìí¬¬¬Êï°\0\0\0\0À\0\0\0\0\0\0\0\0\0 \n\0\t \0\n\0 š\0\0\0\0\0\0\0\0\0\0\0\0\0ÿÿþþÿþÿïþÿïïïé\r­ý¿ßýÿÿÿÿÿÿÿÿÿŸßÿŸžÞùùðœ¬ù ¼¹\0\0\nÜÏÊÌÊüð\0\0\0\0\n\n\0\n\0\0\0\0\n\0 \n\t\nÊ\0\0\0\0\0é\0\0\0\0\0\0À° \0\0\0\0\0ïþÿÿþÿþþýïþÿÞð\r¯ßÿÿÿÿÿÿÿÿÿÿÿÿÿŸÿùùððŸ
É›\rœ™À\0ÀàÚÞÊÌ¬ìú\0\0\0\0\t\n\0\0\0\0\0\0\0\0\nÉ¼ \0©\0¾\0\0\0\0\0š\0\0\0\0\0\0\0\0ïþþÿþÿÿþÿïïï\0Úýÿÿÿÿÿÿÿÿÿÿÿÿÿÿûÿ\tÿŸŸ™éœžœšÛÊ™\0\0\0ÀìëÀÊÏ¯\0\0\0\0\0\0\0¬\0\0\0 \0\0\0\n\n\0\0\n\0\0©\0\0ð\0  éË\0\0\0\0\0\0\0\0žÿÿþÿÿïïþÿþðžžßÿÿÿÿÿÿÿÿÿÿÿÿÿùýùÿððüž™é©É­ž\0\0Àü\rîÚÐ\0\0\0\0\0\0 \0 à\0\0\0\0\0\0\0\n\0\0\n\0 \0\0\0ü \0\0\0\n\0 \0\0\0\0\0\0\0\n\0\0ïÿïïÿþÿïíð\0ßÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûÿŸŸ½¹ùðÐ¼›ËÚ\t\0ÀÀÎ¬îž\0\0\0\0\0\0\0\n\nÀ\0 \0\0\0\0\0\n\0  \0\0\0\0\0\0¯\0\0\0\n\0 \0\0\0\0\0\0\0\0\0\0\0ÿÿÿïïïÿþ©ËÏÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿý¯ùéÚÚŸžœ›É¼°\0¼Þž\0\0\0\0\0\0\0\0\0\0  \0\0\n\0\n\0\0\0\0\n\0\0\0\0þš\0\0\0\0\0\0\0\0\0 \0\0\0\n\0\0þþþÿÿþþÿ\rÿÿÿÿÿÿÿßÿÿÿÿÿÿÿÿ¿ùþŸ¹ŸŸ\t\t
šËË\t\t\0\nÊÎ  \0\0\0\0\0\0\0\0\0 ª\0\0\n\n\0\n\0\0\0\n\0¬\t\n\0\0\0\0ú\0\0\n\n\n\0\0\0\0 \0 \0\n\n\0\0ÏÿÿÿïïÿüþÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿŸßŸ™ùÉàÐšÚÐÙ­ÚÐ\0ÊÐ\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\n\t\0\0\0\0ÿ\0\0\0\0\0\n\n\0\0\0\0\0\0\0\0 \0 ÿïïÿÿïËšßÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ûûÛ¼™
É\t
\0
ËÙ°\0Ààü \0 \0\0\n\0\0\0\0\0   \0\0   \n\0\0\0\0\n\0 \n\0\0\0þ°\0\0\0\0\0\0\0\0\0 \0\0\0\n\0\0ÏÿþþÿþðÿÿÿÿÿÿßÿÿÿÿÿÿÿýÿßÚùùéÛËÉ¼¼¼›À­\t\0àà\0\0š\0\0\n\n\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0ûÀ\0\0\0\0\0 \0\0\0\0\n\0\0\n\0Ê\0\tïïÿÿþÿéÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûûùžÚÛé¹ÉÛÚÙ ÉÐð\0À\r© ¬š\0\0\0\n\0\0\0 \n\0\n\0\n\n\0\0\0\0\0\0\0\0\0\0 \0þ°\0\0\0\0\0\0\0\n\0\0\0\0\0\0À°\0Ïÿÿïïþÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ÿ½¼žý½ùÛÚÞŸ¼ŸŸÉž\n™\nÌú\0úÉ¬ \n\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\n\nð\0\0\0\0\0\0\0 \0\0\n\0\0\0\0¬\0 ÿïÿþüéÏÿÿÿÿÿÿÿýÿÿÿÿÿÛÛßŸùúßðù¹ðßééŸ\t
ÉÀ\0¬ \n¾ Ê\0\0\0\0\0\0 \0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\n\0ÿ°\0\0\0\0\0\0\0\0\n\0\0\0\0\0\n\0àÊ\tÏÿïÿÿÿÿÿÿÿÿÿÿûÿÿÿÿŸÿð¼ðÿß¿ùÿüý¿½½ÿŸž°ÀÎ°\n\0 \0 \t¬°  \0\0\0\0\n\0\0\0\0\0\0\n\0 \0\n\0\0\0\0 °\0\0\0\0\0\0\0\0 \0À \0\0\0\0Êœ©ÊÿÿïëÿÿÿÿÿÿÿýÿÿýûßÿÿÛÿý¿ßßùûûÍÿÿ¼ùùÛÉ\r\0ù\0\0\0\0\0\t \0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\n\0ð\0\0\0\0\0\0\0\0\0  \0\0\0 \0 ê­­ÿïÿüœÿÿÿÿÿÿÿÿÿýÿÿúðÿý¿ý¿ÿûûßýýûéýÿž½©
Ë
À\0\0\0\0\0\0\0\n\0
\0\n\0\0\0\0\0\0\0\0\0\0\0\n\0 \n\0\0 \0\0­\0\0\0 \0\0\0\0\0\0\n\0\0\0À \0Ú\0\0ÏÿþûÿÿÿÿÿÿÿÿÿÿûÿŸß½¿ýÿÿßýÿÿÿûýÿ¿ŸýÛŸ\tÉÌ°\0\0 \0\nË\0\n\0\0 \0\0\0 \0\0\n\0\n\0é\n\0\0\0\0\0\0úÚ\0 \0 \0\0\0\0\0\0\n\n\0\0Ú\0¬¬°\0þÿþœÿÿÿÿÿÿÿÿ¿ÿÿÛÿ½ÿÿÿÿÿÿÿýÿÿýûßßùûýé©ðšš\0\0\0\0 é¬°\0\n\0 \0\0\0\0 \0\n\0\0\0\0\0\0\0\n\0\n\0\0ÿ \0\0\0\0\0\0\0\0\0\nœ\0\0  \n\0\0\0 \0ÿÿíÿÿÿÿÿÿÿÿýûûÿÛßýÿÿÿÿÿÿÿÿß¿ÿûÿžŸŸÛ\r­\r\0\n\0\0\n¼é\n\0 \n\0 \n\0 \0\0\0\0\0Ê\0 \n\n\0\0\0\0\0ú\0\0\n\0\0\0\0\0\0\n\0¬\n\0\0\0\0  \0\0ïþû\rÿÿÿÿÿÿÿÿÿýýÿÿÿ¿ÿÿÿÿÿÿÿÿ¿ßýýùÿý½¿šÛ™Ë\0\0\n\0\0\nÊš\0\0\0\0\0 \n\0\0\n\0\0\n\0\0\n\0\0\0\0\n\0\0\0ÿ \0\0\0\0\0\0\0\0  \n\0À\0\0\0\0\0\0\tÏÿü\0ÿÿÿÿÿÿÿÿÿÿÿùÿÿÿÿÿÿÿÿÿÿÿÿýûûÿÛÛÛÉý°ÚÐ\n\0\0\0\0\nÀ \n\0 \0 \0\0 \0\0\n\0\0\n\0\0 \0\0\0\0\0\0ü \0\0\0\0\0\n\0\0\0\0\n\0   \0\0\0\0 \0 Þÿ¼ÿÿÿÿÿÿÿÿûÛûÿÿÿÿÿÿÿÿÿÿÿÿÿûÿßÛý¼ùÿŸ\r°š\0\0\n\0\0 \0\0\0\0 \0  \0 \n\0\n\0À\0\0\0\0\0\0\0\0\0«\0\0 \0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0 \0ïþÐÿÿÿÿÿÿÿÿßÿßÿÿÿÿÿÿÿÿÿÿÿÿßÿßÿ¿ÛÿŸ™ùù›Éð\0   \n\0\0 \0\0¬\0 \n\0\0à\0 \0\0\n\0\n\0\0\0\0\0\0\0\0ð\n\0\0\0\0 à \0\0\0\0\0   \0\0\0Ë\0\0Þÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûùý¾½­¼¼¼¹\tÚ\0\0\0à\0 \0\n\nÊš\n\0\n\n\n\n\0\n\0\0\n\0\0\0\0\0\0\0\0\0 \0\0\0À¬š\0\0\0\0\0\0\0\0\0©\n\0šïéïÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûùýÿŸ¿Ÿ›Û™ÚÚ\t\0\n\n\0 \0\0\0\0 \0 \0\0\0\0\n\0\0\n\0\0\0\n\0\0\n\0\0\0¹ Ë\0\0\nš\0\n\n\0\0\0\0 \0 \0\t
\0\n\0¬ÿüÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿýÿ¿ŸŸ½ŸŸ¼ý­¯\t­\n\0\0\nË\n\n\0 \0\n\0\0   \n\0\0\0\0\n\0 \0\0\0\0\0\0\0à\0¬\n\0\0\0 \0 \0\0\0\0\n\0\0\0\0\0 \n\0\0ËÏëÏÿÿÿÿÿÿÿÿûÿÿÿÿÿÿÿÿÿÿÿÿßÿ½ùùðÚùùË›ÛÙ½©°\0\n\0\0\0\0\0\0    \0\0\0 \0 \0\0\0\0\0\0\n\0\0\0\0°\nÀ°\0\0 \0 \0\0\0\0\0\0\0 \t\0 \0\0\0\0¬¯üÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ŸßžŸ™ù™É¹ü¿šÚœž\n\0\n\n\n\0 \0\0\0\0\0   \0\0\0\n\0\0\0\0\0\0 \0\0\0\0à\0\nÀ° \0 \n\0\0\0\0\0\0\0\0\0\0\0\0 \nÜÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿßùûÛÙéŸŸÜ¹Ð½½›\tÐœ\0\0\0\0 \0\n\0   \0\0\n\0\0\n\0 \0\0\0\0 \0 \0\0\0š\0\0¬\0\0\0\0\n\0\0\0\0\0 \0\0\0\0\n\0\0\0\0 ïïÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿŸŸ½Ÿ\tÐ°¹Þ½ÚÚÐð° ° \0\0\n\n\0\0\0\0\n\0 \0\0\0\0\0\0\0\0\n\0\0 \0\0\0\0à\0\0\0 \0\0\n\0ÊÊ\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿Ûùù™ùÛ™ÙÐ¹Ú½½¹™ÉÐ\0\0\n\0\0\0\0\0\0 \0\0\0\0\0\0  \0\0\0\0\0\0\0 \0\0\0\0\n\0\0 \0\0\0 \t\0\0\0à°\0\0Ê\0\0\n\0\0\0\nÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿý½ß
©
ÐùÙéðžŸ\n\0\0\0\0  \0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0  \0\0\0\0à \0\n\0\0\0 ¬Ë\n\0\0ë\0\n\0 \0\0\0\0\0\tÏÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿýûÛùý¹Ùùù™ÐŸ\tëŸŸ\t\0™\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0 \0\0\0 \n\0\0°\0\n\0 \0 \n\n\0\nÎ\0 ÀéÀš\n\n\n \0\0¯ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ßýÿŸÛßŸË™Éù­¹ùù\n\n\0 \0\0 \n\0\0\0\0\0\0\0\0\0à \0\0\0\0\0\0\0\0\0\0Ê\0\0\0\0 \0\0\0­©à\0\0 \0 ¬
\0À\0\0\0\nÏÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿýÿÿÛÙùý¹ð¹™Ëœ¹ÛÏð\0\0\0  \0\0\0\0 \0\0\0\0\n\0\0\0\n\0\0 \n\n\n\0\0\0°\0\0\0\0\0\0   \0à\n\0\0\0 \r\0¬\0°  \0©àßÿÿÿÿÿÿÿÿÿÿÿÿÿÿßÿÿÿÿÿý¹½¿Ÿ›\r™Ð™
Ûž½ùŸ\t\n\n\0 \0\0  \0\0\0\0\0\0\0\0\nÚ\0\0 \0\0\0\0\n\0\0à\0\0\0\0\0\0\0\n\n\n\n\0 \0\0\0 ­\0àÀ\t\0 \0\nïÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ÿÿÿûý¿ßÙÙÿýûé¹\r°Ðœ™ËŸù\tž\0\0\0  \0\0 \0\0 \0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0š\0\0 \0\0\0\0\0\0 \0 \0\0\0\0\0\0 š\0 \0 \tÏÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûÿÿýÿÛ™ÿÿÿûßýï°Ù\t\té½­¿ž™é\n\n\0\0\0  \0\0\0\0\0\0\0\n\0¬ \0\0\0 \0 \r\n\0 é\0\n\0\0\n\0\0\n\n\0 \0  \0\0\0\n\r¬\0\0é\0 ¯ÿÿÿÿÿÿÿÿÿÿÿÿÿùùýÿßÿ½½ÿÿÿÿÿÿûßŸ°\0ÛÛùéð\0\0\0 \n\0\0\0\0\0\n\0\0\0\0\0\0\0 \n\0\0\n  \0\0°\0\0\0\0 \0\0\n\n\n\0\0\0\0\n\0\n\0°é\0ÊÐÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûÙÞÿÿÿÿÿùÿùëž™\0\0¼ŸŸ™\r­ \0\0\0 \0 \0\0 \0\0\0\n\0¬  \0\0\0\0\0\n\0Ê\0à\n\0\0   \0\0\n\0\0\0   \0\0\0°°\0°ž°¬¿ÿÿÿÿÿÿÿÿÿÿÿÿûùùûß¯¿ÿ¿ÿ½ÿûÛ›œ™Ë\0\0\0™ééðù\t\0\0\n\0\0 \0\0\0\0\0\0\0\0\0\0À\0\0\0  \0\0ÊÚ Û\0\0\0\0ÊÚ\n\0\0   \0\0\0\n\0\n\n\n\0\nÊÉË\nÏÿÿÿÿÿÿÿÿÿÿÿÿÿûïßûùßÛÿý¿ûû™\r\r\t\0\0\0
ŸŸÛŸ\n\n\0\n\0\n\0\0 \n\0¬ \0\0\n¬\n\0\0\0\0\0¬¬ \0êÊ\0\0\0\0\0\0\0 \0\0     \0\0\0\0\0  \0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿý¹ÿ\tï½ÿ›Ù\rœ½››Ÿ\t\t\t\0Ðù¹Ð\0\0\0\n\0\n\0\0\0\0\0\0\n\n\0\n\0°\0\0\0\0\n\0\nÉ ð\0\0 \0\n\n\0\0\0 \n\n\0\n\0\0\n\0\0\0\0 
\t\0ÿÿÿÿÿÿÿÿÿÿÿÿÿ›ßùŸùùÛÛÛÛœ
ÐÐš™\0
ý©­©\n\0 \0\n\0\0\0 \0   À\0\0ÊÀš\0 \0\0\0 \n\0ëààš\n\0\0 \0\0\0\0\0\n\0\0  \0\n\0\0\0\0\n\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿûý°ù\0\0ŸŸŸŸ½½½½ûùý¹Û›ÙÐÙœ½›ÙÉÊ\0\0\0 \0 \0 \0 \0\0 \0\n\0 \0 Ê\0\0\0\0ü°\0\0\0\0\0 \n\0à\té \0\nš\t\n\0\0°\0°\nÏÿÿÿÿÿÿÿÿÿÿÿÿÿ¹Û™½½ùýùÿÿÿŸ¿™ééÉ­© šÙ°¹\n\0\0\0\0\0\0\0\0\0\n\n\0\n\n\0\n\0êÚ\n\0ð\0\0\0ûÎ°ð  \0\0 \0
à\n\0 °\0\n\0
\0\0\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¹ËÛÿÿÿÿÿÿý½ðûÐûÛŸ¹Û™ùžž›\0\0 \0\0\0\0\0\0\0 \0\n\0\0\0\0\n ð¬\0 \0\0ü°\nœ\0\0\0 ð¬\0°\0\n\0
\0\n\0 \nïÿÿÿÿÿÿÿÿÿÿÿÿûšœ½ÿÿÿÿÿÿùûÿ½¼Ÿœ™éÜ°ÛËËùù©À\0 \0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\nž\t  \0\0\0«\r©­\nÊ\0 \n\0°\0\n\n\té\0\0\n\0
\t\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿ›ßÿÿÿÿÿÿÿýùÛÙ°™éš›©œ™\rœ¹\0\0\n\0\0\0\n\0\0\0\0\0  \n\0\0\0\0\0\0 É\n\0\0\0Þ \0\n°\0\0\0\n\0\0 \0 \0\0à° \0ð \0¬¼ïÿÿÿÿÿÿÿÿÿÿÿÿ½°½
ßÿÿÿÿÿÿ¿¿½­™ \tËÚÛ›ËÙ°¹\r \0\0\n\t\0\0\0\0\0 \0\0\0\0\n\n\0 \n\tÊ\t\n\0\0©\0\0\0\nÊÚ\0 ¬
\0\0\0\0\0\n\nÐ\0\t® \0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿùÿÿÿÿÿÿÿÿßÛÛÛœ™\0ž™\tÐ™ÛÐð\0\0\0\n\0ÊÚ\0\0\0\0\0\0\0\0\0\0\0\n\0ð \0\0\0ð\0 \0©\t \0\0Úð\0\0\0\0\n\tÀ \n\nÉëÊ\0 ¯ïÿÿÿÿÿÿÿÿÿÿÿûß™ùÿÿÿÿÿÿ½¿½½½
\tžŸ›ù\t™\0\n\0  š\0\0\nÀ\0\n\n\0 \n\0\0\0¬\0\0\0\0\0š\0\t\0 \0\0\0¬\n\t \0\0\0 °\n\0\0©\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿûÿ™Ÿÿßÿß½ûÙÛÛûÙé\tž\t\t\tœ½ŸŸ™\t\0\0\0\0\0¬š\n\0\nÚ\t\0\0\n\0\t\0\0\0° \n\0\0àé 
\0\0©\0\0\nÉ \0 \0\0\0\0š\0 íî°\0 ÿÿÿÿÿÿÿÿÿÿÿÿÿý½ù™ùÿ¿ûÿûÙ¹½ÿÛùÛœ™\r©žŸ™ðùÐ°ð \n\n\0\n \0\n\0\0¬  ¬ \t\0 \0\0\0
ž°\0\0
\0\0 \0\t\n\0 \0   ©\0\0 éé \0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿûùðŸ½ýÿùý¿ýÿ½ÿŸ½©­›ÙÉž™í½ž›Ý\0\0 \0\n\0\0  \n\n\0\0\n\t\0\n\0\0\0\n\0¬ š\0\0\nÚ\0\n\0Ïš\0\0\t\0é  \nžÊŸÿÿÿÿÿÿÿÿÿÿÿÿÿûßßŸßûý¿ÿÿÿÿÿùûÛÙÙ¼°š\téŸ›¹ðÙ© \0\0\0\n\n\0\0 \0\0à  Ê\n«É\n\n\nÏð\0\0 \0 \0\0\0\0 ðà\n\n\n
\nÉ\t\0\0 ¼°Êÿÿÿÿÿÿÿÿÿÿÿÿÿÿûûùù©ý¿ßÿÿÿÿÿÿýÿžšÙ¿™ÛðýúÞ«Ð\0\0\0  \0\0 \0\0\0\0À¼œ\0
\tÀ \0\0í®š\0\nË©\0\0
Îÿ\0\0\0 \t   \0\0\nÛ¿ÿÿÿÿÿÿÿÿÿÿÿÿÿýÿŸŸ™¯Ûÿÿÿÿÿÿÿûß½½¼Ùé\r¹ù¹Ù½¹Ü½°\0 \0\n\0\0\0 \0\n\0\n\0\n\nË\0 ¼š\0\0\nÏé\0\r¬ðš\nÀ\t\nœ¯ \n\0°\n\n\0\0\0 \0ý½ÿßÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿŸŸ½ÿÿÿÿÿÿÿÿûÛÚÛ¿™ûÏŸÞ¿ÛÞ›Ú\0 \0\n\0\0  \0 \0\0 š\0Àé\0\0 \0\n°°\n\nË\0 \0\nÉÊÐðœ°Ê\0©\0\0 °ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿŸûÛÛûßÿÿÿÿÿÿûýùùÛÙ\r›Ë›Ý°ù½ð°\0\0 \0 \0\0\0 ©\0\0\n
îð\0\0\0\nÊ\r\0\0 \0\0\n\n
\n°é\0 \0\0­ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿßùûßÿÿÿÿÿÿÿýûÛÉééùûý½ý»ßŸÚŸ\0\0\0\0 \0éé \0\0\0\n\0\0þš\0\0\0\0\0\0½   \0 \n\0\0\0\té­­é ¬ š\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûÿß½ÿŸÿÿÿÿÿÿÿùù¹žŸŸŸÛŸÞŸðý­©\0\0\0\n\0\0\0\0\n\0 \t\0\0\nÀëé \0\0\0\0\0Ê\0\0\0\n\0\r
\n\n\0\0\0  \0
\nÐ\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ß¿ÿÿÿÿÿÿÿùûÛÉùðùé½ðùý¿›Û\0\0\0\n\0\n\n\n\n\0\0\0 \n\0\0šœ\0\0\0 \n°\0 \nÀ °ÉÉ\0   \0\0¬­\nÿÿÿÿÿÛÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿßÿÿßÿÿÿÿÿÿûß½­Ÿ›ÛÛßŸŸ›ÉüšÐ \0\0\0 \0\0\0\0\0\0\0\0\0\n\0\0  \0 \0¬é\0\0\0  \0š\0\t\0\0\n\0 ðúððÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿßûÿÿÿÿÿÿÿÿûÛÛ\tùý½½ðùùý¿™ù­\n\n\0 \n\0\0\t\0 \t\0\n\0°š\0\n\0\0\0\0ú°  àÊ
\n\0 \0é\n\0\0\0îü°ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûÿÿÿÿÿÿÿÿÿŸù½ùð½­ûŸŸž½œúš \n\0\n\0  \0 \n\n\0ééÊÉ \0\0\0  ½\0\0\0ž°\0\t
\0 \0 \0\n\nËË¿ÿÿÿÿûÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿýÿ¿ÿßÿÿÿÿÿÿÿÿÿŸÚžŸŸÛœùùùÛû™ù\tàà\0 \n\0\0\0À°\t\0ž\0\n\t \0 \0\n\0\0ð©  à\0\0\0\n\n\0 \0\n\0¾°éïùÿÿûÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿßÿÿÿÿÿÿÿÿÿÿùð¹ùùù¹û›ÐùúÙÏ\tË
\0\n\0  \0\n
\0¬¼\n\0\0 \n\0\0\0 \0\0 ©\0\0\0\n\t\0\0\0\0\0\0\n\0\0 \0\0\nßÿÿÿùûÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ÿŸÿý¿ÿÿÿÿÿùÿŸ\tééÉ\rœ¹éÙé¹Ú\0\n\0à\0\0©\t\0\0š  \0\0\n\0\0\0\0 \nþšš\n\0\n\0\0\0\0\0\0\0\n\0\n\n\0\0ÿÿùÿ½ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿Ÿý¿ùÿ¿ýÿÿÿÿÿÿùù©ùŸ›Ÿ¹\tš™žž™ù \0 \nÚ\t\n\n
\n\0\0\0\0\0\0\0\0\0\0\n\0¹\t\0\0\0 Úš\0\0\0\0\0\0\0\0\0\0\n\tÿûŸßÛÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿŸùÿùÿÿÿÿÿÿÿÿÿ¼™\t\t\t\r›ÉÚÛÙ¼\0\0\tà  ­\0\t\0š\0\0\0\0\0\0\0\n\0\0\nð \0\0 \r¬\r\0\0\0\0\0\0\n\n\0\n\0ÿŸ¿¿Ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûß¹ù½¿ŸÿûÿÿÿÿÿûÛÙ°¹Ð¼¼™­
É© Ê\0\0\0Ú°©¬­¬ \n\0\0\0\0\0\0\0\0  ©\t \0\0 © °\0 \0\0\0\0\0\n\0\0ÿ›ÝÿßÿÿÿŸÿÿÿÿÿÿÿÿÿÿÿÿÿûÛËÛÉùùýÿÿÿÿÿÿ½°ÙÐ¹\t½™½™­°½°Ð
 \n\0\n\0ËÊÚÚ\0\0\0\0\0\n\0\0 \0\0\0Ú\0\0\0\0\0\0\0\0 \0\n\0\0\0\0\0\0 ÿù¯ŸÿÿûÿðÿÿÿÿÿÿÿÿÿÿÿûÛ½¹\t¹Ÿ¿ûÛÿÿÿÿÛÛ\0\tð™éËÐš™É\tÛ\0 Ë\0\n\0 \0¬¬  \0\0\0\0\0\0\0\0 \0 ©\0\0\0\0 \n\0\0\n\0\0\0  \0\n\0ÿ¹Ùù½ÿûÛ\tßÿÿÿÿÿÿÿÿÿÿÿÿûùùùÉ¹\tÉýÿÿÿÿûÿ™©™ð™¹
ÙË\tðÐðÏ¬ \0\0\0    \0\0 \0\0\0 \0\0\0\0\0\0ð\n\0\0\0\0\0\0\0\n\0\0\0\0\0© ÿÿ›ÿ½¹éïÿÿÿÿÿÿÿÿûÿùÿŸŸÛŸ›Ð™›Ÿ¿ßÿÿýù\tðÉíŸžœ½°Û\té
\n\n\0\n\0\0\0\0\0\0\0 \0\0\0\0\n\0\0\0\0\0\0\n\t\n\0\0\0\n\n\n\0\n\0\0\0  \0ÉËÿÿ»œ¹ùÿß›\tÿÿÿÿÿÿÿÿÿÿùÿ¿ÿÿ¿ùù›Ÿ\tËÛÿÿÿÿ¿\t™é™\0\t\t\0Ðžœ\0\0\n\0\0\0 \n\0 \0\0  \0\n\0\0\n\n\n\0 \0° \0\0\0\0\0\0\0 \0\0\0 \0\n\n\nùÿý¹ðŸ¿\t\0ßÿÿÿÿÿÿÿÿÿÿÿÿÿýùéËÉ\t½½ÿÿÿùùù\0\n™\0\0\0\0\0\0°\t\t  \0\0 \0\0\0\0\0 \0\0\n\0\0\0\n\0\0\0\0\0 é\0\0\0\0    \0 \n\0\0 \0\0\0¿ÿÿŸ™™ùùœÿÿÿÿÿÿÿÿÿùÿÿýÿÿùùù¹ù©žŸŸÿÿÿú\t\r\0\0\0\0\0\0\0É\t\tù\0\0\0\0\0\0  \0\0\0\0\0\0\0\0\0\n\0\0\n\n\n\0\0°\0 \0\0\0\0\0\n\n\0 \0\0\0 \n\rûÝÿÿÿ™ÿœ©\nßÿÿÿÿÿÿÿ¿Ÿÿùÿ½¹Ðœ¹ùÿÿÿÿ\0\0\0\0\0À°\r\0\0\0\n\0\n\n\0\0\0\0\n\0 \0\n\0 \0\0\n\0\0\0\n\0 \0\0\0\0\0\0  \0 \0  \0\0\0 í¿ÿÿÿû¹\r¿ÿÿÿÿÿÿ¿Ÿû™›\0\0\0\0\0\t\t\rÿÿÿùû\t\0\0\0\0\t\té\t\t
›\0\0\0\n\0\0\n\n\0\0\0é\n\0\0\0\0 \0   \0\0Ú\0\0\0\0\0 \0\n\0\0\0\0\0\0\0ÿßÿÿûùé\0\t\0ßÿÿÿÿÿÿßùý¾½\t\0\0\0\0\t
\t
™ýÿÿÿŸž\0\té\t­¼¹\t\0ÐÀ\0\0\0  \0\0\0\0\0\n\0 \0\0\0\0\0\0\0\n\0\0 \0\0\0\0\0\0\n\0\0\0  \0\0\0\0\0éùÿÿ°\t\t\0\rÿÿÿÿÿÿ¿ÿûÙûÛûÐ
\0¼™Ï¿ÿÿÿù™\t\t\0\tËÉ\t\0›Ë\t¹\0\0\0\0\0\n\n\0\0\n\n\n\n\0  \0\n\0  \0\n\0\0\0\0\0\0\0\0\0\n\n\n\0\0\0\0\0\0\nßŸÛû\r\t\0\0\0šÿÿÿÿÿÿÿÿŸŸûœÿßÿ¹ÐÙ\t\t\téûß¿ÿÛš\t\0\t\t\t\tÊÀ\t\tÀ\0\0\0\n\0 \0\0\0\0\0 \0\0\0\0\n\0\0\0\0 \0\nð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ûßÿÙ\0\0\0\0ßÿÿÿÿÿÿÿÿÿùù™ùŸß¹©\t\t½¿ßŸ¿ÛÙ\0\t¬°™™Ú\t\0\0\0\0 \0 \0\n\0\0 \0\0\n\0\0\0\0\0  \n\n\0 \0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0¹Ûð™\0\t\0\0\t¯ÿÿÿÿÿÿÿÿùÿ¿šŸ
\tÉ\t™¿žŸ¿ùùŸù­¹\0\t\t\tÛËÊÛ\t\0\0\0\0\n\0\0 \0\0 \n\n\n\0\n\n\0\n\0\0\0\0\0 ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ùÛù™à\t©\0\0šßÿÿÿÿÿÿÿÿÿùÿýùùù°¼¹­\tùùùÿðŸ™\r©\0\0\0\t\t™\0\0\0\0\0\0\0\n\0\0\0 \0\0\0\0\0\0\0\0\n\n\n\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0é½œž™ù\0\0\0ßÿÿÿÿÿÿÿýÿÿý¿¿ŸŸÛÚ™ÐŸ
ŸùÿŸùðù\0\0\0\0\0\0\t\0\0\0\0\0\0\0\n\0 \0¬   \n\0\0\0\0\0\0\0\n\0  \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ßž›Ûßž™\0\0\0\t¯ÿÿÿÿÿÿÿûûßÿýýûÚ\0\tÙÛÉÿùÿžŸŸ\r­\0\0\0\0\0\0\0\0Ë\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\n\n\0 \n\n\0 Ê°\0\0 \0\0\0\0\0\0\0\0\0\0\n\0\0\0™ß¿™\0\t\0\0\0Ùÿÿÿÿÿÿÿÿß­½û°\t\0\t\t\r©é¿Ÿß½ùý­°™©\0\0\0\0\0\t\t\0\0\0\0\0\0\0\n\n\n\n\n\0\0\0\0\0\0\0\0\0\0\0\0Ê\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0½ïûÙ\0\0\0\0\0ÿÿÿÿÿÿÿÿùÛÚ\t\0\t\0\0\0Ÿùýýÿ¿ß¿ûÛý½­\tÉ\0\0\0Àœ\0\0\0\0\0\0\0\0 \0\0\0\0\0 \0\n\n\0\n\n\0    \0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0™™\0\0\0\0\tÏÿÿÿÿÿÿÿÿ¹\t\0ž\tÀð¼žŸÿÿŸÿûýý¿ß½½
ðùý°Ðùà›\n\0\0\0\0\0\0\0\0\0\0\0°\0\0  \0\0\0\0\n\0\0\0ž\0 \0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\tÿÿÿÿÿÿÿÿÿÿßŸ™Û½ŸÛÛßŸŸýÿý¿¿ûýÿÿÿÛß
É©\0\0É\0\0\0\0\0\0\0\0\0\n\0 \0 \0\0\n\n\n\0\n\0\n\n\0©\0\0  \0 \0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ÿÿÿÿÿÿÿÿÿÿÿÿÿýÿÿÿÿÿÿÿ¿ùÿÿÿßûýùùý­ù½™ù
\0\0\0\0\0\0\0\0\0\0\0\0 \0© \0\0\0\n\0 \0\0\0ê\n\0\0\0\n\0\0  \0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\t\0\0\0\r¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿýÿÿÿßÛÿßûÿÿûÛœšžÉ\t\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\n\0\0   \0\0\0  \0°\0\n\0\0 \0 \0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ÿÿÿßùý½½\t½\t\0°\0\0\0\0\0\0\0\0\0\0\0\0\n\n\0\0 \0\0\0\0\0 \0\0 à\n\0  \0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿßùÿßÿÿÿûÛ\tð\0°\0\0\0\0\0\0\0\0\0\0\n\0\t  \0   \0\0\0 \0\0š\0\0\0\0  \n\n\0\0\0\0°\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\tËßÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ûÿŸÿ°™\t É\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\n\0\0\0\0 \0\0\0\0\0à\0 \n\n\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿß¿ÿŸýýÿÿ™°ž¹\0\t\0\0\0\0\0\0\0\0\0\0\0\0 \n\n\0\n\n\n\0\0\n\0\0\0\0°\0\0\0\0\0 \0\0\n\n\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0¼ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿßÿÿ¿ýûŸ\rŸ™\r©\0\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\n\0\0\0\0\0\0\n\0\0   \0  \0\0š
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ùÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ÿßÿ¿\t›\t©\tÐ™\0š\0\0\0\0\0\0\0\0\0\0\0\0\n\0  \n\0 \0\n\0\0\n\0 ð\0 \0\0\0\0\0\0¬ \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0É\nÙÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿýÿ¿ýÿ»\0Ðš™é\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0 \0 \0\0 \0\0\0\n\0\0\0\0\n\0\0\0\0  \0\0\0\r\0\t\0\0\0\0\0\0\0\0\0\0\0š¾ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÛÿ¿ßûùÙ\r¹Û¼š\t\t\t\0\0\0\0\0\0\0\0\0\0\0\0  \n\0\n\0\n\0\0 \0\0\0àð\0\n\n\n\0\0\n\0\n\n\t\0\0\0\t\0\t\0\0\0\0\0\0\0\0\0\t\tÚÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ÿýÿûýù Ûœ¹\0Ù\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \n\0\0 \0\0\n\n«\0\0\0\0\0\n\0\n\0\0\n\t\0\0\t\0\0\0\0\0\0\0\0\0\0\0žžëÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿùýÿ¹¼›Ú™©\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \n\n\n\0\0\0\0\0 \0\0\nÊ\n\0\0\0\0\0\0\0\n\n\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\t\t©­ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûÛð
Ûð™\0ù\0\t\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\n\0 \n\0\0\0\n\0°\0\n\n\n\0 \n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0ðÙïßÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿßùÿÿÿ™ÙðŸœ¹\t­\t\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\n\né\0\0\0Ê\0 \0\0 \0\0\0\0\0\0\0\0
\n\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÚÙ\t½¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûÿûÛùžž™ù©ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0àÏ\0\n\tà°\0\0 \nð\0\0\0\0\0\0\0\n\0\t\0\t\0\0\0\0\0\0\t\0\0\0\0\t\0\0\0\t\0°ðÞßÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿßÿŸ\t›Úœ\t \0\0\0\0\0\0\0\0\0\0\0\0\t\n\0 
àú\t \0\0\0\n\0\0\0\0\0\n\n\0 \n\0 \0\0\0\0\t\0\0\0\0\0\0\0\0\0
\tÉŸ½ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûûßù°Ð½¹½©\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Àð\0\0\r©¬¼ \n\0\0\0ð\0\n\0 \0\0\0\n\0 \n\0\0\0\t\0\0\0\0\0\0\0\0\0\0ÐšÐýÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿýÿûßœŸœœšÉ\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0¬   ðê\0\n\nš\0\n\n\0 \0\0\0\0\0 \n\0\n\t \0\0\0\0\0\0\0\0\0\0\0\0\0À\0ûÏÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿý¿ý½û
šÛÛ›\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÊËàÀ\n\0 \0\0\0 \0\n\n\0\0\0\0\0\0 \0\nÊ\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\tÉðÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ÿ½Ù\t\t\r©\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0©àüà°¬  \0\0  \0\n\0ê\0\n\n\n\0\n\0\0\0\0©\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0Ë\rÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿýý½ûù­¼¹œ°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 ©®Ë\0\0 \0\0\n\0\0\0°\0\0\0\0\0\0\0\0\0  \0\0\0\0\t\t\0\0\0\0\0\0\0\0\0\0\0\t\0Úýÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ÿûûßŸ™œ©\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0 Îé \n\n\n\0\n\n\t\n\t\n\0\n\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\t\0\r¯ÚÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÛýýðù\r¼©\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0À¬ªš\n\0¬\0\0\0\0À©\n\0à\0\0\n\0\n\0\0\0\0\0\0 \0\0\0\0\0\0\t\0\0\0\0\0\t\t\0\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿýÿÿÿ¿Ÿ½¹\t©\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0  \0\0\0\0 \nš\t \nžš\0 °\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0Êßÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿½½ûý½ðù\t°\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0Îš\0¼  \n \0\0 éé\0Ê\0\0\0\n\0\0\0\n\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0½¯ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ýÿÿ½›Û\tœ\t\0\t\0\0\0\t\0\0\0\0\0\0\0\0\0\0\t ¬\n\0\0\0 \n\nÊÊÚš\n \0 \t\n\0\0\0\n\0\n\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0Ðýÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿùûß¯Ÿ
\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\t  ©\n\0 ­
\0\nË\n\0°\0\0\0ª\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0­ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ½ÿùÿý¹Ù™\tÙ\t\t\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0 à\0\0\n\0 \0\0¬š\tœš\nÊ\0\0 \0é\0\0\0\0\0\0 \t\0\0\0\t\0\0\0\0\0\0\0\0\0\0\t\0žßÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿùÿ½¿ÿ¿ùð°\0\0\0\0\0\t\0\0\0\t\0\0\0\0\0\0
\n \0©\n\n\0\nÀ \0 \0°\0\0\0¬\n\0\0\0\0\n\0\0\n\0\0\t\t\t\t\0\0\0\0\0\0\0\0\0\t\rëÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿŸùéðš™­\t\0\0\t\0\0\0\0\0\0\0\0\0\0\0\t\0àÀ\n\0àÊ\0\0\0 
\0àé  \0 \0\nÀ \n\0\n\0\n\0\0\0\0\0¼À\0\0\0\0\0\t\n­½ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûÿÿ½½ÿŸŸ½\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¬©¬
\0 \0 \n\t¬\nÚÚ\0\0à\0 \0\nš\0\n\n\n\0\0\0\0\0\t\t\0\0\0\0\0\0\0\0œßÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿýÿßÿûÛùù©\tË\t\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0œš\0\0¬®\t \0\tÊ\0¬¬ é °\0\0 \0 À \0\0  \0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¼Ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿Ÿ½½¾ŸŸ›\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0š\0\0\tà\t ¬
Ë\0\0à    \0 \0  \0\0\0\0\0\0À\0\0\t\0\0\0\0\0\0\t
ŸÿÛÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÛËÙ\t\0\0\t\t\0\tÀ\0\0\0\0\0\0\0\0\t
\n\n\0

\0\n©
\nœ \nË \0\n\0\0\0\0 \0\0\0\0\0\0\0\0Ê\0\0\t\0\0\0\0\0\0\0
žŸÿÿÿÿÿÿÿÿÿÿÿÿûÿÿÿùý°½¹\t©\t\0\0\0\0\0\0
\0\0\0\0\0\0\0\0\0\0\0\n\0\0°\0­
¬\0Ê\n ž\nÚ\0\nš\n\0\0\0\0 \n\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0ÉùÿßÿÿÿÿÿÿÿÿÿÿÿÿÿŸÿ¿Ÿ\0\t\0\0\t\t\0\t\t\0\r©Ë\0\0\0\0\0\0œ\n\n\n\0°àÊ\0à\nÚ\0\0©\n©\0 \nÀ\0\0\n\0\n\0\0\0\t\t\0\0\0\t\t\t\0\0\0\0\0\0\0\0\0\0ÛÛÿÿÿÿÿÿÿÿÿÿÿÿý¿ûÛÙùù
\0\t\t\0\t\0\0\0\0\t\0\0\0\t\0\0\0\0\0\0\n\0À©¬\0à\0­®Ð­©©\n\0à \0 \n\n\0 
\0\0\0\0Ê\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\t\0¼½ùûýÿÿÿÿÿÿÿ¿½ûý­¼ú™\tÐ™\0\0\t\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0°ÊË
à\t ®Ê¬¬ °\0 \0\0\0\0\0à\0\0\0\n\tž\t\0\0\0\0\0\0\0\0\0\0\0\0\r\0©É¼¿ÿÿÿÿÿÿÿÿÿßÿ¿Ûùù™ÚÙ©\0\t\0\0\0\t\t\0\0\0\0\t\0\t\0\0\0\0\0éàú\nàààé\0í­Àê\t\0à\0\0\0 \0\0 \0 \0\0\t\té\0\0\0\t\t\0\0\0\0\0\0\0¼Ÿ\rŸŸŸ¿ÿûÿ½ûùùù½Ÿ
Ë\t°\t\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\t\0\0\t\n\nžííêžš\0¬\nÊ®à š\0\0 \0\0\0\0 \0\0\0\0©ìð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tšÐûýùðý¹û\r¿žŸ›\t™\t\t\0\0\0\0\0\t\0\0\0\0\t\t\0\0\0\0\0\0\0œ\0à®ºœ©àðà°©ÊÊÌÚì\nÀà\0\0\0\0\0\0\0\0\0\0\n\0\0\té\0Ð\0\t\0\0\0\0\0\0\0\t\0œ
Ð­
ÐšžŸ›Ëœ¹\t™\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t
\t¬ËÌï à\0Ê\0¬ª¬\n¼\nš\0\0\0\0\0\0 \0\0\n\n\nž\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\t­™\t\0\t\0\0\0\t\0\t\0\t\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\t\0\0\nœ\t ¬êðªÞÚð\0¬Ì¬ÀàÀ¬ \0\0\0\0\0\0\0\0\0\0\0\0\0\t\té\r\0\0\0\0\0\0\t\0\0\0\0\t\t\0\0\0\t\t\0\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\t\tÉËËÊËÏœ¬¬\n\0àºÀ®\0ð \0\0\0\0\0\0\n\0\0\n\0\0 \0žšš\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\t\0\t\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0°œ¬°¬®þ­ëëÊ\0àìÊàÉ  à \0\0\0\0\0\0\0\0\0 °š\0\0 œ\t\r\rœ©\t\0\0\0\0\0\0\0\0\0\0\t\0\t\0\t\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t©Ê\0©\r\r­ëÊžíéêÎ\0éÎ\n ÀÀ\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°Úš\0œ\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°š\0ðÐàúþýë\0à­¬à¬   ð\0\0\0\0\0\0\0\0 \n\0 \nÚ\r\rŸ\t­\0\t\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\tË\0\0\t\r\t
\r\t\tï®®Îí®¼à\nÊÊ\0 \0\0\0\n\0\0\0\0\0\0\0 \0 \0\0\0\0 \r°ð\tš\t\0\0\0\0\0\0\t\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\t\0\0\0\0\t\0\0\0\t­\t
š\0ÚÚðï¯üëÊÊÞ¬¬¼\nÊ\0\0ð\0\0\0\0\0\0\0\0\n\0\0\0\n\n\nœ°\r\r°ù\r©\0\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tš\0\0\0\0\0°°ÐÐ\0í¯ì®¼þïþž ì¬\nÀ¬\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\n\0ÛËÍ\0\t°\0š\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\t\0\0\0\0\0\t\0\0\0\0\t\0ð\t\t\t\0\0\0°éÉ©©\nÚÚîÎþÿ¬¬Ê\n\n\0\0 \0\0\0\0\0\0\n\0\0\n\0\0\0 \n\0\0\0œ°ùÐÉ\tÉ\r\0\0\t\0\0\0\0\t\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\t\0š\0\0\0Ðœ\tšÐ\n\0¬¬éêÏ¯ïþÿ©àà Ú\0\0\0\0\0š\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\nššÙ›\t\r Ú\t\0\0\0\0\t\0\0\0\0\0\t\tÀ\t\0À\0\0œ\0\0\0\t\0\0\0\0\0\r\0Ð\0°\0\t¼\r­­\0\0ÊþÿïÊž¬   \n\0à\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\t\r­¹àÐÚú©\0\0\0\t\0\t\0\0\0\0\0\0\0\0œ\0°\0\0\0\0\0\0\0\n\t
\0\0À\t
\t°à Ê\tààéàïïþþž\0àà\n\0\0À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\n\nÊÐœ°ùÉÚ\0\t\0\0\t\0\0\0\t\0É\t \t\t\t\0\0\0š\tÀ\0\0\0\0šÐ
\0\t\0\0ËŸ\tÏ\0žÎ¬¯ìÿïéà\0\0à\n\0 \nÀ °\0\0\0\0\0\0\0 \0\0\0\0\0\0\n\0\0\0\t
Ë\rž›\tËË\0\0\0ð\t\0\0\0š Ð\0\0 œ\t\r\t\0\t\0\0\0\0\0\0\r\t\0\t\0\t\0Ûœœ ðàà°ËÀààþïÿþ¼  à\0\0\0\0\0\0à\0 \0\0\0\n\0\n\n\0\n\0\0\0\0\0 ° \0œðÉé\0Ð\0\0\0\tÉ\t\0\0\tÉ\té\t\r\t\t\0\0\0\0\0\t\0\0\t
\0\0
\r»
ÉÊÊÚž¬­¬­ïïþÚÀÀ\n\n\0 \n\0 \0° \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0à°ùÉË\t\t\0Ðšš\0\0
\0ðžž
\t\n\t\0\t\t\0ðÛ\t\0\n\tððÐÐ¬¼¬àððËÊÊîþÿí   \0\0\0\0 \0  \0\0\n\0\0 \n\0 \n\0\0\0\0\0 ­ °\r\0ùùËËššÀ\t ÉÉ\0\t\0\0ÉÏ\r\nÐš\0É \0\0žž\t\tð\0\tÉÛ\t›\t© žž¬Þÿïþ­\0¬\0à\0\n\0Àð\0\n\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n°½š\r\tÉ\t\0\t
›\0À\0\t\t©šÙ\t\t\n\t\t\r\t\tùð
\0\0š¼žœ°ÊÀ¬¼¬¼­¬¼¯ïþûÀ  \0 \0 ¬\0  \n\n\0\0\0\n\n\0\0  ° \n\n\0\0   \0ÉË›Íéà°Úœ°œšÐÐÉÐ©\t\t\0ðÐé\t\0\t\0\t
ËÐ™\0©\t\r½
ùËË\t¬ðêÊÊÊÀ\nÊþÿïï \0 \0\n\0À\0ð\0\0   \0\0 \0\0\0\0\0\0\0 \0\0Ðð° Ð¹Ÿ™É­\nË\r\t©¼»Ð
žŸ\t©\té\tÚÙ\t\0\t\0¹É¹é Ù\tÐûÛ\nž\r ÊÊ¼­¬­ ¬íïþÿ\0  \0à \0\n\0\n \0 \0\0\0 \0\0 \n\0 \0\0\0
Ê\n\nÀ
ÚÞžšÙ©ÐÐ°\rËœðÙé\0Ðž½©\nÐð\tÀ¹­œšÝºÛœÙð¼¼ºÉêÐìºÊ\n\n®ÿïþž\0 \0 \0Ê\0\n\0š\0\0\n\0\n\0\0\0 \n\0\0\0\0 \n\0\r©\0
\0é­¹ûÙ Ð
Ë\t\r
ù­™ Ÿ›É\0\t\n
ÞŸ™\t\r°›ËÚ
ÙšÙ\r¹
Ú\r®¯\nÌ¬ \r  Ïïÿëà àÀ \0\n\0\n\0à\0\0\0\n\0\n\0 \0\0\0\0\0\0\0¬¬š©\0ðéÉ¼™­ œ›šÉß\tÉ­°œ™À™©éÚÛÉœ¼¹­°Ú¹ùðúàÊðÊÀ \0Ú\n\0\0\nþÿþÚÀ\n\0 \0\nÀ\0 š\0\0\0\0\0\0\n\0   \0\0\n\0©\0š\0\0\0 \0°Ëœ©Ùžð½šÛÉ \0œ\0¹Ë¼›Ë
ËÛ\r›Ë™Ëž\tà¬Ê¬
ÊÊ\0\0\n\0Àéïþÿ­ à\n\n\0à\0\0 \0 \0\n\0   \0\0\0\0\0\0\n\t\n\0\0     \0š\n\0°Ùœ¹\tÉé\t­©éé\tÐ­œ›\r\té\0°\tÉ¼¹ß›ËÛí½¼°­¬¼ž°êÀ Ð¬\t\0\nÊ\0\n\nÎþÿúÊÀ\0¬\0\0\0Ê\nÀ à\0\0\0\0\0 \0 \0\0\0\0Ê\t\0 \0\0\0\n\n\0\0\0\0©\nÐ°š\rœœ­›
œ°\r½\t©Ë\0°ù©í½©ššššÚ
¬œ
À®\n\n\0\0\nÀ¾ÿÿïð¬ \0\n\n\0\0\0\0š\0\0 © \0\0 \0 é\0\0\0à \0\0\n\n\0\0\0\n\0\n\0©\r\r\r\t©\t©Ë\té\0Àœ©\t\t\0\t­\tÐ\rÙù¼¹Û\r°Ú\nÜºðàà¬\0œ\0\0\n\0À\n\0Îïïþž\n\0\0  \n\0à\n\0É\0\0 \0\0\0\0\0 \n
\t\0\0 \0\0\n\0  \n\0\0©šš¼ðÐ½ù¹\t\r­\0ÚÛ\t¹Ûù¯›ÚšÚ©ð°ù«ÀÊÚ\0Ë\n\n\n\0\n\n\0\nÊÿÿïàÊ\0\0\n\n\0 Î\0\n\n\0 \0\0\0\0\0°\0\0\n\0 \0  \0\0\0\0\0\0\n\nšÜœ\0¼™\nÐ½ÀðÚ­é\tœ¿ËÉéËÙý­©
Û©í ì¬ ð \0\0\0À\0\0\0àïÿïþ°¬ ¬ \0\n\n\nà©\0\0 \0\n\0\0\0 \n\0\nš\0\0\0\0\0\0 \n\n \0\0ÐÎ\tÉ©©\t\0ÊÝžÚÐù½\réÐžœ©É½¿Ÿùï
Ûž°¼¾¼¾šÏ\nàšÀ¬\nÊ\n\n\0\n \0ÎïÿÿÎ\0À\0\nÀÀìàþê\n\n\0\0\0\0\0\0\0\0\0\0\0\0š\0\0\0\0\0\0\0à\n\0  ©à­ð\nÛËûÚÚÙðÚŸŸÛ\té¿™ý¬¹éë
ËÊÚÉ\0¼
\0\0\0\0\0\n\0 \n\nïþü½   \n\0¬®žþï°\0\n\0 \0\n\0\0
\n\0\0\n\0\n\0 \n\0\0\0¬
É\n\0\0ð­\n\t\r­Ïù\r¼œ­ŸžŸ½ð¼ð¼ùßŸ\t\nÛàº­ ž°ªÉ¬\n\n\n\0¬ \0\0\0ÀîÿÿûêÊÀÀ ÊÊÏïïÿÀ\n\n\0\0\0\n\0\n\0 \0\0  \0\0\0\0\0\0\0\nÀ¾\n\0\0\n\0ð©\0àËË©\téé
™©ëÛÉ©ÛÛß™­¹©\té­°
\r°©àëœ\n\0 \0 \0\0\0Ê\n\0 \nÏïïþð\n\nÎ¼þÿïÿþ¾\0\0\0\0\n\0\0\0\0\0\0\0\0\t\n\0\0\0\n\n\0šÀ \n\0 \0 \t °Ðð›ÚÛ­¿œ¼¼¹ÿÛËÚÚšÚÎ¼ºË\nÚ
°\nà\r \n\0\0\n\0\0 Ê®ÿÿÿ\0ààì¼îþþþþÿ

\n\0 \0\n\n\r  \0\0\0\0\0\n\n\0\0\0\0\0\0° \0\0\0 °\t \0\n\0\n\0É\t\0žœ¿›ÛÚ\tï¼°ûË\t©ËÉ ð°Ë\0à
\0\n\n\0 \n\0 \0À\0\nÏïÿïþžžïþÿÿÿÿï¼\0\0\0\0\n\0\n\0\0 \0\0\n\0\0\0 \0  À\0 ¼ 
\0\0 \0 \0
\t\t
\n\0\tà°›\téé©úšÛÏ¼¼¾žþ¾ž¿ûûÿ¾š¬\n\0\0À¬\0À   ¼ÿÿÿ¬¼îïþÿþþÿïÿà   \n\0\0 ¼
\0\0\0\n\0 \0\0\0  \0 ©À\0¬°\0\0\0  \0  \t\nš\tÀà

Ë\t¼¾ûûûùï­­¿ÿÿÿÿûš\n\0 \0   \0  \0\0 îþÿïïîÿÿïïïÿþÿï°\0\0\0\0 \0\n\0\0\0\0\0\0°\0 \0\0\0\0° \0   ššš\0\0\0 \0\n\0\0\n

ÊÚÚ¼ºËûÿÿÿ¿½þþÿÿÿÿÿÿù© \0À\0 \0\n\nÀ ÿïÿþÿïïÿÿÿþÿÿÿË\n\nš\0 \0\0\0\n\n\0 \n\0\0°\t \0\0\0\0š\n\0\0ÐÚÀé\0\0š\t \0 
\0  àð°°¼°\t­ÿÿÿÿÿúü¿ÿÿÿÿÿÿ¿©\n\0
\n\n\0à\0 \0àîÿÿÿïïÿþÿïþÿþþÿð \0\0
\0  \n\0\0\0\0ÊÊ\0 \0 \n\n\0\0\0\n\n\n °\0é \0\0\0  \0\0àš\nÚðû
žºÿÿÿÿÿÿÿïÿÿÿÿÿÿù ¬
\0\0\n\n\0  \0à¼ïïÿÿÿÿïÿþÿïÿïÿë \t \0 \0\0\0\0\n\0\n\0\0 °ÊÚ\0\0\0\n\0
\0ÉÉ\nš\0 \n\t\0 \0\n\n¬Ÿ
¼½«ßûÿÿÿ¿ÿúÿÿÿÿÿÿÿºœ \n\0  \n\0Îÿÿÿïïïÿïÿÿÿþ¿¬¼ð \0 \0\n\0\0 \0\n\0\0 ÐÊ\r \0\0\0\0\n\0\nÊ\n\n\0\0 ©\0 ¼ \n\n\0\0©\t °¾›ëÚûÿÿûÿÿ¿ïŸ¿ÿÿÿÿù  \0 \0\n\0ÊÊðþÿþÿÿÿÿÿïÿïïï¯ÌúÊ©\0 \0 \0\n\0\0°\0\0 \0 \n\0
\0\n\n\0\0\0 \0\0°\0\0À \0\0\0ž\t\0\0°­\n\nœ­
éûÿžŸ¿¿¿¿ÿÿúûûÿÿÿÿ¾ \n\0à¬¼îÿïÿÿÿÿÿïÿïÿþúÚº\0\0ð \0\0\0 \0\0\0\0\0
\0\n\0 ©\n\0\n\0\0\0\n\nœ °°\0  \n\0 
\n\0š\n\n°©\0\nš½¿ÿ¿¿¿¿ÿûûÿïì¼¿ÿÿÿÿ¹ ° \r \0\0žÏïÿïÿïÿÿÿïÿïÿêð¼¬\n \0\n\n\0\0\0\n\n\0 \0\0\0\0\0\0\0\t\0\n
\0\0\n\0\0\0 \t\0©\t\t\0\t\0 \0
\t\0\nÚûûûÿÿÿ¿¿ÿþÿ
ûÿÿÿÿÿ¼°À \tžéîþþþÿïÿïÿÿÿ¾ÿì¯\0à\0  ð\n\0\0 \0 \0\0\0\nÊ
\0 \0\0\n\0 \0\0\0© ©©  \0¬©\0    ©\nš\n\0\nš
š¿ÿÿÿ¿ûûûûûÿþý¯ûÿÿÿÿ©\0 ©\nàààþÿÿÿÿÿþÿÿÿÿïï¬«Àê\nÀÊÊ
\0\n\0\0 \0\0\t\0\0\0\0\0 \n\0\0\0š\0\0\0\0\0\0\0\n\0\0\0\0\t\0\n\0\0\t\n\t\0éàéûÿ¿¿ûÿÿÿÿÿÿûëðÿÿÿÿÿ¿
\r\nÉžÿïïïþÿïÿÿÿÿÿþðúÀ \0À¬¬¬ð    \0\0        \0\0\0   \0      ° °°°°°°© °© ©\n›¹¿ÿÿÿÿÿûûûûûÿïü¿¿ÿÿÿÿð°à­®ïïïÿÿÿÿþÿïïÿÿÿéî\nÊ \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0©ûÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿëûÿÿÿÿÿ¹¬¼þÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿþààààààààà \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0p­þ','Robert King served in the Peace Corps and traveled extensively before completing his degree in English at the University of Michigan in 1992, the year he joined the company.  After completing a course entitled \"Selling in Europe,\" he was transferred to the London office in March 1993.',5,'http://accweb/emmployees/davolio.bmp'),
  (8,'Callahan','Laura','Inside Sales Coordinator','Ms.','1958-01-09','1994-03-05','4726 - 11th Ave. N.E.','Seattle','WA','98105','USA','(206) 555-1189','2344','/\0\0\0\0\r\0\0\0!\0ÿÿÿÿBitmap Image\0Paint.Picture\0\0\0\0\0\0 \0\0\0PBrush\0\0\0\0\0\0\0\0\0 T\0\0BMT\0\0\0\0\0\0v\0\0\0(\0\0\0À\0\0\0ß\0\0\0\0\0\0\0\0\0 S\0\0Î\0\0Ø\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0€\0\0€\0\0\0€€\0€\0\0\0€\0€\0€€\0\0ÀÀÀ\0€€€\0\0\0ÿ\0\0ÿ\0\0\0ÿÿ\0ÿ\0\0\0ÿ\0ÿ\0ÿÿ\0\0ÿÿÿ\0ð\t\0\0\0\0\0\0\t\t°\0\t\0\0\0\0\0\0›ûÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÐ\0œÀùé¾\0\0\0\0Ð\t\0\0\0\0\0\0\0\0°\0\0\0\t\0\0ð\tÍ\0\0\0\t\0\0\0\0ßÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
\r\t\0žŸÉ\0\t\0¿©\0\0\0\0\0\t\t\0\0\0Ð
\0\0\0\0\0\0\0\0›\0\0\0\0\t\t\0\0\t\t¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÐ
\0\0žž\t\0\t\0ùßÿð\0\0\t\0\0\t\0°\0\0\0\0\0\tð\0\0ð\0\0\t\0\0\t\0\0\0¿ÿÿûÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿé¬\0\t\t\0\tž\0Ðÿþ\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0ž\t\0\0\0\t\t\0\0œ›ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿð\t\0\0\0\0\t\0\0Ÿ\0\t\t\tí\0\0\0\t\0\0\0\0\0\0\0\0\tà\0Ÿ\0\0\0\0\0\0\t\téÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûûÿÿÿÿÿÿÐ\t\t\t\t\t\0\t\0¼\0\t½©\0\0\0\0\0¾ÿà\0\0\0\0\0\0\0\0\t\t \0\0\t\0\0\0¿ÿûÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ÿË¿\0\0\0\0\0\0\0Ÿà\0\0\0ü\0\t\0ûÐ°\0\0\0\0\0\0\0\0\0\tžÐ\0\t\0\0\0Ÿ\0\0›ûÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûÿÉð\0\0\t\t\0\0\0\tž\0\0\0°\t\0\0
ü\0Ð\0\0\0\t\t \0\0\0\0\t\0\0\0\0\0\0
ð\t­ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿýÿ¿ÿÿÿÿÿžŸù\0\0\0\t\0\t½
\t\tÉ\0\0\0\t\0°\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\t\0\0›ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûÿÿûÿÿÿÿðŸ\0\t\0\t\0\0\0\0\0¼\0 \t\t\0\0\tð\0ð\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\t\0\0Ÿ\0žûÿûÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÛÿïÿÿ\0\0\0\t\0\0\0\0\t\r¯ÛÐ\0\t\0Ÿà\0\0\0\0\0\t\0\t\0\0\0\0\0\0\0\0\0\0\0ü›ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûÿ½ûÿÿûÿÿÿð\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\t\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\tÿ¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿßÿÿûÿÿÿÿÿÿ\t\t\t\t\0\0\0\0\0\0\t\0\t\0\t\0\0\0\0\0°\t\0\0\0\0\t\0\n\0\0\0\0\0\0\0\0ð\0\t\0\t\0¿ÿÿÿ¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ÿûÿ¿ßÿß¿ûÿÿ\0\0\0\0\0\0\0\0\t\0\0\0\0\0›ð\tð\0\0\0\0\0\t\t\0\0\0\0\0\0\0\t\0ùà\0\týÿÿ¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ËßûÛÿýÿûÿÀ\0\t\0\0\0\0\0\0\0\0\t\0\t\0\tÏÉÿ°\0\0\0\0\0\0\0\0\0\0\0\0\t\0š\0\0\t¿¿¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿýÿÿûÿþ¿ÿýÿÿý\0\t\0ÛÛ\0\0\0\0\0\0\0\t¿úÚÐù\0\t \t\0\0\0\0\0\0\0\0\0\t\r\0\0ßÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûÿÿ¿ÿ¿ßùÿý¿¿ÿïž°\0\0\0­ûËÉ\0\0\t\0\0¼ÿÏ\0ð\t\0\t\t\0\0\0\0\0\0\0\0\0\t\0\0\0\0\t\0›ÿ¿¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ½ÿ¿ÿÿÿÿÿûûÿÐ\0\0™©ßÿûÏ\0\0\0\t
Ð°\0°š\0 \0\0\0\0\0\0\0\tà\0\t\0\0\t¯ûÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿý¯ÿÿÿÿÿŸ½¿½ûßß¼º\0\0™þßàŸ\rûÀ\0\0\r\nœ\0\0ð½ š\0\0\t\0\0\0\0\0\0\0\0™à\0°\t\0™ýýÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿù¯Ûÿ½¿ïÿüûß¯¼ÿßÐ\0\0ÿðùÀ\tàœ¼\0\0žšý\0\0\0ù\0Ð\tÀ\t\0\0\t\0\0\0\0\0\0\0\0\0\0
ûûûÿÿÿÿÿßÿÿÿÿ¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûÿÛïŸþùùùûß­ùûÛëþ\t½\0›Ÿéð\0\tÉ\0\0\0\0°Ÿ\0¹\0\0\t\0\0\0\0\0\0\0\0\0\0\t\t\0\0\tÿÿÿÿÿÿÿ¿ûÿÿÿùÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ûÿÿ¿ùð™ëŸŸ¼¾Ÿ«ÛþÿïýûÀ\0þšþùàŸ\0\0\0\0\0\0\0\0\0ð
\t\0\0\0\0\t\t\0\0\0\0\0\0\0\0\0\0\0Ÿùûÿýûÿ½ü¿ÿ¿ÿÿÿÿÿÿÿÿ¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿þÿÿ¾ýúÛùùýü¿Ûùûÿð\0\0\t\r½ÿí\0\0\0\0\0\0\0\0\0\0°¹\tð°\0\0\0\0\0\0\0\0\n\0\0\0\0\0\t\0
ÿý¿ûý½ûûý¿ÿÿ¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûÿÿÿ¿ýûÛéùù°½ÿ¾úûÛýÿÿþÿ\0\t\0\0\0\t\0\0\0\0\0\0\0\0ùË\0¿É\t\0\0\0\t\0œ\t\0\0\0\0\0\0\0\tŸ¯ùÿ«Ÿ¾ùÿý¿ÿÿÿÿÿÿÿÿ¿ÿÿÿÿÿÿÿÿÿÿÿÿ¿ýûÿÿÿÿïË
Ÿ½ùý¿þ¿¯ÿ½¿ð\0\0\0\0\0\0\0\0\0\0\0\0\0ð™é
\0\0\0\0\0\0\t\t­©\0\0\0\0\0\0¿Ûž¹Ùù­½¿ÿ»ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûÿÿÿûÿÿ¿ûÿŸ­½½¼¼û¯»éùÿß¼ÿÿÿ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°©à™éÀ°\0\0\0\0\0\0\0\0\0\0\0\0›É›Í¾¿ÿÿÿúßÿÿÿÿÿÿÿÿûÿûÿÿÿÿÿÿÿûÿûÿÏ¿ÿýûÿÛÿúù
ŸýÿßÿûÿÿÿûÚÀ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ù\t
\0°\0š\0\0\0\0\0À\0\0\0\0\0\0\0\0\0\0šé»ùý¿¿¿ÿ¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûÿ¿ýÿýÿ½ûÛúýëÿ¼½ëÙéûËûúßûÿûþÿŸ\0\0\0\0\0\0\0\0\0\0\0\0\0üœ\t\t\0\t\t\0\0
À\0\0\0\0\0\0\0\0™žœ¿¯ßßÿý¿ÿÿÿÿÿÿÿÿÿûÿŸÿ¿ÿÿÿÿ¿ðÿ¿ûÿþß¿ß­ûÛÛïŸÿßûüûÞÛÚð\tùù\0\0\0\0\0\0\0\0\0\0\0\0û\t©\n\0\t\0\t\0\0\0\n\0\0\0\0\0\0\0\0\0\0¹ûÛÛûûÿÛÿÿÿÿÿÿÿÿÿ¿ÿÿÿÿÿÿÿûßï¿ûß­ùûûß¿Ûí¯¼½¯¿Ÿÿ¿žÛÿûÿÿŸ\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0°ð\t\0°\0\0°\t\t
\0\t\t\0\0\0\0\0\0\0\t\0\tœ¼½¿­ÿÿ¿ÿÿÿÿÿÿÿÿÿÿýûûùýûÿÿÿŸÿŸûß¾ÿŸëé¾›ùËûùðúÛËÿ¿ÿðùà\0\0\0\0\0\0\0\0\0\0\0\0\0\0ðŸ\n\t\0\0\t\t\tà\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
›Úùÿ¿¿ÿÿÿÿÿÿÿÿÿÿÿûÿßÿûÿÛß¿ùûÿûÛÛéýÿÛÿ¿žžÛÛÿý½þŸý¿¼Ÿ \0\0\0\0\0\0\0\0\0\0\0\0\0\0ù
Ùé\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0é½¿ŸÿßŸ¿ÿÿÿÿÿÿÿÿÿÿ¿ûßÿûÿ¿Ëÿßùï­½¿»šù­¼¼½»ëð›úûÛðúÐûÉÐ\0\0\0\0\0\0\0\0\0\0\0\0°°š\0\0\t \0\0\0\t\0\t\0\0\0\0\0\0\0\0\0\tšÚÚûÛú¿ÿÿÿÿÿÿÿÿÿûýÿŸûŸŸÿÿ¿Ú¿ûß¹ûëÚÞý¾ß
ÛúßŸÞÿŸ½¿\t°©\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð
\r©\t\0\0\0\0\t\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\t­¹½¼¾ÛßÿÿÿÿÿÿÿÿÿÿÿûÿéþÿŸùý¿ü½¯Ÿéùéû›­°½­­½¯ùùÿ¹°ùéðÛÀ\0\0\0\0\0\0\0\0\0\0\0\0\0\0ðœ°šÐ°\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0ùéûÛð¿¿ÿÿÿÿÿÿÿÿÿûüùÿÛÛùÿ¿éûûùëŸŸ­ïÛËËŸŸ«Û¯
Þÿž
\0¹\0\0\0\0\0\0\0\0\0\0\0\0\0\0¾\t\t\t\t\0\0\0\0\t\0\t\0\0\0\0\0\0\0\0\0\0\0››½½½ÿ¿ÿÿÿÿÿÿÿÿÿûÿ¿ÿ¼¾Ÿéÿ\r¼½½éúÛ››Ë¼°ùý­½¹ð©šÛÉð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ù
\0ð°À\t\0\t\0\t\0°\0\0\t\0\0\t\t\0\0\0\0\0\0ÛÉùËð¿¿ÿ¿ÿÿÿÿÿÿÿýÿûü½ÿýûŸ¹ûÛúÚŸ\r¼üü½ª™­¾šÛËÏ\tŸ»Ë\tš\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°ð›\t\t°\0\0\0\t\0\0\t\0\0\0\0\0\0\0\0\0\0\0\tºŸ­¿\tëß¿ÿÿÿÿÿÿÿÿÿ¿ŸÛþ¿Ÿ½ÿùééùðû›
°ùÚÛÉ½¾Ÿ›ž\0œÚ\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0ð›Àš\t\0\t\0\0š\0\0\t°\0\0\0\0\0\0\t\0\t\r©š¼¹¾½ÿÿÿÿÿÿÿÿûÿÿþ¿›ßðûËý¯ŸŸšß\tù­¼Ÿ\t©©ºÚ©éé
Ë\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0ð\t°œ
\0°\0\0\t\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0›ÚÙÛÉÙúß¿ÿÿÿÿÿÿÿÿÛýüÿ­¿ß½¿Ÿ­°ù©ð½šÛéðÐÐ­©ù°šË\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ðš\tÐ\0\0\t\t\0\t\0°\0\0\t\0\0\0\0\0\0\t\0\0\0\t °°¿Ÿ¿ÿûÿÿÿÿÿÿûÿûûùûÛðûéûÛËÚÛ
éð›


Ú›¼¼\r\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°\r™
\0\t \0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t›ŸŸ\t­¿½¿ÿÿÿÿÿÿÿÿÿß¼¾Ÿ½Ÿ\r­½­°ù¼©ééÉ½©\r\t¹\t \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ðš\n\t
\0\0\0\0\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\téÚùþûÿÿÿÿÿÿÿý¿ÿ©ðÛùûÛëûðð°Û\r

š°\0œ°ð©À°\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0û\tžœ\t\0\0\0\0\0\0\0\0\t\t\0\0\0\0\0\0\0\0\0\0\0\0\t\0°½¾›ÿÿÿÿÿÿÿÿÿùÿß¿¼½ééùÏŸŸŸ­°ùéðÙð™ð°™\tÐ°\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\t©

\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t šÙÿŸ¿ÿÿÿÿÿÿ¾ÿðúÛËÚ›ûË¹é©é›\t¹
«
Ê\tÉ¬°©\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ùž©\0\t\0\0
\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t
ÛéÿÿÿÿÿÿÿÿÿžŸ¼¹ëß\r¿ÞŸŸðÚÛÀðÐÐ\t©\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0\t¾\t© ÚÙ\0\0\t\0™\0\0\0\0\0\0\t\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\t
Ÿ¿ÿÿÿÿÿÿÿÿÿûúÛ©úÐ¹ðÚŸ
°›\t°°­š\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0ùð›\t«\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¼¼¿¿ÿÿÿÿÿÿûÛÚß­ð¹ðÛùéû­©ðùË\r°ÚÙ©\0
\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0ð°ð\0œ\0\0\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t¹ýÿÿÿÿÿÿÿþþ½°Û­
©Û\r›ð›
™é­©\nÐ›\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\t\0\0°°¹
\0\0\tšÐ\0\0\0\t\t\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tûÿÿÿÿÿÿÿÛÛÛ°ùÐðÙð°Û­\r¼¼ù\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0\0\0\0\0\0\0ù\t©\t¼\0\0\0°\t\0\0\0\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0šŸÿÿÿÿÿÿÿÿ¿\tðÛ

›

Û­
š›\t¹¼¼°\0
\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0úšÚ¹©©\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tûÿÿÿÿÿÿÿ½éþ›\r¼°ðœœ›ÐùÉéÉ\t\tÉ¹\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0\0\0\0\0\t\0\0ð\0šÚ\0œ
\0\0š\t\0\t\0\0\0\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ÿÿÿÿÿÿÿÿÿ¿\t¼š™\r\té­©©©

ššÚššÀ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0°›½\t\t©¬\0\t\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t¿ÿÿÿÿÿÿ¾½¼›É­šš›\tÐÐ¼¹É­\tÉ\t\t©\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0ð\0ËúÐ›\t\n\t\0\0\0\0š\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿ÿÿÿÿÿßÙúÛð¹
™\r\r
ÀÚ
\tËššð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0\0ù©\t


\0ð™\0\0\0\0\0\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ŸÿÿÿûÙ©é\r\t\r
Ð©©
\tš™É\t°°Ðœ°©\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð°½¼\t
À\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t¿ÿÿùü¿Û›Û›
œ
Ð°Ú\t\nšÉ­°°œ°Ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0°¯\r
Ëš¼°\t\0\0\0\t\0©\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿ÿýûÛü¹í°ü™Ë™\0¼œ¹\0Ú›\t\tÉ©\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ù\t
›É\0\t\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tÿÿûÿý¿ÿ°ý¹ú¼¹\t©
\t\0Û\tžð¼°
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0ú¼°ð¾ššŸ\0\0\0\0\t\t\0
\0\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿ÿÿßÿùÿß¿éŸŸ\t°Úœ°š\t©°°™\t©É\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\t\0ùàžŸ™­\t\r©\t\0\0\0\0\0\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t¿ÿÿ¿½ÿùûßŸéðž›\t\t\t\t\t\0Ð\t©É¬°Ð°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0ð›\0©šž›°ž\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tÿÿÿÿÿ½¿ÿûÿŸ©ù¼›\nšðšð¹\t°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\tºÀšËéü¹\n°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tÿÿÿÿÿÿÿùþÛýÿ
ÀÙ\r\t\t\t\0ù°é\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0ù°­\t\tš›Ëœ\0œ \0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ÿÿÿÿÿÿßÿùý¯Ÿ½ù¹©
\nž°\0°™\tà\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð­ °­¼°ù©
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿ÿÿÿÿÿÿûÿ¿ûý¿Úžžð\t\0Ð
\t\t\n\t\t°š\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°™\n\0›ËŸ\0\0\0\0\0\0\0\t°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tÿÿÿÿÿÿÿÿßßŸ›ü¿ÛÛš\t©\0Ú\rš\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\nÉ\nŸ\0¼°›\té\t\0\t\0\0\0\0\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0›ÿÿÿÿÿÿÿÿûûþýûß­¼°\t¹É
\0š\tš\tð\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t«\tš
ÐšÚÐð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿ÿÿÿÿÿÿÿÛýí½¾Ÿ¹ûËÛ°ðÀ°ž\t\0\t\0\t\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0ð  š©\t¹©\t \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ÿÿÿÿÿÿÿûÿÛùûÛžß¼½­\r
›\r¼šœ°š\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0›°\t\tééŸð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0›ÿÿÿÿÿûÛß½¯Ÿ­žÛšŸžšÛ½¬š\t©\n\t\0\t\0Ð\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0šœð °\0š\0°™ð
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ÿÿÿÿÿÿÿÿ­ùùéÚ›\nÛÐù½°Ú›É°ž\t\t \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0™
°\t
š\t©Ëà›\r\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tÿÿÿÿÿÿ½ùù¾Ÿž½­›\r©­
Ë½é°ÚÚœ\0
\t\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\nÐð\n\0­ Ð°›ÉÚ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0›ÿÿÿÿÿÿþ¿Ÿ\r°™\tšœ›\rš°ÚŸ\r©\t
\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°› \0š™\t\nœ¼°©\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿ûÿÿÿÿÿÛÐÚÛ\tðù­\t¼¹©Ë­¹ðšž\t\t\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ð¼ð ©ªš\t©©\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tÿÿÿÿÿÿûý¿¹ðœðÐ¹ÚÚßù\té\t\0\0©
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0

\t°\t\0šÐ¼\tË½\0\0\0\0\t\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0
¿ÿ¿ÿÿÿß¼ÚÙù
\t
ËË\t™¹©Úšðš\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð°\n\n

É©©éË\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ŸÿÿÿÿÿÿùÛŸ¼ùÚÐÚ™Ÿ­©­
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0šÛ\0à\0\t
\0
\0žš¹\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\tÿýûÿÿÿßŸ½ÿÛý½­©\tš›É°Ð°¹ëÛœ¼©\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n
\t\0\t°\0\n»\0Ú\t½\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
¿ûýÿÿÿ¿ýÿÛÿÛÛÙÛ\tÉ©É­\tÉŸ­©©\tœ°\t\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\t
°\n\0 \0°©ð
™ \0\0\0\t\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ÿÿÿ¿¿ÿÿÿÿÛÉ\0°œ½°ššššÛÛÐÐ¼°\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\t ð \nšš\t\tðúÐ\0\0\0\t\t\0\t \0\0\0\0\0\0\0\0\0\0\tÿÿùéÿÿÿý¼°›Ù©­\té\t\r­\t\tÉ\t\t¿«
É\r°é\0\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0ð\0Ë \0\0\0 š›
\t\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ÿ¿ŸŸÿÿÿÛÉŸÿúßùé\t\0™­°ššÚ›Ï\t

\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t
\t°°\n\0°

\t¬½é©é\0\0\0\0\0\t\t\0\0\0\0\0\0\0\0\0\0Ÿ¿ý©¿¿ÿ½›ÿÿÿÿÿïðð©\0\r\t\t\t¹ë\tÉ\t\t\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0š\0\0\0
ð\0\n\n\0\0°›
œš\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿ÿûÚŸÿÿÐ¿ÿÿÿÿÿÿù¿­šÐ\t°ð¼šÛß°°Úš\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\t\t\t\0°\0 \n

\0ùé
\tÀ\0\0\t\0\0™\0\0\0\0\0\0\0\0\0\tÿ¿™ÿÿð
ÿÿÿÿùëÿ
ÏÚŸ\0\0™\t­
ë\t\t©\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°\0\n\0š \0\0\n\0\0
ËžšÉ©\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0Ÿÿÿù
ù©Ÿÿÿùð\t½°ðû©Ë\t­\0žš½¹Ð½©\t\t\t©\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\t\t
©ð \n\0\n
\0°
\t©°š\0\0\0\0\t\0™\0\0\0\0\0\0\0\0\0›ýù½ÿß\t¿ÿžž™Ð\0\t\t\tÀ°ð\t \0\t\r©šß©Úžš\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0š\0\0\0š°\0\0°\0\0©ðÐš\0\0\0\0\0\0\0\0\0\0\0\0¿ûþš›\t\t\0ùùùùé½›°\t\t\0\t\0ù°ð
\t\t\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\t\0\0°ð\0
\0\0\0\nš
\t©éà©\0\0\0\0\0\t\0\0\0\0\0\0\0\0\tÿÿ\t\tÐš›ŸŸŸŸŸË\r™\t
\t\0\0\0\t
\0ß½¼šÚœ°\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0›Ë°\n\0\n\0\nššÐžŸ™œ\t\0\0\t\0š\0\0\0\0\0\0Ÿÿ¹ù©ýûÿÿÿÿÿÿ¿Ûð½©Ë\n­™\t¹\0\t©\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0°  \0\n\0 \0\0°½©\nÛ\0©\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ûé\tŸûÿÿÿÿÿûÿÛðŸ\tÚ›Ùéš\t©©©¬°ž›šÐšš\t \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t©ð\0\0°\0\n\0 
ËÙ­½\0°\0\t\t\t\t\0\0\0\0\0\0\0Ÿß™\0°úßÿÿÿÿûßŸ¼¿\tð½­©ž©É\r\t¹ÀÙ
\tÉ\r\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t \n°\n\0\0 \0\0

ššÚš\t \0\0\0\0\0\0\0\0\0\0\0\0¿û¼°™½¿¿ÿÿûÿúùûÐš\t\tŸ\t©žšš\t\t\0¹ ðš™\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\t\n
\tð\0\nš\0\0 °\t­­©­\t\0\0\0\t\0\t\t\0\0\0\0\0\0
ÿÛÉ›Ëÿÿÿÿÿý½Ÿ\r
œ™­©ðšÐðÐž›\té\tÐš\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\t
É\0\n \0\0\0\0\0\0\0°ÛÛ\r\téé\t\0\0\0\0\0\0\0\0\0\0\0™ûý¿
À™½¿¿ÿýûÊš\t¬›
Ð¹


\tù
ž

š\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0šš°° \0 \0 
\0\0\0¼ºÚš\0\0\0\0\0\0\0\0\0\0
ÿûÛÙ¹©úßÿÿÿŸ™à\t©š›œ½\rœ°û
Ð™\0›\0É\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0©
ð\0\n\0\0\0\0\n›
Ð°ž\0\0\0\0\t\0\0\0\0\0\0Ÿÿÿÿ¿\tÐŸûßÿûéð™\0\0\t›šš™°¹½ŸÐ¹é ½©\0š\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t­©\n\0°\0\0\n\0\0  \t\0ÿ
\r©\0\0\0\0\0\0\0\0\0\0\0\t¿ÿ¿ÛÐÛ©¿ŸÿÿŸÛé°\t\0\t¼\r½\tËÉé›Ú\té\t\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0°û  
\0\0\0\0\n\0©
žšž°\0\0\0\0\t\t\0\0\0\0\0ÿÿÿÿ¿½ž™ûÿÿûýùÉ¼›\tÉ°\t°šù½¿½¹é\r­°©°š\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0©\n

\nð\0\0 \0\0\0\0\0šœ½­\t­\t\0\0\0\0\0\0\0\0\0\0\t¿ÿÿ½ý¾™ð½¿ÿÿûÿ¼›\r© Ÿ\tù™ËËŸ›ÙÀÐ\t\0\t\0\0\0\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0°\n¹°\0\n\0\0\0\n\0°©©
šž¼\0\0\0\0\0\t\0\0\0\0
ÿÿÿÿ¿ùþ›ÛÿÿÿÿÛËÐðŸ\t žûÛï½½©éé©¹©©\t\0°\0\t\0žšÚ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0©\0«\n \0\t\0\0\0\0\0\n
\tééðš\0\0\0\0\0\0\0\0\0\tÿÿÿ¿ÿŸù¼½ÿÿÿÿ¿Û
\tð°™\0¹¿½¿›ÛŸ›ŸšÐÐœ\t\0\0\t\0
\t\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0š\t©«ð   \0\0\0\n\t\0\n¼¼½\t\0\0\0\0\0\0\0\0ÿÿÿÿŸÿŸÛûÿÿÿÿß­ùÛ
ÉàÙ©ËÙÛËý½ùéééÉ©©©© \t\0\0œ\t°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0©\n¾\n\0°\0\n\0\0\0\0  °¼š›\nð\0\0\0\0\0\0\0\0\0\0›ÿÿÿÿÿûûý½¿ÿÿÿûÛ\r½»™ ›ž¾¿¿ŸéûÛŸ››Û\r\t\0\0\t©
\0É\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\nš™
\0°ð\0\t \n\n\0\0\0\t\0°¼¼½\0\0\0\0\0\t\0\0\0\0
ÿÿÿÿûßÿŸÿÿÿÿÿ½ÿÛšœš™ü½½ùýù¿¼ŸšÞžð½
\t \t\0\0É\t°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tà °
\n  \n\n\t\t\0\nš\n
\t©°¹à\0\0\0\0\0\0\0\0ŸÿÿÿÿÿÿŸÿûÿÿÿÿß¼¹éËË\r
ŸŸ¿Ÿ¯ý½¾Ÿ›™Ë™\nœ\0\t\t ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t
©
\0° ð\0
\0šª\0\0\0\0\0°©œ\0š\0\0\0\0\0\0\0\0
ÿÿÿÿûÿÿ¿ÿÿÿÿÿ½ÛÞ¹\t°¹½ùëÞûßšÛùððð¼ž©\0\0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t©­\nš \n\0° \0ºé\0\0\0 \0\t
žš\t¹\r\0\0\0\0\0\0\0\0Ÿÿÿÿÿÿÿ¿ÿÿÿÿÿÿûé©ù¼½šŸŸ½¿½ÿŸŸŸŸ›\t©\t©\t\t\0\0\t©
Ë\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0š\t
\0°ð\0

\n\n\n\n\0\n\n\n\t©šÀš\t\0\0\0\0\0\0\0\0
ÿÿÿÿÿÿÿÿÿÿÿÿÿßŸŸ
Ð™\t¹ËÚÛÛýûÛùùðž¼Ÿžž\n\0\t\t\0œ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tÊÚ
\n\0
\0 \0  \0\0\0\0\0\0\0»Éà¼°\0\0\0\0\0\0\0\0Ÿÿÿÿÿÿÿÿ¿ÿÿÿÿÿûËÐ½
ÚÛ½¿ÿý¿½¿Ÿ
Û
Ù©\t\t\t\t\t\0\0\t\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t©\t\0 š\0\n°\0\0\0\0\0\n\0\n\0\0 \0°›\t\t
\0\0\0\t\0\0\0\0›ÿÿÿÿÿÿÿÿÿÿÿÿÿýð½ ù©¼°Úù¼¿ËÞ½¿éù­œºÚÚšž\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t °š\0  ð\0\0\0  \0\n\0\0 \nšŸ\r\0šœ\0\0\0\0\0\0\0ÿÿÿÿÿÿÿÿÿÿÿÿÿ¿Ÿ\tÛ\tÐ™ÛÛßûÛÿ½¿ÛŸŸ›©Ù\t°Ð\t\t\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
\0\n\0°\0š \0\0\0\0\0š\0\n\0\0\0\0 ¹©\0
\0\0\0\0\0\0\0\0¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿËÚ\tù©é©­¯ŸÿŸÛý­úÚÐÛ
ÚÙ©\t \0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0ž\n\n\0© °\0\0\n\n\0 \0 \0\0

›ÊÀ\0É\0\0\t\0\0\0\0ŸÿÿÿÿÛÿ¿ÿÿÿÿÿÿý½©Ÿ\nÐŸÛÙð°ð¿ËŸ¹ÛŸ°½© ð\0\0\t\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0©\n\0\0à\n\n\t\0\0\0\n\0 \0  ¹©\n\0\0\0\0\0\0\t¿ÿÿûÿÿÿÿÿÿÿÿÿÿ¿Ÿ\0™
Ÿ©­¾½½›Ù½ûß­é\tœŸ\t\t\r©\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 š©©\0©© °\0\0\n\0\0 \0  \0\0°ð¬°\t\0\0\t\t\0\0\0
ÿÿÿÿ½­½¿ûÿÿÿÿßÿ©½­¼\tý¼™ÚÚð¾›Þ½¹¿™ð»\t©© \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
\0\n\n\0\n\0ð\0\0 \0\n\0
\n\0\0 
©
\0\0\0\0\0\0\0\0\0ŸÿÿÿûË›
Éýÿÿÿÿÿ\tÐ™¼š›ŸÙü¹ÚßÉ­
ÐðÐœ™\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t©
\0\0\n\n° 
\0\0 \0  \0 \0°\0°Ú\0 \t\0\0\t\t\0\0\0ŸÿÿÿùùðÙ›ÚûÿÿÿÿŸ
Ë
ËÉ©Àù°°©

Ÿ«Ú›Ú½
šš\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 ° \n ° \n\0\n\0\0\0\0 \0\n\nšš\r\0™\0\0\0\0\0\0\0\0›ÿÿÿÿÿ¿ž¹ŸÛÿÿùé\t\tÉ\t©\t¹\r\r\t©Ú½\tðË\r
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0™¬š\t
\0 °\0ð \0\0 \0\0© \0\t \0© \nÀ\t\0\t\0\0\0
ÿÿÿÿþÛùùËËÿÿÿÿÛÛ
°ÚÐ°°ðûËËÉ©žš›š\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 ›\t  
\0\n\0© \0\0\n\0\0 \n\0 \n\0 š°\t\0\0\0\0\0\0ÿýÿÿŸ¼¼¼¹ŸŸÿÿÿ¾œ\tÉ
\t
Éù½\0šÐ¹°¹­­\t°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\r  ° ©©\n°\0\n\0 \0\0 \0\0°\0\t­­\n\0\0\t\0\0\0\0›ÿ›¿ðûÉ\t\tšËÛÿÿûÙœ°ššÉ¼½»Ððù¼°šÚËÚÙ°¹\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0šš\tª\0\0š\n\0ú\0\0\0\0\0\0 \0\0\n\0\0 ºš›É\t\0\0\0\0\0\0\0\tÿüŸü\0\0\0\t¹¿ÿÿ­©\t\0\t\t\tÀûÉ\0\t
Ë\t\t™\t­­\t©\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
š
\n\t
\n\0\0\0°  \n\0\0\0\n\0\0\0\n\0\0\0°ð\0\0\0\0\0\0
ÿ\t
ÿ\0\0\0\0\tßÿýûË™\0
\t
Ÿà\0\0\t\0\0\0šœÚ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¹\t ù  © ° ð\0\0\0\0\0\n\0\0\0\0\0\0\nš©½
\t \0\t\0\0\0\0\tûË\0\tï\t\0\0\0ù¿ÿÿ½™\0
\0
ÿ\0\0\0\0\0°©©©Ë
\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\t\t\0ë\t 
\0šš\0\0°\0\0 \0\0\0\0\0\0\n\0\n\tàð­­\0\0\0\0\0\0\0ÿý©\0\0\0\0™©°ÿÿûÉ \0\0½\0Ÿü\t\0\0\0\0\0\t\tÐÙ©\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0ÚÉ°\nš°° © \0ð  \0 \0\0\0\0\0\0 \0\n¿«š\0\t\t\0\0\0™ÿûÚ\0\0\t\0\0œŸ¿ÿÿþ ð\t\t\nŸ\0\0\0\0\0\0\t 
\t \0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0š\t°
é \n\0
\0\n\0°\0\0 \0\0\0\0\0\0\0\0\0\0\0š°ðœ\0\0\0©\0\0\nÛÿÿ½
\t\0œ›\tÿÿÿ½©\t\0Ð\t\t\0\0\0\0\0\0
\téœ©\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\t\0
\0°šº\0  ð\0\0\0\0\0\0\0\0\n\0\0\0\0º©žš\0\0\0\0\0›ÿûýÿ½ðð©šœ¿ÿÿùÿœ°š©\0ðð\0\0\t\t\t\t©\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
Ð° © \0\n \0 \n\0\0\0\0\0\0\0\0\n\0\0\n\0© \t\0\0\0\0\0\0
ÿÿÿ¾ž›Ÿ©Û½ûÿÿéË\t\t\0\t\tÊ™\0Ùœ°šÐ¹
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\t\n
\nšÊ°©\n\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0š\nšÛé\0\0\t\0\t\0\0ùÿ¿ßŸž°™©ÿÿûÿŸ¼›\0\0°š™Ê™\n\t\tÉ©ÊÀ\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°© °\n°\0\n\0\0\0ð\0\n\0\0\0\0\0\0\0\0\0\0\0© \0\t\0\0\0\0\0\0\túùé­ \t¬ž›ÿÿûü»Ÿ
\t\t
É
™Ë™

\0
\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\r\nš
\0
\0©  \0° \0\0\0\0\0\0\0\0\0\0\0\n\n\t©\nÛ\0\0›\0\0\0›ÿžœ\0\0Ù¹ÿÿýÿûÐù \0\0šœšÐŸ\t©Ðš\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0© © \n\0\0\0\0 \0 \0\0\0\0\0\0\0\0\0\0\0\n\0\t\0\t\t\0\0\0\0\0\tÿÿ›\0\0\t\t­ºÿß¿ûÿ­¯\t\0\0\t\t\t­\t­¼¹žš\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\nš
\nš\0 \n\n\0\0ð \0\0\0\0\0\0\0\0\0\0\0\n\n\0
\0\t\0\0\0
ÿÿÿûÛŸ¿ûßŸ¿ùÿýûßé\t\t\0\0\0¼\t\0\t\t\t\tà\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t­©\0°\0 \0\0\0\0\0°\n\0\0\0\0\0\0\0\0\0\0\0\0°©\0\0¹\0\n\t\0\0\t\tÿÿÿÿÿÿÿŸ¿ÿÿÿÿûÿ¿ž½\n\0\0\0\0\0\t©©Ë\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 ©ë š\n\0\0\0\0ð\0\0 \0\0\0\0\0\0\0\0\0
\0\0 \t\t\t\0\0\0\0
ÿÿÿÿÿÿÿÿÿûÿÿ¿ÿÿßÿÚù\t\0\r\0\t\t\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t©\nžš\n \0\0\n\0\0  \0\0\0\0\0\0\0\0\0\0\0 \0 \0\0°\t°\0\t\0\0\0Ÿÿÿÿÿÿÿûÿÿÿÿÿÿÿûÿûÿýï
\0\t\0\t\0œ°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t©  ©\0 \0\0\0\0ð\n\0\0\0\0\0\0\0\0\0\0\0
©\0 \t\0°\t\0\t\0\t\tÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ÿÿÿ½¼½ š\t š°\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0ú\0\t\0\0 \0\0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0©\0\0\t\0žš\0\t\0Ÿÿÿÿÿÿÿÿÿÿÿÿ¿ÿ¿ÿÿÿÿ¿ÿûËÛÉð\0\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\t\0° \n\0\0\0\0\0\0\0à\0\0\0\0\0\0\0\0\0\0\0\0
\n\0 \0\0°\t\t\t«ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿúßùé°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0Ú
\n \0\0\0\0\0\0\0° \0\0\0\0\0\0\0\0\0\0\0  \0\0\n›\0°¼ \nŸÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ÿÿßûž½\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
\t \t\n\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0™­\r\t\t\t\0¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿûÿÿÿÿ¿žù\0\t\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\r 
\n\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¬š°\0\0œ›ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿý¿ÿùÞ\t\0 \0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\nš° \0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\tË\r
\0\t¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ý¯ž¹\0Ú\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t
É\n\0\0\0\0\0\0\0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n°°š\t
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûÿÿûùù\0
\t\0\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0©­\0°\0\0\0\0\0\0\0\0\0\0à\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0ÚÐ\0\tÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÛßÛË\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0œº\n\0\0\0\0\0\0\0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0šÚ°\0š›ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ°¼½\0°
\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n½\t\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \t\t
ËÐ\0Ÿÿÿÿÿÿ¿ÿÿÿÿÿÿÿÿûÿúùÛš\t\r\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\t\0  \0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°°ð
\0™¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿéÿ©Àš\t\0\0\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0½©©\0\0\0\0\0\0\0\0\0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\t\tÉ\tëÐ
›ÿÿÿÿý¿ÿÿÿÿÿÿÿÿÿûÙ\tëÚ\0\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0œ\0°\0\0\0\0\0\0\n\0\0\0\0à\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t­°­\0š¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿéûÛ\t\0¹\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t¼© \0\0\0\0\0\0\0\0\0 \0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
\nŸŸš\t™ÿÿÿÿûÿÿÿÿÿÿÿÿÿÿÿÚŸ­ù\0\tÀ\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0°\t\n\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\r
é \r­\t
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿûÿ\tŸ\0š°\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t­žà\n\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°šžŸššžŸÿÿÿùÿÿÿÿÿÿÿÿÿýÿ\tùù©\0\t\0\t\0\0\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\téé©Éé\t\t½¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿšžžÐ\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\nš\n\t \0\0\0\0\0\0\0\0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 šŸžšð›Ëÿÿÿý¿ÿÿÿÿÿÿÿÿÿûÀ›Úš\0\t\0\0\t\t\0 \0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¼ \tÉ\0\n\0\0\0\0\0\0\0\0\0\0\0\0à\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0™­\0°©éé
À¹ûÿÿúÿÿÿÿÿÿÿÿÿùü™ý©\0\0\0š\0\t\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0°° \t\0\0\0\0\0\0\0\0\0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0  Úý\tžž½Ÿÿÿý¿ÿÿÿÿÿÿÿÿÿ¿\0š\tà\0š\0\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t ð\tËÀ\0 \n\0\0\0\0\0\0\0\0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t
\t©¬™ú™­
šÚ¿ÿûÿÿÿÿÿÿÿÿÿÿÞ\r\0\t\0™\0\0\0\0\t\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0Ù\0š°\0\0\0\0\0\0\0\0\0\0\0\0\0à\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0ÚÚÛ­\t¼\t½ùÿÿŸÿÿÿÿÿÿÿÿÿ¯\t›\t\0
\0\t\t\0\0\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0
\nÐ°Ú\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0©°½°éúÚ›ËÛËŸÿðÿÿÿÿÿÿÿÿûùý
À\0\t\0š\0\n\t©\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tœ\t
\r© š\0\0\0\0\0\0\0\0\0\0\0\0\0 \n\0\0\0\0\0 \0\0\0\0\0\0\n\0\0\0\0\tË›\tùé°°šÛÿÿÛÿÿÿÿ¿ÿÿÿÿðÀ°°\0\0\0\0\0\0\t\0\0\0\0\0\t \t\0\0\0\0\0\0\0\0\0
Úœš\0\n\0\0 \0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0
Êœ¼ðð¼¼éË\r­¿ÿ­¿ÿßÿÿûÿý½û\tÉ\t\0ž\t\0\0\0\t\t\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0
\0\t ù \t \0\0\0\0\0\0\0\0\0\0\0\0\0°\0\0\0\0\0\0\0\0\0\n\0\0\n\0\0\0\0\0\t
›ž›™©ËšŸûÛÿß¿ÿÿÿÿûï¼š\0\0\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°\0\0\0žÙ\0\t \0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\n\0\0°\0Àý©
ËÊý¹ß½ËÿÿÿýÿýûßÛÉ\t
\t\0\t\t\t\t\0\n\0\0\0\0\0©\0\0\0\0\t\0\0\0\t­©\0 °\0\0\0 \0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0°šß\t\r½šž™©ÿ¹ÿ¿ûûûûý¯½°\0\0\0\t\n\0\0\0\0\0\0\0\0\0\0\0 \t\0\0\0\0\0\0\0\t\0ž°\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0°\0\0\0\0\0\0\0\0 \n\0\n\0\0\0\0\n\0\0\0©\t­ð°úÝ©ëÚŸíŸùýÿÿß¯¯Ë\0\0\0\t\0\0\t\0\t\0\0\t\0\0\0\0\t\0\0\0\t\n\0\0\0\t é\0© \0\n\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\n\0\n\0\0\0\0\0 \0\0\0\0 \t\0\nšŸ«œ¹í¹©ÿûúÛÿÙëÛœ\t\0\t\0\0\0\t\0\0\0\0\0\0\0\t\t\0\0\t\0\0\0\0\t\0\0\0\nÐð©\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t \téÉùððÐÚžœ›žŸý½ýÿÛš™ùé\0\0\0\0\0\0\0\0\0\t\t\0\0\0 \0\0\0\0\0\t\0\0\0\0\0\0™
\t \0 \0\0 \0\n\0\0\0\n\0\0\0\0\0\0\0 \0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\n\0\0\0
\0°
Ÿ¯­\t©éé­»ï¿Ÿ¾Ðÿ\0\0\0\t\0\0\0\0\0\t\0\0\0\0\0\0\0\0š\0\0\0\0š\0\0
ÊÐ \n\0\0\n\0\0\0\0\0\n\0\0\0\0\0\0\0 \0°\0\0\0\0\0\0\0\0\0\n\0\0 \0\0\0\0\0 \0
\0\t¼­ŸšœœšßŸÛðù©
Ùð\0\0\0\0\t\0\0\0\0\0\0\0\0
\0À\0\0\0\0\0\t\0\0\0©
\0š\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0à\0\0\0\0\0\n\0 \n\0\0\0\0\0 \0\0\0\0\n\tà°Ÿšðß\t­©©\t°ù­¯ž™ù©\t\t\0\0\0\0\0\0\0\0\0\t\0\0\0
\0\0\0\0\0\0\t\0\0\t\0ž\t\0 
\0\0\0\n\0\0\0 \0\0\0\0\0\0\n\n\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\n\0\0\0°\t\t­­\t šœé\r°ý½¼žš \0\0\0\0\0\0\0\t\0\0\0\0©\0Ð\tÉ\0\0\0š\0\r š
\t \0
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0°\0\0°\0 \0\n\n\0\0°\t\0À\0¾ÚÛÉË\0\t\t
É°¼›\t\r \0\0\0\0\0\0\0\0\0\0\0\0\0é \t\n\n\0\0\0\0\0\0\0\0°

\0 \0\n\0\n\0\0 \0\0\0\0\0\0\0\0\0\0\0\0°\0\0\0\0\0\0\0 \0  \0\0\0\0\0\0\0 \0 
\0™©
°°\0¼
É­°\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\t\0\0\t\0\0\0\t\0\t\0¼

\0ðšš\0\0\t\0 \0 \0 \0\0\0\0\0\n\0\n\0à\0\0\0\0\0\n\0\0 \0\0  \0 \0\0\n\0\0\0\0
\0\0žü°œ\0é\t ¼š\t\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0°š
ž\0\0°\0\0\0\0\0\0°\0ð  \0\n\n\0\t\0\0\0\0\0\0\n\0\0\0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0 \0 \n\0\0\0\0\0\0\téé
\r\n\n\0\t\t­\t\0\0\0\0\0\0\0\0\0\0\0\0\0 \r¬š\0\0\0\tÀ\0\0\n\0ž

ë\nšš\n\t\0\n\0 \0\0\0\0\n\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\n\0\0 \0\0\0\0\0\0 \0 \0\0\0\t°ÉËÉÉý\0\t\0\0\tà\0\0\0\0\0\0\t\0\t\0\0\0\t\t\t\0°\0Ð\té\0\0\0 š\t©°©\0  \0\0\n\0\0\0\0\0\n\0\0\0\0\0\t\n\0\0ð\0\0\0\0\0\0\0\0\0 \0\0 \0 \0\0\0\0\0\n\0\0
\0°ù°°š\0\nÐ\0\0\t\0\0\0\0\0\t\0\0\r\0\t\0\n\0Ð°\t
ËË\0°\0\0\0\t\0\0\r­\nËÊš
\t\0\nš\0\n\0°\0\0\0\0\0\0  \0\0\0\0\0 \0\0\0\0\0 \0\0\n\t\0\n\0\n\0\n\0\0\0 \0\0\0\0\0\t\0À\r­\tÿ\0\0\0\0é\0\0\0\0\0\0\0œ°\0\0\0\t\t\t©\r­©\t\0\t\0\0\0\0\0œ°°°©šÊ
\0\0\t\0\0 \0\0\0\0\0\0\0\0\0 \0\0°\0\0\0\0\0\0 \n\n\n\0\0\0\0\0\0© \0\0\0\n\0\0š¼šÿ\0\0\0\0\0\0\0\0É \0
\0¼šžžË\0\0\0\0\0\t\0\0\0›
\r\n
\0š©\0°\0© \n\0 \0\0 \0\0\0\0\0\0\0 \0\0\0à\0\0\0\0\0\0\0\0\n\0\0\t \n\0\0\0\0\0\0\n\t©\0\0\t\t
\rË\0ð\0\0\0š\0\t\0\0°\t\t\0\t\0¼\tË\0\0\0\0\0\0\0 \0œ°°Úš\t\0°\t©\0\0\0°\n\n\0\0\0\0\n\0 \0\0\0\0\0\0°\0\0\0\0\n\0\0\0\0\n\0 \0\0\0\0 \0š\0\0\0\0\0 \0\0\0\rªœ°\0\tË\0É­\t\tàË\0\0\0\0™àù\0
Ê\0\0\0\0\0\t\0©\0\0é©©Éë\0\0¼°\n\0\n
\n\0\0\t\0\0\0\0\0\0\0\0\0\0\0\n\0\0 \0\0\0 \0\0 \0\n\0\0 \n\t  \0\n\0\0\0\n\0\0ð
É
ýºÐ¬¼\t \r\r
\0
À\t\0\0\0\0\0\r\0\t\t\0ÐÚ›\0°û\n\0°° \0\0 \0 \0\0\0\0\0\0\0\0\n\0\0\0ð\0\0\0\0\0\0\0 \0\0\n\0\0\0\0\0\0\0 \0\0\0\0\0\n\n\0\n\t\0 šÐ\t¾ššÙÀ°É\0š¼\t\r\t\0\0\0\0\0\t\0°\0\0 ½©©¬
Ë\0\0°\0\0\n\0  \0 \0\n\0\0 \n\0\n\0\0\0\0\0 \0\0 \0\n\0\0\0\0\n\0 \0°\n\0\n\0\0\0\0\0\0\0\0\0
\t\0°Ùí Ð\tÉÛÉ ¹Ë½­­\0­\0\n\0\0\0\0\0\n\0\r\0\0\tÉ\0žžš °°\nšš
\0 \0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0°\0\0\0\0\0\0 
\0\0\t\0 \0\t\n\0\0\0\0\0\n\0\0\0\0\0\n\0\n
Ú¯\n\0­ÚË\ré\0\0­\0\nÐ\0\0\0š\0\0\0\0\t\t \t
\0°ð›\t ©\0\n
\0\0\0\0\0\n\0©\n\0\0\0\0\0\0\0\0\0 \0\0à\0\0\0 \0
\0\0\nš\n\0\0\0 \0\0\n\0\0\t\0\0\0\0\0\0\0š\t\0°½ÐÐ\tš
Ðà­\0\0\t\0\0\t\0\0\0\0\0\0\0\0Ðà\t\nÉ
à \t\0© 
\n
\n\0\n\0\n\0\0\0
\n\0\n\0\n\n\n\0\0\0\0°\0\0\0\0\n\0\0 \0\0\0\0\0 \0\0\0\0\0\0 \0\0\0\0\0\0\n\0 \0«ëêÊœ\n\0\0\0\0\t\0\0\0\0\0\0\t\t©\t\0É\t­ºð\t
\n
\0\t  \t\0\0š\0\t©\n\n\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\n\0\0©© \n\0\0\0 \n\t\n\0\0\0\0 \0\0\0\0\0 ššœœ½\t œ\0Ë\0\0\0\t\0\0\0\0\0\0\0\0\0\nÀ\0\0Ð¼¼š\t
\n\0\t\0© \0š\n\nš\0\t \n\t\0š\0\0\0\0\0\0° \0\0\0\0°\0\0\0\0\0\0š\0\n\0
\0\0\0\t\0\0\n\0\0\0\n\0\0\0 \0\0\0\0\0\0 ©  
à©\0ð\n\0\0\0\0\0\0\0\0
É\t\t\0©\t
éªÀ© ©\0\0 \0°\0š\0
\t  \0\0\n\0\0\0\0\0š\0 \0\0à\0\0\0\0\0° \0\0š\0\0\0 \n\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\t\tüœ­Àð\0\tà\0šÐ \0\0\0\tË\0\0 ¬žðð°Ð° \t\0 \0©à\0° \n\0\n\t\0 \n\0\0\0\0\0© \0\0\0\0°\0\0\0\0 \0\0\n \0\n\0\0\0\0  \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \n\n
úÛ
\tË\0À\0\0\0\0\0šÚ\0ÉË\tÉ©
©\n

\t\n\n\0\0 °š\0š\0\0\t\0°\0©\0\0\0\0\0\0
\0\0\0\0\0  \0\0\0\0\0  \0\0\0\n\0
\0©\0\0\0\0 \n\0 \n\0\0\0\0\0\0\0\0\0\0\0\t\0\r­íà¬ù°\0\0\0\0›É\tðšÐ°žšðÚ\t \0\n\0\0\n\0\n\0°©\n\t  \t\0\0\0\0\0\0\0\0\0\0  \0\0°\0\0\0\0\0\0\t\0  °\0\0\0 \t\0 \0\0\0\0\0\n\0 \0\0\0\n\0\0\0\0\0



Ð\0\nËË\t\t\r­­¯Êžœ°­éé
© šš\0\0\0\0\n\t© 
\nù \0\0  \0 \0\0 \0 \0\0\0\0 \0à\0\0\0\0\0\0\n\n\t\t \0°©\0\0 \0\0\t \0\0\0\0\0\0\0 \0\0\0 \n\0\0 \0\0\0­ °\rðÚÚúÚÚÙ½éúßÚðšš\0\0\0\0\0š\0\0\0\0\0\n
\0»\n\0°°\0\0\0\0\0 \0\0\0\0\n\0\0\0\0\n°\0\0\0\0\0\0 \0\0\n\nš\0\0 \0\0 \t \0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0© °\r\r°¬°ùé\ršÚà½­š
\t \0\0
\n\0° \0©\0\0°°©¬°š\0\0\0\0\0\0\0\0\0\0\n\0\n\0\0\t© \0\0\0\0\n\0°\nš\0
\0\t\n\0\0\0\0 \0\0\n\0\0\0\0\0 \0\t\n\0\t\0\0\0\0°š\r\tÉ¬¼°°­­Ÿ\n ° ššš\0\0°\t\0\0\0  \0\0 \nš\n\0š\n\n\0 \0 \0\0\0\0\0\0\0\0\0 \0°\0\0\0\0\0\0 \0\0\0 ©\0 \n\0\nš\n\0\0\0 \0\0\0\0 \n\0\0\0\0\n\0\0\n\0° °\n\t š\0\0\0\r\t\n\0\0\0\0\0\0\t \n\n
\0\0\0©©\n\t\0š\0\0\0\0\0\0
\0\0\0\0š \0\0\0à\0\0\0\0\0\0\0 \0©\0©\0\0\t©\0\0 \0\0\0 \0\0\0\0\0\0\n\0\0\0\0\0\0\0\n\t \nš\0š\n\t\n\nš\0\t\n\0 \0\0 \0\0\0\0©© \0\0©\n\n\0 š\nš\t\0\0© \n\0\n\0 \0\0\0\n\0°\0\0\0\0\0 \0\0©\0  \0\t °\n\n\0°\0\0\0\0\0 \n\0\0\0\0\0\0\0\0 \0\0\t   °š\n\0°\0 \0©\t¬\n\n\t\0\t \0\0\0šš
\0\0\0š
\0 š \t\0\n\n\t\0\0°\0\0\n \0\n\0\0 \0\0\0\0\0\0 \0\0 
\0 \0\n\0\0\t\n\0 \0\0\0\n\0\0\0\0\0\n\0\0š\n\0\t\t\0\0©\t\0\0\0 š\0° 
\0\0 \0\0
\0 \0\0\0š\n\n\0\0°   \tª
\0\0\0 
  \0\0\0š\0\0
\0ð\0\0\0\0\0\0\0\0\0š\n\0©

\0  °\0 \0\0\0\0\0\0\n\0\0 \0\0\0\0\t\n\n\0
\t\n\0
\0\0\0© \n

\0° °\t \0\0\t\0© ©©\0© \n\0\0\t\t \0\n\0š\0\0\0\0 \0\0\0\0\0 \0\0\0\0\0\0\0\n\n\0\t
\n\0\0
\t\0\0°\0\0°\0\n\0 \0\0\0\0\0\0\0š\n\t\0©\0\n\0\n\0\n\0

\0\0\t\0\0
\0\0 \0°\0\n\0\0\t\0 © š
\t

\n\n\t š\t\n\n\0\0 \0\n\0\0\0\0\0\n\0°\0\0\0\0\0\0\0\0\t\0° \t\n
\0\0©\n\0 \0š\0\0\0\n\0\0 \0\0\n\0\0\n\n\0\0\0š\0\0\n\0\0\n\nš\0 °°\0\nš\0\0\n\0\0\t ©\0\t©\0\n\0\0\t\0š
 \n\0\t\0\0\0 \0\0\0 \0\n\0\0à\0\0\0\0\0\0\0\0 °\0
\n\t\0°©\n\t\0 \0\n\0\0\t\0\t\0\0\0\n\0\0\t\0©\n\t \0 \0 \0\0\0\0\0\n\n\0\0° \0  \0\0\n\n\n\nš ©   ¼š\0\0 \0°\0\0\n\0 \0\t °\0\0\0\0\0\0\0\0\0\0©\0\t\n\0\0\0\0 \0\0\t\0\0\0 \n\n\0\0\0\n\0\0\0\n\0 \0\0\0\0\0 \0 \t\0\0\n\0\0\0\0 \n\0\0\0 \0\0\0\0\0\0 \0\0\0º\0 ° \0\nš\0\0\n\0\0\0 \0 \0\0\0\0\0\0\0\0\0©\0© ©
\0\0°\0©\n\0\0\n\0\0\0\n\0\n\0\0 \0°\0©\n\t \0\0\0\0\0 \0\0°\0\n\n\0\t©\n\n\0 \0\0\n\t   ©

  °š\n\t©\0\0\0 \0©\0\0\0\0\0\0\t ð\0\0\0\0\0\0\0\0\0\0 \0\0š\0
\0\0\0\0\n\0\0\t \0\0š\0\0\0 \0\n\0\0\0\0\0\0\n\0\n\0\0\t\0\0\0°\t\0š\0\t\0\0\0° \0\0\0\n\0 °\t\0\0 š\0© ©\0 ° \0\0\0\n\0\0\n\0 \0\0\0\0\0\0\0\0\0\0\nšš\0°\0 \0\n\0©\0\n\0\0 \0\n\0\0\0\0 \0\0 \n\t \0 \n\0
\0\0\0\0 \n\0\0\n\n\0\0\n\0\0\0\0
\0\n\n\0 \n›
 °°\0 ­©\0\t\0 \t«\0 \n\0\0\0\0\0°\0\0\0\0\0\0\0\0\0 \0© \n
\0\0\0\0\0\0\0°\0\n\n\0 \0 \n\n\0\0\t\0\t \0\0\0\0\0š\0 \0\0
\0\0\t\nš\0š\0\n
\0 \t\t\0©\0 «­°\n
\t\n\n
\n\0\0 °¼°\0\0\0\0\0\0\0à\0\0\0\0\0\0\0\0\0\0 \0š\t©\n\0\n\0\0\0 \0\0\0\t \0\n\0\0\0\t\0\0š\n\n\0\0\n©\0 \0\0\0\0\t\0\n\0 \0š\0\n\0º   \0 º\n°\0\n\t °\0\0
\0\0\nš\0\0\0š\0\0\n\0°\0\0\0\0\0\0\0\0\0\0\0© š\0 \0\0\n\0\0 \n\0 \0\n\0\0\0\n\0 \0\n\0\t\n\0\0\0\0
\0 \0\0\n\n\0\0\n
\t\n\0\0\0\0š¼ \0\t \n \t\t °š
\0\n\t \n\t©  \0\n\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0Ú\0šš\n\0\0\0\0\0\0\0\0\0\0\n\0 \n\0\0\n\0\0\0\0°° \n\0\t\0\0 \t\0š
\0\0\n \0\0 ©
\0š\n\0\n\n\t \t  \n\t¬
\t š\t \0\0 \0\0 \n\0\0°\0\0\0\0\0\0\0\0\0\0© © \0\t\0\0 \0\n\0\0\0\0\n\0\0\0\0\0\n\t\n\0\nš\n\n\0\0\0\t\n\n\n\0\0\0\0\0\0\0°°©\t \0\nš©\t  š\n\0  š\0 \n
\0\0 ° 
\0\0\0\0\0\0à\0\0\0\0\0\0\0\0\0\0\0\t \0šš\0\0\0\0\0\0\0\n\0 \0\n\0\0 \t\n\0\0\0\t\0\n\0\0 \t\0\t
\0 © š
\0©  \0 \0\0\0ªÚ\n\0 \n š¬ š°\nš\0š°\0 \0\0 \0°\0\0\0\0\0\0\0\0\0 \nš\0š\0\0\0 \0\0\0\0 \0\0\0 \0\n\t \t\n\0\0\n\n\0 \n\n\0 
\0 \t\0\0\0 \0\n\0\0\0\0 °©©\n\0\0©\n © \nš\n\t \n\0\n\0\0\0©à\0 \0\n\0\0
 \0\0\0\0\0\0\0 \0\t\0\0°\0 \n\0\0\0\0\0\0\0\0\n\t\0š\0 \0\n\0\0 \0\n\t\t\0\0\n\t  \0\0 \0\n\0°°°°©©© \t\0\0\0š©©©©\n ššš
\t 
\t\n\0\t °šš\0\0\0\t \0\0ð\0\0\0\0\0\0\0\0\0\0© \n\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0©\0
\t\0°\t\n\n\t©\t\0\0\t
\0\t©\0\0\0\n\0\0\0š\0\0\0 \0\0š\t\n\0\0\n š\0\0\t ª
\0 \t\0\n\t\n\0© \0\0\0\0\n \0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0  \n\0© \n\0\0 \0\0\n\0 ©©  
\n\0©©©©


\t© 
\0 \n\0°©© °

\t©© 
©\t\0
\0  °š°ºš\0\n
\n\0\0©°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0 \n\0\0\0\0\0\0\0\0\0\0
\0° \n\0\n\0°\0 © \0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ß­þ','Laura received a BA in psychology from the University of Washington.  She has also completed a course in business French.  She reads and writes French.',2,'http://accweb/emmployees/davolio.bmp'),
  (9,'Dodsworth','Anne','Sales Representative','Ms.','1966-01-27','1994-11-15','7 Houndstooth Rd.','London',NULL,'WG2 7LT','UK','(71) 555-4444','452','/\0\0\0\0\r\0\0\0!\0ÿÿÿÿBitmap Image\0Paint.Picture\0\0\0\0\0\0 \0\0\0PBrush\0\0\0\0\0\0\0\0\0 T\0\0BMT\0\0\0\0\0\0v\0\0\0(\0\0\0À\0\0\0ß\0\0\0\0\0\0\0\0\0 S\0\0Î\0\0Ø\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0€\0\0€\0\0\0€€\0€\0\0\0€\0€\0€€\0\0ÀÀÀ\0€€€\0\0\0ÿ\0\0ÿ\0\0\0ÿÿ\0ÿ\0\0\0ÿ\0ÿ\0ÿÿ\0\0ÿÿÿ\0Ù™Ù™™™¹ÙùÙÙÙ™ÙùÙ™½ŸÙÙÙÙÙßÙùùÛÛÙÛÙÛŸÙýÿÿÿÿÿÿÿÿÿùÙùÛý¹ù½ùùÙÛÙ½Ÿ™ÛÙ™™™½½›ÝÙùÛÛÙùÙÙ›Ù™Ù™Û™Ù™ÙùÙùÙÙ™››ÛÙŸ™™ÙÛÙý½½½½½Ÿ½™ýŸÙýÙÿÿÿÿÿÿÿÿÿÛß½ÙùÛÙÝÙÙÝ½ÙÙÙ™™™ÙùÙÙÝ™½Ÿ½ŸÙÝ™¹ÛÙ™Ù™Ù™Ù½½½ÙÙÝÙ™™™™ýŸŸÙÙÙÙùÙùÙÛß™ùßŸŸŸÿÿÿÿÿÿÿÿÿý™ß¹ßŸŸŸŸ›ÙùŸŸ½ùÙ™Ÿ™½ÙÙùùùÙÙÙ›Ù™™Ÿ™Ù™™Ÿ™ùÙ›™›™Ù™ÙÙŸÙÛÝý½½ŸŸ™ßŸÙýŸßÿÿÿÿÿÿÿÿÿûß™ÙßÙùÛÙÙÙÙÝÙÙÙÙŸ™™™™¹ÛÛÙÙÙ½ŸŸ›Ù™ÙùÙ½™›ÙÙ™™ùùÙÛ™™½™ùÝ¹ùÙùùÙÙÛÙ½ŸÙÿÿÿÿÿÿÿÿÿÿýÛÛ½Ÿ½½½½™ùùŸŸŸ™Ù™™Ù½Ÿ™ùÛÛÙÙÛÙÝŸ™™½™™™Ÿ½›ÛÙý›Ù™™™ÙßÙùÝùùÛÙÙùÙÙÙýùßÙýßÿÿÿÿÿÿÿÿÿÿŸÛÙùÙÙÙÙÙýùÙÙÛÙù™™™ÙÛÙÙÙÛÙÙÙÙÛÙÙÙ¹Ù™ÙÙÙ™™Ùù™Ù™ùÙ¹™™ùŸÛß½Ÿ½½½Û½ŸŸÿÿÿÿÿÿÿÿÿÿÿÙý½½½½½ùùÙ½ŸŸŸ™™½½Ÿ½Ÿ½ŸŸ½™™½Ÿ›™™™ÙÙ½›Ù›Ù™Ù™ùùŸÙÛÙÙÙùÙÛÙÙÙÙÙÛßÙÿÿÿÿÿÿÿÿÿÿÿŸ™ÙÙßÙùÙÝÙýÙÙÛÙÙÙÛÙ™™™ÙÙÙÙÛÙÙÙÛÙùÙÙÙŸ™ÙÙ™™ýŸ›ÛÝùŸ›Ù™™ÙÝŸ½½½ŸŸŸŸŸ½›Ý½ùýÿÿÿÿÿÿÿÿÿÿÿÝùý½½½¹ù½™ùùÙÙùÛÙý™›ÙŸ½Ÿ½½Ÿ›ÙÙ™™ù™™ÙÛ™ý™ÙÙÙÛ™™ÛÝ¹ÛÙÛÝÙÙÙÙÛÙÙÙÛÙýŸÙßŸÿÿÿÿÿÿÿÿÿÿÿûÝÙùÙÙÙÝÙýŸŸ™™Ù™ùÙÙùÙÛÙùÛÛÙÙÛŸ™™™™™Ûß™ÙÙŸ›Ý¹ÛÙÙ›½½ÛŸŸŸŸÙÙùùùÙÙý½ùßÿÿÿÿÿÿÿÿÿÿÿý™ùŸ½½ùùý¹ÙŸŸ½Ÿ™™Ù™½ŸŸŸ½½ÙÙÙ™ÙÙÙ™Ù™Û½Ÿ™ÛÙ™™¹ÛÝÙÝùßÝÙ½½½½½ÛßÿÿÿÿÿÿÿÿÿÿÿÿýýŸÝ½ÙßŸÙÙùÙùÙÙù¹ÙÙ›ÙÙÛÙÛÛÙÝùÛÙŸŸ™™ù™™Ÿ™ÙÙÙÙÛÙÙÙý›ÙÙ›Ù¹Ù™ùùùùÙÛÛÛÙÙÙÛÝßÿÿÿÿÿÿÿÿÿÿÿÿŸÙ½ÛÙùùù½™ÙùÙÙùÙÛ™¹ÙÙŸ½½¹ùŸ™ÙÛ™™™™ŸŸ½ŸŸŸ™ÙÛÙ™™ÙÛÝÙÝ½ýùŸŸŸŸùùÿÿÿÿÿÿÿÿÿÿÿÿÿÙßÛÝÙß½›ÙÙùŸ™ùŸÙùùÙÝùùÙÝ™ùÙ™™ÙùÙÙÙÙÙÙÙÙŸ™Ÿ™¹ùŸŸŸŸ™ùÙùùùÙÙßŸßÿÿÿÿÿÿÿÿÿÿÿÿÿý½¹ùùý½½¹ÛÛÙùÛÝŸ™™™Ùý½Ÿ›ÙÙÛÛÛ½›™™½™½½½½Ÿ›Ù™›ÙùýÙßÛÛÝÙÙ½½½ùŸÿÿÿÿÿÿÿÿÿÿÿÿÿùÛßÝÙÙÙÝ™ùÙÛùÙ½™ÙÙÝÛßÙùÙÙÙùÙ™Ù™›ÙÙùÙùÙùÙÛÙÙÙß™ÙÙÝ›Ù™Ý™ùÛßÙÙÙùùÙÛÛÙßÝÿÿÿÿÿÿÿÿÿÿÿÿÿÿÝ¹ÛÛŸŸŸ›ÛÙùÛÙÙÝ¹Ý™™½Ù™Ùý½½½½¹ýŸ½½™™ÙÙÙÙÛÙùÙÛÙÙùÙ™™Ÿ›Ý™ß™Ûß½™ŸŸ™ÙùýŸ¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿ›ÛÝÙÙÙÝŸŸ™ÙŸÝ™½½™ÙÙùùÙÝÝùùÙÙÛÙ™Ù½½ŸùùÙùÙ½™Ù½½Ù™ùŸÙÙÛÙÙÙÙÙýŸ™ùùÿßÿÿÿÿÿÿÿÿÿÿÿÿÿÿÝÙÛŸ½½ùùùý½Ÿù™ù¹ÙÙÙý½ŸÛ›ÛùÛÙÝ™››™ÙùÙù™ÙÙ™Ù½Ù½™ÝÙŸŸ½½½½›ÙÙý™ßÙÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿûŸÙÙùÙÝÙùÛÙÙùù™Ýù¹Ù™ùÛÛÛÝÝÙý™ÛÛÙ™ùÛÙ½Ý½½Ù½Ÿ™™Ùù½Ù™¹ß½ŸÝŸŸŸßŸýÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿýÙý½¹ùùù½ŸŸ™Ù™ÙùÙ½Ý¹ù½Ûß›ÛÙÙ½™™ßùÙùÙùÙ½™Ù™½Ù½™Ý™Ùùù›ÛÛÙ›ÙÙÙÙŸÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿŸ™ùÛÙÝÙùù™™Ý½Ù¹ÛÛÛÙÝÝ½™ÝŸÛÙ™ù½½Ÿ½™ÙÝ™Ù›ÙÝ½½Ù™Û½ÛÝŸÝŸŸŸ›ßýÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ½½½½½½ÙýùŸ›ÙÙÛÛÙù™ÝŸŸŸ›ÙýÛÛÙÛ™ÙùÙÙÛÙÙÙÙù™Û™ÙÙùÙÙ™ÙÙÙÛÛ›ÛÛÙ›ÙÙÙÝŸÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÙùùÙùÙÙÝ™ùù½™™ÙÝ¹Ÿ™Ù½™½›ÛÙÙÝÝ½ŸÙÛÙÛÛÙß½Ÿ½Ÿ½ù™ù½½¹™½½™ÙÙÙßÙùùý½ŸßÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿýÙ½ŸŸŸŸŸÝÙÝ™™ÙÙÙÝ½ÙÙý™Ý½½¹ŸÛÙùùÙÙÙÙÙ½ÛÙÙÙÙÙùÙÙÙ™™ÙÙùÙ½™Ù™ÙùÙùŸŸ™ÙùÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿùùÛÙÙÙÙÙÙÛÛÙŸ›ÙùÝù½¹Ù½™Ý¹ÙÙÙÝùÙß½½½ý½Ý½ŸŸŸŸŸ½ŸŸÙùÙÙùÙÙùÙ™™ß½½½ÛÛÛÛŸÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿýŸŸŸŸŸŸŸŸÙ¹™ÙÛ¹ŸŸŸŸŸùùÛÙÙ™ÛùßÙÝÙÙÙÙÙ™ùŸ™Ù™½™ÛÙ™ÙÙÛÛÙßÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÙÛÙÙÙÙÙÙùùÙ™Ùù™ùŸŸŸ™ÙÙÛÙÙÙÙÙýŸÝŸÛßÝßùŸ›ÛŸŸ½™Ù½ŸÙùÙÛ™ÙÙŸÙùŸŸŸŸŸ™ù½ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿŸ½½½½ŸŸßý™ß›ÙÙÛÝ½½½½Ÿ›ÛÙ½›™½ùßùÝÝÙÙÝ½½™ÙÙÙ¹™Ù™Ù›ÙÙ™ÙÙÛÛÙÙÙßßÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÙÙÙÙÙÙùÛÙÙÛ™ÙÙ™Ù™ÝŸ™¹ÙùÙÝ½ÝŸÝùÝÛßÙÝùß½¹½½¹ùÙÙÙùÛÙý™™™ù¹Ù½¹ùÙÛÛÛÙŸŸÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿùÛÙùùùÙÙÛÛÙÝŸ™Ý¹Û¹ÙÛÛÙÙ™ÛÛÛÝ¹ùýŸ½½ŸŸŸ™ýÙÝÙÙÝ½™ùÙÙ½™ÙÙŸ™Ý½ŸÙßÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿùÙùÝŸŸŸ¹Ù¹™ßŸŸŸÙùùÝ™ùùÙÛÛÝýÝýŸ¹ý½½ùùùÙÛÛÛÙ™™™Ù™½ÛÙ™Ù½½¹ÛÛÙ½Ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ½½ÙùùùßùÙÙŸÙŸ™Ÿ›ÛÙŸŸŸÙÝŸŸÙÝ½ÛÛÛÙÛÝÙÙÝŸ™ÛÙ™½ŸÙÛ™ÙùÙ½ŸÙÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿùÛÛÙÙùÛŸ™ÙŸ™Ù™ŸŸ½ÛŸ™ÝŸÙÙÙß›Ý½ùßýýÝýùÙùŸŸ›ÛÙùÙùÙÛ™ÙùÙÙ™ù›™ÙÙùÙ½Ý½½ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ™ÙÙùÙùÝŸ½ÛÙÙ¹ÙŸÙÛÙÙÙ™Ù™ŸŸŸ¹ÝÛÛß½ŸŸŸùßÙÙÝÙ½Ÿ™Ù™™›™Ý½™Ù¹ÙÙùÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿß½Ÿ™Ù™ùÙÙÙ›™Ù¹ÙŸ½™ŸÙÛÙÙùÝ½½Ùýýýýùýùß½½¹ý½ÙÙÛÙÙÙŸ›ÙÙÙ¹ÙÙÙ¹ÙÝ¹ÙùùÝÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ½ßùÙùÛß™ÝÙ¹ÙÙ™ÛÙÙùùùß™ŸŸ™ÙÛÛß½ÛÛßÛÝ½ÛÝÙÝ™Ù½½Ÿ™ÙÙ™™Ý¹ù½Ù¹ÙÛŸ¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿùÙùù™Ù½™ß™½™Ù™ÙùÙùÙ¹ÙùùùÛÙßÛÝ½ÙÿßÿßßÛÙùÛŸÛùÝ½›ÙŸ™™Ù™ù™™Ù™ù½ÙÛÛßÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿýÛÙÙýùý½½ŸÙÙÙ™ù¹ÙùÙÙÙ½½ÛÝ½½Ÿý½ùýùßÙÙ¹ÙÙÝ™ÙÛ™™ÛÙÙÙÙ™™ÙŸßÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ½™™ùÙÛÙŸÛ›ÙÙ™Ù½ŸŸŸ™ùÙùÙùÙùýÛßßý\0ŸßßŸßùßÛßÙùù½Ÿ™›ÙÙÙ™ù››ÙùŸŸ™ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¹ÛÝ½™›Ù™›ÙÛÙÙÙÝ¹½ŸÙùßŸùýÿ›ßŸßý½™ÛÙ™ùÙ™ù›Ùù™ÙÛ™™ùÛÙßÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿùÝ™ÙýŸ›ÙùÝ™Ù›Ÿ™Û™ÙÛÙŸ›ÙÙÙÙÛßŸÙýýŸÛß\tŸÿÛßÛßÙùýùß½›Ù™™Ù™™™ÙŸÙÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÙÛ½½™™ÙÙÙÛ¹Ù™Ù™ÙßŸŸŸ½™ÝŸ½ýýýÙ™Ýýùý½ÙÙ™ÙÙ¹Ùù™™™™¹™›™ù½™Ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ™ÙÙÙý›Ù™ÙÙ½™›™ÙùÙÛÙÛÛÙùÝýùýßÛÛýÿ
\0Ð›ŸýŸùÛÛßŸÙùŸÙÙÙ›¹Ù¹ÙùÙ™ÙÙÛßÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿùÝ½Ÿ™™ùÙŸ¹™™Ÿ™ÙÙÙÙ½Ÿ¹ÛßŸùýýÿßÉÙ\t\tßýùÝ™ÙùŸ™Ù™™™Ù™™™Û™™™Ù™ßÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ›Ý¹ÙÙÙ½™ÙÙÙÙÙ½¹™ÛÛÙÙ½½ŸŸÝ½ýŸßŸßÿ›™É\0½Ÿßùýùý™ÙÙ½›™™™™™™™™½›ÙŸŸÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ™¹Ÿ™Ù™ÙÙ¹›™Ù™™Ù™ÙùÙÛÙùÙÛÝûÛý½ýÿý\0é\t\tùýùÙÙ™Û™ÙÙ™Ù™Ù™™™Ù™™›ÙŸÙßÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÙÙùÙÙÙ½™›ÙÝ™™ÙÙÛ›Ý¹ÙÙÙÙÙý½ÛÝýßßýýÿ¹Ú\t\0\t›ŸùßÙÛÙÛÙ¹™™™™Ù™Ù™™™™™™™ÙŸÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿù½™™™Ù™ÛÙ™™™ÙÙ½›™ÙŸŸŸŸŸÛÙùûýùÿßß\0Ë™\tÛ\0\0Ÿ™Ÿ™Ù™Ù™™™™™™™™™™™›Ù¹ßÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿùÙÙù½½™™›™™™›Ù™Ù½™ßŸÙýßßÝÛßßÿÿ°\0™\0\0ž½ŸÙÙŸ™™Ù™™™™™™™™™™™™½™Ýÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿý™½™ùÙ™™™™ÙÛÙ™Ù™¹ÙŸ™ŸŸŸŸÙùùÿÿýÿßßÚ™\0\t\t\t™½™™™™™™™™™™™™™™™™™™ù™ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ™Ù™™™Ù™Ù™™™¹™Ùù™ÙÛÙÙÝùùßßßÛßßßÿÿ\t\0\t\t\t\0™\0\0™™™Ù™™™™™™™™™™\t™™™™™™ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ™™™Ù™Û™™™Ù™™Ù™ù™™Ÿ›½½¹ßŸŸÛßßýÿýÿÿšð\0\0\0\0™™™™™™™™\t™™™™\t™™™Ù™™™ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÙÙù™™™™™™™™™Ù™ùÙ™ùÙÙÙÝ½Ýý½ùÿßýÿÿù\0\0™
\t\0\0\0\0™™™™™™™™™\t\t\t™™™™™™½Ÿ›ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿù™™™™™™™™™ÙÙ™Ù™™½½ÛÝ¿Ÿßßýÿßÿýš\0\tÛ\0\0\0\0\0\0\0\0\0\0\t™™™™™™™™™™ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿù™™ù™™™™™™™™™™™™ÙÛÙ½ŸŸÝùùýÿßÿù¹¿œ™\0š\0\0\0\0\0\0\0\0\t™\t\t\t\0\t\t™™™™™™™›ÿÿÿÿÿÿ¿ÿ¿¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ›™™™™™™™™™™™™™™™™™½ÙÿÙùßßßßÿÿ™Ü\t\0°\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0™™™™™ÿÿÿÿ¿ûßŸýÿŸ¿Ÿûÿÿÿÿÿÿÿÿÿÿÿý™™Ù™™™™™™™\t™™™™™™™ÙÙ½¿ßùÿßÿù™É©ÿ™\t\t\n\t\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\t™™™™™™Ÿÿÿÿ¿ÿ¿û¿¿ûûùû›ÛÛùÿ¿ÿÿÿÿÿÿÿ™™™™™™™™™™\t™™™Ù›ßŸŸßÛÝÛßýÿù\tðŸßù°
\t\0\t \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0™™™\t\t™™™Ÿÿÿýùûù½ÿû½½¿½¿›½¿½ý»ÛÿÿÿÿÿÙ™™™™™\t™™™™™™™™ÙÙÙ½Ûýýÿ¹\tù½ÿ\t\0
\t\0¹\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\t\t™™™™ÿÿ»ÿ½ÿûÛýûûÛûÛý½½»¿Ûÿ›ûÿÿÿù™™™Ù™\t™™™\t\t\t\t™™™ÙùùýÛÝÿÿ\t\t\0\t
œ›\0ž›À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0™™\t™\t™Ÿÿû¹ÿ¿Ÿ¿Û½½½½¿›ûûßÛÿŸÿŸ½¿ÿù™™™™™™™™™™™™™™™½™ý¿™™\0\t\0°Û\r
\t\t\r\0\t\0™\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t™\t™\tŸÿ™ûÿûùûùûÛûûûÛ½ùùû»ùûù¿ŸŸÿù™™™™™™™\t™\0™\t™™™™Ù™ÙùÛßÛÙ\t\0\t\0\t\t½™À›Ú
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t™™™
ÿ©¹½½¿½¿¹ùùý½½ûûÿ½ý¿½¿Ûûù¿ù™™™\t™™™\t™™™™™™¹ÙùÛÙ™™\0\0\t\tÙ\t°\0™\0\0\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0™\t™ù™½»ûÛûÛÿ¿¿›ûûŸŸŸ¿¿ŸŸ›½½¿¿™™™™™™™™™\t™™™™\t\0\0\0\t\0\0
ð­\t\t™ù\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0™™Ÿ°›
ŸŸ¿Ÿ¿›ÛÛÿŸÿûÿ¿ÛÛûûý»ùù»™™™™™\t™™\t\t\t™™™™™™™\0\0\0\0\0\0\0ù\0\0™ÙÙ\0
š\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t™™ð\t\t™ý¿½½½½ûûùÿŸ½ùý¿¿ÛÛÛŸ›ùù™™™\t™\t\t™™™™™™™™\0\0\0\0\0\0\0\0\0\t\t\t\t›™\0\0¼\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\tŸ›››½»ûûû½½¿¿ùÿ¿ûûÛÿûûùû›š™\t™\t™™™\t\t™™™™\t\0\0\0\0\t\t\t\0\0\0šÐ°\0ðù\tÛ\t\t\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t™Û\t\0½»ÛÛÛß¿¿ÿÛûùùÿŸùûŸŸ¹½½™©™\t™\t\t\t™™\t™\t™\0\0\0\0\0\0\0\0\0\0\t\tš\t™Ë°\0\0¹
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0››½¿¿¿»ßÛù¿ŸŸ¿½ûÿ½ûùÿÛ›¹™\t\t™\t™™™\t\t™\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\t\t­\t\t\t\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\t\t\t›ÛÛß½½û¿ŸùûûßŸ¿Ûß¿Ÿ¹¹ù°™\t\t\t\t™\t\0\0\0\0\0\0\0\0\0\0\0\0\0\t ™¹ûÐš\0\0\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0½»ûùûÿ¿Ûù»¹½»ûÛÿûÛùÛû™©\t\0\t\t\t™\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\n™\0Ï\r½™\0
\0š\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t
ŸŸ¿ŸŸ¹½¿¿›ÛŸ½¹ûùû½Ÿ¹››™\t\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\r­¹™ûž \t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0™ùûÛûûÛû›»™½½»ÛÿýûùûùÛ\t\t\0\0\t\t\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0\0\0\t
Ð
\t™™\t©\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0›¿½¿½½½¹ùÙŸ¹¹½»Û›»ÛŸ›¹™°\t\t\0™\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\n™ËÉ\0°\0š\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\r½¿½»Û¹ù›¹¹™½¹ù¿ÿß½»ùÛ\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\t\t\nù
›°\t\0\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0™¿›ûÛùù»Ù››Û››Ÿ™¹¿Ÿ™û½°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0š™\t\t\rû©\0š\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ùûÛù››Ù¹½½¹ùùù¿Ÿ¹ûûŸ›™\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0©\tÀ°ùË
\0œ\0©\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0›Ÿ½»›»Û››ÛÛß›ùùù›Ÿ™¹ÿ›\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\t\t\t\t©\tß\t\0š›\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0½¹ûùùÙ¹¹ù½½»ý¿ŸŸ½¹ÿŸ›ù¹\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t›Éù­\t\t\0™\t\0©\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ûÛ››¹ŸŸ›ÿß¿ÛûùùÛ›ùù¿\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\nšÐšÙŸ°š›\0 \t°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0›Û½½¹Û›¹ÿÿÛÿÿÿßÿ¿¿Ÿ›¹ù¹\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\t\0\0½\t
ÙþŸœ¹©\t™ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t½»Û›™¹ûßûß¿ûÛÿ¿ùýùù½Ÿ½°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
¯™¹
\t\t
\r
\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\nÛÛ¹¹ÛŸŸùÿ¿ÿÿÿÿÿÿûÿûÛ¹¹ù\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\t\0\tý
Ð\n›\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t¹½½¹¹ûùÿÿÿÿÿÿÿÿÿÿûß½›Û›\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\n\0½ùú™©¹é\t©\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t¿¹¹™½½ÿÿÿÿÿÿÿÿÿÿÿÿÿÿ½¹ù\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\nÉ\0°\0°ýýœ\tš›\0™\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ÿ›Û\t»Ûûÿ¿ÿÿÿÿÿÿÿÿÿÿûÛÛÛ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0™\t\t\t™ÿù\t»\t\0\t\0\t
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
\0\0\0\0\0
ù½›Ù¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿½¹\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ÿ\0\t\n\tËÛÉßÛÙ›¹š°\0\nœ\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0šð\0\0\0\0¹½¹¹¿Ûß¿ÛÿÿûÿÿÿÿÿÿÿÿÿÿŸ›\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð\0\0™
\t\tŸùé¹\0©
\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0Ÿ››Ÿ½¿ûÿÿÿÿÿÿ¿ûûÿÿûÿÿýûý\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0°\0ÐšßŸž™\0½°\t\0\0š\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\nÐû\0\0\0ù»ÛÛÛÿÿÿ¿ûÿ¿ùÿŸÿÿûÿß¿ûùû\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0›\0\0\t\t\0\t©­¹ùÉéŸ

\t\0°\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t Ï\0\0\t»Ù¹ûÿûÿ½ûß¿Ûÿ¿ûùûßÿ¿ÿÿÿŸð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\t\t\0\0\t
ÙÛÞŸ™›ÉÙùùú°\tÊ©\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0û›°\0\0›¹ÛŸ¿ÿ¿ûÿ¿ÛÿŸùÿÿÿûÿÿ¿ÿÿûß\0\0\0›\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð½ÿËÉ½¯›\t\t
\n™\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t¯šÿ\0\0\tùŸ¿ÿý¿ß¿½ÿ¿Ûÿ¿ùùûÿÛÿß¿ŸŸû\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0\0\0\t›
ÛÙùù™Ð›©é\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ž\t\0žù\0\0›¹ûÛÛûÿûßÛùÿ¿ÛÛŸ¿ÿÛÿß¿ÿÿÿ½ù\0\0Ð\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0ù¿ùËœ½¹šÚš\t»\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¹°ÿð\0\0\tŸ›ûÿÿÿ¿ûÿÿ¹Û™¹ùÛÛÿÿ¿ûÛûùÿ¿\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
\t
ËßÝ¿ž™«ÉÐ
™™\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0©ÿ\0\0›ý½¿Ÿ¿Ûß¿›Û™¹Û›™½½¿ÿÿÿÿÿ›Ûð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0 \t\0š™ÿŸ½™\t¹›\t° ™ \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0û\0\0\0›Ÿ›ûÿÿùÿ¿Ûù¹ýß½ýÿÛÛý½½½½¿ÿÿÚ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0™\t\tŸýžŸù½©Û
°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0›\0\0\0½ûÿŸ½¿Ÿûù½™ýûûÛÛ½¿ýûÿûûÿÿŸŸ¹\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0©\0œ\t
š¼¹Ûÿýý\0­©»\t°\t\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\r»Ÿ›ýûûÿ½½¹ÿûÛßûÿÛù›½½½¿Ÿÿÿÿ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\t
Ÿ™É¼™œ¹ûÿ½Ÿ°Ú°\t¹°\t°\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ß¿ùûßý¿Ÿ›Û™Ûÿ¿ý¿ÿÿŸ™¹û›Ûûûûýð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n°
›\n›ÚÛßŸÿß›¹\r»û\t¹©\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0½¹ù¿¿¿›ùùù™ûŸûÿûÿùÿÿ½\t™\t¿ÿßßûð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0½\t\t™
Ð¹Éý½ÿŸ½š›
Ÿ¹°°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
Ûÿÿÿßý¿Ÿ›™›ùÿ½ÿ¹ûÿÿ¿ù\0\t›ÿÛûûßù\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0°šœ½
›Ÿýùð»°°¹°¹\t
\t \0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t½¿Ÿ¿¿¿¹›™\0½¿Ÿ››™™¹Ÿ›¹\0\0ŸŸ¿ÿÿûû\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\té
Ð¹
™
\r™ùÿ¿ý™
ë\t\tš›šœ°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿ŸûÛßÛÛ™\0\t
û›™™Ù¹™™™™™Ÿ›¿ÛûÛýÿÐ\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\t
Ð©Ú°ù\tÛÛ\t½¹\nš›\0©šš\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿Ÿÿ¿ÿ¿¿¹\0\0™™™™½›Ÿ›¿¹½½»ßÿûÿ»\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0
›\t©°š™ýž¿¼°
°©\t°Ûš™©°\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ù\0\0ùÿ¹ùûÛùŸ›™™™™ŸŸ¿Ûùùûß¿ÛÛÛý¿ŸŸÿÐ\0\0\0\0\0\0\0\0\0\0\t\0\0\t\nŸšùš¹°ùùÐ\t\t¹©¿©©°ùð
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿¿ÿûÛ½¿¹½»ÛŸÛÿÿ½¹¹ûÿß¿ß¿›››Ÿ»ÿûý\0\0\0\0\0\0\0\0\0\0\0\0\t\0\t\0ý\r¹°›

ÉÿË«š°
\0©°š›¹\tù©°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°\0\tùùûÛ½›™ûÛÛýûý¿››\t™›Ÿ¿ûûÛù½¹ùý»ßû\0\0\0\0\0\0\0\0\0\0\0\0\n\0›Ù\tÛËÙù°\t
Ÿ\t«Û\t\t\0š°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ûÿ½½»ùû››ŸŸ¿ûùð™Ÿ›Ùùùÿý½¹›ŸŸ›ß¿ù \0\0\0\0\0\0\0\0\0\0\0\0\0\tðð½¯Ÿ\tŸùéùíé\n½¬\0\0\t
šš\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ŸŸÛÛûŸ™¹ÛÛûûý½¹¹½¹Ÿ››ÿùûÛ™ùùù¿ùÿûÐ\0\0\0\0\0\0\0\0\0\t\0\t\t¹\t™ËÙù¹°
\tÛßš›™°š›š\t \0
\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0«ûû¹ùùûÛ›Ÿ™ý¿¿›™›Ÿùùù™¿Ÿ¹¹½¿¿ßŸ¿ÿ\0\0\0\0\0\0\0\0\0\t\0\t\0\0žšùðÚ¼Ÿßù©\0\0\0ù \0\0\0°\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t¹¹ÙûßÛ›ŸŸ½¹›ÿ¿Ÿ›™™ŸŸÿÿŸŸŸùùŸŸÛÛûùùÿ\0\0\0\0\0\0\0\0\0\0\0\0\0™\0ý\0©©ýÛÛýýÿ\0\0\tšš\0\t\0\0\0\n\0™\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ŸŸŸ¿½»›Ûùùûù¹›Ûûùùûÿÿÿÿÿÿý»™¹ÿ¿ÿßÿÿÿð\0\0\0\0\0\0\0\0\0\0\t\0\0\t©\t\t Ÿ°œŸŸ¿ùËÿý\0\t™«\0\0\0\0\0\t\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ðÿ¿ûßŸ½¿ŸŸûßŸ™½¿ŸŸŸýÿÿÿÿÿÿÿ½¹ßÛýÿ¿ŸùûÚ\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0½©\t\t\t\t
›ËÙ™ŸŸÿ\0\0\0\t\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0™ûß½»ûÛù¿¿Ÿûùù™Ÿ¹ÿÿ¿ÿÿÿÿÿÿÿ™›ûÿÿ½ÿÿÿÿù\0\0\0\0\0\0\0\0\0\0\0\t\0™\tÉ\0\0°\t½\rŸ°šÿß\0\0\0\0\t\0\0\n\0\t š\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0¹ÿ¿ûÛÛùÿÛßûßÿÿ¹¹ÛŸÿÿÿÿÿÿÿÿÿ¹ùÿÿÿÿÿÿÿÿÿ\0\0\0\0\0\0\0\0\0\0\t\0\0\0éŸžÛ\r™
É
Û¿\0\0ð\t \0\t©\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ÿùû¿¿Ÿ½¿ûßûßùÿ™¹ÿûßÿÿÿÿÿÿù™ÿÿÿÿÿÿÿÿûû\0\0\0\0\0\0\0\0\0\0\0\0\t\0ü¹\túÛ™\r\tð›Ù­ß\0\0šž\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÿ¿¹ûùý¿ûÿÿûÿûÿùù™ûßÿÿÿÿÿÿÿÛÿÿÿÿÿÿÿÿÿÿß\0\0\0\0\0\0\0\0\t\0\t\0\t
ÛÞž½¼\0™¹ù¿\0\0\t\t \0\n\0\0\0 \t\0\0\0\0\0\0\0\0\0\0\0\0\0\0
ÛÛÛ›ÛûùÿÛýÿŸÿÿÿûùŸ¿ûÿÿÿÿÿûùÿÿÿÿÿÿÿÿÿÿÿ°\0\0\0\0\0\0\0\0\0\t\0\0¹ùÙ\tß›\0
Ðù\0™\t©\0\0™\t\0\t\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿ÿ½½½½¿¿ÿûÿÿÿÿÿÿûùùÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿ð\0\0\0\0\0\0\0\0\0\0\0\0°
\t\t

½ýÿ\t½ð¹É\0\0
\t\0\0\t \0\0\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0›ß¹û›¿¿ÿßÿÿÿÿÿÿÿÿÿÿŸ½ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÛ\0\0\0\0\0\0\0\0\0\t\t
\r\tÏýù
\t\t\t\t¹\0\0°\n\t\0šš\0\0\n\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0½ûÛ›ŸÛÛÛÿ¿ÿÿÿÿÿÿÿÿÛÿÿ¿ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ¿\0\0\0\0\0\0\0\0\0\0š\t›\t©ù»›¹\t\t\t«\t\0\0\t\t\0°\0\t\0©\t\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0ûÿ¹ý¹¿ÿÿÿÿûÿ¿ÿÿÿÿûÿ½¿ßÿÿÿÿÿÿÿÿûßÿÿÿÿÿÿÿÛð\0\0\0\0\0\0\0\t\0\t\t °
\tÛœ\nœ¹°ù°°\0 \0

\0š\tÉ\0\0\0\0\0\0\0\0\0\0\0\0\tÿŸ›¹››ÿ¿¿ßýÿÿÿÿÿýÿùÿûÿÿÿÿÿÿÿÿ¿ÿûÿÿÿÿÿÿÿ½°\0\0\0\0\0\0\0\t\n™\téðÜ½­»ùœ¹\t©ËÙ\0°\0\t 
\0š \0\0\0\0\0\0\0\0\0\0\0\0\0\0¹¹½»ÿÛÿÿ¿¿ÿÿûý¿ûÿ¿ûßûÿÿÿÿÿÿÿÿ¿ÿÿÿÿÿÿÿÿ›Ð\0\0\0\0\0\0\0\0\0\t\nŸ™\t¹ýŸ\rÿÚÛšŸ¹


\0°š\t °©Ê\t\0°\0\0\0\0\0\0\0\0\0\0\0Ÿ½¹ùùŸ¿ßŸÿÿ¿ÿýûÿŸûßŸÿŸÿÿÿÿÿûùûßûûÿÿÿÿÿÿ™°\0\0\0\0\0\0\0\t\0°¹©
\rûÿÛÝù©¹\rÿœð\0\t°\t\t\nš\t
\t\t \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÿ›»\t›ÿÿ¿ûùÿý¿»ÿÛûŸ¿ùûÿÿÿÿûý½¿Ÿ¹ŸŸ¿ÿÿÿÿÿ°ù\0\0\0\0\0\0\0\0\t\0°©\0œ›\r½ûýù\r¹Û›° ¹\0\0°\t \n°
\t\t\0\0\0\0\0\0\0\0\0\0\0\0››™\t°\tûÿûÿÿ½ÿÿß¹½½½¹¿ß½ÿÿÿÿûû›™›™½ùÿ¿ÿÿÿÙ°\0\0\0\0\0\0\0\t\0™\t½¹©É¹\rÿý½°Ù°É\0\0°\t\tË©
û°\t \n\0\0\0\0\0\0\0\0\0\0\0\0\0ù\t\t\t\0›ŸÛßùûÿ¿›¹›š››Ÿ›¿Ûÿÿÿý½›Ù¹½¹ù¿¿ßÿÿÿ¹ù\0\0\0\0\0\0\t\0\t ­
\r°\0¿ùÛß\týšš\n›
ðººÛ©©\nšš\0\0\0\0\0\0\0\0\0\0\0
°\0Ÿÿ¿ûÿ¿Ûù½™ù™™™\t½ù¿ÿÿÿ»û¹››Ù½»ÿßÿÿÿÿ°\0\0\0\0\0\0\0\0\tÚÙ°¹Ù©Û\t½ù\tš\0\0°›Ÿ¼»š¹© ©©\0\0\0\0\0\0\0\0\0\0\0\t\0\0
ŸûÿŸß½¿››šŸ›\t››Ÿýÿÿÿß™›™
š›¿¿ÿ¿ÿŸ›\0\0\0\0\0\0\0\t
\t°
\t©\t\0™ËßðÙÿ\t©\0©«

°ûšš\0°
\n\0\0\0\0\0\0\0\0\0\0\0\0™\r\t\t\0¹ýûûûû›\t¹™¹™›¹»¿ÿÿ¿ðŸ°\t
™™›Ÿÿÿ
\0\0\0\0\0\0\0¼žŸð°ú½½½\t\r­\rß š°¹
ÿ©©°\0°
\0¹\0\0\0\0\0\0\0\0\0\0\0\t©»š\0
ÿ¿¹ù¹™™\t\t\t­¹\t¹ŸŸßÿÿÛ›½\t\0\0\t\0\r¹ùÿÿ™\t\0\0\0\0\0\0\0\0\t©\t\të°œ™\tÙïÛ\0™ÿ™»ù\tº›
\0¯ÿ\n\0\0°\0\0\0\0\0\0\0\0\0\0\0\0ŸŸ\0Ÿ›ßŸ›™\0\0\0\0\0\0Ÿ\0\t\t›Û¿¿ÿ¹\t\t
\0\0\0\0š¿ÿÿ\0\0\0\0\0\0\0\0\0™ð\t¹ËÉûðŸ›Ù\0\tùÊ\t
\n\t\0©«
¿ë¿ð°

©©\0\0\0\0\0\0\0\0\0\0\0¹°\0\0›ÿ¿¿½½°\0\0\0\0\0
™\0¹½ÿÿ½½¹\t\0\0\0\0\0\r¹¿ÿÿû\0\0\0\0\0\0\0\0\0©©
\t¹ûÉÛÐÐ½¹
šÛ™ž™°\0°\nšßü¿ÿÏ©­¼Ú\0\0\0\0\0\0\0\0\0\0\0›™\t\0\0\r½½¿›ûŸ\0\0\0\0\0\0\tË›Ÿ¿ÿûÐ\0\0©¹\t™ûÿÿ\0\0\0\0\0\t\0
™É\tÐ¹\r\t\tûÉ™™Ù\0ßý¼™©\0\n\0©©«»›ÿÿ»ÿû°\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0
¿›ýÿŸ›\0\0\0\0™›Ÿ¿ßŸ½»\tš›™\0¹ûßÿý\0\0\0\0\0\0\0\0\0šž™ÀÐ°š½­\tÙÿÿßÛÚ
\t
¹©¹\0š›»½ÿÿÐ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0›Ù«Û¹¹¹\t°\0\t\0\0©°¹ùùûûÛ™
\0\0™\0\0™Ûùûÿû\0\0\0\0\0\0\t\0›\t\t¹\0\t
Ù
Ÿÿý¿¿¼\t\0û©àð\0º\0\t\tº»Ÿ¿ \0À\0\0\0\0\0\0\0\0\0\0\0\0\0\t»Ù¹\t\t\t¹\t¹\t\0\t™›Ÿ¿½½»Û™™\0™©¹½ÿù\0\0\0\0\0\0\0\0©\0ù\tšÙ\tÿßš\tÛÛ\t©©é»© 
\0 \0™\0©
šš\0\0\0\0\0\0\0\0
©\0\0\0\0\0™¹\0\0\0\0\t™°Û™Ÿ›ûÛŸ¼š™\0\t\0›™
Ÿÿ\0\0\0\0\0\0\t\0°šŸ\t\tÉÿÿ\tËß½ùÿð¿¿­ºÉ­
\0° \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0››\0\0\t\0\t\0\0\0\0\t©\t¹ûùù½¹ù›™\0\0\t\t\t
ýÿ¹\0\0\0\0\0\0\0°\tÉ\r›ÙŸßß™ßŸßŸÛÐù\t\t
°š›
š°°\0\0\0 \t\t\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0™°\0\t\0\0\0\0\0\0ÛÛŸ›ÛÛÛ½©\t\t\0\t\0\0šßÛÿŸ\0\0\0\0\0\0\t\0›
\tðÿýÿ»¿Ùùûù½¼Ÿœ°™¼»\0\n©\0\0\0\0\0\t \n\0\t\n\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0

\0\0\0\0\0\0\0\t\t©¹ùù¹¹½›Ùš©\n\0\t›ÿŸ¹\0\0\0\0\t\0\0\nÐ°\t\tš™œ\r¾ŸÉœ™ŸŸ\t»\0\0\0\0
\0°\0\0\t\0š\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t™›\0\0\0\0\t\0š¹›Û›ŸŸ›››¿½½Ÿ™ý©ûé½½°\0\0\0\0\0\0
\0š›\t¼¹ÙÙ°
Û
Ùéùù
°\0\0\0\0\0\0\0\0\n\0\0ðË\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°¹°\t\t\t½¹\tù›ÛÛ›­™
Ûùÿ›Û™û
\0\0\0\0\0\0
\0\t
\tš™\t©™½\tÙ\t\t
ÛÐ\0\0\0\0\0\0\0\0\0\0\0\0ÿÿð \t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t™\0\0\0š›\t››››©›™¿¿ŸŸ¹½¹
Ÿ\t™\0\0\0\0\0\0\0\r\t°œšÉ™
œÐ\0
Ð¼žšÐ™\t\t\0\0\0\0°\0\0\0\0\0\0šÿÿÿÚ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0š›
\0\0š™¹\t\t¹½½©™\0™™¹ù\t\t™\t¹\0\0\0\0\0\0\0\0 \0¹é¾ž

\t°™ùý½\0
šÐ\0\0\0\0\n\0\0\0\0\0\0­ÿÿÿýð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0\0\t
™¹\0\0\t
››¹\0
\0¹ù¿¹\0
\t\t
›\0\0\0\0\0\0\0\t©\t™ùé™\tù\rŸšÛÙ\0ÛÙ\0\0\0º\0\0\0\0\0\nŸÿÿÿÿ°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0™\t\0\0\0\0š™\0\0™©Ù\0™\t
Ù\0¹š°\0\0\0\0\0\0\t\0\0\t\r°ð½Ÿž\n© ÛÚ™\tÉÿš¼›\0\0
\0\0\0\0\0\0
\t«»ÿÞ¿\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0™\t°\0\t\0Ÿ™©\t\0Ë\t
Ÿ›\t\0™\t\t\t\0\0\0\0\0\0\0\t\t°
\t\tÐ©ý½
É\t°\tÐ¿ÛÐš™\0\0\0°\0\0\0\0\0\0 \0
ûÙ\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0Ÿ\0\t\t¹\t
™°\t¹°¹\0\0\0\0\0\0\0\0\0°\t\t\tš™\t
ÚŸŸ
\t¹¹
ßù
\t©\t\0\0\n
\0\0\0\0\0
\0\0\0\0
 \0\0ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0™\0¹\t\0°Ú\t©É\0û\t\t©\0\0\0\0\0\0\0\0\0\t °°Ú™ý°ù½¼\rÿŸ©ÚÙ\0\0\0\0\0\0\0\0\0°\0\0¬\t \tÿ\0\r\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°¹\0\t¹°\t\0™¹\0™Û¹\t™\0°\0\0\t\0\0\0\0\0\0\0\0°™\r ¿ûðšÛÛß\týÿý©\0\0\0\0 \0\0\0\0\0
Ë\n\t\0ž°šš\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\t\0°™\0\0\t\t\t\0\t©©°™°\0\0\t\0\0\0\0\0\0\0\0
\tš™ÿÿß™ßŸßÛÙžŸÿù
\0\0 \0š\0 \0\0\0\0\0°š\0
Û\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t©\0\0\0\0š\0\t™™\t\t°\0\0\0\0\0\0\0\0\0\0\0\0\0©\t™Ëí©žŸù©ð½ùð½
\tÙŸý\0\0š\0\0°
\0\0\0\0\0š\0\0\0\té\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\t\t\t\0™\t\0\0\t\t
\0\0\0\0¼¹\0›™\0\0\0\0\0\0\0\0\0\0\0\0\t\0
™ûÚßëÐ™\t
ÙÛ™


ËûË\0\0\0\0\0\0°\0\0\0\0°\0\0\0\0\t°ž
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\t
\0
\0\0\0™\0\t\t››™\t°\0\0\t\0\0\0\0\0\0\0\0\t\0\0\t\tü½¯›Ÿ©ú
\t\tŸùùœ™\t¹É½\0\0
\0\0
\0\0\0\0 \0\0\0\0\0\0­ °\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0™\t\0\t\0\0\t©\t\0\0\0™\t\0\0\0\0\0\0\0\0\0\0\t\0š\0
ÛÛùÿßù™\0Ÿß
©š\r¹Ë\0\0°\0\n\0\0\0\0 
\0\0\0\0\0\0š›ËÐ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\t\0\0\0\0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0›ÿ°°Ÿ¿ÿ\n›\t½©½™ùÉ°\0\0\n\0\0\0\0\0
\0\0\0\0\0 \0šÉ¼¾\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0¹\0\0\0\0\t\0\0\t\0\0\0\t\0\0\t\t\0\0\0\0\0\0\0\0\0\0\0\t\0\0
ŸÞŸùßÿý\0üŸÛÚ™ëéÿ¼ù\0°\t\n\t\0\0\0\0\0\0\0\0\0\0\0\t°ûÛ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0ÿ¹
ïÿÿýúŸ½½¼ŸšŸûËÚ\0\0 © \0\0\0\0\0\0\0\0\0
\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\t\n\0\t\t°\0\0\t\0\0\0\0\0\0\t\0\0\t\0\0\0\0\0\t\0 \0\t¿ù
™ÿÿûýÿß™ù\tÛ
™ùý\0\0\0\0\0\0\0\0\0\0\0\n\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0Ð™\0©\t\t\0\t\0\0\0\0\0\0\0\0\n\0\0\0\0\0 \0š\tü°úŸùù¿ß¹ÐÙ\ržŸÙúœ»\0©©\n\0\0\0\0\0\0\0\0\t\t\0°\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0°\t
\tù\0šÉ°\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\t\t\0¿ßßÿÿð™ðÛ™ßÛùð\t°\0\0\0© \0\0\0\0\0\0\0\0 ©\0 °\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0š™š™\t°\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\n\n\0\0Ÿÿÿÿý¿½¼½¹­Ÿ©°ÛË\0\0°\0\0\0\n\0\0\0\0\n©\t\0
\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\t™ \t©\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0™É\0ÿ¿ÿûðšß\tÛ™šÛ
\t©©\0\0
\0\0\0\0\0\0© \0\0\0\0\0\0° \0É\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\0\t°°Ù\0\t\t\0°\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\t °\0\0¿Ûÿ¼Ù½ýž¼½º\0 \0\0\0\0\0\0\0

\0\0\0  \t\t\0© ©\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0™\0™\t
\0™\0 \0\0\0\0\0\0\0\0\0\0\0\t\0\t\0œ\tðü¹û©ŸûÛ\t½™œÛ\t\0ð\0\0°\0 \0\0 šš\0\0\n\0\0\0\0
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0°\0
\t\t\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\t
°\0©»žÐ›Ùéý½\téËð›\t\0
\0 \0\0\t© \0\0\0\0 \0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0™\t\0\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0š\nÐ\0Ù\0
ð¿ÿŸŸù
ü¿\0\0°š\0\0\0\n\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0°\0\t\t
\0¾ÿ™\t\0ûßù©\tý»\t©›ý\0\0\0© \0\0\0°\0\n\0\0\0 \n \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0š\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0¼°\t\0Ÿÿéð¯½½œðŸÐ¼ž°Ÿ\0 \0\0\0\0\0\0 \0\0\t\0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\t\t\0É\0š\tÿÿÿ
ßÿ¹Û\tß™\t«Ûùù\0\0\0 \0\0\0°º\n\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\t \0 °\tÿÿÿù¿û\t »ÐùýÿðÿÛ\0\0\0\0\nš\0\0\0
\0\0\0\0°°\0©©\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\t\t©\r ›ÿÿÿ°©ÿÿ™
\0½ð¿½¿›ý\0\0\0
\0\0

\t  \n\0\0 \0\t©\0\0\t\0\0\0\0\0\0\0\0\0\t\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0°ÐÏÿÿÿ™É\tû©\t½ß¹\rß\tðŸ\0\0© \0\0 \0 \t\0\0\t©\0\0 \0
\0\0\0\0\0\0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0©
Ð¿ÿÿÿù¯°›ù°ûËûûé¿­ù\0\0\t© 

\0\0\0\0\n\0\0\t\t\nÉ\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0É
Ûßÿÿÿÿß¾ŸŸ¹¹°šŸŸÞÛÙ\0\nš\0\t «\0\0\n\0\0\0°\0 
úð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0

\tïùÿÿÿÿÿ°™ÿÿü\t­©¹°¹\0\0\0\0\0\t\0\0\n\t\n\0 \0 š
ß¼\0\0\0\0\0\0\0\0\0\t\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0šé°Ÿÿÿÿÿÿù\týÿ™ù°™\t\0\0\0\t©© \0\0\0\t\0\0\0\0\0\t©\0©ëÙ©\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0

é­ÿÿÿÿÿð›šž\tà\0ÐÛ\n™\t\n\0\n\0\n\0\0\n\n\0\n\0\n\0 ð
ŸŸ\n\0\0\0\0\0\0\0\0\0\t\0\0\t\0\0\0\0\t\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\tÉ°\t\0\0™ÿÿÿÿÿÿÿ\t©Ù½Ÿ›

Ùš\n\0»\t\0\0 \0©\t
\0°°\0 \0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°\t\0\t\0\n›ÿÿÿÿÿÿðÙ­ðÐŸ\t\0\0
 \0\0  \t\n\n\0° \0\0
\tš\t©\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0À\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ÿ\0\0\0\tÿÿÿÿÿÿ»
Ûù
Ú»\tðð\0\0°š\0\0 °©\0°\0\0\0\0\n\tš\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\t\0 \t\0\0\t¿ÿÿÿÿù\t½Ÿ¹\tÐ¼Ÿ™\0\t©©\0\0 \tª\t\0
\0°\0\n\0\t¾ \0\0\0\0\0\0\0\0\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0¹\0\0°
›Ÿ›ù \nÐÐ
\r


°š\0\n\0\0\0©\0 °\t š\0\n
\0šš\t\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0
\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0ð\0\0\0\t\0\t©©\n\0\0\t™©\0°°°™Ë\t\0\0\0\0\0š\0\0\nš\tº\t\0¹\0\t  \0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\t\0°\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0™\0\0
\t\0\0\0\0š\0\0\n\t\0›
š
\n\0 \n\0\n
©\0\0©©\n\t\0©\n
\n\t\t\0\0\0\0\0\0\0\n\t\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t©\n\0\0\0°\0\0\0\0\0\0\0\0¹ ½©ž°
\0\0\0\0\0\0šš\0\0\0°° \t©\t­\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t©\n\0\t\0\0™é\0\0\0\0 \0\0\0
Ð
›½½¹°¹ ©\0\0\0\0©°\n\0\t©­©
\nžšš\t\0
\0\0©\0\0\0\0\0\0\0\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0Ÿ\tÀ\t š\0\0\0\0š\n\0\0 \t\t\0©ûð
™Ë\t\0  \0 šð¹©\n\0
\nž›

\t °\0\0°\0\0\0\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0š™\0\0\0\0\0\n\0\t\t°š›™¬°\n
\0\t š°»
\0©©«\të\nšðð\0\0\0\0\0\0\0\t\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0©¬­©\t
\0\t \0\0\0\0\n\n­\t\0\t©
™\t
\0ššš
º›°°
šš¹ºš›\n\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n
\0\0Ðð\t\0\0\0\0\0\0ð\t \0°š»\t©©©¿\t©©
©©©¾›°»© š\0\0š \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\nððš\t©\t
š\0\0\0\n

\t°\tð\0 \0šœš™ºš\t«
¾šš\0ššš›©¯š\0\0\0\0\0\t\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0 \0\0\0\0\0\0\0\0\t\0ÀŸœš\0œ°°\0\0\0\0\0\0\0¬\t ™\0\0\t©\r«\t«\nùû
¹©©ª›©›ù»š\t\n\n\t\0\0\t\0\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
\0\0\0\0\0\0­\0\0\0\0\0\0\0\0\0\0\0\0


\t
\r\t©\0\0\0\0\0\0\t \0™°\t™ \0\0žš™º¹
›©»\nšš¹¾»›«
°\n\0\0\n\t\0\0\0\t\0 \0\0\t\0\0\0\0\0\0\0\0\tý\0\0\0\0\0\0\0\t \0\0\t\0\0\0\r\0ð\0\t\0žœÐ½°°\t\t
\0\0\0\0\0 \0
\n\nÚ\0\0\t°
›ÚŸ
úûš
\t©«š››©¹°\t©\n\t\t\t\0\0šš\t\0\0\0\t\0\0\0\t\0\0\0\0\nš \0\n\0\n\0É\t \0\0 \0\0\n\0š\0\t\t\n\t©©©­\tË\r©\n\t\n\0\0\0\0\0
\0\nÛ\0\0
°©©«°¹º›© ûž¹«©°°šÚÚ\0\n\0š\0\n\0\t\0©\0š\0\0\0\0\0\0\0\0\0\0\0\t\0\0\rï\0¬É\0\0\0\0\0\tð°\n
\0šœš½°š™\nš\0\0\0\t ¹ ©\t\0\t
\0\0Ûžš›û©°
°»š›ššš\t©© \t©\n\0\0\0\t ©\0\0\0°\0\0\0\0\0\0\0\0\0\0\nÛÞÿÿýÿïðé\tÊ\n\t\t©À\t
\t
Û\t­\0°\0\0\0\0 
Ê\tÐ\0™ž\0
©©›©«°š\n\0»Ë¹«¹© \0ºš
\0\0\0\0\0 \0š\0š
\0\0\0\0\0\0\t\0\0\0\0\t\0\0
\r\n
››ù›šù¹À\tšÚÐ¹ š\0\r©é°\0©\t\0\t \0\0°°›\n\0š\t \0\0 šš\0\t

»
\t«
\t©\0\0 \n\0\0\t\0\t \0\n\t\0 \0\0\0\0\0\0\0\0\0š\t\0éœšÐ \0 \t©\n
\0¹ê\t\t\t©\0\tšš™\0\tÐ\n\t\0 
\0\t \nš\0© ©É°\t\0\0\n
›¹©©\0\0©°¿»° °ššš\t\0\0\0\0 ©\0\0 \n\n  š\0\0\n\0\t\0\0\t\n\t\0°ºË
É©\0\0\0°\0œ°ð°ššÉ \t\téš°\t\n\0™\0š\t©©\nš\0¼›\0°\t\0©\nš\0 \n©°°\0   \0\0\n
\t\0°\0\0\0\0\0\0°\0\0\0\0\t\0\0\0\0\0žŸ\t\t°¼°\0\0\0\0  

\t
\r©\t
\t °©\t™\0\t\0\n \t\0° šð©©
\t \0 \0 ©\n¹°°\0\0\nš
\t \0\n\0\0\0°°\n\0\0\0\0\n \0\0\0\0\n\t © \0\0\0­šž°š
\nš°\0\0\n°°\0š¼šœ© šÙ\tšÙ Ð\t\0\n\t\0\t°°°°ºšš ™\0°\t\n©\n
\0\0\0\0° \t\0°
\0\0\0\0\n°\n°\0\0\0\0\0\0
\t \t\0 \0 ©\0°\t\tÉ©°ù©Ë\0\0 \0\0Ê\n\t©­
«šš\t\nÚ\t\nÙ©\0\n\0©°\t\0°¹é©­©\t\0°\t\n \n›©\0  š


\n

\0\0\0š
\n\0\0\0\0\0\0\0\0 \0\0  °©\0\0\t\t\n›¯\n¼© Ú°\0\t\0°°°«\nš
ºúÐ°¹™¹­\t\t
©\0›\t°ù«š©ªÐ½
\0\0©
\0©©\0 \0 \0°°°°°©
\0\0\t
\n\0 \0\0\0\0\0\0\n\t\t©\t\0žžšš
\t° Ð½¯
ž›°«
\t\n\0\0©
É©­°©\tï½«Ë\0 Ë\0š°¹é
Ëº¹©\nš›
\t°°°š\0\0š° \0š\n\n
Ë
šš\0š  šš \t\0  \n\0š©\n\n\0 \t©©\0\0°«\n™ºúý¯


\0š©\t«š°ºž›Ÿ
ûÞ½»
Û™©
\tžžš›ž›
Ú°©­°°š
\0\0 \0
\t\t\0° ©\0ž½°©©© š\0©
\n\0 \t\t\0\n\0©\n\t©
\nš©©Ëð¹ \0Ÿÿý°¼°­«©\n \0©Ë\t©°»
ûßùúü°°ð°\0ù©™©©«

 ¹©
Ë
©é©ð \0\0°\0© °\0š©\n\n
ïûšššš
\0°\nššš
\n\n\0\0°\n©\0\0\0°°©\0\n›\0š
ÿÿï


\t«›
\n°°°©\n°ûÿÿûû\t™
šš«É½¹ùù»
ºš°°»
Ú›\t \0\0š


\0š\0¹ÿž¿š© 
\0°

é°°°š\0°©\0\0



\0©\t« š\0¿ÿÿÿð° ¾ë °¹\nš
š¹«
¼ûßÿðð°ùë\r¹™ºšºšº¹\n›

\0°©© \0 \n\t©© °© 
\nžÿïð©ª°°
\n°¹
Ë\n\t \n
\0š\0 °°°°š °\t 

ÿÿÿÿð°™©«¹
š\0© ¹\nœ­úßþÿÿÿÿ
¿¹Û¿¾½¹©¹©» ©\nšššš¾\t
\0šÛšš\nššš›¿¿ÿÿð\t«
 °\n°°©\n
\t\0«©©š
Ë
\n\0\n›
\n°©ïÿÿÿÿ
\nššž°©°š\t\n¹»ÿÿÿÿÿÿÿÿ›š›û›šúššš\t\0

\0\0\0\n° ° ©°\0\t\t °°ðüÿÿÿû©
°\nš¼«Êšª\t© ©©°°ù°° °°°©»Ÿÿÿÿÿ¬°©­©
\nš©ª
Ëÿÿÿýÿÿÿÿ°\t©\t¹ë¹¹­«
«\0\0\0\0°\t\0\t©
\0\0šš»°° 
ÿ¿¿ÿÿÿþÛ©© \0ù©¬\n©©ë«¾š›\nšËË\n
›Ð©©°¼¿ÿÿÿÿù šÚš°° š ¿¿ÿÿÿÿ¿ÿÿÿ\0\nœ°¿¹ëš°\0\0\0\0\0\n\0\0\0 

©©©\n\0\t­ÿûÏÿÿÿÿÿ°\0\0\0é ¬\n©©\nù\t© ©\0°°°š
Ë
›
­¿ŸÿÿÿÿþŸ©©\t©éªÚŸÿÿÿÿÿ¿ßÿÿÿ\0\t

Úš™°

©©\0\0\0\0\0\t\t\0\0°¼½©\tÿ»\nÚÿÿýþÿÿÿÿ\0ð\0\0\0

\0 \0
\n©\nú¼\t\0\0ð°° °šùïÿÿÿÿù \n\t\nËÿù¯ÿÿÿÿÿÿßïÿÿÿ\0\0°¹¹ \n°\0\0\0\0\0\0\0\0\0\0\0¼¿
\0\0ÿÏ°¿ÿÿ¾½ÿÿÿÿð\n\0 \n\0À©\0Ð©Ê\t
\n\0\0\t©©à
ËÉ
Ë¹ï›ÿÿÿÿÿÚœ\nÉ¬ÿÿÿÿÿÿÿÿûÿŸÿÿÿ°\0\0\0\0\0š\0\0\0\0\0\0\0\0\0\0\0\0\0\n
ð\0\0ÿûÿÿÿßÿÿÿÿÿà\0\0\0\0\n\0 \n \nÀ Ê\0\0\0\0àðð°šž½íÿÿÿÿð à  \nÿÿÿÿÿÿÿÿýéÿÿÿÿ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÚÛ\0\0ÿÿÿÿÿÿÿÿÿÿÿÿ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
\0à\n°\0\n›ÿûÿÿÿÿÿ\0\0\0\0\0ÿÿÿÿÿÿÿÿÿ¿ÿÿÿÿ\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0¿ð\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0®­þ','Anne has a BA degree in English from St. Lawrence College.  She is fluent in French and German.',5,'http://accweb/emmployees/davolio.bmp');

COMMIT;

#
# Data for the `Region` table  (LIMIT 0,500)
#

INSERT INTO `Region` (`RegionID`, `RegionDescription`) VALUES 
  (1,'Eastern'),
  (2,'Western'),
  (3,'Northern'),
  (4,'Southern');

COMMIT;

#
# Data for the `Territories` table  (LIMIT 0,500)
#

INSERT INTO `Territories` (`TerritoryID`, `TerritoryDescription`, `RegionID`) VALUES 
  ('01581','Westboro',1),
  ('01730','Bedford',1),
  ('01833','Georgetow',1),
  ('02116','Boston',1),
  ('02139','Cambridge',1),
  ('02184','Braintree',1),
  ('02903','Providence',1),
  ('03049','Hollis',3),
  ('03801','Portsmouth',3),
  ('06897','Wilton',1),
  ('07960','Morristown',1),
  ('08837','Edison',1),
  ('10019','New York',1),
  ('10038','New York',1),
  ('11747','Mellvile',1),
  ('14450','Fairport',1),
  ('19428','Philadelphia',3),
  ('19713','Neward',1),
  ('20852','Rockville',1),
  ('27403','Greensboro',1),
  ('27511','Cary',1),
  ('29202','Columbia',4),
  ('30346','Atlanta',4),
  ('31406','Savannah',4),
  ('32859','Orlando',4),
  ('33607','Tampa',4),
  ('40222','Louisville',1),
  ('44122','Beachwood',3),
  ('45839','Findlay',3),
  ('48075','Southfield',3),
  ('48084','Troy',3),
  ('48304','Bloomfield Hills',3),
  ('53404','Racine',3),
  ('55113','Roseville',3),
  ('55439','Minneapolis',3),
  ('60179','Hoffman Estates',2),
  ('60601','Chicago',2),
  ('72716','Bentonville',4),
  ('75234','Dallas',4),
  ('78759','Austin',4),
  ('80202','Denver',2),
  ('80909','Colorado Springs',2),
  ('85014','Phoenix',2),
  ('85251','Scottsdale',2),
  ('90405','Santa Monica',2),
  ('94025','Menlo Park',2),
  ('94105','San Francisco',2),
  ('95008','Campbell',2),
  ('95054','Santa Clara',2),
  ('95060','Santa Cruz',2),
  ('98004','Bellevue',2),
  ('98052','Redmond',2),
  ('98104','Seattle',2);

COMMIT;

#
# Data for the `EmployeeTerritories` table  (LIMIT 0,500)
#

INSERT INTO `EmployeeTerritories` (`EmployeeID`, `TerritoryID`) VALUES 
  (2,'01581'),
  (2,'01730'),
  (2,'01833'),
  (2,'02116'),
  (2,'02139'),
  (2,'02184'),
  (5,'02903'),
  (9,'03049'),
  (9,'03801'),
  (1,'06897'),
  (5,'07960'),
  (5,'08837'),
  (5,'10019'),
  (5,'10038'),
  (5,'11747'),
  (5,'14450'),
  (8,'19428'),
  (1,'19713'),
  (4,'20852'),
  (4,'27403'),
  (4,'27511'),
  (3,'30346'),
  (3,'31406'),
  (3,'32859'),
  (3,'33607'),
  (2,'40222'),
  (8,'44122'),
  (8,'45839'),
  (9,'48075'),
  (9,'48084'),
  (9,'48304'),
  (8,'53404'),
  (9,'55113'),
  (9,'55439'),
  (7,'60179'),
  (7,'60601'),
  (7,'80202'),
  (7,'80909'),
  (6,'85014'),
  (6,'85251'),
  (7,'90405'),
  (7,'94025'),
  (7,'94105'),
  (7,'95008'),
  (7,'95054'),
  (7,'95060'),
  (6,'98004'),
  (6,'98052'),
  (6,'98104');

COMMIT;

#
# Data for the `Shippers` table  (LIMIT 0,500)
#

INSERT INTO `Shippers` (`ShipperID`, `CompanyName`, `Phone`) VALUES 
  (1,'Speedy Express','(503) 555-9831'),
  (2,'United Package','(503) 555-3199'),
  (3,'Federal Shipping','(503) 555-9931');

COMMIT;

#
# Data for the `Orders` table  (LIMIT 0,500)
#

INSERT INTO `Orders` (`OrderID`, `CustomerID`, `EmployeeID`, `OrderDate`, `RequiredDate`, `ShippedDate`, `ShipVia`, `Freight`, `ShipName`, `ShipAddress`, `ShipCity`, `ShipRegion`, `ShipPostalCode`, `ShipCountry`) VALUES 
  (10248,'VINET',5,'1996-07-04','1996-08-01','1996-07-16',3,32.38,'Vins et alcools Chevalier','59 rue de l''Abbaye','Reims',NULL,'51100','France'),
  (10249,'TOMSP',6,'1996-07-05','1996-08-16','1996-07-10',1,11.61,'Toms Spezialitäten','Luisenstr. 48','Münster',NULL,'44087','Germany'),
  (10250,'HANAR',4,'1996-07-08','1996-08-05','1996-07-12',2,65.83,'Hanari Carnes','Rua do Paço, 67','Rio de Janeiro','RJ','05454-876','Brazil'),
  (10251,'VICTE',3,'1996-07-08','1996-08-05','1996-07-15',1,41.34,'Victuailles en stock','2, rue du Commerce','Lyon',NULL,'69004','France'),
  (10252,'SUPRD',4,'1996-07-09','1996-08-06','1996-07-11',2,51.3,'Suprêmes délices','Boulevard Tirou, 255','Charleroi',NULL,'B-6000','Belgium'),
  (10253,'HANAR',3,'1996-07-10','1996-07-24','1996-07-16',2,58.17,'Hanari Carnes','Rua do Paço, 67','Rio de Janeiro','RJ','05454-876','Brazil'),
  (10254,'CHOPS',5,'1996-07-11','1996-08-08','1996-07-23',2,22.98,'Chop-suey Chinese','Hauptstr. 31','Bern',NULL,'3012','Switzerland'),
  (10255,'RICSU',9,'1996-07-12','1996-08-09','1996-07-15',3,148.33,'Richter Supermarkt','Starenweg 5','Genève',NULL,'1204','Switzerland'),
  (10256,'WELLI',3,'1996-07-15','1996-08-12','1996-07-17',2,13.97,'Wellington Importadora','Rua do Mercado, 12','Resende','SP','08737-363','Brazil'),
  (10257,'HILAA',4,'1996-07-16','1996-08-13','1996-07-22',3,81.91,'HILARION-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Cristóbal','Táchira','5022','Venezuela'),
  (10258,'ERNSH',1,'1996-07-17','1996-08-14','1996-07-23',1,140.51,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (10259,'CENTC',4,'1996-07-18','1996-08-15','1996-07-25',3,3.25,'Centro comercial Moctezuma','Sierras de Granada 9993','México D.F.',NULL,'05022','Mexico'),
  (10260,'OTTIK',4,'1996-07-19','1996-08-16','1996-07-29',1,55.09,'Ottilies Käseladen','Mehrheimerstr. 369','Köln',NULL,'50739','Germany'),
  (10261,'QUEDE',4,'1996-07-19','1996-08-16','1996-07-30',2,3.05,'Que Delícia','Rua da Panificadora, 12','Rio de Janeiro','RJ','02389-673','Brazil'),
  (10262,'RATTC',8,'1996-07-22','1996-08-19','1996-07-25',3,48.29,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA'),
  (10263,'ERNSH',9,'1996-07-23','1996-08-20','1996-07-31',3,146.06,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (10264,'FOLKO',6,'1996-07-24','1996-08-21','1996-08-23',3,3.67,'Folk och fä HB','Åkergatan 24','Bräcke',NULL,'S-844 67','Sweden'),
  (10265,'BLONP',2,'1996-07-25','1996-08-22','1996-08-12',1,55.28,'Blondel père et fils','24, place Kléber','Strasbourg',NULL,'67000','France'),
  (10266,'WARTH',3,'1996-07-26','1996-09-06','1996-07-31',3,25.73,'Wartian Herkku','Torikatu 38','Oulu',NULL,'90110','Finland'),
  (10267,'FRANK',4,'1996-07-29','1996-08-26','1996-08-06',1,208.58,'Frankenversand','Berliner Platz 43','München',NULL,'80805','Germany'),
  (10268,'GROSR',8,'1996-07-30','1996-08-27','1996-08-02',3,66.29,'GROSELLA-Restaurante','5ª Ave. Los Palos Grandes','Caracas','DF','1081','Venezuela'),
  (10269,'WHITC',5,'1996-07-31','1996-08-14','1996-08-09',1,4.56,'White Clover Markets','1029 - 12th Ave. S.','Seattle','WA','98124','USA'),
  (10270,'WARTH',1,'1996-08-01','1996-08-29','1996-08-02',1,136.54,'Wartian Herkku','Torikatu 38','Oulu',NULL,'90110','Finland'),
  (10271,'SPLIR',6,'1996-08-01','1996-08-29','1996-08-30',2,4.54,'Split Rail Beer & Ale','P.O. Box 555','Lander','WY','82520','USA'),
  (10272,'RATTC',6,'1996-08-02','1996-08-30','1996-08-06',2,98.03,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA'),
  (10273,'QUICK',3,'1996-08-05','1996-09-02','1996-08-12',3,76.07,'QUICK-Stop','Taucherstraße 10','Cunewalde',NULL,'01307','Germany'),
  (10274,'VINET',6,'1996-08-06','1996-09-03','1996-08-16',1,6.01,'Vins et alcools Chevalier','59 rue de l''Abbaye','Reims',NULL,'51100','France'),
  (10275,'MAGAA',1,'1996-08-07','1996-09-04','1996-08-09',1,26.93,'Magazzini Alimentari Riuniti','Via Ludovico il Moro 22','Bergamo',NULL,'24100','Italy'),
  (10276,'TORTU',8,'1996-08-08','1996-08-22','1996-08-14',3,13.84,'Tortuga Restaurante','Avda. Azteca 123','México D.F.',NULL,'05033','Mexico'),
  (10277,'MORGK',2,'1996-08-09','1996-09-06','1996-08-13',3,125.77,'Morgenstern Gesundkost','Heerstr. 22','Leipzig',NULL,'04179','Germany'),
  (10278,'BERGS',8,'1996-08-12','1996-09-09','1996-08-16',2,92.69,'Berglunds snabbköp','Berguvsvägen  8','Luleå',NULL,'S-958 22','Sweden'),
  (10279,'LEHMS',8,'1996-08-13','1996-09-10','1996-08-16',2,25.83,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M.',NULL,'60528','Germany'),
  (10280,'BERGS',2,'1996-08-14','1996-09-11','1996-09-12',1,8.98,'Berglunds snabbköp','Berguvsvägen  8','Luleå',NULL,'S-958 22','Sweden'),
  (10281,'ROMEY',4,'1996-08-14','1996-08-28','1996-08-21',1,2.94,'Romero y tomillo','Gran Vía, 1','Madrid',NULL,'28001','Spain'),
  (10282,'ROMEY',4,'1996-08-15','1996-09-12','1996-08-21',1,12.69,'Romero y tomillo','Gran Vía, 1','Madrid',NULL,'28001','Spain'),
  (10283,'LILAS',3,'1996-08-16','1996-09-13','1996-08-23',3,84.81,'LILA-Supermercado','Carrera 52 con Ave. Bolívar #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela'),
  (10284,'LEHMS',4,'1996-08-19','1996-09-16','1996-08-27',1,76.56,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M.',NULL,'60528','Germany'),
  (10285,'QUICK',1,'1996-08-20','1996-09-17','1996-08-26',2,76.83,'QUICK-Stop','Taucherstraße 10','Cunewalde',NULL,'01307','Germany'),
  (10286,'QUICK',8,'1996-08-21','1996-09-18','1996-08-30',3,229.24,'QUICK-Stop','Taucherstraße 10','Cunewalde',NULL,'01307','Germany'),
  (10287,'RICAR',8,'1996-08-22','1996-09-19','1996-08-28',3,12.76,'Ricardo Adocicados','Av. Copacabana, 267','Rio de Janeiro','RJ','02389-890','Brazil'),
  (10288,'REGGC',4,'1996-08-23','1996-09-20','1996-09-03',1,7.45,'Reggiani Caseifici','Strada Provinciale 124','Reggio Emilia',NULL,'42100','Italy'),
  (10289,'BSBEV',7,'1996-08-26','1996-09-23','1996-08-28',3,22.77,'B''s Beverages','Fauntleroy Circus','London',NULL,'EC2 5NT','UK'),
  (10290,'COMMI',8,'1996-08-27','1996-09-24','1996-09-03',1,79.7,'Comércio Mineiro','Av. dos Lusíadas, 23','Sao Paulo','SP','05432-043','Brazil'),
  (10291,'QUEDE',6,'1996-08-27','1996-09-24','1996-09-04',2,6.4,'Que Delícia','Rua da Panificadora, 12','Rio de Janeiro','RJ','02389-673','Brazil'),
  (10292,'TRADH',1,'1996-08-28','1996-09-25','1996-09-02',2,1.35,'Tradiçao Hipermercados','Av. Inês de Castro, 414','Sao Paulo','SP','05634-030','Brazil'),
  (10293,'TORTU',1,'1996-08-29','1996-09-26','1996-09-11',3,21.18,'Tortuga Restaurante','Avda. Azteca 123','México D.F.',NULL,'05033','Mexico'),
  (10294,'RATTC',4,'1996-08-30','1996-09-27','1996-09-05',2,147.26,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA'),
  (10295,'VINET',2,'1996-09-02','1996-09-30','1996-09-10',2,1.15,'Vins et alcools Chevalier','59 rue de l''Abbaye','Reims',NULL,'51100','France'),
  (10296,'LILAS',6,'1996-09-03','1996-10-01','1996-09-11',1,0.12,'LILA-Supermercado','Carrera 52 con Ave. Bolívar #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela'),
  (10297,'BLONP',5,'1996-09-04','1996-10-16','1996-09-10',2,5.74,'Blondel père et fils','24, place Kléber','Strasbourg',NULL,'67000','France'),
  (10298,'HUNGO',6,'1996-09-05','1996-10-03','1996-09-11',2,168.22,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',NULL,'Ireland'),
  (10299,'RICAR',4,'1996-09-06','1996-10-04','1996-09-13',2,29.76,'Ricardo Adocicados','Av. Copacabana, 267','Rio de Janeiro','RJ','02389-890','Brazil'),
  (10300,'MAGAA',2,'1996-09-09','1996-10-07','1996-09-18',2,17.68,'Magazzini Alimentari Riuniti','Via Ludovico il Moro 22','Bergamo',NULL,'24100','Italy'),
  (10301,'WANDK',8,'1996-09-09','1996-10-07','1996-09-17',2,45.08,'Die Wandernde Kuh','Adenauerallee 900','Stuttgart',NULL,'70563','Germany'),
  (10302,'SUPRD',4,'1996-09-10','1996-10-08','1996-10-09',2,6.27,'Suprêmes délices','Boulevard Tirou, 255','Charleroi',NULL,'B-6000','Belgium'),
  (10303,'GODOS',7,'1996-09-11','1996-10-09','1996-09-18',2,107.83,'Godos Cocina Típica','C/ Romero, 33','Sevilla',NULL,'41101','Spain'),
  (10304,'TORTU',1,'1996-09-12','1996-10-10','1996-09-17',2,63.79,'Tortuga Restaurante','Avda. Azteca 123','México D.F.',NULL,'05033','Mexico'),
  (10305,'OLDWO',8,'1996-09-13','1996-10-11','1996-10-09',3,257.62,'Old World Delicatessen','2743 Bering St.','Anchorage','AK','99508','USA'),
  (10306,'ROMEY',1,'1996-09-16','1996-10-14','1996-09-23',3,7.56,'Romero y tomillo','Gran Vía, 1','Madrid',NULL,'28001','Spain'),
  (10307,'LONEP',2,'1996-09-17','1996-10-15','1996-09-25',2,0.56,'Lonesome Pine Restaurant','89 Chiaroscuro Rd.','Portland','OR','97219','USA'),
  (10308,'ANATR',7,'1996-09-18','1996-10-16','1996-09-24',3,1.61,'Ana Trujillo Emparedados y helados','Avda. de la Constitución 2222','México D.F.',NULL,'05021','Mexico'),
  (10309,'HUNGO',3,'1996-09-19','1996-10-17','1996-10-23',1,47.3,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',NULL,'Ireland'),
  (10310,'THEBI',8,'1996-09-20','1996-10-18','1996-09-27',2,17.52,'The Big Cheese','89 Jefferson Way Suite 2','Portland','OR','97201','USA'),
  (10311,'DUMON',1,'1996-09-20','1996-10-04','1996-09-26',3,24.69,'Du monde entier','67, rue des Cinquante Otages','Nantes',NULL,'44000','France'),
  (10312,'WANDK',2,'1996-09-23','1996-10-21','1996-10-03',2,40.26,'Die Wandernde Kuh','Adenauerallee 900','Stuttgart',NULL,'70563','Germany'),
  (10313,'QUICK',2,'1996-09-24','1996-10-22','1996-10-04',2,1.96,'QUICK-Stop','Taucherstraße 10','Cunewalde',NULL,'01307','Germany'),
  (10314,'RATTC',1,'1996-09-25','1996-10-23','1996-10-04',2,74.16,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA'),
  (10315,'ISLAT',4,'1996-09-26','1996-10-24','1996-10-03',2,41.76,'Island Trading','Garden House Crowther Way','Cowes','Isle of Wight','PO31 7PJ','UK'),
  (10316,'RATTC',1,'1996-09-27','1996-10-25','1996-10-08',3,150.15,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA'),
  (10317,'LONEP',6,'1996-09-30','1996-10-28','1996-10-10',1,12.69,'Lonesome Pine Restaurant','89 Chiaroscuro Rd.','Portland','OR','97219','USA'),
  (10318,'ISLAT',8,'1996-10-01','1996-10-29','1996-10-04',2,4.73,'Island Trading','Garden House Crowther Way','Cowes','Isle of Wight','PO31 7PJ','UK'),
  (10319,'TORTU',7,'1996-10-02','1996-10-30','1996-10-11',3,64.5,'Tortuga Restaurante','Avda. Azteca 123','México D.F.',NULL,'05033','Mexico'),
  (10320,'WARTH',5,'1996-10-03','1996-10-17','1996-10-18',3,34.57,'Wartian Herkku','Torikatu 38','Oulu',NULL,'90110','Finland'),
  (10321,'ISLAT',3,'1996-10-03','1996-10-31','1996-10-11',2,3.43,'Island Trading','Garden House Crowther Way','Cowes','Isle of Wight','PO31 7PJ','UK'),
  (10322,'PERIC',7,'1996-10-04','1996-11-01','1996-10-23',3,0.4,'Pericles Comidas clásicas','Calle Dr. Jorge Cash 321','México D.F.',NULL,'05033','Mexico'),
  (10323,'KOENE',4,'1996-10-07','1996-11-04','1996-10-14',1,4.88,'Königlich Essen','Maubelstr. 90','Brandenburg',NULL,'14776','Germany'),
  (10324,'SAVEA',9,'1996-10-08','1996-11-05','1996-10-10',1,214.27,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (10325,'KOENE',1,'1996-10-09','1996-10-23','1996-10-14',3,64.86,'Königlich Essen','Maubelstr. 90','Brandenburg',NULL,'14776','Germany'),
  (10326,'BOLID',4,'1996-10-10','1996-11-07','1996-10-14',2,77.92,'Bólido Comidas preparadas','C/ Araquil, 67','Madrid',NULL,'28023','Spain'),
  (10327,'FOLKO',2,'1996-10-11','1996-11-08','1996-10-14',1,63.36,'Folk och fä HB','Åkergatan 24','Bräcke',NULL,'S-844 67','Sweden'),
  (10328,'FURIB',4,'1996-10-14','1996-11-11','1996-10-17',3,87.03,'Furia Bacalhau e Frutos do Mar','Jardim das rosas n. 32','Lisboa',NULL,'1675','Portugal'),
  (10329,'SPLIR',4,'1996-10-15','1996-11-26','1996-10-23',2,191.67,'Split Rail Beer & Ale','P.O. Box 555','Lander','WY','82520','USA'),
  (10330,'LILAS',3,'1996-10-16','1996-11-13','1996-10-28',1,12.75,'LILA-Supermercado','Carrera 52 con Ave. Bolívar #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela'),
  (10331,'BONAP',9,'1996-10-16','1996-11-27','1996-10-21',1,10.19,'Bon app''','12, rue des Bouchers','Marseille',NULL,'13008','France'),
  (10332,'MEREP',3,'1996-10-17','1996-11-28','1996-10-21',2,52.84,'Mère Paillarde','43 rue St. Laurent','Montréal','Québec','H1J 1C3','Canada'),
  (10333,'WARTH',5,'1996-10-18','1996-11-15','1996-10-25',3,0.59,'Wartian Herkku','Torikatu 38','Oulu',NULL,'90110','Finland'),
  (10334,'VICTE',8,'1996-10-21','1996-11-18','1996-10-28',2,8.56,'Victuailles en stock','2, rue du Commerce','Lyon',NULL,'69004','France'),
  (10335,'HUNGO',7,'1996-10-22','1996-11-19','1996-10-24',2,42.11,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',NULL,'Ireland'),
  (10336,'PRINI',7,'1996-10-23','1996-11-20','1996-10-25',2,15.51,'Princesa Isabel Vinhos','Estrada da saúde n. 58','Lisboa',NULL,'1756','Portugal'),
  (10337,'FRANK',4,'1996-10-24','1996-11-21','1996-10-29',3,108.26,'Frankenversand','Berliner Platz 43','München',NULL,'80805','Germany'),
  (10338,'OLDWO',4,'1996-10-25','1996-11-22','1996-10-29',3,84.21,'Old World Delicatessen','2743 Bering St.','Anchorage','AK','99508','USA'),
  (10339,'MEREP',2,'1996-10-28','1996-11-25','1996-11-04',2,15.66,'Mère Paillarde','43 rue St. Laurent','Montréal','Québec','H1J 1C3','Canada'),
  (10340,'BONAP',1,'1996-10-29','1996-11-26','1996-11-08',3,166.31,'Bon app''','12, rue des Bouchers','Marseille',NULL,'13008','France'),
  (10341,'SIMOB',7,'1996-10-29','1996-11-26','1996-11-05',3,26.78,'Simons bistro','Vinbæltet 34','Kobenhavn',NULL,'1734','Denmark'),
  (10342,'FRANK',4,'1996-10-30','1996-11-13','1996-11-04',2,54.83,'Frankenversand','Berliner Platz 43','München',NULL,'80805','Germany'),
  (10343,'LEHMS',4,'1996-10-31','1996-11-28','1996-11-06',1,110.37,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M.',NULL,'60528','Germany'),
  (10344,'WHITC',4,'1996-11-01','1996-11-29','1996-11-05',2,23.29,'White Clover Markets','1029 - 12th Ave. S.','Seattle','WA','98124','USA'),
  (10345,'QUICK',2,'1996-11-04','1996-12-02','1996-11-11',2,249.06,'QUICK-Stop','Taucherstraße 10','Cunewalde',NULL,'01307','Germany'),
  (10346,'RATTC',3,'1996-11-05','1996-12-17','1996-11-08',3,142.08,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA'),
  (10347,'FAMIA',4,'1996-11-06','1996-12-04','1996-11-08',3,3.1,'Familia Arquibaldo','Rua Orós, 92','Sao Paulo','SP','05442-030','Brazil'),
  (10348,'WANDK',4,'1996-11-07','1996-12-05','1996-11-15',2,0.78,'Die Wandernde Kuh','Adenauerallee 900','Stuttgart',NULL,'70563','Germany'),
  (10349,'SPLIR',7,'1996-11-08','1996-12-06','1996-11-15',1,8.63,'Split Rail Beer & Ale','P.O. Box 555','Lander','WY','82520','USA'),
  (10350,'LAMAI',6,'1996-11-11','1996-12-09','1996-12-03',2,64.19,'La maison d''Asie','1 rue Alsace-Lorraine','Toulouse',NULL,'31000','France'),
  (10351,'ERNSH',1,'1996-11-11','1996-12-09','1996-11-20',1,162.33,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (10352,'FURIB',3,'1996-11-12','1996-11-26','1996-11-18',3,1.3,'Furia Bacalhau e Frutos do Mar','Jardim das rosas n. 32','Lisboa',NULL,'1675','Portugal'),
  (10353,'PICCO',7,'1996-11-13','1996-12-11','1996-11-25',3,360.63,'Piccolo und mehr','Geislweg 14','Salzburg',NULL,'5020','Austria'),
  (10354,'PERIC',8,'1996-11-14','1996-12-12','1996-11-20',3,53.8,'Pericles Comidas clásicas','Calle Dr. Jorge Cash 321','México D.F.',NULL,'05033','Mexico'),
  (10355,'AROUT',6,'1996-11-15','1996-12-13','1996-11-20',1,41.95,'Around the Horn','Brook Farm Stratford St. Mary','Colchester','Essex','CO7 6JX','UK'),
  (10356,'WANDK',6,'1996-11-18','1996-12-16','1996-11-27',2,36.71,'Die Wandernde Kuh','Adenauerallee 900','Stuttgart',NULL,'70563','Germany'),
  (10357,'LILAS',1,'1996-11-19','1996-12-17','1996-12-02',3,34.88,'LILA-Supermercado','Carrera 52 con Ave. Bolívar #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela'),
  (10358,'LAMAI',5,'1996-11-20','1996-12-18','1996-11-27',1,19.64,'La maison d''Asie','1 rue Alsace-Lorraine','Toulouse',NULL,'31000','France'),
  (10359,'SEVES',5,'1996-11-21','1996-12-19','1996-11-26',3,288.43,'Seven Seas Imports','90 Wadhurst Rd.','London',NULL,'OX15 4NB','UK'),
  (10360,'BLONP',4,'1996-11-22','1996-12-20','1996-12-02',3,131.7,'Blondel père et fils','24, place Kléber','Strasbourg',NULL,'67000','France'),
  (10361,'QUICK',1,'1996-11-22','1996-12-20','1996-12-03',2,183.17,'QUICK-Stop','Taucherstraße 10','Cunewalde',NULL,'01307','Germany'),
  (10362,'BONAP',3,'1996-11-25','1996-12-23','1996-11-28',1,96.04,'Bon app''','12, rue des Bouchers','Marseille',NULL,'13008','France'),
  (10363,'DRACD',4,'1996-11-26','1996-12-24','1996-12-04',3,30.54,'Drachenblut Delikatessen','Walserweg 21','Aachen',NULL,'52066','Germany'),
  (10364,'EASTC',1,'1996-11-26','1997-01-07','1996-12-04',1,71.97,'Eastern Connection','35 King George','London',NULL,'WX3 6FW','UK'),
  (10365,'ANTON',3,'1996-11-27','1996-12-25','1996-12-02',2,22,'Antonio Moreno Taquería','Mataderos  2312','México D.F.',NULL,'05023','Mexico'),
  (10366,'GALED',8,'1996-11-28','1997-01-09','1996-12-30',2,10.14,'Galería del gastronómo','Rambla de Cataluña, 23','Barcelona',NULL,'8022','Spain'),
  (10367,'VAFFE',7,'1996-11-28','1996-12-26','1996-12-02',3,13.55,'Vaffeljernet','Smagsloget 45','Århus',NULL,'8200','Denmark'),
  (10368,'ERNSH',2,'1996-11-29','1996-12-27','1996-12-02',2,101.95,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (10369,'SPLIR',8,'1996-12-02','1996-12-30','1996-12-09',2,195.68,'Split Rail Beer & Ale','P.O. Box 555','Lander','WY','82520','USA'),
  (10370,'CHOPS',6,'1996-12-03','1996-12-31','1996-12-27',2,1.17,'Chop-suey Chinese','Hauptstr. 31','Bern',NULL,'3012','Switzerland'),
  (10371,'LAMAI',1,'1996-12-03','1996-12-31','1996-12-24',1,0.45,'La maison d''Asie','1 rue Alsace-Lorraine','Toulouse',NULL,'31000','France'),
  (10372,'QUEEN',5,'1996-12-04','1997-01-01','1996-12-09',2,890.78,'Queen Cozinha','Alameda dos Canàrios, 891','Sao Paulo','SP','05487-020','Brazil'),
  (10373,'HUNGO',4,'1996-12-05','1997-01-02','1996-12-11',3,124.12,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',NULL,'Ireland'),
  (10374,'WOLZA',1,'1996-12-05','1997-01-02','1996-12-09',3,3.94,'Wolski Zajazd','ul. Filtrowa 68','Warszawa',NULL,'01-012','Poland'),
  (10375,'HUNGC',3,'1996-12-06','1997-01-03','1996-12-09',2,20.12,'Hungry Coyote Import Store','City Center Plaza 516 Main St.','Elgin','OR','97827','USA'),
  (10376,'MEREP',1,'1996-12-09','1997-01-06','1996-12-13',2,20.39,'Mère Paillarde','43 rue St. Laurent','Montréal','Québec','H1J 1C3','Canada'),
  (10377,'SEVES',1,'1996-12-09','1997-01-06','1996-12-13',3,22.21,'Seven Seas Imports','90 Wadhurst Rd.','London',NULL,'OX15 4NB','UK'),
  (10378,'FOLKO',5,'1996-12-10','1997-01-07','1996-12-19',3,5.44,'Folk och fä HB','Åkergatan 24','Bräcke',NULL,'S-844 67','Sweden'),
  (10379,'QUEDE',2,'1996-12-11','1997-01-08','1996-12-13',1,45.03,'Que Delícia','Rua da Panificadora, 12','Rio de Janeiro','RJ','02389-673','Brazil'),
  (10380,'HUNGO',8,'1996-12-12','1997-01-09','1997-01-16',3,35.03,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',NULL,'Ireland'),
  (10381,'LILAS',3,'1996-12-12','1997-01-09','1996-12-13',3,7.99,'LILA-Supermercado','Carrera 52 con Ave. Bolívar #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela'),
  (10382,'ERNSH',4,'1996-12-13','1997-01-10','1996-12-16',1,94.77,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (10383,'AROUT',8,'1996-12-16','1997-01-13','1996-12-18',3,34.24,'Around the Horn','Brook Farm Stratford St. Mary','Colchester','Essex','CO7 6JX','UK'),
  (10384,'BERGS',3,'1996-12-16','1997-01-13','1996-12-20',3,168.64,'Berglunds snabbköp','Berguvsvägen  8','Luleå',NULL,'S-958 22','Sweden'),
  (10385,'SPLIR',1,'1996-12-17','1997-01-14','1996-12-23',2,30.96,'Split Rail Beer & Ale','P.O. Box 555','Lander','WY','82520','USA'),
  (10386,'FAMIA',9,'1996-12-18','1997-01-01','1996-12-25',3,13.99,'Familia Arquibaldo','Rua Orós, 92','Sao Paulo','SP','05442-030','Brazil'),
  (10387,'SANTG',1,'1996-12-18','1997-01-15','1996-12-20',2,93.63,'Santé Gourmet','Erling Skakkes gate 78','Stavern',NULL,'4110','Norway'),
  (10388,'SEVES',2,'1996-12-19','1997-01-16','1996-12-20',1,34.86,'Seven Seas Imports','90 Wadhurst Rd.','London',NULL,'OX15 4NB','UK'),
  (10389,'BOTTM',4,'1996-12-20','1997-01-17','1996-12-24',2,47.42,'Bottom-Dollar Markets','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada'),
  (10390,'ERNSH',6,'1996-12-23','1997-01-20','1996-12-26',1,126.38,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (10391,'DRACD',3,'1996-12-23','1997-01-20','1996-12-31',3,5.45,'Drachenblut Delikatessen','Walserweg 21','Aachen',NULL,'52066','Germany'),
  (10392,'PICCO',2,'1996-12-24','1997-01-21','1997-01-01',3,122.46,'Piccolo und mehr','Geislweg 14','Salzburg',NULL,'5020','Austria'),
  (10393,'SAVEA',1,'1996-12-25','1997-01-22','1997-01-03',3,126.56,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (10394,'HUNGC',1,'1996-12-25','1997-01-22','1997-01-03',3,30.34,'Hungry Coyote Import Store','City Center Plaza 516 Main St.','Elgin','OR','97827','USA'),
  (10395,'HILAA',6,'1996-12-26','1997-01-23','1997-01-03',1,184.41,'HILARION-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Cristóbal','Táchira','5022','Venezuela'),
  (10396,'FRANK',1,'1996-12-27','1997-01-10','1997-01-06',3,135.35,'Frankenversand','Berliner Platz 43','München',NULL,'80805','Germany'),
  (10397,'PRINI',5,'1996-12-27','1997-01-24','1997-01-02',1,60.26,'Princesa Isabel Vinhos','Estrada da saúde n. 58','Lisboa',NULL,'1756','Portugal'),
  (10398,'SAVEA',2,'1996-12-30','1997-01-27','1997-01-09',3,89.16,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (10399,'VAFFE',8,'1996-12-31','1997-01-14','1997-01-08',3,27.36,'Vaffeljernet','Smagsloget 45','Århus',NULL,'8200','Denmark'),
  (10400,'EASTC',1,'1997-01-01','1997-01-29','1997-01-16',3,83.93,'Eastern Connection','35 King George','London',NULL,'WX3 6FW','UK'),
  (10401,'RATTC',1,'1997-01-01','1997-01-29','1997-01-10',1,12.51,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA'),
  (10402,'ERNSH',8,'1997-01-02','1997-02-13','1997-01-10',2,67.88,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (10403,'ERNSH',4,'1997-01-03','1997-01-31','1997-01-09',3,73.79,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (10404,'MAGAA',2,'1997-01-03','1997-01-31','1997-01-08',1,155.97,'Magazzini Alimentari Riuniti','Via Ludovico il Moro 22','Bergamo',NULL,'24100','Italy'),
  (10405,'LINOD',1,'1997-01-06','1997-02-03','1997-01-22',1,34.82,'LINO-Delicateses','Ave. 5 de Mayo Porlamar','I. de Margarita','Nueva Esparta','4980','Venezuela'),
  (10406,'QUEEN',7,'1997-01-07','1997-02-18','1997-01-13',1,108.04,'Queen Cozinha','Alameda dos Canàrios, 891','Sao Paulo','SP','05487-020','Brazil'),
  (10407,'OTTIK',2,'1997-01-07','1997-02-04','1997-01-30',2,91.48,'Ottilies Käseladen','Mehrheimerstr. 369','Köln',NULL,'50739','Germany'),
  (10408,'FOLIG',8,'1997-01-08','1997-02-05','1997-01-14',1,11.26,'Folies gourmandes','184, chaussée de Tournai','Lille',NULL,'59000','France'),
  (10409,'OCEAN',3,'1997-01-09','1997-02-06','1997-01-14',1,29.83,'Océano Atlántico Ltda.','Ing. Gustavo Moncada 8585 Piso 20-A','Buenos Aires',NULL,'1010','Argentina'),
  (10410,'BOTTM',3,'1997-01-10','1997-02-07','1997-01-15',3,2.4,'Bottom-Dollar Markets','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada'),
  (10411,'BOTTM',9,'1997-01-10','1997-02-07','1997-01-21',3,23.65,'Bottom-Dollar Markets','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada'),
  (10412,'WARTH',8,'1997-01-13','1997-02-10','1997-01-15',2,3.77,'Wartian Herkku','Torikatu 38','Oulu',NULL,'90110','Finland'),
  (10413,'LAMAI',3,'1997-01-14','1997-02-11','1997-01-16',2,95.66,'La maison d''Asie','1 rue Alsace-Lorraine','Toulouse',NULL,'31000','France'),
  (10414,'FAMIA',2,'1997-01-14','1997-02-11','1997-01-17',3,21.48,'Familia Arquibaldo','Rua Orós, 92','Sao Paulo','SP','05442-030','Brazil'),
  (10415,'HUNGC',3,'1997-01-15','1997-02-12','1997-01-24',1,0.2,'Hungry Coyote Import Store','City Center Plaza 516 Main St.','Elgin','OR','97827','USA'),
  (10416,'WARTH',8,'1997-01-16','1997-02-13','1997-01-27',3,22.72,'Wartian Herkku','Torikatu 38','Oulu',NULL,'90110','Finland'),
  (10417,'SIMOB',4,'1997-01-16','1997-02-13','1997-01-28',3,70.29,'Simons bistro','Vinbæltet 34','Kobenhavn',NULL,'1734','Denmark'),
  (10418,'QUICK',4,'1997-01-17','1997-02-14','1997-01-24',1,17.55,'QUICK-Stop','Taucherstraße 10','Cunewalde',NULL,'01307','Germany'),
  (10419,'RICSU',4,'1997-01-20','1997-02-17','1997-01-30',2,137.35,'Richter Supermarkt','Starenweg 5','Genève',NULL,'1204','Switzerland'),
  (10420,'WELLI',3,'1997-01-21','1997-02-18','1997-01-27',1,44.12,'Wellington Importadora','Rua do Mercado, 12','Resende','SP','08737-363','Brazil'),
  (10421,'QUEDE',8,'1997-01-21','1997-03-04','1997-01-27',1,99.23,'Que Delícia','Rua da Panificadora, 12','Rio de Janeiro','RJ','02389-673','Brazil'),
  (10422,'FRANS',2,'1997-01-22','1997-02-19','1997-01-31',1,3.02,'Franchi S.p.A.','Via Monte Bianco 34','Torino',NULL,'10100','Italy'),
  (10423,'GOURL',6,'1997-01-23','1997-02-06','1997-02-24',3,24.5,'Gourmet Lanchonetes','Av. Brasil, 442','Campinas','SP','04876-786','Brazil'),
  (10424,'MEREP',7,'1997-01-23','1997-02-20','1997-01-27',2,370.61,'Mère Paillarde','43 rue St. Laurent','Montréal','Québec','H1J 1C3','Canada'),
  (10425,'LAMAI',6,'1997-01-24','1997-02-21','1997-02-14',2,7.93,'La maison d''Asie','1 rue Alsace-Lorraine','Toulouse',NULL,'31000','France'),
  (10426,'GALED',4,'1997-01-27','1997-02-24','1997-02-06',1,18.69,'Galería del gastronómo','Rambla de Cataluña, 23','Barcelona',NULL,'8022','Spain'),
  (10427,'PICCO',4,'1997-01-27','1997-02-24','1997-03-03',2,31.29,'Piccolo und mehr','Geislweg 14','Salzburg',NULL,'5020','Austria'),
  (10428,'REGGC',7,'1997-01-28','1997-02-25','1997-02-04',1,11.09,'Reggiani Caseifici','Strada Provinciale 124','Reggio Emilia',NULL,'42100','Italy'),
  (10429,'HUNGO',3,'1997-01-29','1997-03-12','1997-02-07',2,56.63,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',NULL,'Ireland'),
  (10430,'ERNSH',4,'1997-01-30','1997-02-13','1997-02-03',1,458.78,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (10431,'BOTTM',4,'1997-01-30','1997-02-13','1997-02-07',2,44.17,'Bottom-Dollar Markets','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada'),
  (10432,'SPLIR',3,'1997-01-31','1997-02-14','1997-02-07',2,4.34,'Split Rail Beer & Ale','P.O. Box 555','Lander','WY','82520','USA'),
  (10433,'PRINI',3,'1997-02-03','1997-03-03','1997-03-04',3,73.83,'Princesa Isabel Vinhos','Estrada da saúde n. 58','Lisboa',NULL,'1756','Portugal'),
  (10434,'FOLKO',3,'1997-02-03','1997-03-03','1997-02-13',2,17.92,'Folk och fä HB','Åkergatan 24','Bräcke',NULL,'S-844 67','Sweden'),
  (10435,'CONSH',8,'1997-02-04','1997-03-18','1997-02-07',2,9.21,'Consolidated Holdings','Berkeley Gardens 12  Brewery','London',NULL,'WX1 6LT','UK'),
  (10436,'BLONP',3,'1997-02-05','1997-03-05','1997-02-11',2,156.66,'Blondel père et fils','24, place Kléber','Strasbourg',NULL,'67000','France'),
  (10437,'WARTH',8,'1997-02-05','1997-03-05','1997-02-12',1,19.97,'Wartian Herkku','Torikatu 38','Oulu',NULL,'90110','Finland'),
  (10438,'TOMSP',3,'1997-02-06','1997-03-06','1997-02-14',2,8.24,'Toms Spezialitäten','Luisenstr. 48','Münster',NULL,'44087','Germany'),
  (10439,'MEREP',6,'1997-02-07','1997-03-07','1997-02-10',3,4.07,'Mère Paillarde','43 rue St. Laurent','Montréal','Québec','H1J 1C3','Canada'),
  (10440,'SAVEA',4,'1997-02-10','1997-03-10','1997-02-28',2,86.53,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (10441,'OLDWO',3,'1997-02-10','1997-03-24','1997-03-14',2,73.02,'Old World Delicatessen','2743 Bering St.','Anchorage','AK','99508','USA'),
  (10442,'ERNSH',3,'1997-02-11','1997-03-11','1997-02-18',2,47.94,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (10443,'REGGC',8,'1997-02-12','1997-03-12','1997-02-14',1,13.95,'Reggiani Caseifici','Strada Provinciale 124','Reggio Emilia',NULL,'42100','Italy'),
  (10444,'BERGS',3,'1997-02-12','1997-03-12','1997-02-21',3,3.5,'Berglunds snabbköp','Berguvsvägen  8','Luleå',NULL,'S-958 22','Sweden'),
  (10445,'BERGS',3,'1997-02-13','1997-03-13','1997-02-20',1,9.3,'Berglunds snabbköp','Berguvsvägen  8','Luleå',NULL,'S-958 22','Sweden'),
  (10446,'TOMSP',6,'1997-02-14','1997-03-14','1997-02-19',1,14.68,'Toms Spezialitäten','Luisenstr. 48','Münster',NULL,'44087','Germany'),
  (10447,'RICAR',4,'1997-02-14','1997-03-14','1997-03-07',2,68.66,'Ricardo Adocicados','Av. Copacabana, 267','Rio de Janeiro','RJ','02389-890','Brazil'),
  (10448,'RANCH',4,'1997-02-17','1997-03-17','1997-02-24',2,38.82,'Rancho grande','Av. del Libertador 900','Buenos Aires',NULL,'1010','Argentina'),
  (10449,'BLONP',3,'1997-02-18','1997-03-18','1997-02-27',2,53.3,'Blondel père et fils','24, place Kléber','Strasbourg',NULL,'67000','France'),
  (10450,'VICTE',8,'1997-02-19','1997-03-19','1997-03-11',2,7.23,'Victuailles en stock','2, rue du Commerce','Lyon',NULL,'69004','France'),
  (10451,'QUICK',4,'1997-02-19','1997-03-05','1997-03-12',3,189.09,'QUICK-Stop','Taucherstraße 10','Cunewalde',NULL,'01307','Germany'),
  (10452,'SAVEA',8,'1997-02-20','1997-03-20','1997-02-26',1,140.26,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (10453,'AROUT',1,'1997-02-21','1997-03-21','1997-02-26',2,25.36,'Around the Horn','Brook Farm Stratford St. Mary','Colchester','Essex','CO7 6JX','UK'),
  (10454,'LAMAI',4,'1997-02-21','1997-03-21','1997-02-25',3,2.74,'La maison d''Asie','1 rue Alsace-Lorraine','Toulouse',NULL,'31000','France'),
  (10455,'WARTH',8,'1997-02-24','1997-04-07','1997-03-03',2,180.45,'Wartian Herkku','Torikatu 38','Oulu',NULL,'90110','Finland'),
  (10456,'KOENE',8,'1997-02-25','1997-04-08','1997-02-28',2,8.12,'Königlich Essen','Maubelstr. 90','Brandenburg',NULL,'14776','Germany'),
  (10457,'KOENE',2,'1997-02-25','1997-03-25','1997-03-03',1,11.57,'Königlich Essen','Maubelstr. 90','Brandenburg',NULL,'14776','Germany'),
  (10458,'SUPRD',7,'1997-02-26','1997-03-26','1997-03-04',3,147.06,'Suprêmes délices','Boulevard Tirou, 255','Charleroi',NULL,'B-6000','Belgium'),
  (10459,'VICTE',4,'1997-02-27','1997-03-27','1997-02-28',2,25.09,'Victuailles en stock','2, rue du Commerce','Lyon',NULL,'69004','France'),
  (10460,'FOLKO',8,'1997-02-28','1997-03-28','1997-03-03',1,16.27,'Folk och fä HB','Åkergatan 24','Bräcke',NULL,'S-844 67','Sweden'),
  (10461,'LILAS',1,'1997-02-28','1997-03-28','1997-03-05',3,148.61,'LILA-Supermercado','Carrera 52 con Ave. Bolívar #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela'),
  (10462,'CONSH',2,'1997-03-03','1997-03-31','1997-03-18',1,6.17,'Consolidated Holdings','Berkeley Gardens 12  Brewery','London',NULL,'WX1 6LT','UK'),
  (10463,'SUPRD',5,'1997-03-04','1997-04-01','1997-03-06',3,14.78,'Suprêmes délices','Boulevard Tirou, 255','Charleroi',NULL,'B-6000','Belgium'),
  (10464,'FURIB',4,'1997-03-04','1997-04-01','1997-03-14',2,89,'Furia Bacalhau e Frutos do Mar','Jardim das rosas n. 32','Lisboa',NULL,'1675','Portugal'),
  (10465,'VAFFE',1,'1997-03-05','1997-04-02','1997-03-14',3,145.04,'Vaffeljernet','Smagsloget 45','Århus',NULL,'8200','Denmark'),
  (10466,'COMMI',4,'1997-03-06','1997-04-03','1997-03-13',1,11.93,'Comércio Mineiro','Av. dos Lusíadas, 23','Sao Paulo','SP','05432-043','Brazil'),
  (10467,'MAGAA',8,'1997-03-06','1997-04-03','1997-03-11',2,4.93,'Magazzini Alimentari Riuniti','Via Ludovico il Moro 22','Bergamo',NULL,'24100','Italy'),
  (10468,'KOENE',3,'1997-03-07','1997-04-04','1997-03-12',3,44.12,'Königlich Essen','Maubelstr. 90','Brandenburg',NULL,'14776','Germany'),
  (10469,'WHITC',1,'1997-03-10','1997-04-07','1997-03-14',1,60.18,'White Clover Markets','1029 - 12th Ave. S.','Seattle','WA','98124','USA'),
  (10470,'BONAP',4,'1997-03-11','1997-04-08','1997-03-14',2,64.56,'Bon app''','12, rue des Bouchers','Marseille',NULL,'13008','France'),
  (10471,'BSBEV',2,'1997-03-11','1997-04-08','1997-03-18',3,45.59,'B''s Beverages','Fauntleroy Circus','London',NULL,'EC2 5NT','UK'),
  (10472,'SEVES',8,'1997-03-12','1997-04-09','1997-03-19',1,4.2,'Seven Seas Imports','90 Wadhurst Rd.','London',NULL,'OX15 4NB','UK'),
  (10473,'ISLAT',1,'1997-03-13','1997-03-27','1997-03-21',3,16.37,'Island Trading','Garden House Crowther Way','Cowes','Isle of Wight','PO31 7PJ','UK'),
  (10474,'PERIC',5,'1997-03-13','1997-04-10','1997-03-21',2,83.49,'Pericles Comidas clásicas','Calle Dr. Jorge Cash 321','México D.F.',NULL,'05033','Mexico'),
  (10475,'SUPRD',9,'1997-03-14','1997-04-11','1997-04-04',1,68.52,'Suprêmes délices','Boulevard Tirou, 255','Charleroi',NULL,'B-6000','Belgium'),
  (10476,'HILAA',8,'1997-03-17','1997-04-14','1997-03-24',3,4.41,'HILARION-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Cristóbal','Táchira','5022','Venezuela'),
  (10477,'PRINI',5,'1997-03-17','1997-04-14','1997-03-25',2,13.02,'Princesa Isabel Vinhos','Estrada da saúde n. 58','Lisboa',NULL,'1756','Portugal'),
  (10478,'VICTE',2,'1997-03-18','1997-04-01','1997-03-26',3,4.81,'Victuailles en stock','2, rue du Commerce','Lyon',NULL,'69004','France'),
  (10479,'RATTC',3,'1997-03-19','1997-04-16','1997-03-21',3,708.95,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA'),
  (10480,'FOLIG',6,'1997-03-20','1997-04-17','1997-03-24',2,1.35,'Folies gourmandes','184, chaussée de Tournai','Lille',NULL,'59000','France'),
  (10481,'RICAR',8,'1997-03-20','1997-04-17','1997-03-25',2,64.33,'Ricardo Adocicados','Av. Copacabana, 267','Rio de Janeiro','RJ','02389-890','Brazil'),
  (10482,'LAZYK',1,'1997-03-21','1997-04-18','1997-04-10',3,7.48,'Lazy K Kountry Store','12 Orchestra Terrace','Walla Walla','WA','99362','USA'),
  (10483,'WHITC',7,'1997-03-24','1997-04-21','1997-04-25',2,15.28,'White Clover Markets','1029 - 12th Ave. S.','Seattle','WA','98124','USA'),
  (10484,'BSBEV',3,'1997-03-24','1997-04-21','1997-04-01',3,6.88,'B''s Beverages','Fauntleroy Circus','London',NULL,'EC2 5NT','UK'),
  (10485,'LINOD',4,'1997-03-25','1997-04-08','1997-03-31',2,64.45,'LINO-Delicateses','Ave. 5 de Mayo Porlamar','I. de Margarita','Nueva Esparta','4980','Venezuela'),
  (10486,'HILAA',1,'1997-03-26','1997-04-23','1997-04-02',2,30.53,'HILARION-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Cristóbal','Táchira','5022','Venezuela'),
  (10487,'QUEEN',2,'1997-03-26','1997-04-23','1997-03-28',2,71.07,'Queen Cozinha','Alameda dos Canàrios, 891','Sao Paulo','SP','05487-020','Brazil'),
  (10488,'FRANK',8,'1997-03-27','1997-04-24','1997-04-02',2,4.93,'Frankenversand','Berliner Platz 43','München',NULL,'80805','Germany'),
  (10489,'PICCO',6,'1997-03-28','1997-04-25','1997-04-09',2,5.29,'Piccolo und mehr','Geislweg 14','Salzburg',NULL,'5020','Austria'),
  (10490,'HILAA',7,'1997-03-31','1997-04-28','1997-04-03',2,210.19,'HILARION-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Cristóbal','Táchira','5022','Venezuela'),
  (10491,'FURIB',8,'1997-03-31','1997-04-28','1997-04-08',3,16.96,'Furia Bacalhau e Frutos do Mar','Jardim das rosas n. 32','Lisboa',NULL,'1675','Portugal'),
  (10492,'BOTTM',3,'1997-04-01','1997-04-29','1997-04-11',1,62.89,'Bottom-Dollar Markets','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada'),
  (10493,'LAMAI',4,'1997-04-02','1997-04-30','1997-04-10',3,10.64,'La maison d''Asie','1 rue Alsace-Lorraine','Toulouse',NULL,'31000','France'),
  (10494,'COMMI',4,'1997-04-02','1997-04-30','1997-04-09',2,65.99,'Comércio Mineiro','Av. dos Lusíadas, 23','Sao Paulo','SP','05432-043','Brazil'),
  (10495,'LAUGB',3,'1997-04-03','1997-05-01','1997-04-11',3,4.65,'Laughing Bacchus Wine Cellars','2319 Elm St.','Vancouver','BC','V3F 2K1','Canada'),
  (10496,'TRADH',7,'1997-04-04','1997-05-02','1997-04-07',2,46.77,'Tradiçao Hipermercados','Av. Inês de Castro, 414','Sao Paulo','SP','05634-030','Brazil'),
  (10497,'LEHMS',7,'1997-04-04','1997-05-02','1997-04-07',1,36.21,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M.',NULL,'60528','Germany'),
  (10498,'HILAA',8,'1997-04-07','1997-05-05','1997-04-11',2,29.75,'HILARION-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Cristóbal','Táchira','5022','Venezuela'),
  (10499,'LILAS',4,'1997-04-08','1997-05-06','1997-04-16',2,102.02,'LILA-Supermercado','Carrera 52 con Ave. Bolívar #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela'),
  (10500,'LAMAI',6,'1997-04-09','1997-05-07','1997-04-17',1,42.68,'La maison d''Asie','1 rue Alsace-Lorraine','Toulouse',NULL,'31000','France'),
  (10501,'BLAUS',9,'1997-04-09','1997-05-07','1997-04-16',3,8.85,'Blauer See Delikatessen','Forsterstr. 57','Mannheim',NULL,'68306','Germany'),
  (10502,'PERIC',2,'1997-04-10','1997-05-08','1997-04-29',1,69.32,'Pericles Comidas clásicas','Calle Dr. Jorge Cash 321','México D.F.',NULL,'05033','Mexico'),
  (10503,'HUNGO',6,'1997-04-11','1997-05-09','1997-04-16',2,16.74,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',NULL,'Ireland'),
  (10504,'WHITC',4,'1997-04-11','1997-05-09','1997-04-18',3,59.13,'White Clover Markets','1029 - 12th Ave. S.','Seattle','WA','98124','USA'),
  (10505,'MEREP',3,'1997-04-14','1997-05-12','1997-04-21',3,7.13,'Mère Paillarde','43 rue St. Laurent','Montréal','Québec','H1J 1C3','Canada'),
  (10506,'KOENE',9,'1997-04-15','1997-05-13','1997-05-02',2,21.19,'Königlich Essen','Maubelstr. 90','Brandenburg',NULL,'14776','Germany'),
  (10507,'ANTON',7,'1997-04-15','1997-05-13','1997-04-22',1,47.45,'Antonio Moreno Taquería','Mataderos  2312','México D.F.',NULL,'05023','Mexico'),
  (10508,'OTTIK',1,'1997-04-16','1997-05-14','1997-05-13',2,4.99,'Ottilies Käseladen','Mehrheimerstr. 369','Köln',NULL,'50739','Germany'),
  (10509,'BLAUS',4,'1997-04-17','1997-05-15','1997-04-29',1,0.15,'Blauer See Delikatessen','Forsterstr. 57','Mannheim',NULL,'68306','Germany'),
  (10510,'SAVEA',6,'1997-04-18','1997-05-16','1997-04-28',3,367.63,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (10511,'BONAP',4,'1997-04-18','1997-05-16','1997-04-21',3,350.64,'Bon app''','12, rue des Bouchers','Marseille',NULL,'13008','France'),
  (10512,'FAMIA',7,'1997-04-21','1997-05-19','1997-04-24',2,3.53,'Familia Arquibaldo','Rua Orós, 92','Sao Paulo','SP','05442-030','Brazil'),
  (10513,'WANDK',7,'1997-04-22','1997-06-03','1997-04-28',1,105.65,'Die Wandernde Kuh','Adenauerallee 900','Stuttgart',NULL,'70563','Germany'),
  (10514,'ERNSH',3,'1997-04-22','1997-05-20','1997-05-16',2,789.95,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (10515,'QUICK',2,'1997-04-23','1997-05-07','1997-05-23',1,204.47,'QUICK-Stop','Taucherstraße 10','Cunewalde',NULL,'01307','Germany'),
  (10516,'HUNGO',2,'1997-04-24','1997-05-22','1997-05-01',3,62.78,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',NULL,'Ireland'),
  (10517,'NORTS',3,'1997-04-24','1997-05-22','1997-04-29',3,32.07,'North/South','South House 300 Queensbridge','London',NULL,'SW7 1RZ','UK'),
  (10518,'TORTU',4,'1997-04-25','1997-05-09','1997-05-05',2,218.15,'Tortuga Restaurante','Avda. Azteca 123','México D.F.',NULL,'05033','Mexico'),
  (10519,'CHOPS',6,'1997-04-28','1997-05-26','1997-05-01',3,91.76,'Chop-suey Chinese','Hauptstr. 31','Bern',NULL,'3012','Switzerland'),
  (10520,'SANTG',7,'1997-04-29','1997-05-27','1997-05-01',1,13.37,'Santé Gourmet','Erling Skakkes gate 78','Stavern',NULL,'4110','Norway'),
  (10521,'CACTU',8,'1997-04-29','1997-05-27','1997-05-02',2,17.22,'Cactus Comidas para llevar','Cerrito 333','Buenos Aires',NULL,'1010','Argentina'),
  (10522,'LEHMS',4,'1997-04-30','1997-05-28','1997-05-06',1,45.33,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M.',NULL,'60528','Germany'),
  (10523,'SEVES',7,'1997-05-01','1997-05-29','1997-05-30',2,77.63,'Seven Seas Imports','90 Wadhurst Rd.','London',NULL,'OX15 4NB','UK'),
  (10524,'BERGS',1,'1997-05-01','1997-05-29','1997-05-07',2,244.79,'Berglunds snabbköp','Berguvsvägen  8','Luleå',NULL,'S-958 22','Sweden'),
  (10525,'BONAP',1,'1997-05-02','1997-05-30','1997-05-23',2,11.06,'Bon app''','12, rue des Bouchers','Marseille',NULL,'13008','France'),
  (10526,'WARTH',4,'1997-05-05','1997-06-02','1997-05-15',2,58.59,'Wartian Herkku','Torikatu 38','Oulu',NULL,'90110','Finland'),
  (10527,'QUICK',7,'1997-05-05','1997-06-02','1997-05-07',1,41.9,'QUICK-Stop','Taucherstraße 10','Cunewalde',NULL,'01307','Germany'),
  (10528,'GREAL',6,'1997-05-06','1997-05-20','1997-05-09',2,3.35,'Great Lakes Food Market','2732 Baker Blvd.','Eugene','OR','97403','USA'),
  (10529,'MAISD',5,'1997-05-07','1997-06-04','1997-05-09',2,66.69,'Maison Dewey','Rue Joseph-Bens 532','Bruxelles',NULL,'B-1180','Belgium'),
  (10530,'PICCO',3,'1997-05-08','1997-06-05','1997-05-12',2,339.22,'Piccolo und mehr','Geislweg 14','Salzburg',NULL,'5020','Austria'),
  (10531,'OCEAN',7,'1997-05-08','1997-06-05','1997-05-19',1,8.12,'Océano Atlántico Ltda.','Ing. Gustavo Moncada 8585 Piso 20-A','Buenos Aires',NULL,'1010','Argentina'),
  (10532,'EASTC',7,'1997-05-09','1997-06-06','1997-05-12',3,74.46,'Eastern Connection','35 King George','London',NULL,'WX3 6FW','UK'),
  (10533,'FOLKO',8,'1997-05-12','1997-06-09','1997-05-22',1,188.04,'Folk och fä HB','Åkergatan 24','Bräcke',NULL,'S-844 67','Sweden'),
  (10534,'LEHMS',8,'1997-05-12','1997-06-09','1997-05-14',2,27.94,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M.',NULL,'60528','Germany'),
  (10535,'ANTON',4,'1997-05-13','1997-06-10','1997-05-21',1,15.64,'Antonio Moreno Taquería','Mataderos  2312','México D.F.',NULL,'05023','Mexico'),
  (10536,'LEHMS',3,'1997-05-14','1997-06-11','1997-06-06',2,58.88,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M.',NULL,'60528','Germany'),
  (10537,'RICSU',1,'1997-05-14','1997-05-28','1997-05-19',1,78.85,'Richter Supermarkt','Starenweg 5','Genève',NULL,'1204','Switzerland'),
  (10538,'BSBEV',9,'1997-05-15','1997-06-12','1997-05-16',3,4.87,'B''s Beverages','Fauntleroy Circus','London',NULL,'EC2 5NT','UK'),
  (10539,'BSBEV',6,'1997-05-16','1997-06-13','1997-05-23',3,12.36,'B''s Beverages','Fauntleroy Circus','London',NULL,'EC2 5NT','UK'),
  (10540,'QUICK',3,'1997-05-19','1997-06-16','1997-06-13',3,1007.64,'QUICK-Stop','Taucherstraße 10','Cunewalde',NULL,'01307','Germany'),
  (10541,'HANAR',2,'1997-05-19','1997-06-16','1997-05-29',1,68.65,'Hanari Carnes','Rua do Paço, 67','Rio de Janeiro','RJ','05454-876','Brazil'),
  (10542,'KOENE',1,'1997-05-20','1997-06-17','1997-05-26',3,10.95,'Königlich Essen','Maubelstr. 90','Brandenburg',NULL,'14776','Germany'),
  (10543,'LILAS',8,'1997-05-21','1997-06-18','1997-05-23',2,48.17,'LILA-Supermercado','Carrera 52 con Ave. Bolívar #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela'),
  (10544,'LONEP',4,'1997-05-21','1997-06-18','1997-05-30',1,24.91,'Lonesome Pine Restaurant','89 Chiaroscuro Rd.','Portland','OR','97219','USA'),
  (10545,'LAZYK',8,'1997-05-22','1997-06-19','1997-06-26',2,11.92,'Lazy K Kountry Store','12 Orchestra Terrace','Walla Walla','WA','99362','USA'),
  (10546,'VICTE',1,'1997-05-23','1997-06-20','1997-05-27',3,194.72,'Victuailles en stock','2, rue du Commerce','Lyon',NULL,'69004','France'),
  (10547,'SEVES',3,'1997-05-23','1997-06-20','1997-06-02',2,178.43,'Seven Seas Imports','90 Wadhurst Rd.','London',NULL,'OX15 4NB','UK'),
  (10548,'TOMSP',3,'1997-05-26','1997-06-23','1997-06-02',2,1.43,'Toms Spezialitäten','Luisenstr. 48','Münster',NULL,'44087','Germany'),
  (10549,'QUICK',5,'1997-05-27','1997-06-10','1997-05-30',1,171.24,'QUICK-Stop','Taucherstraße 10','Cunewalde',NULL,'01307','Germany'),
  (10550,'GODOS',7,'1997-05-28','1997-06-25','1997-06-06',3,4.32,'Godos Cocina Típica','C/ Romero, 33','Sevilla',NULL,'41101','Spain'),
  (10551,'FURIB',4,'1997-05-28','1997-07-09','1997-06-06',3,72.95,'Furia Bacalhau e Frutos do Mar','Jardim das rosas n. 32','Lisboa',NULL,'1675','Portugal'),
  (10552,'HILAA',2,'1997-05-29','1997-06-26','1997-06-05',1,83.22,'HILARION-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Cristóbal','Táchira','5022','Venezuela'),
  (10553,'WARTH',2,'1997-05-30','1997-06-27','1997-06-03',2,149.49,'Wartian Herkku','Torikatu 38','Oulu',NULL,'90110','Finland'),
  (10554,'OTTIK',4,'1997-05-30','1997-06-27','1997-06-05',3,120.97,'Ottilies Käseladen','Mehrheimerstr. 369','Köln',NULL,'50739','Germany'),
  (10555,'SAVEA',6,'1997-06-02','1997-06-30','1997-06-04',3,252.49,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (10556,'SIMOB',2,'1997-06-03','1997-07-15','1997-06-13',1,9.8,'Simons bistro','Vinbæltet 34','Kobenhavn',NULL,'1734','Denmark'),
  (10557,'LEHMS',9,'1997-06-03','1997-06-17','1997-06-06',2,96.72,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M.',NULL,'60528','Germany'),
  (10558,'AROUT',1,'1997-06-04','1997-07-02','1997-06-10',2,72.97,'Around the Horn','Brook Farm Stratford St. Mary','Colchester','Essex','CO7 6JX','UK'),
  (10559,'BLONP',6,'1997-06-05','1997-07-03','1997-06-13',1,8.05,'Blondel père et fils','24, place Kléber','Strasbourg',NULL,'67000','France'),
  (10560,'FRANK',8,'1997-06-06','1997-07-04','1997-06-09',1,36.65,'Frankenversand','Berliner Platz 43','München',NULL,'80805','Germany'),
  (10561,'FOLKO',2,'1997-06-06','1997-07-04','1997-06-09',2,242.21,'Folk och fä HB','Åkergatan 24','Bräcke',NULL,'S-844 67','Sweden'),
  (10562,'REGGC',1,'1997-06-09','1997-07-07','1997-06-12',1,22.95,'Reggiani Caseifici','Strada Provinciale 124','Reggio Emilia',NULL,'42100','Italy'),
  (10563,'RICAR',2,'1997-06-10','1997-07-22','1997-06-24',2,60.43,'Ricardo Adocicados','Av. Copacabana, 267','Rio de Janeiro','RJ','02389-890','Brazil'),
  (10564,'RATTC',4,'1997-06-10','1997-07-08','1997-06-16',3,13.75,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA'),
  (10565,'MEREP',8,'1997-06-11','1997-07-09','1997-06-18',2,7.15,'Mère Paillarde','43 rue St. Laurent','Montréal','Québec','H1J 1C3','Canada'),
  (10566,'BLONP',9,'1997-06-12','1997-07-10','1997-06-18',1,88.4,'Blondel père et fils','24, place Kléber','Strasbourg',NULL,'67000','France'),
  (10567,'HUNGO',1,'1997-06-12','1997-07-10','1997-06-17',1,33.97,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',NULL,'Ireland'),
  (10568,'GALED',3,'1997-06-13','1997-07-11','1997-07-09',3,6.54,'Galería del gastronómo','Rambla de Cataluña, 23','Barcelona',NULL,'8022','Spain'),
  (10569,'RATTC',5,'1997-06-16','1997-07-14','1997-07-11',1,58.98,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA'),
  (10570,'MEREP',3,'1997-06-17','1997-07-15','1997-06-19',3,188.99,'Mère Paillarde','43 rue St. Laurent','Montréal','Québec','H1J 1C3','Canada'),
  (10571,'ERNSH',8,'1997-06-17','1997-07-29','1997-07-04',3,26.06,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (10572,'BERGS',3,'1997-06-18','1997-07-16','1997-06-25',2,116.43,'Berglunds snabbköp','Berguvsvägen  8','Luleå',NULL,'S-958 22','Sweden'),
  (10573,'ANTON',7,'1997-06-19','1997-07-17','1997-06-20',3,84.84,'Antonio Moreno Taquería','Mataderos  2312','México D.F.',NULL,'05023','Mexico'),
  (10574,'TRAIH',4,'1997-06-19','1997-07-17','1997-06-30',2,37.6,'Trail''s Head Gourmet Provisioners','722 DaVinci Blvd.','Kirkland','WA','98034','USA'),
  (10575,'MORGK',5,'1997-06-20','1997-07-04','1997-06-30',1,127.34,'Morgenstern Gesundkost','Heerstr. 22','Leipzig',NULL,'04179','Germany'),
  (10576,'TORTU',3,'1997-06-23','1997-07-07','1997-06-30',3,18.56,'Tortuga Restaurante','Avda. Azteca 123','México D.F.',NULL,'05033','Mexico'),
  (10577,'TRAIH',9,'1997-06-23','1997-08-04','1997-06-30',2,25.41,'Trail''s Head Gourmet Provisioners','722 DaVinci Blvd.','Kirkland','WA','98034','USA'),
  (10578,'BSBEV',4,'1997-06-24','1997-07-22','1997-07-25',3,29.6,'B''s Beverages','Fauntleroy Circus','London',NULL,'EC2 5NT','UK'),
  (10579,'LETSS',1,'1997-06-25','1997-07-23','1997-07-04',2,13.73,'Let''s Stop N Shop','87 Polk St. Suite 5','San Francisco','CA','94117','USA'),
  (10580,'OTTIK',4,'1997-06-26','1997-07-24','1997-07-01',3,75.89,'Ottilies Käseladen','Mehrheimerstr. 369','Köln',NULL,'50739','Germany'),
  (10581,'FAMIA',3,'1997-06-26','1997-07-24','1997-07-02',1,3.01,'Familia Arquibaldo','Rua Orós, 92','Sao Paulo','SP','05442-030','Brazil'),
  (10582,'BLAUS',3,'1997-06-27','1997-07-25','1997-07-14',2,27.71,'Blauer See Delikatessen','Forsterstr. 57','Mannheim',NULL,'68306','Germany'),
  (10583,'WARTH',2,'1997-06-30','1997-07-28','1997-07-04',2,7.28,'Wartian Herkku','Torikatu 38','Oulu',NULL,'90110','Finland'),
  (10584,'BLONP',4,'1997-06-30','1997-07-28','1997-07-04',1,59.14,'Blondel père et fils','24, place Kléber','Strasbourg',NULL,'67000','France'),
  (10585,'WELLI',7,'1997-07-01','1997-07-29','1997-07-10',1,13.41,'Wellington Importadora','Rua do Mercado, 12','Resende','SP','08737-363','Brazil'),
  (10586,'REGGC',9,'1997-07-02','1997-07-30','1997-07-09',1,0.48,'Reggiani Caseifici','Strada Provinciale 124','Reggio Emilia',NULL,'42100','Italy'),
  (10587,'QUEDE',1,'1997-07-02','1997-07-30','1997-07-09',1,62.52,'Que Delícia','Rua da Panificadora, 12','Rio de Janeiro','RJ','02389-673','Brazil'),
  (10588,'QUICK',2,'1997-07-03','1997-07-31','1997-07-10',3,194.67,'QUICK-Stop','Taucherstraße 10','Cunewalde',NULL,'01307','Germany'),
  (10589,'GREAL',8,'1997-07-04','1997-08-01','1997-07-14',2,4.42,'Great Lakes Food Market','2732 Baker Blvd.','Eugene','OR','97403','USA'),
  (10590,'MEREP',4,'1997-07-07','1997-08-04','1997-07-14',3,44.77,'Mère Paillarde','43 rue St. Laurent','Montréal','Québec','H1J 1C3','Canada'),
  (10591,'VAFFE',1,'1997-07-07','1997-07-21','1997-07-16',1,55.92,'Vaffeljernet','Smagsloget 45','Århus',NULL,'8200','Denmark'),
  (10592,'LEHMS',3,'1997-07-08','1997-08-05','1997-07-16',1,32.1,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M.',NULL,'60528','Germany'),
  (10593,'LEHMS',7,'1997-07-09','1997-08-06','1997-08-13',2,174.2,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M.',NULL,'60528','Germany'),
  (10594,'OLDWO',3,'1997-07-09','1997-08-06','1997-07-16',2,5.24,'Old World Delicatessen','2743 Bering St.','Anchorage','AK','99508','USA'),
  (10595,'ERNSH',2,'1997-07-10','1997-08-07','1997-07-14',1,96.78,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (10596,'WHITC',8,'1997-07-11','1997-08-08','1997-08-12',1,16.34,'White Clover Markets','1029 - 12th Ave. S.','Seattle','WA','98124','USA'),
  (10597,'PICCO',7,'1997-07-11','1997-08-08','1997-07-18',3,35.12,'Piccolo und mehr','Geislweg 14','Salzburg',NULL,'5020','Austria'),
  (10598,'RATTC',1,'1997-07-14','1997-08-11','1997-07-18',3,44.42,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA'),
  (10599,'BSBEV',6,'1997-07-15','1997-08-26','1997-07-21',3,29.98,'B''s Beverages','Fauntleroy Circus','London',NULL,'EC2 5NT','UK'),
  (10600,'HUNGC',4,'1997-07-16','1997-08-13','1997-07-21',1,45.13,'Hungry Coyote Import Store','City Center Plaza 516 Main St.','Elgin','OR','97827','USA'),
  (10601,'HILAA',7,'1997-07-16','1997-08-27','1997-07-22',1,58.3,'HILARION-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Cristóbal','Táchira','5022','Venezuela'),
  (10602,'VAFFE',8,'1997-07-17','1997-08-14','1997-07-22',2,2.92,'Vaffeljernet','Smagsloget 45','Århus',NULL,'8200','Denmark'),
  (10603,'SAVEA',8,'1997-07-18','1997-08-15','1997-08-08',2,48.77,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (10604,'FURIB',1,'1997-07-18','1997-08-15','1997-07-29',1,7.46,'Furia Bacalhau e Frutos do Mar','Jardim das rosas n. 32','Lisboa',NULL,'1675','Portugal'),
  (10605,'MEREP',1,'1997-07-21','1997-08-18','1997-07-29',2,379.13,'Mère Paillarde','43 rue St. Laurent','Montréal','Québec','H1J 1C3','Canada'),
  (10606,'TRADH',4,'1997-07-22','1997-08-19','1997-07-31',3,79.4,'Tradiçao Hipermercados','Av. Inês de Castro, 414','Sao Paulo','SP','05634-030','Brazil'),
  (10607,'SAVEA',5,'1997-07-22','1997-08-19','1997-07-25',1,200.24,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (10608,'TOMSP',4,'1997-07-23','1997-08-20','1997-08-01',2,27.79,'Toms Spezialitäten','Luisenstr. 48','Münster',NULL,'44087','Germany'),
  (10609,'DUMON',7,'1997-07-24','1997-08-21','1997-07-30',2,1.85,'Du monde entier','67, rue des Cinquante Otages','Nantes',NULL,'44000','France'),
  (10610,'LAMAI',8,'1997-07-25','1997-08-22','1997-08-06',1,26.78,'La maison d''Asie','1 rue Alsace-Lorraine','Toulouse',NULL,'31000','France'),
  (10611,'WOLZA',6,'1997-07-25','1997-08-22','1997-08-01',2,80.65,'Wolski Zajazd','ul. Filtrowa 68','Warszawa',NULL,'01-012','Poland'),
  (10612,'SAVEA',1,'1997-07-28','1997-08-25','1997-08-01',2,544.08,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (10613,'HILAA',4,'1997-07-29','1997-08-26','1997-08-01',2,8.11,'HILARION-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Cristóbal','Táchira','5022','Venezuela'),
  (10614,'BLAUS',8,'1997-07-29','1997-08-26','1997-08-01',3,1.93,'Blauer See Delikatessen','Forsterstr. 57','Mannheim',NULL,'68306','Germany'),
  (10615,'WILMK',2,'1997-07-30','1997-08-27','1997-08-06',3,0.75,'Wilman Kala','Keskuskatu 45','Helsinki',NULL,'21240','Finland'),
  (10616,'GREAL',1,'1997-07-31','1997-08-28','1997-08-05',2,116.53,'Great Lakes Food Market','2732 Baker Blvd.','Eugene','OR','97403','USA'),
  (10617,'GREAL',4,'1997-07-31','1997-08-28','1997-08-04',2,18.53,'Great Lakes Food Market','2732 Baker Blvd.','Eugene','OR','97403','USA'),
  (10618,'MEREP',1,'1997-08-01','1997-09-12','1997-08-08',1,154.68,'Mère Paillarde','43 rue St. Laurent','Montréal','Québec','H1J 1C3','Canada'),
  (10619,'MEREP',3,'1997-08-04','1997-09-01','1997-08-07',3,91.05,'Mère Paillarde','43 rue St. Laurent','Montréal','Québec','H1J 1C3','Canada'),
  (10620,'LAUGB',2,'1997-08-05','1997-09-02','1997-08-14',3,0.94,'Laughing Bacchus Wine Cellars','2319 Elm St.','Vancouver','BC','V3F 2K1','Canada'),
  (10621,'ISLAT',4,'1997-08-05','1997-09-02','1997-08-11',2,23.73,'Island Trading','Garden House Crowther Way','Cowes','Isle of Wight','PO31 7PJ','UK'),
  (10622,'RICAR',4,'1997-08-06','1997-09-03','1997-08-11',3,50.97,'Ricardo Adocicados','Av. Copacabana, 267','Rio de Janeiro','RJ','02389-890','Brazil'),
  (10623,'FRANK',8,'1997-08-07','1997-09-04','1997-08-12',2,97.18,'Frankenversand','Berliner Platz 43','München',NULL,'80805','Germany'),
  (10624,'THECR',4,'1997-08-07','1997-09-04','1997-08-19',2,94.8,'The Cracker Box','55 Grizzly Peak Rd.','Butte','MT','59801','USA'),
  (10625,'ANATR',3,'1997-08-08','1997-09-05','1997-08-14',1,43.9,'Ana Trujillo Emparedados y helados','Avda. de la Constitución 2222','México D.F.',NULL,'05021','Mexico'),
  (10626,'BERGS',1,'1997-08-11','1997-09-08','1997-08-20',2,138.69,'Berglunds snabbköp','Berguvsvägen  8','Luleå',NULL,'S-958 22','Sweden'),
  (10627,'SAVEA',8,'1997-08-11','1997-09-22','1997-08-21',3,107.46,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (10628,'BLONP',4,'1997-08-12','1997-09-09','1997-08-20',3,30.36,'Blondel père et fils','24, place Kléber','Strasbourg',NULL,'67000','France'),
  (10629,'GODOS',4,'1997-08-12','1997-09-09','1997-08-20',3,85.46,'Godos Cocina Típica','C/ Romero, 33','Sevilla',NULL,'41101','Spain'),
  (10630,'KOENE',1,'1997-08-13','1997-09-10','1997-08-19',2,32.35,'Königlich Essen','Maubelstr. 90','Brandenburg',NULL,'14776','Germany'),
  (10631,'LAMAI',8,'1997-08-14','1997-09-11','1997-08-15',1,0.87,'La maison d''Asie','1 rue Alsace-Lorraine','Toulouse',NULL,'31000','France'),
  (10632,'WANDK',8,'1997-08-14','1997-09-11','1997-08-19',1,41.38,'Die Wandernde Kuh','Adenauerallee 900','Stuttgart',NULL,'70563','Germany'),
  (10633,'ERNSH',7,'1997-08-15','1997-09-12','1997-08-18',3,477.9,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (10634,'FOLIG',4,'1997-08-15','1997-09-12','1997-08-21',3,487.38,'Folies gourmandes','184, chaussée de Tournai','Lille',NULL,'59000','France'),
  (10635,'MAGAA',8,'1997-08-18','1997-09-15','1997-08-21',3,47.46,'Magazzini Alimentari Riuniti','Via Ludovico il Moro 22','Bergamo',NULL,'24100','Italy'),
  (10636,'WARTH',4,'1997-08-19','1997-09-16','1997-08-26',1,1.15,'Wartian Herkku','Torikatu 38','Oulu',NULL,'90110','Finland'),
  (10637,'QUEEN',6,'1997-08-19','1997-09-16','1997-08-26',1,201.29,'Queen Cozinha','Alameda dos Canàrios, 891','Sao Paulo','SP','05487-020','Brazil'),
  (10638,'LINOD',3,'1997-08-20','1997-09-17','1997-09-01',1,158.44,'LINO-Delicateses','Ave. 5 de Mayo Porlamar','I. de Margarita','Nueva Esparta','4980','Venezuela'),
  (10639,'SANTG',7,'1997-08-20','1997-09-17','1997-08-27',3,38.64,'Santé Gourmet','Erling Skakkes gate 78','Stavern',NULL,'4110','Norway'),
  (10640,'WANDK',4,'1997-08-21','1997-09-18','1997-08-28',1,23.55,'Die Wandernde Kuh','Adenauerallee 900','Stuttgart',NULL,'70563','Germany'),
  (10641,'HILAA',4,'1997-08-22','1997-09-19','1997-08-26',2,179.61,'HILARION-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Cristóbal','Táchira','5022','Venezuela'),
  (10642,'SIMOB',7,'1997-08-22','1997-09-19','1997-09-05',3,41.89,'Simons bistro','Vinbæltet 34','Kobenhavn',NULL,'1734','Denmark'),
  (10643,'ALFKI',6,'1997-08-25','1997-09-22','1997-09-02',1,29.46,'Alfreds Futterkiste','Obere Str. 57','Berlin',NULL,'12209','Germany'),
  (10644,'WELLI',3,'1997-08-25','1997-09-22','1997-09-01',2,0.14,'Wellington Importadora','Rua do Mercado, 12','Resende','SP','08737-363','Brazil'),
  (10645,'HANAR',4,'1997-08-26','1997-09-23','1997-09-02',1,12.41,'Hanari Carnes','Rua do Paço, 67','Rio de Janeiro','RJ','05454-876','Brazil'),
  (10646,'HUNGO',9,'1997-08-27','1997-10-08','1997-09-03',3,142.33,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',NULL,'Ireland'),
  (10647,'QUEDE',4,'1997-08-27','1997-09-10','1997-09-03',2,45.54,'Que Delícia','Rua da Panificadora, 12','Rio de Janeiro','RJ','02389-673','Brazil'),
  (10648,'RICAR',5,'1997-08-28','1997-10-09','1997-09-09',2,14.25,'Ricardo Adocicados','Av. Copacabana, 267','Rio de Janeiro','RJ','02389-890','Brazil'),
  (10649,'MAISD',5,'1997-08-28','1997-09-25','1997-08-29',3,6.2,'Maison Dewey','Rue Joseph-Bens 532','Bruxelles',NULL,'B-1180','Belgium'),
  (10650,'FAMIA',5,'1997-08-29','1997-09-26','1997-09-03',3,176.81,'Familia Arquibaldo','Rua Orós, 92','Sao Paulo','SP','05442-030','Brazil'),
  (10651,'WANDK',8,'1997-09-01','1997-09-29','1997-09-11',2,20.6,'Die Wandernde Kuh','Adenauerallee 900','Stuttgart',NULL,'70563','Germany'),
  (10652,'GOURL',4,'1997-09-01','1997-09-29','1997-09-08',2,7.14,'Gourmet Lanchonetes','Av. Brasil, 442','Campinas','SP','04876-786','Brazil'),
  (10653,'FRANK',1,'1997-09-02','1997-09-30','1997-09-19',1,93.25,'Frankenversand','Berliner Platz 43','München',NULL,'80805','Germany'),
  (10654,'BERGS',5,'1997-09-02','1997-09-30','1997-09-11',1,55.26,'Berglunds snabbköp','Berguvsvägen  8','Luleå',NULL,'S-958 22','Sweden'),
  (10655,'REGGC',1,'1997-09-03','1997-10-01','1997-09-11',2,4.41,'Reggiani Caseifici','Strada Provinciale 124','Reggio Emilia',NULL,'42100','Italy'),
  (10656,'GREAL',6,'1997-09-04','1997-10-02','1997-09-10',1,57.15,'Great Lakes Food Market','2732 Baker Blvd.','Eugene','OR','97403','USA'),
  (10657,'SAVEA',2,'1997-09-04','1997-10-02','1997-09-15',2,352.69,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (10658,'QUICK',4,'1997-09-05','1997-10-03','1997-09-08',1,364.15,'QUICK-Stop','Taucherstraße 10','Cunewalde',NULL,'01307','Germany'),
  (10659,'QUEEN',7,'1997-09-05','1997-10-03','1997-09-10',2,105.81,'Queen Cozinha','Alameda dos Canàrios, 891','Sao Paulo','SP','05487-020','Brazil'),
  (10660,'HUNGC',8,'1997-09-08','1997-10-06','1997-10-15',1,111.29,'Hungry Coyote Import Store','City Center Plaza 516 Main St.','Elgin','OR','97827','USA'),
  (10661,'HUNGO',7,'1997-09-09','1997-10-07','1997-09-15',3,17.55,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',NULL,'Ireland'),
  (10662,'LONEP',3,'1997-09-09','1997-10-07','1997-09-18',2,1.28,'Lonesome Pine Restaurant','89 Chiaroscuro Rd.','Portland','OR','97219','USA'),
  (10663,'BONAP',2,'1997-09-10','1997-09-24','1997-10-03',2,113.15,'Bon app''','12, rue des Bouchers','Marseille',NULL,'13008','France'),
  (10664,'FURIB',1,'1997-09-10','1997-10-08','1997-09-19',3,1.27,'Furia Bacalhau e Frutos do Mar','Jardim das rosas n. 32','Lisboa',NULL,'1675','Portugal'),
  (10665,'LONEP',1,'1997-09-11','1997-10-09','1997-09-17',2,26.31,'Lonesome Pine Restaurant','89 Chiaroscuro Rd.','Portland','OR','97219','USA'),
  (10666,'RICSU',7,'1997-09-12','1997-10-10','1997-09-22',2,232.42,'Richter Supermarkt','Starenweg 5','Genève',NULL,'1204','Switzerland'),
  (10667,'ERNSH',7,'1997-09-12','1997-10-10','1997-09-19',1,78.09,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (10668,'WANDK',1,'1997-09-15','1997-10-13','1997-09-23',2,47.22,'Die Wandernde Kuh','Adenauerallee 900','Stuttgart',NULL,'70563','Germany'),
  (10669,'SIMOB',2,'1997-09-15','1997-10-13','1997-09-22',1,24.39,'Simons bistro','Vinbæltet 34','Kobenhavn',NULL,'1734','Denmark'),
  (10670,'FRANK',4,'1997-09-16','1997-10-14','1997-09-18',1,203.48,'Frankenversand','Berliner Platz 43','München',NULL,'80805','Germany'),
  (10671,'FRANR',1,'1997-09-17','1997-10-15','1997-09-24',1,30.34,'France restauration','54, rue Royale','Nantes',NULL,'44000','France'),
  (10672,'BERGS',9,'1997-09-17','1997-10-01','1997-09-26',2,95.75,'Berglunds snabbköp','Berguvsvägen  8','Luleå',NULL,'S-958 22','Sweden'),
  (10673,'WILMK',2,'1997-09-18','1997-10-16','1997-09-19',1,22.76,'Wilman Kala','Keskuskatu 45','Helsinki',NULL,'21240','Finland'),
  (10674,'ISLAT',4,'1997-09-18','1997-10-16','1997-09-30',2,0.9,'Island Trading','Garden House Crowther Way','Cowes','Isle of Wight','PO31 7PJ','UK'),
  (10675,'FRANK',5,'1997-09-19','1997-10-17','1997-09-23',2,31.85,'Frankenversand','Berliner Platz 43','München',NULL,'80805','Germany'),
  (10676,'TORTU',2,'1997-09-22','1997-10-20','1997-09-29',2,2.01,'Tortuga Restaurante','Avda. Azteca 123','México D.F.',NULL,'05033','Mexico'),
  (10677,'ANTON',1,'1997-09-22','1997-10-20','1997-09-26',3,4.03,'Antonio Moreno Taquería','Mataderos  2312','México D.F.',NULL,'05023','Mexico'),
  (10678,'SAVEA',7,'1997-09-23','1997-10-21','1997-10-16',3,388.98,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (10679,'BLONP',8,'1997-09-23','1997-10-21','1997-09-30',3,27.94,'Blondel père et fils','24, place Kléber','Strasbourg',NULL,'67000','France'),
  (10680,'OLDWO',1,'1997-09-24','1997-10-22','1997-09-26',1,26.61,'Old World Delicatessen','2743 Bering St.','Anchorage','AK','99508','USA'),
  (10681,'GREAL',3,'1997-09-25','1997-10-23','1997-09-30',3,76.13,'Great Lakes Food Market','2732 Baker Blvd.','Eugene','OR','97403','USA'),
  (10682,'ANTON',3,'1997-09-25','1997-10-23','1997-10-01',2,36.13,'Antonio Moreno Taquería','Mataderos  2312','México D.F.',NULL,'05023','Mexico'),
  (10683,'DUMON',2,'1997-09-26','1997-10-24','1997-10-01',1,4.4,'Du monde entier','67, rue des Cinquante Otages','Nantes',NULL,'44000','France'),
  (10684,'OTTIK',3,'1997-09-26','1997-10-24','1997-09-30',1,145.63,'Ottilies Käseladen','Mehrheimerstr. 369','Köln',NULL,'50739','Germany'),
  (10685,'GOURL',4,'1997-09-29','1997-10-13','1997-10-03',2,33.75,'Gourmet Lanchonetes','Av. Brasil, 442','Campinas','SP','04876-786','Brazil'),
  (10686,'PICCO',2,'1997-09-30','1997-10-28','1997-10-08',1,96.5,'Piccolo und mehr','Geislweg 14','Salzburg',NULL,'5020','Austria'),
  (10687,'HUNGO',9,'1997-09-30','1997-10-28','1997-10-30',2,296.43,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',NULL,'Ireland'),
  (10688,'VAFFE',4,'1997-10-01','1997-10-15','1997-10-07',2,299.09,'Vaffeljernet','Smagsloget 45','Århus',NULL,'8200','Denmark'),
  (10689,'BERGS',1,'1997-10-01','1997-10-29','1997-10-07',2,13.42,'Berglunds snabbköp','Berguvsvägen  8','Luleå',NULL,'S-958 22','Sweden'),
  (10690,'HANAR',1,'1997-10-02','1997-10-30','1997-10-03',1,15.8,'Hanari Carnes','Rua do Paço, 67','Rio de Janeiro','RJ','05454-876','Brazil'),
  (10691,'QUICK',2,'1997-10-03','1997-11-14','1997-10-22',2,810.05,'QUICK-Stop','Taucherstraße 10','Cunewalde',NULL,'01307','Germany'),
  (10692,'ALFKI',4,'1997-10-03','1997-10-31','1997-10-13',2,61.02,'Alfred''s Futterkiste','Obere Str. 57','Berlin',NULL,'12209','Germany'),
  (10693,'WHITC',3,'1997-10-06','1997-10-20','1997-10-10',3,139.34,'White Clover Markets','1029 - 12th Ave. S.','Seattle','WA','98124','USA'),
  (10694,'QUICK',8,'1997-10-06','1997-11-03','1997-10-09',3,398.36,'QUICK-Stop','Taucherstraße 10','Cunewalde',NULL,'01307','Germany'),
  (10695,'WILMK',7,'1997-10-07','1997-11-18','1997-10-14',1,16.72,'Wilman Kala','Keskuskatu 45','Helsinki',NULL,'21240','Finland'),
  (10696,'WHITC',8,'1997-10-08','1997-11-19','1997-10-14',3,102.55,'White Clover Markets','1029 - 12th Ave. S.','Seattle','WA','98124','USA'),
  (10697,'LINOD',3,'1997-10-08','1997-11-05','1997-10-14',1,45.52,'LINO-Delicateses','Ave. 5 de Mayo Porlamar','I. de Margarita','Nueva Esparta','4980','Venezuela'),
  (10698,'ERNSH',4,'1997-10-09','1997-11-06','1997-10-17',1,272.47,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (10699,'MORGK',3,'1997-10-09','1997-11-06','1997-10-13',3,0.58,'Morgenstern Gesundkost','Heerstr. 22','Leipzig',NULL,'04179','Germany'),
  (10700,'SAVEA',3,'1997-10-10','1997-11-07','1997-10-16',1,65.1,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (10701,'HUNGO',6,'1997-10-13','1997-10-27','1997-10-15',3,220.31,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',NULL,'Ireland'),
  (10702,'ALFKI',4,'1997-10-13','1997-11-24','1997-10-21',1,23.94,'Alfred''s Futterkiste','Obere Str. 57','Berlin',NULL,'12209','Germany'),
  (10703,'FOLKO',6,'1997-10-14','1997-11-11','1997-10-20',2,152.3,'Folk och fä HB','Åkergatan 24','Bräcke',NULL,'S-844 67','Sweden'),
  (10704,'QUEEN',6,'1997-10-14','1997-11-11','1997-11-07',1,4.78,'Queen Cozinha','Alameda dos Canàrios, 891','Sao Paulo','SP','05487-020','Brazil'),
  (10705,'HILAA',9,'1997-10-15','1997-11-12','1997-11-18',2,3.52,'HILARION-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Cristóbal','Táchira','5022','Venezuela'),
  (10706,'OLDWO',8,'1997-10-16','1997-11-13','1997-10-21',3,135.63,'Old World Delicatessen','2743 Bering St.','Anchorage','AK','99508','USA'),
  (10707,'AROUT',4,'1997-10-16','1997-10-30','1997-10-23',3,21.74,'Around the Horn','Brook Farm Stratford St. Mary','Colchester','Essex','CO7 6JX','UK'),
  (10708,'THEBI',6,'1997-10-17','1997-11-28','1997-11-05',2,2.96,'The Big Cheese','89 Jefferson Way Suite 2','Portland','OR','97201','USA'),
  (10709,'GOURL',1,'1997-10-17','1997-11-14','1997-11-20',3,210.8,'Gourmet Lanchonetes','Av. Brasil, 442','Campinas','SP','04876-786','Brazil'),
  (10710,'FRANS',1,'1997-10-20','1997-11-17','1997-10-23',1,4.98,'Franchi S.p.A.','Via Monte Bianco 34','Torino',NULL,'10100','Italy'),
  (10711,'SAVEA',5,'1997-10-21','1997-12-02','1997-10-29',2,52.41,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (10712,'HUNGO',3,'1997-10-21','1997-11-18','1997-10-31',1,89.93,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',NULL,'Ireland'),
  (10713,'SAVEA',1,'1997-10-22','1997-11-19','1997-10-24',1,167.05,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (10714,'SAVEA',5,'1997-10-22','1997-11-19','1997-10-27',3,24.49,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (10715,'BONAP',3,'1997-10-23','1997-11-06','1997-10-29',1,63.2,'Bon app''','12, rue des Bouchers','Marseille',NULL,'13008','France'),
  (10716,'RANCH',4,'1997-10-24','1997-11-21','1997-10-27',2,22.57,'Rancho grande','Av. del Libertador 900','Buenos Aires',NULL,'1010','Argentina'),
  (10717,'FRANK',1,'1997-10-24','1997-11-21','1997-10-29',2,59.25,'Frankenversand','Berliner Platz 43','München',NULL,'80805','Germany'),
  (10718,'KOENE',1,'1997-10-27','1997-11-24','1997-10-29',3,170.88,'Königlich Essen','Maubelstr. 90','Brandenburg',NULL,'14776','Germany'),
  (10719,'LETSS',8,'1997-10-27','1997-11-24','1997-11-05',2,51.44,'Let''s Stop N Shop','87 Polk St. Suite 5','San Francisco','CA','94117','USA'),
  (10720,'QUEDE',8,'1997-10-28','1997-11-11','1997-11-05',2,9.53,'Que Delícia','Rua da Panificadora, 12','Rio de Janeiro','RJ','02389-673','Brazil'),
  (10721,'QUICK',5,'1997-10-29','1997-11-26','1997-10-31',3,48.92,'QUICK-Stop','Taucherstraße 10','Cunewalde',NULL,'01307','Germany'),
  (10722,'SAVEA',8,'1997-10-29','1997-12-10','1997-11-04',1,74.58,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (10723,'WHITC',3,'1997-10-30','1997-11-27','1997-11-25',1,21.72,'White Clover Markets','1029 - 12th Ave. S.','Seattle','WA','98124','USA'),
  (10724,'MEREP',8,'1997-10-30','1997-12-11','1997-11-05',2,57.75,'Mère Paillarde','43 rue St. Laurent','Montréal','Québec','H1J 1C3','Canada'),
  (10725,'FAMIA',4,'1997-10-31','1997-11-28','1997-11-05',3,10.83,'Familia Arquibaldo','Rua Orós, 92','Sao Paulo','SP','05442-030','Brazil'),
  (10726,'EASTC',4,'1997-11-03','1997-11-17','1997-12-05',1,16.56,'Eastern Connection','35 King George','London',NULL,'WX3 6FW','UK'),
  (10727,'REGGC',2,'1997-11-03','1997-12-01','1997-12-05',1,89.9,'Reggiani Caseifici','Strada Provinciale 124','Reggio Emilia',NULL,'42100','Italy'),
  (10728,'QUEEN',4,'1997-11-04','1997-12-02','1997-11-11',2,58.33,'Queen Cozinha','Alameda dos Canàrios, 891','Sao Paulo','SP','05487-020','Brazil'),
  (10729,'LINOD',8,'1997-11-04','1997-12-16','1997-11-14',3,141.06,'LINO-Delicateses','Ave. 5 de Mayo Porlamar','I. de Margarita','Nueva Esparta','4980','Venezuela'),
  (10730,'BONAP',5,'1997-11-05','1997-12-03','1997-11-14',1,20.12,'Bon app''','12, rue des Bouchers','Marseille',NULL,'13008','France'),
  (10731,'CHOPS',7,'1997-11-06','1997-12-04','1997-11-14',1,96.65,'Chop-suey Chinese','Hauptstr. 31','Bern',NULL,'3012','Switzerland'),
  (10732,'BONAP',3,'1997-11-06','1997-12-04','1997-11-07',1,16.97,'Bon app''','12, rue des Bouchers','Marseille',NULL,'13008','France'),
  (10733,'BERGS',1,'1997-11-07','1997-12-05','1997-11-10',3,110.11,'Berglunds snabbköp','Berguvsvägen  8','Luleå',NULL,'S-958 22','Sweden'),
  (10734,'GOURL',2,'1997-11-07','1997-12-05','1997-11-12',3,1.63,'Gourmet Lanchonetes','Av. Brasil, 442','Campinas','SP','04876-786','Brazil'),
  (10735,'LETSS',6,'1997-11-10','1997-12-08','1997-11-21',2,45.97,'Let''s Stop N Shop','87 Polk St. Suite 5','San Francisco','CA','94117','USA'),
  (10736,'HUNGO',9,'1997-11-11','1997-12-09','1997-11-21',2,44.1,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',NULL,'Ireland'),
  (10737,'VINET',2,'1997-11-11','1997-12-09','1997-11-18',2,7.79,'Vins et alcools Chevalier','59 rue de l''Abbaye','Reims',NULL,'51100','France'),
  (10738,'SPECD',2,'1997-11-12','1997-12-10','1997-11-18',1,2.91,'Spécialités du monde','25, rue Lauriston','Paris',NULL,'75016','France'),
  (10739,'VINET',3,'1997-11-12','1997-12-10','1997-11-17',3,11.08,'Vins et alcools Chevalier','59 rue de l''Abbaye','Reims',NULL,'51100','France'),
  (10740,'WHITC',4,'1997-11-13','1997-12-11','1997-11-25',2,81.88,'White Clover Markets','1029 - 12th Ave. S.','Seattle','WA','98124','USA'),
  (10741,'AROUT',4,'1997-11-14','1997-11-28','1997-11-18',3,10.96,'Around the Horn','Brook Farm Stratford St. Mary','Colchester','Essex','CO7 6JX','UK'),
  (10742,'BOTTM',3,'1997-11-14','1997-12-12','1997-11-18',3,243.73,'Bottom-Dollar Markets','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada'),
  (10743,'AROUT',1,'1997-11-17','1997-12-15','1997-11-21',2,23.72,'Around the Horn','Brook Farm Stratford St. Mary','Colchester','Essex','CO7 6JX','UK'),
  (10744,'VAFFE',6,'1997-11-17','1997-12-15','1997-11-24',1,69.19,'Vaffeljernet','Smagsloget 45','Århus',NULL,'8200','Denmark'),
  (10745,'QUICK',9,'1997-11-18','1997-12-16','1997-11-27',1,3.52,'QUICK-Stop','Taucherstraße 10','Cunewalde',NULL,'01307','Germany'),
  (10746,'CHOPS',1,'1997-11-19','1997-12-17','1997-11-21',3,31.43,'Chop-suey Chinese','Hauptstr. 31','Bern',NULL,'3012','Switzerland'),
  (10747,'PICCO',6,'1997-11-19','1997-12-17','1997-11-26',1,117.33,'Piccolo und mehr','Geislweg 14','Salzburg',NULL,'5020','Austria');

COMMIT;

#
# Data for the `Orders` table  (LIMIT 500,500)
#

INSERT INTO `Orders` (`OrderID`, `CustomerID`, `EmployeeID`, `OrderDate`, `RequiredDate`, `ShippedDate`, `ShipVia`, `Freight`, `ShipName`, `ShipAddress`, `ShipCity`, `ShipRegion`, `ShipPostalCode`, `ShipCountry`) VALUES 
  (10748,'SAVEA',3,'1997-11-20','1997-12-18','1997-11-28',1,232.55,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (10749,'ISLAT',4,'1997-11-20','1997-12-18','1997-12-19',2,61.53,'Island Trading','Garden House Crowther Way','Cowes','Isle of Wight','PO31 7PJ','UK'),
  (10750,'WARTH',9,'1997-11-21','1997-12-19','1997-11-24',1,79.3,'Wartian Herkku','Torikatu 38','Oulu',NULL,'90110','Finland'),
  (10751,'RICSU',3,'1997-11-24','1997-12-22','1997-12-03',3,130.79,'Richter Supermarkt','Starenweg 5','Genève',NULL,'1204','Switzerland'),
  (10752,'NORTS',2,'1997-11-24','1997-12-22','1997-11-28',3,1.39,'North/South','South House 300 Queensbridge','London',NULL,'SW7 1RZ','UK'),
  (10753,'FRANS',3,'1997-11-25','1997-12-23','1997-11-27',1,7.7,'Franchi S.p.A.','Via Monte Bianco 34','Torino',NULL,'10100','Italy'),
  (10754,'MAGAA',6,'1997-11-25','1997-12-23','1997-11-27',3,2.38,'Magazzini Alimentari Riuniti','Via Ludovico il Moro 22','Bergamo',NULL,'24100','Italy'),
  (10755,'BONAP',4,'1997-11-26','1997-12-24','1997-11-28',2,16.71,'Bon app''','12, rue des Bouchers','Marseille',NULL,'13008','France'),
  (10756,'SPLIR',8,'1997-11-27','1997-12-25','1997-12-02',2,73.21,'Split Rail Beer & Ale','P.O. Box 555','Lander','WY','82520','USA'),
  (10757,'SAVEA',6,'1997-11-27','1997-12-25','1997-12-15',1,8.19,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (10758,'RICSU',3,'1997-11-28','1997-12-26','1997-12-04',3,138.17,'Richter Supermarkt','Starenweg 5','Genève',NULL,'1204','Switzerland'),
  (10759,'ANATR',3,'1997-11-28','1997-12-26','1997-12-12',3,11.99,'Ana Trujillo Emparedados y helados','Avda. de la Constitución 2222','México D.F.',NULL,'05021','Mexico'),
  (10760,'MAISD',4,'1997-12-01','1997-12-29','1997-12-10',1,155.64,'Maison Dewey','Rue Joseph-Bens 532','Bruxelles',NULL,'B-1180','Belgium'),
  (10761,'RATTC',5,'1997-12-02','1997-12-30','1997-12-08',2,18.66,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA'),
  (10762,'FOLKO',3,'1997-12-02','1997-12-30','1997-12-09',1,328.74,'Folk och fä HB','Åkergatan 24','Bräcke',NULL,'S-844 67','Sweden'),
  (10763,'FOLIG',3,'1997-12-03','1997-12-31','1997-12-08',3,37.35,'Folies gourmandes','184, chaussée de Tournai','Lille',NULL,'59000','France'),
  (10764,'ERNSH',6,'1997-12-03','1997-12-31','1997-12-08',3,145.45,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (10765,'QUICK',3,'1997-12-04','1998-01-01','1997-12-09',3,42.74,'QUICK-Stop','Taucherstraße 10','Cunewalde',NULL,'01307','Germany'),
  (10766,'OTTIK',4,'1997-12-05','1998-01-02','1997-12-09',1,157.55,'Ottilies Käseladen','Mehrheimerstr. 369','Köln',NULL,'50739','Germany'),
  (10767,'SUPRD',4,'1997-12-05','1998-01-02','1997-12-15',3,1.59,'Suprêmes délices','Boulevard Tirou, 255','Charleroi',NULL,'B-6000','Belgium'),
  (10768,'AROUT',3,'1997-12-08','1998-01-05','1997-12-15',2,146.32,'Around the Horn','Brook Farm Stratford St. Mary','Colchester','Essex','CO7 6JX','UK'),
  (10769,'VAFFE',3,'1997-12-08','1998-01-05','1997-12-12',1,65.06,'Vaffeljernet','Smagsloget 45','Århus',NULL,'8200','Denmark'),
  (10770,'HANAR',8,'1997-12-09','1998-01-06','1997-12-17',3,5.32,'Hanari Carnes','Rua do Paço, 67','Rio de Janeiro','RJ','05454-876','Brazil'),
  (10771,'ERNSH',9,'1997-12-10','1998-01-07','1998-01-02',2,11.19,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (10772,'LEHMS',3,'1997-12-10','1998-01-07','1997-12-19',2,91.28,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M.',NULL,'60528','Germany'),
  (10773,'ERNSH',1,'1997-12-11','1998-01-08','1997-12-16',3,96.43,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (10774,'FOLKO',4,'1997-12-11','1997-12-25','1997-12-12',1,48.2,'Folk och fä HB','Åkergatan 24','Bräcke',NULL,'S-844 67','Sweden'),
  (10775,'THECR',7,'1997-12-12','1998-01-09','1997-12-26',1,20.25,'The Cracker Box','55 Grizzly Peak Rd.','Butte','MT','59801','USA'),
  (10776,'ERNSH',1,'1997-12-15','1998-01-12','1997-12-18',3,351.53,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (10777,'GOURL',7,'1997-12-15','1997-12-29','1998-01-21',2,3.01,'Gourmet Lanchonetes','Av. Brasil, 442','Campinas','SP','04876-786','Brazil'),
  (10778,'BERGS',3,'1997-12-16','1998-01-13','1997-12-24',1,6.79,'Berglunds snabbköp','Berguvsvägen  8','Luleå',NULL,'S-958 22','Sweden'),
  (10779,'MORGK',3,'1997-12-16','1998-01-13','1998-01-14',2,58.13,'Morgenstern Gesundkost','Heerstr. 22','Leipzig',NULL,'04179','Germany'),
  (10780,'LILAS',2,'1997-12-16','1997-12-30','1997-12-25',1,42.13,'LILA-Supermercado','Carrera 52 con Ave. Bolívar #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela'),
  (10781,'WARTH',2,'1997-12-17','1998-01-14','1997-12-19',3,73.16,'Wartian Herkku','Torikatu 38','Oulu',NULL,'90110','Finland'),
  (10782,'CACTU',9,'1997-12-17','1998-01-14','1997-12-22',3,1.1,'Cactus Comidas para llevar','Cerrito 333','Buenos Aires',NULL,'1010','Argentina'),
  (10783,'HANAR',4,'1997-12-18','1998-01-15','1997-12-19',2,124.98,'Hanari Carnes','Rua do Paço, 67','Rio de Janeiro','RJ','05454-876','Brazil'),
  (10784,'MAGAA',4,'1997-12-18','1998-01-15','1997-12-22',3,70.09,'Magazzini Alimentari Riuniti','Via Ludovico il Moro 22','Bergamo',NULL,'24100','Italy'),
  (10785,'GROSR',1,'1997-12-18','1998-01-15','1997-12-24',3,1.51,'GROSELLA-Restaurante','5ª Ave. Los Palos Grandes','Caracas','DF','1081','Venezuela'),
  (10786,'QUEEN',8,'1997-12-19','1998-01-16','1997-12-23',1,110.87,'Queen Cozinha','Alameda dos Canàrios, 891','Sao Paulo','SP','05487-020','Brazil'),
  (10787,'LAMAI',2,'1997-12-19','1998-01-02','1997-12-26',1,249.93,'La maison d''Asie','1 rue Alsace-Lorraine','Toulouse',NULL,'31000','France'),
  (10788,'QUICK',1,'1997-12-22','1998-01-19','1998-01-19',2,42.7,'QUICK-Stop','Taucherstraße 10','Cunewalde',NULL,'01307','Germany'),
  (10789,'FOLIG',1,'1997-12-22','1998-01-19','1997-12-31',2,100.6,'Folies gourmandes','184, chaussée de Tournai','Lille',NULL,'59000','France'),
  (10790,'GOURL',6,'1997-12-22','1998-01-19','1997-12-26',1,28.23,'Gourmet Lanchonetes','Av. Brasil, 442','Campinas','SP','04876-786','Brazil'),
  (10791,'FRANK',6,'1997-12-23','1998-01-20','1998-01-01',2,16.85,'Frankenversand','Berliner Platz 43','München',NULL,'80805','Germany'),
  (10792,'WOLZA',1,'1997-12-23','1998-01-20','1997-12-31',3,23.79,'Wolski Zajazd','ul. Filtrowa 68','Warszawa',NULL,'01-012','Poland'),
  (10793,'AROUT',3,'1997-12-24','1998-01-21','1998-01-08',3,4.52,'Around the Horn','Brook Farm Stratford St. Mary','Colchester','Essex','CO7 6JX','UK'),
  (10794,'QUEDE',6,'1997-12-24','1998-01-21','1998-01-02',1,21.49,'Que Delícia','Rua da Panificadora, 12','Rio de Janeiro','RJ','02389-673','Brazil'),
  (10795,'ERNSH',8,'1997-12-24','1998-01-21','1998-01-20',2,126.66,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (10796,'HILAA',3,'1997-12-25','1998-01-22','1998-01-14',1,26.52,'HILARION-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Cristóbal','Táchira','5022','Venezuela'),
  (10797,'DRACD',7,'1997-12-25','1998-01-22','1998-01-05',2,33.35,'Drachenblut Delikatessen','Walserweg 21','Aachen',NULL,'52066','Germany'),
  (10798,'ISLAT',2,'1997-12-26','1998-01-23','1998-01-05',1,2.33,'Island Trading','Garden House Crowther Way','Cowes','Isle of Wight','PO31 7PJ','UK'),
  (10799,'KOENE',9,'1997-12-26','1998-02-06','1998-01-05',3,30.76,'Königlich Essen','Maubelstr. 90','Brandenburg',NULL,'14776','Germany'),
  (10800,'SEVES',1,'1997-12-26','1998-01-23','1998-01-05',3,137.44,'Seven Seas Imports','90 Wadhurst Rd.','London',NULL,'OX15 4NB','UK'),
  (10801,'BOLID',4,'1997-12-29','1998-01-26','1997-12-31',2,97.09,'Bólido Comidas preparadas','C/ Araquil, 67','Madrid',NULL,'28023','Spain'),
  (10802,'SIMOB',4,'1997-12-29','1998-01-26','1998-01-02',2,257.26,'Simons bistro','Vinbæltet 34','Kobenhavn',NULL,'1734','Denmark'),
  (10803,'WELLI',4,'1997-12-30','1998-01-27','1998-01-06',1,55.23,'Wellington Importadora','Rua do Mercado, 12','Resende','SP','08737-363','Brazil'),
  (10804,'SEVES',6,'1997-12-30','1998-01-27','1998-01-07',2,27.33,'Seven Seas Imports','90 Wadhurst Rd.','London',NULL,'OX15 4NB','UK'),
  (10805,'THEBI',2,'1997-12-30','1998-01-27','1998-01-09',3,237.34,'The Big Cheese','89 Jefferson Way Suite 2','Portland','OR','97201','USA'),
  (10806,'VICTE',3,'1997-12-31','1998-01-28','1998-01-05',2,22.11,'Victuailles en stock','2, rue du Commerce','Lyon',NULL,'69004','France'),
  (10807,'FRANS',4,'1997-12-31','1998-01-28','1998-01-30',1,1.36,'Franchi S.p.A.','Via Monte Bianco 34','Torino',NULL,'10100','Italy'),
  (10808,'OLDWO',2,'1998-01-01','1998-01-29','1998-01-09',3,45.53,'Old World Delicatessen','2743 Bering St.','Anchorage','AK','99508','USA'),
  (10809,'WELLI',7,'1998-01-01','1998-01-29','1998-01-07',1,4.87,'Wellington Importadora','Rua do Mercado, 12','Resende','SP','08737-363','Brazil'),
  (10810,'LAUGB',2,'1998-01-01','1998-01-29','1998-01-07',3,4.33,'Laughing Bacchus Wine Cellars','2319 Elm St.','Vancouver','BC','V3F 2K1','Canada'),
  (10811,'LINOD',8,'1998-01-02','1998-01-30','1998-01-08',1,31.22,'LINO-Delicateses','Ave. 5 de Mayo Porlamar','I. de Margarita','Nueva Esparta','4980','Venezuela'),
  (10812,'REGGC',5,'1998-01-02','1998-01-30','1998-01-12',1,59.78,'Reggiani Caseifici','Strada Provinciale 124','Reggio Emilia',NULL,'42100','Italy'),
  (10813,'RICAR',1,'1998-01-05','1998-02-02','1998-01-09',1,47.38,'Ricardo Adocicados','Av. Copacabana, 267','Rio de Janeiro','RJ','02389-890','Brazil'),
  (10814,'VICTE',3,'1998-01-05','1998-02-02','1998-01-14',3,130.94,'Victuailles en stock','2, rue du Commerce','Lyon',NULL,'69004','France'),
  (10815,'SAVEA',2,'1998-01-05','1998-02-02','1998-01-14',3,14.62,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (10816,'GREAL',4,'1998-01-06','1998-02-03','1998-02-04',2,719.78,'Great Lakes Food Market','2732 Baker Blvd.','Eugene','OR','97403','USA'),
  (10817,'KOENE',3,'1998-01-06','1998-01-20','1998-01-13',2,306.07,'Königlich Essen','Maubelstr. 90','Brandenburg',NULL,'14776','Germany'),
  (10818,'MAGAA',7,'1998-01-07','1998-02-04','1998-01-12',3,65.48,'Magazzini Alimentari Riuniti','Via Ludovico il Moro 22','Bergamo',NULL,'24100','Italy'),
  (10819,'CACTU',2,'1998-01-07','1998-02-04','1998-01-16',3,19.76,'Cactus Comidas para llevar','Cerrito 333','Buenos Aires',NULL,'1010','Argentina'),
  (10820,'RATTC',3,'1998-01-07','1998-02-04','1998-01-13',2,37.52,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA'),
  (10821,'SPLIR',1,'1998-01-08','1998-02-05','1998-01-15',1,36.68,'Split Rail Beer & Ale','P.O. Box 555','Lander','WY','82520','USA'),
  (10822,'TRAIH',6,'1998-01-08','1998-02-05','1998-01-16',3,7,'Trail''s Head Gourmet Provisioners','722 DaVinci Blvd.','Kirkland','WA','98034','USA'),
  (10823,'LILAS',5,'1998-01-09','1998-02-06','1998-01-13',2,163.97,'LILA-Supermercado','Carrera 52 con Ave. Bolívar #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela'),
  (10824,'FOLKO',8,'1998-01-09','1998-02-06','1998-01-30',1,1.23,'Folk och fä HB','Åkergatan 24','Bräcke',NULL,'S-844 67','Sweden'),
  (10825,'DRACD',1,'1998-01-09','1998-02-06','1998-01-14',1,79.25,'Drachenblut Delikatessen','Walserweg 21','Aachen',NULL,'52066','Germany'),
  (10826,'BLONP',6,'1998-01-12','1998-02-09','1998-02-06',1,7.09,'Blondel père et fils','24, place Kléber','Strasbourg',NULL,'67000','France'),
  (10827,'BONAP',1,'1998-01-12','1998-01-26','1998-02-06',2,63.54,'Bon app''','12, rue des Bouchers','Marseille',NULL,'13008','France'),
  (10828,'RANCH',9,'1998-01-13','1998-01-27','1998-02-04',1,90.85,'Rancho grande','Av. del Libertador 900','Buenos Aires',NULL,'1010','Argentina'),
  (10829,'ISLAT',9,'1998-01-13','1998-02-10','1998-01-23',1,154.72,'Island Trading','Garden House Crowther Way','Cowes','Isle of Wight','PO31 7PJ','UK'),
  (10830,'TRADH',4,'1998-01-13','1998-02-24','1998-01-21',2,81.83,'Tradiçao Hipermercados','Av. Inês de Castro, 414','Sao Paulo','SP','05634-030','Brazil'),
  (10831,'SANTG',3,'1998-01-14','1998-02-11','1998-01-23',2,72.19,'Santé Gourmet','Erling Skakkes gate 78','Stavern',NULL,'4110','Norway'),
  (10832,'LAMAI',2,'1998-01-14','1998-02-11','1998-01-19',2,43.26,'La maison d''Asie','1 rue Alsace-Lorraine','Toulouse',NULL,'31000','France'),
  (10833,'OTTIK',6,'1998-01-15','1998-02-12','1998-01-23',2,71.49,'Ottilies Käseladen','Mehrheimerstr. 369','Köln',NULL,'50739','Germany'),
  (10834,'TRADH',1,'1998-01-15','1998-02-12','1998-01-19',3,29.78,'Tradiçao Hipermercados','Av. Inês de Castro, 414','Sao Paulo','SP','05634-030','Brazil'),
  (10835,'ALFKI',1,'1998-01-15','1998-02-12','1998-01-21',3,69.53,'Alfred''s Futterkiste','Obere Str. 57','Berlin',NULL,'12209','Germany'),
  (10836,'ERNSH',7,'1998-01-16','1998-02-13','1998-01-21',1,411.88,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (10837,'BERGS',9,'1998-01-16','1998-02-13','1998-01-23',3,13.32,'Berglunds snabbköp','Berguvsvägen  8','Luleå',NULL,'S-958 22','Sweden'),
  (10838,'LINOD',3,'1998-01-19','1998-02-16','1998-01-23',3,59.28,'LINO-Delicateses','Ave. 5 de Mayo Porlamar','I. de Margarita','Nueva Esparta','4980','Venezuela'),
  (10839,'TRADH',3,'1998-01-19','1998-02-16','1998-01-22',3,35.43,'Tradiçao Hipermercados','Av. Inês de Castro, 414','Sao Paulo','SP','05634-030','Brazil'),
  (10840,'LINOD',4,'1998-01-19','1998-03-02','1998-02-16',2,2.71,'LINO-Delicateses','Ave. 5 de Mayo Porlamar','I. de Margarita','Nueva Esparta','4980','Venezuela'),
  (10841,'SUPRD',5,'1998-01-20','1998-02-17','1998-01-29',2,424.3,'Suprêmes délices','Boulevard Tirou, 255','Charleroi',NULL,'B-6000','Belgium'),
  (10842,'TORTU',1,'1998-01-20','1998-02-17','1998-01-29',3,54.42,'Tortuga Restaurante','Avda. Azteca 123','México D.F.',NULL,'05033','Mexico'),
  (10843,'VICTE',4,'1998-01-21','1998-02-18','1998-01-26',2,9.26,'Victuailles en stock','2, rue du Commerce','Lyon',NULL,'69004','France'),
  (10844,'PICCO',8,'1998-01-21','1998-02-18','1998-01-26',2,25.22,'Piccolo und mehr','Geislweg 14','Salzburg',NULL,'5020','Austria'),
  (10845,'QUICK',8,'1998-01-21','1998-02-04','1998-01-30',1,212.98,'QUICK-Stop','Taucherstraße 10','Cunewalde',NULL,'01307','Germany'),
  (10846,'SUPRD',2,'1998-01-22','1998-03-05','1998-01-23',3,56.46,'Suprêmes délices','Boulevard Tirou, 255','Charleroi',NULL,'B-6000','Belgium'),
  (10847,'SAVEA',4,'1998-01-22','1998-02-05','1998-02-10',3,487.57,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (10848,'CONSH',7,'1998-01-23','1998-02-20','1998-01-29',2,38.24,'Consolidated Holdings','Berkeley Gardens 12  Brewery','London',NULL,'WX1 6LT','UK'),
  (10849,'KOENE',9,'1998-01-23','1998-02-20','1998-01-30',2,0.56,'Königlich Essen','Maubelstr. 90','Brandenburg',NULL,'14776','Germany'),
  (10850,'VICTE',1,'1998-01-23','1998-03-06','1998-01-30',1,49.19,'Victuailles en stock','2, rue du Commerce','Lyon',NULL,'69004','France'),
  (10851,'RICAR',5,'1998-01-26','1998-02-23','1998-02-02',1,160.55,'Ricardo Adocicados','Av. Copacabana, 267','Rio de Janeiro','RJ','02389-890','Brazil'),
  (10852,'RATTC',8,'1998-01-26','1998-02-09','1998-01-30',1,174.05,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA'),
  (10853,'BLAUS',9,'1998-01-27','1998-02-24','1998-02-03',2,53.83,'Blauer See Delikatessen','Forsterstr. 57','Mannheim',NULL,'68306','Germany'),
  (10854,'ERNSH',3,'1998-01-27','1998-02-24','1998-02-05',2,100.22,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (10855,'OLDWO',3,'1998-01-27','1998-02-24','1998-02-04',1,170.97,'Old World Delicatessen','2743 Bering St.','Anchorage','AK','99508','USA'),
  (10856,'ANTON',3,'1998-01-28','1998-02-25','1998-02-10',2,58.43,'Antonio Moreno Taquería','Mataderos  2312','México D.F.',NULL,'05023','Mexico'),
  (10857,'BERGS',8,'1998-01-28','1998-02-25','1998-02-06',2,188.85,'Berglunds snabbköp','Berguvsvägen  8','Luleå',NULL,'S-958 22','Sweden'),
  (10858,'LACOR',2,'1998-01-29','1998-02-26','1998-02-03',1,52.51,'La corne d''abondance','67, avenue de l''Europe','Versailles',NULL,'78000','France'),
  (10859,'FRANK',1,'1998-01-29','1998-02-26','1998-02-02',2,76.1,'Frankenversand','Berliner Platz 43','München',NULL,'80805','Germany'),
  (10860,'FRANR',3,'1998-01-29','1998-02-26','1998-02-04',3,19.26,'France restauration','54, rue Royale','Nantes',NULL,'44000','France'),
  (10861,'WHITC',4,'1998-01-30','1998-02-27','1998-02-17',2,14.93,'White Clover Markets','1029 - 12th Ave. S.','Seattle','WA','98124','USA'),
  (10862,'LEHMS',8,'1998-01-30','1998-03-13','1998-02-02',2,53.23,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M.',NULL,'60528','Germany'),
  (10863,'HILAA',4,'1998-02-02','1998-03-02','1998-02-17',2,30.26,'HILARION-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Cristóbal','Táchira','5022','Venezuela'),
  (10864,'AROUT',4,'1998-02-02','1998-03-02','1998-02-09',2,3.04,'Around the Horn','Brook Farm Stratford St. Mary','Colchester','Essex','CO7 6JX','UK'),
  (10865,'QUICK',2,'1998-02-02','1998-02-16','1998-02-12',1,348.14,'QUICK-Stop','Taucherstraße 10','Cunewalde',NULL,'01307','Germany'),
  (10866,'BERGS',5,'1998-02-03','1998-03-03','1998-02-12',1,109.11,'Berglunds snabbköp','Berguvsvägen  8','Luleå',NULL,'S-958 22','Sweden'),
  (10867,'LONEP',6,'1998-02-03','1998-03-17','1998-02-11',1,1.93,'Lonesome Pine Restaurant','89 Chiaroscuro Rd.','Portland','OR','97219','USA'),
  (10868,'QUEEN',7,'1998-02-04','1998-03-04','1998-02-23',2,191.27,'Queen Cozinha','Alameda dos Canàrios, 891','Sao Paulo','SP','05487-020','Brazil'),
  (10869,'SEVES',5,'1998-02-04','1998-03-04','1998-02-09',1,143.28,'Seven Seas Imports','90 Wadhurst Rd.','London',NULL,'OX15 4NB','UK'),
  (10870,'WOLZA',5,'1998-02-04','1998-03-04','1998-02-13',3,12.04,'Wolski Zajazd','ul. Filtrowa 68','Warszawa',NULL,'01-012','Poland'),
  (10871,'BONAP',9,'1998-02-05','1998-03-05','1998-02-10',2,112.27,'Bon app''','12, rue des Bouchers','Marseille',NULL,'13008','France'),
  (10872,'GODOS',5,'1998-02-05','1998-03-05','1998-02-09',2,175.32,'Godos Cocina Típica','C/ Romero, 33','Sevilla',NULL,'41101','Spain'),
  (10873,'WILMK',4,'1998-02-06','1998-03-06','1998-02-09',1,0.82,'Wilman Kala','Keskuskatu 45','Helsinki',NULL,'21240','Finland'),
  (10874,'GODOS',5,'1998-02-06','1998-03-06','1998-02-11',2,19.58,'Godos Cocina Típica','C/ Romero, 33','Sevilla',NULL,'41101','Spain'),
  (10875,'BERGS',4,'1998-02-06','1998-03-06','1998-03-03',2,32.37,'Berglunds snabbköp','Berguvsvägen  8','Luleå',NULL,'S-958 22','Sweden'),
  (10876,'BONAP',7,'1998-02-09','1998-03-09','1998-02-12',3,60.42,'Bon app''','12, rue des Bouchers','Marseille',NULL,'13008','France'),
  (10877,'RICAR',1,'1998-02-09','1998-03-09','1998-02-19',1,38.06,'Ricardo Adocicados','Av. Copacabana, 267','Rio de Janeiro','RJ','02389-890','Brazil'),
  (10878,'QUICK',4,'1998-02-10','1998-03-10','1998-02-12',1,46.69,'QUICK-Stop','Taucherstraße 10','Cunewalde',NULL,'01307','Germany'),
  (10879,'WILMK',3,'1998-02-10','1998-03-10','1998-02-12',3,8.5,'Wilman Kala','Keskuskatu 45','Helsinki',NULL,'21240','Finland'),
  (10880,'FOLKO',7,'1998-02-10','1998-03-24','1998-02-18',1,88.01,'Folk och fä HB','Åkergatan 24','Bräcke',NULL,'S-844 67','Sweden'),
  (10881,'CACTU',4,'1998-02-11','1998-03-11','1998-02-18',1,2.84,'Cactus Comidas para llevar','Cerrito 333','Buenos Aires',NULL,'1010','Argentina'),
  (10882,'SAVEA',4,'1998-02-11','1998-03-11','1998-02-20',3,23.1,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (10883,'LONEP',8,'1998-02-12','1998-03-12','1998-02-20',3,0.53,'Lonesome Pine Restaurant','89 Chiaroscuro Rd.','Portland','OR','97219','USA'),
  (10884,'LETSS',4,'1998-02-12','1998-03-12','1998-02-13',2,90.97,'Let''s Stop N Shop','87 Polk St. Suite 5','San Francisco','CA','94117','USA'),
  (10885,'SUPRD',6,'1998-02-12','1998-03-12','1998-02-18',3,5.64,'Suprêmes délices','Boulevard Tirou, 255','Charleroi',NULL,'B-6000','Belgium'),
  (10886,'HANAR',1,'1998-02-13','1998-03-13','1998-03-02',1,4.99,'Hanari Carnes','Rua do Paço, 67','Rio de Janeiro','RJ','05454-876','Brazil'),
  (10887,'GALED',8,'1998-02-13','1998-03-13','1998-02-16',3,1.25,'Galería del gastronómo','Rambla de Cataluña, 23','Barcelona',NULL,'8022','Spain'),
  (10888,'GODOS',1,'1998-02-16','1998-03-16','1998-02-23',2,51.87,'Godos Cocina Típica','C/ Romero, 33','Sevilla',NULL,'41101','Spain'),
  (10889,'RATTC',9,'1998-02-16','1998-03-16','1998-02-23',3,280.61,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA'),
  (10890,'DUMON',7,'1998-02-16','1998-03-16','1998-02-18',1,32.76,'Du monde entier','67, rue des Cinquante Otages','Nantes',NULL,'44000','France'),
  (10891,'LEHMS',7,'1998-02-17','1998-03-17','1998-02-19',2,20.37,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M.',NULL,'60528','Germany'),
  (10892,'MAISD',4,'1998-02-17','1998-03-17','1998-02-19',2,120.27,'Maison Dewey','Rue Joseph-Bens 532','Bruxelles',NULL,'B-1180','Belgium'),
  (10893,'KOENE',9,'1998-02-18','1998-03-18','1998-02-20',2,77.78,'Königlich Essen','Maubelstr. 90','Brandenburg',NULL,'14776','Germany'),
  (10894,'SAVEA',1,'1998-02-18','1998-03-18','1998-02-20',1,116.13,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (10895,'ERNSH',3,'1998-02-18','1998-03-18','1998-02-23',1,162.75,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (10896,'MAISD',7,'1998-02-19','1998-03-19','1998-02-27',3,32.45,'Maison Dewey','Rue Joseph-Bens 532','Bruxelles',NULL,'B-1180','Belgium'),
  (10897,'HUNGO',3,'1998-02-19','1998-03-19','1998-02-25',2,603.54,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',NULL,'Ireland'),
  (10898,'OCEAN',4,'1998-02-20','1998-03-20','1998-03-06',2,1.27,'Océano Atlántico Ltda.','Ing. Gustavo Moncada 8585 Piso 20-A','Buenos Aires',NULL,'1010','Argentina'),
  (10899,'LILAS',5,'1998-02-20','1998-03-20','1998-02-26',3,1.21,'LILA-Supermercado','Carrera 52 con Ave. Bolívar #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela'),
  (10900,'WELLI',1,'1998-02-20','1998-03-20','1998-03-04',2,1.66,'Wellington Importadora','Rua do Mercado, 12','Resende','SP','08737-363','Brazil'),
  (10901,'HILAA',4,'1998-02-23','1998-03-23','1998-02-26',1,62.09,'HILARION-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Cristóbal','Táchira','5022','Venezuela'),
  (10902,'FOLKO',1,'1998-02-23','1998-03-23','1998-03-03',1,44.15,'Folk och fä HB','Åkergatan 24','Bräcke',NULL,'S-844 67','Sweden'),
  (10903,'HANAR',3,'1998-02-24','1998-03-24','1998-03-04',3,36.71,'Hanari Carnes','Rua do Paço, 67','Rio de Janeiro','RJ','05454-876','Brazil'),
  (10904,'WHITC',3,'1998-02-24','1998-03-24','1998-02-27',3,162.95,'White Clover Markets','1029 - 12th Ave. S.','Seattle','WA','98124','USA'),
  (10905,'WELLI',9,'1998-02-24','1998-03-24','1998-03-06',2,13.72,'Wellington Importadora','Rua do Mercado, 12','Resende','SP','08737-363','Brazil'),
  (10906,'WOLZA',4,'1998-02-25','1998-03-11','1998-03-03',3,26.29,'Wolski Zajazd','ul. Filtrowa 68','Warszawa',NULL,'01-012','Poland'),
  (10907,'SPECD',6,'1998-02-25','1998-03-25','1998-02-27',3,9.19,'Spécialités du monde','25, rue Lauriston','Paris',NULL,'75016','France'),
  (10908,'REGGC',4,'1998-02-26','1998-03-26','1998-03-06',2,32.96,'Reggiani Caseifici','Strada Provinciale 124','Reggio Emilia',NULL,'42100','Italy'),
  (10909,'SANTG',1,'1998-02-26','1998-03-26','1998-03-10',2,53.05,'Santé Gourmet','Erling Skakkes gate 78','Stavern',NULL,'4110','Norway'),
  (10910,'WILMK',1,'1998-02-26','1998-03-26','1998-03-04',3,38.11,'Wilman Kala','Keskuskatu 45','Helsinki',NULL,'21240','Finland'),
  (10911,'GODOS',3,'1998-02-26','1998-03-26','1998-03-05',1,38.19,'Godos Cocina Típica','C/ Romero, 33','Sevilla',NULL,'41101','Spain'),
  (10912,'HUNGO',2,'1998-02-26','1998-03-26','1998-03-18',2,580.91,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',NULL,'Ireland'),
  (10913,'QUEEN',4,'1998-02-26','1998-03-26','1998-03-04',1,33.05,'Queen Cozinha','Alameda dos Canàrios, 891','Sao Paulo','SP','05487-020','Brazil'),
  (10914,'QUEEN',6,'1998-02-27','1998-03-27','1998-03-02',1,21.19,'Queen Cozinha','Alameda dos Canàrios, 891','Sao Paulo','SP','05487-020','Brazil'),
  (10915,'TORTU',2,'1998-02-27','1998-03-27','1998-03-02',2,3.51,'Tortuga Restaurante','Avda. Azteca 123','México D.F.',NULL,'05033','Mexico'),
  (10916,'RANCH',1,'1998-02-27','1998-03-27','1998-03-09',2,63.77,'Rancho grande','Av. del Libertador 900','Buenos Aires',NULL,'1010','Argentina'),
  (10917,'ROMEY',4,'1998-03-02','1998-03-30','1998-03-11',2,8.29,'Romero y tomillo','Gran Vía, 1','Madrid',NULL,'28001','Spain'),
  (10918,'BOTTM',3,'1998-03-02','1998-03-30','1998-03-11',3,48.83,'Bottom-Dollar Markets','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada'),
  (10919,'LINOD',2,'1998-03-02','1998-03-30','1998-03-04',2,19.8,'LINO-Delicateses','Ave. 5 de Mayo Porlamar','I. de Margarita','Nueva Esparta','4980','Venezuela'),
  (10920,'AROUT',4,'1998-03-03','1998-03-31','1998-03-09',2,29.61,'Around the Horn','Brook Farm Stratford St. Mary','Colchester','Essex','CO7 6JX','UK'),
  (10921,'VAFFE',1,'1998-03-03','1998-04-14','1998-03-09',1,176.48,'Vaffeljernet','Smagsloget 45','Århus',NULL,'8200','Denmark'),
  (10922,'HANAR',5,'1998-03-03','1998-03-31','1998-03-05',3,62.74,'Hanari Carnes','Rua do Paço, 67','Rio de Janeiro','RJ','05454-876','Brazil'),
  (10923,'LAMAI',7,'1998-03-03','1998-04-14','1998-03-13',3,68.26,'La maison d''Asie','1 rue Alsace-Lorraine','Toulouse',NULL,'31000','France'),
  (10924,'BERGS',3,'1998-03-04','1998-04-01','1998-04-08',2,151.52,'Berglunds snabbköp','Berguvsvägen  8','Luleå',NULL,'S-958 22','Sweden'),
  (10925,'HANAR',3,'1998-03-04','1998-04-01','1998-03-13',1,2.27,'Hanari Carnes','Rua do Paço, 67','Rio de Janeiro','RJ','05454-876','Brazil'),
  (10926,'ANATR',4,'1998-03-04','1998-04-01','1998-03-11',3,39.92,'Ana Trujillo Emparedados y helados','Avda. de la Constitución 2222','México D.F.',NULL,'05021','Mexico'),
  (10927,'LACOR',4,'1998-03-05','1998-04-02','1998-04-08',1,19.79,'La corne d''abondance','67, avenue de l''Europe','Versailles',NULL,'78000','France'),
  (10928,'GALED',1,'1998-03-05','1998-04-02','1998-03-18',1,1.36,'Galería del gastronómo','Rambla de Cataluña, 23','Barcelona',NULL,'8022','Spain'),
  (10929,'FRANK',6,'1998-03-05','1998-04-02','1998-03-12',1,33.93,'Frankenversand','Berliner Platz 43','München',NULL,'80805','Germany'),
  (10930,'SUPRD',4,'1998-03-06','1998-04-17','1998-03-18',3,15.55,'Suprêmes délices','Boulevard Tirou, 255','Charleroi',NULL,'B-6000','Belgium'),
  (10931,'RICSU',4,'1998-03-06','1998-03-20','1998-03-19',2,13.6,'Richter Supermarkt','Starenweg 5','Genève',NULL,'1204','Switzerland'),
  (10932,'BONAP',8,'1998-03-06','1998-04-03','1998-03-24',1,134.64,'Bon app''','12, rue des Bouchers','Marseille',NULL,'13008','France'),
  (10933,'ISLAT',6,'1998-03-06','1998-04-03','1998-03-16',3,54.15,'Island Trading','Garden House Crowther Way','Cowes','Isle of Wight','PO31 7PJ','UK'),
  (10934,'LEHMS',3,'1998-03-09','1998-04-06','1998-03-12',3,32.01,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M.',NULL,'60528','Germany'),
  (10935,'WELLI',4,'1998-03-09','1998-04-06','1998-03-18',3,47.59,'Wellington Importadora','Rua do Mercado, 12','Resende','SP','08737-363','Brazil'),
  (10936,'GREAL',3,'1998-03-09','1998-04-06','1998-03-18',2,33.68,'Great Lakes Food Market','2732 Baker Blvd.','Eugene','OR','97403','USA'),
  (10937,'CACTU',7,'1998-03-10','1998-03-24','1998-03-13',3,31.51,'Cactus Comidas para llevar','Cerrito 333','Buenos Aires',NULL,'1010','Argentina'),
  (10938,'QUICK',3,'1998-03-10','1998-04-07','1998-03-16',2,31.89,'QUICK-Stop','Taucherstraße 10','Cunewalde',NULL,'01307','Germany'),
  (10939,'MAGAA',2,'1998-03-10','1998-04-07','1998-03-13',2,76.33,'Magazzini Alimentari Riuniti','Via Ludovico il Moro 22','Bergamo',NULL,'24100','Italy'),
  (10940,'BONAP',8,'1998-03-11','1998-04-08','1998-03-23',3,19.77,'Bon app''','12, rue des Bouchers','Marseille',NULL,'13008','France'),
  (10941,'SAVEA',7,'1998-03-11','1998-04-08','1998-03-20',2,400.81,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (10942,'REGGC',9,'1998-03-11','1998-04-08','1998-03-18',3,17.95,'Reggiani Caseifici','Strada Provinciale 124','Reggio Emilia',NULL,'42100','Italy'),
  (10943,'BSBEV',4,'1998-03-11','1998-04-08','1998-03-19',2,2.17,'B''s Beverages','Fauntleroy Circus','London',NULL,'EC2 5NT','UK'),
  (10944,'BOTTM',6,'1998-03-12','1998-03-26','1998-03-13',3,52.92,'Bottom-Dollar Markets','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada'),
  (10945,'MORGK',4,'1998-03-12','1998-04-09','1998-03-18',1,10.22,'Morgenstern Gesundkost','Heerstr. 22','Leipzig',NULL,'04179','Germany'),
  (10946,'VAFFE',1,'1998-03-12','1998-04-09','1998-03-19',2,27.2,'Vaffeljernet','Smagsloget 45','Århus',NULL,'8200','Denmark'),
  (10947,'BSBEV',3,'1998-03-13','1998-04-10','1998-03-16',2,3.26,'B''s Beverages','Fauntleroy Circus','London',NULL,'EC2 5NT','UK'),
  (10948,'GODOS',3,'1998-03-13','1998-04-10','1998-03-19',3,23.39,'Godos Cocina Típica','C/ Romero, 33','Sevilla',NULL,'41101','Spain'),
  (10949,'BOTTM',2,'1998-03-13','1998-04-10','1998-03-17',3,74.44,'Bottom-Dollar Markets','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada'),
  (10950,'MAGAA',1,'1998-03-16','1998-04-13','1998-03-23',2,2.5,'Magazzini Alimentari Riuniti','Via Ludovico il Moro 22','Bergamo',NULL,'24100','Italy'),
  (10951,'RICSU',9,'1998-03-16','1998-04-27','1998-04-07',2,30.85,'Richter Supermarkt','Starenweg 5','Genève',NULL,'1204','Switzerland'),
  (10952,'ALFKI',1,'1998-03-16','1998-04-27','1998-03-24',1,40.42,'Alfred''s Futterkiste','Obere Str. 57','Berlin',NULL,'12209','Germany'),
  (10953,'AROUT',9,'1998-03-16','1998-03-30','1998-03-25',2,23.72,'Around the Horn','Brook Farm Stratford St. Mary','Colchester','Essex','CO7 6JX','UK'),
  (10954,'LINOD',5,'1998-03-17','1998-04-28','1998-03-20',1,27.91,'LINO-Delicateses','Ave. 5 de Mayo Porlamar','I. de Margarita','Nueva Esparta','4980','Venezuela'),
  (10955,'FOLKO',8,'1998-03-17','1998-04-14','1998-03-20',2,3.26,'Folk och fä HB','Åkergatan 24','Bräcke',NULL,'S-844 67','Sweden'),
  (10956,'BLAUS',6,'1998-03-17','1998-04-28','1998-03-20',2,44.65,'Blauer See Delikatessen','Forsterstr. 57','Mannheim',NULL,'68306','Germany'),
  (10957,'HILAA',8,'1998-03-18','1998-04-15','1998-03-27',3,105.36,'HILARION-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Cristóbal','Táchira','5022','Venezuela'),
  (10958,'OCEAN',7,'1998-03-18','1998-04-15','1998-03-27',2,49.56,'Océano Atlántico Ltda.','Ing. Gustavo Moncada 8585 Piso 20-A','Buenos Aires',NULL,'1010','Argentina'),
  (10959,'GOURL',6,'1998-03-18','1998-04-29','1998-03-23',2,4.98,'Gourmet Lanchonetes','Av. Brasil, 442','Campinas','SP','04876-786','Brazil'),
  (10960,'HILAA',3,'1998-03-19','1998-04-02','1998-04-08',1,2.08,'HILARION-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Cristóbal','Táchira','5022','Venezuela'),
  (10961,'QUEEN',8,'1998-03-19','1998-04-16','1998-03-30',1,104.47,'Queen Cozinha','Alameda dos Canàrios, 891','Sao Paulo','SP','05487-020','Brazil'),
  (10962,'QUICK',8,'1998-03-19','1998-04-16','1998-03-23',2,275.79,'QUICK-Stop','Taucherstraße 10','Cunewalde',NULL,'01307','Germany'),
  (10963,'FURIB',9,'1998-03-19','1998-04-16','1998-03-26',3,2.7,'Furia Bacalhau e Frutos do Mar','Jardim das rosas n. 32','Lisboa',NULL,'1675','Portugal'),
  (10964,'SPECD',3,'1998-03-20','1998-04-17','1998-03-24',2,87.38,'Spécialités du monde','25, rue Lauriston','Paris',NULL,'75016','France'),
  (10965,'OLDWO',6,'1998-03-20','1998-04-17','1998-03-30',3,144.38,'Old World Delicatessen','2743 Bering St.','Anchorage','AK','99508','USA'),
  (10966,'CHOPS',4,'1998-03-20','1998-04-17','1998-04-08',1,27.19,'Chop-suey Chinese','Hauptstr. 31','Bern',NULL,'3012','Switzerland'),
  (10967,'TOMSP',2,'1998-03-23','1998-04-20','1998-04-02',2,62.22,'Toms Spezialitäten','Luisenstr. 48','Münster',NULL,'44087','Germany'),
  (10968,'ERNSH',1,'1998-03-23','1998-04-20','1998-04-01',3,74.6,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (10969,'COMMI',1,'1998-03-23','1998-04-20','1998-03-30',2,0.21,'Comércio Mineiro','Av. dos Lusíadas, 23','Sao Paulo','SP','05432-043','Brazil'),
  (10970,'BOLID',9,'1998-03-24','1998-04-07','1998-04-24',1,16.16,'Bólido Comidas preparadas','C/ Araquil, 67','Madrid',NULL,'28023','Spain'),
  (10971,'FRANR',2,'1998-03-24','1998-04-21','1998-04-02',2,121.82,'France restauration','54, rue Royale','Nantes',NULL,'44000','France'),
  (10972,'LACOR',4,'1998-03-24','1998-04-21','1998-03-26',2,0.02,'La corne d''abondance','67, avenue de l''Europe','Versailles',NULL,'78000','France'),
  (10973,'LACOR',6,'1998-03-24','1998-04-21','1998-03-27',2,15.17,'La corne d''abondance','67, avenue de l''Europe','Versailles',NULL,'78000','France'),
  (10974,'SPLIR',3,'1998-03-25','1998-04-08','1998-04-03',3,12.96,'Split Rail Beer & Ale','P.O. Box 555','Lander','WY','82520','USA'),
  (10975,'BOTTM',1,'1998-03-25','1998-04-22','1998-03-27',3,32.27,'Bottom-Dollar Markets','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada'),
  (10976,'HILAA',1,'1998-03-25','1998-05-06','1998-04-03',1,37.97,'HILARION-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Cristóbal','Táchira','5022','Venezuela'),
  (10977,'FOLKO',8,'1998-03-26','1998-04-23','1998-04-10',3,208.5,'Folk och fä HB','Åkergatan 24','Bräcke',NULL,'S-844 67','Sweden'),
  (10978,'MAISD',9,'1998-03-26','1998-04-23','1998-04-23',2,32.82,'Maison Dewey','Rue Joseph-Bens 532','Bruxelles',NULL,'B-1180','Belgium'),
  (10979,'ERNSH',8,'1998-03-26','1998-04-23','1998-03-31',2,353.07,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (10980,'FOLKO',4,'1998-03-27','1998-05-08','1998-04-17',1,1.26,'Folk och fä HB','Åkergatan 24','Bräcke',NULL,'S-844 67','Sweden'),
  (10981,'HANAR',1,'1998-03-27','1998-04-24','1998-04-02',2,193.37,'Hanari Carnes','Rua do Paço, 67','Rio de Janeiro','RJ','05454-876','Brazil'),
  (10982,'BOTTM',2,'1998-03-27','1998-04-24','1998-04-08',1,14.01,'Bottom-Dollar Markets','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada'),
  (10983,'SAVEA',2,'1998-03-27','1998-04-24','1998-04-06',2,657.54,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (10984,'SAVEA',1,'1998-03-30','1998-04-27','1998-04-03',3,211.22,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (10985,'HUNGO',2,'1998-03-30','1998-04-27','1998-04-02',1,91.51,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',NULL,'Ireland'),
  (10986,'OCEAN',8,'1998-03-30','1998-04-27','1998-04-21',2,217.86,'Océano Atlántico Ltda.','Ing. Gustavo Moncada 8585 Piso 20-A','Buenos Aires',NULL,'1010','Argentina'),
  (10987,'EASTC',8,'1998-03-31','1998-04-28','1998-04-06',1,185.48,'Eastern Connection','35 King George','London',NULL,'WX3 6FW','UK'),
  (10988,'RATTC',3,'1998-03-31','1998-04-28','1998-04-10',2,61.14,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA'),
  (10989,'QUEDE',2,'1998-03-31','1998-04-28','1998-04-02',1,34.76,'Que Delícia','Rua da Panificadora, 12','Rio de Janeiro','RJ','02389-673','Brazil'),
  (10990,'ERNSH',2,'1998-04-01','1998-05-13','1998-04-07',3,117.61,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (10991,'QUICK',1,'1998-04-01','1998-04-29','1998-04-07',1,38.51,'QUICK-Stop','Taucherstraße 10','Cunewalde',NULL,'01307','Germany'),
  (10992,'THEBI',1,'1998-04-01','1998-04-29','1998-04-03',3,4.27,'The Big Cheese','89 Jefferson Way Suite 2','Portland','OR','97201','USA'),
  (10993,'FOLKO',7,'1998-04-01','1998-04-29','1998-04-10',3,8.81,'Folk och fä HB','Åkergatan 24','Bräcke',NULL,'S-844 67','Sweden'),
  (10994,'VAFFE',2,'1998-04-02','1998-04-16','1998-04-09',3,65.53,'Vaffeljernet','Smagsloget 45','Århus',NULL,'8200','Denmark'),
  (10995,'PERIC',1,'1998-04-02','1998-04-30','1998-04-06',3,46,'Pericles Comidas clásicas','Calle Dr. Jorge Cash 321','México D.F.',NULL,'05033','Mexico'),
  (10996,'QUICK',4,'1998-04-02','1998-04-30','1998-04-10',2,1.12,'QUICK-Stop','Taucherstraße 10','Cunewalde',NULL,'01307','Germany'),
  (10997,'LILAS',8,'1998-04-03','1998-05-15','1998-04-13',2,73.91,'LILA-Supermercado','Carrera 52 con Ave. Bolívar #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela'),
  (10998,'WOLZA',8,'1998-04-03','1998-04-17','1998-04-17',2,20.31,'Wolski Zajazd','ul. Filtrowa 68','Warszawa',NULL,'01-012','Poland'),
  (10999,'OTTIK',6,'1998-04-03','1998-05-01','1998-04-10',2,96.35,'Ottilies Käseladen','Mehrheimerstr. 369','Köln',NULL,'50739','Germany'),
  (11000,'RATTC',2,'1998-04-06','1998-05-04','1998-04-14',3,55.12,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA'),
  (11001,'FOLKO',2,'1998-04-06','1998-05-04','1998-04-14',2,197.3,'Folk och fä HB','Åkergatan 24','Bräcke',NULL,'S-844 67','Sweden'),
  (11002,'SAVEA',4,'1998-04-06','1998-05-04','1998-04-16',1,141.16,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (11003,'THECR',3,'1998-04-06','1998-05-04','1998-04-08',3,14.91,'The Cracker Box','55 Grizzly Peak Rd.','Butte','MT','59801','USA'),
  (11004,'MAISD',3,'1998-04-07','1998-05-05','1998-04-20',1,44.84,'Maison Dewey','Rue Joseph-Bens 532','Bruxelles',NULL,'B-1180','Belgium'),
  (11005,'WILMK',2,'1998-04-07','1998-05-05','1998-04-10',1,0.75,'Wilman Kala','Keskuskatu 45','Helsinki',NULL,'21240','Finland'),
  (11006,'GREAL',3,'1998-04-07','1998-05-05','1998-04-15',2,25.19,'Great Lakes Food Market','2732 Baker Blvd.','Eugene','OR','97403','USA'),
  (11007,'PRINI',8,'1998-04-08','1998-05-06','1998-04-13',2,202.24,'Princesa Isabel Vinhos','Estrada da saúde n. 58','Lisboa',NULL,'1756','Portugal'),
  (11008,'ERNSH',7,'1998-04-08','1998-05-06',NULL,3,79.46,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (11009,'GODOS',2,'1998-04-08','1998-05-06','1998-04-10',1,59.11,'Godos Cocina Típica','C/ Romero, 33','Sevilla',NULL,'41101','Spain'),
  (11010,'REGGC',2,'1998-04-09','1998-05-07','1998-04-21',2,28.71,'Reggiani Caseifici','Strada Provinciale 124','Reggio Emilia',NULL,'42100','Italy'),
  (11011,'ALFKI',3,'1998-04-09','1998-05-07','1998-04-13',1,1.21,'Alfred''s Futterkiste','Obere Str. 57','Berlin',NULL,'12209','Germany'),
  (11012,'FRANK',1,'1998-04-09','1998-04-23','1998-04-17',3,242.95,'Frankenversand','Berliner Platz 43','München',NULL,'80805','Germany'),
  (11013,'ROMEY',2,'1998-04-09','1998-05-07','1998-04-10',1,32.99,'Romero y tomillo','Gran Vía, 1','Madrid',NULL,'28001','Spain'),
  (11014,'LINOD',2,'1998-04-10','1998-05-08','1998-04-15',3,23.6,'LINO-Delicateses','Ave. 5 de Mayo Porlamar','I. de Margarita','Nueva Esparta','4980','Venezuela'),
  (11015,'SANTG',2,'1998-04-10','1998-04-24','1998-04-20',2,4.62,'Santé Gourmet','Erling Skakkes gate 78','Stavern',NULL,'4110','Norway'),
  (11016,'AROUT',9,'1998-04-10','1998-05-08','1998-04-13',2,33.8,'Around the Horn','Brook Farm Stratford St. Mary','Colchester','Essex','CO7 6JX','UK'),
  (11017,'ERNSH',9,'1998-04-13','1998-05-11','1998-04-20',2,754.26,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (11018,'LONEP',4,'1998-04-13','1998-05-11','1998-04-16',2,11.65,'Lonesome Pine Restaurant','89 Chiaroscuro Rd.','Portland','OR','97219','USA'),
  (11019,'RANCH',6,'1998-04-13','1998-05-11',NULL,3,3.17,'Rancho grande','Av. del Libertador 900','Buenos Aires',NULL,'1010','Argentina'),
  (11020,'OTTIK',2,'1998-04-14','1998-05-12','1998-04-16',2,43.3,'Ottilies Käseladen','Mehrheimerstr. 369','Köln',NULL,'50739','Germany'),
  (11021,'QUICK',3,'1998-04-14','1998-05-12','1998-04-21',1,297.18,'QUICK-Stop','Taucherstraße 10','Cunewalde',NULL,'01307','Germany'),
  (11022,'HANAR',9,'1998-04-14','1998-05-12','1998-05-04',2,6.27,'Hanari Carnes','Rua do Paço, 67','Rio de Janeiro','RJ','05454-876','Brazil'),
  (11023,'BSBEV',1,'1998-04-14','1998-04-28','1998-04-24',2,123.83,'B''s Beverages','Fauntleroy Circus','London',NULL,'EC2 5NT','UK'),
  (11024,'EASTC',4,'1998-04-15','1998-05-13','1998-04-20',1,74.36,'Eastern Connection','35 King George','London',NULL,'WX3 6FW','UK'),
  (11025,'WARTH',6,'1998-04-15','1998-05-13','1998-04-24',3,29.17,'Wartian Herkku','Torikatu 38','Oulu',NULL,'90110','Finland'),
  (11026,'FRANS',4,'1998-04-15','1998-05-13','1998-04-28',1,47.09,'Franchi S.p.A.','Via Monte Bianco 34','Torino',NULL,'10100','Italy'),
  (11027,'BOTTM',1,'1998-04-16','1998-05-14','1998-04-20',1,52.52,'Bottom-Dollar Markets','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada'),
  (11028,'KOENE',2,'1998-04-16','1998-05-14','1998-04-22',1,29.59,'Königlich Essen','Maubelstr. 90','Brandenburg',NULL,'14776','Germany'),
  (11029,'CHOPS',4,'1998-04-16','1998-05-14','1998-04-27',1,47.84,'Chop-suey Chinese','Hauptstr. 31','Bern',NULL,'3012','Switzerland'),
  (11030,'SAVEA',7,'1998-04-17','1998-05-15','1998-04-27',2,830.75,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (11031,'SAVEA',6,'1998-04-17','1998-05-15','1998-04-24',2,227.22,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (11032,'WHITC',2,'1998-04-17','1998-05-15','1998-04-23',3,606.19,'White Clover Markets','1029 - 12th Ave. S.','Seattle','WA','98124','USA'),
  (11033,'RICSU',7,'1998-04-17','1998-05-15','1998-04-23',3,84.74,'Richter Supermarkt','Starenweg 5','Genève',NULL,'1204','Switzerland'),
  (11034,'OLDWO',8,'1998-04-20','1998-06-01','1998-04-27',1,40.32,'Old World Delicatessen','2743 Bering St.','Anchorage','AK','99508','USA'),
  (11035,'SUPRD',2,'1998-04-20','1998-05-18','1998-04-24',2,0.17,'Suprêmes délices','Boulevard Tirou, 255','Charleroi',NULL,'B-6000','Belgium'),
  (11036,'DRACD',8,'1998-04-20','1998-05-18','1998-04-22',3,149.47,'Drachenblut Delikatessen','Walserweg 21','Aachen',NULL,'52066','Germany'),
  (11037,'GODOS',7,'1998-04-21','1998-05-19','1998-04-27',1,3.2,'Godos Cocina Típica','C/ Romero, 33','Sevilla',NULL,'41101','Spain'),
  (11038,'SUPRD',1,'1998-04-21','1998-05-19','1998-04-30',2,29.59,'Suprêmes délices','Boulevard Tirou, 255','Charleroi',NULL,'B-6000','Belgium'),
  (11039,'LINOD',1,'1998-04-21','1998-05-19',NULL,2,65,'LINO-Delicateses','Ave. 5 de Mayo Porlamar','I. de Margarita','Nueva Esparta','4980','Venezuela'),
  (11040,'GREAL',4,'1998-04-22','1998-05-20',NULL,3,18.84,'Great Lakes Food Market','2732 Baker Blvd.','Eugene','OR','97403','USA'),
  (11041,'CHOPS',3,'1998-04-22','1998-05-20','1998-04-28',2,48.22,'Chop-suey Chinese','Hauptstr. 31','Bern',NULL,'3012','Switzerland'),
  (11042,'COMMI',2,'1998-04-22','1998-05-06','1998-05-01',1,29.99,'Comércio Mineiro','Av. dos Lusíadas, 23','Sao Paulo','SP','05432-043','Brazil'),
  (11043,'SPECD',5,'1998-04-22','1998-05-20','1998-04-29',2,8.8,'Spécialités du monde','25, rue Lauriston','Paris',NULL,'75016','France'),
  (11044,'WOLZA',4,'1998-04-23','1998-05-21','1998-05-01',1,8.72,'Wolski Zajazd','ul. Filtrowa 68','Warszawa',NULL,'01-012','Poland'),
  (11045,'BOTTM',6,'1998-04-23','1998-05-21',NULL,2,70.58,'Bottom-Dollar Markets','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada'),
  (11046,'WANDK',8,'1998-04-23','1998-05-21','1998-04-24',2,71.64,'Die Wandernde Kuh','Adenauerallee 900','Stuttgart',NULL,'70563','Germany'),
  (11047,'EASTC',7,'1998-04-24','1998-05-22','1998-05-01',3,46.62,'Eastern Connection','35 King George','London',NULL,'WX3 6FW','UK'),
  (11048,'BOTTM',7,'1998-04-24','1998-05-22','1998-04-30',3,24.12,'Bottom-Dollar Markets','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada'),
  (11049,'GOURL',3,'1998-04-24','1998-05-22','1998-05-04',1,8.34,'Gourmet Lanchonetes','Av. Brasil, 442','Campinas','SP','04876-786','Brazil'),
  (11050,'FOLKO',8,'1998-04-27','1998-05-25','1998-05-05',2,59.41,'Folk och fä HB','Åkergatan 24','Bräcke',NULL,'S-844 67','Sweden'),
  (11051,'LAMAI',7,'1998-04-27','1998-05-25',NULL,3,2.79,'La maison d''Asie','1 rue Alsace-Lorraine','Toulouse',NULL,'31000','France'),
  (11052,'HANAR',3,'1998-04-27','1998-05-25','1998-05-01',1,67.26,'Hanari Carnes','Rua do Paço, 67','Rio de Janeiro','RJ','05454-876','Brazil'),
  (11053,'PICCO',2,'1998-04-27','1998-05-25','1998-04-29',2,53.05,'Piccolo und mehr','Geislweg 14','Salzburg',NULL,'5020','Austria'),
  (11054,'CACTU',8,'1998-04-28','1998-05-26',NULL,1,0.33,'Cactus Comidas para llevar','Cerrito 333','Buenos Aires',NULL,'1010','Argentina'),
  (11055,'HILAA',7,'1998-04-28','1998-05-26','1998-05-05',2,120.92,'HILARION-Abastos','Carrera 22 con Ave. Carlos Soublette #8-35','San Cristóbal','Táchira','5022','Venezuela'),
  (11056,'EASTC',8,'1998-04-28','1998-05-12','1998-05-01',2,278.96,'Eastern Connection','35 King George','London',NULL,'WX3 6FW','UK'),
  (11057,'NORTS',3,'1998-04-29','1998-05-27','1998-05-01',3,4.13,'North/South','South House 300 Queensbridge','London',NULL,'SW7 1RZ','UK'),
  (11058,'BLAUS',9,'1998-04-29','1998-05-27',NULL,3,31.14,'Blauer See Delikatessen','Forsterstr. 57','Mannheim',NULL,'68306','Germany'),
  (11059,'RICAR',2,'1998-04-29','1998-06-10',NULL,2,85.8,'Ricardo Adocicados','Av. Copacabana, 267','Rio de Janeiro','RJ','02389-890','Brazil'),
  (11060,'FRANS',2,'1998-04-30','1998-05-28','1998-05-04',2,10.98,'Franchi S.p.A.','Via Monte Bianco 34','Torino',NULL,'10100','Italy'),
  (11061,'GREAL',4,'1998-04-30','1998-06-11',NULL,3,14.01,'Great Lakes Food Market','2732 Baker Blvd.','Eugene','OR','97403','USA'),
  (11062,'REGGC',4,'1998-04-30','1998-05-28',NULL,2,29.93,'Reggiani Caseifici','Strada Provinciale 124','Reggio Emilia',NULL,'42100','Italy'),
  (11063,'HUNGO',3,'1998-04-30','1998-05-28','1998-05-06',2,81.73,'Hungry Owl All-Night Grocers','8 Johnstown Road','Cork','Co. Cork',NULL,'Ireland'),
  (11064,'SAVEA',1,'1998-05-01','1998-05-29','1998-05-04',1,30.09,'Save-a-lot Markets','187 Suffolk Ln.','Boise','ID','83720','USA'),
  (11065,'LILAS',8,'1998-05-01','1998-05-29',NULL,1,12.91,'LILA-Supermercado','Carrera 52 con Ave. Bolívar #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela'),
  (11066,'WHITC',7,'1998-05-01','1998-05-29','1998-05-04',2,44.72,'White Clover Markets','1029 - 12th Ave. S.','Seattle','WA','98124','USA'),
  (11067,'DRACD',1,'1998-05-04','1998-05-18','1998-05-06',2,7.98,'Drachenblut Delikatessen','Walserweg 21','Aachen',NULL,'52066','Germany'),
  (11068,'QUEEN',8,'1998-05-04','1998-06-01',NULL,2,81.75,'Queen Cozinha','Alameda dos Canàrios, 891','Sao Paulo','SP','05487-020','Brazil'),
  (11069,'TORTU',1,'1998-05-04','1998-06-01','1998-05-06',2,15.67,'Tortuga Restaurante','Avda. Azteca 123','México D.F.',NULL,'05033','Mexico'),
  (11070,'LEHMS',2,'1998-05-05','1998-06-02',NULL,1,136,'Lehmanns Marktstand','Magazinweg 7','Frankfurt a.M.',NULL,'60528','Germany'),
  (11071,'LILAS',1,'1998-05-05','1998-06-02',NULL,1,0.93,'LILA-Supermercado','Carrera 52 con Ave. Bolívar #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela'),
  (11072,'ERNSH',4,'1998-05-05','1998-06-02',NULL,2,258.64,'Ernst Handel','Kirchgasse 6','Graz',NULL,'8010','Austria'),
  (11073,'PERIC',2,'1998-05-05','1998-06-02',NULL,2,24.95,'Pericles Comidas clásicas','Calle Dr. Jorge Cash 321','México D.F.',NULL,'05033','Mexico'),
  (11074,'SIMOB',7,'1998-05-06','1998-06-03',NULL,2,18.44,'Simons bistro','Vinbæltet 34','Kobenhavn',NULL,'1734','Denmark'),
  (11075,'RICSU',8,'1998-05-06','1998-06-03',NULL,2,6.19,'Richter Supermarkt','Starenweg 5','Genève',NULL,'1204','Switzerland'),
  (11076,'BONAP',4,'1998-05-06','1998-06-03',NULL,2,38.28,'Bon app''','12, rue des Bouchers','Marseille',NULL,'13008','France'),
  (11077,'RATTC',1,'1998-05-06','1998-06-03',NULL,2,8.53,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA');

COMMIT;

#
# Data for the `Suppliers` table  (LIMIT 0,500)
#

INSERT INTO `Suppliers` (`SupplierID`, `CompanyName`, `ContactName`, `ContactTitle`, `Address`, `City`, `Region`, `PostalCode`, `Country`, `Phone`, `Fax`, `HomePage`) VALUES 
  (1,'Exotic Liquids','Charlotte Cooper','Purchasing Manager','49 Gilbert St.','London',NULL,'EC1 4SD','UK','(171) 555-2222',NULL,NULL),
  (2,'New Orleans Cajun Delights','Shelley Burke','Order Administrator','P.O. Box 78934','New Orleans','LA','70117','USA','(100) 555-4822',NULL,'#CAJUN.HTM#'),
  (3,'Grandma Kelly''s Homestead','Regina Murphy','Sales Representative','707 Oxford Rd.','Ann Arbor','MI','48104','USA','(313) 555-5735','(313) 555-3349',NULL),
  (4,'Tokyo Traders','Yoshi Nagase','Marketing Manager','9-8 Sekimai Musashino-shi','Tokyo',NULL,'100','Japan','(03) 3555-5011',NULL,NULL),
  (5,'Cooperativa de Quesos ''Las Cabras''','Antonio del Valle Saavedra','Export Administrator','Calle del Rosal 4','Oviedo','Asturias','33007','Spain','(98) 598 76 54',NULL,NULL),
  (6,'Mayumi''s','Mayumi Ohno','Marketing Representative','92 Setsuko Chuo-ku','Osaka',NULL,'545','Japan','(06) 431-7877',NULL,'Mayumi''s (on the World Wide Web)#http://www.microsoft.com/accessdev/sampleapps/mayumi.htm#'),
  (7,'Pavlova, Ltd.','Ian Devling','Marketing Manager','74 Rose St. Moonie Ponds','Melbourne','Victoria','3058','Australia','(03) 444-2343','(03) 444-6588',NULL),
  (8,'Specialty Biscuits, Ltd.','Peter Wilson','Sales Representative','29 King''s Way','Manchester',NULL,'M14 GSD','UK','(161) 555-4448',NULL,NULL),
  (9,'PB Knäckebröd AB','Lars Peterson','Sales Agent','Kaloadagatan 13','Göteborg',NULL,'S-345 67','Sweden','031-987 65 43','031-987 65 91',NULL),
  (10,'Refrescos Americanas LTDA','Carlos Diaz','Marketing Manager','Av. das Americanas 12.890','Sao Paulo',NULL,'5442','Brazil','(11) 555 4640',NULL,NULL),
  (11,'Heli Süßwaren GmbH & Co. KG','Petra Winkler','Sales Manager','Tiergartenstraße 5','Berlin',NULL,'10785','Germany','(010) 9984510',NULL,NULL),
  (12,'Plutzer Lebensmittelgroßmärkte AG','Martin Bein','International Marketing Mgr.','Bogenallee 51','Frankfurt',NULL,'60439','Germany','(069) 992755',NULL,'Plutzer (on the World Wide Web)#http://www.microsoft.com/accessdev/sampleapps/plutzer.htm#'),
  (13,'Nord-Ost-Fisch Handelsgesellschaft mbH','Sven Petersen','Coordinator Foreign Markets','Frahmredder 112a','Cuxhaven',NULL,'27478','Germany','(04721) 8713','(04721) 8714',NULL),
  (14,'Formaggi Fortini s.r.l.','Elio Rossi','Sales Representative','Viale Dante, 75','Ravenna',NULL,'48100','Italy','(0544) 60323','(0544) 60603','#FORMAGGI.HTM#'),
  (15,'Norske Meierier','Beate Vileid','Marketing Manager','Hatlevegen 5','Sandvika',NULL,'1320','Norway','(0)2-953010',NULL,NULL),
  (16,'Bigfoot Breweries','Cheryl Saylor','Regional Account Rep.','3400 - 8th Avenue Suite 210','Bend','OR','97101','USA','(503) 555-9931',NULL,NULL),
  (17,'Svensk Sjöföda AB','Michael Björn','Sales Representative','Brovallavägen 231','Stockholm',NULL,'S-123 45','Sweden','08-123 45 67',NULL,NULL),
  (18,'Aux joyeux ecclésiastiques','Guylène Nodier','Sales Manager','203, Rue des Francs-Bourgeois','Paris',NULL,'75004','France','(1) 03.83.00.68','(1) 03.83.00.62',NULL),
  (19,'New England Seafood Cannery','Robb Merchant','Wholesale Account Agent','Order Processing Dept. 2100 Paul Revere Blvd.','Boston','MA','02134','USA','(617) 555-3267','(617) 555-3389',NULL),
  (20,'Leka Trading','Chandra Leka','Owner','471 Serangoon Loop, Suite #402','Singapore',NULL,'0512','Singapore','555-8787',NULL,NULL),
  (21,'Lyngbysild','Niels Petersen','Sales Manager','Lyngbysild Fiskebakken 10','Lyngby',NULL,'2800','Denmark','43844108','43844115',NULL),
  (22,'Zaanse Snoepfabriek','Dirk Luchte','Accounting Manager','Verkoop Rijnweg 22','Zaandam',NULL,'9999 ZZ','Netherlands','(12345) 1212','(12345) 1210',NULL),
  (23,'Karkki Oy','Anne Heikkonen','Product Manager','Valtakatu 12','Lappeenranta',NULL,'53120','Finland','(953) 10956',NULL,NULL),
  (24,'G''day, Mate','Wendy Mackenzie','Sales Representative','170 Prince Edward Parade Hunter''s Hill','Sydney','NSW','2042','Australia','(02) 555-5914','(02) 555-4873','G''day Mate (on the World Wide Web)#http://www.microsoft.com/accessdev/sampleapps/gdaymate.htm#'),
  (25,'Ma Maison','Jean-Guy Lauzon','Marketing Manager','2960 Rue St. Laurent','Montréal','Québec','H1J 1C3','Canada','(514) 555-9022',NULL,NULL),
  (26,'Pasta Buttini s.r.l.','Giovanni Giudici','Order Administrator','Via dei Gelsomini, 153','Salerno',NULL,'84100','Italy','(089) 6547665','(089) 6547667',NULL),
  (27,'Escargots Nouveaux','Marie Delamare','Sales Manager','22, rue H. Voiron','Montceau',NULL,'71300','France','85.57.00.07',NULL,NULL),
  (28,'Gai pâturage','Eliane Noz','Sales Representative','Bat. B 3, rue des Alpes','Annecy',NULL,'74000','France','38.76.98.06','38.76.98.58',NULL),
  (29,'Forêts d''érables','Chantal Goulet','Accounting Manager','148 rue Chasseur','Ste-Hyacinthe','Québec','J2S 7S8','Canada','(514) 555-2955','(514) 555-2921',NULL);

COMMIT;

#
# Data for the `Products` table  (LIMIT 0,500)
#

INSERT INTO `Products` (`ProductID`, `ProductName`, `SupplierID`, `CategoryID`, `QuantityPerUnit`, `UnitPrice`, `UnitsInStock`, `UnitsOnOrder`, `ReorderLevel`, `Discontinued`) VALUES 
  (1,'Chai',1,1,'10 boxes x 20 bags',18,39,0,10,0),
  (2,'Chang',1,1,'24 - 12 oz bottles',19,17,40,25,0),
  (3,'Aniseed Syrup',1,2,'12 - 550 ml bottles',10,13,70,25,0),
  (4,'Chef Anton''s Cajun Seasoning',2,2,'48 - 6 oz jars',22,53,0,0,0),
  (5,'Chef Anton''s Gumbo Mix',2,2,'36 boxes',21.35,0,0,0,1),
  (6,'Grandma''s Boysenberry Spread',3,2,'12 - 8 oz jars',25,120,0,25,0),
  (7,'Uncle Bob''s Organic Dried Pears',3,7,'12 - 1 lb pkgs.',30,15,0,10,0),
  (8,'Northwoods Cranberry Sauce',3,2,'12 - 12 oz jars',40,6,0,0,0),
  (9,'Mishi Kobe Niku',4,6,'18 - 500 g pkgs.',97,29,0,0,1),
  (10,'Ikura',4,8,'12 - 200 ml jars',31,31,0,0,0),
  (11,'Queso Cabrales',5,4,'1 kg pkg.',21,22,30,30,0),
  (12,'Queso Manchego La Pastora',5,4,'10 - 500 g pkgs.',38,86,0,0,0),
  (13,'Konbu',6,8,'2 kg box',6,24,0,5,0),
  (14,'Tofu',6,7,'40 - 100 g pkgs.',23.25,35,0,0,0),
  (15,'Genen Shouyu',6,2,'24 - 250 ml bottles',15.5,39,0,5,0),
  (16,'Pavlova',7,3,'32 - 500 g boxes',17.45,29,0,10,0),
  (17,'Alice Mutton',7,6,'20 - 1 kg tins',39,0,0,0,1),
  (18,'Carnarvon Tigers',7,8,'16 kg pkg.',62.5,42,0,0,0),
  (19,'Teatime Chocolate Biscuits',8,3,'10 boxes x 12 pieces',9.2,25,0,5,0),
  (20,'Sir Rodney''s Marmalade',8,3,'30 gift boxes',81,40,0,0,0),
  (21,'Sir Rodney''s Scones',8,3,'24 pkgs. x 4 pieces',10,3,40,5,0),
  (22,'Gustaf''s Knäckebröd',9,5,'24 - 500 g pkgs.',21,104,0,25,0),
  (23,'Tunnbröd',9,5,'12 - 250 g pkgs.',9,61,0,25,0),
  (24,'Guaraná Fantástica',10,1,'12 - 355 ml cans',4.5,20,0,0,1),
  (25,'NuNuCa Nuß-Nougat-Creme',11,3,'20 - 450 g glasses',14,76,0,30,0),
  (26,'Gumbär Gummibärchen',11,3,'100 - 250 g bags',31.23,15,0,0,0),
  (27,'Schoggi Schokolade',11,3,'100 - 100 g pieces',43.9,49,0,30,0),
  (28,'Rössle Sauerkraut',12,7,'25 - 825 g cans',45.6,26,0,0,1),
  (29,'Thüringer Rostbratwurst',12,6,'50 bags x 30 sausgs.',123.79,0,0,0,1),
  (30,'Nord-Ost Matjeshering',13,8,'10 - 200 g glasses',25.89,10,0,15,0),
  (31,'Gorgonzola Telino',14,4,'12 - 100 g pkgs',12.5,0,70,20,0),
  (32,'Mascarpone Fabioli',14,4,'24 - 200 g pkgs.',32,9,40,25,0),
  (33,'Geitost',15,4,'500 g',2.5,112,0,20,0),
  (34,'Sasquatch Ale',16,1,'24 - 12 oz bottles',14,111,0,15,0),
  (35,'Steeleye Stout',16,1,'24 - 12 oz bottles',18,20,0,15,0),
  (36,'Inlagd Sill',17,8,'24 - 250 g  jars',19,112,0,20,0),
  (37,'Gravad lax',17,8,'12 - 500 g pkgs.',26,11,50,25,0),
  (38,'Côte de Blaye',18,1,'12 - 75 cl bottles',263.5,17,0,15,0),
  (39,'Chartreuse verte',18,1,'750 cc per bottle',18,69,0,5,0),
  (40,'Boston Crab Meat',19,8,'24 - 4 oz tins',18.4,123,0,30,0),
  (41,'Jack''s New England Clam Chowder',19,8,'12 - 12 oz cans',9.65,85,0,10,0),
  (42,'Singaporean Hokkien Fried Mee',20,5,'32 - 1 kg pkgs.',14,26,0,0,1),
  (43,'Ipoh Coffee',20,1,'16 - 500 g tins',46,17,10,25,0),
  (44,'Gula Malacca',20,2,'20 - 2 kg bags',19.45,27,0,15,0),
  (45,'Rogede sild',21,8,'1k pkg.',9.5,5,70,15,0),
  (46,'Spegesild',21,8,'4 - 450 g glasses',12,95,0,0,0),
  (47,'Zaanse koeken',22,3,'10 - 4 oz boxes',9.5,36,0,0,0),
  (48,'Chocolade',22,3,'10 pkgs.',12.75,15,70,25,0),
  (49,'Maxilaku',23,3,'24 - 50 g pkgs.',20,10,60,15,0),
  (50,'Valkoinen suklaa',23,3,'12 - 100 g bars',16.25,65,0,30,0),
  (51,'Manjimup Dried Apples',24,7,'50 - 300 g pkgs.',53,20,0,10,0),
  (52,'Filo Mix',24,5,'16 - 2 kg boxes',7,38,0,25,0),
  (53,'Perth Pasties',24,6,'48 pieces',32.8,0,0,0,1),
  (54,'Tourtière',25,6,'16 pies',7.45,21,0,10,0),
  (55,'Pâté chinois',25,6,'24 boxes x 2 pies',24,115,0,20,0),
  (56,'Gnocchi di nonna Alice',26,5,'24 - 250 g pkgs.',38,21,10,30,0),
  (57,'Ravioli Angelo',26,5,'24 - 250 g pkgs.',19.5,36,0,20,0),
  (58,'Escargots de Bourgogne',27,8,'24 pieces',13.25,62,0,20,0),
  (59,'Raclette Courdavault',28,4,'5 kg pkg.',55,79,0,0,0),
  (60,'Camembert Pierrot',28,4,'15 - 300 g rounds',34,19,0,0,0),
  (61,'Sirop d''érable',29,2,'24 - 500 ml bottles',28.5,113,0,25,0),
  (62,'Tarte au sucre',29,3,'48 pies',49.3,17,0,0,0),
  (63,'Vegie-spread',7,2,'15 - 625 g jars',43.9,24,0,5,0),
  (64,'Wimmers gute Semmelknödel',12,5,'20 bags x 4 pieces',33.25,22,80,30,0),
  (65,'Louisiana Fiery Hot Pepper Sauce',2,2,'32 - 8 oz bottles',21.05,76,0,0,0),
  (66,'Louisiana Hot Spiced Okra',2,2,'24 - 8 oz jars',17,4,100,20,0),
  (67,'Laughing Lumberjack Lager',16,1,'24 - 12 oz bottles',14,52,0,10,0),
  (68,'Scottish Longbreads',8,3,'10 boxes x 8 pieces',12.5,6,10,15,0),
  (69,'Gudbrandsdalsost',15,4,'10 kg pkg.',36,26,0,15,0),
  (70,'Outback Lager',7,1,'24 - 355 ml bottles',15,15,10,30,0),
  (71,'Flotemysost',15,4,'10 - 500 g pkgs.',21.5,26,0,0,0),
  (72,'Mozzarella di Giovanni',14,4,'24 - 200 g pkgs.',34.8,14,0,0,0),
  (73,'Röd Kaviar',17,8,'24 - 150 g jars',15,101,0,5,0),
  (74,'Longlife Tofu',4,7,'5 kg pkg.',10,4,20,5,0),
  (75,'Rhönbräu Klosterbier',12,1,'24 - 0.5 l bottles',7.75,125,0,25,0),
  (76,'Lakkalikööri',23,1,'500 ml',18,57,0,20,0),
  (77,'Original Frankfurter grüne Soße',12,2,'12 boxes',13,32,0,15,0);

COMMIT;

#
# Data for the `Order Details` table  (LIMIT 0,500)
#

INSERT INTO `Order Details` (`OrderID`, `ProductID`, `UnitPrice`, `Quantity`, `Discount`) VALUES 
  (10248,11,14,12,0),
  (10248,42,9.8,10,0),
  (10248,72,34.8,5,0),
  (10249,14,18.6,9,0),
  (10249,51,42.4,40,0),
  (10250,41,7.7,10,0),
  (10250,51,42.4,35,0.15),
  (10250,65,16.8,15,0.15),
  (10251,22,16.8,6,0.05),
  (10251,57,15.6,15,0.05),
  (10251,65,16.8,20,0),
  (10252,20,64.8,40,0.05),
  (10252,33,2,25,0.05),
  (10252,60,27.2,40,0),
  (10253,31,10,20,0),
  (10253,39,14.4,42,0),
  (10253,49,16,40,0),
  (10254,24,3.6,15,0.15),
  (10254,55,19.2,21,0.15),
  (10254,74,8,21,0),
  (10255,2,15.2,20,0),
  (10255,16,13.9,35,0),
  (10255,36,15.2,25,0),
  (10255,59,44,30,0),
  (10256,53,26.2,15,0),
  (10256,77,10.4,12,0),
  (10257,27,35.1,25,0),
  (10257,39,14.4,6,0),
  (10257,77,10.4,15,0),
  (10258,2,15.2,50,0.2),
  (10258,5,17,65,0.2),
  (10258,32,25.6,6,0.2),
  (10259,21,8,10,0),
  (10259,37,20.8,1,0),
  (10260,41,7.7,16,0.25),
  (10260,57,15.6,50,0),
  (10260,62,39.4,15,0.25),
  (10260,70,12,21,0.25),
  (10261,21,8,20,0),
  (10261,35,14.4,20,0),
  (10262,5,17,12,0.2),
  (10262,7,24,15,0),
  (10262,56,30.4,2,0),
  (10263,16,13.9,60,0.25),
  (10263,24,3.6,28,0),
  (10263,30,20.7,60,0.25),
  (10263,74,8,36,0.25),
  (10264,2,15.2,35,0),
  (10264,41,7.7,25,0.15),
  (10265,17,31.2,30,0),
  (10265,70,12,20,0),
  (10266,12,30.4,12,0.05),
  (10267,40,14.7,50,0),
  (10267,59,44,70,0.15),
  (10267,76,14.4,15,0.15),
  (10268,29,99,10,0),
  (10268,72,27.8,4,0),
  (10269,33,2,60,0.05),
  (10269,72,27.8,20,0.05),
  (10270,36,15.2,30,0),
  (10270,43,36.8,25,0),
  (10271,33,2,24,0),
  (10272,20,64.8,6,0),
  (10272,31,10,40,0),
  (10272,72,27.8,24,0),
  (10273,10,24.8,24,0.05),
  (10273,31,10,15,0.05),
  (10273,33,2,20,0),
  (10273,40,14.7,60,0.05),
  (10273,76,14.4,33,0.05),
  (10274,71,17.2,20,0),
  (10274,72,27.8,7,0),
  (10275,24,3.6,12,0.05),
  (10275,59,44,6,0.05),
  (10276,10,24.8,15,0),
  (10276,13,4.8,10,0),
  (10277,28,36.4,20,0),
  (10277,62,39.4,12,0),
  (10278,44,15.5,16,0),
  (10278,59,44,15,0),
  (10278,63,35.1,8,0),
  (10278,73,12,25,0),
  (10279,17,31.2,15,0.25),
  (10280,24,3.6,12,0),
  (10280,55,19.2,20,0),
  (10280,75,6.2,30,0),
  (10281,19,7.3,1,0),
  (10281,24,3.6,6,0),
  (10281,35,14.4,4,0),
  (10282,30,20.7,6,0),
  (10282,57,15.6,2,0),
  (10283,15,12.4,20,0),
  (10283,19,7.3,18,0),
  (10283,60,27.2,35,0),
  (10283,72,27.8,3,0),
  (10284,27,35.1,15,0.25),
  (10284,44,15.5,21,0),
  (10284,60,27.2,20,0.25),
  (10284,67,11.2,5,0.25),
  (10285,1,14.4,45,0.2),
  (10285,40,14.7,40,0.2),
  (10285,53,26.2,36,0.2),
  (10286,35,14.4,100,0),
  (10286,62,39.4,40,0),
  (10287,16,13.9,40,0.15),
  (10287,34,11.2,20,0),
  (10287,46,9.6,15,0.15),
  (10288,54,5.9,10,0.1),
  (10288,68,10,3,0.1),
  (10289,3,8,30,0),
  (10289,64,26.6,9,0),
  (10290,5,17,20,0),
  (10290,29,99,15,0),
  (10290,49,16,15,0),
  (10290,77,10.4,10,0),
  (10291,13,4.8,20,0.1),
  (10291,44,15.5,24,0.1),
  (10291,51,42.4,2,0.1),
  (10292,20,64.8,20,0),
  (10293,18,50,12,0),
  (10293,24,3.6,10,0),
  (10293,63,35.1,5,0),
  (10293,75,6.2,6,0),
  (10294,1,14.4,18,0),
  (10294,17,31.2,15,0),
  (10294,43,36.8,15,0),
  (10294,60,27.2,21,0),
  (10294,75,6.2,6,0),
  (10295,56,30.4,4,0),
  (10296,11,16.8,12,0),
  (10296,16,13.9,30,0),
  (10296,69,28.8,15,0),
  (10297,39,14.4,60,0),
  (10297,72,27.8,20,0),
  (10298,2,15.2,40,0),
  (10298,36,15.2,40,0.25),
  (10298,59,44,30,0.25),
  (10298,62,39.4,15,0),
  (10299,19,7.3,15,0),
  (10299,70,12,20,0),
  (10300,66,13.6,30,0),
  (10300,68,10,20,0),
  (10301,40,14.7,10,0),
  (10301,56,30.4,20,0),
  (10302,17,31.2,40,0),
  (10302,28,36.4,28,0),
  (10302,43,36.8,12,0),
  (10303,40,14.7,40,0.1),
  (10303,65,16.8,30,0.1),
  (10303,68,10,15,0.1),
  (10304,49,16,30,0),
  (10304,59,44,10,0),
  (10304,71,17.2,2,0),
  (10305,18,50,25,0.1),
  (10305,29,99,25,0.1),
  (10305,39,14.4,30,0.1),
  (10306,30,20.7,10,0),
  (10306,53,26.2,10,0),
  (10306,54,5.9,5,0),
  (10307,62,39.4,10,0),
  (10307,68,10,3,0),
  (10308,69,28.8,1,0),
  (10308,70,12,5,0),
  (10309,4,17.6,20,0),
  (10309,6,20,30,0),
  (10309,42,11.2,2,0),
  (10309,43,36.8,20,0),
  (10309,71,17.2,3,0),
  (10310,16,13.9,10,0),
  (10310,62,39.4,5,0),
  (10311,42,11.2,6,0),
  (10311,69,28.8,7,0),
  (10312,28,36.4,4,0),
  (10312,43,36.8,24,0),
  (10312,53,26.2,20,0),
  (10312,75,6.2,10,0),
  (10313,36,15.2,12,0),
  (10314,32,25.6,40,0.1),
  (10314,58,10.6,30,0.1),
  (10314,62,39.4,25,0.1),
  (10315,34,11.2,14,0),
  (10315,70,12,30,0),
  (10316,41,7.7,10,0),
  (10316,62,39.4,70,0),
  (10317,1,14.4,20,0),
  (10318,41,7.7,20,0),
  (10318,76,14.4,6,0),
  (10319,17,31.2,8,0),
  (10319,28,36.4,14,0),
  (10319,76,14.4,30,0),
  (10320,71,17.2,30,0),
  (10321,35,14.4,10,0),
  (10322,52,5.6,20,0),
  (10323,15,12.4,5,0),
  (10323,25,11.2,4,0),
  (10323,39,14.4,4,0),
  (10324,16,13.9,21,0.15),
  (10324,35,14.4,70,0.15),
  (10324,46,9.6,30,0),
  (10324,59,44,40,0.15),
  (10324,63,35.1,80,0.15),
  (10325,6,20,6,0),
  (10325,13,4.8,12,0),
  (10325,14,18.6,9,0),
  (10325,31,10,4,0),
  (10325,72,27.8,40,0),
  (10326,4,17.6,24,0),
  (10326,57,15.6,16,0),
  (10326,75,6.2,50,0),
  (10327,2,15.2,25,0.2),
  (10327,11,16.8,50,0.2),
  (10327,30,20.7,35,0.2),
  (10327,58,10.6,30,0.2),
  (10328,59,44,9,0),
  (10328,65,16.8,40,0),
  (10328,68,10,10,0),
  (10329,19,7.3,10,0.05),
  (10329,30,20.7,8,0.05),
  (10329,38,210.8,20,0.05),
  (10329,56,30.4,12,0.05),
  (10330,26,24.9,50,0.15),
  (10330,72,27.8,25,0.15),
  (10331,54,5.9,15,0),
  (10332,18,50,40,0.2),
  (10332,42,11.2,10,0.2),
  (10332,47,7.6,16,0.2),
  (10333,14,18.6,10,0),
  (10333,21,8,10,0.1),
  (10333,71,17.2,40,0.1),
  (10334,52,5.6,8,0),
  (10334,68,10,10,0),
  (10335,2,15.2,7,0.2),
  (10335,31,10,25,0.2),
  (10335,32,25.6,6,0.2),
  (10335,51,42.4,48,0.2),
  (10336,4,17.6,18,0.1),
  (10337,23,7.2,40,0),
  (10337,26,24.9,24,0),
  (10337,36,15.2,20,0),
  (10337,37,20.8,28,0),
  (10337,72,27.8,25,0),
  (10338,17,31.2,20,0),
  (10338,30,20.7,15,0),
  (10339,4,17.6,10,0),
  (10339,17,31.2,70,0.05),
  (10339,62,39.4,28,0),
  (10340,18,50,20,0.05),
  (10340,41,7.7,12,0.05),
  (10340,43,36.8,40,0.05),
  (10341,33,2,8,0),
  (10341,59,44,9,0.15),
  (10342,2,15.2,24,0.2),
  (10342,31,10,56,0.2),
  (10342,36,15.2,40,0.2),
  (10342,55,19.2,40,0.2),
  (10343,64,26.6,50,0),
  (10343,68,10,4,0.05),
  (10343,76,14.4,15,0),
  (10344,4,17.6,35,0),
  (10344,8,32,70,0.25),
  (10345,8,32,70,0),
  (10345,19,7.3,80,0),
  (10345,42,11.2,9,0),
  (10346,17,31.2,36,0.1),
  (10346,56,30.4,20,0),
  (10347,25,11.2,10,0),
  (10347,39,14.4,50,0.15),
  (10347,40,14.7,4,0),
  (10347,75,6.2,6,0.15),
  (10348,1,14.4,15,0.15),
  (10348,23,7.2,25,0),
  (10349,54,5.9,24,0),
  (10350,50,13,15,0.1),
  (10350,69,28.8,18,0.1),
  (10351,38,210.8,20,0.05),
  (10351,41,7.7,13,0),
  (10351,44,15.5,77,0.05),
  (10351,65,16.8,10,0.05),
  (10352,24,3.6,10,0),
  (10352,54,5.9,20,0.15),
  (10353,11,16.8,12,0.2),
  (10353,38,210.8,50,0.2),
  (10354,1,14.4,12,0),
  (10354,29,99,4,0),
  (10355,24,3.6,25,0),
  (10355,57,15.6,25,0),
  (10356,31,10,30,0),
  (10356,55,19.2,12,0),
  (10356,69,28.8,20,0),
  (10357,10,24.8,30,0.2),
  (10357,26,24.9,16,0),
  (10357,60,27.2,8,0.2),
  (10358,24,3.6,10,0.05),
  (10358,34,11.2,10,0.05),
  (10358,36,15.2,20,0.05),
  (10359,16,13.9,56,0.05),
  (10359,31,10,70,0.05),
  (10359,60,27.2,80,0.05),
  (10360,28,36.4,30,0),
  (10360,29,99,35,0),
  (10360,38,210.8,10,0),
  (10360,49,16,35,0),
  (10360,54,5.9,28,0),
  (10361,39,14.4,54,0.1),
  (10361,60,27.2,55,0.1),
  (10362,25,11.2,50,0),
  (10362,51,42.4,20,0),
  (10362,54,5.9,24,0),
  (10363,31,10,20,0),
  (10363,75,6.2,12,0),
  (10363,76,14.4,12,0),
  (10364,69,28.8,30,0),
  (10364,71,17.2,5,0),
  (10365,11,16.8,24,0),
  (10366,65,16.8,5,0),
  (10366,77,10.4,5,0),
  (10367,34,11.2,36,0),
  (10367,54,5.9,18,0),
  (10367,65,16.8,15,0),
  (10367,77,10.4,7,0),
  (10368,21,8,5,0.1),
  (10368,28,36.4,13,0.1),
  (10368,57,15.6,25,0),
  (10368,64,26.6,35,0.1),
  (10369,29,99,20,0),
  (10369,56,30.4,18,0.25),
  (10370,1,14.4,15,0.15),
  (10370,64,26.6,30,0),
  (10370,74,8,20,0.15),
  (10371,36,15.2,6,0.2),
  (10372,20,64.8,12,0.25),
  (10372,38,210.8,40,0.25),
  (10372,60,27.2,70,0.25),
  (10372,72,27.8,42,0.25),
  (10373,58,10.6,80,0.2),
  (10373,71,17.2,50,0.2),
  (10374,31,10,30,0),
  (10374,58,10.6,15,0),
  (10375,14,18.6,15,0),
  (10375,54,5.9,10,0),
  (10376,31,10,42,0.05),
  (10377,28,36.4,20,0.15),
  (10377,39,14.4,20,0.15),
  (10378,71,17.2,6,0),
  (10379,41,7.7,8,0.1),
  (10379,63,35.1,16,0.1),
  (10379,65,16.8,20,0.1),
  (10380,30,20.7,18,0.1),
  (10380,53,26.2,20,0.1),
  (10380,60,27.2,6,0.1),
  (10380,70,12,30,0),
  (10381,74,8,14,0),
  (10382,5,17,32,0),
  (10382,18,50,9,0),
  (10382,29,99,14,0),
  (10382,33,2,60,0),
  (10382,74,8,50,0),
  (10383,13,4.8,20,0),
  (10383,50,13,15,0),
  (10383,56,30.4,20,0),
  (10384,20,64.8,28,0),
  (10384,60,27.2,15,0),
  (10385,7,24,10,0.2),
  (10385,60,27.2,20,0.2),
  (10385,68,10,8,0.2),
  (10386,24,3.6,15,0),
  (10386,34,11.2,10,0),
  (10387,24,3.6,15,0),
  (10387,28,36.4,6,0),
  (10387,59,44,12,0),
  (10387,71,17.2,15,0),
  (10388,45,7.6,15,0.2),
  (10388,52,5.6,20,0.2),
  (10388,53,26.2,40,0),
  (10389,10,24.8,16,0),
  (10389,55,19.2,15,0),
  (10389,62,39.4,20,0),
  (10389,70,12,30,0),
  (10390,31,10,60,0.1),
  (10390,35,14.4,40,0.1),
  (10390,46,9.6,45,0),
  (10390,72,27.8,24,0.1),
  (10391,13,4.8,18,0),
  (10392,69,28.8,50,0),
  (10393,2,15.2,25,0.25),
  (10393,14,18.6,42,0.25),
  (10393,25,11.2,7,0.25),
  (10393,26,24.9,70,0.25),
  (10393,31,10,32,0),
  (10394,13,4.8,10,0),
  (10394,62,39.4,10,0),
  (10395,46,9.6,28,0.1),
  (10395,53,26.2,70,0.1),
  (10395,69,28.8,8,0),
  (10396,23,7.2,40,0),
  (10396,71,17.2,60,0),
  (10396,72,27.8,21,0),
  (10397,21,8,10,0.15),
  (10397,51,42.4,18,0.15),
  (10398,35,14.4,30,0),
  (10398,55,19.2,120,0.1),
  (10399,68,10,60,0),
  (10399,71,17.2,30,0),
  (10399,76,14.4,35,0),
  (10399,77,10.4,14,0),
  (10400,29,99,21,0),
  (10400,35,14.4,35,0),
  (10400,49,16,30,0),
  (10401,30,20.7,18,0),
  (10401,56,30.4,70,0),
  (10401,65,16.8,20,0),
  (10401,71,17.2,60,0),
  (10402,23,7.2,60,0),
  (10402,63,35.1,65,0),
  (10403,16,13.9,21,0.15),
  (10403,48,10.2,70,0.15),
  (10404,26,24.9,30,0.05),
  (10404,42,11.2,40,0.05),
  (10404,49,16,30,0.05),
  (10405,3,8,50,0),
  (10406,1,14.4,10,0),
  (10406,21,8,30,0.1),
  (10406,28,36.4,42,0.1),
  (10406,36,15.2,5,0.1),
  (10406,40,14.7,2,0.1),
  (10407,11,16.8,30,0),
  (10407,69,28.8,15,0),
  (10407,71,17.2,15,0),
  (10408,37,20.8,10,0),
  (10408,54,5.9,6,0),
  (10408,62,39.4,35,0),
  (10409,14,18.6,12,0),
  (10409,21,8,12,0),
  (10410,33,2,49,0),
  (10410,59,44,16,0),
  (10411,41,7.7,25,0.2),
  (10411,44,15.5,40,0.2),
  (10411,59,44,9,0.2),
  (10412,14,18.6,20,0.1),
  (10413,1,14.4,24,0),
  (10413,62,39.4,40,0),
  (10413,76,14.4,14,0),
  (10414,19,7.3,18,0.05),
  (10414,33,2,50,0),
  (10415,17,31.2,2,0),
  (10415,33,2,20,0),
  (10416,19,7.3,20,0),
  (10416,53,26.2,10,0),
  (10416,57,15.6,20,0),
  (10417,38,210.8,50,0),
  (10417,46,9.6,2,0.25),
  (10417,68,10,36,0.25),
  (10417,77,10.4,35,0),
  (10418,2,15.2,60,0),
  (10418,47,7.6,55,0),
  (10418,61,22.8,16,0),
  (10418,74,8,15,0),
  (10419,60,27.2,60,0.05),
  (10419,69,28.8,20,0.05),
  (10420,9,77.6,20,0.1),
  (10420,13,4.8,2,0.1),
  (10420,70,12,8,0.1),
  (10420,73,12,20,0.1),
  (10421,19,7.3,4,0.15),
  (10421,26,24.9,30,0),
  (10421,53,26.2,15,0.15),
  (10421,77,10.4,10,0.15),
  (10422,26,24.9,2,0),
  (10423,31,10,14,0),
  (10423,59,44,20,0),
  (10424,35,14.4,60,0.2),
  (10424,38,210.8,49,0.2),
  (10424,68,10,30,0.2),
  (10425,55,19.2,10,0.25),
  (10425,76,14.4,20,0.25),
  (10426,56,30.4,5,0),
  (10426,64,26.6,7,0),
  (10427,14,18.6,35,0),
  (10428,46,9.6,20,0),
  (10429,50,13,40,0),
  (10429,63,35.1,35,0.25),
  (10430,17,31.2,45,0.2),
  (10430,21,8,50,0),
  (10430,56,30.4,30,0),
  (10430,59,44,70,0.2),
  (10431,17,31.2,50,0.25),
  (10431,40,14.7,50,0.25),
  (10431,47,7.6,30,0.25),
  (10432,26,24.9,10,0),
  (10432,54,5.9,40,0),
  (10433,56,30.4,28,0),
  (10434,11,16.8,6,0),
  (10434,76,14.4,18,0.15),
  (10435,2,15.2,10,0),
  (10435,22,16.8,12,0),
  (10435,72,27.8,10,0),
  (10436,46,9.6,5,0),
  (10436,56,30.4,40,0.1),
  (10436,64,26.6,30,0.1),
  (10436,75,6.2,24,0.1);

COMMIT;

#
# Data for the `Order Details` table  (LIMIT 500,500)
#

INSERT INTO `Order Details` (`OrderID`, `ProductID`, `UnitPrice`, `Quantity`, `Discount`) VALUES 
  (10437,53,26.2,15,0),
  (10438,19,7.3,15,0.2),
  (10438,34,11.2,20,0.2),
  (10438,57,15.6,15,0.2),
  (10439,12,30.4,15,0),
  (10439,16,13.9,16,0),
  (10439,64,26.6,6,0),
  (10439,74,8,30,0),
  (10440,2,15.2,45,0.15),
  (10440,16,13.9,49,0.15),
  (10440,29,99,24,0.15),
  (10440,61,22.8,90,0.15),
  (10441,27,35.1,50,0),
  (10442,11,16.8,30,0),
  (10442,54,5.9,80,0),
  (10442,66,13.6,60,0),
  (10443,11,16.8,6,0.2),
  (10443,28,36.4,12,0),
  (10444,17,31.2,10,0),
  (10444,26,24.9,15,0),
  (10444,35,14.4,8,0),
  (10444,41,7.7,30,0),
  (10445,39,14.4,6,0),
  (10445,54,5.9,15,0),
  (10446,19,7.3,12,0.1),
  (10446,24,3.6,20,0.1),
  (10446,31,10,3,0.1),
  (10446,52,5.6,15,0.1),
  (10447,19,7.3,40,0),
  (10447,65,16.8,35,0),
  (10447,71,17.2,2,0),
  (10448,26,24.9,6,0),
  (10448,40,14.7,20,0),
  (10449,10,24.8,14,0),
  (10449,52,5.6,20,0),
  (10449,62,39.4,35,0),
  (10450,10,24.8,20,0.2),
  (10450,54,5.9,6,0.2),
  (10451,55,19.2,120,0.1),
  (10451,64,26.6,35,0.1),
  (10451,65,16.8,28,0.1),
  (10451,77,10.4,55,0.1),
  (10452,28,36.4,15,0),
  (10452,44,15.5,100,0.05),
  (10453,48,10.2,15,0.1),
  (10453,70,12,25,0.1),
  (10454,16,13.9,20,0.2),
  (10454,33,2,20,0.2),
  (10454,46,9.6,10,0.2),
  (10455,39,14.4,20,0),
  (10455,53,26.2,50,0),
  (10455,61,22.8,25,0),
  (10455,71,17.2,30,0),
  (10456,21,8,40,0.15),
  (10456,49,16,21,0.15),
  (10457,59,44,36,0),
  (10458,26,24.9,30,0),
  (10458,28,36.4,30,0),
  (10458,43,36.8,20,0),
  (10458,56,30.4,15,0),
  (10458,71,17.2,50,0),
  (10459,7,24,16,0.05),
  (10459,46,9.6,20,0.05),
  (10459,72,27.8,40,0),
  (10460,68,10,21,0.25),
  (10460,75,6.2,4,0.25),
  (10461,21,8,40,0.25),
  (10461,30,20.7,28,0.25),
  (10461,55,19.2,60,0.25),
  (10462,13,4.8,1,0),
  (10462,23,7.2,21,0),
  (10463,19,7.3,21,0),
  (10463,42,11.2,50,0),
  (10464,4,17.6,16,0.2),
  (10464,43,36.8,3,0),
  (10464,56,30.4,30,0.2),
  (10464,60,27.2,20,0),
  (10465,24,3.6,25,0),
  (10465,29,99,18,0.1),
  (10465,40,14.7,20,0),
  (10465,45,7.6,30,0.1),
  (10465,50,13,25,0),
  (10466,11,16.8,10,0),
  (10466,46,9.6,5,0),
  (10467,24,3.6,28,0),
  (10467,25,11.2,12,0),
  (10468,30,20.7,8,0),
  (10468,43,36.8,15,0),
  (10469,2,15.2,40,0.15),
  (10469,16,13.9,35,0.15),
  (10469,44,15.5,2,0.15),
  (10470,18,50,30,0),
  (10470,23,7.2,15,0),
  (10470,64,26.6,8,0),
  (10471,7,24,30,0),
  (10471,56,30.4,20,0),
  (10472,24,3.6,80,0.05),
  (10472,51,42.4,18,0),
  (10473,33,2,12,0),
  (10473,71,17.2,12,0),
  (10474,14,18.6,12,0),
  (10474,28,36.4,18,0),
  (10474,40,14.7,21,0),
  (10474,75,6.2,10,0),
  (10475,31,10,35,0.15),
  (10475,66,13.6,60,0.15),
  (10475,76,14.4,42,0.15),
  (10476,55,19.2,2,0.05),
  (10476,70,12,12,0),
  (10477,1,14.4,15,0),
  (10477,21,8,21,0.25),
  (10477,39,14.4,20,0.25),
  (10478,10,24.8,20,0.05),
  (10479,38,210.8,30,0),
  (10479,53,26.2,28,0),
  (10479,59,44,60,0),
  (10479,64,26.6,30,0),
  (10480,47,7.6,30,0),
  (10480,59,44,12,0),
  (10481,49,16,24,0),
  (10481,60,27.2,40,0),
  (10482,40,14.7,10,0),
  (10483,34,11.2,35,0.05),
  (10483,77,10.4,30,0.05),
  (10484,21,8,14,0),
  (10484,40,14.7,10,0),
  (10484,51,42.4,3,0),
  (10485,2,15.2,20,0.1),
  (10485,3,8,20,0.1),
  (10485,55,19.2,30,0.1),
  (10485,70,12,60,0.1),
  (10486,11,16.8,5,0),
  (10486,51,42.4,25,0),
  (10486,74,8,16,0),
  (10487,19,7.3,5,0),
  (10487,26,24.9,30,0),
  (10487,54,5.9,24,0.25),
  (10488,59,44,30,0),
  (10488,73,12,20,0.2),
  (10489,11,16.8,15,0.25),
  (10489,16,13.9,18,0),
  (10490,59,44,60,0),
  (10490,68,10,30,0),
  (10490,75,6.2,36,0),
  (10491,44,15.5,15,0.15),
  (10491,77,10.4,7,0.15),
  (10492,25,11.2,60,0.05),
  (10492,42,11.2,20,0.05),
  (10493,65,16.8,15,0.1),
  (10493,66,13.6,10,0.1),
  (10493,69,28.8,10,0.1),
  (10494,56,30.4,30,0),
  (10495,23,7.2,10,0),
  (10495,41,7.7,20,0),
  (10495,77,10.4,5,0),
  (10496,31,10,20,0.05),
  (10497,56,30.4,14,0),
  (10497,72,27.8,25,0),
  (10497,77,10.4,25,0),
  (10498,24,4.5,14,0),
  (10498,40,18.4,5,0),
  (10498,42,14,30,0),
  (10499,28,45.6,20,0),
  (10499,49,20,25,0),
  (10500,15,15.5,12,0.05),
  (10500,28,45.6,8,0.05),
  (10501,54,7.45,20,0),
  (10502,45,9.5,21,0),
  (10502,53,32.8,6,0),
  (10502,67,14,30,0),
  (10503,14,23.25,70,0),
  (10503,65,21.05,20,0),
  (10504,2,19,12,0),
  (10504,21,10,12,0),
  (10504,53,32.8,10,0),
  (10504,61,28.5,25,0),
  (10505,62,49.3,3,0),
  (10506,25,14,18,0.1),
  (10506,70,15,14,0.1),
  (10507,43,46,15,0.15),
  (10507,48,12.75,15,0.15),
  (10508,13,6,10,0),
  (10508,39,18,10,0),
  (10509,28,45.6,3,0),
  (10510,29,123.79,36,0),
  (10510,75,7.75,36,0.1),
  (10511,4,22,50,0.15),
  (10511,7,30,50,0.15),
  (10511,8,40,10,0.15),
  (10512,24,4.5,10,0.15),
  (10512,46,12,9,0.15),
  (10512,47,9.5,6,0.15),
  (10512,60,34,12,0.15),
  (10513,21,10,40,0.2),
  (10513,32,32,50,0.2),
  (10513,61,28.5,15,0.2),
  (10514,20,81,39,0),
  (10514,28,45.6,35,0),
  (10514,56,38,70,0),
  (10514,65,21.05,39,0),
  (10514,75,7.75,50,0),
  (10515,9,97,16,0.15),
  (10515,16,17.45,50,0),
  (10515,27,43.9,120,0),
  (10515,33,2.5,16,0.15),
  (10515,60,34,84,0.15),
  (10516,18,62.5,25,0.1),
  (10516,41,9.65,80,0.1),
  (10516,42,14,20,0),
  (10517,52,7,6,0),
  (10517,59,55,4,0),
  (10517,70,15,6,0),
  (10518,24,4.5,5,0),
  (10518,38,263.5,15,0),
  (10518,44,19.45,9,0),
  (10519,10,31,16,0.05),
  (10519,56,38,40,0),
  (10519,60,34,10,0.05),
  (10520,24,4.5,8,0),
  (10520,53,32.8,5,0),
  (10521,35,18,3,0),
  (10521,41,9.65,10,0),
  (10521,68,12.5,6,0),
  (10522,1,18,40,0.2),
  (10522,8,40,24,0),
  (10522,30,25.89,20,0.2),
  (10522,40,18.4,25,0.2),
  (10523,17,39,25,0.1),
  (10523,20,81,15,0.1),
  (10523,37,26,18,0.1),
  (10523,41,9.65,6,0.1),
  (10524,10,31,2,0),
  (10524,30,25.89,10,0),
  (10524,43,46,60,0),
  (10524,54,7.45,15,0),
  (10525,36,19,30,0),
  (10525,40,18.4,15,0.1),
  (10526,1,18,8,0.15),
  (10526,13,6,10,0),
  (10526,56,38,30,0.15),
  (10527,4,22,50,0.1),
  (10527,36,19,30,0.1),
  (10528,11,21,3,0),
  (10528,33,2.5,8,0.2),
  (10528,72,34.8,9,0),
  (10529,55,24,14,0),
  (10529,68,12.5,20,0),
  (10529,69,36,10,0),
  (10530,17,39,40,0),
  (10530,43,46,25,0),
  (10530,61,28.5,20,0),
  (10530,76,18,50,0),
  (10531,59,55,2,0),
  (10532,30,25.89,15,0),
  (10532,66,17,24,0),
  (10533,4,22,50,0.05),
  (10533,72,34.8,24,0),
  (10533,73,15,24,0.05),
  (10534,30,25.89,10,0),
  (10534,40,18.4,10,0.2),
  (10534,54,7.45,10,0.2),
  (10535,11,21,50,0.1),
  (10535,40,18.4,10,0.1),
  (10535,57,19.5,5,0.1),
  (10535,59,55,15,0.1),
  (10536,12,38,15,0.25),
  (10536,31,12.5,20,0),
  (10536,33,2.5,30,0),
  (10536,60,34,35,0.25),
  (10537,31,12.5,30,0),
  (10537,51,53,6,0),
  (10537,58,13.25,20,0),
  (10537,72,34.8,21,0),
  (10537,73,15,9,0),
  (10538,70,15,7,0),
  (10538,72,34.8,1,0),
  (10539,13,6,8,0),
  (10539,21,10,15,0),
  (10539,33,2.5,15,0),
  (10539,49,20,6,0),
  (10540,3,10,60,0),
  (10540,26,31.23,40,0),
  (10540,38,263.5,30,0),
  (10540,68,12.5,35,0),
  (10541,24,4.5,35,0.1),
  (10541,38,263.5,4,0.1),
  (10541,65,21.05,36,0.1),
  (10541,71,21.5,9,0.1),
  (10542,11,21,15,0.05),
  (10542,54,7.45,24,0.05),
  (10543,12,38,30,0.15),
  (10543,23,9,70,0.15),
  (10544,28,45.6,7,0),
  (10544,67,14,7,0),
  (10545,11,21,10,0),
  (10546,7,30,10,0),
  (10546,35,18,30,0),
  (10546,62,49.3,40,0),
  (10547,32,32,24,0.15),
  (10547,36,19,60,0),
  (10548,34,14,10,0.25),
  (10548,41,9.65,14,0),
  (10549,31,12.5,55,0.15),
  (10549,45,9.5,100,0.15),
  (10549,51,53,48,0.15),
  (10550,17,39,8,0.1),
  (10550,19,9.2,10,0),
  (10550,21,10,6,0.1),
  (10550,61,28.5,10,0.1),
  (10551,16,17.45,40,0.15),
  (10551,35,18,20,0.15),
  (10551,44,19.45,40,0),
  (10552,69,36,18,0),
  (10552,75,7.75,30,0),
  (10553,11,21,15,0),
  (10553,16,17.45,14,0),
  (10553,22,21,24,0),
  (10553,31,12.5,30,0),
  (10553,35,18,6,0),
  (10554,16,17.45,30,0.05),
  (10554,23,9,20,0.05),
  (10554,62,49.3,20,0.05),
  (10554,77,13,10,0.05),
  (10555,14,23.25,30,0.2),
  (10555,19,9.2,35,0.2),
  (10555,24,4.5,18,0.2),
  (10555,51,53,20,0.2),
  (10555,56,38,40,0.2),
  (10556,72,34.8,24,0),
  (10557,64,33.25,30,0),
  (10557,75,7.75,20,0),
  (10558,47,9.5,25,0),
  (10558,51,53,20,0),
  (10558,52,7,30,0),
  (10558,53,32.8,18,0),
  (10558,73,15,3,0),
  (10559,41,9.65,12,0.05),
  (10559,55,24,18,0.05),
  (10560,30,25.89,20,0),
  (10560,62,49.3,15,0.25),
  (10561,44,19.45,10,0),
  (10561,51,53,50,0),
  (10562,33,2.5,20,0.1),
  (10562,62,49.3,10,0.1),
  (10563,36,19,25,0),
  (10563,52,7,70,0),
  (10564,17,39,16,0.05),
  (10564,31,12.5,6,0.05),
  (10564,55,24,25,0.05),
  (10565,24,4.5,25,0.1),
  (10565,64,33.25,18,0.1),
  (10566,11,21,35,0.15),
  (10566,18,62.5,18,0.15),
  (10566,76,18,10,0),
  (10567,31,12.5,60,0.2),
  (10567,51,53,3,0),
  (10567,59,55,40,0.2),
  (10568,10,31,5,0),
  (10569,31,12.5,35,0.2),
  (10569,76,18,30,0),
  (10570,11,21,15,0.05),
  (10570,56,38,60,0.05),
  (10571,14,23.25,11,0.15),
  (10571,42,14,28,0.15),
  (10572,16,17.45,12,0.1),
  (10572,32,32,10,0.1),
  (10572,40,18.4,50,0),
  (10572,75,7.75,15,0.1),
  (10573,17,39,18,0),
  (10573,34,14,40,0),
  (10573,53,32.8,25,0),
  (10574,33,2.5,14,0),
  (10574,40,18.4,2,0),
  (10574,62,49.3,10,0),
  (10574,64,33.25,6,0),
  (10575,59,55,12,0),
  (10575,63,43.9,6,0),
  (10575,72,34.8,30,0),
  (10575,76,18,10,0),
  (10576,1,18,10,0),
  (10576,31,12.5,20,0),
  (10576,44,19.45,21,0),
  (10577,39,18,10,0),
  (10577,75,7.75,20,0),
  (10577,77,13,18,0),
  (10578,35,18,20,0),
  (10578,57,19.5,6,0),
  (10579,15,15.5,10,0),
  (10579,75,7.75,21,0),
  (10580,14,23.25,15,0.05),
  (10580,41,9.65,9,0.05),
  (10580,65,21.05,30,0.05),
  (10581,75,7.75,50,0.2),
  (10582,57,19.5,4,0),
  (10582,76,18,14,0),
  (10583,29,123.79,10,0),
  (10583,60,34,24,0.15),
  (10583,69,36,10,0.15),
  (10584,31,12.5,50,0.05),
  (10585,47,9.5,15,0),
  (10586,52,7,4,0.15),
  (10587,26,31.23,6,0),
  (10587,35,18,20,0),
  (10587,77,13,20,0),
  (10588,18,62.5,40,0.2),
  (10588,42,14,100,0.2),
  (10589,35,18,4,0),
  (10590,1,18,20,0),
  (10590,77,13,60,0.05),
  (10591,3,10,14,0),
  (10591,7,30,10,0),
  (10591,54,7.45,50,0),
  (10592,15,15.5,25,0.05),
  (10592,26,31.23,5,0.05),
  (10593,20,81,21,0.2),
  (10593,69,36,20,0.2),
  (10593,76,18,4,0.2),
  (10594,52,7,24,0),
  (10594,58,13.25,30,0),
  (10595,35,18,30,0.25),
  (10595,61,28.5,120,0.25),
  (10595,69,36,65,0.25),
  (10596,56,38,5,0.2),
  (10596,63,43.9,24,0.2),
  (10596,75,7.75,30,0.2),
  (10597,24,4.5,35,0.2),
  (10597,57,19.5,20,0),
  (10597,65,21.05,12,0.2),
  (10598,27,43.9,50,0),
  (10598,71,21.5,9,0),
  (10599,62,49.3,10,0),
  (10600,54,7.45,4,0),
  (10600,73,15,30,0),
  (10601,13,6,60,0),
  (10601,59,55,35,0),
  (10602,77,13,5,0.25),
  (10603,22,21,48,0),
  (10603,49,20,25,0.05),
  (10604,48,12.75,6,0.1),
  (10604,76,18,10,0.1),
  (10605,16,17.45,30,0.05),
  (10605,59,55,20,0.05),
  (10605,60,34,70,0.05),
  (10605,71,21.5,15,0.05),
  (10606,4,22,20,0.2),
  (10606,55,24,20,0.2),
  (10606,62,49.3,10,0.2),
  (10607,7,30,45,0),
  (10607,17,39,100,0),
  (10607,33,2.5,14,0),
  (10607,40,18.4,42,0),
  (10607,72,34.8,12,0),
  (10608,56,38,28,0),
  (10609,1,18,3,0),
  (10609,10,31,10,0),
  (10609,21,10,6,0),
  (10610,36,19,21,0.25),
  (10611,1,18,6,0),
  (10611,2,19,10,0),
  (10611,60,34,15,0),
  (10612,10,31,70,0),
  (10612,36,19,55,0),
  (10612,49,20,18,0),
  (10612,60,34,40,0),
  (10612,76,18,80,0),
  (10613,13,6,8,0.1),
  (10613,75,7.75,40,0),
  (10614,11,21,14,0),
  (10614,21,10,8,0),
  (10614,39,18,5,0),
  (10615,55,24,5,0),
  (10616,38,263.5,15,0.05),
  (10616,56,38,14,0),
  (10616,70,15,15,0.05),
  (10616,71,21.5,15,0.05),
  (10617,59,55,30,0.15),
  (10618,6,25,70,0),
  (10618,56,38,20,0),
  (10618,68,12.5,15,0),
  (10619,21,10,42,0),
  (10619,22,21,40,0),
  (10620,24,4.5,5,0),
  (10620,52,7,5,0),
  (10621,19,9.2,5,0),
  (10621,23,9,10,0),
  (10621,70,15,20,0),
  (10621,71,21.5,15,0),
  (10622,2,19,20,0),
  (10622,68,12.5,18,0.2),
  (10623,14,23.25,21,0),
  (10623,19,9.2,15,0.1),
  (10623,21,10,25,0.1),
  (10623,24,4.5,3,0),
  (10623,35,18,30,0.1),
  (10624,28,45.6,10,0),
  (10624,29,123.79,6,0),
  (10624,44,19.45,10,0),
  (10625,14,23.25,3,0),
  (10625,42,14,5,0),
  (10625,60,34,10,0);

COMMIT;

#
# Data for the `Order Details` table  (LIMIT 1000,500)
#

INSERT INTO `Order Details` (`OrderID`, `ProductID`, `UnitPrice`, `Quantity`, `Discount`) VALUES 
  (10626,53,32.8,12,0),
  (10626,60,34,20,0),
  (10626,71,21.5,20,0),
  (10627,62,49.3,15,0),
  (10627,73,15,35,0.15),
  (10628,1,18,25,0),
  (10629,29,123.79,20,0),
  (10629,64,33.25,9,0),
  (10630,55,24,12,0.05),
  (10630,76,18,35,0),
  (10631,75,7.75,8,0.1),
  (10632,2,19,30,0.05),
  (10632,33,2.5,20,0.05),
  (10633,12,38,36,0.15),
  (10633,13,6,13,0.15),
  (10633,26,31.23,35,0.15),
  (10633,62,49.3,80,0.15),
  (10634,7,30,35,0),
  (10634,18,62.5,50,0),
  (10634,51,53,15,0),
  (10634,75,7.75,2,0),
  (10635,4,22,10,0.1),
  (10635,5,21.35,15,0.1),
  (10635,22,21,40,0),
  (10636,4,22,25,0),
  (10636,58,13.25,6,0),
  (10637,11,21,10,0),
  (10637,50,16.25,25,0.05),
  (10637,56,38,60,0.05),
  (10638,45,9.5,20,0),
  (10638,65,21.05,21,0),
  (10638,72,34.8,60,0),
  (10639,18,62.5,8,0),
  (10640,69,36,20,0.25),
  (10640,70,15,15,0.25),
  (10641,2,19,50,0),
  (10641,40,18.4,60,0),
  (10642,21,10,30,0.2),
  (10642,61,28.5,20,0.2),
  (10643,28,45.6,15,0.25),
  (10643,39,18,21,0.25),
  (10643,46,12,2,0.25),
  (10644,18,62.5,4,0.1),
  (10644,43,46,20,0),
  (10644,46,12,21,0.1),
  (10645,18,62.5,20,0),
  (10645,36,19,15,0),
  (10646,1,18,15,0.25),
  (10646,10,31,18,0.25),
  (10646,71,21.5,30,0.25),
  (10646,77,13,35,0.25),
  (10647,19,9.2,30,0),
  (10647,39,18,20,0),
  (10648,22,21,15,0),
  (10648,24,4.5,15,0.15),
  (10649,28,45.6,20,0),
  (10649,72,34.8,15,0),
  (10650,30,25.89,30,0),
  (10650,53,32.8,25,0.05),
  (10650,54,7.45,30,0),
  (10651,19,9.2,12,0.25),
  (10651,22,21,20,0.25),
  (10652,30,25.89,2,0.25),
  (10652,42,14,20,0),
  (10653,16,17.45,30,0.1),
  (10653,60,34,20,0.1),
  (10654,4,22,12,0.1),
  (10654,39,18,20,0.1),
  (10654,54,7.45,6,0.1),
  (10655,41,9.65,20,0.2),
  (10656,14,23.25,3,0.1),
  (10656,44,19.45,28,0.1),
  (10656,47,9.5,6,0.1),
  (10657,15,15.5,50,0),
  (10657,41,9.65,24,0),
  (10657,46,12,45,0),
  (10657,47,9.5,10,0),
  (10657,56,38,45,0),
  (10657,60,34,30,0),
  (10658,21,10,60,0),
  (10658,40,18.4,70,0.05),
  (10658,60,34,55,0.05),
  (10658,77,13,70,0.05),
  (10659,31,12.5,20,0.05),
  (10659,40,18.4,24,0.05),
  (10659,70,15,40,0.05),
  (10660,20,81,21,0),
  (10661,39,18,3,0.2),
  (10661,58,13.25,49,0.2),
  (10662,68,12.5,10,0),
  (10663,40,18.4,30,0.05),
  (10663,42,14,30,0.05),
  (10663,51,53,20,0.05),
  (10664,10,31,24,0.15),
  (10664,56,38,12,0.15),
  (10664,65,21.05,15,0.15),
  (10665,51,53,20,0),
  (10665,59,55,1,0),
  (10665,76,18,10,0),
  (10666,29,123.79,36,0),
  (10666,65,21.05,10,0),
  (10667,69,36,45,0.2),
  (10667,71,21.5,14,0.2),
  (10668,31,12.5,8,0.1),
  (10668,55,24,4,0.1),
  (10668,64,33.25,15,0.1),
  (10669,36,19,30,0),
  (10670,23,9,32,0),
  (10670,46,12,60,0),
  (10670,67,14,25,0),
  (10670,73,15,50,0),
  (10670,75,7.75,25,0),
  (10671,16,17.45,10,0),
  (10671,62,49.3,10,0),
  (10671,65,21.05,12,0),
  (10672,38,263.5,15,0.1),
  (10672,71,21.5,12,0),
  (10673,16,17.45,3,0),
  (10673,42,14,6,0),
  (10673,43,46,6,0),
  (10674,23,9,5,0),
  (10675,14,23.25,30,0),
  (10675,53,32.8,10,0),
  (10675,58,13.25,30,0),
  (10676,10,31,2,0),
  (10676,19,9.2,7,0),
  (10676,44,19.45,21,0),
  (10677,26,31.23,30,0.15),
  (10677,33,2.5,8,0.15),
  (10678,12,38,100,0),
  (10678,33,2.5,30,0),
  (10678,41,9.65,120,0),
  (10678,54,7.45,30,0),
  (10679,59,55,12,0),
  (10680,16,17.45,50,0.25),
  (10680,31,12.5,20,0.25),
  (10680,42,14,40,0.25),
  (10681,19,9.2,30,0.1),
  (10681,21,10,12,0.1),
  (10681,64,33.25,28,0),
  (10682,33,2.5,30,0),
  (10682,66,17,4,0),
  (10682,75,7.75,30,0),
  (10683,52,7,9,0),
  (10684,40,18.4,20,0),
  (10684,47,9.5,40,0),
  (10684,60,34,30,0),
  (10685,10,31,20,0),
  (10685,41,9.65,4,0),
  (10685,47,9.5,15,0),
  (10686,17,39,30,0.2),
  (10686,26,31.23,15,0),
  (10687,9,97,50,0.25),
  (10687,29,123.79,10,0),
  (10687,36,19,6,0.25),
  (10688,10,31,18,0.1),
  (10688,28,45.6,60,0.1),
  (10688,34,14,14,0),
  (10689,1,18,35,0.25),
  (10690,56,38,20,0.25),
  (10690,77,13,30,0.25),
  (10691,1,18,30,0),
  (10691,29,123.79,40,0),
  (10691,43,46,40,0),
  (10691,44,19.45,24,0),
  (10691,62,49.3,48,0),
  (10692,63,43.9,20,0),
  (10693,9,97,6,0),
  (10693,54,7.45,60,0.15),
  (10693,69,36,30,0.15),
  (10693,73,15,15,0.15),
  (10694,7,30,90,0),
  (10694,59,55,25,0),
  (10694,70,15,50,0),
  (10695,8,40,10,0),
  (10695,12,38,4,0),
  (10695,24,4.5,20,0),
  (10696,17,39,20,0),
  (10696,46,12,18,0),
  (10697,19,9.2,7,0.25),
  (10697,35,18,9,0.25),
  (10697,58,13.25,30,0.25),
  (10697,70,15,30,0.25),
  (10698,11,21,15,0),
  (10698,17,39,8,0.05),
  (10698,29,123.79,12,0.05),
  (10698,65,21.05,65,0.05),
  (10698,70,15,8,0.05),
  (10699,47,9.5,12,0),
  (10700,1,18,5,0.2),
  (10700,34,14,12,0.2),
  (10700,68,12.5,40,0.2),
  (10700,71,21.5,60,0.2),
  (10701,59,55,42,0.15),
  (10701,71,21.5,20,0.15),
  (10701,76,18,35,0.15),
  (10702,3,10,6,0),
  (10702,76,18,15,0),
  (10703,2,19,5,0),
  (10703,59,55,35,0),
  (10703,73,15,35,0),
  (10704,4,22,6,0),
  (10704,24,4.5,35,0),
  (10704,48,12.75,24,0),
  (10705,31,12.5,20,0),
  (10705,32,32,4,0),
  (10706,16,17.45,20,0),
  (10706,43,46,24,0),
  (10706,59,55,8,0),
  (10707,55,24,21,0),
  (10707,57,19.5,40,0),
  (10707,70,15,28,0.15),
  (10708,5,21.35,4,0),
  (10708,36,19,5,0),
  (10709,8,40,40,0),
  (10709,51,53,28,0),
  (10709,60,34,10,0),
  (10710,19,9.2,5,0),
  (10710,47,9.5,5,0),
  (10711,19,9.2,12,0),
  (10711,41,9.65,42,0),
  (10711,53,32.8,120,0),
  (10712,53,32.8,3,0.05),
  (10712,56,38,30,0),
  (10713,10,31,18,0),
  (10713,26,31.23,30,0),
  (10713,45,9.5,110,0),
  (10713,46,12,24,0),
  (10714,2,19,30,0.25),
  (10714,17,39,27,0.25),
  (10714,47,9.5,50,0.25),
  (10714,56,38,18,0.25),
  (10714,58,13.25,12,0.25),
  (10715,10,31,21,0),
  (10715,71,21.5,30,0),
  (10716,21,10,5,0),
  (10716,51,53,7,0),
  (10716,61,28.5,10,0),
  (10717,21,10,32,0.05),
  (10717,54,7.45,15,0),
  (10717,69,36,25,0.05),
  (10718,12,38,36,0),
  (10718,16,17.45,20,0),
  (10718,36,19,40,0),
  (10718,62,49.3,20,0),
  (10719,18,62.5,12,0.25),
  (10719,30,25.89,3,0.25),
  (10719,54,7.45,40,0.25),
  (10720,35,18,21,0),
  (10720,71,21.5,8,0),
  (10721,44,19.45,50,0.05),
  (10722,2,19,3,0),
  (10722,31,12.5,50,0),
  (10722,68,12.5,45,0),
  (10722,75,7.75,42,0),
  (10723,26,31.23,15,0),
  (10724,10,31,16,0),
  (10724,61,28.5,5,0),
  (10725,41,9.65,12,0),
  (10725,52,7,4,0),
  (10725,55,24,6,0),
  (10726,4,22,25,0),
  (10726,11,21,5,0),
  (10727,17,39,20,0.05),
  (10727,56,38,10,0.05),
  (10727,59,55,10,0.05),
  (10728,30,25.89,15,0),
  (10728,40,18.4,6,0),
  (10728,55,24,12,0),
  (10728,60,34,15,0),
  (10729,1,18,50,0),
  (10729,21,10,30,0),
  (10729,50,16.25,40,0),
  (10730,16,17.45,15,0.05),
  (10730,31,12.5,3,0.05),
  (10730,65,21.05,10,0.05),
  (10731,21,10,40,0.05),
  (10731,51,53,30,0.05),
  (10732,76,18,20,0),
  (10733,14,23.25,16,0),
  (10733,28,45.6,20,0),
  (10733,52,7,25,0),
  (10734,6,25,30,0),
  (10734,30,25.89,15,0),
  (10734,76,18,20,0),
  (10735,61,28.5,20,0.1),
  (10735,77,13,2,0.1),
  (10736,65,21.05,40,0),
  (10736,75,7.75,20,0),
  (10737,13,6,4,0),
  (10737,41,9.65,12,0),
  (10738,16,17.45,3,0),
  (10739,36,19,6,0),
  (10739,52,7,18,0),
  (10740,28,45.6,5,0.2),
  (10740,35,18,35,0.2),
  (10740,45,9.5,40,0.2),
  (10740,56,38,14,0.2),
  (10741,2,19,15,0.2),
  (10742,3,10,20,0),
  (10742,60,34,50,0),
  (10742,72,34.8,35,0),
  (10743,46,12,28,0.05),
  (10744,40,18.4,50,0.2),
  (10745,18,62.5,24,0),
  (10745,44,19.45,16,0),
  (10745,59,55,45,0),
  (10745,72,34.8,7,0),
  (10746,13,6,6,0),
  (10746,42,14,28,0),
  (10746,62,49.3,9,0),
  (10746,69,36,40,0),
  (10747,31,12.5,8,0),
  (10747,41,9.65,35,0),
  (10747,63,43.9,9,0),
  (10747,69,36,30,0),
  (10748,23,9,44,0),
  (10748,40,18.4,40,0),
  (10748,56,38,28,0),
  (10749,56,38,15,0),
  (10749,59,55,6,0),
  (10749,76,18,10,0),
  (10750,14,23.25,5,0.15),
  (10750,45,9.5,40,0.15),
  (10750,59,55,25,0.15),
  (10751,26,31.23,12,0.1),
  (10751,30,25.89,30,0),
  (10751,50,16.25,20,0.1),
  (10751,73,15,15,0),
  (10752,1,18,8,0),
  (10752,69,36,3,0),
  (10753,45,9.5,4,0),
  (10753,74,10,5,0),
  (10754,40,18.4,3,0),
  (10755,47,9.5,30,0.25),
  (10755,56,38,30,0.25),
  (10755,57,19.5,14,0.25),
  (10755,69,36,25,0.25),
  (10756,18,62.5,21,0.2),
  (10756,36,19,20,0.2),
  (10756,68,12.5,6,0.2),
  (10756,69,36,20,0.2),
  (10757,34,14,30,0),
  (10757,59,55,7,0),
  (10757,62,49.3,30,0),
  (10757,64,33.25,24,0),
  (10758,26,31.23,20,0),
  (10758,52,7,60,0),
  (10758,70,15,40,0),
  (10759,32,32,10,0),
  (10760,25,14,12,0.25),
  (10760,27,43.9,40,0),
  (10760,43,46,30,0.25),
  (10761,25,14,35,0.25),
  (10761,75,7.75,18,0),
  (10762,39,18,16,0),
  (10762,47,9.5,30,0),
  (10762,51,53,28,0),
  (10762,56,38,60,0),
  (10763,21,10,40,0),
  (10763,22,21,6,0),
  (10763,24,4.5,20,0),
  (10764,3,10,20,0.1),
  (10764,39,18,130,0.1),
  (10765,65,21.05,80,0.1),
  (10766,2,19,40,0),
  (10766,7,30,35,0),
  (10766,68,12.5,40,0),
  (10767,42,14,2,0),
  (10768,22,21,4,0),
  (10768,31,12.5,50,0),
  (10768,60,34,15,0),
  (10768,71,21.5,12,0),
  (10769,41,9.65,30,0.05),
  (10769,52,7,15,0.05),
  (10769,61,28.5,20,0),
  (10769,62,49.3,15,0),
  (10770,11,21,15,0.25),
  (10771,71,21.5,16,0),
  (10772,29,123.79,18,0),
  (10772,59,55,25,0),
  (10773,17,39,33,0),
  (10773,31,12.5,70,0.2),
  (10773,75,7.75,7,0.2),
  (10774,31,12.5,2,0.25),
  (10774,66,17,50,0),
  (10775,10,31,6,0),
  (10775,67,14,3,0),
  (10776,31,12.5,16,0.05),
  (10776,42,14,12,0.05),
  (10776,45,9.5,27,0.05),
  (10776,51,53,120,0.05),
  (10777,42,14,20,0.2),
  (10778,41,9.65,10,0),
  (10779,16,17.45,20,0),
  (10779,62,49.3,20,0),
  (10780,70,15,35,0),
  (10780,77,13,15,0),
  (10781,54,7.45,3,0.2),
  (10781,56,38,20,0.2),
  (10781,74,10,35,0),
  (10782,31,12.5,1,0),
  (10783,31,12.5,10,0),
  (10783,38,263.5,5,0),
  (10784,36,19,30,0),
  (10784,39,18,2,0.15),
  (10784,72,34.8,30,0.15),
  (10785,10,31,10,0),
  (10785,75,7.75,10,0),
  (10786,8,40,30,0.2),
  (10786,30,25.89,15,0.2),
  (10786,75,7.75,42,0.2),
  (10787,2,19,15,0.05),
  (10787,29,123.79,20,0.05),
  (10788,19,9.2,50,0.05),
  (10788,75,7.75,40,0.05),
  (10789,18,62.5,30,0),
  (10789,35,18,15,0),
  (10789,63,43.9,30,0),
  (10789,68,12.5,18,0),
  (10790,7,30,3,0.15),
  (10790,56,38,20,0.15),
  (10791,29,123.79,14,0.05),
  (10791,41,9.65,20,0.05),
  (10792,2,19,10,0),
  (10792,54,7.45,3,0),
  (10792,68,12.5,15,0),
  (10793,41,9.65,14,0),
  (10793,52,7,8,0),
  (10794,14,23.25,15,0.2),
  (10794,54,7.45,6,0.2),
  (10795,16,17.45,65,0),
  (10795,17,39,35,0.25),
  (10796,26,31.23,21,0.2),
  (10796,44,19.45,10,0),
  (10796,64,33.25,35,0.2),
  (10796,69,36,24,0.2),
  (10797,11,21,20,0),
  (10798,62,49.3,2,0),
  (10798,72,34.8,10,0),
  (10799,13,6,20,0.15),
  (10799,24,4.5,20,0.15),
  (10799,59,55,25,0),
  (10800,11,21,50,0.1),
  (10800,51,53,10,0.1),
  (10800,54,7.45,7,0.1),
  (10801,17,39,40,0.25),
  (10801,29,123.79,20,0.25),
  (10802,30,25.89,25,0.25),
  (10802,51,53,30,0.25),
  (10802,55,24,60,0.25),
  (10802,62,49.3,5,0.25),
  (10803,19,9.2,24,0.05),
  (10803,25,14,15,0.05),
  (10803,59,55,15,0.05),
  (10804,10,31,36,0),
  (10804,28,45.6,24,0),
  (10804,49,20,4,0.15),
  (10805,34,14,10,0),
  (10805,38,263.5,10,0),
  (10806,2,19,20,0.25),
  (10806,65,21.05,2,0),
  (10806,74,10,15,0.25),
  (10807,40,18.4,1,0),
  (10808,56,38,20,0.15),
  (10808,76,18,50,0.15),
  (10809,52,7,20,0),
  (10810,13,6,7,0),
  (10810,25,14,5,0),
  (10810,70,15,5,0),
  (10811,19,9.2,15,0),
  (10811,23,9,18,0),
  (10811,40,18.4,30,0),
  (10812,31,12.5,16,0.1),
  (10812,72,34.8,40,0.1),
  (10812,77,13,20,0),
  (10813,2,19,12,0.2),
  (10813,46,12,35,0),
  (10814,41,9.65,20,0),
  (10814,43,46,20,0.15),
  (10814,48,12.75,8,0.15),
  (10814,61,28.5,30,0.15),
  (10815,33,2.5,16,0),
  (10816,38,263.5,30,0.05),
  (10816,62,49.3,20,0.05),
  (10817,26,31.23,40,0.15),
  (10817,38,263.5,30,0),
  (10817,40,18.4,60,0.15),
  (10817,62,49.3,25,0.15),
  (10818,32,32,20,0),
  (10818,41,9.65,20,0),
  (10819,43,46,7,0),
  (10819,75,7.75,20,0),
  (10820,56,38,30,0),
  (10821,35,18,20,0),
  (10821,51,53,6,0),
  (10822,62,49.3,3,0),
  (10822,70,15,6,0),
  (10823,11,21,20,0.1),
  (10823,57,19.5,15,0);

COMMIT;

#
# Data for the `Order Details` table  (LIMIT 1500,500)
#

INSERT INTO `Order Details` (`OrderID`, `ProductID`, `UnitPrice`, `Quantity`, `Discount`) VALUES 
  (10823,59,55,40,0.1),
  (10823,77,13,15,0.1),
  (10824,41,9.65,12,0),
  (10824,70,15,9,0),
  (10825,26,31.23,12,0),
  (10825,53,32.8,20,0),
  (10826,31,12.5,35,0),
  (10826,57,19.5,15,0),
  (10827,10,31,15,0),
  (10827,39,18,21,0),
  (10828,20,81,5,0),
  (10828,38,263.5,2,0),
  (10829,2,19,10,0),
  (10829,8,40,20,0),
  (10829,13,6,10,0),
  (10829,60,34,21,0),
  (10830,6,25,6,0),
  (10830,39,18,28,0),
  (10830,60,34,30,0),
  (10830,68,12.5,24,0),
  (10831,19,9.2,2,0),
  (10831,35,18,8,0),
  (10831,38,263.5,8,0),
  (10831,43,46,9,0),
  (10832,13,6,3,0.2),
  (10832,25,14,10,0.2),
  (10832,44,19.45,16,0.2),
  (10832,64,33.25,3,0),
  (10833,7,30,20,0.1),
  (10833,31,12.5,9,0.1),
  (10833,53,32.8,9,0.1),
  (10834,29,123.79,8,0.05),
  (10834,30,25.89,20,0.05),
  (10835,59,55,15,0),
  (10835,77,13,2,0.2),
  (10836,22,21,52,0),
  (10836,35,18,6,0),
  (10836,57,19.5,24,0),
  (10836,60,34,60,0),
  (10836,64,33.25,30,0),
  (10837,13,6,6,0),
  (10837,40,18.4,25,0),
  (10837,47,9.5,40,0.25),
  (10837,76,18,21,0.25),
  (10838,1,18,4,0.25),
  (10838,18,62.5,25,0.25),
  (10838,36,19,50,0.25),
  (10839,58,13.25,30,0.1),
  (10839,72,34.8,15,0.1),
  (10840,25,14,6,0.2),
  (10840,39,18,10,0.2),
  (10841,10,31,16,0),
  (10841,56,38,30,0),
  (10841,59,55,50,0),
  (10841,77,13,15,0),
  (10842,11,21,15,0),
  (10842,43,46,5,0),
  (10842,68,12.5,20,0),
  (10842,70,15,12,0),
  (10843,51,53,4,0.25),
  (10844,22,21,35,0),
  (10845,23,9,70,0.1),
  (10845,35,18,25,0.1),
  (10845,42,14,42,0.1),
  (10845,58,13.25,60,0.1),
  (10845,64,33.25,48,0),
  (10846,4,22,21,0),
  (10846,70,15,30,0),
  (10846,74,10,20,0),
  (10847,1,18,80,0.2),
  (10847,19,9.2,12,0.2),
  (10847,37,26,60,0.2),
  (10847,45,9.5,36,0.2),
  (10847,60,34,45,0.2),
  (10847,71,21.5,55,0.2),
  (10848,5,21.35,30,0),
  (10848,9,97,3,0),
  (10849,3,10,49,0),
  (10849,26,31.23,18,0.15),
  (10850,25,14,20,0.15),
  (10850,33,2.5,4,0.15),
  (10850,70,15,30,0.15),
  (10851,2,19,5,0.05),
  (10851,25,14,10,0.05),
  (10851,57,19.5,10,0.05),
  (10851,59,55,42,0.05),
  (10852,2,19,15,0),
  (10852,17,39,6,0),
  (10852,62,49.3,50,0),
  (10853,18,62.5,10,0),
  (10854,10,31,100,0.15),
  (10854,13,6,65,0.15),
  (10855,16,17.45,50,0),
  (10855,31,12.5,14,0),
  (10855,56,38,24,0),
  (10855,65,21.05,15,0.15),
  (10856,2,19,20,0),
  (10856,42,14,20,0),
  (10857,3,10,30,0),
  (10857,26,31.23,35,0.25),
  (10857,29,123.79,10,0.25),
  (10858,7,30,5,0),
  (10858,27,43.9,10,0),
  (10858,70,15,4,0),
  (10859,24,4.5,40,0.25),
  (10859,54,7.45,35,0.25),
  (10859,64,33.25,30,0.25),
  (10860,51,53,3,0),
  (10860,76,18,20,0),
  (10861,17,39,42,0),
  (10861,18,62.5,20,0),
  (10861,21,10,40,0),
  (10861,33,2.5,35,0),
  (10861,62,49.3,3,0),
  (10862,11,21,25,0),
  (10862,52,7,8,0),
  (10863,1,18,20,0.15),
  (10863,58,13.25,12,0.15),
  (10864,35,18,4,0),
  (10864,67,14,15,0),
  (10865,38,263.5,60,0.05),
  (10865,39,18,80,0.05),
  (10866,2,19,21,0.25),
  (10866,24,4.5,6,0.25),
  (10866,30,25.89,40,0.25),
  (10867,53,32.8,3,0),
  (10868,26,31.23,20,0),
  (10868,35,18,30,0),
  (10868,49,20,42,0.1),
  (10869,1,18,40,0),
  (10869,11,21,10,0),
  (10869,23,9,50,0),
  (10869,68,12.5,20,0),
  (10870,35,18,3,0),
  (10870,51,53,2,0),
  (10871,6,25,50,0.05),
  (10871,16,17.45,12,0.05),
  (10871,17,39,16,0.05),
  (10872,55,24,10,0.05),
  (10872,62,49.3,20,0.05),
  (10872,64,33.25,15,0.05),
  (10872,65,21.05,21,0.05),
  (10873,21,10,20,0),
  (10873,28,45.6,3,0),
  (10874,10,31,10,0),
  (10875,19,9.2,25,0),
  (10875,47,9.5,21,0.1),
  (10875,49,20,15,0),
  (10876,46,12,21,0),
  (10876,64,33.25,20,0),
  (10877,16,17.45,30,0.25),
  (10877,18,62.5,25,0),
  (10878,20,81,20,0.05),
  (10879,40,18.4,12,0),
  (10879,65,21.05,10,0),
  (10879,76,18,10,0),
  (10880,23,9,30,0.2),
  (10880,61,28.5,30,0.2),
  (10880,70,15,50,0.2),
  (10881,73,15,10,0),
  (10882,42,14,25,0),
  (10882,49,20,20,0.15),
  (10882,54,7.45,32,0.15),
  (10883,24,4.5,8,0),
  (10884,21,10,40,0.05),
  (10884,56,38,21,0.05),
  (10884,65,21.05,12,0.05),
  (10885,2,19,20,0),
  (10885,24,4.5,12,0),
  (10885,70,15,30,0),
  (10885,77,13,25,0),
  (10886,10,31,70,0),
  (10886,31,12.5,35,0),
  (10886,77,13,40,0),
  (10887,25,14,5,0),
  (10888,2,19,20,0),
  (10888,68,12.5,18,0),
  (10889,11,21,40,0),
  (10889,38,263.5,40,0),
  (10890,17,39,15,0),
  (10890,34,14,10,0),
  (10890,41,9.65,14,0),
  (10891,30,25.89,15,0.05),
  (10892,59,55,40,0.05),
  (10893,8,40,30,0),
  (10893,24,4.5,10,0),
  (10893,29,123.79,24,0),
  (10893,30,25.89,35,0),
  (10893,36,19,20,0),
  (10894,13,6,28,0.05),
  (10894,69,36,50,0.05),
  (10894,75,7.75,120,0.05),
  (10895,24,4.5,110,0),
  (10895,39,18,45,0),
  (10895,40,18.4,91,0),
  (10895,60,34,100,0),
  (10896,45,9.5,15,0),
  (10896,56,38,16,0),
  (10897,29,123.79,80,0),
  (10897,30,25.89,36,0),
  (10898,13,6,5,0),
  (10899,39,18,8,0.15),
  (10900,70,15,3,0.25),
  (10901,41,9.65,30,0),
  (10901,71,21.5,30,0),
  (10902,55,24,30,0.15),
  (10902,62,49.3,6,0.15),
  (10903,13,6,40,0),
  (10903,65,21.05,21,0),
  (10903,68,12.5,20,0),
  (10904,58,13.25,15,0),
  (10904,62,49.3,35,0),
  (10905,1,18,20,0.05),
  (10906,61,28.5,15,0),
  (10907,75,7.75,14,0),
  (10908,7,30,20,0.05),
  (10908,52,7,14,0.05),
  (10909,7,30,12,0),
  (10909,16,17.45,15,0),
  (10909,41,9.65,5,0),
  (10910,19,9.2,12,0),
  (10910,49,20,10,0),
  (10910,61,28.5,5,0),
  (10911,1,18,10,0),
  (10911,17,39,12,0),
  (10911,67,14,15,0),
  (10912,11,21,40,0.25),
  (10912,29,123.79,60,0.25),
  (10913,4,22,30,0.25),
  (10913,33,2.5,40,0.25),
  (10913,58,13.25,15,0),
  (10914,71,21.5,25,0),
  (10915,17,39,10,0),
  (10915,33,2.5,30,0),
  (10915,54,7.45,10,0),
  (10916,16,17.45,6,0),
  (10916,32,32,6,0),
  (10916,57,19.5,20,0),
  (10917,30,25.89,1,0),
  (10917,60,34,10,0),
  (10918,1,18,60,0.25),
  (10918,60,34,25,0.25),
  (10919,16,17.45,24,0),
  (10919,25,14,24,0),
  (10919,40,18.4,20,0),
  (10920,50,16.25,24,0),
  (10921,35,18,10,0),
  (10921,63,43.9,40,0),
  (10922,17,39,15,0),
  (10922,24,4.5,35,0),
  (10923,42,14,10,0.2),
  (10923,43,46,10,0.2),
  (10923,67,14,24,0.2),
  (10924,10,31,20,0.1),
  (10924,28,45.6,30,0.1),
  (10924,75,7.75,6,0),
  (10925,36,19,25,0.15),
  (10925,52,7,12,0.15),
  (10926,11,21,2,0),
  (10926,13,6,10,0),
  (10926,19,9.2,7,0),
  (10926,72,34.8,10,0),
  (10927,20,81,5,0),
  (10927,52,7,5,0),
  (10927,76,18,20,0),
  (10928,47,9.5,5,0),
  (10928,76,18,5,0),
  (10929,21,10,60,0),
  (10929,75,7.75,49,0),
  (10929,77,13,15,0),
  (10930,21,10,36,0),
  (10930,27,43.9,25,0),
  (10930,55,24,25,0.2),
  (10930,58,13.25,30,0.2),
  (10931,13,6,42,0.15),
  (10931,57,19.5,30,0),
  (10932,16,17.45,30,0.1),
  (10932,62,49.3,14,0.1),
  (10932,72,34.8,16,0),
  (10932,75,7.75,20,0.1),
  (10933,53,32.8,2,0),
  (10933,61,28.5,30,0),
  (10934,6,25,20,0),
  (10935,1,18,21,0),
  (10935,18,62.5,4,0.25),
  (10935,23,9,8,0.25),
  (10936,36,19,30,0.2),
  (10937,28,45.6,8,0),
  (10937,34,14,20,0),
  (10938,13,6,20,0.25),
  (10938,43,46,24,0.25),
  (10938,60,34,49,0.25),
  (10938,71,21.5,35,0.25),
  (10939,2,19,10,0.15),
  (10939,67,14,40,0.15),
  (10940,7,30,8,0),
  (10940,13,6,20,0),
  (10941,31,12.5,44,0.25),
  (10941,62,49.3,30,0.25),
  (10941,68,12.5,80,0.25),
  (10941,72,34.8,50,0),
  (10942,49,20,28,0),
  (10943,13,6,15,0),
  (10943,22,21,21,0),
  (10943,46,12,15,0),
  (10944,11,21,5,0.25),
  (10944,44,19.45,18,0.25),
  (10944,56,38,18,0),
  (10945,13,6,20,0),
  (10945,31,12.5,10,0),
  (10946,10,31,25,0),
  (10946,24,4.5,25,0),
  (10946,77,13,40,0),
  (10947,59,55,4,0),
  (10948,50,16.25,9,0),
  (10948,51,53,40,0),
  (10948,55,24,4,0),
  (10949,6,25,12,0),
  (10949,10,31,30,0),
  (10949,17,39,6,0),
  (10949,62,49.3,60,0),
  (10950,4,22,5,0),
  (10951,33,2.5,15,0.05),
  (10951,41,9.65,6,0.05),
  (10951,75,7.75,50,0.05),
  (10952,6,25,16,0.05),
  (10952,28,45.6,2,0),
  (10953,20,81,50,0.05),
  (10953,31,12.5,50,0.05),
  (10954,16,17.45,28,0.15),
  (10954,31,12.5,25,0.15),
  (10954,45,9.5,30,0),
  (10954,60,34,24,0.15),
  (10955,75,7.75,12,0.2),
  (10956,21,10,12,0),
  (10956,47,9.5,14,0),
  (10956,51,53,8,0),
  (10957,30,25.89,30,0),
  (10957,35,18,40,0),
  (10957,64,33.25,8,0),
  (10958,5,21.35,20,0),
  (10958,7,30,6,0),
  (10958,72,34.8,5,0),
  (10959,75,7.75,20,0.15),
  (10960,24,4.5,10,0.25),
  (10960,41,9.65,24,0),
  (10961,52,7,6,0.05),
  (10961,76,18,60,0),
  (10962,7,30,45,0),
  (10962,13,6,77,0),
  (10962,53,32.8,20,0),
  (10962,69,36,9,0),
  (10962,76,18,44,0),
  (10963,60,34,2,0.15),
  (10964,18,62.5,6,0),
  (10964,38,263.5,5,0),
  (10964,69,36,10,0),
  (10965,51,53,16,0),
  (10966,37,26,8,0),
  (10966,56,38,12,0.15),
  (10966,62,49.3,12,0.15),
  (10967,19,9.2,12,0),
  (10967,49,20,40,0),
  (10968,12,38,30,0),
  (10968,24,4.5,30,0),
  (10968,64,33.25,4,0),
  (10969,46,12,9,0),
  (10970,52,7,40,0.2),
  (10971,29,123.79,14,0),
  (10972,17,39,6,0),
  (10972,33,2.5,7,0),
  (10973,26,31.23,5,0),
  (10973,41,9.65,6,0),
  (10973,75,7.75,10,0),
  (10974,63,43.9,10,0),
  (10975,8,40,16,0),
  (10975,75,7.75,10,0),
  (10976,28,45.6,20,0),
  (10977,39,18,30,0),
  (10977,47,9.5,30,0),
  (10977,51,53,10,0),
  (10977,63,43.9,20,0),
  (10978,8,40,20,0.15),
  (10978,21,10,40,0.15),
  (10978,40,18.4,10,0),
  (10978,44,19.45,6,0.15),
  (10979,7,30,18,0),
  (10979,12,38,20,0),
  (10979,24,4.5,80,0),
  (10979,27,43.9,30,0),
  (10979,31,12.5,24,0),
  (10979,63,43.9,35,0),
  (10980,75,7.75,40,0.2),
  (10981,38,263.5,60,0),
  (10982,7,30,20,0),
  (10982,43,46,9,0),
  (10983,13,6,84,0.15),
  (10983,57,19.5,15,0),
  (10984,16,17.45,55,0),
  (10984,24,4.5,20,0),
  (10984,36,19,40,0),
  (10985,16,17.45,36,0.1),
  (10985,18,62.5,8,0.1),
  (10985,32,32,35,0.1),
  (10986,11,21,30,0),
  (10986,20,81,15,0),
  (10986,76,18,10,0),
  (10986,77,13,15,0),
  (10987,7,30,60,0),
  (10987,43,46,6,0),
  (10987,72,34.8,20,0),
  (10988,7,30,60,0),
  (10988,62,49.3,40,0.1),
  (10989,6,25,40,0),
  (10989,11,21,15,0),
  (10989,41,9.65,4,0),
  (10990,21,10,65,0),
  (10990,34,14,60,0.15),
  (10990,55,24,65,0.15),
  (10990,61,28.5,66,0.15),
  (10991,2,19,50,0.2),
  (10991,70,15,20,0.2),
  (10991,76,18,90,0.2),
  (10992,72,34.8,2,0),
  (10993,29,123.79,50,0.25),
  (10993,41,9.65,35,0.25),
  (10994,59,55,18,0.05),
  (10995,51,53,20,0),
  (10995,60,34,4,0),
  (10996,42,14,40,0),
  (10997,32,32,50,0),
  (10997,46,12,20,0.25),
  (10997,52,7,20,0.25),
  (10998,24,4.5,12,0),
  (10998,61,28.5,7,0),
  (10998,74,10,20,0),
  (10998,75,7.75,30,0),
  (10999,41,9.65,20,0.05),
  (10999,51,53,15,0.05),
  (10999,77,13,21,0.05),
  (11000,4,22,25,0.25),
  (11000,24,4.5,30,0.25),
  (11000,77,13,30,0),
  (11001,7,30,60,0),
  (11001,22,21,25,0),
  (11001,46,12,25,0),
  (11001,55,24,6,0),
  (11002,13,6,56,0),
  (11002,35,18,15,0.15),
  (11002,42,14,24,0.15),
  (11002,55,24,40,0),
  (11003,1,18,4,0),
  (11003,40,18.4,10,0),
  (11003,52,7,10,0),
  (11004,26,31.23,6,0),
  (11004,76,18,6,0),
  (11005,1,18,2,0),
  (11005,59,55,10,0),
  (11006,1,18,8,0),
  (11006,29,123.79,2,0.25),
  (11007,8,40,30,0),
  (11007,29,123.79,10,0),
  (11007,42,14,14,0),
  (11008,28,45.6,70,0.05),
  (11008,34,14,90,0.05),
  (11008,71,21.5,21,0),
  (11009,24,4.5,12,0),
  (11009,36,19,18,0.25),
  (11009,60,34,9,0),
  (11010,7,30,20,0),
  (11010,24,4.5,10,0),
  (11011,58,13.25,40,0.05),
  (11011,71,21.5,20,0),
  (11012,19,9.2,50,0.05),
  (11012,60,34,36,0.05),
  (11012,71,21.5,60,0.05),
  (11013,23,9,10,0),
  (11013,42,14,4,0),
  (11013,45,9.5,20,0),
  (11013,68,12.5,2,0),
  (11014,41,9.65,28,0.1),
  (11015,30,25.89,15,0),
  (11015,77,13,18,0),
  (11016,31,12.5,15,0),
  (11016,36,19,16,0),
  (11017,3,10,25,0),
  (11017,59,55,110,0),
  (11017,70,15,30,0),
  (11018,12,38,20,0),
  (11018,18,62.5,10,0),
  (11018,56,38,5,0),
  (11019,46,12,3,0),
  (11019,49,20,2,0),
  (11020,10,31,24,0.15),
  (11021,2,19,11,0.25),
  (11021,20,81,15,0),
  (11021,26,31.23,63,0),
  (11021,51,53,44,0.25),
  (11021,72,34.8,35,0),
  (11022,19,9.2,35,0);

COMMIT;

#
# Data for the `Order Details` table  (LIMIT 2000,500)
#

INSERT INTO `Order Details` (`OrderID`, `ProductID`, `UnitPrice`, `Quantity`, `Discount`) VALUES 
  (11022,69,36,30,0),
  (11023,7,30,4,0),
  (11023,43,46,30,0),
  (11024,26,31.23,12,0),
  (11024,33,2.5,30,0),
  (11024,65,21.05,21,0),
  (11024,71,21.5,50,0),
  (11025,1,18,10,0.1),
  (11025,13,6,20,0.1),
  (11026,18,62.5,8,0),
  (11026,51,53,10,0),
  (11027,24,4.5,30,0.25),
  (11027,62,49.3,21,0.25),
  (11028,55,24,35,0),
  (11028,59,55,24,0),
  (11029,56,38,20,0),
  (11029,63,43.9,12,0),
  (11030,2,19,100,0.25),
  (11030,5,21.35,70,0),
  (11030,29,123.79,60,0.25),
  (11030,59,55,100,0.25),
  (11031,1,18,45,0),
  (11031,13,6,80,0),
  (11031,24,4.5,21,0),
  (11031,64,33.25,20,0),
  (11031,71,21.5,16,0),
  (11032,36,19,35,0),
  (11032,38,263.5,25,0),
  (11032,59,55,30,0),
  (11033,53,32.8,70,0.1),
  (11033,69,36,36,0.1),
  (11034,21,10,15,0.1),
  (11034,44,19.45,12,0),
  (11034,61,28.5,6,0),
  (11035,1,18,10,0),
  (11035,35,18,60,0),
  (11035,42,14,30,0),
  (11035,54,7.45,10,0),
  (11036,13,6,7,0),
  (11036,59,55,30,0),
  (11037,70,15,4,0),
  (11038,40,18.4,5,0.2),
  (11038,52,7,2,0),
  (11038,71,21.5,30,0),
  (11039,28,45.6,20,0),
  (11039,35,18,24,0),
  (11039,49,20,60,0),
  (11039,57,19.5,28,0),
  (11040,21,10,20,0),
  (11041,2,19,30,0.2),
  (11041,63,43.9,30,0),
  (11042,44,19.45,15,0),
  (11042,61,28.5,4,0),
  (11043,11,21,10,0),
  (11044,62,49.3,12,0),
  (11045,33,2.5,15,0),
  (11045,51,53,24,0),
  (11046,12,38,20,0.05),
  (11046,32,32,15,0.05),
  (11046,35,18,18,0.05),
  (11047,1,18,25,0.25),
  (11047,5,21.35,30,0.25),
  (11048,68,12.5,42,0),
  (11049,2,19,10,0.2),
  (11049,12,38,4,0.2),
  (11050,76,18,50,0.1),
  (11051,24,4.5,10,0.2),
  (11052,43,46,30,0.2),
  (11052,61,28.5,10,0.2),
  (11053,18,62.5,35,0.2),
  (11053,32,32,20,0),
  (11053,64,33.25,25,0.2),
  (11054,33,2.5,10,0),
  (11054,67,14,20,0),
  (11055,24,4.5,15,0),
  (11055,25,14,15,0),
  (11055,51,53,20,0),
  (11055,57,19.5,20,0),
  (11056,7,30,40,0),
  (11056,55,24,35,0),
  (11056,60,34,50,0),
  (11057,70,15,3,0),
  (11058,21,10,3,0),
  (11058,60,34,21,0),
  (11058,61,28.5,4,0),
  (11059,13,6,30,0),
  (11059,17,39,12,0),
  (11059,60,34,35,0),
  (11060,60,34,4,0),
  (11060,77,13,10,0),
  (11061,60,34,15,0),
  (11062,53,32.8,10,0.2),
  (11062,70,15,12,0.2),
  (11063,34,14,30,0),
  (11063,40,18.4,40,0.1),
  (11063,41,9.65,30,0.1),
  (11064,17,39,77,0.1),
  (11064,41,9.65,12,0),
  (11064,53,32.8,25,0.1),
  (11064,55,24,4,0.1),
  (11064,68,12.5,55,0),
  (11065,30,25.89,4,0.25),
  (11065,54,7.45,20,0.25),
  (11066,16,17.45,3,0),
  (11066,19,9.2,42,0),
  (11066,34,14,35,0),
  (11067,41,9.65,9,0),
  (11068,28,45.6,8,0.15),
  (11068,43,46,36,0.15),
  (11068,77,13,28,0.15),
  (11069,39,18,20,0),
  (11070,1,18,40,0.15),
  (11070,2,19,20,0.15),
  (11070,16,17.45,30,0.15),
  (11070,31,12.5,20,0),
  (11071,7,30,15,0.05),
  (11071,13,6,10,0.05),
  (11072,2,19,8,0),
  (11072,41,9.65,40,0),
  (11072,50,16.25,22,0),
  (11072,64,33.25,130,0),
  (11073,11,21,10,0),
  (11073,24,4.5,20,0),
  (11074,16,17.45,14,0.05),
  (11075,2,19,10,0.15),
  (11075,46,12,30,0.15),
  (11075,76,18,2,0.15),
  (11076,6,25,20,0.25),
  (11076,14,23.25,20,0.25),
  (11076,19,9.2,10,0.25),
  (11077,2,19,24,0.2),
  (11077,3,10,4,0),
  (11077,4,22,1,0),
  (11077,6,25,1,0.02),
  (11077,7,30,1,0.05),
  (11077,8,40,2,0.1),
  (11077,10,31,1,0),
  (11077,12,38,2,0.05),
  (11077,13,6,4,0),
  (11077,14,23.25,1,0.03),
  (11077,16,17.45,2,0.03),
  (11077,20,81,1,0.04),
  (11077,23,9,2,0),
  (11077,32,32,1,0),
  (11077,39,18,2,0.05),
  (11077,41,9.65,3,0),
  (11077,46,12,3,0.02),
  (11077,52,7,2,0),
  (11077,55,24,2,0),
  (11077,60,34,2,0.06),
  (11077,64,33.25,2,0.03),
  (11077,66,17,1,0),
  (11077,73,15,2,0.01),
  (11077,75,7.75,4,0),
  (11077,77,13,2,0);

COMMIT;