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

    // [TestFixture]
    public abstract class DateTests
    {
        protected TestDB _db;

        [Fact]
        public void DateTime_Day()
        {
            var result = _db.Orders.Where(o => o.OrderDate.Day == 5);
            Assert.Equal(3, result.Count());
        }

        [Fact]
        public void DateTime_DayOfWeek()
        {
            var result = _db.Orders.Where(o => o.OrderDate.DayOfWeek == DayOfWeek.Friday);
            Assert.Equal(14, result.Count());
        }

        [Fact]
        public void DateTime_DayOfYear()
        {
            var result = _db.Orders.Where(o => o.OrderDate.DayOfYear == 360);
            Assert.Equal(0, result.Count());
        }

        [Fact]
        public void DateTime_Hour()
        {
            var result = _db.Orders.Where(o => o.OrderDate.Hour == 6);
            Assert.Equal(0, result.Count());
        }

        [Fact]
        public void DateTime_Millisecond()
        {
            var result = _db.Orders.Where(o => o.OrderDate.Millisecond == 200);
            Assert.Equal(0, result.Count());
        }

        [Fact]
        public void DateTime_Minute()
        {
            var result = _db.Orders.Where(o => o.OrderDate.Minute == 32);
            Assert.Equal(0, result.Count());
        }

        [Fact]
        public void DateTime_Month()
        {
            var result = _db.Orders.Where(o => o.OrderDate.Month == 12);
            Assert.Equal(10, result.Count());
        }

        [Fact]
        public void DateTime_Second()
        {
            var result = _db.Orders.Where(o => o.OrderDate.Second == 47);
            Assert.Equal(0, result.Count());
        }

        [Fact]
        public void DateTime_Year()
        {
            var result = _db.Orders.Where(o => o.OrderDate.Year == 2007);
            Assert.Equal(31, result.Count());
        }
    }
}

// ReSharper restore InconsistentNaming