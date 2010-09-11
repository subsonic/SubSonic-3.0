using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.SqlGeneration.Schema;

namespace SubSonic.Tests.Repositories.TestBases
{
    public class Movie
    {
        public virtual int Id { get; set; }
        public virtual int DirectorId { get; set; }
        public virtual string Title { get; set; }

        [SubSonicToOneRelation(ThisClassContainsJoinKey = true)]
        public virtual Director Director { get; set; }

        [SubSonicToOneRelation(JoinKeyName = "Movie")]
        public virtual Plot Plot { get; set; }

        [SubSonicToManyRelation]
        public virtual IList<Comment> Comments { get; set; }
    }
}
