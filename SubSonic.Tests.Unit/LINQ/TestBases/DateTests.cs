using System;
using System.Linq;
using SubSonic.Tests.Unit.Linq.SqlStrings;
using Xunit;

namespace SubSonic.Tests.Unit.Linq.TestBases
{
	// ReSharper disable InconsistentNaming
	public abstract class DateTests
	{
		protected TestDB _db;
		protected IDateTestsSql dateTestsSql;

		[Fact]
		public void DateTime_Day()
		{
			var result = _db.Orders.Where(o => o.OrderDate.Day == 5);

			Assert.Equal(dateTestsSql.DateTime_Day, result.GetQueryText());
		}

		[Fact]
		public void DateTime_DayOfWeek()
		{
			var result = _db.Orders.Where(o => o.OrderDate.DayOfWeek == DayOfWeek.Friday);

			Assert.Equal(dateTestsSql.DateTime_DayOfWeek, result.GetQueryText());
		}

		[Fact]
		public void DateTime_DayOfYear()
		{
			var result = _db.Orders.Where(o => o.OrderDate.DayOfYear == 360);

			Assert.Equal(dateTestsSql.DateTime_DayOfYear, result.GetQueryText());
		}

		[Fact]
		public void DateTime_Hour()
		{
			var result = _db.Orders.Where(o => o.OrderDate.Hour == 6);

			Assert.Equal(dateTestsSql.DateTime_Hour, result.GetQueryText());
		}

		[Fact]
		public void DateTime_Millisecond()
		{
			var result = _db.Orders.Where(o => o.OrderDate.Millisecond == 200);

			Assert.Equal(dateTestsSql.DateTime_Millisecond, result.GetQueryText());
		}

		[Fact]
		public void DateTime_Minute()
		{
			var result = _db.Orders.Where(o => o.OrderDate.Minute == 32);

			Assert.Equal(dateTestsSql.DateTime_Minute, result.GetQueryText());
		}

		[Fact]
		public void DateTime_Month()
		{
			var result = _db.Orders.Where(o => o.OrderDate.Month == 12);

			Assert.Equal(dateTestsSql.DateTime_Month, result.GetQueryText());
		}

		[Fact]
		public void DateTime_Second()
		{
			var result = _db.Orders.Where(o => o.OrderDate.Second == 47);

			Assert.Equal(dateTestsSql.DateTime_Second, result.GetQueryText());
		}

		[Fact]
		public void DateTime_Year()
		{
			var result = _db.Orders.Where(o => o.OrderDate.Year == 2007);

			Assert.Equal(dateTestsSql.DateTime_Year, result.GetQueryText());
		}
	}
	// ReSharper restore InconsistentNaming
}
