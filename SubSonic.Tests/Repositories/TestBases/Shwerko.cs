using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.SqlGeneration.Schema;

namespace SubSonic.Tests.Repositories.TestBases
{
    public class Shwerko : IShwerko
    {
        public int ID { get; set; }
        public Guid Key { get; set; }
        public string Name { get; set; }
        public DateTime ElDate { get; set; }
        public decimal SomeNumber { get; set; }

		[SubSonicIgnore]
		public string SomePropertyToTestIgnoreAttribute { get; set; }

        public int? NullInt { get; set; }
        public decimal? NullSomeNumber { get; set; }
        public DateTime? NullElDate { get; set; }
        public Guid? NullKey { get; set; }
        public int Underscored_Column { get; set; }
        public Salutation Salutation { get; set; }
        public Salutation? NullableSalutation { get; set; }
        public byte[] Binary { get; set; }
    }
}
