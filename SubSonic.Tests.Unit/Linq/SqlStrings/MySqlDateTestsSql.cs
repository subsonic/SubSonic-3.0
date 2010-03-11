
namespace SubSonic.Tests.Unit.Linq.SqlStrings
{
	public class MySqlDateTestsSql : IDateTestsSql
	{
		#region Properties (9)

		public string DateTime_Day
		{
			get
			{
				return @"SELECT `t0`.`CustomerID`, `t0`.`OrderDate`, `t0`.`OrderID`, `t0`.`RequiredDate`, `t0`.`ShippedDate`
FROM `Orders` AS t0
WHERE (DAY(`t0`.`OrderDate`) = 5)";
			}
		}

		public string DateTime_DayOfWeek
		{
			get
			{
				return @"SELECT `t0`.`CustomerID`, `t0`.`OrderDate`, `t0`.`OrderID`, `t0`.`RequiredDate`, `t0`.`ShippedDate`
FROM `Orders` AS t0
WHERE ((DAYOFWEEK(`t0`.`OrderDate`) - 1) = 5)";
			}
		}

		public string DateTime_DayOfYear
		{
			get
			{
				return @"SELECT `t0`.`CustomerID`, `t0`.`OrderDate`, `t0`.`OrderID`, `t0`.`RequiredDate`, `t0`.`ShippedDate`
FROM `Orders` AS t0
WHERE ((DAYOFYEAR( `t0`.`OrderDate`) - 1) = 360)";
			}
		}

		public string DateTime_Hour
		{
			get
			{
				return @"SELECT `t0`.`CustomerID`, `t0`.`OrderDate`, `t0`.`OrderID`, `t0`.`RequiredDate`, `t0`.`ShippedDate`
FROM `Orders` AS t0
WHERE (HOUR( `t0`.`OrderDate`) = 6)";
			}
		}

		public string DateTime_Millisecond
		{
			get
			{
				return @"SELECT `t0`.`CustomerID`, `t0`.`OrderDate`, `t0`.`OrderID`, `t0`.`RequiredDate`, `t0`.`ShippedDate`
FROM `Orders` AS t0
WHERE (MICROSECOND( `t0`.`OrderDate`) = 200)";
			}
		}

		public string DateTime_Minute
		{
			get
			{
				return @"SELECT `t0`.`CustomerID`, `t0`.`OrderDate`, `t0`.`OrderID`, `t0`.`RequiredDate`, `t0`.`ShippedDate`
FROM `Orders` AS t0
WHERE (MINUTE( `t0`.`OrderDate`) = 32)";
			}
		}

		public string DateTime_Month
		{
			get
			{
				return @"SELECT `t0`.`CustomerID`, `t0`.`OrderDate`, `t0`.`OrderID`, `t0`.`RequiredDate`, `t0`.`ShippedDate`
FROM `Orders` AS t0
WHERE (MONTH(`t0`.`OrderDate`) = 12)";
			}
		}

		public string DateTime_Second
		{
			get
			{
				return @"SELECT `t0`.`CustomerID`, `t0`.`OrderDate`, `t0`.`OrderID`, `t0`.`RequiredDate`, `t0`.`ShippedDate`
FROM `Orders` AS t0
WHERE (SECOND( `t0`.`OrderDate`) = 47)";
			}
		}

		public string DateTime_Year
		{
			get
			{
				return @"SELECT `t0`.`CustomerID`, `t0`.`OrderDate`, `t0`.`OrderID`, `t0`.`RequiredDate`, `t0`.`ShippedDate`
FROM `Orders` AS t0
WHERE (YEAR(`t0`.`OrderDate`) = 2007)";
			}
		}

		#endregion Properties 
	}
}

