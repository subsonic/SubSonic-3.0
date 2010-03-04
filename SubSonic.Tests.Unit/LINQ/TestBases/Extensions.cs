using System.Linq;
using SubSonic.Linq.Structure;
using Xunit;

namespace SubSonic.Tests.Unit.Linq.TestBases
{
	internal static class Extensions
	{
		public static string GetQueryText(this IQueryable query)
		{
			return (query.Provider as IQueryText).GetQueryText(query.Expression);
		}
	}
}
