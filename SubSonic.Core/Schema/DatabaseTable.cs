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
using System.Collections.Generic;
using System.Linq;
using SubSonic.Extensions;
using SubSonic.DataProviders;

namespace SubSonic.Schema
{
    public class DatabaseTable : ITable
    {
        protected IDataProvider _provider;

        public DatabaseTable()
        {
            Columns = new List<IColumn>();
        }

        public DatabaseTable(string name, IDataProvider provider)
            : this(null, name, provider, null) {}

        public DatabaseTable(string name, IDataProvider provider, string classname)
            : this(null, name, provider, classname) {}

        public DatabaseTable(string schema, string name, IDataProvider provider) :
            this(schema, name, provider, null) {}

        public DatabaseTable(string schema, string name, IDataProvider provider, string classname)
        {
            _provider = provider;
            Name = name;
            SchemaName = schema;
            ClassName = classname;
            Columns = new List<IColumn>();
        }

        public IColumn[] PrimaryKeys
        {
            get { return Columns.Where(c => c.IsPrimaryKey).ToArray(); }
        }


        #region ITable Members

        public string QualifiedName
        {
            get { return Provider.QualifyTableName(this); }
        }

        public bool HasPrimaryKey
        {
            get { return PrimaryKey != null; }
        }

        public IColumn PrimaryKey
        {
            get { return Columns.Where(c => c.IsPrimaryKey).FirstOrDefault(); }
        }

        public IColumn Descriptor
        {
            get
            {
                IColumn result = null;
                foreach(var col in Columns)
                {
                    if(!col.IsPrimaryKey && col.IsString & !col.IsForeignKey)
                    {
                        result = col;
                        break;
                    }
                }
                if(result == null)
                    result = PrimaryKey;

                return result;
            }
        }

        public string SchemaName { get; set; }
        public string Name { get; set; }
        public string FriendlyName { get; set; }
        public string ClassName { get; set; }

        public IDataProvider Provider
        {
            get { return _provider; }
            set { _provider = value; }
        }

        public IList<IColumn> Columns { get; set; }

        public IColumn GetColumn(string ColumnName)
        {
            return Columns.Where(c => c.Name.Matches(ColumnName)).SingleOrDefault();
        }

        public IColumn GetColumnByPropertyName(string PropertyName)
        {
            return Columns.SingleOrDefault(x => x.Name.Equals(PropertyName, StringComparison.InvariantCultureIgnoreCase));
        }

        public string CreateSql
        {
            get { return Provider.SchemaGenerator.BuildCreateTableStatement(this); }
        }

        public string DropSql
        {
            get { return Provider.SchemaGenerator.BuildDropTableStatement(QualifiedName); }
        }

        public string DropColumnSql(string columnName)
        {
            return Provider.SchemaGenerator.BuildDropColumnStatement(Name, columnName);
        }

        #endregion


        public override string ToString()
        {
            return Name;
        }

        /// <summary>
        /// 
        /// </summary>
        public enum TableType
        {
            /// <summary>
            /// 
            /// </summary>
            Table,
            /// <summary>
            /// 
            /// </summary>
            View
        }

    }
}