using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Blog;
using SubSonic.Repository;

namespace SubSonic.Examples.SimpleRepo.Controllers {
    [HandleError]
    public class HomeController : Controller {

        IRepository _repo;

        public HomeController() {
            _repo = new SimpleRepository("Blog");
        }

        public HomeController(IRepository repo) {
            _repo = repo;
        }

        public ActionResult Index() {

            //get all the posts
            var posts = _repo.GetPaged<Post>(0, 20);

            return View(posts);
        }


        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Details(string id) {

            var postID = new Guid(id);

            //get the single value out
            var post = _repo.Single<Post>(postID);

            return View(post);


        }


        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Create() {
            return View(_repo.All<Category>());
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Create(Post post) {
            if (ModelState.IsValid) {
                _repo.Add(post);
                return RedirectToAction("Index");
            } else {
                return View(_repo.All<Category>());
            }
        }


        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Edit(string id) {

            var postID = new Guid(id);
            //get the single value out
            var post = _repo.Single<Post>(postID);
            post.Category = _repo.Single<Category>(post.CategoryID);

            ViewData["CategoryID"] = new SelectList(_repo.All<Category>(), "CategoryID", "Description", post.Category.CategoryID);

            return View(post);


        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Edit(string id, FormCollection form) {

            var postID = new Guid(id);

            //get the single value out
            var post = _repo.Single<Post>(postID);

            //have to run update as the modelbinders won't trigger the dirty columns for some reason
            UpdateModel(post);

            if (ModelState.IsValid) {
                _repo.Update(post);
                return RedirectToAction("Index");
            } else {
                return View();
            }
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Delete(string id) {
            var postID = new Guid(id);

            //delete it
            _repo.Delete<Post>(postID);
            return RedirectToAction("Index");

        }

        public ActionResult About() {
            return View();
        }
    }
}
