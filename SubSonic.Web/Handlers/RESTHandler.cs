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
using System.Data;
using System.IO;
using System.Web;
using System.Xml;
using SubSonic.Extensions;
using SubSonic.DataProviders;
using SubSonic.Query;
using SubSonic.Schema;

namespace SubSonic.Handlers
{
    /// <summary>
    /// Summary for the RESTHandler class
    /// </summary>
    public class RESTHandler : IHttpHandler
    {
        #region props

        private HttpContext _context;
        private string _output;
        private TextWriter _outputWriter;
        private string _spList = String.Empty;
        private string _tableList = String.Empty;
        private RESTfullUrl _url;

        private string _viewList = String.Empty;

        /// <summary>
        /// Gets or sets the allowed table list.
        /// </summary>
        /// <value>The allowed table list.</value>
        public string AllowedTableList
        {
            get { return _tableList; }
            set { _tableList = value; }
        }

        /// <summary>
        /// Gets or sets the allowed view list.
        /// </summary>
        /// <value>The allowed view list.</value>
        public string AllowedViewList
        {
            get { return _viewList; }
            set { _viewList = value; }
        }

        /// <summary>
        /// Gets or sets the allowed sp list.
        /// </summary>
        /// <value>The allowed sp list.</value>
        public string AllowedSpList
        {
            get { return _spList; }
            set { _spList = value; }
        }

        /// <summary>
        /// Gets or sets the context.
        /// </summary>
        /// <value>The context.</value>
        public HttpContext Context
        {
            get { return _context; }
            set { _context = value; }
        }

        /// <summary>
        /// Gets or sets the output.
        /// </summary>
        /// <value>The output.</value>
        public string Output
        {
            get { return _output; }
            set { _output = value; }
        }

        /// <summary>
        /// Gets or sets the output writer.
        /// </summary>
        /// <value>The output writer.</value>
        public TextWriter OutputWriter
        {
            get { return _outputWriter; }
            set { _outputWriter = value; }
        }

        /// <summary>
        /// Gets a value indicating whether another request can use the <see cref="T:System.Web.IHttpHandler"/> instance.
        /// </summary>
        /// <value></value>
        /// <returns>true if the <see cref="T:System.Web.IHttpHandler"/> instance is reusable; otherwise, false.</returns>
        public bool IsReusable
        {
            get { return false; }
        }

        #endregion


        #region IHttpHandler Members

        /// <summary>
        /// Main entry point
        /// </summary>
        /// <param name="context">An <see cref="T:System.Web.HttpContext"/> object that provides references to the intrinsic server objects (for example, Request, Response, Session, and Server) used to service HTTP requests.</param>
        public void ProcessRequest(HttpContext context)
        {
            _context = context;
            _outputWriter = context.Response.Output;

            //parse the URL
            _url = new RESTfullUrl(context);

            DataSet ds = GenerateReturnSet();

            _output = FormatOutput(ds);

            RenderOutput();
        }

        #endregion


        /// <summary>
        /// A pre-execution call - you can override for your own processing calls
        /// if you return false, execution of the request stops
        /// </summary>
        /// <returns></returns>
        public virtual bool PreProcessRequest()
        {
            return true;
        }

        /// <summary>
        /// Outputs the data to the response stream
        /// </summary>
        public virtual void RenderOutput()
        {
            if(_url.ReturnType == RESTReturnType.xml)
            {
                _context.Response.ContentType = "text/xml";
                _outputWriter.Write(_output);
            }
            else if(_url.ReturnType == RESTReturnType.json)
            {
                _context.Response.ContentType = "text/json";

                XmlDocument xdoc = new XmlDocument();
                xdoc.LoadXml(_output);

                //convert XML to a JSON string
                string json = XmlToJSONParser.XmlToJSON(xdoc);
                //clean up and prep for delivery
                json = json.Replace(@"\", @"\\");
                //final clean up and make it safe json for client side
                _outputWriter.Write(XmlToJSONParser.SafeJSON(json));
            }
        }

        /// <summary>
        /// Renders the output based on the request (XML, JSON, RSS,etc)
        /// </summary>
        /// <param name="ds">The ds.</param>
        /// <returns></returns>
        private string FormatOutput(DataSet ds)
        {
            string result = String.Empty;

            if(_url.ReturnType == RESTReturnType.xml || _url.ReturnType == RESTReturnType.json)
            {
                result = ds.GetXml();

                //the way the query engine runs a data set
                //is that it wraps the outer bits using "<NewDataSet>"
                //strip that

                string tableName = _url.TableName.MakePlural();
                tableName = tableName.ToProper();
                string itemName = tableName.PluralToSingular();

                result = result.Replace("<NewDataSet>", String.Concat("<", tableName, ">")).Replace("</NewDataSet>", String.Concat("</", tableName, ">"));

                //find and replace if no result returned we still want the root element to have the name of the table
                result = result.Replace("<NewDataSet />", String.Concat("<", tableName, "/>"));

                //next, replace the <table> tag with the name of the table/sp passed in
                result = result.Replace("<Table>", String.Concat("<", itemName, ">")).Replace("</Table>", String.Concat("</", itemName, ">"));
            }
            else if(_url.ReturnType == RESTReturnType.rss)
            {
                //TODO: complete RSS logic
            }

            return result;
        }

        /// <summary>
        /// Helper method to evaluate the operator to use for the query
        /// </summary>
        /// <param name="originalParam">The original param.</param>
        /// <param name="paramName">Name of the param.</param>
        /// <param name="comp">The comp.</param>
        public static void EvalComparison(string originalParam, out string paramName, out Comparison comp)
        {
            //we can handle some query-ability here, like less thans, greater thans, and so on
            //by simply naming our parameters properly
            string lowered = originalParam.ToLowerInvariant();
            comp = Comparison.Equals;
            paramName = originalParam;

            if(lowered.StartsWith("min_"))
            {
                comp = Comparison.GreaterThan;
                paramName = originalParam.Replace("min_", String.Empty);
            }
            else if(lowered.StartsWith("minz_"))
            {
                comp = Comparison.GreaterOrEquals;
                paramName = originalParam.Replace("minz_", String.Empty);
            }
            else if(lowered.StartsWith("max_"))
            {
                comp = Comparison.LessThan;
                paramName = originalParam.Replace("max_", String.Empty);
            }
            else if(lowered.StartsWith("maxz_"))
            {
                comp = Comparison.LessOrEquals;
                paramName = originalParam.Replace("maxz_", String.Empty);
            }
            else if(lowered.EndsWith("_not"))
            {
                comp = Comparison.IsNot;
                paramName = originalParam.Replace("_not", String.Empty);
            }
            else if(lowered.EndsWith("_notequal"))
            {
                comp = Comparison.NotEquals;
                paramName = originalParam.Replace("_notequal", String.Empty);
            }
            else if(lowered.EndsWith("_is"))
            {
                comp = Comparison.Is;
                paramName = originalParam.Replace("_is", String.Empty);
            }
            else if(lowered.EndsWith("_like"))
            {
                comp = Comparison.Like;
                paramName = originalParam.Replace("_like", String.Empty);
            }
            else if(lowered.EndsWith("_notlike"))
            {
                comp = Comparison.NotLike;
                paramName = originalParam.Replace("_notlike", String.Empty);
            }
        }

        /// <summary>
        /// Data retrieval
        /// </summary>
        /// <returns></returns>
        private DataSet GenerateReturnSet()
        {
            DataSet result = null;
            if(_url != null)
            {
                SqlQuery qry = null;
                //Query q;

                if(!String.IsNullOrEmpty(_url.TableName))
                {
                    qry = new Select().From(_url.TableName);
                    IDataProvider provider = ProviderFactory.GetProvider();
                    ITable tbl = provider.FindTable(_url.TableName);

                    if(_url.PrimaryKey != null)
                        qry = qry.Where(tbl.PrimaryKey.Name).IsEqualTo(_url.PrimaryKey);
                    //q.WHERE(q.Schema.PrimaryKey.ParameterName, _url.PrimaryKey);

                    if(_url.Parameters != null)
                    {
                        IDictionaryEnumerator loopy = _url.Parameters.GetEnumerator();
                        IColumn column;

                        string paramName;
                        object paramValue;

                        while(loopy.MoveNext())
                        {
                            paramName = loopy.Key.ToString();
                            paramValue = loopy.Value;

                            int pageSize = 0;
                            int pageIndex = -1;

                            if(paramName.ToLowerInvariant() == "pagesize" || paramName.ToLowerInvariant() == "pageindex")
                            {
                                if(paramName.ToLowerInvariant() == "pagesize")
                                    pageSize = int.Parse(paramValue.ToString());

                                if(paramName.ToLowerInvariant() == "pageindex")
                                    pageIndex = int.Parse(paramValue.ToString());

                                if(pageSize > 0 && pageIndex > -1)
                                    qry.Paged(pageIndex + 1, pageSize);
                            }
                            else
                            {
                                Comparison comp;
                                EvalComparison(paramName, out paramName, out comp);
                                column = tbl.GetColumn(paramName);

                                //if this column is a string, by default do a fuzzy search
                                if(comp == Comparison.Like || column.IsString)
                                {
                                    comp = Comparison.Like;
                                    paramValue = String.Concat("%", paramValue, "%");
                                    qry = qry.Where(column.Name).Like(paramValue.ToString());
                                }
                                else if(paramValue.ToString().ToLower() == "null")
                                    qry = qry.Where(column.Name).IsNull();

                                //q.WHERE(column.ColumnName, comp, paramValue);
                            }
                        }
                    }

                    result = provider.ExecuteDataSet(qry.GetCommand());
                }
                else if(!String.IsNullOrEmpty(_url.SpName))
                {
                    StoredProcedure sp = new StoredProcedure(_url.SpName);

                    if(_url.Parameters != null)
                    {
                        IDictionaryEnumerator loopy = _url.Parameters.GetEnumerator();
                        while(loopy.MoveNext())
                            sp.Command.AddParameter(loopy.Key.ToString(), loopy.Value, DbType.AnsiString);
                    }
                    result = sp.ExecuteDataSet();
                }
            }
            return result;
        }
    }
}