using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.Schema;
using System.Data.Common;
using LinFu.IoC.Configuration;


namespace SubSonic.DataProviders.Providers
{
    [Implements(typeof(IDataProvider), ServiceName = "MySql.Data.MySqlClient")]
    class MySQLProvider:DbDataProvider
    {
        private string _InsertionIdentityFetchString = "";
        public override string InsertionIdentityFetchString { get { return _InsertionIdentityFetchString; } }

        public MySQLProvider(string connectionString, string providerName)
        {
            DbDataProviderName = String.IsNullOrEmpty(providerName) ? DEFAULT_DB_CLIENT_TYPE_NAME : providerName;
            Schema = new DatabaseSchema();
            ClientName = "MySql.Data.MySqlClient";
            ConnectionString = connectionString;
            Factory = DbProviderFactories.GetFactory(DbDataProviderName);
        }

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
        
    }
}
