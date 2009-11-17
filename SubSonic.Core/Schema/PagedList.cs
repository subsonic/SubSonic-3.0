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
using System.Collections.Generic;
using System.Linq;

namespace SubSonic.Schema
{
    public interface IPagedList
    {
        int TotalCount { get; set; }

        int TotalPages { get; set; }

        int PageIndex { get; set; }

        int PageSize { get; set; }

        bool IsPreviousPage { get; }

        bool IsNextPage { get; }
    }

    public class PagedList<T> : List<T>, IPagedList
    {
        public PagedList(IQueryable<T> source, int index, int pageSize)
        {
            int total = source.Count();
            TotalCount = total;
            TotalPages = total / pageSize;

            if(total % pageSize > 0)
                TotalPages++;

            PageSize = pageSize;
            PageIndex = index;
            AddRange(source.Skip(index * pageSize).Take(pageSize).ToList());
        }

        public PagedList(IEnumerable<T> source, int totalRecords, int index, int pageSize)
        {
            TotalCount = totalRecords;
            TotalPages = totalRecords / pageSize;

            if(totalRecords % pageSize > 0)
                TotalPages++;

            PageSize = pageSize;
            PageIndex = index;
            AddRange(source.ToList());
        }


        #region IPagedList Members

        public int TotalPages { get; set; }

        public int TotalCount { get; set; }

        public int PageIndex { get; set; }

        public int PageSize { get; set; }

        public bool IsPreviousPage
        {
            get { return (PageIndex > 0); }
        }

        public bool IsNextPage
        {
            get { return ((PageIndex + 1) * PageSize) <= TotalCount; }
        }

        #endregion
    }

    public static class Pagination
    {
        public static PagedList<T> ToPagedList<T>(this IQueryable<T> source, int index, int pageSize)
        {
            return new PagedList<T>(source, index, pageSize);
        }

        public static PagedList<T> ToPagedList<T>(this IQueryable<T> source, int index)
        {
            return new PagedList<T>(source, index, 10);
        }
    }
}