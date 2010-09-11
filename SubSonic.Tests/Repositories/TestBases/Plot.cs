using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SubSonic.Tests.Repositories.TestBases
{
    public class Plot
    {
        public int Id { get; set; }
        public int Movie { get; set; }
        public string Tagline { get; set; }
        public string PlotWithoutSpoiler { get; set; }
        public string PlotWithSpoiler { get; set; }
    }
}
