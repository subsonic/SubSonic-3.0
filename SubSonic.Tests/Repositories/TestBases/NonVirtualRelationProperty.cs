using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.SqlGeneration.Schema;

namespace SubSonic.Tests.Repositories.TestBases
{
    public class NonVirtualRelationProperty
    {
        public int Id { get; set; }
        public int DirectorId { get; set; }

        [SubSonicToOneRelation()]
        public Director Director { get; set; }
    }
}
