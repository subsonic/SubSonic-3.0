using System.Linq;
using SubSonic.Tests.Unit.Linq.SqlStrings;
using Xunit;

namespace SubSonic.Tests.Unit.Linq.TestBases
{
	// ReSharper disable InconsistentNaming
	public abstract class StringTests : LinqTestsBase
	{
		#region Fields (1) 

		protected IStringTestsSql _stringTestsSql;

		#endregion Fields 

		#region Methods (22) 

		// Public Methods (22) 

		[Fact]
		public void String_CompareEQ()
		{
			var result = _db.Customers.Where(c => string.Compare(c.City, "City1") == 0);

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_stringTestsSql.String_CompareEQ, result.GetQueryText());
		}

		[Fact]
		public void String_CompareGE()
		{
			var result = _db.Customers.Where(c => string.Compare(c.City, "City1") >= 0);

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_stringTestsSql.String_CompareGE, result.GetQueryText());
		}

		[Fact]
		public void String_CompareGT()
		{
			var result = _db.Customers.Where(c => string.Compare(c.City, "City1") > 0);

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_stringTestsSql.String_CompareGT, result.GetQueryText());
		}

		[Fact]
		public void String_CompareLE()
		{
			var result = _db.Customers.Where(c => string.Compare(c.City, "City1") <= 0);
		
			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_stringTestsSql.String_CompareLE, result.GetQueryText());
		}

		[Fact]
		public void String_CompareLT()
		{
			var result = _db.Customers.Where(c => string.Compare(c.City, "City1") < 0);

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_stringTestsSql.String_CompareLT, result.GetQueryText());
		}

		[Fact]
		public void String_CompareNE()
		{
			var result = _db.Customers.Where(c => string.Compare(c.City, "City1") != 0);

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_stringTestsSql.String_CompareNE, result.GetQueryText());
		}

		[Fact]
		public void String_CompareToEQ()
		{
			var result = _db.Customers.Where(c => c.City.CompareTo("City1") == 0);

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_stringTestsSql.String_CompareToEQ, result.GetQueryText());
		}

		[Fact]
		public void String_CompareToGE()
		{
			var result = _db.Customers.Where(c => c.City.CompareTo("City1") >= 0);

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_stringTestsSql.String_CompareToGE, result.GetQueryText());
		}

		[Fact]
		public void String_CompareToGT()
		{
			var result = _db.Customers.Where(c => c.City.CompareTo("City1") > 0);

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_stringTestsSql.String_CompareToGT, result.GetQueryText());
		}

		[Fact]
		public void String_CompareToLE()
		{
			var result = _db.Customers.Where(c => c.City.CompareTo("City1") <= 0);

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_stringTestsSql.String_CompareToLE, result.GetQueryText());
		}

		[Fact]
		public void String_CompareToLT()
		{
			var result = _db.Customers.Where(c => c.City.CompareTo("City1") < 0);

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_stringTestsSql.String_CompareToLT, result.GetQueryText());
		}

		[Fact]
		public void String_CompareToNE()
		{
			var result = _db.Customers.Where(c => c.City.CompareTo("City1") != 0);

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_stringTestsSql.String_CompareToNE, result.GetQueryText());
		}

		[Fact]
		public void String_IndexOf()
		{
			var result = _db.Customers.Where(c => c.City.IndexOf("ty") == 4);

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_stringTestsSql.String_IndexOf, result.GetQueryText());
		}

		[Fact]
		public void String_IndexOfChar()
		{
			var result = _db.Customers.Where(c => c.City.IndexOf('t') == 3);

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_stringTestsSql.String_IndexOfChar, result.GetQueryText());
		}

		[Fact]
		public void String_IsNullOrEmpty()
		{
			var result = _db.Customers.Where(c => string.IsNullOrEmpty(c.City));

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_stringTestsSql.String_IsNullOrEmpty, result.GetQueryText());
		}

		[Fact]
		public void String_Replace()
		{
			var result = _db.Customers.Where(c => c.City.Replace("it", "ti") == "Ctiy1");

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_stringTestsSql.String_Replace, result.GetQueryText());
		}

		[Fact]
		public void String_ReplaceChars()
		{
			var result = _db.Customers.Where(c => c.City.Replace("y", "ee") == "Citee");

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_stringTestsSql.String_ReplaceChars, result.GetQueryText());
		}

		[Fact]
		public void String_Substring()
		{
			var result = _db.Customers.Where(c => c.City.Substring(0, 4) == "City");

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_stringTestsSql.String_Substring, result.GetQueryText());
		}

		[Fact]
		public void String_ToLower()
		{
			var result = _db.Customers.Where(c => c.City.ToLower() == "city1");

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_stringTestsSql.String_ToLower, result.GetQueryText());
		}

		[Fact]
		public void String_ToString()
		{
			// just to prove this is a no op
			var result = _db.Customers.Where(c => c.City.ToString() == "City1");

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_stringTestsSql.String_ToString, result.GetQueryText());
		}

		[Fact]
		public void String_ToUpper()
		{
			var result = _db.Customers.Where(c => c.City.ToUpper() == "CITY1");

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_stringTestsSql.String_ToUpper, result.GetQueryText());
		}

		[Fact]
		public void String_Trim()
		{
			var result = _db.Customers.Where(c => c.City.Trim() == "City1");

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_stringTestsSql.String_Trim, result.GetQueryText());
		}

		#endregion Methods 
	}

	// ReSharper restore InconsistentNaming
}
