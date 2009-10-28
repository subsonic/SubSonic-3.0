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
using System.Data;
using SubSonic.DataProviders;

namespace SubSonic.Schema
{
    public class DatabaseColumn : IColumn
    {
        /// <summary>
        /// Summary for the ReservedColumnName class
        /// </summary>
        public class ReservedColumnName
        {
            public const string CREATED_BY = "CreatedBy";
            public const string CREATED_ON = "CreatedOn";
            public const string DELETED = "Deleted";
            public const string IS_ACTIVE = "IsActive";
            public const string IS_DELETED = "IsDeleted";
            public const string MODIFIED_BY = "ModifiedBy";
            public const string MODIFIED_ON = "ModifiedOn";
        }

        public DatabaseColumn() {}

        public DatabaseColumn(ITable tbl)
            : this(String.Empty, tbl) {}

        public DatabaseColumn(string columnName, ITable tbl)
        {
            Table = tbl;
            Name = columnName;
        }


        #region IColumn Members

        public bool IsForeignKey { get; set; }
        public ITable Table { get; set; }
        public DbType DataType { get; set; }
        public int MaxLength { get; set; }
        public bool IsNullable { get; set; }
        public bool IsReadOnly { get; set; }
        public bool IsComputed { get; set; }
        public bool AutoIncrement { get; set; }
        public int NumberScale { get; set; }
        public int NumericPrecision { get; set; }
        public bool IsPrimaryKey { get; set; }
        public object DefaultSetting { get; set; }

        public string SchemaName
        {
            get { return Table.SchemaName; }
            set { Table.SchemaName = value; }
        }

        public IDataProvider Provider
        {
            get { return Table.Provider; }
            set { Table.Provider = value; }
        }

        public string Name { get; set; }
        public string PropertyName { get; set; }

        public string ParameterName
        {
            get
            {
                const string paramFormat = "{0}{1}";
                return string.Format(paramFormat, Table.Provider.ParameterPrefix, PropertyName);
            }
        }

        public string QualifiedName
        {
            get { return Table.Provider.QualifyColumnName(this); }
        }

        public ITable ForeignKeyTo { get; set; }
        public string FriendlyName { get; set; }

        /// <summary>
        /// Gets a value indicating whether this instance is numeric.
        /// </summary>
        /// <value>
        /// 	<c>true</c> if this instance is numeric; otherwise, <c>false</c>.
        /// </value>
        public bool IsNumeric
        {
            get
            {
                return DataType == DbType.Currency ||
                       DataType == DbType.Decimal ||
                       DataType == DbType.Double ||
                       DataType == DbType.Int16 ||
                       DataType == DbType.Int32 ||
                       DataType == DbType.Int64 ||
                       DataType == DbType.Single ||
                       DataType == DbType.UInt16 ||
                       DataType == DbType.UInt32 ||
                       DataType == DbType.UInt64 ||
                       DataType == DbType.VarNumeric;
            }
        }

        /// <summary>
        /// Gets a value indicating whether this instance is date time.
        /// </summary>
        /// <value>
        /// 	<c>true</c> if this instance is date time; otherwise, <c>false</c>.
        /// </value>
        public bool IsDateTime
        {
            get
            {
                return DataType == DbType.DateTime ||
                       DataType == DbType.Time ||
                       DataType == DbType.Date;
            }
        }

        /// <summary>
        /// Gets a value indicating whether this instance is string.
        /// </summary>
        /// <value><c>true</c> if this instance is string; otherwise, <c>false</c>.</value>
        public bool IsString
        {
            get
            {
                return DataType == DbType.AnsiString ||
                       DataType == DbType.AnsiStringFixedLength ||
                       DataType == DbType.String ||
                       DataType == DbType.StringFixedLength;
            }
        }

        public string CreateSql
        {
            get { return Provider.SchemaGenerator.BuildAddColumnStatement(Table.Name, this); }
        }

        public string AlterSql
        {
            get { return Provider.SchemaGenerator.BuildAlterColumnStatement(this); }
        }

        public string DeleteSql
        {
            get { return Provider.SchemaGenerator.BuildDropColumnStatement(Table.Name, Name); }
        }

        #endregion


        public override string ToString()
        {
            return Name;
        }

        public override bool Equals(object obj)
        {
            if(obj.GetType() == typeof(IColumn))
            {
                DatabaseColumn compareTo = (DatabaseColumn)obj;

                if(IsPrimaryKey)
                    return true; //no altering the PK

                if(DataType == DbType.String)
                    return compareTo.DataType == DataType && MaxLength == compareTo.MaxLength;

                if(IsNumeric)
                {
                    return compareTo.DataType == DataType
                           && NumericPrecision == compareTo.NumericPrecision
                           && NumberScale == compareTo.NumberScale;
                }
                return compareTo.DataType == DataType;
            }
            return base.Equals(obj);
        }

        public override int GetHashCode()
        {
            return base.GetHashCode();
        }
    }
}