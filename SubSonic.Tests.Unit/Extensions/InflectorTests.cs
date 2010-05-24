using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Xunit;
using SubSonic.Extensions;

namespace SubSonic.Tests.Unit.Extensions {
    public class InflectorTests {

        [Fact]
        public void SomethingStatus_Should_Be_Left_Alone() {
            var word = "SomethingStatus";
            var inflected = Inflector.MakeSingular(word);
            Assert.Equal(word, inflected);
        }

        [Fact]
        public void Penis_Should_Be_Pluralized_Penises() {
            var word = "Person";
            var inflected = Inflector.MakePlural(word);
            Assert.Equal("People", inflected);
        }
    }
}
