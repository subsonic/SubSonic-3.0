using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Blog {
    public class Post {

        public Guid PostID { get; set; }
        public int CategoryID { get; set; }
        public Category Category { get; set; }
        public string Title { get; set; }
        public string Slug { get; set; }
        public string Body { get; set; }
        public DateTime PublishedOn { get; set; }
        public DateTime CreatedOn { get; set; }
        public DateTime ModifiedOn { get; set; }
        public string CreatedBy { get; set; }
        public string ModifiedBy { get; set; }


    }
}
