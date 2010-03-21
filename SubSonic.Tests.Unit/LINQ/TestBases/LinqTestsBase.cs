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

		/// <summary>
		/// Asserts the equality of expected and actual strings ignoring extra whitespace and carriage return.
		/// </summary>
		/// <param name="expected">The expected.</param>
		/// <param name="actual">The actual.</param>
		public void AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(string expected, string actual)
		{
			// Strip extra whitespace and carriage returns
			expected = ReplaceExtraWhitespaceAndCarriageReturn(expected);
			actual = ReplaceExtraWhitespaceAndCarriageReturn(actual);

			Assert.Equal(expected, actual);
		}

		string ReplaceExtraWhitespaceAndCarriageReturn(string input)
		{
			input = Regex.Replace(input, "\\s+", " ");
			return Regex.Replace(input, "\r", "");
		}
	}
}
