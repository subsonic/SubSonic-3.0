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
    public class DateTests
    {
        [Fact]
        public void DaysAgo_Should_Return_DateTime_AddDays_Neg3_For_3()
        {
            var today = DateTime.Now;
            var then = 3.DaysAgo();

            Assert.Equal(then, DateTime.Now.AddDays(-3));
        }

        [Fact]
        public void DaysFromNow_Should_Return_DateTime_AddDays3_For_3()
        {
            var today = DateTime.Now;
            var then = 3.DaysFromNow();

            Assert.Equal(then, DateTime.Now.AddDays(3));
        }

        [Fact]
        public void HoursAgo_Should_Return_DateTime_AddHours_Neg3_For_3()
        {
            var today = DateTime.Now;
            var then = 3.HoursAgo();

            Assert.Equal(then, DateTime.Now.AddHours(-3));
        }

        [Fact]
        public void HoursFromNow_Should_Return_DateTime_AddHours3_For_3()
        {
            var today = DateTime.Now;
            var then = 3.HoursFromNow();

            Assert.Equal(then, DateTime.Now.AddHours(3));
        }

        [Fact]
        public void MinutesAgo_Should_Return_DateTime_AddMinutes_Neg3_For_3()
        {
            var today = DateTime.Now;
            var then = 3.MinutesAgo();

            Assert.Equal(then, DateTime.Now.AddMinutes(-3));
        }

        [Fact]
        public void MinutesFromNow_Should_Return_DateTime_AddMinutes_3_For_3()
        {
            var today = DateTime.Now;
            var then = 3.MinutesFromNow();

            Assert.Equal(then, DateTime.Now.AddMinutes(3));
        }

        [Fact]
        public void SecondsAgo_Should_Return_DateTime_AddSeconds_Neg3_For_3()
        {
            var today = DateTime.Now;
            var then = 3.SecondsAgo();

            Assert.Equal(then, DateTime.Now.AddSeconds(-3));
        }

        [Fact]
        public void SecondsFromNow_Should_Return_DateTime_AddSeconds3_For_3()
        {
            var today = DateTime.Now;
            var then = 3.SecondsFromNow();

            Assert.Equal(then, DateTime.Now.AddSeconds(3));
        }

        [Fact]
        public void Diff_Should_Return_3Day_Timespan_For_DateTimeNow_And_AddDays3()
        {
            var today = DateTime.Now;
            var then = DateTime.Now.AddDays(3);
            var diff = today.Diff(then);
            Assert.Equal(-3, diff.Days);
        }

        [Fact]
        public void DiffDays_Should_Return_3_For_DateTimeNow_And_AddDays3()
        {
            var today = DateTime.Now;
            var then = DateTime.Now.AddDays(3);
            var diff = today.DiffDays(then);
            Assert.Equal(-3, diff);
        }

        [Fact]
        public void DiffHours_Should_Return_3_For_DateTimeNow_And_AddHours3()
        {
            var today = DateTime.Now;
            var then = DateTime.Now.AddHours(3);
            var diff = today.DiffHours(then);
            Assert.Equal(-3, diff);
        }

        [Fact]
        public void DiffMinutes_Should_Return_3_For_DateTimeNow_And_AddMinutes3()
        {
            var today = DateTime.Now;
            var then = DateTime.Now.AddMinutes(3);
            var diff = today.DiffMinutes(then);
            Assert.Equal(-3, diff);
        }

        [Fact]
        public void ReadableDiff_Should_Say_3_Years_Ago_When_DateTimeNow_Is_Diffed_With_DateTimeNow_AddYears_3()
        {
            var today = DateTime.Now;
            var then = DateTime.Now.AddYears(3);
            var diff = today.ReadableDiff(then);
            Assert.Equal("3 years ago", diff);
        }

        [Fact]
        public void TimeDiff_Should_Say_3_Days_8_Hourse_5Minutes_3Seconds_Ago_When_DateTimeNow_Is_Diffed_WithAddedValues()
        {
            var today = DateTime.Now;
            var then = DateTime.Now.AddDays(3).AddHours(8).AddMinutes(5).AddSeconds(2);
            var diff = today.TimeDiff(then);
            Assert.Equal("3 days 8 hours 5 minutes 2 seconds ", diff);
        }

        [Fact]
        public void CountWeekdays_Should_Be_86_When_Comparing_1_1_2001_to_5_1_2001()
        {
            var today = new DateTime(2001, 1, 1);
            var then = new DateTime(2001, 5, 1);
            var diff = today.CountWeekdays(then);
            Assert.Equal(86, diff);
        }

        [Fact]
        public void CountWeekends_Should_Be_86_When_Comparing_1_1_2001_to_5_1_2001()
        {
            var today = new DateTime(2001, 1, 1);
            var then = new DateTime(2001, 5, 1);
            var diff = today.CountWeekends(then);
            Assert.Equal(34, diff);
        }

        [Fact]
        public void IsWeekDay_Should_BeTrue_For_4_16_09_And_IsWeekend_ShouldBe_False()
        {
            var today = new DateTime(2009, 4, 16);
            Assert.True(today.IsWeekDay());
            Assert.False(today.IsWeekEnd());
        }

        [Fact]
        public void IsWeekEnd_Should_BeTrue_For_4_18_09_And_IsWeekDay_ShouldBe_False()
        {
            var today = new DateTime(2009, 4, 18);
            Assert.False(today.IsWeekDay());
            Assert.True(today.IsWeekEnd());
        }

        [Fact]
        public void GetFormattedMonthAndDay_Should_Be_April_16th_For_ParsedDate()
        {
            var today = new DateTime(2009, 4, 16);
            var result = today.GetFormattedMonthAndDay();
            Assert.Equal(String.Format("{0:MMMM}", today) + " 16th", result);
        }

        [Fact]
        public void GetDateDayWithSuffix_Should_Be_April_16th_For_ParsedDate()
        {
            var today = new DateTime(2009, 4, 16);
            var result = today.GetDateDayWithSuffix();
            Assert.Equal("16th", result);
        }
    }
}