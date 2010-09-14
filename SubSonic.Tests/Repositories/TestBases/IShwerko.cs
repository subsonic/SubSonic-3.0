using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SubSonic.Tests.Repositories.TestBases
{
    public interface IShwerko
    {
        Guid Key { get; set; }
        string Name { get; set; }
        DateTime ElDate { get; set; }
        decimal SomeNumber { get; set; }
        decimal? NullSomeNumber { get; set; }
        int Underscored_Column { get; set; }
    }
}
