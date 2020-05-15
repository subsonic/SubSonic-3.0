using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Data.SQLite;
using System.Linq;
using System.Text;

namespace SubSonic.Tests
{
    public class DbClientTypeName
    {
#if DOTNETCORE || DOTNETSTANDARD
        static DbClientTypeName()
        {
            // Registering DbProviderFactories using app.config is only possible in the full framework
            // Applications using SubSonic.Core must register the factories before calling the deeper layer like below
            // This static constructor is not the best place - but I didn't intent to refactor the whole tests
            DbProviderFactories.RegisterFactory(MsSql, System.Data.SqlClient.SqlClientFactory.Instance);
            DbProviderFactories.RegisterFactory(MySqlClient, MySql.Data.MySqlClient.MySqlClientFactory.Instance);
            DbProviderFactories.RegisterFactory(SqlLite, SQLiteFactory.Instance);
        }
#endif

        public static string MsSql { get; } = "System.Data.SqlClient";
        public static string MsSqlCe { get; } = "System.Data.SqlServerCe.3.5";
        public static string MySqlClient { get; } = "MySql.Data.MySqlClient";
        //public const string OleDb = "System.Data.OleDb";
        public static string Oracle { get; } = "System.Data.OracleClient";
        public static string SqlLite { get; } = "System.Data.SQLite";
    }
}
