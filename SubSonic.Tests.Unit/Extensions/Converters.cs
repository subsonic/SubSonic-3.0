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
using System.Linq;

namespace SubSonic.Tests.Unit.Extensions {

    class Duck {
        public short Shorty { get; set; }
        public int Thirty { get; set; }

    }
    public class Converters {

        [Fact]
        public void Can_convert_valid_Int32_to_16() {

            var duck = new Duck();
            duck.Shorty = 12;
            duck.Thirty = 20;

            var newShort = duck.Thirty.ChangeTypeTo(duck.Shorty.GetType());

            Assert.Equal(typeof(short), newShort.GetType());

            typeof(Duck).GetProperty("Shorty").SetValue(duck, newShort,null);
        }
    }
}
