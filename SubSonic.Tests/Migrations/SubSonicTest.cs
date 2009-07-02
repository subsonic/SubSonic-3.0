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
using SubSonic.SqlGeneration.Schema;

namespace SubSonic.Tests.Migrations
{
    public partial class SubSonicTest
    {

        public Guid Key { get; set; }
        public int Thinger { get; set; }
        public string Name { get; set; }

        [SubSonicStringLength(500)]
        public string UserName { get; set; }

        public DateTime CreatedOn { get; set; }
        public decimal Price { get; set; }
        public double Discount { get; set; }

        [SubSonicNumericPrecision(10, 3)]
        public float? Lat { get; set; }

        [SubSonicNumericPrecision(10, 3)]
        public float? Long { get; set; }

        public bool SomeFlag { get; set; }
        public bool? SomeNullableFlag { get; set; }

        [SubSonicLongString]
        public string LongText { get; set; }

        [SubSonicStringLength(800)]
        public string MediumText { get; set; }

        [SubSonicIgnore]
        public int IgnoreMe { get; set; }


    }
}