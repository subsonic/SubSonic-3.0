using System.Data;

namespace SubSonic.Schema
{
    public interface IColumn : IDBObject
    {
        bool IsForeignKey { get; set; }
        ITable Table { get; set; }
        DbType DataType { get; set; }
        int MaxLength { get; set; }
        bool IsNullable { get; set; }
        bool IsReadOnly { get; set; }
        bool IsComputed { get; set; }
        bool AutoIncrement { get; set; }
        int NumberScale { get; set; }
        int NumericPrecision { get; set; }
        bool IsPrimaryKey { get; set; }
        object DefaultSetting { get; set; }
        string ParameterName { get; }
        string PropertyName { get; set; }

        ITable ForeignKeyTo { get; set; }

        /// <summary>
        /// Gets a value indicating whether this instance is numeric.
        /// </summary>
        /// <value>
        /// 	<c>true</c> if this instance is numeric; otherwise, <c>false</c>.
        /// </value>
        bool IsNumeric { get; }

        /// <summary>
        /// Gets a value indicating whether this instance is date time.
        /// </summary>
        /// <value>
        /// 	<c>true</c> if this instance is date time; otherwise, <c>false</c>.
        /// </value>
        bool IsDateTime { get; }

        /// <summary>
        /// Gets a value indicating whether this instance is string.
        /// </summary>
        /// <value><c>true</c> if this instance is string; otherwise, <c>false</c>.</value>
        bool IsString { get; }

        string CreateSql { get; }
        string AlterSql { get; }
        string DeleteSql { get; }
    }
}