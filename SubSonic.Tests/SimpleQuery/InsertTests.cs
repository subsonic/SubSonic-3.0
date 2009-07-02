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
using System.Linq;
using WestWind;
using SubSonic.Tests.Linq.TestBases;
using Xunit;

namespace SubSonic.Tests.Update
{
    /// <summary>
    /// Summary description for InsertTests
    /// </summary>
    public class InsertTests
    {
        private readonly SubSonicDB _db;

        public InsertTests()
        {
            _db = new SubSonicDB();
            var setup = new Setup(_db.Provider);
            setup.DropTestTables();
            setup.CreateTestTable();
            setup.LoadTestData();
        }

        [Fact]
        public void Insert_With_Advanced_Template_Context()
        {
            bool wasThere = _db.Categories.Any(x => x.CategoryName == "SubSonic");
            Assert.False(wasThere);

            var qry = _db.Insert.Into<Category>(x => x.CategoryName)
                .Values("SubSonic").Execute();

            wasThere = _db.Categories.Any(x => x.CategoryName == "SubSonic");
            Assert.True(wasThere);
        }

        [Fact]
        public void Insert_With_ActiveRecord()
        {
            bool wasThere = Southwind.Category.Exists(x => x.CategoryName == "SubSonic");
            Assert.False(wasThere);

            var newCategory = new Southwind.Category();
            newCategory.CategoryName = "SubSonic";
            newCategory.Save();

            wasThere = _db.Categories.Any(x => x.CategoryName == "SubSonic");
            Assert.True(wasThere);
        }
    }
}