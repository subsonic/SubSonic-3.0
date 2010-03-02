
namespace SubSonic.Tests.Unit.Linq.SqlStrings
{
	public class SQLiteStringTestsSql : IStringTestsSql
	{
		#region Properties (22)

		public string String_CompareEQ
		{
			get
			{
				return @"SELECT `t0`.`Address`, `t0`.`City`, `t0`.`CompanyName`, `t0`.`ContactName`, `t0`.`Country`, `t0`.`CustomerID`, `t0`.`Region`
FROM `Customers` AS t0
WHERE (`t0`.`City` = 'City1')";
			}
		}

		public string String_CompareGE
		{
			get
			{
				return @"SELECT `t0`.`Address`, `t0`.`City`, `t0`.`CompanyName`, `t0`.`ContactName`, `t0`.`Country`, `t0`.`CustomerID`, `t0`.`Region`
FROM `Customers` AS t0
WHERE (`t0`.`City` >= 'City1')";
			}
		}

		public string String_CompareGT
		{
			get
			{
				return @"SELECT `t0`.`Address`, `t0`.`City`, `t0`.`CompanyName`, `t0`.`ContactName`, `t0`.`Country`, `t0`.`CustomerID`, `t0`.`Region`
FROM `Customers` AS t0
WHERE (`t0`.`City` > 'City1')";
			}
		}

		public string String_CompareLE
		{
			get
			{
				return @"SELECT `t0`.`Address`, `t0`.`City`, `t0`.`CompanyName`, `t0`.`ContactName`, `t0`.`Country`, `t0`.`CustomerID`, `t0`.`Region`
FROM `Customers` AS t0
WHERE (`t0`.`City` <= 'City1')";
			}
		}

		public string String_CompareLT
		{
			get
			{
				return @"SELECT `t0`.`Address`, `t0`.`City`, `t0`.`CompanyName`, `t0`.`ContactName`, `t0`.`Country`, `t0`.`CustomerID`, `t0`.`Region`
FROM `Customers` AS t0
WHERE (`t0`.`City` < 'City1')";
			}
		}

		public string String_CompareNE
		{
			get
			{
				return @"SELECT `t0`.`Address`, `t0`.`City`, `t0`.`CompanyName`, `t0`.`ContactName`, `t0`.`Country`, `t0`.`CustomerID`, `t0`.`Region`
FROM `Customers` AS t0
WHERE (`t0`.`City` <> 'City1')";
			}
		}

		public string String_CompareToEQ
		{
			get
			{
				return @"SELECT `t0`.`Address`, `t0`.`City`, `t0`.`CompanyName`, `t0`.`ContactName`, `t0`.`Country`, `t0`.`CustomerID`, `t0`.`Region`
FROM `Customers` AS t0
WHERE (`t0`.`City` = 'City1')";
			}
		}

		public string String_CompareToGE
		{
			get
			{
				return @"SELECT `t0`.`Address`, `t0`.`City`, `t0`.`CompanyName`, `t0`.`ContactName`, `t0`.`Country`, `t0`.`CustomerID`, `t0`.`Region`
FROM `Customers` AS t0
WHERE (`t0`.`City` >= 'City1')";
			}
		}

		public string String_CompareToGT
		{
			get
			{
				return @"SELECT `t0`.`Address`, `t0`.`City`, `t0`.`CompanyName`, `t0`.`ContactName`, `t0`.`Country`, `t0`.`CustomerID`, `t0`.`Region`
FROM `Customers` AS t0
WHERE (`t0`.`City` > 'City1')";
			}
		}

		public string String_CompareToLE
		{
			get
			{
				return @"SELECT `t0`.`Address`, `t0`.`City`, `t0`.`CompanyName`, `t0`.`ContactName`, `t0`.`Country`, `t0`.`CustomerID`, `t0`.`Region`
FROM `Customers` AS t0
WHERE (`t0`.`City` <= 'City1')";
			}
		}

		public string String_CompareToLT
		{
			get
			{
				return @"SELECT `t0`.`Address`, `t0`.`City`, `t0`.`CompanyName`, `t0`.`ContactName`, `t0`.`Country`, `t0`.`CustomerID`, `t0`.`Region`
FROM `Customers` AS t0
WHERE (`t0`.`City` < 'City1')";
			}
		}

		public string String_CompareToNE
		{
			get
			{
				return @"SELECT `t0`.`Address`, `t0`.`City`, `t0`.`CompanyName`, `t0`.`ContactName`, `t0`.`Country`, `t0`.`CustomerID`, `t0`.`Region`
FROM `Customers` AS t0
WHERE (`t0`.`City` <> 'City1')";
			}
		}

		public string String_IndexOf
		{
			get
			{
				return @"SELECT `t0`.`Address`, `t0`.`City`, `t0`.`CompanyName`, `t0`.`ContactName`, `t0`.`Country`, `t0`.`CustomerID`, `t0`.`Region`
FROM `Customers` AS t0
WHERE ((CHARINDEX(`t0`.`City`, 'ty') - 1) = 4)";
			}
		}

		public string String_IndexOfChar
		{
			get
			{
				return @"SELECT `t0`.`Address`, `t0`.`City`, `t0`.`CompanyName`, `t0`.`ContactName`, `t0`.`Country`, `t0`.`CustomerID`, `t0`.`Region`
FROM `Customers` AS t0
WHERE ((CHARINDEX(`t0`.`City`, t) - 1) = 3)";
			}
		}

		public string String_IsNullOrEmpty
		{
			get
			{
				return @"SELECT `t0`.`Address`, `t0`.`City`, `t0`.`CompanyName`, `t0`.`ContactName`, `t0`.`Country`, `t0`.`CustomerID`, `t0`.`Region`
FROM `Customers` AS t0
WHERE (`t0`.`City` IS NULL OR `t0`.`City` = '')";
			}
		}

		public string String_Replace
		{
			get
			{
				return @"SELECT `t0`.`Address`, `t0`.`City`, `t0`.`CompanyName`, `t0`.`ContactName`, `t0`.`Country`, `t0`.`CustomerID`, `t0`.`Region`
FROM `Customers` AS t0
WHERE (REPLACE(`t0`.`City`, 'it', 'ti') = 'Ctiy1')";
			}
		}

		public string String_ReplaceChars
		{
			get
			{
				return @"SELECT `t0`.`Address`, `t0`.`City`, `t0`.`CompanyName`, `t0`.`ContactName`, `t0`.`Country`, `t0`.`CustomerID`, `t0`.`Region`
FROM `Customers` AS t0
WHERE (REPLACE(`t0`.`City`, 'y', 'ee') = 'Citee')";
			}
		}

		public string String_Substring
		{
			get
			{
				return @"SELECT `t0`.`Address`, `t0`.`City`, `t0`.`CompanyName`, `t0`.`ContactName`, `t0`.`Country`, `t0`.`CustomerID`, `t0`.`Region`
FROM `Customers` AS t0
WHERE (SUBSTR(`t0`.`City`, 0 + 1, 4) = 'City')";
			}
		}

		public string String_ToLower
		{
			get
			{
				return @"SELECT `t0`.`Address`, `t0`.`City`, `t0`.`CompanyName`, `t0`.`ContactName`, `t0`.`Country`, `t0`.`CustomerID`, `t0`.`Region`
FROM `Customers` AS t0
WHERE (LOWER(`t0`.`City`) = 'city1')";
			}
		}

		public string String_ToString
		{
			get
			{
				return @"SELECT `t0`.`Address`, `t0`.`City`, `t0`.`CompanyName`, `t0`.`ContactName`, `t0`.`Country`, `t0`.`CustomerID`, `t0`.`Region`
FROM `Customers` AS t0
WHERE (`t0`.`City` = 'City1')";
			}
		}

		public string String_ToUpper
		{
			get
			{
				return @"SELECT `t0`.`Address`, `t0`.`City`, `t0`.`CompanyName`, `t0`.`ContactName`, `t0`.`Country`, `t0`.`CustomerID`, `t0`.`Region`
FROM `Customers` AS t0
WHERE (UPPER(`t0`.`City`) = 'CITY1')";
			}
		}

		public string String_Trim
		{
			get
			{
				return @"SELECT `t0`.`Address`, `t0`.`City`, `t0`.`CompanyName`, `t0`.`ContactName`, `t0`.`Country`, `t0`.`CustomerID`, `t0`.`Region`
FROM `Customers` AS t0
WHERE (RTRIM(LTRIM(`t0`.`City`)) = 'City1')";
			}
		}

		#endregion Properties
	}
}
