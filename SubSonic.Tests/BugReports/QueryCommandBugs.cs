using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SubSonic.Query;
using SubSonic.DataProviders;
using Xunit;
using System.Data;

namespace SubSonic.Tests.BugReports
{
    public class QueryCommandBugs
    {
        private const int Timeout = 120;

        [Fact]
        public void GitHub_Issue149_QueryCommand_Should_Respect_Timeout_When_Creating_DbCommands()
        {
            var provider = ProviderFactory.GetProvider("Northwind");
            QueryCommand q = new QueryCommand("SELECT * FROM Orders", provider);
            q.CommandTimeout = Timeout;

            var dbCommand = q.ToDbCommand();

            Assert.Equal(Timeout, dbCommand.CommandTimeout);
        }

        [Fact]
        public void QueryCommand_Should_Respect_CommandType_When_Creating_DbCommands()
        {
            var provider = ProviderFactory.GetProvider("Northwind");
            QueryCommand q = new QueryCommand("SELECT * FROM Orders", provider);
            q.CommandType = CommandType.StoredProcedure;

            var dbCommand = q.ToDbCommand();

            Assert.Equal(CommandType.StoredProcedure, dbCommand.CommandType);
        }

        [Fact]
        public void QueryCommand_Should_Use_CommandType_Text_By_Default()
        {
            var provider = ProviderFactory.GetProvider("Northwind");
            QueryCommand q = new QueryCommand("SELECT * FROM Orders", provider);

            Assert.Equal(CommandType.Text, q.CommandType);
        }
    }
}
