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
using System.Linq.Expressions;
using SubSonic.DataProviders;
using SubSonic.Linq.Structure;
using SubSonic.Schema;

namespace SubSonic.Query
{
    ///<summary>
    ///</summary>
    public interface IQuerySurface
    {
        IDataProvider Provider { get; }
        Select Select { get; }
        Insert Insert { get; }
        SqlQuery Avg<T>(Expression<Func<T, object>> column);
        SqlQuery Count<T>(Expression<Func<T, object>> column);
        SqlQuery Max<T>(Expression<Func<T, object>> column);
        SqlQuery Min<T>(Expression<Func<T, object>> column);
        SqlQuery Variance<T>(Expression<Func<T, object>> column);
        SqlQuery StandardDeviation<T>(Expression<Func<T, object>> column);
        SqlQuery Sum<T>(Expression<Func<T, object>> column);
        SqlQuery Delete<T>(Expression<Func<T, bool>> column) where T : new();
        Query<T> GetQuery<T>();
        ITable FindTable(string tableName);
        Update<T> Update<T>() where T : new();
    }
}