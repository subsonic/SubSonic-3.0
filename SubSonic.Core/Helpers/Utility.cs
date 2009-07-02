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

namespace SubSonic.Helpers
{
    public class Utility
    {
        /// <summary>
        /// Performs a case-insensitive comparison of two passed strings.
        /// </summary>
        /// <param name="stringA">The string to compare with the second parameter</param>
        /// <param name="stringB">The string to compare with the first parameter</param>
        /// <returns>
        /// 	<c>true</c> if the strings match; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsMatch(string stringA, string stringB)
        {
            return String.Equals(stringA, stringB, StringComparison.InvariantCultureIgnoreCase);
        }
    }
}