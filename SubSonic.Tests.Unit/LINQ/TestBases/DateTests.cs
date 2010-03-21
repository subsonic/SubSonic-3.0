using System;
using System.Linq;
using SubSonic.Tests.Unit.Linq.SqlStrings;
using Xunit;

namespace SubSonic.Tests.Unit.Linq.TestBases
{
	// ReSharper disable InconsistentNaming
	public abstract class DateTests : LinqTestsBase
	{
		protected IDateTestsSql _dateTestsSql;

		[Fact]
		public void DateTime_Day()
		{
			var result = _db.Orders.Where(o => o.OrderDate.Day == 5);

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_dateTestsSql.DateTime_Day, result.GetQueryText());
		}

		[Fact]
		public void DateTime_DayOfWeek()
		{
			var result = _db.Orders.Where(o => o.OrderDate.DayOfWeek == DayOfWeek.Friday);

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_dateTestsSql.DateTime_DayOfWeek, result.GetQueryText());
		}

		[Fact]
		public void DateTime_DayOfYear()
		{
			var result = _db.Orders.Where(o => o.OrderDate.DayOfYear == 360);

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_dateTestsSql.DateTime_DayOfYear, result.GetQueryText());
		}

		[Fact]
		public void DateTime_Hour()
		{
			var result = _db.Orders.Where(o => o.OrderDate.Hour == 6);

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_dateTestsSql.DateTime_Hour, result.GetQueryText());
		}

		[Fact]
		public void DateTime_Millisecond()
		{
			var result = _db.Orders.Where(o => o.OrderDate.Millisecond == 200);

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_dateTestsSql.DateTime_Millisecond, result.GetQueryText());
		}

		[Fact]
		public void DateTime_Minute()
		{
			var result = _db.Orders.Where(o => o.OrderDate.Minute == 32);

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_dateTestsSql.DateTime_Minute, result.GetQueryText());
		}

		[Fact]
		public void DateTime_Month()
		{
			var result = _db.Orders.Where(o => o.OrderDate.Month == 12);

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_dateTestsSql.DateTime_Month, result.GetQueryText());
		}

		[Fact]
		public void DateTime_Second()
		{
			var result = _db.Orders.Where(o => o.OrderDate.Second == 47);

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_dateTestsSql.DateTime_Second, result.GetQueryText());
		}

		[Fact]
		public void DateTime_Year()
		{
			var result = _db.Orders.Where(o => o.OrderDate.Year == 2007);

			AssertEqualIgnoringExtraWhitespaceAndCarriageReturn(_dateTestsSql.DateTime_Year, result.GetQueryText());
		}
	}
	// ReSharper restore InconsistentNaming
}
