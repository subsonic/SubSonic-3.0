using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.Schema;
using System.Data.Common;
using SubSonic.Linq.Structure;
using SubSonic.Query;



namespace SubSonic.DataProviders.MySQL
{
    class MySqlProvider : DbDataProvider
    {
        public override string InsertionIdentityFetchString { get { return String.Empty; } }

        public MySqlProvider(string connectionString, string providerName) : base(connectionString, providerName)
        {}

        public override string QualifyTableName(ITable table)
        {
            return String.Format("`{0}`", table.Name);
        }

        public override string QualifyColumnName(IColumn column)
        {
            string qualifiedFormat;

            qualifiedFormat = String.IsNullOrEmpty(column.SchemaName) ? "`{2}`" : "`{0}`.`{1}`.`{2}`";
        
            return String.Format(qualifiedFormat, column.Table.SchemaName, column.Table.Name, column.Name);
        }

        public override ISchemaGenerator SchemaGenerator
        {
            get { return new MySqlSchema(); }
        }

        public override ISqlGenerator GetSqlGenerator(SqlQuery query)
        {
            return new MySqlGenerator(query);
        }

        public override IQueryLanguage QueryLanguage { get { return new MySqlLanguage(this); } }
    }
}
