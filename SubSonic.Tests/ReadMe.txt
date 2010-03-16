Database requirements to run the tests
======================================

MySQL
=====
These tests require MySQL 5.0 + and you can get that from http://mysql.org
  * Make sure to download MySQL Workbench as well N.B. Make sure you get at least version 5.2 of Workbench (as of writing this is a Development Release)
  * Open up the MySQL Workbench and create a new database called "Northwind" and one called "subsonic"
  * Open up the MySQL Query Browser against Northwind, then select File/Open Script.
  * Open up Northwind_Schema_Data_MySQL.sql in the Query Browser, and select Execute (green lighting button)
  * The tests expect MySQL to be installed at localhost, this is the default

SQL2005
=======
These tests require any version of SQL Server 2005
  * Open up Management Studio and create a new database called "Northwind" and one called "SubSonic"
  * Select File/Open/File and open up Northwind_Schema_Data_SQLServer.sql
  * Execute the script against the Northwind database
  * The tests expect an instance of SQL Server installed at .\SQLExpress 
  * If that's not your server name you can create an Alias as described at http://geekswithblogs.net/twickers/archive/2009/12/08/136830.aspx

SQL2008
=======
These tests require any version of SQL Server 2008
  * Open up Management Studio and create a new database called "Northwind" and one called "SubSonic"
  * Select File/Open/File and open up Northwind_Schema_Data_SQLServer.sql
  * Execute the script against the Northwind database
  * The tests expect an instance of SQL Server installed at .\SQL2008
  * If that's not your server name you can create an Alias as described at http://geekswithblogs.net/twickers/archive/2009/12/08/136830.aspxNorthwind_Schema_Data_SQLServer.sql  

SQLite
======
Nothing, the DBs are included in the project as are the required assemblies (I <3 SQLite :)

Running the tests
=================

We use xUnit  for testing so to you'll need a test runner (a tool that runs the tests) such as:
  * TestDriven.net - http://www.testdriven.net/quickstart.aspx
  * The xUnit console based test runner - http://xunit.codeplex.com/wikipage?title=HowToUse
  * The (experimental) xUnit GUI test runner - http://bradwilson.typepad.com/blog/2009/09/xunitnet-15-shipped.html
  * ReSharper - http://www.jetbrains.com/resharper/plugins/

FAQ
===
Where are the DbScripts to create required databases?
In the DbScripts folder at the root of the solution

Where are the connection strings specified?
For ActiveRecord - In the App.config the Northwind connectionstring is used
For all other tests - In the TestConfiguration.cs file in the root of SubSonic.Tests (next to this file) 

Why don't you use MSTest?
Because it's not available in the Express versions of Visual Studio