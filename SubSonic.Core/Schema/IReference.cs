using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SubSonic.Schema
{
    public interface IRelation
    {
        ITable Table { get; }
        string Name { get; }

        IColumn JoinKey { get; set; }

        Type TargetType { get; set; }
        ITable TargetTable { get; set; }
        IColumn TargetJoinKey { get; set; }

        Qualifier Qualifier { get; set; }
    }

    public enum Qualifier
    {
        One, Many
    }
}
