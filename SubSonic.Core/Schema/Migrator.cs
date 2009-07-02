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
using System.Reflection;
using SubSonic.Extensions;
using SubSonic.DataProviders;

namespace SubSonic.Schema
{
    public class Migrator
    {
        private readonly Assembly _modelAssembly;

        public Migrator(Assembly modelAssembly)
        {
            _modelAssembly = modelAssembly;
        }

        ///<summary>
        /// Creates a set of SQL commands for synchronizing your database with your object set
        ///</summary>
        public string[] CreateColumnMigrationSql(ITable source)
        {
            var result = new List<string>();
            var existing = source.Provider.GetTableFromDB(source.Name);
            //remove columns not found
            foreach(var c in existing.Columns)
            {
                var colFound = source.GetColumn(c.Name);
                if(colFound == null)
                {
                    //remove it
                    result.Add(source.DropColumnSql(c.Name));
                }
            }
            //loop the existing table and add columns not found, update columns found...
            foreach(var col in source.Columns)
            {
                var colFound = existing.GetColumn(col.Name);
                if(colFound == null)
                {
                    //add it
                    string addSql = col.CreateSql;
                    //when adding a column, and UPDATE it appended
                    //need to split that out into its own command
                    var sqlCommands = addSql.Split(new char[]{';'},StringSplitOptions.RemoveEmptyEntries);
                    foreach (var s in sqlCommands)
                    {
                        result.Add(s);
                    }
                }
                else
                {
                    //don't want to alter the PK
                    if(!colFound.Equals(col) & ! col.IsPrimaryKey)
                    {
                            
                        if(!String.IsNullOrEmpty(col.AlterSql))
                            result.Add(col.AlterSql);
                        
                    }
                }
            }

            return result.ToArray();
        }

        public string[] MigrateFromModel<T>(IDataProvider provider)
        {
            return MigrateFromModel(typeof(T), provider);
        }

        public string[] MigrateFromModel(Type type, IDataProvider provider)
        {
            var result = new List<string>();

            var table = type.ToSchemaTable(provider);
            var existing = provider.GetTableFromDB(table.Name);

            if(existing != null)
            {
                //if the tables exist, reconcile the columns
                result.AddRange(CreateColumnMigrationSql(table));
            }
            else
            {
                //create tables for them
                result.Add(table.CreateSql);
            }
            return result.ToArray();
        }

        public string[] MigrateFromModel(string baseNameSpace, IDataProvider provider)
        {
            var result = new List<string>();

            //pull all the objects out of the namespace
            var modelTypes = _modelAssembly.GetTypes().Where(x => x.Namespace.StartsWith(baseNameSpace));

            foreach(var type in modelTypes)
                result.AddRange(MigrateFromModel(type, provider));

            return result.ToArray();
        }
    }
}