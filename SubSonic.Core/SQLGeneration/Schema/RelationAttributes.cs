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
using System.Linq;
using System.Data;
using SubSonic.Schema;
using System.Reflection;
using System.Collections.Generic;

namespace SubSonic.SqlGeneration.Schema
{
    public interface IRelationMappingAttribute
    {
        bool Accept(IRelation column, PropertyInfo property);
        void Apply(IRelation column, PropertyInfo property);
    }

    public abstract class AbstractSubSonicRelationAttribute : Attribute, IRelationMappingAttribute
    {
        public string JoinKeyName { get; set; }

        private Qualifier _qualifier;

        protected AbstractSubSonicRelationAttribute(Qualifier qualifier)
        {
            _qualifier = qualifier;
        }

        public virtual bool Accept(IRelation relation, PropertyInfo prop)
        {
            return true;
        }

        public virtual void Apply(IRelation relation, PropertyInfo prop)
        {
            DiscoverTargetTable(relation, prop);
            DiscoverJoinKeys(relation, prop);

            relation.Qualifier = _qualifier;
        }

        protected virtual void DiscoverJoinKeys(IRelation relation, PropertyInfo prop)
        {
            var keyNames = BuildKeyNames(relation.Table);

            relation.JoinKey = relation.Table.PrimaryKey;
            relation.TargetJoinKey = FindColumnByNames(relation.TargetTable, keyNames);
        }

        protected string[] BuildKeyNames(ITable table)
        {
            if (String.IsNullOrEmpty(JoinKeyName))
            {
                return new[] { "ID" + table.ClassName, table.ClassName + "ID" };
            }

            return new[] { JoinKeyName };
        }

        protected virtual IColumn FindColumnByNames(ITable table, params string[] foreignKeyNames)
        {
            var foreignKey = table.Columns.FirstOrDefault(c =>
                    foreignKeyNames.Any(f => c.Name.Equals(f, StringComparison.InvariantCultureIgnoreCase)));

            if (foreignKey == null)
            {
                throw new InvalidOperationException(
                    String.Format("Could not locate foreign key in type {0} using foreign key names '{1}'",
                    table.ClassName, String.Join(", ", foreignKeyNames)));
            }

            return foreignKey;
        }

        protected virtual void DiscoverTargetTable(IRelation relation, PropertyInfo prop)
        {
            relation.TargetType = GetRelationType(relation, prop);
            relation.TargetTable = relation.Table.Provider.FindOrCreateTable(relation.TargetType);
        }

        protected abstract Type GetRelationType(IRelation relation, PropertyInfo prop);
    }

    [AttributeUsage(AttributeTargets.Property)]
    public class SubSonicToManyRelationAttribute : AbstractSubSonicRelationAttribute, IRelationMappingAttribute
    {
        public SubSonicToManyRelationAttribute()
            : base(Qualifier.Many)
        { }

        protected override Type GetRelationType(IRelation relation, PropertyInfo prop)
        {
            if (!prop.PropertyType.IsGenericType)
            {
                throw new InvalidOperationException("Expecting a generic collection to use this property as one to many collection");
            }

            var relationType = prop.PropertyType.GetGenericArguments()[0];
            var listGeneric = typeof(List<>).MakeGenericType(relationType);

            if (!prop.PropertyType.IsAssignableFrom(listGeneric))
            {
                throw new InvalidOperationException("Expecting a collection type that is assignable from List<T> to use this propery as one to many collection");
            }

            return relationType;
        }
    }

    [AttributeUsage(AttributeTargets.Property)]
    public class SubSonicToOneRelationAttribute : AbstractSubSonicRelationAttribute, IRelationMappingAttribute
    {
        public bool ThisClassContainsJoinKey { get; set; }

        public SubSonicToOneRelationAttribute()
            : base(Qualifier.One)
        {
            ThisClassContainsJoinKey = false;
        }

        protected override Type GetRelationType(IRelation relation, PropertyInfo prop)
        {
            return prop.PropertyType;
        }

        protected override void DiscoverJoinKeys(IRelation relation, PropertyInfo prop)
        {
            if (ThisClassContainsJoinKey)
            {
                relation.TargetJoinKey = relation.TargetTable.PrimaryKey;

                var keyNames = BuildKeyNames(relation.TargetTable);
                relation.JoinKey = FindColumnByNames(relation.Table, keyNames);
            }
            else
            {
                var keyNames = BuildKeyNames(relation.Table);
                relation.TargetJoinKey = FindColumnByNames(relation.TargetTable, keyNames);

                relation.JoinKey = relation.Table.PrimaryKey;
            }
        }
    }
}
