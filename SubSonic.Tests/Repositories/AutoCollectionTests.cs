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
using System.Collections.Generic;
using System.IO;
using System.Linq;
using SubSonic.DataProviders;
using SubSonic.DataProviders.Log;
using SubSonic.Query;
using SubSonic.Repository;
using Xunit;
using SubSonic.SqlGeneration.Schema;
using SubSonic.Extensions;
using Castle.DynamicProxy;
using SubSonic.Tests.Repositories.TestBases;

namespace SubSonic.Tests.Repositories
{
    public abstract class AutoCollectionTests
    {
        private readonly DbDataProvider _provider;
        private readonly IRepository _repo;

        protected AutoCollectionTests(IDataProvider provider)
        {
            _provider = (DbDataProvider)provider;
            _provider.SetLogger(new TextWriterLogAdapter(Console.Out));
            _repo = new SimpleRepository(_provider, SimpleRepositoryOptions.RunMigrations);

            TestSupport.CleanTables(_provider, "Directors", "Movies", "Comments", "NonVirtualRelationProperties");
        }

        [Fact]
        public void Simple_Repo_Should_Lazy_Load_1toN_Relation()
        {
            GivenMovies();

            var director = _repo.All<Director>().FirstOrDefault();

            Assert.NotNull(director.Movies);
        }

        [Fact]
        public void Simple_Repo_Should_Lazy_Load_1toN_Relation_Of_Relation()
        {
            GivenMovies();

            var director = _repo.All<Director>().FirstOrDefault();

            Assert.NotNull(director.Movies);

            foreach (var movie in director.Movies)
            {
                Assert.NotNull(movie.Comments);
            }
        }

        [Fact]
        public void Simple_Repo_Should_Lazy_Load_1toN_Relation_Only_Once()
        {
            GivenMovies();

            var director = _repo.All<Director>().FirstOrDefault();

            Assert.NotNull(director.Movies);

            _provider.InterceptionStrategy = new MockInterceptionStrategy(_provider);

            Assert.DoesNotThrow(() => {
                var someAccess = director.Movies[0];
            });
        }

        [Fact]
        public void Simple_Repo_Should_Lazy_Not_Reload_Set_Properties_for_1toN_Relation()
        {
            GivenMovies();

            var director = _repo.All<Director>().FirstOrDefault();
            director.Movies = new List<Movie>();

            _provider.InterceptionStrategy = new MockInterceptionStrategy(_provider);

            Assert.DoesNotThrow(() =>
            {
                var someAccess = director.Movies;
            });
        }

        [Fact]
        public void Simple_Repo_Should_Lazy_Load_1to1_Relation_Only_Once()
        {
            GivenMovies();

            var movie = _repo.All<Movie>().FirstOrDefault();

            Assert.NotNull(movie.Director);

            _provider.InterceptionStrategy = new MockInterceptionStrategy(_provider);

            Assert.DoesNotThrow(() =>
            {
                var someAccess = movie.Director.Name;
            });
        }

        [Fact]
        public void Simple_Repo_Should_Lazy_Not_Reload_Set_Properties_for_1to1_Relation()
        {
            GivenMovies();

            var movie = _repo.All<Movie>().FirstOrDefault();
            movie.Director = new Director { Name = "Unknown" };

            _provider.InterceptionStrategy = new MockInterceptionStrategy(_provider);

            Assert.DoesNotThrow(() =>
            {
                var someAccess = movie.Director;
            });
        }

        [Fact]
        public void Simple_Repo_Should_Lazy_Load_1to1_Relation()
        {
            GivenMovies();

            var movie = _repo.All<Movie>().FirstOrDefault();

            Assert.NotNull(movie.Director);
        }

        [Fact]
        public void Simple_Repo_Should_Lazy_Load_1to1_Relation_With_Inverted_Relation()
        {
            GivenMovies();

            var movie = _repo.All<Movie>().FirstOrDefault();

            Assert.NotNull(movie.Plot);
        }

        [Fact]
        public void NonVirtual_Relation_Property_Should_Throw_An_Exception()
        {
            Assert.Throws<InvalidOperationException>(() => {
                _repo.Add(new NonVirtualRelationProperty { DirectorId = 1 });
            });
        }

        private void GivenMovies()
        {
            var director = new Director { Name = "Martin Scorsese" };
            _repo.Add(director);

            var movie = new Movie { DirectorId = director.Id, Title="Taxi Driver" };
            _repo.Add(movie);

            var plot = new Plot() {
                Movie = movie.Id,
                PlotWithoutSpoiler = "Taxi Driver meets girl",
                PlotWithSpoiler = "Taxi Driver meets girl and life goes down the sewer!",
                Tagline = "Taxi Driver, Girl, Sewer"
            };
            _repo.Add(plot);

            var comment = new Comment { MovieId = movie.Id, Author = "donna", Text="Great!" };
            _repo.Add(comment);

            comment = new Comment { MovieId = movie.Id, Author= "spiderman", Text="w00t!" };
            _repo.Add(comment);

            movie = new Movie { DirectorId = director.Id, Title = "Goodfellas" };
            _repo.Add(movie);

            comment = new Comment { MovieId = movie.Id, Author = "martin", Text = "That's me at my best!" };
            _repo.Add(comment);

            comment = new Comment { MovieId = movie.Id, Author = "sometimes", Text = "Yes! Gangsters!" };
            _repo.Add(comment);
        }
    }
}