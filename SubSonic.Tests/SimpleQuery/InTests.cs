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
using System.Collections.Generic;
using WestWind;
using Xunit;

namespace SubSonic.Tests.In
{
    public class InTests
    {
        [Fact]
        public void In_Should_Return_2_Products_For_In_1_2()
        {
            var items = new List<int>
                            {
                                1,
                                2
                            };
            var db = new SubSonicDB();
            var result = db.Select.From<Product>().Where("ProductID").In(items).GetRecordCount();

            Assert.Equal(2, result);
        }
    }
}