using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.SqlGeneration.Schema;

namespace SubSonic.Tests.Repositories.TestBases
{
    public class NonAutoIncrementingIdWithDefaultSetting
    {
        [SubSonicPrimaryKey(false)]
        public int Id { get; set; }

        [SubSonicDefaultSetting("NN")]
        [SubSonicNullString()]
        public String Name { get; set; }
    }
}
