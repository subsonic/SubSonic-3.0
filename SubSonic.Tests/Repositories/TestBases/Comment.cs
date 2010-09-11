using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SubSonic.Tests.Repositories.TestBases
{
    public class Comment
    {
        public virtual int Id { get; set; }
        public virtual int MovieId { get; set; }

        public virtual string Author { get; set; }
        public virtual string Text { get; set; }
    }
}
