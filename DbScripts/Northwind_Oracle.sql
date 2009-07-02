-- Start of DDL Script for Table NWIND.CATEGORIES
-- Generated 19/01/07 19:41:29 from NWIND@INTELLIZ

CREATE TABLE categories
    (categoryid                     NUMBER(10,0) NOT NULL,
    categoryname                   VARCHAR2(15),
    description                    CLOB,
    picture                        BLOB)
  PCTFREE     10
  INITRANS    1
  MAXTRANS    255
  TABLESPACE  users
  STORAGE   (
    INITIAL     65536
    MINEXTENTS  1
    MAXEXTENTS  2147483645
  )
  LOB ("DESCRIPTION") STORE AS SYS_LOB0000043738C00003$$
  (
  TABLESPACE  users
  STORAGE   (
    INITIAL     65536
    MINEXTENTS  1
    MAXEXTENTS  2147483645
  )
   NOCACHE LOGGING
   CHUNK 8192
   PCTVERSION 10
  )
  LOB ("PICTURE") STORE AS SYS_LOB0000043738C00004$$
  (
  TABLESPACE  users
  STORAGE   (
    INITIAL     65536
    MINEXTENTS  1
    MAXEXTENTS  2147483645
  )
   NOCACHE LOGGING
   CHUNK 8192
   PCTVERSION 10
  )
/





-- Constraints for CATEGORIES

ALTER TABLE categories
ADD CONSTRAINT pk_categories PRIMARY KEY (categoryid)
USING INDEX
  PCTFREE     10
  INITRANS    2
  MAXTRANS    255
  TABLESPACE  users
  STORAGE   (
    INITIAL     65536
    MINEXTENTS  1
    MAXEXTENTS  2147483645
  )
/


-- End of DDL Script for Table NWIND.CATEGORIES

-- Start of DDL Script for Table NWIND.CUSTOMERS
-- Generated 19/01/07 19:41:30 from NWIND@INTELLIZ

CREATE TABLE customers
    (customerid                     VARCHAR2(5) NOT NULL,
    companyname                    VARCHAR2(40),
    contactname                    VARCHAR2(30),
    contacttitle                   VARCHAR2(30),
    address                        VARCHAR2(60),
    city                           VARCHAR2(15),
    region                         VARCHAR2(15),
    postalcode                     VARCHAR2(10),
    country                        VARCHAR2(15),
    phone                          VARCHAR2(24),
    fax                            VARCHAR2(24))
  PCTFREE     10
  INITRANS    1
  MAXTRANS    255
  TABLESPACE  users
  STORAGE   (
    INITIAL     65536
    MINEXTENTS  1
    MAXEXTENTS  2147483645
  )
/





-- Constraints for CUSTOMERS

ALTER TABLE customers
ADD CONSTRAINT pk_customers PRIMARY KEY (customerid)
USING INDEX
  PCTFREE     10
  INITRANS    2
  MAXTRANS    255
  TABLESPACE  users
  STORAGE   (
    INITIAL     65536
    MINEXTENTS  1
    MAXEXTENTS  2147483645
  )
/


-- End of DDL Script for Table NWIND.CUSTOMERS

-- Start of DDL Script for Table NWIND.EMPLOYEES
-- Generated 19/01/07 19:41:30 from NWIND@INTELLIZ

CREATE TABLE employees
    (employeeid                     NUMBER(10,0) NOT NULL,
    lastname                       VARCHAR2(20),
    firstname                      VARCHAR2(10),
    title                          VARCHAR2(30),
    titleofcourtesy                VARCHAR2(25),
    birthdate                      DATE,
    hiredate                       DATE,
    address                        VARCHAR2(60),
    city                           VARCHAR2(15),
    region                         VARCHAR2(15),
    postalcode                     VARCHAR2(10),
    country                        VARCHAR2(15),
    homephone                      VARCHAR2(24),
    extension                      VARCHAR2(4),
    photo                          BLOB,
    notes                          CLOB,
    reportsto                      NUMBER(10,0))
  PCTFREE     10
  INITRANS    1
  MAXTRANS    255
  TABLESPACE  users
  STORAGE   (
    INITIAL     65536
    MINEXTENTS  1
    MAXEXTENTS  2147483645
  )
  LOB ("PHOTO") STORE AS SYS_LOB0000043744C00015$$
  (
  TABLESPACE  users
  STORAGE   (
    INITIAL     65536
    MINEXTENTS  1
    MAXEXTENTS  2147483645
  )
   NOCACHE LOGGING
   CHUNK 8192
   PCTVERSION 10
  )
  LOB ("NOTES") STORE AS SYS_LOB0000043744C00016$$
  (
  TABLESPACE  users
  STORAGE   (
    INITIAL     65536
    MINEXTENTS  1
    MAXEXTENTS  2147483645
  )
   NOCACHE LOGGING
   CHUNK 8192
   PCTVERSION 10
  )
/





-- Constraints for EMPLOYEES

ALTER TABLE employees
ADD CONSTRAINT pk_employees PRIMARY KEY (employeeid)
USING INDEX
  PCTFREE     10
  INITRANS    2
  MAXTRANS    255
  TABLESPACE  users
  STORAGE   (
    INITIAL     65536
    MINEXTENTS  1
    MAXEXTENTS  2147483645
  )
/


-- Triggers for EMPLOYEES

CREATE OR REPLACE TRIGGER ti_employees
 BEFORE
  INSERT
 ON employees
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   max_employeeid   employees.employeeid%TYPE;

   CURSOR cpk1_employees
   IS
      SELECT seq_employees.NEXTVAL
        FROM DUAL;
BEGIN
   OPEN cpk1_employees;

   FETCH cpk1_employees
    INTO max_employeeid;

   CLOSE cpk1_employees;

   :NEW.employeeid := max_employeeid;
END;
/


-- End of DDL Script for Table NWIND.EMPLOYEES

-- Start of DDL Script for Table NWIND.ORDER_DETAILS
-- Generated 19/01/07 19:41:31 from NWIND@INTELLIZ

CREATE TABLE order_details
    (orderid                        NUMBER(10,0) NOT NULL,
    productid                      NUMBER(10,0) NOT NULL,
    unitprice                      NUMBER(10,2),
    quantity                       NUMBER(10,0),
    discount                       NUMBER(10,2))
  PCTFREE     10
  INITRANS    1
  MAXTRANS    255
  TABLESPACE  users
  STORAGE   (
    INITIAL     65536
    MINEXTENTS  1
    MAXEXTENTS  2147483645
  )
/





-- Constraints for ORDER_DETAILS



ALTER TABLE order_details
ADD CONSTRAINT pk_order_details PRIMARY KEY (orderid, productid)
USING INDEX
  PCTFREE     10
  INITRANS    2
  MAXTRANS    255
  TABLESPACE  users
  STORAGE   (
    INITIAL     65536
    MINEXTENTS  1
    MAXEXTENTS  2147483645
  )
/


-- End of DDL Script for Table NWIND.ORDER_DETAILS

-- Foreign Key
ALTER TABLE order_details
ADD CONSTRAINT fk1_orders_details FOREIGN KEY (productid)
REFERENCES products (productid)
/
ALTER TABLE order_details
ADD CONSTRAINT fk_orders_details FOREIGN KEY (orderid)
REFERENCES orders (orderid) ON DELETE CASCADE
/
-- End of DDL script for Foreign Key(s)
-- Start of DDL Script for Table NWIND.ORDERS
-- Generated 19/01/07 19:41:31 from NWIND@INTELLIZ

CREATE TABLE orders
    (orderid                        NUMBER(10,0) NOT NULL,
    customerid                     VARCHAR2(5) NOT NULL,
    employeeid                     NUMBER(10,0) NOT NULL,
    orderdate                      DATE NOT NULL,
    requireddate                   DATE,
    shippeddate                    DATE,
    shipvia                        NUMBER(10,0) NOT NULL,
    freight                        NUMBER(10,2),
    shipname                       VARCHAR2(40),
    shipaddress                    VARCHAR2(60),
    shipcity                       VARCHAR2(15),
    shipregion                     VARCHAR2(15),
    shippostalcode                 VARCHAR2(10),
    shipcountry                    VARCHAR2(15))
  PCTFREE     10
  INITRANS    1
  MAXTRANS    255
  TABLESPACE  users
  STORAGE   (
    INITIAL     65536
    MINEXTENTS  1
    MAXEXTENTS  2147483645
  )
/





-- Constraints for ORDERS




ALTER TABLE orders
ADD CONSTRAINT pk_orders PRIMARY KEY (orderid)
USING INDEX
  PCTFREE     10
  INITRANS    2
  MAXTRANS    255
  TABLESPACE  users
  STORAGE   (
    INITIAL     65536
    MINEXTENTS  1
    MAXEXTENTS  2147483645
  )
/


-- Triggers for ORDERS

CREATE OR REPLACE TRIGGER ti_orders
 BEFORE
  INSERT
 ON orders
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   max_orderid   orders.orderid%TYPE;

   CURSOR cpk1_orders
   IS
      SELECT seq_orders.NEXTVAL
        FROM DUAL;
BEGIN
   OPEN cpk1_orders;

   FETCH cpk1_orders
    INTO max_orderid;

   CLOSE cpk1_orders;

   :NEW.orderid := max_orderid;
END;
/


-- End of DDL Script for Table NWIND.ORDERS

-- Foreign Key
ALTER TABLE orders
ADD CONSTRAINT fk1_orders FOREIGN KEY (employeeid)
REFERENCES employees (employeeid)
/
ALTER TABLE orders
ADD CONSTRAINT fk3_orders FOREIGN KEY (shipvia)
REFERENCES shippers (shipperid)
/
ALTER TABLE orders
ADD CONSTRAINT fk_orders FOREIGN KEY (customerid)
REFERENCES customers (customerid)
/
-- End of DDL script for Foreign Key(s)
-- Start of DDL Script for Table NWIND.PRODUCTS
-- Generated 19/01/07 19:41:31 from NWIND@INTELLIZ

CREATE TABLE products
    (productid                      NUMBER(10,0) NOT NULL,
    productname                    VARCHAR2(40),
    supplierid                     NUMBER(10,0) NOT NULL,
    categoryid                     NUMBER(10,0) NOT NULL,
    quantityperunit                VARCHAR2(20),
    unitprice                      NUMBER(10,2),
    unitsinstock                   NUMBER(10,0),
    unitsonorder                   NUMBER(10,0),
    reorderlevel                   NUMBER(10,0),
    discontinued                   NUMBER(1,0))
  PCTFREE     10
  INITRANS    1
  MAXTRANS    255
  TABLESPACE  users
  STORAGE   (
    INITIAL     65536
    MINEXTENTS  1
    MAXEXTENTS  2147483645
  )
/





-- Constraints for PRODUCTS



ALTER TABLE products
ADD CONSTRAINT pk_products PRIMARY KEY (productid)
USING INDEX
  PCTFREE     10
  INITRANS    2
  MAXTRANS    255
  TABLESPACE  users
  STORAGE   (
    INITIAL     65536
    MINEXTENTS  1
    MAXEXTENTS  2147483645
  )
/


-- Triggers for PRODUCTS

CREATE OR REPLACE TRIGGER ti_products
 BEFORE
  INSERT
 ON products
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   max_productid   products.productid%TYPE;

   CURSOR cpk1_products
   IS
      SELECT seq_products.NEXTVAL
        FROM DUAL;
BEGIN
   OPEN cpk1_products;

   FETCH cpk1_products
    INTO max_productid;

   CLOSE cpk1_products;

   :NEW.productid := max_productid;
END;
/


-- End of DDL Script for Table NWIND.PRODUCTS

-- Foreign Key
ALTER TABLE products
ADD CONSTRAINT fk1_products FOREIGN KEY (supplierid)
REFERENCES suppliers (supplierid)
/
ALTER TABLE products
ADD CONSTRAINT fk_products FOREIGN KEY (categoryid)
REFERENCES categories (categoryid)
/
-- End of DDL script for Foreign Key(s)
-- Start of DDL Script for Table NWIND.SHIPPERS
-- Generated 19/01/07 19:41:32 from NWIND@INTELLIZ

CREATE TABLE shippers
    (shipperid                      NUMBER(10,0) NOT NULL,
    companyname                    VARCHAR2(40),
    phone                          VARCHAR2(24))
  PCTFREE     10
  INITRANS    1
  MAXTRANS    255
  TABLESPACE  users
  STORAGE   (
    INITIAL     65536
    MINEXTENTS  1
    MAXEXTENTS  2147483645
  )
/





-- Constraints for SHIPPERS

ALTER TABLE shippers
ADD CONSTRAINT pk_shippers PRIMARY KEY (shipperid)
USING INDEX
  PCTFREE     10
  INITRANS    2
  MAXTRANS    255
  TABLESPACE  users
  STORAGE   (
    INITIAL     65536
    MINEXTENTS  1
    MAXEXTENTS  2147483645
  )
/


-- End of DDL Script for Table NWIND.SHIPPERS

-- Start of DDL Script for Table NWIND.SUPPLIERS
-- Generated 19/01/07 19:41:32 from NWIND@INTELLIZ

CREATE TABLE suppliers
    (supplierid                     NUMBER(10,0) NOT NULL,
    companyname                    VARCHAR2(40),
    contactname                    VARCHAR2(30),
    contacttitle                   VARCHAR2(30),
    address                        VARCHAR2(60),
    city                           VARCHAR2(15),
    region                         VARCHAR2(15),
    postalcode                     VARCHAR2(10),
    country                        VARCHAR2(15),
    phone                          VARCHAR2(24),
    fax                            VARCHAR2(24),
    homepage                       CLOB)
  PCTFREE     10
  INITRANS    1
  MAXTRANS    255
  TABLESPACE  users
  STORAGE   (
    INITIAL     65536
    MINEXTENTS  1
    MAXEXTENTS  2147483645
  )
  LOB ("HOMEPAGE") STORE AS SYS_LOB0000043753C00012$$
  (
  TABLESPACE  users
  STORAGE   (
    INITIAL     65536
    MINEXTENTS  1
    MAXEXTENTS  2147483645
  )
   NOCACHE LOGGING
   CHUNK 8192
   PCTVERSION 10
  )
/





-- Constraints for SUPPLIERS

ALTER TABLE suppliers
ADD CONSTRAINT pk_suppliers PRIMARY KEY (supplierid)
USING INDEX
  PCTFREE     10
  INITRANS    2
  MAXTRANS    255
  TABLESPACE  users
  STORAGE   (
    INITIAL     65536
    MINEXTENTS  1
    MAXEXTENTS  2147483645
  )
/


-- Triggers for SUPPLIERS

CREATE OR REPLACE TRIGGER ti_suppliers
 BEFORE
  INSERT
 ON suppliers
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   max_supplierid   suppliers.supplierid%TYPE;

   CURSOR cpk1_suppliers
   IS
      SELECT seq_suppliers.NEXTVAL
        FROM DUAL;
BEGIN
   OPEN cpk1_suppliers;

   FETCH cpk1_suppliers
    INTO max_supplierid;

   CLOSE cpk1_suppliers;

   :NEW.supplierid := max_supplierid;
END;
/


-- End of DDL Script for Table NWIND.SUPPLIERS

-- Start of DDL Script for View NWIND.ALPHABETICAL_LIST_OF_PRODUCTS
-- Generated 19/01/07 19:41:42 from NWIND@INTELLIZ

CREATE OR REPLACE VIEW alphabetical_list_of_products (
   productid,
   productname,
   supplierid,
   categoryid,
   quantityperunit,
   unitprice,
   unitsinstock,
   unitsonorder,
   reorderlevel,
   discontinued,
   categoryname )
AS
SELECT Products.*, Categories.CategoryName
     FROM Categories INNER JOIN Products
          ON Categories.CategoryID = Products.CategoryID
    WHERE (((Products.Discontinued) = 0))
/


-- End of DDL Script for View NWIND.ALPHABETICAL_LIST_OF_PRODUCTS

-- Start of DDL Script for View NWIND.CATEGORY_SALES_FOR_1997
-- Generated 19/01/07 19:41:42 from NWIND@INTELLIZ

CREATE OR REPLACE VIEW category_sales_for_1997 (
   categoryname,
   categorysales )
AS
SELECT   Product_Sales_for_1997.CategoryName,
            SUM (Product_Sales_for_1997.ProductSales) AS CategorySales
       FROM Product_Sales_for_1997
   GROUP BY Product_Sales_for_1997.CategoryName
/


-- End of DDL Script for View NWIND.CATEGORY_SALES_FOR_1997

-- Start of DDL Script for View NWIND.CURRENT_PRODUCT_LIST
-- Generated 19/01/07 19:41:42 from NWIND@INTELLIZ

CREATE OR REPLACE VIEW current_product_list (
   productid,
   productname )
AS
SELECT Product_List.ProductID, Product_List.ProductName
     FROM Products Product_List
    WHERE (((Product_List.Discontinued) = 0))
/


-- End of DDL Script for View NWIND.CURRENT_PRODUCT_LIST

-- Start of DDL Script for View NWIND.CUSTOMER_AND_SUPPLIERS_BY_CITY
-- Generated 19/01/07 19:41:42 from NWIND@INTELLIZ

CREATE OR REPLACE VIEW customer_and_suppliers_by_city (
   city,
   companyname,
   contactname,
   relationship )
AS
SELECT City, CompanyName, ContactName, 'Customers' AS Relationship
     FROM Customers
   UNION
   SELECT City, CompanyName, ContactName, 'Suppliers'
     FROM Suppliers
/


-- End of DDL Script for View NWIND.CUSTOMER_AND_SUPPLIERS_BY_CITY

-- Start of DDL Script for View NWIND.INVOICES
-- Generated 19/01/07 19:41:42 from NWIND@INTELLIZ

CREATE OR REPLACE VIEW invoices (
   shipname,
   shipaddress,
   shipcity,
   shipregion,
   shippostalcode,
   shipcountry,
   customerid,
   customername,
   address,
   city,
   region,
   postalcode,
   country,
   salesperson,
   orderid,
   orderdate,
   requireddate,
   shippeddate,
   shippername,
   productid,
   productname,
   unitprice,
   quantity,
   discount,
   extendedprice,
   freight )
AS
SELECT Orders.ShipName, Orders.ShipAddress, Orders.ShipCity,
          Orders.ShipRegion, Orders.ShipPostalCode, Orders.ShipCountry,
          Orders.CustomerID, Customers.CompanyName AS CustomerName,
          Customers.Address, Customers.City, Customers.Region,
          Customers.PostalCode, Customers.Country,
          (FirstName || ' ' || LastName) AS Salesperson, Orders.OrderID,
          Orders.OrderDate, Orders.RequiredDate, Orders.ShippedDate,
          Shippers.CompanyName AS ShipperName, Order_Details.ProductID,
          Products.ProductName, Order_Details.UnitPrice,
          Order_Details.Quantity, Order_Details.Discount,
          (  (  Order_Details.UnitPrice
              * Order_Details.Quantity
              * (1 - Order_Details.Discount)
              / 100
             )
           * 100
          ) AS ExtendedPrice,
          Orders.Freight
     FROM Shippers
          INNER JOIN
          (Products
          INNER JOIN
          ((Employees
          INNER JOIN
          (Customers INNER JOIN Orders
          ON Customers.CustomerID = Orders.CustomerID)
          ON Employees.EmployeeID = Orders.EmployeeID)
          INNER JOIN
          Order_Details ON Orders.OrderID = Order_Details.OrderID)
          ON Products.ProductID = Order_Details.ProductID)
          ON Shippers.ShipperID = Orders.ShipVia
/


-- End of DDL Script for View NWIND.INVOICES

-- Start of DDL Script for View NWIND.ORDER_DETAILS_EXTENDED
-- Generated 19/01/07 19:41:42 from NWIND@INTELLIZ

CREATE OR REPLACE VIEW order_details_extended (
   orderid,
   productid,
   productname,
   unitprice,
   quantity,
   discount,
   extendedprice )
AS
SELECT Order_Details.OrderID, Order_Details.ProductID,
          Products.ProductName, Order_Details.UnitPrice,
          Order_Details.Quantity, Order_Details.Discount,
          ((Order_Details.UnitPrice * Quantity * (1 - Discount) / 100) * 100
          ) AS ExtendedPrice
     FROM Products INNER JOIN Order_Details
          ON Products.ProductID = Order_Details.ProductID
/


-- End of DDL Script for View NWIND.ORDER_DETAILS_EXTENDED

-- Start of DDL Script for View NWIND.ORDER_SUBTOTALS
-- Generated 19/01/07 19:41:42 from NWIND@INTELLIZ

CREATE OR REPLACE VIEW order_subtotals (
   orderid,
   subtotal )
AS
SELECT   Order_Details.OrderID,
            SUM (  (Order_Details.UnitPrice * Quantity * (1 - Discount) / 100
                   )
                 * 100
                ) AS Subtotal
       FROM Order_Details
   GROUP BY Order_Details.OrderID
/


-- End of DDL Script for View NWIND.ORDER_SUBTOTALS

-- Start of DDL Script for View NWIND.ORDERS_QRY
-- Generated 19/01/07 19:41:42 from NWIND@INTELLIZ

CREATE OR REPLACE VIEW orders_qry (
   orderid,
   customerid,
   employeeid,
   orderdate,
   requireddate,
   shippeddate,
   shipvia,
   freight,
   shipname,
   shipaddress,
   shipcity,
   shipregion,
   shippostalcode,
   shipcountry,
   companyname,
   address,
   city,
   region,
   postalcode,
   country )
AS
SELECT Orders.OrderID, Orders.CustomerID, Orders.EmployeeID,
          Orders.OrderDate, Orders.RequiredDate, Orders.ShippedDate,
          Orders.ShipVia, Orders.Freight, Orders.ShipName, Orders.ShipAddress,
          Orders.ShipCity, Orders.ShipRegion, Orders.ShipPostalCode,
          Orders.ShipCountry, Customers.CompanyName, Customers.Address,
          Customers.City, Customers.Region, Customers.PostalCode,
          Customers.Country
     FROM Customers INNER JOIN Orders ON Customers.CustomerID =
                                                             Orders.CustomerID
/


-- End of DDL Script for View NWIND.ORDERS_QRY

-- Start of DDL Script for View NWIND.PRODUCT_SALES_FOR_1997
-- Generated 19/01/07 19:41:42 from NWIND@INTELLIZ

CREATE OR REPLACE VIEW product_sales_for_1997 (
   categoryname,
   productname,
   productsales )
AS
SELECT   Categories.CategoryName, Products.ProductName,
            SUM (  (Order_Details.UnitPrice * Quantity * (1 - Discount) / 100
                   )
                 * 100
                ) AS ProductSales
       FROM (Categories INNER JOIN Products
            ON Categories.CategoryID = Products.CategoryID)
            INNER JOIN
            (Orders INNER JOIN Order_Details
            ON Orders.OrderID = Order_Details.OrderID)
            ON Products.ProductID = Order_Details.ProductID
      WHERE ((TO_CHAR (Orders.ShippedDate, 'rrrrmmdd') BETWEEN '19970101'
                                                           AND '19971231'
             )
            )
   GROUP BY Categories.CategoryName, Products.ProductName
/


-- End of DDL Script for View NWIND.PRODUCT_SALES_FOR_1997

-- Start of DDL Script for View NWIND.PRODUCTS_ABOVE_AVERAGE_PRICE
-- Generated 19/01/07 19:41:42 from NWIND@INTELLIZ

CREATE OR REPLACE VIEW products_above_average_price (
   productname,
   unitprice )
AS
SELECT Products.ProductName, Products.UnitPrice
     FROM Products
    WHERE Products.UnitPrice > (SELECT AVG (UnitPrice)
                                  FROM Products)
/


-- End of DDL Script for View NWIND.PRODUCTS_ABOVE_AVERAGE_PRICE

-- Start of DDL Script for View NWIND.PRODUCTS_BY_CATEGORY
-- Generated 19/01/07 19:41:42 from NWIND@INTELLIZ

CREATE OR REPLACE VIEW products_by_category (
   categoryname,
   productname,
   quantityperunit,
   unitsinstock,
   discontinued )
AS
SELECT Categories.CategoryName, Products.ProductName,
          Products.QuantityPerUnit, Products.UnitsInStock,
          Products.Discontinued
     FROM Categories INNER JOIN Products
          ON Categories.CategoryID = Products.CategoryID
    WHERE Products.Discontinued <> 1
/


-- End of DDL Script for View NWIND.PRODUCTS_BY_CATEGORY

-- Start of DDL Script for View NWIND.QUARTERLY_ORDERS
-- Generated 19/01/07 19:41:42 from NWIND@INTELLIZ

CREATE OR REPLACE VIEW quarterly_orders (
   customerid,
   companyname,
   city,
   country )
AS
SELECT DISTINCT Customers.CustomerID, Customers.CompanyName,
                   Customers.City, Customers.Country
              FROM Customers RIGHT JOIN Orders
                   ON Customers.CustomerID = Orders.CustomerID
             WHERE Orders.OrderDate BETWEEN '19970101' AND '19971231'
/


-- End of DDL Script for View NWIND.QUARTERLY_ORDERS

-- Start of DDL Script for View NWIND.SALES_BY_CATEGORY
-- Generated 19/01/07 19:41:42 from NWIND@INTELLIZ

CREATE OR REPLACE VIEW sales_by_category (
   categoryid,
   categoryname,
   productname,
   productsales )
AS
SELECT   Categories.CategoryID, Categories.CategoryName,
            Products.ProductName,
            SUM (Order_Details_Extended.ExtendedPrice) AS ProductSales
       FROM Categories
            INNER JOIN
            (Products
            INNER JOIN
            (Orders INNER JOIN Order_Details_Extended
            ON Orders.OrderID = Order_Details_Extended.OrderID)
            ON Products.ProductID = Order_Details_Extended.ProductID)
            ON Categories.CategoryID = Products.CategoryID
      WHERE TO_CHAR (Orders.OrderDate, 'rrrrmmdd') BETWEEN '19970101'
                                                       AND '19971231'
   GROUP BY Categories.CategoryID,
            Categories.CategoryName,
            Products.ProductName
/


-- End of DDL Script for View NWIND.SALES_BY_CATEGORY

-- Start of DDL Script for View NWIND.SALES_TOTALS_BY_AMOUNT
-- Generated 19/01/07 19:41:42 from NWIND@INTELLIZ

CREATE OR REPLACE VIEW sales_totals_by_amount (
   saleamount,
   orderid,
   companyname,
   shippeddate )
AS
SELECT Order_Subtotals.Subtotal AS SaleAmount, Orders.OrderID,
          Customers.CompanyName, Orders.ShippedDate
     FROM Customers
          INNER JOIN
          (Orders INNER JOIN Order_Subtotals
          ON Orders.OrderID = Order_Subtotals.OrderID)
          ON Customers.CustomerID = Orders.CustomerID
    WHERE (Order_Subtotals.Subtotal > 2500)
      AND (Orders.ShippedDate BETWEEN '19970101' AND '19971231')
/


-- End of DDL Script for View NWIND.SALES_TOTALS_BY_AMOUNT

-- Start of DDL Script for View NWIND.SUMMARY_OF_SALES_BY_QUARTER
-- Generated 19/01/07 19:41:43 from NWIND@INTELLIZ

CREATE OR REPLACE VIEW summary_of_sales_by_quarter (
   shippeddate,
   orderid,
   subtotal )
AS
SELECT Orders.ShippedDate, Orders.OrderID, Order_Subtotals.Subtotal
     FROM Orders INNER JOIN Order_Subtotals
          ON Orders.OrderID = Order_Subtotals.OrderID
    WHERE Orders.ShippedDate IS NOT NULL
/


-- End of DDL Script for View NWIND.SUMMARY_OF_SALES_BY_QUARTER

-- Start of DDL Script for View NWIND.SUMMARY_OF_SALES_BY_YEAR
-- Generated 19/01/07 19:41:43 from NWIND@INTELLIZ

CREATE OR REPLACE VIEW summary_of_sales_by_year (
   shippeddate,
   orderid,
   subtotal )
AS
SELECT Orders.ShippedDate, Orders.OrderID, Order_Subtotals.Subtotal
     FROM Orders INNER JOIN Order_Subtotals
          ON Orders.OrderID = Order_Subtotals.OrderID
    WHERE Orders.ShippedDate IS NOT NULL
/


-- End of DDL Script for View NWIND.SUMMARY_OF_SALES_BY_YEAR

-- Start of DDL Script for Sequence NWIND.SEQ_EMPLOYEES
-- Generated 19/01/07 19:44:37 from NWIND@INTELLIZ

CREATE SEQUENCE seq_employees
  INCREMENT BY 1
  START WITH 11
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  NOCYCLE
  NOORDER
  CACHE 20
/


-- End of DDL Script for Sequence NWIND.SEQ_EMPLOYEES

-- Start of DDL Script for Sequence NWIND.SEQ_ORDERS
-- Generated 19/01/07 19:44:37 from NWIND@INTELLIZ

CREATE SEQUENCE seq_orders
  INCREMENT BY 1
  START WITH 11078
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  NOCYCLE
  NOORDER
  CACHE 20
/


-- End of DDL Script for Sequence NWIND.SEQ_ORDERS

-- Start of DDL Script for Sequence NWIND.SEQ_PRODUCTS
-- Generated 19/01/07 19:44:37 from NWIND@INTELLIZ

CREATE SEQUENCE seq_products
  INCREMENT BY 1
  START WITH 78
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  NOCYCLE
  NOORDER
  CACHE 20
/


-- End of DDL Script for Sequence NWIND.SEQ_PRODUCTS

-- Start of DDL Script for Sequence NWIND.SEQ_SUPPLIERS
-- Generated 19/01/07 19:44:37 from NWIND@INTELLIZ

CREATE SEQUENCE seq_suppliers
  INCREMENT BY 1
  START WITH 30
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  NOCYCLE
  NOORDER
  CACHE 20
/


-- End of DDL Script for Sequence NWIND.SEQ_SUPPLIERS

