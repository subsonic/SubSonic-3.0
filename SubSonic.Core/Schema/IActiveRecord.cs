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
using SubSonic.DataProviders;

namespace SubSonic.Schema
{
    public interface IActiveRecord
    {
        void Delete();
        List<IColumn> GetDirtyColumns();
        bool IsDirty();
        bool IsNew();
        bool IsLoaded();
        string KeyName();
        object KeyValue();
        string DescriptorColumn();
        string DescriptorValue();
        void Load(IDataReader rdr);
        void Load(IDataReader rdr, bool closeReader);
        void Save();
        void Save(IDataProvider provider);
        void Add();
        void Add(IDataProvider provider);
        void Update();
        void Update(IDataProvider provider);
        DbCommand GetUpdateCommand();
        DbCommand GetInsertCommand();
        DbCommand GetDeleteCommand();
        void SetKeyValue(object value);
        void SetIsLoaded(bool isLoaded);
        void SetIsNew(bool isLoaded);

    }
}