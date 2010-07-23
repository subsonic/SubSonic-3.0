using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.Schema;
using System.Data.Common;
using LinFu.IoC.Configuration;
using System.ComponentModel.Composition;

namespace SubSonic.DataProviders.SqlServer
{
    //[Implements(typeof(IDataProvider), ServiceName = "System.Data.SqlClient")]
    
    class SqlServerProvider : DbDataProvider, IDataProvider
    {
        private string _InsertionIdentityFetchString = "; SELECT SCOPE_IDENTITY() as new_id";
        public override string InsertionIdentityFetchString { get { return _InsertionIdentityFetchString; } }

        

        public SqlServerProvider()
        {
            Schema = new DatabaseSchema();
            ClientName = "System.Data.SqlClient";
        }

        public SqlServerProvider(string connectionString, string providerName)
        {
            DbDataProviderName = String.IsNullOrEmpty(providerName) ? DEFAULT_DB_CLIENT_TYPE_NAME : providerName;
            Schema = new DatabaseSchema();
            ClientName = "System.Data.SqlClient";
            
            ConnectionString = connectionString;
            Factory = DbProviderFactories.GetFactory(DbDataProviderName);
        }


        public override string QualifyTableName(ITable table)
        {
            string qualifiedTable;


            string qualifiedFormat = String.IsNullOrEmpty(table.SchemaName) ? "[{1}]" : "[{0}].[{1}]";
            qualifiedTable = String.Format(qualifiedFormat, table.SchemaName, table.Name);


            return qualifiedTable;
        }

        public override string QualifyColumnName(IColumn column)
        {
            string qualifiedFormat;
            qualifiedFormat = String.IsNullOrEmpty(column.SchemaName) ? "[{1}].[{2}]" : "[{0}].[{1}].[{2}]";
            return String.Format(qualifiedFormat, column.Table.SchemaName, column.Table.Name, column.Name);
        }

    }
}
