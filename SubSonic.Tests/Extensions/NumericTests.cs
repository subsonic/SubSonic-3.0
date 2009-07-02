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
using SubSonic.Extensions;
using Xunit;

namespace SubSonic.Tests.Extensions
{
    public class NumericTests
    {
        [Fact]
        public void IsNatural_ShouldReturn_True_For_3()
        {
            Assert.True("3".IsNaturalNumber());
        }

        [Fact]
        public void IsNatural_ShouldReturn_False_For_Neg3()
        {
            Assert.False("-3".IsNaturalNumber());
        }

        [Fact]
        public void IsNatural_ShouldReturn_False_For_3Point3()
        {
            Assert.False("3.3".IsNaturalNumber());
        }

        [Fact]
        public void IsWholeNumber_ShouldReturn_True_For_3()
        {
            Assert.True("3".IsWholeNumber());
        }

        [Fact]
        public void IsWholeNumber_ShouldReturn_False_For_Neg3()
        {
            Assert.False("-3".IsWholeNumber());
        }

        [Fact]
        public void IsWholeNumber_ShouldReturn_False_For_3Point3()
        {
            Assert.False("3.3".IsWholeNumber());
        }

        [Fact]
        public void IsInteger_Should_Return_True_For_3()
        {
            Assert.True("3".IsInteger());
        }

        [Fact]
        public void IsInteger_ShouldReturn_True_For_Neg3()
        {
            Assert.True("-3".IsInteger());
        }

        [Fact]
        public void IsInteger_ShouldReturn_False_For_3Point3()
        {
            Assert.False("3.3".IsInteger());
        }

        [Fact]
        public void IsNumber_ShouldReturn_True_For_3()
        {
            Assert.True("3".IsNumber());
        }

        [Fact]
        public void IsNumber_ShouldReturn_True_For_3Point3()
        {
            Assert.True(3.3f.ToString().IsNumber());
        }

        [Fact]
        public void IsNumber_ShouldReturn_True_For_Neg3()
        {
            Assert.True("-3".IsNumber());
        }

        [Fact]
        public void IsNumber_ShouldReturn_False_For_Foo()
        {
            Assert.False("Foo".IsNumber());
        }

        [Fact]
        public void IsEven_Should_Return_True_For_2_And_4()
        {
            Assert.True(2.IsEven());
            Assert.True(4.IsEven());
        }

        [Fact]
        public void IsEven_Should_Return_False_For_1_And_3()
        {
            Assert.False(1.IsEven());
            Assert.False(3.IsEven());
        }

        [Fact]
        public void IsOdd_Should_Return_False_For_2_And_4()
        {
            Assert.False(2.IsOdd());
            Assert.False(4.IsOdd());
        }

        [Fact]
        public void IsOdd_Should_Return_True_For_1_And_3()
        {
            Assert.True(1.IsOdd());
            Assert.True(3.IsOdd());
        }

        [Fact]
        public void Random_With_10_High_Should_Produce_Number_LessThan10_100_Times()
        {
            bool fail = true;
            for(int i = 0; i <= 100; i++)
            {
                var result = Numeric.Random(10);
                fail = result > 10;
                if(fail)
                    break;
            }
            Assert.False(fail);
        }

        [Fact]
        public void Random_With_10_High_Should_Produce_Number_Between_10_And_100_100_Times()
        {
            bool fail = true;
            for(int i = 0; i <= 100; i++)
            {
                var result = Numeric.Random(10, 100);
                fail = result < 10 || result > 100;
                if(fail)
                    break;
            }
            Assert.False(fail);
        }
    }
}