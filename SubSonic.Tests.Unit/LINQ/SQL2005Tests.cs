// 
//   SubSonic - http://subsonicproject.com
// 
//   The contents of this file are subject to the New BSD
//   License (the "License"); you may not use this file
//   except in compliance with the License. You may obtain a copy of
//   the License at http://www.opensource.org/licenses/bsd-license.php
//  
//   Software distributed under the License is distributed on an 
//   "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
//   implied. See the License for the specific language governing
//   rights and limitations under the License.
// 
using SubSonic.DataProviders;
using SubSonic.Tests.Unit.Linq.SqlStrings;
using SubSonic.Tests.Unit.Linq.TestBases;

namespace SubSonic.Tests.Unit.Linq
{
	// ReSharper disable InconsistentNaming
	// these are unit tests and I like underscores
	// suck it Osherove :)

	public class Sql2005SelectTests : SelectTests
	{
		public Sql2005SelectTests()
		{
			_db = new TestDB(TestConfiguration.MsSql2005TestConnectionString, DbClientTypeName.MsSql);
			_selectTestsSql = new Sql2005SelectTestsSql();
		}
	}

	public class Sql2005NumberTests : NumberTests
	{
		public Sql2005NumberTests()
		{
			_db = new TestDB(TestConfiguration.MsSql2005TestConnectionString, DbClientTypeName.MsSql);
			_numberTestsSql = new Sql2005NumberTestsSql();
		}
	}

	public class Sql2005StringTests : StringTests
	{
		public Sql2005StringTests()
		{
			_db = new TestDB(TestConfiguration.MsSql2005TestConnectionString, DbClientTypeName.MsSql);
			_stringTestsSql = new Sql2005StringTestsSql();
		}
	}

	public class Sql2005DateTests : DateTests
	{
		public Sql2005DateTests()
		{
			_db = new TestDB(TestConfiguration.MsSql2005TestConnectionString, DbClientTypeName.MsSql);
			_dateTestsSql = new Sql2005DateTestsSql();
		}
	}
}