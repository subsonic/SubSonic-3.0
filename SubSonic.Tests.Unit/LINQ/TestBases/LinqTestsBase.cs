using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using Xunit;

namespace SubSonic.Tests.Unit.Linq.TestBases
{
	/// <summary>
	/// A base class for all Linq Tests
	/// </summary>
	public abstract class LinqTestsBase
	{
		protected TestDB _db;

		protected static Regex whitespaceRegex = new Regex("\\s+");
		protected static Regex carriageReturnRegex = new Regex("\r");

		/// <summary>
		/// Asserts the equality of expected and actual strings ignoring extra whitespace and carriage return.
		/// </summary>
		/// <param name="expected">The expected.</param>
		/// <param name="actual">The actual.</param>
		public void AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(string expected, string actual)
		{
			// Strip extra whitespace 
			expected = Regex.Replace(expected, "\\s+", " ");
			actual = Regex.Replace(actual, "\\s+", " ");

			// Strip carriage returns
			expected = Regex.Replace(expected, "\r", "");
			actual = Regex.Replace(actual, "\r", "");

			Assert.Equal(expected, actual);
		}
	}
}
