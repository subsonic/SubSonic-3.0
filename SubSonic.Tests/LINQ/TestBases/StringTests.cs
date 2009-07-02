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
//using NUnit.Framework;
using SubSonic.Tests.Linq.TestBases;
using Xunit;

namespace SubSonic.Tests.Linq
{
// ReSharper disable InconsistentNaming
    //[TestFixture]
    public abstract class StringTests
    {
        protected TestDB _db;

        [Fact]
        public void String_CompareEQ()
        {
            var result = _db.Customers.Where(c => string.Compare(c.City, "City1") == 0);
            Assert.True(result.Count() > 0);
        }

        [Fact]
        public void String_CompareGE()
        {
            var result = _db.Customers.Where(c => string.Compare(c.City, "City1") >= 0);
            Assert.True(result.Count() > 0);
        }

        [Fact]
        public void String_CompareGT()
        {
            var result = _db.Customers.Where(c => string.Compare(c.City, "City1") > 0);
            Assert.True(result.Count() > 0);
        }

        [Fact]
        public void String_CompareLE()
        {
            var result = _db.Customers.Where(c => string.Compare(c.City, "City1") <= 0);
            Assert.True(result.Count() > 0);
        }

        [Fact]
        public void String_CompareLT()
        {
            var result = _db.Customers.Where(c => string.Compare(c.City, "City1") < 0);
            Assert.False(result.Count() > 0);
        }

        [Fact]
        public void String_CompareNE()
        {
            var result = _db.Customers.Where(c => string.Compare(c.City, "City1") != 0);
            Assert.True(result.Count() > 0);
        }

        [Fact]
        public void String_CompareToEQ()
        {
            var result = _db.Customers.Where(c => c.City.CompareTo("City1") == 0);
            Assert.True(result.Count() > 0);
        }

        [Fact]
        public void String_CompareToGE()
        {
            var result = _db.Customers.Where(c => c.City.CompareTo("City1") >= 0);
            Assert.True(result.Count() > 0);
        }

        [Fact]
        public void String_CompareToGT()
        {
            var result = _db.Customers.Where(c => c.City.CompareTo("City1") > 0);
            Assert.True(result.Count() > 0);
        }

        [Fact]
        public void String_CompareToLE()
        {
            var result = _db.Customers.Where(c => c.City.CompareTo("City1") <= 0);
            Assert.True(result.Count() > 0);
        }

        [Fact]
        public void String_CompareToLT()
        {
            var result = _db.Customers.Where(c => c.City.CompareTo("City1") < 0);
            Assert.False(result.Count() > 0);
        }

        [Fact]
        public void String_CompareToNE()
        {
            var result = _db.Customers.Where(c => c.City.CompareTo("City1") != 0);
            Assert.True(result.Count() > 0);
        }

        [Fact]
        public void String_IndexOf()
        {
            var result = _db.Customers.Where(c => c.City.IndexOf("ty") == 4);
            Assert.True(result.Count() == 0);
        }

        [Fact]
        public void String_IndexOfChar()
        {
            var result = _db.Customers.Where(c => c.City.IndexOf('t') == 3);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void String_IsNullOrEmpty()
        {
            var result = _db.Customers.Where(c => string.IsNullOrEmpty(c.City));
            Assert.True(result.Count() == 0);
        }

        [Fact]
        public void String_Replace()
        {
            var result = _db.Customers.Where(c => c.City.Replace("it", "ti") == "Ctiy1");
            Assert.True(result.Count() > 0);
        }

        [Fact]
        public void String_ReplaceChars()
        {
            var result = _db.Customers.Where(c => c.City.Replace("y", "ee") == "Citee");
            Assert.False(result.Count() > 0);
        }

        [Fact]
        public void String_Substring()
        {
            var result = _db.Customers.Where(c => c.City.Substring(0, 4) == "City");
            Assert.True(result.Count() > 0);
        }

        [Fact]
        public void String_ToLower()
        {
            var result = _db.Customers.Where(c => c.City.ToLower() == "city1");
            Assert.True(result.Count() > 0);
        }

        [Fact]
        public void String_ToString()
        {
            // just to prove this is a no op
            var result = _db.Customers.Where(c => c.City.ToString() == "City1");
            Assert.True(result.Count() > 0);
        }

        [Fact]
        public void String_ToUpper()
        {
            var result = _db.Customers.Where(c => c.City.ToUpper() == "CITY1");
            Assert.True(result.Count() > 0);
        }

        [Fact]
        public void String_Trim()
        {
            var result = _db.Customers.Where(c => c.City.Trim() == "City1");
            Assert.True(result.Count() > 0);
        }
    }

    // ReSharper restore InconsistentNaming
}