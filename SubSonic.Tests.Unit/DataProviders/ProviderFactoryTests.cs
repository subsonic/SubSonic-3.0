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
using SubSonic.DataProviders;
using Xunit;

namespace SubSonic.Tests
{
    /// <summary>
    /// Summary description for ProviderFactoryTests
    /// </summary>
    public class ProviderFactoryTests
    {
        [Fact]
        public void Provider_Factory_Should_Throw_Exception_When_Requesting_Nonexistent_Provider()
        {
            // Arrange
            var nonexistent = "nonexistent_provider";
            var expectedMessage = String.Format("Connection string '{0}' does not exist", nonexistent);
            Exception expectedException = null;

            // Act
            try
            {
                ProviderFactory.GetProvider(nonexistent);
            }
            catch(Exception ex)
            {
                expectedException = ex;
            }

            // Assert
            Assert.NotNull(expectedException);
            Assert.Equal(expectedMessage, expectedException.Message);
        }
    }
}