using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.Schema;
using System.Data.Common;
using SubSonic.DataProviders.Schema;
using SubSonic.Linq.Structure;
using SubSonic.Query;



namespace SubSonic.DataProviders.MySQL
{
    class MySQLProvider : DbDataProvider
    {
        private string _insertionIdentityFetchString = "";
        public override string InsertionIdentityFetchString { get { return _insertionIdentityFetchString; } }

        public MySQLProvider(string connectionString, string providerName) : base(connectionString, providerName)
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
