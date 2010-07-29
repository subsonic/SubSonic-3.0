using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


namespace SubSonic.DataProviders
{
    
    public interface ISqlFragment
    {
        string AND { get; }
        string AS { get; }
        string ASC { get; }
        string BETWEEN { get; }
        string CROSS_JOIN { get; }
        string DELETE_FROM { get; }
        string DESC { get; }
        string DISTINCT { get; }
        string EQUAL_TO { get; }
        string FROM { get; }
        string GROUP_BY { get; }
        string HAVING { get; }
        string IN { get; }

        string INNER_JOIN { get; }

        string INSERT_INTO { get; }
        string JOIN_PREFIX { get; }
        string LEFT_INNER_JOIN { get; }
        string LEFT_JOIN { get; }
        string LEFT_OUTER_JOIN { get; }
        string NOT_EQUAL_TO { get; }
        string NOT_IN { get; }
        string ON { get; }
        string OR { get; }
        string ORDER_BY { get; }
        string OUTER_JOIN { get; }
        string RIGHT_INNER_JOIN { get; }
        string RIGHT_JOIN { get; }
        string RIGHT_OUTER_JOIN { get; }
        string SELECT { get; }
        string SET { get; }
        string SPACE { get; }
        string TOP { get; }
        string UNEQUAL_JOIN { get; }
        string UPDATE { get; }
        string WHERE { get; }

        string ClientName { get; set; }
    }
}
