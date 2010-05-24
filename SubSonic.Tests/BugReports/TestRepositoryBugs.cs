using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SouthWind;
using Xunit;

namespace SubSonic.Tests.BugReports
{
    public class TestRepositoryBugs
    {
        public TestRepositoryBugs()
        {
            OrderDetail.ResetTestRepo();
            Order.ResetTestRepo();
        }

        [Fact]
        public void Github_Issue138_SingleOrDefault_Should_Return_Matching_Entry_Only()
        {
            GivenOrderDetails();
            
            var orderDetail = OrderDetail.SingleOrDefault(o => o.ProductID == 3 && o.OrderID == 1, "test", String.Empty);

            Assert.Equal(orderDetail.ProductID, 3);
            Assert.Equal(orderDetail.OrderID, 1);
        }

        [Fact]
        public void Github_Issue138_Find_Should_Return_Matching_Entries_Only()
        {
            GivenOrderDetails();

            var orderDetail = OrderDetail.Find(o => o.ProductID == 3 && o.OrderID == 1, "test", String.Empty);

            Assert.Equal(orderDetail.Count, 1);
            Assert.Equal(orderDetail.First().ProductID, 3);
            Assert.Equal(orderDetail.First().OrderID, 1);
        }

        [Fact]
        public void Github_Issue139_Update_Should_Update_Item()
        {
            GivenOrders();

            var orderToUpdate = Order.SingleOrDefault(o => o.OrderID == 1, "test", String.Empty);
            orderToUpdate.Freight = 2.0m;
            orderToUpdate.Update();

            var updatedOrder = Order.SingleOrDefault(o => o.OrderID == 1, "test", String.Empty);

            Assert.Equal(2.0m, updatedOrder.Freight);
        }

        [Fact]
        public void Github_Issue139_Update_Should_Not_Add_New_Items()
        {
            GivenOrders();

            var orderToUpdate = Order.SingleOrDefault(o => o.OrderID == 1, "test", String.Empty);
            orderToUpdate.Freight = 2.0m;
            orderToUpdate.Update();

            Assert.Equal(2, Order.All("test", String.Empty).Count());
        }

        private void GivenOrderDetails()
        {
            var orderDetails = new List<OrderDetail> {
                new OrderDetail
                {
                    OrderID = 1,
                    ProductID = 1
                },
                new OrderDetail
                {
                    OrderID = 1,
                    ProductID = 2
                },
                new OrderDetail
                {
                    OrderID = 1,
                    ProductID = 3
                },
                new OrderDetail
                {
                    OrderID = 2,
                    ProductID = 4
                },
                new OrderDetail
                {
                    OrderID = 2,
                    ProductID = 3
                }
            };

            OrderDetail.Setup(orderDetails);
        }

        private void GivenOrders()
        {
            var orders= new List<Order> {
                new Order
                {
                    OrderID = 1,
                    OrderDate = new DateTime(2010, 2, 1),
                    CustomerID = "1"
                },
                new Order
                {
                    OrderID = 2,
                    OrderDate = new DateTime(2010, 1, 1),
                    CustomerID = "2"
                }
            };

            Order.Setup(orders);
        }
    }
}
