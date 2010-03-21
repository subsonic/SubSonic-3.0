using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Xunit;
using SouthWind;
using SubSonic.Tests.Linq.TestBases;
using SubSonic.Linq.Structure;

namespace SubSonic.Tests.BugReports {
   
    public class ActiveRecord {

        /// <summary>
        /// Issue 32 - ActiveRecord - IsLoaded not set true when query is executed
        /// http://github.com/subsonic/SubSonic-3.0/issues#issue/32
        /// </summary>
			
        [Fact]
        public void Github_Issue95_Booleans_Always_Set_True() {
            var p = Product.SingleOrDefault(x => x.ProductID == 1);
            p.Discontinued = true;
            p.Save();

            p = Product.SingleOrDefault(x => x.ProductID == 1);
            Assert.Equal(p.Discontinued, true);

            p.Discontinued = false;
            p.Save();
            
            p = Product.SingleOrDefault(x => x.ProductID == 1);
            Assert.Equal(p.Discontinued, false);

        }
        [Fact]
        public void UsingLinq_With_ActiveRecord_Product_Should_Set_IsLoaded_True() {
            var list = from p in Product.All()
                       where p.ProductID > 0
                       select p;

            Assert.Equal(true, list.FirstOrDefault().IsLoaded());
        }


        [Fact]
        public void UsingLinq_With_ActiveRecord_Product_Should_Set_IsNew_False() {
            var list = from p in Product.All()
                       where p.ProductID > 0
                       select p;

            Assert.Equal(false, list.FirstOrDefault().IsNew());
        }

        [Fact]
        public void CreatingNew_Product_Should_Set_IsNew_True() {
            var product = new Product();
            Assert.Equal(true, product.IsNew());
        }
        [Fact]
        public void CreatingNew_Product_Should_Set_IsLoaded_False() {
            var product = new Product();
            Assert.Equal(false, product.IsLoaded());
        }

        [Fact]
        public void PullingSingle_Should_Set_New_Product_IsLoaded_True() {
            var product = new Product();
            product = Product.SingleOrDefault(x => x.ProductID == 1);
            Assert.Equal(true, product.IsLoaded());
        }
        [Fact]
        public void PullingSingle_Should_Set_New_Product_IsNew_False() {
            var product = new Product();
            product = Product.SingleOrDefault(x => x.ProductID == 1);
            Assert.Equal(false, product.IsNew());
        }


        [Fact]
        public void Issue54_Looping_List_Calling_Update_Should_Work() {

            // Arrange
            Exception expectedException = null;
            var list = Product.Find(x => x.ProductID < 10);

            // Act
            try
            {
                foreach (Product p in list)
                {
                    p.UnitPrice = 100;
                    p.Update();
                }
            }
            catch (Exception ex)
            {
                expectedException = ex;
            }

            // Assert
            Assert.Null(expectedException);

        }

        [Fact]
        public void Issue55_Delete_Should_Have_Two_Constraints() {

            Product.Delete(x => x.ProductID > 100 && x.CategoryID == 5);

        }

        [Fact]
        public void Issue158_GetPaged_With_SortOrder_Should_Not_Expect_Case_Sensitive_Order()
        {
            var paged = Category.GetPaged("CategoryName DESC", 1, 10);

            Assert.Equal("Seafood", paged[0].CategoryName);
        }

				[Fact]
				public void Issue148_TestMode_Field_Should_Not_Be_Included_In_Query()
				{
					var value = from employees in Employee.All()
											join employeeTerritories in EmployeeTerritory.All() on employees.EmployeeID equals employeeTerritories.EmployeeID
											join territories in Territory.All() on employeeTerritories.TerritoryID equals territories.TerritoryID
											select territories.Region;

						
					Assert.DoesNotContain("TestMode", (value as Query<Region>).QueryText);					 
				}

			  //[Fact] // TODO: This test illustrates issue 151, it should pass once that issue is fixed (updated templates may already have fixed this)
				//public void Issue151_Update_Should_Work_After_Save()
				//{
				//  Category category = new Category { CategoryName = "Test Category" };
				//  category.Save();
				//  category.CategoryName = "New Test Category";
				//  category.Update();
				//  Category loadedCategory = Category.Find(cat => cat.CategoryID == category.CategoryID).First();
				//  Assert.Equal(category.CategoryName, loadedCategory.CategoryName);
				//}
    }

}
