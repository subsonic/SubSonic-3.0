// 
//   SubSonic - http://subsonicproject.com
// 
//   The contents of this file are subject to the New BSD
//   License (the "License"); you may not use this file
//   except in compliance with the License. You may obtain a copy of
//   the License at http://www.opensource.org/licenses/bsd-license.php
//  
//   Software distributed under the License is distributed on an 
//   "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
//   implied. See the License for the specific language governing
//   rights and limitations under the License.
// 
using System;
using SubSonic.Schema;
using SubSonic.SqlGeneration;

namespace SubSonic.Query
{
    /// <summary>
    /// 
    /// </summary>
    public class Join
    {
        #region JoinType enum

        /// <summary>
        /// 
        /// </summary>
        public enum JoinType
        {
            /// <summary>
            /// 
            /// </summary>
            Inner,
            /// <summary>
            /// 
            /// </summary>
            Outer,
            /// <summary>
            /// 
            /// </summary>
            LeftInner,
            /// <summary>
            /// 
            /// </summary>
            LeftOuter,
            /// <summary>
            /// 
            /// </summary>
            RightInner,
            /// <summary>
            /// 
            /// </summary>
            RightOuter,
            /// <summary>
            /// 
            /// </summary>
            Cross,
            /// <summary>
            /// 
            /// </summary>
            NotEqual
        }

        #endregion


        private JoinType _joinType = JoinType.Inner;

        /// <summary>
        /// Initializes a new instance of the <see cref="Join"/> class.
        /// </summary>
        /// <param name="from">From.</param>
        /// <param name="to">To.</param>
        /// <param name="joinType">Type of the join.</param>
        public Join(IColumn from, IColumn to, JoinType joinType)
        {
            FromColumn = from;
            ToColumn = to;
            Type = joinType;
        }

        public Join(string fromTableName, string fromColumnName, string toTableName, string toColumnName, JoinType joinType)
        {
            /*
            //lookem up
            ITable tblFrom = (DatabaseTable)DataService.FindTable(fromTableName);
            if (tblFrom == null)
                tblFrom = DataService.FindTableByClassName(fromTableName);

            DatabaseTable tblTo = (DatabaseTable)DataService.FindTable(toTableName);
            if (tblTo == null)
                tblTo = DataService.FindTableByClassName(toTableName);
            
            DatabaseTableColumn fromCol = null;
            DatabaseTableColumn toCol = null;

            if (tblFrom != null) {
                fromCol = tblFrom.GetColumn(fromColumnName);

            }

            if (tblTo != null) {
                toCol = tblTo.GetColumn(toColumnName);
            }

            if (fromCol != null && toCol != null) {
                FromColumn = fromCol;
                ToColumn = toCol;
                Type = joinType;

            } else {
                throw new InvalidOperationException("Can't find the table/columns you're looking for");
            }
            */
        }

        /// <summary>
        /// Gets or sets the type.
        /// </summary>
        /// <value>The type.</value>
        public JoinType Type
        {
            get { return _joinType; }
            set { _joinType = value; }
        }

        /// <summary>
        /// Gets or sets from column.
        /// </summary>
        /// <value>From column.</value>
        public IColumn FromColumn { get; set; }

        /// <summary>
        /// Gets or sets to column.
        /// </summary>
        /// <value>To column.</value>
        public IColumn ToColumn { get; set; }

        /// <summary>
        /// Gets the join type value.
        /// </summary>
        /// <param name="j">The j.</param>
        /// <returns></returns>
        public static string GetJoinTypeValue(ISqlGenerator generator, JoinType j)
        {
            string result = generator.sqlFragment.INNER_JOIN;
            switch(j)
            {
                case JoinType.Outer:
                    result = generator.sqlFragment.OUTER_JOIN;
                    break;
                case JoinType.LeftInner:
                    result = generator.sqlFragment.LEFT_INNER_JOIN;
                    break;
                case JoinType.LeftOuter:
                    result = generator.sqlFragment.LEFT_OUTER_JOIN;
                    break;
                case JoinType.RightInner:
                    result = generator.sqlFragment.RIGHT_INNER_JOIN;
                    break;
                case JoinType.RightOuter:
                    result = generator.sqlFragment.RIGHT_OUTER_JOIN;
                    break;
                case JoinType.Cross:
                    result = generator.sqlFragment.CROSS_JOIN;
                    break;
                case JoinType.NotEqual:
                    result = generator.sqlFragment.UNEQUAL_JOIN;
                    break;
            }
            return result;
        }

        public override bool Equals(object obj)
        {
            if(typeof(object) == typeof(Join))
            {
                Join jCompare = (Join)obj;
                return (FromColumn.Name.Equals(jCompare.FromColumn.Name, StringComparison.InvariantCultureIgnoreCase) &&
                        ToColumn.Name.Equals(jCompare.ToColumn.Name, StringComparison.InvariantCultureIgnoreCase));
            }

            return base.Equals(obj);
        }

        public override int GetHashCode()
        {
            int hash = FromColumn.Name.GetHashCode() + ToColumn.Name.GetHashCode();
            return hash;
        }
    }
}