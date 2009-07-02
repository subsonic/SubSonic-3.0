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
        public void Getting_a_named_provider_that_depends_on_a_nonexistant_connection_string()
        {
            try
            {
                ProviderFactory.GetProvider("nonexistant");
            }
            catch(Exception ex)
            {
                Assert.Equal(ex.Message, "Object reference not set to an instance of an object.");
            }

            //var ex = Assert.Throws<InvalidOperationException>(() => { IDataProvider provider = ProviderFactory.GetProvider("nonexistant"); });

            //Assert.Equal(
            //    "There was a problem getting the ConnectionString 'nonexistant' from your config file; please make sure it's there. If this is a test project it MUST be in the app.config",
            //    ex.Message);
        }
    }
}