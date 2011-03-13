using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.SqlGeneration.Schema;

namespace SubSonic.Tests.Repositories.TestBases
{
    public class Shwerko3 : IShwerko
    {
		 public int Id { get; set; }
	    public Guid Key { get; set; }
		 public string Name { get; set; }
		 public DateTime ElDate { get; set; }
		 public decimal SomeNumber { get; set; }
		 public decimal? NullSomeNumber { get; set; }
		 public int Underscored_Column { get; set; }

		 [SubSonicColumnNameOverride("FünkyName$")]
		 public decimal FunkyName { get; set; }
    }
}
