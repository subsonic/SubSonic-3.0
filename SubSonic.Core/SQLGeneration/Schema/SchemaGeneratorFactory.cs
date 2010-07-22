using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.DataProviders;

namespace SubSonic.SqlGeneration.Schema
{
    public static class SchemaGeneratorFactory
    {
        public static ISchemaGenerator Create(DataClient client)
        {
            switch (client)
            {
                case DataClient.SqlClient:
                    return new Sql2005Schema();
                case DataClient.MySqlClient:
                    return new MySqlSchema();
                case DataClient.SQLite:
                    return new SQLiteSchema();
                default:
                    throw new ArgumentOutOfRangeException(client.ToString(), "There is no generator for this client");
            }
        }
    }
}
