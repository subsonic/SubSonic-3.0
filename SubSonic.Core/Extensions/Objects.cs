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
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Reflection;
using System.Linq;
using SubSonic.DataProviders;
using SubSonic.Schema;
using SubSonic.SqlGeneration.Schema;

namespace SubSonic.Extensions
{
    public static class Objects
    {
        /// <summary>
        /// Returns an Object with the specified Type and whose value is equivalent to the specified object.
        /// </summary>
        /// <param name="value">An Object that implements the IConvertible interface.</param>
        /// <returns>
        /// An object whose Type is conversionType (or conversionType's underlying type if conversionType
        /// is Nullable&lt;&gt;) and whose value is equivalent to value. -or- a null reference, if value is a null
        /// reference and conversionType is not a value type.
        /// </returns>
        /// <remarks>
        /// This method exists as a workaround to System.Convert.ChangeType(Object, Type) which does not handle
        /// nullables as of version 2.0 (2.0.50727.42) of the .NET Framework. The idea is that this method will
        /// be deleted once Convert.ChangeType is updated in a future version of the .NET Framework to handle
        /// nullable types, so we want this to behave as closely to Convert.ChangeType as possible.
        /// This method was written by Peter Johnson at:
        /// http://aspalliance.com/author.aspx?uId=1026.
        /// </remarks>
        /// 
        public static object ChangeTypeTo<T>(this object value)
        {
            Type conversionType = typeof(T);
            return ChangeTypeTo(value, conversionType);
        }

        public static object ChangeTypeTo(this object value, Type conversionType)
        {
            // Note: This if block was taken from Convert.ChangeType as is, and is needed here since we're
            // checking properties on conversionType below.
            if(conversionType == null)
                throw new ArgumentNullException("conversionType");

            // If it's not a nullable type, just pass through the parameters to Convert.ChangeType

            if(conversionType.IsGenericType && conversionType.GetGenericTypeDefinition().Equals(typeof(Nullable<>)))
            {
                // It's a nullable type, so instead of calling Convert.ChangeType directly which would throw a
                // InvalidCastException (per http://weblogs.asp.net/pjohnson/archive/2006/02/07/437631.aspx),
                // determine what the underlying type is
                // If it's null, it won't convert to the underlying type, but that's fine since nulls don't really
                // have a type--so just return null
                // Note: We only do this check if we're converting to a nullable type, since doing it outside
                // would diverge from Convert.ChangeType's behavior, which throws an InvalidCastException if
                // value is null and conversionType is a value type.
                if(value == null)
                    return null;

                // It's a nullable type, and not null, so that means it can be converted to its underlying type,
                // so overwrite the passed-in conversion type with this underlying type
                NullableConverter nullableConverter = new NullableConverter(conversionType);
                conversionType = nullableConverter.UnderlyingType;
            }
            else if(conversionType == typeof(Guid))
            {
                return new Guid(value.ToString());
                
            }else if(conversionType==typeof(Int64) && value.GetType()==typeof(int))

            {
                //there is an issue with SQLite where the PK is ALWAYS int64. If this conversion type is Int64
                //we need to throw here - suggesting that they need to use LONG instead
                
                
                throw  new InvalidOperationException("Can't convert an Int64 (long) to Int32(int). If you're using SQLite - this is probably due to your PK being an INTEGER, which is 64bit. You'll need to set your key to long.");
            }

            // Now that we've guaranteed conversionType is something Convert.ChangeType can handle (i.e. not a
            // nullable type), pass the call on to Convert.ChangeType
            return Convert.ChangeType(value, conversionType);
        }

        public static Dictionary<string, object> ToDictionary(this object value)
        {
            Dictionary<string, object> result = new Dictionary<string, object>();
            PropertyInfo[] props = value.GetType().GetProperties();
            foreach(PropertyInfo pi in props)
            {
                try
                {
                    result.Add(pi.Name, pi.GetValue(value, null));
                }
                catch {}
            }
            return result;
        }

        public static T FromDictionary<T>(this Dictionary<string, object> settings, T item) where T : class
        {
            PropertyInfo[] props = item.GetType().GetProperties();
            //FieldInfo[] fields = item.GetType().GetFields();
            foreach(PropertyInfo pi in props)
            {
                if(settings.ContainsKey(pi.Name))
                {
                    if(pi.CanWrite)
                        pi.SetValue(item, settings[pi.Name], null);
                }
            }
            return item;
        }

        public static T CopyTo<T>(this object From, T to) where T : class
        {
            Type t = From.GetType();

            var settings = From.ToDictionary();

            to = settings.FromDictionary(to);

            return to;
        }

        private static bool CanGenerateSchemaFor(Type type)
        {
        	return type == typeof (string) ||
        	       type == typeof (Guid) ||
        	       type == typeof (Guid?) ||
        	       type == typeof (decimal) ||
        	       type == typeof (decimal?) ||
        	       type == typeof (double) ||
        	       type == typeof (double?) ||
        	       type == typeof (DateTime) ||
        	       type == typeof (DateTime?) ||
        	       type == typeof (bool) ||
        	       type == typeof (bool?) ||
        	       type == typeof (Int16) ||
        	       type == typeof (Int16?) ||
        	       type == typeof (Int32) ||
        	       type == typeof (Int32?) ||
        	       type == typeof (Int64) ||
        	       type == typeof (Int64?) ||
        	       type == typeof (float?) ||
        	       type == typeof (float) ||
        	       type.IsEnum || IsNullableEnum(type);
        }

    	internal static bool IsNullableEnum(Type type)
    	{
    		var enumType = Nullable.GetUnderlyingType(type);

			return enumType != null && enumType.IsEnum;
    	}

    	public static ITable ToSchemaTable(this Type type, IDataProvider provider)
        {
            string tableName = type.Name;
            tableName = tableName.MakePlural();

			var typeAttributes = type.GetCustomAttributes(false);
			var tableNameAttr = (SubSonicTableNameOverrideAttribute)typeAttributes.FirstOrDefault(x => x.ToString().Equals("SubSonic.SqlGeneration.Schema.SubSonicTableNameOverrideAttribute"));

			if (tableNameAttr != null && tableNameAttr.IsSet)
			{
				tableName = tableNameAttr.TableName;
			}

            var result = new DatabaseTable(tableName, provider);
            result.ClassName = type.Name;

            var props = type.GetProperties();
            foreach(var prop in props)
            {
                var attributes = prop.GetCustomAttributes(false);
                bool isIgnored = false;
                foreach(var att in attributes)
                {
                    isIgnored = att.ToString().Equals("SubSonic.SqlGeneration.Schema.SubSonicIgnoreAttribute");
                    if(isIgnored)
                        break;
                }
                if(CanGenerateSchemaFor(prop.PropertyType) & !isIgnored)
                {
                    var column = new DatabaseColumn(prop.Name, result);
					bool isNullable = prop.PropertyType.Name.Contains("Nullable");

                	column.DataType = IdentifyColumnDataType(prop.PropertyType, isNullable);

                    if(column.DataType == DbType.Decimal || column.DataType == DbType.Double)
                    {
                        //default to most common;
                        column.NumberScale = 2;
                        column.NumericPrecision = 10;

                        //loop the attributes to see if there's a length
                        foreach(var att in attributes)
                        {
                            if (att.ToString().Equals("SubSonic.SqlGeneration.Schema.SubSonicNumericPrecisionAttribute"))
                            {
                                var precision = (SubSonicNumericPrecisionAttribute)att;
                                column.NumberScale = precision.Scale;
                                column.NumericPrecision = precision.Precision;
                            }
                        }
                    }
                    else if(column.DataType == DbType.String)
                    {
                        column.MaxLength = 255;

                        //loop the attributes to see if there's a length
                        foreach(var att in attributes)
                        {
                            if (att.ToString().Equals("SubSonic.SqlGeneration.Schema.SubSonicStringLengthAttribute"))
                            {
                                var lengthAtt = (SubSonicStringLengthAttribute)att;
                                column.MaxLength = lengthAtt.Length;
                            }

                            if (att.ToString().Equals("SubSonic.SqlGeneration.Schema.SubSonicNullStringAttribute"))
                            {
                                isNullable = true;
                            }
                        }
                    }

                    if(isNullable)
                        column.IsNullable = true;

                    //set the length on this if it's text - specifically we want to know
                    //if the LongString attribute is used - we'll set to nvarchar MAX or ntext depending

                    foreach(var att in attributes)
                    {
                        if (att.ToString().Equals("SubSonic.SqlGeneration.Schema.SubSonicLongStringAttribute"))
                            column.MaxLength = 8001;
                    }

                    //loop the attributes - see if a PK attribute was set
                    foreach(var att in attributes)
                    {
                        if (att.ToString().Equals("SubSonic.SqlGeneration.Schema.SubSonicPrimaryKeyAttribute")) {
                            column.IsPrimaryKey = true;
                            column.IsNullable = false;
                            if(column.IsNumeric)
                                column.AutoIncrement = true;
                            else if (column.IsString && column.MaxLength == 0)
                                column.MaxLength = 255;
                        }
                        
                    }

                    result.Columns.Add(column);
                }
            }

            //if the PK is still null-look for a column called [tableName]ID - if it's there then make it PK
            if(result.PrimaryKey == null)
            {
                var pk = (result.GetColumn(type.Name + "ID") ?? result.GetColumn("ID")) ?? result.GetColumn("Key");

                if(pk != null)
                {
                    pk.IsPrimaryKey = true;
                    //if it's an INT then AutoIncrement it
                    if(pk.IsNumeric)
                        pk.AutoIncrement = true;
                    else if(pk.IsString && pk.MaxLength == 0)
                        pk.MaxLength = 255;
                    //} else {
                    //    pk = new DatabaseColumn(type.Name + "ID", result);
                    //    pk.DataType = DbType.Int32;
                    //    pk.IsPrimaryKey = true;
                    //    pk.AutoIncrement = true;
                    //    result.Columns.Insert(0, pk);
                }
            }

            //we should have a PK at this point
            //if not, throw :)
            if(result.PrimaryKey == null)
                throw new InvalidOperationException("Can't decide which property to consider the Key - you can create one called 'ID' or mark one with SubSonicPrimaryKey attribute");
            return result;
        }

		private static DbType IdentifyColumnDataType(Type type, bool isNullable)
    	{
			//if this is a nullable type, we need to get at the underlying type
			if (isNullable)
			{
				var nullType = Nullable.GetUnderlyingType(type);

				return nullType.IsEnum ? GetEnumType(nullType) : Database.GetDbType(nullType);
			}

			return type.IsEnum ? GetEnumType(type) : Database.GetDbType(type);
    	}

    	private static DbType GetEnumType(Type type)
    	{
			var enumType = Enum.GetUnderlyingType(type);
    		return Database.GetDbType(enumType);
    	}
    }
}