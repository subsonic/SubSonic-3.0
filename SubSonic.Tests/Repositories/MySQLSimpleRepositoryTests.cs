using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.DataProviders;
using Xunit;

namespace SubSonic.Tests.Repositories
{
    public class MySQLSimpleRepositoryTests : SimpleRepositoryTests
    {
        public MySQLSimpleRepositoryTests() :
			 base(ProviderFactory.GetProvider(@"server=localhost;database=SubSonic;user id=root; password=;", "MySql.Data.MySqlClient"))
        {
        }

		  [Fact]
		  public void Simple_Repo_Should_Support_Contains_Enumerable()
		  {
			  List<int> ids = new List<int>();
			  var shwerko = CreateTestRecord<Shwerko>(Guid.NewGuid(), s => s.Name = "test1");
			  _repo.Add(shwerko);
			  ids.Add(shwerko.ID);

			  var shwerko2 = CreateTestRecord<Shwerko>(Guid.NewGuid(), s => s.Name = "test2");
			  _repo.Add(shwerko2);
			  ids.Add(shwerko2.ID);

			  var result = _repo.All<Shwerko>().Where(o => ids.Contains(o.ID)).ToList();
			  Assert.NotEmpty(result);
			  Assert.True(result.Count == 2);
		  }
		  [Fact]
		  public void Simple_Repo_Should_Support_Contains_String_Enumerable()
		  {
			  List<string> names = new List<string>();
			  var shwerko = CreateTestRecord<Shwerko>(Guid.NewGuid(), s => s.Name = "test1");
			  _repo.Add(shwerko);
			  names.Add(shwerko.Name);

			  var shwerko2 = CreateTestRecord<Shwerko>(Guid.NewGuid(), s => s.Name = "test2");
			  _repo.Add(shwerko2);
			  names.Add(shwerko2.Name);

			  var result = _repo.All<Shwerko>().Where(o => names.Contains(o.Name)).ToList();
			  Assert.NotEmpty(result);
			  Assert.True(result.Count == 2);
		  }

		  public void Simple_Repo_Should_Return_Zero_Results_When_Using_Contains_With_Empty_Enumerable()
		  {
			  //I'm building this using the same logic as Linq to Sql Classes.  They append a where clause of 0 = 1
			  //	to force the statment to return no results.  This does not result in an exception being thrown and 
			  //	allows the logic of Contains(id) to be valid. 
			  var shwerko = CreateTestRecord<Shwerko>(Guid.NewGuid(), s => s.Name = "test1");
			  _repo.Add(shwerko);

			  var shwerko2 = CreateTestRecord<Shwerko>(Guid.NewGuid(), s => s.Name = "test2");
			  _repo.Add(shwerko2);

			  List<int> ids = new List<int>();
			  var result = _repo.All<Shwerko>().Where(o => ids.Contains(o.ID)).ToList();
			  Assert.Empty(result);
		  }
    }
}
