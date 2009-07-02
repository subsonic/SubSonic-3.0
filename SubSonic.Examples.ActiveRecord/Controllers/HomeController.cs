using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using SubSonic.Repository;
using Blog;

namespace SubSonic.Examples.ActiveRecord.Controllers {
    [HandleError]
    public class HomeController : Controller {


        public ActionResult Index() {

            //get all the posts
            var posts = Post.GetPaged(1, 20);

            return View(posts);
        }


        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Details(string id) {

            var postID = new Guid(id);

            //get the single value out
            var post = Post.SingleOrDefault(x => x.PostID == postID);

            return View(post);


        }


        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Create() {
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Create(Post post) {
            if (ModelState.IsValid) {
                post.Add();
                return RedirectToAction("Index");
            } else {
                return View();
            }
        }


        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Edit(string id) {

            var postID = new Guid(id);
            //get the single value out
            var post = Post.SingleOrDefault(x => x.PostID == postID);
            ViewData["CategoryID"] = new SelectList(Category.All(), "CategoryID", "Description", post.CategoryID);

            return View(post);


        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Edit(string id, FormCollection form) {

            var postID = new Guid(id);

            //get the single value out
            var post = Post.SingleOrDefault(x => x.PostID == postID);
            
            //have to run update as the modelbinders won't trigger the dirty columns for some reason
            UpdateModel(post);
            
            if (ModelState.IsValid) {
                post.Update();
                return RedirectToAction("Index");
            } else {
                return View();
            }
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Delete(string id) {
            var postID = new Guid(id);
            
            //delete it
            Post.Delete(x => x.PostID == postID);
            return RedirectToAction("Index");

        }

        public ActionResult About() {
            return View();
        }
    }
}
