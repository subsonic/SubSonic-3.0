
namespace SubSonic.Tests.Unit.Linq.SqlStrings
{
	public class Sql2005NumberTestsSql : INumberTestsSql
	{
		#region Properties (52)

		public string And
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (([t0].[OrderID] > 0) AND ([t0].[OrderID] < 2000))";
			}
		}

		public string Coalesce2
		{
			get
			{
				return @"SELECT [t0].[Address], [t0].[City], [t0].[CompanyName], [t0].[ContactName], [t0].[Country], [t0].[CustomerID], [t0].[Region]
FROM [Customers] AS t0
WHERE (COALESCE([t0].[City], [t0].[Country], 'Seattle') = 'Seattle')";
			}
		}

		public string Coalsce
		{
			get
			{
				return @"SELECT [t0].[Address], [t0].[City], [t0].[CompanyName], [t0].[ContactName], [t0].[Country], [t0].[CustomerID], [t0].[Region]
FROM [Customers] AS t0
WHERE (COALESCE([t0].[City], 'Seattle') = 'Seattle')";
			}
		}

		public string Decimal_Add
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (([t0].[OrderID] + 0.0) = 0.0)";
			}
		}

		public string Decimal_Ceiling
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (CEILING([t0].[OrderID]) = 0.0)";
			}
		}

		public string Decimal_Compare
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE ([t0].[OrderID] = 0.0)";
			}
		}

		public string Decimal_Divide
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (([t0].[OrderID] / 1.0) = 1.0)";
			}
		}

		public string Decimal_Floor
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (FLOOR([t0].[OrderID]) = 0.0)";
			}
		}

		public string Decimal_LT
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE ([t0].[OrderID] < 0.0)";
			}
		}

		public string Decimal_Multiply
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (([t0].[OrderID] * 1.0) = 1.0)";
			}
		}

		public string Decimal_Negate
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (-[t0].[OrderID] = 1.0)";
			}
		}

		public string Decimal_Remainder
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (([t0].[OrderID] % 1.0) = 0.0)";
			}
		}

		public string Decimal_RoundDefault
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (ROUND([t0].[OrderID], 0) = 0)";
			}
		}

		public string Decimal_RoundPlaces
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (ROUND([t0].[OrderID], 2) = 0.00)";
			}
		}

		public string Decimal_Subtract
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (([t0].[OrderID] - 0.0) = 0.0)";
			}
		}

		public string Decimal_Truncate
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (ROUND([t0].[OrderID], 0, 1) = 0)";
			}
		}

		public string EqualNull
		{
			get
			{
				return @"SELECT [t0].[Address], [t0].[City], [t0].[CompanyName], [t0].[ContactName], [t0].[Country], [t0].[CustomerID], [t0].[Region]
FROM [Customers] AS t0
WHERE ([t0].[City] IS NULL)";
			}
		}

		public string EqualNullReverse
		{
			get
			{
				return @"SELECT [t0].[Address], [t0].[City], [t0].[CompanyName], [t0].[ContactName], [t0].[Country], [t0].[CustomerID], [t0].[Region]
FROM [Customers] AS t0
WHERE ([t0].[City] IS NULL)";
			}
		}

		public string Int_Add
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (([t0].[OrderID] + 0) = 0)";
			}
		}

		public string Int_BitwiseAnd
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (([t0].[OrderID] & 1) = 0)";
			}
		}

		public string Int_BitwiseNot
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (~[t0].[OrderID] = 0)";
			}
		}

		public string Int_BitwiseOr
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (([t0].[OrderID] | 1) = 1)";
			}
		}

		public string Int_CompareTo
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE ([t0].[OrderID] = 1000)";
			}
		}

		public string Int_Divide
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (([t0].[OrderID] / 1) = 1)";
			}
		}

		public string Int_Equal
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE ([t0].[OrderID] = 0)";
			}
		}

		public string Int_GreaterThan
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE ([t0].[OrderID] > 0)";
			}
		}

		public string Int_GreaterThanOrEqual
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE ([t0].[OrderID] >= 0)";
			}
		}

		public string Int_LeftShift
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (([t0].[OrderID] * POWER(2, 1)) = 0)";
			}
		}

		public string Int_LessThan
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE ([t0].[OrderID] < 0)";
			}
		}

		public string Int_LessThanOrEqual
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE ([t0].[OrderID] <= 0)";
			}
		}

		public string Int_Modulo
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (([t0].[OrderID] % 1) = 0)";
			}
		}

		public string Int_Multiply
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (([t0].[OrderID] * 1) = 1)";
			}
		}

		public string Int_Negate
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (-[t0].[OrderID] = -1)";
			}
		}

		public string Int_NotEqual
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE ([t0].[OrderID] <> 0)";
			}
		}

		public string Int_RightShift
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (([t0].[OrderID] / POWER(2, 1)) = 0)";
			}
		}

		public string Int_Subtract
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (([t0].[OrderID] - 0) = 0)";
			}
		}

		public string Math_Abs
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (ABS([t0].[OrderID]) = 10)";
			}
		}

		public string Math_Atan
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (ATAN([t0].[OrderID]) = 0)";
			}
		}

		public string Math_Atan2
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (ATN2([t0].[OrderID], 3) = 0)";
			}
		}

		public string Math_Ceiling
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (CEILING([t0].[OrderID]) = 0)";
			}
		}

		public string Math_Cos
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (COS([t0].[OrderID]) = 0)";
			}
		}

		public string Math_Floor
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (FLOOR([t0].[OrderID]) = 0)";
			}
		}

		public string Math_Log
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (LOG([t0].[OrderID]) = 0)";
			}
		}

		public string Math_Log10
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (LOG10([t0].[OrderID]) = 0)";
			}
		}

		public string Math_RoundDefault
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (ROUND([t0].[OrderID], 0) = 0)";
			}
		}

		public string Math_RoundToPlace
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (ROUND([t0].[OrderID], 2) = 0)";
			}
		}

		public string Math_Sin
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (SIN([t0].[OrderID]) = 0)";
			}
		}

		public string Math_Sqrt
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (SQRT([t0].[OrderID]) = 0)";
			}
		}

		public string Math_Tan
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (TAN([t0].[OrderID]) = 0)";
			}
		}

		public string Math_Truncate
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (ROUND([t0].[OrderID], 0, 1) = 0)";
			}
		}

		public string Not
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE NOT ([t0].[OrderID] = 0)";
			}
		}

		public string Or
		{
			get
			{
				return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (([t0].[OrderID] < 5) OR ([t0].[OrderID] > 10))";
			}
		}

		#endregion Properties 
	}
}
