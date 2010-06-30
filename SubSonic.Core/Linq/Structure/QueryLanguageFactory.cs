using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.DataProviders;
using SubSonic.Linq.Translation.MySql;
using SubSonic.Linq.Translation.SQLite;

namespace SubSonic.Linq.Structure
{
    public static class QueryLanguageFactory
    {
        public static QueryLanguage Create(IDataProvider provider)
        {
            switch (provider.Client)
            {
                case DataClient.MySqlClient:
                    return new MySqlLanguage(provider);
                case DataClient.SQLite:
                    return new SqliteLanguage(provider);
                default:
                    return new TSqlLanguage(provider);
            }
        }
    }
}
