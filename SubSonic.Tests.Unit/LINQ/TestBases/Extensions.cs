using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.Linq.Structure;

namespace SubSonic.Tests.Unit.LINQ.TestBases
{
	internal static class Extensions
	{
		public static string GetQueryText(this IQueryable query)
		{
			return (query.Provider as IQueryText).GetQueryText(query.Expression);
		}
	}
}
