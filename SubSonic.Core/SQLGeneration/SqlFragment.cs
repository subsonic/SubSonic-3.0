using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using SubSonic.DataProviders;

namespace SubSonic.SqlGeneration
{
    /// <summary>
    /// Summary for the SqlFragment class
    /// </summary>
    public class SqlFragment : ISqlFragment
    {
        public string ClientName{get;set;}

        private string _and = " AND ";
        public string AND { get { return _and; } set { _and = value; } }

        private string _as = " AS ";
        public string AS { get { return _as; } set { _as = value; } }

        private string _asc = " ASC";
        public string ASC { get { return _asc; } set { _asc = value; } }

        private string _between = " BETWEEN ";
        public string BETWEEN { get { return _between; } set { _between = value; } }

        private string _cross_join = " CROSS JOIN ";
        public string CROSS_JOIN { get { return _cross_join; } set { _cross_join = value; } }

        private string _delete_from = "DELETE FROM ";
        public string DELETE_FROM { get { return _delete_from; } set { _delete_from = value; } }

        private string _desc = " DESC";
        public string DESC { get { return _desc; } set { _desc = value; } }

        private string _distinct = "DISTINCT ";
        public string DISTINCT { get { return _distinct; } set { _distinct = value; } }

        private string _equal_to = " = ";
        public string EQUAL_TO { get { return _equal_to; } set { _equal_to = value; } }

        private string _from = " FROM ";
        public string FROM { get { return _from; } set { _from = value; } }

        private string _group_by = " GROUP BY ";
        public string GROUP_BY { get { return _group_by; } set { _group_by = value; } }

        private string _having = " HAVING ";
        public string HAVING { get { return _having; } set { _having = value; } }

        private string _in = " IN ";
        public string IN { get { return _in; } set { _in = value; } }

        private string _inner_join = " INNER JOIN ";
        public string INNER_JOIN { get { return _inner_join; } set { _inner_join = value; } }

        private string _insert_into = "INSERT INTO ";
        public string INSERT_INTO { get { return _insert_into; } set { _insert_into = value; } }

        private string _join_prefix = "J";
        public string JOIN_PREFIX { get { return _join_prefix; } set { _join_prefix = value; } }

        private string _left_inner_join = " LEFT INNER JOIN ";
        public string LEFT_INNER_JOIN { get { return _left_inner_join; } set { _left_inner_join = value; } }

        private string _left_join = " LEFT JOIN ";
        public string LEFT_JOIN { get { return _left_join; } set { _left_join = value; } }

        private string _left_outer_join = " LEFT OUTER JOIN ";
        public string LEFT_OUTER_JOIN { get { return _left_outer_join; } set { _left_outer_join = value; } }

        private string _not_equal_to = " <> ";
        public string NOT_EQUAL_TO { get { return _not_equal_to; } set { _not_equal_to = value; } }

        private string _not_in = " NOT IN ";
        public string NOT_IN { get { return _not_in; } set { _not_in = value; } }

        private string _on = " ON ";
        public string ON { get { return _on; } set { _on = value; } }

        private string _or = " OR ";
        public string OR { get { return _or; } set { _or = value; } }

        private string _order_by = " ORDER BY ";
        public string ORDER_BY { get { return _order_by; } set { _order_by = value; } }

        private string _outer_join = " OUTER JOIN ";
        public string OUTER_JOIN { get { return _outer_join; } set { _outer_join = value; } }

        private string _right_inner_join = " RIGHT INNER JOIN ";
        public string RIGHT_INNER_JOIN { get { return _right_inner_join; } set { _right_inner_join = value; } }

        private string _right_join = " RIGHT JOIN ";
        public string RIGHT_JOIN { get { return _right_join; } set { _right_join = value; } }

        private string _right_outer_join = " RIGHT OUTER JOIN ";
        public string RIGHT_OUTER_JOIN { get { return _right_outer_join; } set { _right_outer_join = value; } }

        private string _select = "SELECT ";
        public string SELECT { get { return _select; } set { _select = value; } }

        private string _set = " SET ";
        public string SET { get { return _set; } set { _set = value; } }

        private string _space = " ";
        public string SPACE { get { return _space; } set { _space = value; } }

        private string _top = "TOP ";
        public string TOP { get { return _top; } set { _top = value; } }

        private string _unequal_join = " JOIN ";
        public string UNEQUAL_JOIN { get { return _unequal_join; } set { _unequal_join = value; } }

        private string _update = "UPDATE ";
        public string UPDATE { get { return _update; } set { _update = value; } }

        private string _where = " WHERE ";
        public string WHERE { get { return _where; } set { _where = value; } }


    }
}
