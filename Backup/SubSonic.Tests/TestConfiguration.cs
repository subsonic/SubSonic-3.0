// 
//   SubSonic - http://subsonicproject.com
// 
//   The contents of this file are subject to the New BSD
//   License (the "License"); you may not use this file
//   except in compliance with the License. You may obtain a copy of
//   the License at http://www.opensource.org/licenses/bsd-license.php
//  
//   Software distributed under the License is distributed on an 
//   "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
//   implied. See the License for the specific language governing
//   rights and limitations under the License.
// 
using System;
using System.IO;

namespace SubSonic.Tests
{
    public class TestConfiguration
    {
        private const string dataSourceParam = "Data Source=";

        public const string MsSql2005TestConnectionString = @"server=.\SQLExpress;database=SubSonic;integrated security=true;";
        public const string MsSql2008TestConnectionString = @"server=.\SQL2008;database=SubSonic;integrated security=true;";
        public const string MySqlTestConnectionString = "server=localhost;database=subsonic;user id=root; password=;";

        public static string SQLiteTestsFilePath
        {
            get { return String.Concat(Directory.GetCurrentDirectory(), "\\..\\..\\TestClasses\\", "SubSonic.db"); }
        }

        public static string SQLiteMigrationsFilePath
        {
            get { return String.Concat(Directory.GetCurrentDirectory(), "\\..\\..\\Migrations\\", "Migrations.db"); }
        }

        public static string SQLiteRepositoryFilePath
        {
            get { return String.Concat(Directory.GetCurrentDirectory(), "\\..\\..\\Repositories\\", "RepoTests.db"); }
        }

        public static string SQLiteTestsConnectionString
        {
            get { return String.Concat(dataSourceParam, SQLiteTestsFilePath); }
        }

        public static string SQLiteMigrationsConnectionString
        {
            get { return String.Concat(dataSourceParam, SQLiteMigrationsFilePath); }
        }

        public static string SQLiteRepositoryConnectionString
        {
            get { return String.Concat(dataSourceParam, SQLiteRepositoryFilePath); }
        }
    }
}