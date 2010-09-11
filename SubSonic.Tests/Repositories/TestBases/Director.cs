using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.SqlGeneration.Schema;

namespace SubSonic.Tests.Repositories.TestBases
{
    public class Director
    {
        public virtual int Id { get; set; }
        public virtual string Name { get; set; }

        [SubSonicToManyRelation()]
        public virtual IList<Movie> Movies { get; set; }
    }
}
