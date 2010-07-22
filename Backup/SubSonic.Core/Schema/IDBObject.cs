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
using SubSonic.DataProviders;

namespace SubSonic.Schema
{
    public interface IDBObject
    {
        string Name { get; set; }
        string FriendlyName { get; set; }
        string QualifiedName { get; }
        string SchemaName { get; set; }
        IDataProvider Provider { get; set; }
    }
}