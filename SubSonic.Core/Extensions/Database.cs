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
using System.Linq;
using System.Reflection;
using SubSonic.DataProviders;
using SubSonic.Query;
using SubSonic.Schema;
using Constraint=SubSonic.Query.Constraint;

namespace SubSonic.Extensions
{
    public static class Database
    {
        /// <summary>
        /// Returns the SqlDbType for a give DbType
        /// </summary>
        /// <returns></returns>
        public static SqlDbType GetSqlDBType(this DbType dbType)
        {
            switch(dbType)
            {
                case DbType.AnsiString:
                    return SqlDbType.VarChar;
                case DbType.AnsiStringFixedLength:
                    return SqlDbType.Char;
                case DbType.Binary:
                    return SqlDbType.VarBinary;
                case DbType.Boolean:
                    return SqlDbType.Bit;
                case DbType.Byte:
                    return SqlDbType.TinyInt;
                case DbType.Currency:
                    return SqlDbType.Money;
                case DbType.Date:
                    return SqlDbType.DateTime;
                case DbType.DateTime:
                    return SqlDbType.DateTime;
                case DbType.Decimal:
                    return SqlDbType.Decimal;
                case DbType.Double:
                    return SqlDbType.Float;
                case DbType.Guid:
                    return SqlDbType.UniqueIdentifier;
                case DbType.Int16:
                    return SqlDbType.Int;
                case DbType.Int32:
                    return SqlDbType.Int;
                case DbType.Int64:
                    return SqlDbType.BigInt;
                case DbType.Object:
                    return SqlDbType.Variant;
                case DbType.SByte:
                    return SqlDbType.TinyInt;
                case DbType.Single:
                    return SqlDbType.Real;
                case DbType.String:
                    return SqlDbType.NVarChar;
                case DbType.StringFixedLength:
                    return SqlDbType.NChar;
                case DbType.Time:
                    return SqlDbType.DateTime;
                case DbType.UInt16:
                    return SqlDbType.Int;
                case DbType.UInt32:
                    return SqlDbType.Int;
                case DbType.UInt64:
                    return SqlDbType.BigInt;
                case DbType.VarNumeric:
                    return SqlDbType.Decimal;

                default:
                    return SqlDbType.VarChar;
            }
        }

        public static DbType GetDbType(Type type)
        {
            DbType result;

            if(type == typeof(Int32))
                result = DbType.Int32;
            else if (type == typeof(Int16))
                result = DbType.Int16;
            else if (type == typeof(Int64))
                result = DbType.Int64;
            else if(type == typeof(DateTime))
                result = DbType.DateTime;
            else if(type == typeof(float))
                result = DbType.Decimal;
            else if(type == typeof(decimal))
                result = DbType.Decimal;
            else if(type == typeof(double))
                result = DbType.Double;
            else if(type == typeof(Guid))
                result = DbType.Guid;
            else if(type == typeof(bool))
                result = DbType.Boolean;
            else if(type == typeof(byte[]))
                result = DbType.Binary;
            else
                result = DbType.String;

            return result;
        }

        /// <summary>
        /// Takes the properties of an object and turns them into SubSonic.Query.Constraint
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static List<Constraint> ToConstraintList(this object value)
        {
            var hashedSet = value.ToDictionary();
            SqlQuery query = new SqlQuery();
            foreach(string key in hashedSet.Keys)
            {
                if(query.Constraints.Count == 0)
                    query.Where(key).IsEqualTo(hashedSet[key]);
                else
                    query.And(key).IsEqualTo(hashedSet[key]);
            }
            return query.Constraints;
        }
        public static void Load<T>(this IDataReader rdr, T item) {
            Load<T>(rdr, item, new List<string>());
        }

        /// <summary>
        /// Coerces an IDataReader to try and load an object using name/property matching
        /// </summary>
        public static void Load<T>(this IDataReader rdr, T item, List<string> ColumnNames) //mike added ColumnNames
        {
            Type iType = typeof(T);

            PropertyInfo[] cachedProps = iType.GetProperties();
            FieldInfo[] cachedFields = iType.GetFields();

            PropertyInfo currentProp;
            FieldInfo currentField = null;

            for(int i = 0; i < rdr.FieldCount; i++)
            {
                string pName = rdr.GetName(i);
                currentProp = cachedProps.SingleOrDefault(x => x.Name.Equals(pName, StringComparison.InvariantCultureIgnoreCase));

				//mike if the property is null and ColumnNames has data then look in ColumnNames for match
				if (currentProp == null && ColumnNames != null && ColumnNames.Count > i) {
					currentProp = cachedProps.First(x => x.Name == ColumnNames[i]);
				}
                
				//if the property is null, likely it's a Field
				if(currentProp == null)
                    currentField = cachedFields.SingleOrDefault(x => x.Name.Equals(pName, StringComparison.InvariantCultureIgnoreCase));

                if(currentProp != null && !DBNull.Value.Equals(rdr.GetValue(i)))
                {
                    Type valueType = rdr.GetValue(i).GetType();
                    if(valueType == typeof(Boolean))
                    {
                        string value = rdr.GetValue(i).ToString();
                        currentProp.SetValue(item, value == "1" || value == "True", null);
                    }
                    else if(currentProp.PropertyType == typeof(Guid))
                    {
						currentProp.SetValue(item, rdr.GetGuid(i), null);
					}
					else if (Objects.IsNullableEnum(currentProp.PropertyType))
					{
						var nullEnumObjectValue = Enum.ToObject(Nullable.GetUnderlyingType(currentProp.PropertyType), rdr.GetValue(i));
						currentProp.SetValue(item, nullEnumObjectValue, null);
					}
                    else{

					    var val = rdr.GetValue(i);
					    var valType = val.GetType();
                        //try to assign it
                        if (val.GetType().IsAssignableFrom(valueType)){
                            currentProp.SetValue(item, val, null);
                        } else {
                            currentProp.SetValue(item, rdr.GetValue(i).ChangeTypeTo(valueType), null);
                            
                        }

					}
                }
                else if(currentField != null && !DBNull.Value.Equals(rdr.GetValue(i)))
                {
                    Type valueType = rdr.GetValue(i).GetType();
                    if(valueType == typeof(Boolean))
                    {
                        string value = rdr.GetValue(i).ToString();
                        currentField.SetValue(item, value == "1" || value == "True");
                    }
                    else if(currentField.FieldType == typeof(Guid))
                    {
						currentField.SetValue(item, rdr.GetGuid(i));
					}
					else if (Objects.IsNullableEnum(currentField.FieldType))
					{
						var nullEnumObjectValue = Enum.ToObject(Nullable.GetUnderlyingType(currentField.FieldType), rdr.GetValue(i));
						currentField.SetValue(item, nullEnumObjectValue);
					}
                    else
                        currentField.SetValue(item, rdr.GetValue(i).ChangeTypeTo(valueType));
                }
            }

            if (item is IActiveRecord) {
                var arItem = (IActiveRecord)item;
                arItem.SetIsLoaded(true);
                arItem.SetIsNew(false);
                
            }

        }

    	/// <summary>
        /// Loads a single primitive value type
        /// </summary>
        /// <typeparam name="T"></typeparam>
        public static void LoadValueType<T>(this IDataReader rdr, ref T item)
        {
            Type iType = typeof(T);
            //thanks to Pascal LaCroix for the help here...

            if(iType.IsValueType)
            {
                // We assume only one field
                if(iType == typeof(Int16) || iType == typeof(Int32) || iType == typeof(Int64))
                    item = (T)Convert.ChangeType(rdr.GetValue(0), iType);
                else
                    item = (T)rdr.GetValue(0);
            }
        }

        /// <summary>
        /// Toes the type of the enumerable value.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="rdr">The IDataReader to read from.</param>
        /// <returns></returns>
        public static IEnumerable<T> ToEnumerableValueType<T>(this IDataReader rdr)
        {
            //thanks to Pascal LaCroix for the help here...
            List<T> result = new List<T>();
            while(rdr.Read())
            {
                var instance = Activator.CreateInstance<T>();
                LoadValueType(rdr, ref instance);
                result.Add(instance);
            }
            return result.AsEnumerable();
        }

        /// <summary>
        /// Determines whether [is core system type] [the specified type].
        /// </summary>
        /// <param name="type">The type.</param>
        /// <returns>
        /// 	<c>true</c> if [is core system type] [the specified type]; otherwise, <c>false</c>.
        /// </returns>
        private static bool IsCoreSystemType(Type type)
        {
            return type == typeof(string) ||
                   type == typeof(Int16) ||
                   type == typeof(Int16?) ||
                   type == typeof(Int32) ||
                   type == typeof(Int32?) ||
                   type == typeof(Int64) ||
                   type == typeof(Int64?) ||
                   type == typeof(decimal) ||
                   type == typeof(decimal?) ||
                   type == typeof(double) ||
                   type == typeof(double?) ||
                   type == typeof(DateTime) ||
                   type == typeof(DateTime?) ||
                   type == typeof(Guid) ||
                   type == typeof(Guid?) ||
                   type == typeof(bool) ||
                   type == typeof(bool?);
        }

        /// <summary>
        /// Coerces an IDataReader to load an enumerable of T
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="rdr"></param>

    	public static IEnumerable<T> ToEnumerable<T>(this IDataReader rdr, List<string> ColumnNames){//mike added ColumnNames

            List<T> result = new List<T>();
            while(rdr.Read()){
                T instance = default(T);
                var type = typeof(T);
                if(type.Name.Contains("AnonymousType")){
                
                    //this is an anon type and it has read-only fields that are set
                    //in a constructor. So - read the fields and build it
                    //http://stackoverflow.com/questions/478013/how-do-i-create-and-access-a-new-instance-of-an-anonymous-class-passed-as-a-param
                    var properties = TypeDescriptor.GetProperties(instance);
                    int objIdx = 0;
                    object[] objArray = new object[properties.Count];

                    foreach(PropertyDescriptor info in properties)
                        objArray[objIdx++] = rdr[info.Name];

                    result.Add((T)Activator.CreateInstance(instance.GetType(), objArray));
                }
                    //TODO: there has to be a better way to work with the type system
                else if(IsCoreSystemType(type))
                {
                    instance = (T)rdr.GetValue(0).ChangeTypeTo(type);
                    result.Add(instance);
                }
                else
                    instance = Activator.CreateInstance<T>();

                //do we have a parameterless constructor?
                Load(rdr, instance,ColumnNames);//mike added ColumnNames
                result.Add(instance);
            }
            return result.AsEnumerable();
        }

        /// <summary>
        /// Creates a typed list from an IDataReader
        /// </summary>
        public static List<T> ToList<T>(this IDataReader rdr) where T : new()
        {
            List<T> result = new List<T>();
            Type iType = typeof(T);

            //set the values        
            while(rdr.Read())
            {
                T item = new T();
                rdr.Load(item,null);//mike added null to match ColumnNames
                result.Add(item);
            }
            return result;
        }

        ///<summary>
        /// Builds a SubSonic UPDATE query from the passed-in object
        ///</summary>
        public static ISqlQuery ToUpdateQuery<T>(this T item, IDataProvider provider) where T : class, new()
        {
            Type type = typeof(T);
            var settings = item.ToDictionary();

            ITable tbl = provider.FindOrCreateTable<T>();

            Update<T> query = new Update<T>(tbl.Provider);
            if(item is IActiveRecord)
            {
                var ar = item as IActiveRecord;
                foreach(var dirty in ar.GetDirtyColumns())
                {
                    if(!dirty.IsPrimaryKey && !dirty.IsReadOnly)
                        query.Set(dirty.Name).EqualTo(settings[dirty.Name]);
                }
            }
            else
            {
                foreach(string key in settings.Keys)
                {
                    IColumn col = tbl.GetColumn(key);
                    if(col != null)
                    {
                        if(!col.IsPrimaryKey && !col.IsReadOnly)
                            query.Set(col).EqualTo(settings[key]);
                    }
                }
            }

            //add the PK constraint
            Constraint c = new Constraint(ConstraintType.Where, tbl.PrimaryKey.Name)
                               {
                                   ParameterValue = settings[tbl.PrimaryKey.Name],
                                   ParameterName = tbl.PrimaryKey.Name,
                                   ConstructionFragment = tbl.PrimaryKey.Name
                               };
            query.Constraints.Add(c);

            return query;
        }

        ///<summary>
        /// Builds a SubSonic INSERT query from the passed-in object
        ///</summary>
        public static ISqlQuery ToInsertQuery<T>(this T item, IDataProvider provider) where T : class, new()
        {
            Type type = typeof(T);
            ITable tbl = provider.FindOrCreateTable<T>();
            Insert query = null;

            if(tbl != null)
            {
                var hashed = item.ToDictionary();
                query = new Insert(provider).Into<T>(tbl);
                foreach(string key in hashed.Keys)
                {
                    IColumn col = tbl.GetColumn(key);
                    if(col != null)
                    {
                        if(!col.AutoIncrement && !col.IsReadOnly)
                            query.Value(col.QualifiedName, hashed[key], col.DataType);
                    }
                }
            }

            return query;
        }

        ///<summary>
        /// Builds a SubSonic DELETE query from the passed-in object
        ///</summary>
        public static ISqlQuery ToDeleteQuery<T>(this T item, IDataProvider provider) where T : class, new()
        {
            Type type = typeof(T);
            ITable tbl = provider.FindOrCreateTable<T>();
            var query = new Delete<T>(tbl, provider);
            if(tbl != null)
            {
                IColumn pk = tbl.PrimaryKey;
                var settings = item.ToDictionary();
                if(pk != null)
                {
                    var c = new Constraint(ConstraintType.Where, pk.Name)
                                {
                                    ParameterValue = settings[pk.Name],
                                    ParameterName = pk.Name,
                                    ConstructionFragment = pk.Name
                                };
                    query.Constraints.Add(c);
                }
                else
                    query.Constraints = item.ToConstraintList();
            }
            return query;
        }
    }
}
