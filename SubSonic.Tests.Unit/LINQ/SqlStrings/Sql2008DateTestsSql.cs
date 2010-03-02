
namespace SubSonic.Tests.Unit.Linq.SqlStrings
{
	public class Sql2008DateTestsSql : IDateTestsSql
	{
		#region Properties (9) 

		public string DateTime_Day
		{
			get { return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (DAY([t0].[OrderDate]) = 5)";
			}
		}

		public string DateTime_DayOfWeek
		{
			get { return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE ((DATEPART(weekday, [t0].[OrderDate]) - 1) = 5)";
			}
		}

		public string DateTime_DayOfYear
		{
			get { return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE ((DATEPART(dayofyear, [t0].[OrderDate]) - 1) = 360)";
			}
		}

		public string DateTime_Hour
		{
			get { return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (DATEPART(hour, [t0].[OrderDate]) = 6)";
			}
		}

		public string DateTime_Millisecond
		{
			get { return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (DATEPART(millisecond, [t0].[OrderDate]) = 200)";
			}
		}

		public string DateTime_Minute
		{
			get { return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (DATEPART(minute, [t0].[OrderDate]) = 32)";
			}
		}

		public string DateTime_Month
		{
			get { return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (MONTH([t0].[OrderDate]) = 12)";
			}
		}

		public string DateTime_Second
		{
			get { return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (DATEPART(second, [t0].[OrderDate]) = 47)";
			}
		}

		public string DateTime_Year
		{
			get { return @"SELECT [t0].[CustomerID], [t0].[OrderDate], [t0].[OrderID], [t0].[RequiredDate], [t0].[ShippedDate]
FROM [Orders] AS t0
WHERE (YEAR([t0].[OrderDate]) = 2007)";
			}
		}

		#endregion Properties 
	}	
}
