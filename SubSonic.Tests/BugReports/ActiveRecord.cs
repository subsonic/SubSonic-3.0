using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Xunit;
using SouthWind;

namespace SubSonic.Tests.BugReports {
   
    public class ActiveRecord {

        /// <summary>
        /// Issue 32 - ActiveRecord - IsLoaded not set true when query is executed
        /// http://github.com/subsonic/SubSonic-3.0/issues#issue/32
        /// </summary>
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
            var list = Product.Find(x => x.ProductID < 10);
            foreach(Product p in list){
                p.UnitPrice=100;
                p.Update();
            }
        }


        [Fact]
        public void Issue55_Delete_Should_Have_Two_Constraints() {

            Product.Delete(x => x.ProductID > 100 && x.CategoryID == 5);

        }


    }

}
