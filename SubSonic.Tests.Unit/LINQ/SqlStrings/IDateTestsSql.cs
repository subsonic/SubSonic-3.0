using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SubSonic.Tests.Unit.LINQ.SqlStrings
{
	public interface IDateTestsSql
	{
		string DateTime_Day { get; }
		string DateTime_DayOfWeek { get; }
		string DateTime_DayOfYear { get; }
		string DateTime_Hour { get; }
		string DateTime_Millisecond { get; }
		string DateTime_Minute { get; }
		string DateTime_Month { get; }
		string DateTime_Second { get; }
		string DateTime_Year { get; }
	}
}
