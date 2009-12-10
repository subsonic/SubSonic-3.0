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
using System.Text;
using SubSonic.DataProviders;
using SubSonic.Schema;
using SubSonic.SqlGeneration;

namespace SubSonic.Query
{
    /// <summary>
    /// 
    /// </summary>
    public class Select : SqlQuery
    {
        private SqlFragment sqlFragment;

        /// <summary>
        /// Initializes a new instance of the <see cref="Select"/> class.
        /// </summary>
        /// <param name="provider">The provider.</param>
        /// <param name="columns">The columns.</param>
        public Select(IDataProvider provider, params string[] columns)
        {
            this.sqlFragment = new SqlFragment(_provider);
            _provider = provider;
            SelectColumnList = columns;
            SQLCommand = this.sqlFragment.SELECT;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="Select"/> class.
        /// </summary>
        public Select()
        {
            _provider = ProviderFactory.GetProvider();
            this.sqlFragment = new SqlFragment(_provider);
            SQLCommand = this.sqlFragment.SELECT;
        }

        public Select(IDataProvider provider)
        {
            _provider = provider;
            this.sqlFragment = new SqlFragment(_provider);
            SQLCommand = this.sqlFragment.SELECT;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="Select"/> class.
        /// </summary>
        /// <param name="aggregates">The aggregates.</param>
        public Select(params Aggregate[] aggregates)
        {
            _provider = ProviderFactory.GetProvider();
            this.sqlFragment = new SqlFragment(_provider);
            SQLCommand = this.sqlFragment.SELECT;
            foreach(Aggregate agg in aggregates)
                Aggregates.Add(agg);
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="Select"/> class.
        /// </summary>
        /// <param name="provider">The provider.</param>
        /// <param name="aggregates">The aggregates.</param>
        public Select(IDataProvider provider, params Aggregate[] aggregates)
        {
            _provider = provider;
            this.sqlFragment = new SqlFragment(_provider);
            SQLCommand = this.sqlFragment.SELECT;
            foreach(Aggregate agg in aggregates)
                Aggregates.Add(agg);
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="Select"/> class.
        /// </summary>
        /// <param name="columns">The columns.</param>
        public Select(params IColumn[] columns)
        {
            if(columns.Length > 0)
            {
                _provider = columns[0].Table.Provider;
                this.sqlFragment = new SqlFragment(_provider);
                SQLCommand = this.sqlFragment.SELECT;
                
                
                SelectColumnList = new string[columns.Length];
                for (int i = 0; i < columns.Length; i++)
                    SelectColumnList[i] = columns[i].QualifiedName;
                
                //user entered an array
                //StringBuilder sb = new StringBuilder();
                //foreach(IColumn col in columns)
                //    sb.AppendFormat("{0}|", col.QualifiedName);

                //SelectColumnList = sb.ToString().Split(new char[] {'|'}, StringSplitOptions.RemoveEmptyEntries);
            }
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="Select"/> class.
        /// WARNING: This overload should only be used with applications that use a single provider!
        /// </summary>
        /// <param name="columns">The columns.</param>
        public Select(params string[] columns)
        {
            _provider = ProviderFactory.GetProvider();
            this.sqlFragment = new SqlFragment(_provider);
            SQLCommand = this.sqlFragment.SELECT;
            if(columns.Length == 1 && columns[0].Contains(","))
            {
                //user entered a single string column list: "col1, col2, col3"
                SelectColumnList = columns[0].Split(new [] {','}, StringSplitOptions.RemoveEmptyEntries);
                for (int i = 0; i < SelectColumnList.Length; i++)
                    SelectColumnList[i] = SelectColumnList[i].Trim();
            }
            else
            {
                //user entered an array
                SelectColumnList = columns;
            }
        }

        /// <summary>
        /// Alls the columns from.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public static Select AllColumnsFrom<T>() where T : ITable, new()
        {
            T item = new T();
            Select s = new Select(item.Provider);
            s.FromTables.Add(item);
            return s;
        }

        /// <summary>
        /// Expressions the specified SQL expression.
        /// </summary>
        /// <param name="sqlExpression">The SQL expression.</param>
        /// <returns></returns>
        public Select Expression(string sqlExpression)
        {
            _provider = ProviderFactory.GetProvider();
            this.sqlFragment = new SqlFragment(_provider);
            SQLCommand = this.sqlFragment.SELECT;
            Expressions.Add(sqlExpression);
            return this;
        }

        /// <summary>
        /// Tops the specified top.
        /// </summary>
        /// <param name="top">The top.</param>
        /// <returns></returns>
        public Select Top(string top)
        {
            SQLCommand = this.sqlFragment.SELECT;
            if(!top.ToLower().Trim().Contains("top"))
                top = String.Concat(" TOP ", top);
            TopSpec = top;
            return this;
        }
    }
}