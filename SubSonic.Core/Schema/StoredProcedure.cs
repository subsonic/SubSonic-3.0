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
using System.Data;
using System.Data.Common;
using SubSonic.Extensions;
using SubSonic.DataProviders;
using SubSonic.Query;

namespace SubSonic.Schema
{
    public class StoredProcedure : IStoredProcedure
    {
        public StoredProcedure(string spName) : this(spName, ProviderFactory.GetProvider()) {}

        public StoredProcedure(string spName, IDataProvider provider)
        {
            Provider = provider;
            Command = new QueryCommand(spName, Provider)
                          {
                              CommandType = CommandType.StoredProcedure
                          };
        }

        public QueryCommand Command { get; private set; }

        public string ParameterName
        {
            get
            {
                const string paramFormat = "{0}{1}";
                return string.Format(paramFormat, Provider.ParameterPrefix, Name);
            }
        }


        #region IStoredProcedure Members

        public object Output { get; set; }

        public string SchemaName { get; set; }
        public string FriendlyName { get; set; }
        public string Name { get; set; }

        public string QualifiedName
        {
            get { return Provider.QualifySPName(this); }
        }

        public IDataProvider Provider { get; set; }

        #endregion


        #region Execution

        /// <summary>
        /// Executes the specified SQL.
        /// </summary>
        public void Execute()
        {
            Provider.ExecuteQuery(Command);
        }

        /// <summary>
        /// Executes the scalar.
        /// </summary>
        /// <typeparam name="TResult">The type of the result.</typeparam>
        /// <returns></returns>
        public TResult ExecuteScalar<TResult>()
        {
            TResult result = (TResult)Provider.ExecuteScalar(Command).ChangeTypeTo<TResult>();
            return result;
        }

        /// <summary>
        /// Executes the typed list.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public List<T> ExecuteTypedList<T>() where T : new()
        {
            return Provider.ToList<T>(Command) as List<T>;
        }

        /// <summary>
        /// Executes the reader.
        /// </summary>
        /// <returns></returns>
        public DbDataReader ExecuteReader()
        {
            return Provider.ExecuteReader(Command);
        }

        public DataSet ExecuteDataSet()
        {
            return Provider.ExecuteDataSet(Command);
        }

        #endregion
    }
}