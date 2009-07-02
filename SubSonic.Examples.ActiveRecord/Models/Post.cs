using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Blog {
    public partial class Post {

        partial void OnCreated() {
            this.PostID = Guid.NewGuid();
            this.CreatedOn = DateTime.Now;
            this.ModifiedOn = DateTime.Now;
            
        }

    }
}
