
namespace SubSonic.Tests.Unit.Linq.SqlStrings
{
	public class Sql2008SelectTestsSql : ISelectTestsSql
	{
		#region Properties (58) 

		public string All_With_SubQuery
		{
			get { return @"SELECT [t0].[Address], [t0].[City], [t0].[CompanyName], [t0].[ContactName], [t0].[Country], [t0].[CustomerID], [t0].[Region]
FROM [Customers] AS t0
WHERE NOT EXISTS(
  SELECT NULL 
  FROM [Orders] AS t1
  WHERE (([t1].[CustomerID] = [t0].[CustomerID]) AND NOT ([t1].[OrderDate] > 05/01/2008 00:00:00))
  )";
			}
		}

		public string Any_With_Collection
		{
			get { return @"SELECT [t0].[Address], [t0].[City], [t0].[CompanyName], [t0].[ContactName], [t0].[Country], [t0].[CustomerID], [t0].[Region]
FROM [Customers] AS t0
WHERE (([t0].[CustomerID] = 'TEST1') OR ([t0].[CustomerID] = 'TEST2'))";
			}
		}

		public string Any_With_Collection_One_False
		{
			get { return @"SELECT [t0].[Address], [t0].[City], [t0].[CompanyName], [t0].[ContactName], [t0].[Country], [t0].[CustomerID], [t0].[Region]
FROM [Customers] AS t0
WHERE (([t0].[CustomerID] = 'ABCDE') OR ([t0].[CustomerID] = 'TEST1'))";
			}
		}

		public string Contains_Resolves_Literal
		{
			get { return @"SELECT [t0].[Address], [t0].[City], [t0].[CompanyName], [t0].[ContactName], [t0].[Country], [t0].[CustomerID], [t0].[Region]
FROM [Customers] AS t0
WHERE ([t0].[ContactName] LIKE '%' + 'har' + '%')";
			}
		}

		public string Contains_With_LocalCollection_2_True
		{
			get { return @"SELECT [t0].[Address], [t0].[City], [t0].[CompanyName], [t0].[ContactName], [t0].[Country], [t0].[CustomerID], [t0].[Region]
FROM [Customers] AS t0
WHERE [t0].[CustomerID] IN ('TEST2', 'TEST1')";
			}
		}

		public string Contains_With_LocalCollection_OneFalse
		{
			get { return @"SELECT [t0].[Address], [t0].[City], [t0].[CompanyName], [t0].[ContactName], [t0].[Country], [t0].[CustomerID], [t0].[Region]
FROM [Customers] AS t0
WHERE [t0].[CustomerID] IN ('ABCDE', 'TEST1')";
			}
		}

		public string Contains_With_Subquery
		{
			get { return @"SELECT [t0].[Address], [t0].[City], [t0].[CompanyName], [t0].[ContactName], [t0].[Country], [t0].[CustomerID], [t0].[Region]
FROM [Customers] AS t0
WHERE [t0].[CustomerID] IN (
  SELECT [t1].[CustomerID]
  FROM [Orders] AS t1
  )";
			}
		}

		public string Count_Distinct
		{
			get { return @"SELECT DISTINCT [t0].[City]
FROM [Customers] AS t0";
			}
		}

		public string Count_No_Args
		{
			get { return @"SELECT [t0].[OrderID]
FROM [Orders] AS t0";
			}
		}

		public string Distinct_GroupBy
		{
			get { return "SELECT [t0].[CustomerID]\r\nFROM (\r\n  SELECT DISTINCT [t1].[CustomerID], [t1].[OrderDate], [t1].[OrderID], [t1].[RequiredDate], [t1].[ShippedDate]\r\n  FROM [Orders] AS t1\r\n  ) AS t0\r\nGROUP BY [t0].[CustomerID]\n\nSELECT DISTINCT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]\r\nFROM [Orders] AS t0\r\nWHERE (([t0].[CustomerID] IS NULL AND [t1].[CustomerID] IS NULL) OR ([t0].[CustomerID] = [t1].[CustomerID]))";
			}
		}

		public string Distinct_Should_Not_Fail
		{
			get { return @"SELECT DISTINCT [t0].[Address], [t0].[City], [t0].[CompanyName], [t0].[ContactName], [t0].[Country], [t0].[CustomerID], [t0].[Region]
FROM [Customers] AS t0";
			}
		}

		public string Distinct_Should_Return_11_For_Scalar_CustomerCity
		{
			get { return @"SELECT DISTINCT [t0].[City]
FROM [Customers] AS t0";
			}
		}

		public string Distinct_Should_Return_69_For_Scalar_CustomerCity_Ordered
		{
			get { return @"SELECT DISTINCT [t0].[City]
FROM [Customers] AS t0
ORDER BY [t0].[City]";
			}
		}

		public string GroupBy_Basic
		{
			get { return "SELECT [t0].[City]\r\nFROM [Customers] AS t0\r\nGROUP BY [t0].[City]\n\nSELECT [t0].[Address], [t0].[City], [t0].[CompanyName], [t0].[ContactName], [t0].[Country], [t0].[CustomerID], [t0].[Region]\r\nFROM [Customers] AS t0\r\nWHERE (([t0].[City] IS NULL AND [t1].[City] IS NULL) OR ([t0].[City] = [t1].[City]))";
			}
		}

		public string GroupBy_Distinct
		{
			get { return "SELECT DISTINCT [t0].[CustomerID]\r\nFROM (\r\n  SELECT [t1].[CustomerID]\r\n  FROM [Orders] AS t1\r\n  GROUP BY [t1].[CustomerID]\r\n  ) AS t0\n\nSELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]\r\nFROM [Orders] AS t0\r\nWHERE (([t0].[CustomerID] IS NULL AND [t1].[CustomerID] IS NULL) OR ([t0].[CustomerID] = [t1].[CustomerID]))";
			}
		}

		public string GroupBy_SelectMany
		{
			get { return @"SELECT [t0].[Address], [t0].[City], [t0].[CompanyName], [t0].[ContactName], [t0].[Country], [t0].[CustomerID], [t0].[Region]
FROM (
  SELECT [t1].[City]
  FROM [Customers] AS t1
  GROUP BY [t1].[City]
  ) AS t2
INNER JOIN [Customers] AS t0
  ON (([t0].[City] IS NULL AND [t2].[City] IS NULL) OR ([t0].[City] = [t2].[City]))";
			}
		}

		public string GroupBy_Sum
		{
			get { return @"SELECT SUM([t0].[OrderID]) AS agg1, MIN([t0].[OrderID]) AS agg2, MAX([t0].[OrderID]) AS agg3, AVG([t0].[OrderID]) AS agg4
FROM [Orders] AS t0
GROUP BY [t0].[CustomerID]";
			}
		}

		public string GroupBy_Sum_With_Element_Selector_Sum_Max
		{
			get { return @"SELECT SUM([t0].[OrderID]) AS agg1, MAX([t0].[OrderID]) AS agg2
FROM [Orders] AS t0
GROUP BY [t0].[CustomerID]";
			}
		}

		public string GroupBy_Sum_With_Result_Selector
		{
			get { return "SELECT SUM([t0].[OrderID]) AS c0, MIN([t0].[OrderID]) AS c1, MAX([t0].[OrderID]) AS c2, AVG([t0].[OrderID]) AS c3\r\nFROM [Orders] AS t0\r\nGROUP BY [t0].[CustomerID]";
			}
		}

		public string GroupBy_With_Anon_Element
		{
			get { return @"SELECT SUM([t0].[OrderID]) AS agg1
FROM [Orders] AS t0
GROUP BY [t0].[CustomerID]";
			}
		}

		public string GroupBy_With_Element_Selector
		{
			get { return "SELECT [t0].[CustomerID]\r\nFROM [Orders] AS t0\r\nGROUP BY [t0].[CustomerID]\n\nSELECT [t0].[OrderID]\r\nFROM [Orders] AS t0\r\nWHERE (([t0].[CustomerID] IS NULL AND [t1].[CustomerID] IS NULL) OR ([t0].[CustomerID] = [t1].[CustomerID]))";
			}
		}

		public string GroupBy_With_Element_Selector_Sum
		{
			get { return @"SELECT SUM([t0].[OrderID]) AS agg1
FROM [Orders] AS t0
GROUP BY [t0].[CustomerID]";
			}
		}

		public string GroupBy_With_OrderBy
		{
			get { return @"SELECT SUM([t0].[OrderID]) AS agg1
FROM [Orders] AS t0
GROUP BY [t0].[CustomerID]";
			}
		}

		public string Join_To_Categories
		{
			get { return @"SELECT [t0].[CategoryID], [t0].[Discontinued], [t0].[ProductID], [t0].[ProductName], [t0].[Sku], [t0].[UnitPrice]
FROM [Categories] AS t1
INNER JOIN [Products] AS t0
  ON ([t1].[CategoryID] = [t0].[CategoryID])";
			}
		}

		public string OrderBy_CustomerID
		{
			get { return @"SELECT [t0].[Address], [t0].[City], [t0].[CompanyName], [t0].[ContactName], [t0].[Country], [t0].[CustomerID], [t0].[Region]
FROM [Customers] AS t0
ORDER BY [t0].[CustomerID]";
			}
		}

		public string OrderBy_CustomerID_Descending
		{
			get { return @"SELECT [t0].[Address], [t0].[City], [t0].[CompanyName], [t0].[ContactName], [t0].[Country], [t0].[CustomerID], [t0].[Region]
FROM [Customers] AS t0
ORDER BY [t0].[CustomerID] DESC";
			}
		}

		public string OrderBy_CustomerID_Descending_ThenBy_City
		{
			get { return @"SELECT [t0].[City]
FROM [Customers] AS t0
ORDER BY [t0].[CustomerID] DESC, [t0].[City]";
			}
		}

		public string OrderBy_CustomerID_Descending_ThenByDescending_City
		{
			get { return @"SELECT [t0].[City]
FROM [Customers] AS t0
ORDER BY [t0].[CustomerID] DESC, [t0].[City] DESC";
			}
		}

		public string OrderBy_CustomerID_OrderBy_Company_City
		{
			get { return @"SELECT [t0].[City]
FROM [Customers] AS t0
ORDER BY [t0].[City], [t0].[CompanyName]";
			}
		}

		public string OrderBy_CustomerID_ThenBy_City
		{
			get { return @"SELECT [t0].[City]
FROM [Customers] AS t0
ORDER BY [t0].[CustomerID], [t0].[City]";
			}
		}

		public string OrderBy_CustomerID_With_Select
		{
			get { return @"SELECT [t0].[Address]
FROM [Customers] AS t0
ORDER BY [t0].[CustomerID]";
			}
		}

		public string OrderBy_Join
		{
			get { return "SELECT [t0].[CustomerID], [t1].[OrderID]\r\nFROM [Customers] AS t0\r\nINNER JOIN [Orders] AS t1\r\n  ON ([t0].[CustomerID] = [t1].[CustomerID])\r\nORDER BY [t0].[CustomerID], [t1].[OrderID]";
			}
		}

		public string OrderBy_SelectMany
		{
			get { return "SELECT [t0].[CustomerID], [t1].[OrderID]\r\nFROM [Customers] AS t0\r\nCROSS JOIN [Orders] AS t1\r\nWHERE ([t0].[CustomerID] = [t1].[CustomerID])\r\nORDER BY [t0].[CustomerID], [t1].[OrderID]";
			}
		}

		public string Paging_With_Skip_Take
		{
			get
			{
				return "SELECT [t0].[CategoryID], [t0].[Discontinued], [t0].[ProductID], [t0].[ProductName], [t0].[Sku], [t0].[UnitPrice]\r\nFROM (\r\n  SELECT [t1].[CategoryID], [t1].[Discontinued], [t1].[ProductID], [t1].[ProductName], ROW_NUMBER() OVER(ORDER BY [t1].[ProductID]) AS rownum, [t1].[Sku], [t1].[UnitPrice]\r\n  FROM [Products] AS t1\r\n  ) AS t0\r\nWHERE [t0].[rownum] BETWEEN (10 + 1) AND (10 + 20)\r\nORDER BY [t0].[ProductID]";
			}
		}

		public string Paging_With_Take
		{
			get { return "SELECT TOP (20) [t0].[CategoryID], [t0].[Discontinued], [t0].[ProductID], [t0].[ProductName], [t0].[Sku], [t0].[UnitPrice]\r\nFROM [Products] AS t0";
			}
		}

		public string Select_0_When_Set_False
		{
			get { return @"SELECT [t0].[CategoryID], [t0].[Discontinued], [t0].[ProductID], [t0].[ProductName], [t0].[Sku], [t0].[UnitPrice]
FROM [Products] AS t0
WHERE 0 <> 0";
			}
		}

		public string Select_100_When_Set_True
		{
			get { return @"SELECT [t0].[CategoryID], [t0].[Discontinued], [t0].[ProductID], [t0].[ProductName], [t0].[Sku], [t0].[UnitPrice]
FROM [Products] AS t0
WHERE 1 <> 0";
			}
		}

		public string Select_Anon_Constant_Int
		{
			get { return @"SELECT NULL 
FROM [Products] AS t0";
			}
		}

		public string Select_Anon_Constant_NullString
		{
			get { return @"SELECT NULL 
FROM [Products] AS t0";
			}
		}

		public string Select_Anon_Empty
		{
			get { return @"SELECT NULL 
FROM [Products] AS t0";
			}
		}

		public string Select_Anon_Literal
		{
			get { return "SELECT NULL \r\nFROM [Products] AS t0";
			}
		}

		public string Select_Anon_Nested
		{
			get { return "SELECT [t0].[ProductName], [t0].[UnitPrice]\r\nFROM [Products] AS t0";
			}
		}

		public string Select_Anon_One
		{
			get { return "SELECT [t0].[ProductName]\r\nFROM [Products] AS t0";
			}
		}

		public string Select_Anon_One_And_Object
		{
			get { return "SELECT [t0].[ProductName], [t0].[CategoryID], [t0].[Discontinued], [t0].[ProductID], [t0].[Sku], [t0].[UnitPrice]\r\nFROM [Products] AS t0";
			}
		}

		public string Select_Anon_Three
		{
			get { return "SELECT [t0].[ProductName], [t0].[UnitPrice], [t0].[Discontinued]\r\nFROM [Products] AS t0";
			}
		}

		public string Select_Anon_Two
		{
			get { return "SELECT [t0].[ProductName], [t0].[UnitPrice]\r\nFROM [Products] AS t0";
			}
		}

		public string Select_Anon_With_Local
		{
			get { return @"SELECT NULL 
FROM [Products] AS t0";
			}
		}

		public string Select_Nested_Collection
		{
			get { return @"SELECT (
  SELECT COUNT(*)
  FROM [OrderDetails] AS t0
  WHERE ([t0].[ProductID] = [t1].[ProductID])
  ) AS c0
FROM [Products] AS t1
WHERE ([t1].[ProductID] = 1)";
			}
		}

		public string Select_Nested_Collection_With_AnonType
		{
			get { return "SELECT [t0].[ProductID]\r\nFROM [Products] AS t0\r\nWHERE ([t0].[ProductID] = 1)\n\nSELECT [t0].[ProductID], [t1].[Test], [t1].[Discount], [t1].[OrderDetailID], [t1].[OrderID], [t1].[ProductID] AS ProductID1, [t1].[Quantity], [t1].[UnitPrice]\r\nFROM [Products] AS t0\r\nLEFT OUTER JOIN (\r\n  SELECT [t2].[Discount], [t2].[OrderDetailID], [t2].[OrderID], [t2].[ProductID], [t2].[Quantity], 1 AS Test, [t2].[UnitPrice]\r\n  FROM [OrderDetails] AS t2\r\n  ) AS t1\r\n  ON ([t1].[ProductID] = [t0].[ProductID])\r\nWHERE ([t0].[ProductID] = 1)";
			}
		}

		public string Select_On_Self
		{
			get { return @"SELECT [t0].[CategoryID], [t0].[Discontinued], [t0].[ProductID], [t0].[ProductName], [t0].[Sku], [t0].[UnitPrice]
FROM [Products] AS t0";
			}
		}

		public string Select_Scalar
		{
			get { return @"SELECT [t0].[ProductName]
FROM [Products] AS t0";
			}
		}

		public string SelectMany_Customer_Orders
		{
			get { return "SELECT [t0].[ContactName], [t1].[OrderID]\r\nFROM [Customers] AS t0\r\nCROSS JOIN [Orders] AS t1\r\nWHERE ([t0].[CustomerID] = [t1].[CustomerID])";
			}
		}

		public string Where_Resolves_String_EndsWith_Literal
		{
			get { return @"SELECT [t0].[Address], [t0].[City], [t0].[CompanyName], [t0].[ContactName], [t0].[Country], [t0].[CustomerID], [t0].[Region]
FROM [Customers] AS t0
WHERE ([t0].[City] LIKE '%' + '10')";
			}
		}

		public string Where_Resolves_String_EndsWith_OtherColumn
		{
			get { return @"SELECT [t0].[Address], [t0].[City], [t0].[CompanyName], [t0].[ContactName], [t0].[Country], [t0].[CustomerID], [t0].[Region]
FROM [Customers] AS t0
WHERE ([t0].[ContactName] LIKE '%' + [t0].[ContactName])";
			}
		}

		public string Where_Resolves_String_IsNullOrEmpty
		{
			get { return @"SELECT [t0].[Address], [t0].[City], [t0].[CompanyName], [t0].[ContactName], [t0].[Country], [t0].[CustomerID], [t0].[Region]
FROM [Customers] AS t0
WHERE ([t0].[City] IS NULL OR [t0].[City] = '')";
			}
		}

		public string Where_Resolves_String_Length
		{
			get { return @"SELECT [t0].[Address], [t0].[City], [t0].[CompanyName], [t0].[ContactName], [t0].[Country], [t0].[CustomerID], [t0].[Region]
FROM [Customers] AS t0
WHERE (LEN([t0].[City]) = 7)";
			}
		}

		public string Where_Resolves_String_StartsWith_Literal
		{
			get { return @"SELECT [t0].[Address], [t0].[City], [t0].[CompanyName], [t0].[ContactName], [t0].[Country], [t0].[CustomerID], [t0].[Region]
FROM [Customers] AS t0
WHERE ([t0].[ContactName] LIKE 'C' + '%')";
			}
		}

		public string Where_Resolves_String_StartsWith_OtherColumn
		{
			get { return @"SELECT [t0].[Address], [t0].[City], [t0].[CompanyName], [t0].[ContactName], [t0].[Country], [t0].[CustomerID], [t0].[Region]
FROM [Customers] AS t0
WHERE ([t0].[ContactName] LIKE [t0].[ContactName] + '%')";
			}
		}

		#endregion Properties 
	}
}

