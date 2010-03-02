using System;
using System.Globalization;
using System.Linq;
using System.Threading;
using SubSonic.Linq.Structure;
using SubSonic.Tests.Unit.Linq.SqlStrings;
using Xunit;

	namespace SubSonic.Tests.Unit.Linq.TestBases
	{
		// ReSharper disable InconsistentNaming
		// these are unit tests and I like underscores
		// suck it Osherove :)
		// [TestFixture]
		public abstract class SelectTests
		{
			protected TestDB _db;
			protected ISelectTestsSql selectTestsSql;

			//[Fact]
			//public void All_With_StartsWith()
			//{
			//  // Hits DB 
			//  var result =
			//      _db.Customers.All(c => c.ContactName.StartsWith("x"));

			//  Assert.False(result);
			//}

			[Fact]
			public void All_With_SubQuery()
			{
				var result =
						_db.Customers.Where(
								c => _db.Orders.Where(o => o.CustomerID == c.CustomerID).All(o => o.OrderDate > DateTime.Parse("5/1/2008")));

				Thread.CurrentThread.CurrentCulture = CultureInfo.InvariantCulture;

				string expectedSql = @"SELECT [t0].[Address], [t0].[City], [t0].[CompanyName], [t0].[ContactName], [t0].[Country], [t0].[CustomerID], [t0].[Region]
	FROM [Customers] AS t0
	WHERE NOT EXISTS(
		SELECT NULL 
		FROM [Orders] AS t1
		WHERE (([t1].[CustomerID] = [t0].[CustomerID]) AND NOT ([t1].[OrderDate] > 05/01/2008 00:00:00))
		)";

				Assert.Equal(selectTestsSql.All_With_SubQuery, result.GetQueryText());
			}

			//[Fact]
			//public void Any_Should_Not_Fail()
			//{
			//  // Hits DB
			//  Assert.True(_db.Products.Any(x => x.ProductID == 1));
			//}

			[Fact]
			public void Any_With_Collection()
			{
				string[] ids = new[] { "TEST1", "TEST2" };
				var result = _db.Customers.Where(c => ids.Any(id => c.CustomerID == id));
			
				Assert.Equal(selectTestsSql.Any_With_Collection, result.GetQueryText());
			}

			[Fact]
			public void Any_With_Collection_One_False()
			{
				string[] ids = new[] { "ABCDE", "TEST1" };
				var result = _db.Customers.Where(c => ids.Any(id => c.CustomerID == id));
				Assert.Equal(selectTestsSql.Any_With_Collection_One_False, result.GetQueryText());
			}

			[Fact]
			public void Contains_Resolves_Literal()
			{
				var result =
						_db.Customers.Where(x => x.ContactName.Contains("har"));
				Assert.Equal(selectTestsSql.Contains_Resolves_Literal, result.GetQueryText());
			}

			[Fact]
			public void Contains_With_LocalCollection_2_True()
			{
				string[] ids = new[] { "TEST2", "TEST1" };
				var result =
						_db.Customers.Where(c => ids.Contains(c.CustomerID));
				Assert.Equal(selectTestsSql.Contains_With_LocalCollection_2_True, result.GetQueryText());
			}

			[Fact]
			public void Contains_With_LocalCollection_OneFalse()
			{
				string[] ids = new[] { "ABCDE", "TEST1" };
				var result =
						_db.Customers.Where(c => ids.Contains(c.CustomerID));
				Assert.Equal(selectTestsSql.Contains_With_LocalCollection_OneFalse, result.GetQueryText());
			}

			[Fact]
			public void Contains_With_Subquery()
			{
				var result =
						_db.Customers.Where(c => _db.Orders.Select(o => o.CustomerID).Contains(c.CustomerID));
				
				Assert.Equal(selectTestsSql.Contains_With_Subquery, result.GetQueryText());
			}

			[Fact]
			public void Count_Distinct()
			{
				var result = _db.Customers.Select(c => c.City).Distinct();
				
				Assert.Equal(selectTestsSql.Count_Distinct, result.GetQueryText());
			}

			//[Fact]
			//public void Count_Distinct_With_Arg()
			//{
			//  // Hits DB
			//  var result = _db.Customers.Distinct().Count(x => x.CustomerID == "TEST1");

			//  Assert.Equal(1, result);
			//}

			[Fact]
			public void Count_No_Args()
			{
				var result = _db.Orders.Select(o => o.OrderID);
				
				Assert.Equal(selectTestsSql.Count_No_Args, result.GetQueryText());
			}

			//[Fact]
			//public void Count_With_SingleArg()
			//{
			//  // Hits DB
			//  var result = _db.Orders.Count(x => x.OrderID > 0);
			//  Assert.Equal(100, result);
			//}

			[Fact]
			public void Distinct_GroupBy()
			{
				var result = _db.Orders.Distinct().GroupBy(o => o.CustomerID);
				string expectedSql = "SELECT [t0].[CustomerID]\r\nFROM (\r\n  SELECT DISTINCT [t1].[CustomerID], [t1].[OrderDate], [t1].[OrderID], [t1].[RequiredDate], [t1].[ShippedDate]\r\n  FROM [Orders] AS t1\r\n  ) AS t0\r\nGROUP BY [t0].[CustomerID]\n\nSELECT DISTINCT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]\r\nFROM [Orders] AS t0\r\nWHERE (([t0].[CustomerID] IS NULL AND [t1].[CustomerID] IS NULL) OR ([t0].[CustomerID] = [t1].[CustomerID]))";
				Assert.Equal(selectTestsSql.Distinct_GroupBy, result.GetQueryText());
			}

			[Fact]
			public void Distinct_Should_Not_Fail()
			{
				var result = _db.Customers.Distinct();
				
				Assert.Equal(selectTestsSql.Distinct_Should_Not_Fail, result.GetQueryText());
			}

			[Fact]
			public void Distinct_Should_Return_11_For_Scalar_CustomerCity()
			{
				var result = _db.Customers.Select(x => x.City).Distinct();

				Assert.Equal(selectTestsSql.Distinct_Should_Return_11_For_Scalar_CustomerCity, result.GetQueryText());
			}

			[Fact]
			public void Distinct_Should_Return_69_For_Scalar_CustomerCity_Ordered()
			{
				var result = _db.Customers.Select(x => x.City).Distinct().OrderBy(x => x);

				Assert.Equal(selectTestsSql.Distinct_Should_Return_69_For_Scalar_CustomerCity_Ordered, result.GetQueryText());
			}

			//[Fact]
			//public void First_Product_Should_Have_ProductID_1()
			//{
			//  // Hits DB
			//  Assert.True(_db.Products.First().ProductID == 1);
			//}

			[Fact]
			public void GroupBy_Basic()
			{
				var result = _db.Customers.GroupBy(c => c.City);
				Assert.Equal(selectTestsSql.GroupBy_Basic, result.GetQueryText());
			}

			[Fact]
			public void GroupBy_Distinct()
			{
				var result = _db.Orders.GroupBy(o => o.CustomerID).Distinct();
				Assert.Equal(selectTestsSql.GroupBy_Distinct, result.GetQueryText());
			}
			

			[Fact]
			public void GroupBy_SelectMany()
			{
				var result = _db.Customers.GroupBy(c => c.City).SelectMany(x => x);

				Assert.Equal(selectTestsSql.GroupBy_SelectMany, result.GetQueryText());
			}

			[Fact]
			public void GroupBy_Sum()
			{
				var result = _db.Orders.GroupBy(o => o.CustomerID).Select(g =>
																																	new
																																	{
																																		Sum = g.Sum(o => o.OrderID),
																																		Min = g.Min(o => o.OrderID),
																																		Max = g.Max(o => o.OrderID),
																																		Avg = g.Average(o => o.OrderID)
																																	});

				Assert.Equal(selectTestsSql.GroupBy_Sum, result.GetQueryText());
			}

			[Fact]
			public void GroupBy_Sum_With_Element_Selector_Sum_Max()
			{
				var result =
						_db.Orders.GroupBy(o => o.CustomerID, o => o.OrderID).Select(g => new
						{
							Sum = g.Sum(),
							Max = g.Max()
						});

				Assert.Equal(selectTestsSql.GroupBy_Sum_With_Element_Selector_Sum_Max, result.GetQueryText());
			}

			[Fact]
			public void GroupBy_Sum_With_Result_Selector()
			{
				var result = _db.Orders.GroupBy(o => o.CustomerID, (k, g) =>
																													 new
																													 {
																														 Sum = g.Sum(o => o.OrderID),
																														 Min = g.Min(o => o.OrderID),
																														 Max = g.Max(o => o.OrderID),
																														 Avg = g.Average(o => o.OrderID)
																													 });

				Assert.Equal(selectTestsSql.GroupBy_Sum_With_Result_Selector, result.GetQueryText());
			}

			[Fact]
			public void GroupBy_With_Anon_Element()
			{
				var result =
						_db.Orders.GroupBy(o => o.CustomerID, o => new
						{
							o.OrderID
						}).Select(g => g.Sum(x => x.OrderID));

				Assert.Equal(selectTestsSql.GroupBy_With_Anon_Element, result.GetQueryText());
			}

			[Fact]
			public void GroupBy_With_Element_Selector()
			{
				// note: groups are retrieved through a separately execute subquery per row
				var result = _db.Orders.GroupBy(o => o.CustomerID, o => o.OrderID);

				Assert.Equal(selectTestsSql.GroupBy_With_Element_Selector, result.GetQueryText());
			}

			[Fact]
			public void GroupBy_With_Element_Selector_Sum()
			{
				var result = _db.Orders.GroupBy(o => o.CustomerID, o => o.OrderID).Select(g => g.Sum());

				Assert.Equal(selectTestsSql.GroupBy_With_Element_Selector_Sum, result.GetQueryText());
			}

			[Fact]
			public void GroupBy_With_OrderBy()
			{
				var result =
						_db.Orders.OrderBy(o => o.OrderID).GroupBy(o => o.CustomerID).Select(g => g.Sum(o => o.OrderID));

				Assert.Equal(selectTestsSql.GroupBy_With_OrderBy, result.GetQueryText());
			}

			[Fact]
			public void Join_To_Categories()
			{
				var result = from c in _db.Categories
										 join p in _db.Products on c.CategoryID equals p.CategoryID
										 select p;

				Assert.Equal(selectTestsSql.Join_To_Categories, result.GetQueryText());
			}

			[Fact]
			public void OrderBy_CustomerID()
			{
				var result = (from c in _db.Customers
											orderby c.CustomerID
											select c);

				Assert.Equal(selectTestsSql.OrderBy_CustomerID, result.GetQueryText());
			}

			[Fact]
			public void OrderBy_CustomerID_Descending()
			{
				var result = (from c in _db.Customers
											orderby c.CustomerID descending
											select c);

				Assert.Equal(selectTestsSql.OrderBy_CustomerID_Descending, result.GetQueryText());
			}

			[Fact]
			public void OrderBy_CustomerID_Descending_ThenBy_City()
			{
				var result = _db.Customers.OrderByDescending(x => x.CustomerID).ThenBy(x => x.City).Select(x => x.City);

				Assert.Equal(selectTestsSql.OrderBy_CustomerID_Descending_ThenBy_City, result.GetQueryText());
			}

			[Fact]
			public void OrderBy_CustomerID_Descending_ThenByDescending_City()
			{
				var result = _db.Customers.OrderByDescending(x => x.CustomerID).ThenByDescending(x => x.City).Select(x => x.City);

				Assert.Equal(selectTestsSql.OrderBy_CustomerID_Descending_ThenByDescending_City, result.GetQueryText());
			}

			[Fact]
			public void OrderBy_CustomerID_OrderBy_Company_City()
			{
				var result = _db.Customers.OrderBy(x => x.CompanyName).OrderBy(x => x.City).Select(x => x.City);

				Assert.Equal(selectTestsSql.OrderBy_CustomerID_OrderBy_Company_City, result.GetQueryText());
			}

			[Fact]
			public void OrderBy_CustomerID_ThenBy_City()
			{
				var result = _db.Customers.OrderBy(x => x.CustomerID).ThenBy(x => x.City).Select(x => x.City);

				Assert.Equal(selectTestsSql.OrderBy_CustomerID_ThenBy_City, result.GetQueryText());
			}

			[Fact]
			public void OrderBy_CustomerID_With_Select()
			{
				var result = (from c in _db.Customers
											orderby c.CustomerID
											select c).Select(c => c.Address);

				Assert.Equal(selectTestsSql.OrderBy_CustomerID_With_Select, result.GetQueryText());
			}

			[Fact]
			public void OrderBy_Join()
			{
				var result = (from c in _db.Customers.OrderBy(c => c.CustomerID)
											join o in _db.Orders.OrderBy(o => o.OrderID) on c.CustomerID equals o.CustomerID
											select new
											{
												c.CustomerID,
												o.OrderID
											});

				Assert.Equal(selectTestsSql.OrderBy_Join, result.GetQueryText());
			}

			[Fact]
			public void OrderBy_SelectMany()
			{
				var result = (from c in _db.Customers.OrderBy(c => c.CustomerID)
											from o in _db.Orders.OrderBy(o => o.OrderID)
											where c.CustomerID == o.CustomerID
											select new
											{
												c.CustomerID,
												o.OrderID
											});

				Assert.Equal(selectTestsSql.OrderBy_SelectMany, result.GetQueryText());
			}

			[Fact]
			public void Paging_With_Skip_Take()
			{
				var result = _db.Products.Skip(10).Take(20).OrderBy(x => x.ProductID);
				Assert.Equal(selectTestsSql.Paging_With_Skip_Take, result.GetQueryText());
			}

			[Fact]
			public void Paging_With_Take()
			{
				var result = _db.Products.Take(20);
				Assert.Equal(selectTestsSql.Paging_With_Take, result.GetQueryText());
			}

			[Fact]
			public void Select_0_When_Set_False()
			{
				var result = _db.Products.Where(x => false);

				Assert.Equal(selectTestsSql.Select_0_When_Set_False, result.GetQueryText());
			}

			[Fact]
			public void Select_100_When_Set_True()
			{
				var result = _db.Products.Where(x => true);

				Assert.Equal(selectTestsSql.Select_100_When_Set_True, result.GetQueryText());
			}

			[Fact]
			public void Select_Anon_Constant_Int()
			{
				var result = _db.Products.Select(x => 1);

				Assert.Equal(selectTestsSql.Select_Anon_Constant_Int, result.GetQueryText());
			}

			[Fact]
			public void Select_Anon_Constant_NullString()
			{
				var result = _db.Products.Select(x => (string)null);

				Assert.Equal(selectTestsSql.Select_Anon_Constant_NullString, result.GetQueryText());
			}

			[Fact]
			public void Select_Anon_Empty()
			{
				var result = _db.Products.Select(x => new { });

				Assert.Equal(selectTestsSql.Select_Anon_Empty, (result.Provider as IQueryText).GetQueryText(result.Expression));
			}

			[Fact]
			public void Select_Anon_Literal()
			{
				var result = _db.Products.Select(x => new
				{
					Thing = 1
				});

				Assert.Equal(selectTestsSql.Select_Anon_Literal, result.GetQueryText());
			}

			[Fact]
			public void Select_Anon_Nested()
			{
				var result = _db.Products.Select(x => new
				{
					x.ProductName,
					Price = new
					{
						x.UnitPrice
					}
				});

				Assert.Equal(selectTestsSql.Select_Anon_Nested, result.GetQueryText());
			}

			[Fact]
			public void Select_Anon_One()
			{
				var result = _db.Products.Select(x => new
				{
					x.ProductName
				});

				Assert.Equal(selectTestsSql.Select_Anon_One, result.GetQueryText());
			}

			[Fact]
			public void Select_Anon_One_And_Object()
			{
				var result = _db.Products.Select(x => new
				{
					x.ProductName,
					x
				});

				Assert.Equal(selectTestsSql.Select_Anon_One_And_Object, result.GetQueryText());
			}

			[Fact]
			public void Select_Anon_Three()
			{
				var result = _db.Products.Select(x => new
				{
					x.ProductName,
					x.UnitPrice,
					x.Discontinued
				});
				
				Assert.Equal(selectTestsSql.Select_Anon_Three, result.GetQueryText());
			}

			[Fact]
			public void Select_Anon_Two()
			{
				var result = _db.Products.Select(x => new
				{
					x.ProductName,
					x.UnitPrice
				});

				Assert.Equal(selectTestsSql.Select_Anon_Two, result.GetQueryText());
			}

			[Fact]
			public void Select_Anon_With_Local()
			{
				int thing = 10;
				var result = _db.Products.Select(x => thing);

				Assert.Equal(selectTestsSql.Select_Anon_With_Local, result.GetQueryText());
			}

			[Fact]
			public void Select_Nested_Collection()
			{
				var result = from p in _db.Products
										 where p.ProductID == 1
										 select _db.OrderDetails.Where(x => x.ProductID == p.ProductID).Count();

				Assert.Equal(selectTestsSql.Select_Nested_Collection, result.GetQueryText());
			}

			[Fact]
			public void Select_Nested_Collection_With_AnonType()
			{
				var result = from p in _db.Products
										 where p.ProductID == 1
										 select new
										 {
											 Thing = _db.OrderDetails.Where(x => x.ProductID == p.ProductID)
										 };

			Assert.Equal(selectTestsSql.Select_Nested_Collection_With_AnonType, result.GetQueryText());
			}

			[Fact]
			public void Select_On_Self()
			{
				var result = _db.Products.Select(x => x);

				Assert.Equal(selectTestsSql.Select_On_Self, result.GetQueryText());
			}

			[Fact]
			public void Select_Scalar()
			{
				var result = _db.Products.Select(x => x.ProductName);

				Assert.Equal(selectTestsSql.Select_Scalar, result.GetQueryText());
			}

			//[Fact]
			//public void Select_Single_Product_With_ID_1()
			//{
			//  // Hits DB
			//  var result = (from p in _db.Products
			//                where p.ProductID == 1
			//                select p).SingleOrDefault();

			//  Assert.NotNull(result);
			//  Assert.Equal(1, result.ProductID);
			//}

			[Fact]
			public void SelectMany_Customer_Orders()
			{
				var result = from c in _db.Customers
										 from o in _db.Orders
										 where c.CustomerID == o.CustomerID
										 select new
										 {
											 c.ContactName,
											 o.OrderID
										 };

				Assert.Equal(selectTestsSql.SelectMany_Customer_Orders, result.GetQueryText());
			}

			//[Fact]
			//public void Single_Product_Should_Have_ProductID_1()
			//{
			//  // Hits DB
			//  Assert.True(_db.Products.Single(x => x.ProductID == 1).ProductID == 1);
			//}

			//[Fact]
			//public void Sum_No_Args()
			//{
			//  // Hits DB
			//  var result = _db.Orders.Select(o => o.OrderID).Sum();
			//  Assert.Equal(5050, result);
			//}
					
			//[Fact]
			//public void Sum_With_SingleArg()
			//{
			//  // Hits DB
			//  var result = _db.Orders.Sum(x => x.OrderID);
			//  Assert.Equal(5050, result);
			//}

			[Fact]
			public void Where_Resolves_String_EndsWith_Literal()
			{
				var result =
						_db.Customers.Where(c => c.City.EndsWith("10"));

				Assert.Equal(selectTestsSql.Where_Resolves_String_EndsWith_Literal, result.GetQueryText());
			}

			[Fact]
			public void Where_Resolves_String_EndsWith_OtherColumn()
			{
				var result =
						_db.Customers.Where(c => c.ContactName.EndsWith(c.ContactName));

				Assert.Equal(selectTestsSql.Where_Resolves_String_EndsWith_OtherColumn, result.GetQueryText());
			}

			[Fact]
			public void Where_Resolves_String_IsNullOrEmpty()
			{
				var result =
						_db.Customers.Where(c => string.IsNullOrEmpty(c.City));

				Assert.Equal(selectTestsSql.Where_Resolves_String_IsNullOrEmpty, result.GetQueryText());
			}

			[Fact]
			public void Where_Resolves_String_Length()
			{
				var result =
						_db.Customers.Where(c => c.City.Length == 7);

				Assert.Equal(selectTestsSql.Where_Resolves_String_Length, result.GetQueryText());
			}

			[Fact]
			public void Where_Resolves_String_StartsWith_Literal()
			{
				var result =
						_db.Customers.Where(c => c.ContactName.StartsWith("C"));

				Assert.Equal(selectTestsSql.Where_Resolves_String_StartsWith_Literal, result.GetQueryText());
			}

			[Fact]
			public void Where_Resolves_String_StartsWith_OtherColumn()
			{
				var result =
						_db.Customers.Where(c => c.ContactName.StartsWith(c.ContactName));

				Assert.Equal(selectTestsSql.Where_Resolves_String_StartsWith_OtherColumn, result.GetQueryText());
			}
		}
		// ReSharper restore InconsistentNaming
	}
