using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.Repository;

namespace SubSonic.Tests.Repositories
{
    public class SimpleTestRepositoryTests : SimpleRepositoryTests
    {
        protected override string[] StringNumbers
        {
            get { return new string[] { "1", "2", "3" }; }
        }

        public SimpleTestRepositoryTests()
            : base(new SimpleTestRepository())
        {}
    }
}
