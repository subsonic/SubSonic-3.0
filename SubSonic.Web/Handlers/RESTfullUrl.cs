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
using System.Collections;
using System.Collections.Specialized;
using System.IO;
using System.Web;
using SubSonic.Extensions;

namespace SubSonic.Handlers
{
    /// <summary>
    /// 
    /// </summary>
    public enum RESTReturnType
    {
        /// <summary>
        /// 
        /// </summary>
        xml,
        /// <summary>
        /// 
        /// </summary>
        rss,
        /// <summary>
        /// 
        /// </summary>
        json
    }

    /// <summary>
    /// 
    /// </summary>
    public enum RESTCommand
    {
        /// <summary>
        /// 
        /// </summary>
        List,
        /// <summary>
        /// 
        /// </summary>
        Show,
        /// <summary>
        /// 
        /// </summary>
        Insert,
        /// <summary>
        /// 
        /// </summary>
        Update,
        /// <summary>
        /// 
        /// </summary>
        Delete,
        /// <summary>
        /// 
        /// </summary>
        Exec,
        /// <summary>
        /// 
        /// </summary>
        Search
    }

    /// <summary>
    /// Summary for the RESTfullUrl class
    /// </summary>
    public class RESTfullUrl
    {
        private object _key;
        private Hashtable _params;
        private string _rawUrl;
        private RESTCommand _restCommand;

        private string _spName = String.Empty;
        private string _tableName = String.Empty;

        /// <summary>
        /// Initializes a new instance of the <see cref="RESTfullUrl"/> class.
        /// </summary>
        /// <param name="url">The URL.</param>
        public RESTfullUrl(string url)
        {
            _rawUrl = url;
            ParseUrl();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="RESTfullUrl"/> class.
        /// </summary>
        /// <param name="context">The context.</param>
        public RESTfullUrl(HttpContext context)
        {
            _rawUrl = context.Request.Url.AbsoluteUri;

            //set the return type based on context requested filepath (xml or json for now)
            string format = Path.GetExtension(context.Request.CurrentExecutionFilePath).Replace(".", String.Empty);
            ReturnType = DecideReturnType(format);

            ParseUrl();
        }

        /// <summary>
        /// Gets or sets the rest command.
        /// </summary>
        /// <value>The rest command.</value>
        public RESTCommand RestCommand
        {
            get { return _restCommand; }
            set { _restCommand = value; }
        }

        /// <summary>
        /// Gets or sets the type of the return.
        /// </summary>
        /// <value>The type of the return.</value>
        public RESTReturnType ReturnType { get; set; }

        /// <summary>
        /// Gets or sets the raw URL.
        /// </summary>
        /// <value>The raw URL.</value>
        public string RawUrl
        {
            get { return _rawUrl; }
            set { _rawUrl = value; }
        }

        /// <summary>
        /// Gets or sets the primary key.
        /// </summary>
        /// <value>The primary key.</value>
        public object PrimaryKey
        {
            get { return _key; }
            set { _key = value; }
        }

        /// <summary>
        /// Gets or sets the name of the table.
        /// </summary>
        /// <value>The name of the table.</value>
        public string TableName
        {
            get { return _tableName; }
            set { _tableName = value; }
        }

        /// <summary>
        /// Gets or sets the name of the sp.
        /// </summary>
        /// <value>The name of the sp.</value>
        public string SpName
        {
            get { return _spName; }
            set { _spName = value; }
        }

        /// <summary>
        /// Gets or sets the parameters.
        /// </summary>
        /// <value>The parameters.</value>
        public Hashtable Parameters
        {
            get { return _params; }
            set { _params = value; }
        }

        /// <summary>
        /// Determines whether [is non key command] [the specified URL].
        /// </summary>
        /// <param name="url">The URL.</param>
        /// <returns>
        /// 	<c>true</c> if [is non key command] [the specified URL]; otherwise, <c>false</c>.
        /// </returns>
        private static bool IsNonKeyCommand(string url)
        {
            //bool result = true;

            //check to see if the page is a number
            string sPage = Path.GetFileNameWithoutExtension(url);

            return sPage.IsNumber();
        }

        /// <summary>
        /// Decides the command.
        /// </summary>
        /// <param name="command">The command.</param>
        /// <returns></returns>
        private static RESTCommand DecideCommand(string command)
        {
            return command.ToEnum<RESTCommand>();
        }

        /// <summary>
        /// Decides the type of the return.
        /// </summary>
        /// <param name="format">The format.</param>
        /// <returns></returns>
        private static RESTReturnType DecideReturnType(string format)
        {
            return format.ToEnum<RESTReturnType>();
        }

        /// <summary>
        /// load, parse, and format
        /// the URL must be in the format
        /// http://domain/service_directory/table_or_view/[key].[format]
        /// or with a REST command
        /// http://domain/service_directory/table_or_view/[command].[format]?[params]
        /// for search, this is
        /// http://domain/service_directory/table_or_view/search.[format]?paramname=paramvalue
        /// SPs use
        /// http://domain/service_directory/spname/exec.[format]?[params]
        /// Parses the URL.
        /// </summary>
        private void ParseUrl()
        {
            //work backwards up the URL
            //first thing, check for a query string and strip it
            string workingUrl = _rawUrl;

            if(workingUrl.Contains("?"))
            {
                //strip off the query string - it'll be used later
                workingUrl = workingUrl.Chop("?");
            }

            string[] bits = workingUrl.Split(new[] {'/'}, StringSplitOptions.RemoveEmptyEntries);
            //the URL should be split out into
            //protocol ("http");
            //domain ("foo.com");
            //service directory ("services");
            //table or sp ("products")
            //command.format ("list.xml")

            //the index of each item within the URL
            int commandIndex = bits.Length - 1;
            int tableSPIndex = bits.Length - 2;

            //now check to see if the last item on the URL is a key, or 
            if(IsNonKeyCommand(workingUrl))
            {
                //the last item is the command - list/show/etc
                //set it
                //the last item is a key, set it, and then the command
                _key = Path.GetFileNameWithoutExtension(bits[bits.Length - 1]);
                commandIndex--;
                tableSPIndex--;
            }

            //the command is the next item up the chain
            _restCommand = DecideCommand(Path.GetFileNameWithoutExtension(bits[commandIndex]));

            //evaluate the command
            if(_restCommand == RESTCommand.Exec)
                _spName = bits[tableSPIndex];
            else
                _tableName = bits[tableSPIndex];

            ParseQueryString();
        }

        /// <summary>
        /// Parses the query string.
        /// </summary>
        private void ParseQueryString()
        {
            //parse the query string
            int qMark = _rawUrl.IndexOf("?");
            if(qMark > 0)
            {
                string qString = _rawUrl.Clip(qMark);
                NameValueCollection queryString = HttpUtility.ParseQueryString(qString);
                _params = new Hashtable();
                for(int i = 0; i < queryString.Count; i++)
                    _params.Add(queryString.GetKey(i), queryString[i]);
            }
        }
    }
}