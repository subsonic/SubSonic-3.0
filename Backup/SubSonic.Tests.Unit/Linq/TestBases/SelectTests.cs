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
		public abstract class SelectTests : LinqTestsBase
		{
		#region Fields (1) 

			protected ISelectTestsSql _selectTestsSql;

		#endregion Fields 

		#region Methods (58) 

		// Public Methods (58) 

			//[Fact]
			//public void All_With_StartsWith()
			//{
			//  // TODO: Hits DB, need to fix this
			//  var result =
			//      _db.Customers.All(c => c.ContactName.StartsWith("x"));

			//  Assert.False(result);
			//}

			[Fact]
			public void All_With_SubQuery()
			{
			    var result =_db.Customers.Where(
			    c => _db.Orders.Where(o => o.CustomerID == c.CustomerID).All(o => o.OrderDate > new DateTime(2008, 5, 1)));

			    AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.All_With_SubQuery, result.GetQueryText());
			}

			//[Fact]
			//public void Any_Should_Not_Fail()
			//{
			//  // TODO: Hits DB, need to fix this
			//  Assert.True(_db.Products.Any(x => x.ProductID == 1));
			//}
			[Fact]
			public void Any_With_Collection()
			{
				string[] ids = new[] { "TEST1", "TEST2" };
				var result = _db.Customers.Where(c => ids.Any(id => c.CustomerID == id));
			
				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Any_With_Collection, result.GetQueryText());
			}

			[Fact]
			public void Any_With_Collection_One_False()
			{
				string[] ids = new[] { "ABCDE", "TEST1" };
				var result = _db.Customers.Where(c => ids.Any(id => c.CustomerID == id));
				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Any_With_Collection_One_False, result.GetQueryText());
			}

			[Fact]
			public void Contains_Resolves_Literal()
			{
				var result =
						_db.Customers.Where(x => x.ContactName.Contains("har"));
				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Contains_Resolves_Literal, result.GetQueryText());
			}

			[Fact]
			public void Contains_With_LocalCollection_2_True()
			{
				string[] ids = new[] { "TEST2", "TEST1" };
				var result =
						_db.Customers.Where(c => ids.Contains(c.CustomerID));
				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Contains_With_LocalCollection_2_True, result.GetQueryText());
			}

			[Fact]
			public void Contains_With_LocalCollection_OneFalse()
			{
				string[] ids = new[] { "ABCDE", "TEST1" };
				var result =
						_db.Customers.Where(c => ids.Contains(c.CustomerID));
				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Contains_With_LocalCollection_OneFalse, result.GetQueryText());
			}

			[Fact]
			public void Contains_With_Subquery()
			{
				var result =
						_db.Customers.Where(c => _db.Orders.Select(o => o.CustomerID).Contains(c.CustomerID));
				
				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Contains_With_Subquery, result.GetQueryText());
			}

			[Fact]
			public void Count_Distinct()
			{
				var result = _db.Customers.Select(c => c.City).Distinct();
				
				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Count_Distinct, result.GetQueryText());
			}

			//[Fact]
			//public void Count_Distinct_With_Arg()
			//{
			//  // TODO: Hits DB, need to fix this
			//  var result = _db.Customers.Distinct().Count(x => x.CustomerID == "TEST1");

			//  AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(1, result);
			//}
			[Fact]
			public void Count_No_Args()
			{
				var result = _db.Orders.Select(o => o.OrderID);
				
				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Count_No_Args, result.GetQueryText());
			}

			//[Fact]
			//public void Count_With_SingleArg()
			//{
			//  // TODO: Hits DB, need to fix this
			//  var result = _db.Orders.Count(x => x.OrderID > 0);
			//  AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(100, result);
			//}
			[Fact]
			public void Distinct_GroupBy()
			{
				var result = _db.Orders.Distinct().GroupBy(o => o.CustomerID);
				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Distinct_GroupBy, result.GetQueryText());
			}

			[Fact]
			public void Distinct_Should_Not_Fail()
			{
				var result = _db.Customers.Distinct();
				
				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Distinct_Should_Not_Fail, result.GetQueryText());
			}

			[Fact]
			public void Distinct_Should_Return_11_For_Scalar_CustomerCity()
			{
				var result = _db.Customers.Select(x => x.City).Distinct();

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Distinct_Should_Return_11_For_Scalar_CustomerCity, result.GetQueryText());
			}

			[Fact]
			public void Distinct_Should_Return_69_For_Scalar_CustomerCity_Ordered()
			{
				var result = _db.Customers.Select(x => x.City).Distinct().OrderBy(x => x);

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Distinct_Should_Return_69_For_Scalar_CustomerCity_Ordered, result.GetQueryText());
			}

			//[Fact]
			//public void First_Product_Should_Have_ProductID_1()
			//{
			//  // TODO: Hits DB, need to fix this
			//  Assert.True(_db.Products.First().ProductID == 1);
			//}
			[Fact]
			public void GroupBy_Basic()
			{
				var result = _db.Customers.GroupBy(c => c.City);
				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.GroupBy_Basic, result.GetQueryText());
			}

			[Fact]
			public void GroupBy_Distinct()
			{
				var result = _db.Orders.GroupBy(o => o.CustomerID).Distinct();
				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.GroupBy_Distinct, result.GetQueryText());
			}

			[Fact]
			public void GroupBy_SelectMany()
			{
				var result = _db.Customers.GroupBy(c => c.City).SelectMany(x => x);

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.GroupBy_SelectMany, result.GetQueryText());
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

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.GroupBy_Sum, result.GetQueryText());
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

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.GroupBy_Sum_With_Element_Selector_Sum_Max, result.GetQueryText());
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

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.GroupBy_Sum_With_Result_Selector, result.GetQueryText());
			}

			[Fact]
			public void GroupBy_With_Anon_Element()
			{
				var result =
						_db.Orders.GroupBy(o => o.CustomerID, o => new
						{
							o.OrderID
						}).Select(g => g.Sum(x => x.OrderID));

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.GroupBy_With_Anon_Element, result.GetQueryText());
			}

			[Fact]
			public void GroupBy_With_Element_Selector()
			{
				// note: groups are retrieved through a separately execute subquery per row
				var result = _db.Orders.GroupBy(o => o.CustomerID, o => o.OrderID);

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.GroupBy_With_Element_Selector, result.GetQueryText());
			}

			[Fact]
			public void GroupBy_With_Element_Selector_Sum()
			{
				var result = _db.Orders.GroupBy(o => o.CustomerID, o => o.OrderID).Select(g => g.Sum());

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.GroupBy_With_Element_Selector_Sum, result.GetQueryText());
			}

			[Fact]
			public void GroupBy_With_OrderBy()
			{
				var result =
						_db.Orders.OrderBy(o => o.OrderID).GroupBy(o => o.CustomerID).Select(g => g.Sum(o => o.OrderID));

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.GroupBy_With_OrderBy, result.GetQueryText());
			}

			[Fact]
			public void Join_To_Categories()
			{
				var result = from c in _db.Categories
										 join p in _db.Products on c.CategoryID equals p.CategoryID
										 select p;

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Join_To_Categories, result.GetQueryText());
			}

			[Fact]
			public void OrderBy_CustomerID()
			{
				var result = (from c in _db.Customers
											orderby c.CustomerID
											select c);

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.OrderBy_CustomerID, result.GetQueryText());
			}

			[Fact]
			public void OrderBy_CustomerID_Descending()
			{
				var result = (from c in _db.Customers
											orderby c.CustomerID descending
											select c);

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.OrderBy_CustomerID_Descending, result.GetQueryText());
			}

			[Fact]
			public void OrderBy_CustomerID_Descending_ThenBy_City()
			{
				var result = _db.Customers.OrderByDescending(x => x.CustomerID).ThenBy(x => x.City).Select(x => x.City);

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.OrderBy_CustomerID_Descending_ThenBy_City, result.GetQueryText());
			}

			[Fact]
			public void OrderBy_CustomerID_Descending_ThenByDescending_City()
			{
				var result = _db.Customers.OrderByDescending(x => x.CustomerID).ThenByDescending(x => x.City).Select(x => x.City);

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.OrderBy_CustomerID_Descending_ThenByDescending_City, result.GetQueryText());
			}

			[Fact]
			public void OrderBy_CustomerID_OrderBy_Company_City()
			{
				var result = _db.Customers.OrderBy(x => x.CompanyName).OrderBy(x => x.City).Select(x => x.City);

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.OrderBy_CustomerID_OrderBy_Company_City, result.GetQueryText());
			}

			[Fact]
			public void OrderBy_CustomerID_ThenBy_City()
			{
				var result = _db.Customers.OrderBy(x => x.CustomerID).ThenBy(x => x.City).Select(x => x.City);

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.OrderBy_CustomerID_ThenBy_City, result.GetQueryText());
			}

			[Fact]
			public void OrderBy_CustomerID_With_Select()
			{
				var result = (from c in _db.Customers
											orderby c.CustomerID
											select c).Select(c => c.Address);

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.OrderBy_CustomerID_With_Select, result.GetQueryText());
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

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.OrderBy_Join, result.GetQueryText());
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

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.OrderBy_SelectMany, result.GetQueryText());
			}

			[Fact]
			public void Paging_With_Skip_Take()
			{
				var result = _db.Products.Skip(10).Take(20).OrderBy(x => x.ProductID);
				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Paging_With_Skip_Take, result.GetQueryText());
			}

			[Fact]
			public void Paging_With_Take()
			{
				var result = _db.Products.Take(20);
				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Paging_With_Take, result.GetQueryText());
			}

			[Fact]
			public void Select_0_When_Set_False()
			{
				var result = _db.Products.Where(x => false);

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Select_0_When_Set_False, result.GetQueryText());
			}

			[Fact]
			public void Select_100_When_Set_True()
			{
				var result = _db.Products.Where(x => true);

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Select_100_When_Set_True, result.GetQueryText());
			}

			[Fact]
			public void Select_Anon_Constant_Int()
			{
				var result = _db.Products.Select(x => 1);

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Select_Anon_Constant_Int, result.GetQueryText());
			}

			[Fact]
			public void Select_Anon_Constant_NullString()
			{
				var result = _db.Products.Select(x => (string)null);

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Select_Anon_Constant_NullString, result.GetQueryText());
			}

			[Fact]
			public void Select_Anon_Empty()
			{
				var result = _db.Products.Select(x => new { });

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Select_Anon_Empty, (result.Provider as IQueryText).GetQueryText(result.Expression));
			}

			[Fact]
			public void Select_Anon_Literal()
			{
				var result = _db.Products.Select(x => new
				{
					Thing = 1
				});

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Select_Anon_Literal, result.GetQueryText());
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

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Select_Anon_Nested, result.GetQueryText());
			}

			[Fact]
			public void Select_Anon_One()
			{
				var result = _db.Products.Select(x => new
				{
					x.ProductName
				});

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Select_Anon_One, result.GetQueryText());
			}

			[Fact]
			public void Select_Anon_One_And_Object()
			{
				var result = _db.Products.Select(x => new
				{
					x.ProductName,
					x
				});

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Select_Anon_One_And_Object, result.GetQueryText());
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
				
				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Select_Anon_Three, result.GetQueryText());
			}

			[Fact]
			public void Select_Anon_Two()
			{
				var result = _db.Products.Select(x => new
				{
					x.ProductName,
					x.UnitPrice
				});

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Select_Anon_Two, result.GetQueryText());
			}

			[Fact]
			public void Select_Anon_With_Local()
			{
				int thing = 10;
				var result = _db.Products.Select(x => thing);

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Select_Anon_With_Local, result.GetQueryText());
			}

			[Fact]
			public void Select_Nested_Collection()
			{
				var result = from p in _db.Products
										 where p.ProductID == 1
										 select _db.OrderDetails.Where(x => x.ProductID == p.ProductID).Count();

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Select_Nested_Collection, result.GetQueryText());
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

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Select_Nested_Collection_With_AnonType, result.GetQueryText());
			}

			[Fact]
			public void Select_On_Self()
			{
				var result = _db.Products.Select(x => x);

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Select_On_Self, result.GetQueryText());
			}

			[Fact]
			public void Select_Scalar()
			{
				var result = _db.Products.Select(x => x.ProductName);

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Select_Scalar, result.GetQueryText());
			}

			//[Fact]
			//public void Select_Single_Product_With_ID_1()
			//{
			//  // TODO: Hits DB, need to fix this
			//  var result = (from p in _db.Products
			//                where p.ProductID == 1
			//                select p).SingleOrDefault();

			//  Assert.NotNull(result);
			//  AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(1, result.ProductID);
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

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.SelectMany_Customer_Orders, result.GetQueryText());
			}

			//[Fact]
			//public void Single_Product_Should_Have_ProductID_1()
			//{
			//  // TODO: Hits DB, need to fix this
			//  Assert.True(_db.Products.Single(x => x.ProductID == 1).ProductID == 1);
			//}
			//[Fact]
			//public void Sum_No_Args()
			//{
			//  // TODO: Hits DB, need to fix this
			//  var result = _db.Orders.Select(o => o.OrderID).Sum();
			//  AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(5050, result);
			//}
			//[Fact]
			//public void Sum_With_SingleArg()
			//{
			//  // TODO: Hits DB, need to fix this
			//  var result = _db.Orders.Sum(x => x.OrderID);
			//  AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(5050, result);
			//}
			[Fact]
			public void Where_Resolves_String_EndsWith_Literal()
			{
				var result =
						_db.Customers.Where(c => c.City.EndsWith("10"));

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Where_Resolves_String_EndsWith_Literal, result.GetQueryText());
			}

			[Fact]
			public void Where_Resolves_String_EndsWith_OtherColumn()
			{
				var result =
						_db.Customers.Where(c => c.ContactName.EndsWith(c.ContactName));

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Where_Resolves_String_EndsWith_OtherColumn, result.GetQueryText());
			}

			[Fact]
			public void Where_Resolves_String_IsNullOrEmpty()
			{
				var result =
						_db.Customers.Where(c => string.IsNullOrEmpty(c.City));

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Where_Resolves_String_IsNullOrEmpty, result.GetQueryText());
			}

			[Fact]
			public void Where_Resolves_String_Length()
			{
				var result =
						_db.Customers.Where(c => c.City.Length == 7);

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Where_Resolves_String_Length, result.GetQueryText());
			}

			[Fact]
			public void Where_Resolves_String_StartsWith_Literal()
			{
				var result =
						_db.Customers.Where(c => c.ContactName.StartsWith("C"));

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Where_Resolves_String_StartsWith_Literal, result.GetQueryText());
			}

			[Fact]
			public void Where_Resolves_String_StartsWith_OtherColumn()
			{
				var result =
						_db.Customers.Where(c => c.ContactName.StartsWith(c.ContactName));

				AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_selectTestsSql.Where_Resolves_String_StartsWith_OtherColumn, result.GetQueryText());
			}

		#endregion Methods 
		}
		// ReSharper restore InconsistentNaming
	}
