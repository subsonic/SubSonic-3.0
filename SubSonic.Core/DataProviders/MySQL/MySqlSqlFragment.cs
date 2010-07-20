using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using LinFu.IoC.Configuration;
using SubSonic.DataProviders;
using SubSonic.SqlGeneration;

namespace SubSonic.DataProviders.MySQL
{
    [Implements(typeof(ISqlFragment), ServiceName="MySql.Data.MySqlClient")]
    class MySqlSqlFragment : SqlFragment
    {
        public MySqlSqlFragment()
        {
            this.LEFT_INNER_JOIN = this.LEFT_JOIN;  //MSSQL Doesn't like standard left join syntax.
            this.RIGHT_INNER_JOIN = this.RIGHT_JOIN;

        }
    }
}

