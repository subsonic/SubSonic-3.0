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

namespace SubSonic.SqlGeneration.Schema
{
	[AttributeUsage(AttributeTargets.Class)]
	public class SubSonicTableNameOverrideAttribute : Attribute
	{
		public SubSonicTableNameOverrideAttribute(string tableName)
        {
			TableName = tableName;
        }

		public string TableName { get; set; }
		public bool IsSet
		{
			get
			{
				return !string.IsNullOrEmpty(TableName);
			}
		}
	}

    [AttributeUsage(AttributeTargets.Property)]
    public class SubSonicNullStringAttribute : Attribute {}

    [AttributeUsage(AttributeTargets.Property)]
    public class SubSonicLongStringAttribute : Attribute {}

    [AttributeUsage(AttributeTargets.Property)]
    public class SubSonicIgnoreAttribute : Attribute {}

    [AttributeUsage(AttributeTargets.Property)]
    public class SubSonicPrimaryKeyAttribute : Attribute {}

    [AttributeUsage(AttributeTargets.Property)]
    public class SubSonicStringLengthAttribute : Attribute
    {
        public SubSonicStringLengthAttribute(int length)
        {
            Length = length;
        }

        public int Length { get; set; }
    }

    [AttributeUsage(AttributeTargets.Property)]
    public class SubSonicNumericPrecisionAttribute : Attribute
    {
        public SubSonicNumericPrecisionAttribute(int precision, int scale)
        {
            Scale = scale;
            Precision = precision;
        }

        public int Precision { get; set; }
        public int Scale { get; set; }
    }
}