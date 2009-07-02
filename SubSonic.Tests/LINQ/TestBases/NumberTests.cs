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
using System.Linq;
//using NUnit.Framework;
using SubSonic.Tests.Linq.TestBases;
using Xunit;

namespace SubSonic.Tests.Linq
{
// ReSharper disable InconsistentNaming
    public abstract class NumberTests
    {
        protected TestDB _db;

        [Fact]
        public void Math_Abs()
        {
            var result = _db.Orders.Where(o => Math.Abs(o.OrderID) == 10);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Math_Atan()
        {
            var result = _db.Orders.Where(o => Math.Atan(o.OrderID) == 0);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Math_Atan2()
        {
            var result = _db.Orders.Where(o => Math.Atan2(o.OrderID, 3) == 0);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Math_Cos()
        {
            var result = _db.Orders.Where(o => Math.Cos(o.OrderID) == 0);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Math_Sin()
        {
            var result = _db.Orders.Where(o => Math.Sin(o.OrderID) == 0);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Math_Tan()
        {
            var result = _db.Orders.Where(o => Math.Tan(o.OrderID) == 0);
            Assert.True(result.Count() >= 0);
        }

        //[Fact]
        //public void Math_Exp() {
        //    var result = _db.Orders.Where(o => Math.Exp(o.OrderID) == 0);
        //     Assert.True(result.Count()>=0);
        //}

        [Fact]
        public void Math_Log()
        {
            var result = _db.Orders.Where(o => Math.Log(o.OrderID) == 0);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Math_Log10()
        {
            var result = _db.Orders.Where(o => Math.Log10(o.OrderID) == 0);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Math_Sqrt()
        {
            var result = _db.Orders.Where(o => Math.Sqrt(o.OrderID) == 0);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Math_Ceiling()
        {
            var result = _db.Orders.Where(o => Math.Ceiling((double)o.OrderID) == 0);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Math_Floor()
        {
            var result = _db.Orders.Where(o => Math.Floor((double)o.OrderID) == 0);
            Assert.True(result.Count() >= 0);
        }

        //[Fact]
        //public void Math_Pow() {
        //    var result = _db.Orders.Where(o => Math.Pow(o.OrderID, 3) == 0);
        //     Assert.True(result.Count()>=0);
        //}

        [Fact]
        public void Math_RoundDefault()
        {
            var result = _db.Orders.Where(o => Math.Round((decimal)o.OrderID) == 0);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Math_RoundToPlace()
        {
            var result = _db.Orders.Where(o => Math.Round((decimal)o.OrderID, 2) == 0);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Math_Truncate()
        {
            var result = _db.Orders.Where(o => Math.Truncate((double)o.OrderID) == 0);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Int_CompareTo()
        {
            // prove that x.CompareTo(y) works for types other than string
            var result = _db.Orders.Where(o => o.OrderID.CompareTo(1000) == 0);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Decimal_Compare()
        {
            // prove that type.Compare(x,y) works with decimal
            var result = _db.Orders.Where(o => decimal.Compare(o.OrderID, 0.0m) == 0);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Decimal_Add()
        {
            var result = _db.Orders.Where(o => decimal.Add(o.OrderID, 0.0m) == 0.0m);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Decimal_Subtract()
        {
            var result = _db.Orders.Where(o => decimal.Subtract(o.OrderID, 0.0m) == 0.0m);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Decimal_Multiply()
        {
            var result = _db.Orders.Where(o => decimal.Multiply(o.OrderID, 1.0m) == 1.0m);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Decimal_Divide()
        {
            var result = _db.Orders.Where(o => decimal.Divide(o.OrderID, 1.0m) == 1.0m);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Decimal_Remainder()
        {
            var result = _db.Orders.Where(o => decimal.Remainder(o.OrderID, 1.0m) == 0.0m);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Decimal_Negate()
        {
            var result = _db.Orders.Where(o => decimal.Negate(o.OrderID) == 1.0m);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Decimal_Ceiling()
        {
            var result = _db.Orders.Where(o => decimal.Ceiling(o.OrderID) == 0.0m);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Decimal_Floor()
        {
            var result = _db.Orders.Where(o => decimal.Floor(o.OrderID) == 0.0m);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Decimal_RoundDefault()
        {
            var result = _db.Orders.Where(o => decimal.Round(o.OrderID) == 0m);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Decimal_RoundPlaces()
        {
            var result = _db.Orders.Where(o => decimal.Round(o.OrderID, 2) == 0.00m);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Decimal_Truncate()
        {
            var result = _db.Orders.Where(o => decimal.Truncate(o.OrderID) == 0m);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Decimal_LT()
        {
            // prove that decimals are treated normally with respect to normal comparison operators
            var result = _db.Orders.Where(o => (o.OrderID) < 0.0m);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Int_LessThan()
        {
            var result = _db.Orders.Where(o => o.OrderID < 0);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Int_LessThanOrEqual()
        {
            var result = _db.Orders.Where(o => o.OrderID <= 0);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Int_GreaterThan()
        {
            var result = _db.Orders.Where(o => o.OrderID > 0);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Int_GreaterThanOrEqual()
        {
            var result = _db.Orders.Where(o => o.OrderID >= 0);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Int_Equal()
        {
            var result = _db.Orders.Where(o => o.OrderID == 0);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Int_NotEqual()
        {
            var result = _db.Orders.Where(o => o.OrderID != 0);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Int_Add()
        {
            var result = _db.Orders.Where(o => o.OrderID + 0 == 0);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Int_Subtract()
        {
            var result = _db.Orders.Where(o => o.OrderID - 0 == 0);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Int_Multiply()
        {
            var result = _db.Orders.Where(o => o.OrderID * 1 == 1);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Int_Divide()
        {
            var result = _db.Orders.Where(o => o.OrderID / 1 == 1);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Int_Modulo()
        {
            var result = _db.Orders.Where(o => o.OrderID % 1 == 0);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Int_LeftShift()
        {
            var result = _db.Orders.Where(o => o.OrderID << 1 == 0);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Int_RightShift()
        {
            var result = _db.Orders.Where(o => o.OrderID >> 1 == 0);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Int_BitwiseAnd()
        {
            var result = _db.Orders.Where(o => (o.OrderID & 1) == 0);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Int_BitwiseOr()
        {
            var result = _db.Orders.Where(o => (o.OrderID | 1) == 1);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Int_BitwiseNot()
        {
            var result = _db.Orders.Where(o => ~o.OrderID == 0);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Int_Negate()
        {
            var result = _db.Orders.Where(o => -o.OrderID == -1);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void And()
        {
            var result = _db.Orders.Where(o => o.OrderID > 0 && o.OrderID < 2000);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Or()
        {
            var result = _db.Orders.Where(o => o.OrderID < 5 || o.OrderID > 10);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Not()
        {
            var result = _db.Orders.Where(o => !(o.OrderID == 0));
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void EqualNull()
        {
            var result = _db.Customers.Where(c => c.City == null);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void EqualNullReverse()
        {
            var result = _db.Customers.Where(c => null == c.City);
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Coalsce()
        {
            var result = _db.Customers.Where(c => (c.City ?? "Seattle") == "Seattle");
            Assert.True(result.Count() >= 0);
        }

        [Fact]
        public void Coalesce2()
        {
            var result = _db.Customers.Where(c => (c.City ?? c.Country ?? "Seattle") == "Seattle");
            Assert.True(result.Count() >= 0);
        }

        /*
        [Fact]
        public void Conditional() {
            var result = _db.Orders.Where(o => (o.CustomerID == "ALFKI" ? 1000 : 0) == 1000);
             Assert.True(result.Count()>=0);
        }

        [Fact]
        public void Conditional2() {
            var result = _db.Orders.Where(o => (o.CustomerID == "ALFKI" ? 1000 : o.CustomerID == "ABCDE" ? 2000 : 0) == 1000);
             Assert.True(result.Count()>=0);
        }

        //[Fact]
        //public void ConditionalTestIsValue() {
        //    var result = _db.Orders.Where(o => (((bool)(object)o.CustomerID) ? 100 : 200) == 100).Count();
        //    Assert.True(result >= 0);
        //}

        [Fact]
        public void ConditionalResultsArePredicates() {
            var result = _db.Orders.Where(o => (o.CustomerID == "ALFKI" ? o.OrderID < 10 : o.OrderID > 10));
             Assert.True(result.Count()>=0);
        }
        */
    }

    // ReSharper restore InconsistentNaming
}