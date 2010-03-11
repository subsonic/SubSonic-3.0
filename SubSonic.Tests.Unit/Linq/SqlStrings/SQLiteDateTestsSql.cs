
namespace SubSonic.Tests.Unit.Linq.SqlStrings
{
	public class SQLiteDateTestsSql : IDateTestsSql
	{
		#region Properties (9)

		public string DateTime_Day
		{
			get
			{
				return @"SELECT `t0`.`CustomerID`, `t0`.`OrderDate`, `t0`.`OrderID`, `t0`.`RequiredDate`, `t0`.`ShippedDate`
FROM `Orders` AS t0
WHERE (CAST(strftime('%d',`t0`.`OrderDate`) AS INTEGER) = 5)";
			}
		}

		public string DateTime_DayOfWeek
		{
			get
			{
				return @"SELECT `t0`.`CustomerID`, `t0`.`OrderDate`, `t0`.`OrderID`, `t0`.`RequiredDate`, `t0`.`ShippedDate`
FROM `Orders` AS t0
WHERE (CAST(strftime('%w',`t0`.`OrderDate`) AS INTEGER) = 5)";
			}
		}

		public string DateTime_DayOfYear
		{
			get
			{
				return @"SELECT `t0`.`CustomerID`, `t0`.`OrderDate`, `t0`.`OrderID`, `t0`.`RequiredDate`, `t0`.`ShippedDate`
FROM `Orders` AS t0
WHERE (CAST(DATE( `t0`.`OrderDate`,'MM/DD/YYYY') AS INTEGER) = 360)";
			}
		}

		public string DateTime_Hour
		{
			get
			{
				return @"SELECT `t0`.`CustomerID`, `t0`.`OrderDate`, `t0`.`OrderID`, `t0`.`RequiredDate`, `t0`.`ShippedDate`
FROM `Orders` AS t0
WHERE (CAST(strftime('%H',`t0`.`OrderDate`) AS INTEGER) = 6)";
			}
		}

		public string DateTime_Millisecond
		{
			get
			{
				return @"SELECT `t0`.`CustomerID`, `t0`.`OrderDate`, `t0`.`OrderID`, `t0`.`RequiredDate`, `t0`.`ShippedDate`
FROM `Orders` AS t0
WHERE (CAST(strftime('%f',`t0`.`OrderDate`) AS INTEGER) = 200)";
			}
		}

		public string DateTime_Minute
		{
			get
			{
				return @"SELECT `t0`.`CustomerID`, `t0`.`OrderDate`, `t0`.`OrderID`, `t0`.`RequiredDate`, `t0`.`ShippedDate`
FROM `Orders` AS t0
WHERE (CAST(strftime('%M',`t0`.`OrderDate`) AS INTEGER) = 32)";
			}
		}

		public string DateTime_Month
		{
			get
			{
				return @"SELECT `t0`.`CustomerID`, `t0`.`OrderDate`, `t0`.`OrderID`, `t0`.`RequiredDate`, `t0`.`ShippedDate`
FROM `Orders` AS t0
WHERE (CAST(strftime('%m',`t0`.`OrderDate`) AS INTEGER) = 12)";
			}
		}

		public string DateTime_Second
		{
			get
			{
				return @"SELECT `t0`.`CustomerID`, `t0`.`OrderDate`, `t0`.`OrderID`, `t0`.`RequiredDate`, `t0`.`ShippedDate`
FROM `Orders` AS t0
WHERE (CAST(strftime('%S',`t0`.`OrderDate`) AS INTEGER) = 47)";
			}
		}

		public string DateTime_Year
		{
			get
			{
				return @"SELECT `t0`.`CustomerID`, `t0`.`OrderDate`, `t0`.`OrderID`, `t0`.`RequiredDate`, `t0`.`ShippedDate`
FROM `Orders` AS t0
WHERE (CAST(strftime('%Y',`t0`.`OrderDate`) AS INTEGER) = 2007)";
			}
		}

		#endregion Properties
	}
}
