using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.Schema;
using System.Data.Common;

using LinFu.IoC;
using LinFu.IoC.Configuration;

namespace SubSonic.DataProviders.Providers
{
    [Implements(typeof(IDataProvider),ServiceName="System.Data.SQLite")]
    class SqLiteProvider: DbDataProvider, IDataProvider
    {
        private string _InsertionIdentityFetchString = "";
        public override string InsertionIdentityFetchString { get { return _InsertionIdentityFetchString; } }

        public SqLiteProvider(string connectionString, string providerName)
        {
            DbDataProviderName = String.IsNullOrEmpty(providerName) ? DEFAULT_DB_CLIENT_TYPE_NAME : providerName;
            Schema = new DatabaseSchema();
            ClientName = "System.Data.SQLite";
            ConnectionString = connectionString;
            Factory = DbProviderFactories.GetFactory(DbDataProviderName);
        }


        public override string QualifyTableName(ITable table)
        {
            string qualifiedTable;

            qualifiedTable = qualifiedTable = String.Format("`{0}`", table.Name);


            return qualifiedTable;
        }

        public override string QualifyColumnName(IColumn column)
        {
            string qualifiedFormat;
            qualifiedFormat = "`{2}`";
            return String.Format(qualifiedFormat, column.Table.SchemaName, column.Table.Name, column.Name);
        }

    }
}
