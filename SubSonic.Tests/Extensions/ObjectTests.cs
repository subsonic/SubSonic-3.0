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
using System;
using SubSonic.Extensions;
using Xunit;

namespace SubSonic.Tests.Extensions
{
    public class ObjectTests
    {
        [Fact]
        public void ChangeTypeTo_Should_Change_String_To_DateTime()
        {
            var result = "12/12/09".ChangeTypeTo<DateTime>();
            Assert.IsType(typeof(DateTime), result);
        }

        [Fact]
        public void ChangeTypeTo_Should_Change_A_String_To_A_Guid()
        {
            string guid = Guid.NewGuid().ToString();
            var result = guid.ChangeTypeTo<Guid>();
            Assert.IsType(typeof(Guid), result);
        }

        [Fact]
        public void ToDictionary_Should_Return_5_Items_For_Test_Object()
        {
            var tester = new
                             {
                                 thing1 = "test",
                                 thing2 = DateTime.Now,
                                 thing3 = 1,
                                 thing4 = 2.03M,
                                 thing5 = Guid.NewGuid()
                             };

            var result = tester.ToDictionary();
            Assert.Equal(5, result.Count);
        }
    }
}