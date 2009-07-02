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
using System.Globalization;
using System.Text;
using System.Xml;

namespace SubSonic.Handlers
{
    /// <summary>
    /// Some of this code was initially published on http://www.phdcc.com/xml2json.htm - thanks for your hard work!
    /// </summary>
    public class XmlToJSONParser
    {
        /// <summary>
        /// XMLs to JSON.
        /// </summary>
        /// <param name="xmlDoc">The XML doc.</param>
        /// <returns></returns>
        public static string XmlToJSON(XmlDocument xmlDoc)
        {
            StringBuilder sbJSON = new StringBuilder();
            sbJSON.Append("{ ");
            XmlToJSONnode(sbJSON, xmlDoc.DocumentElement, true);
            sbJSON.Append("}");
            return sbJSON.ToString();
        }

        /// <summary>
        /// XmlToJSONnode:  Output an XmlElement, possibly as part of a higher array
        /// </summary>
        /// <param name="sbJSON">The sb JSON.</param>
        /// <param name="node">The node.</param>
        /// <param name="showNodeName">if set to <c>true</c> [show node name].</param>
        private static void XmlToJSONnode(StringBuilder sbJSON, XmlNode node, bool showNodeName)
        {
            if(showNodeName)
                sbJSON.Append(node.Name + ": ");
            sbJSON.Append("{");
            // Build a sorted list of key-value pairs
            //  where   key is case-sensitive nodeName
            //          value is an ArrayList of string or XmlElement
            //  so that we know whether the nodeName is an array or not.
            SortedList childNodeNames = new SortedList();

            //  Add in all node attributes
            if(node.Attributes != null)
            {
                foreach(XmlAttribute attr in node.Attributes)
                    StoreChildNode(childNodeNames, attr.Name, attr.InnerText);
            }

            //  Add in all nodes
            foreach(XmlNode cnode in node.ChildNodes)
            {
                if(cnode is XmlText)
                    StoreChildNode(childNodeNames, "value", cnode.InnerText);
                else if(cnode is XmlElement)
                    StoreChildNode(childNodeNames, cnode.Name, cnode);
            }

            // Now output all stored info
            foreach(string childname in childNodeNames.Keys)
            {
                ArrayList alChild = (ArrayList)childNodeNames[childname];
                if(alChild.Count == 1)
                    OutputNode(childname, alChild[0], sbJSON, true);
                else
                {
                    sbJSON.Append(childname + ": [ ");
                    foreach(object Child in alChild)
                        OutputNode(childname, Child, sbJSON, false);
                    sbJSON.Remove(sbJSON.Length - 2, 2);
                    sbJSON.Append(" ], ");
                }
            }
            sbJSON.Remove(sbJSON.Length - 2, 2);
            sbJSON.Append(" }");
        }

        /// <summary>
        /// StoreChildNode: Store data associated with each nodeName
        /// so that we know whether the nodeName is an array or not.
        /// </summary>
        /// <param name="childNodeNames">The child node names.</param>
        /// <param name="nodeName">Name of the node.</param>
        /// <param name="nodeValue">The node value.</param>
        private static void StoreChildNode(IDictionary childNodeNames, string nodeName, object nodeValue)
        {
            // Pre-process contraction of XmlElement-s
            if(nodeValue is XmlElement)
            {
                // Convert  <aa></aa> into "aa":null
                //          <aa>xx</aa> into "aa":"xx"
                XmlNode cnode = (XmlNode)nodeValue;
                if(cnode.Attributes.Count == 0)
                {
                    XmlNodeList children = cnode.ChildNodes;
                    if(children.Count == 0)
                        nodeValue = null;
                    else if(children.Count == 1 && (children[0] is XmlText))
                        nodeValue = ((children[0])).InnerText;
                }
            }
            // Add nodeValue to ArrayList associated with each nodeName
            // If nodeName doesn't exist then add it
            object oValuesAL = childNodeNames[nodeName];
            ArrayList ValuesAL;
            if(oValuesAL == null)
            {
                ValuesAL = new ArrayList();
                childNodeNames[nodeName] = ValuesAL;
            }
            else
                ValuesAL = (ArrayList)oValuesAL;
            ValuesAL.Add(nodeValue);
        }

        /// <summary>
        /// Outputs the node.
        /// </summary>
        /// <param name="childname">The childname.</param>
        /// <param name="alChild">The al child.</param>
        /// <param name="sbJSON">The sb JSON.</param>
        /// <param name="showNodeName">if set to <c>true</c> [show node name].</param>
        private static void OutputNode(string childname, object alChild, StringBuilder sbJSON, bool showNodeName)
        {
            if(alChild == null)
            {
                if(showNodeName)
                    sbJSON.Append(SafeJSON(childname) + ": ");
                sbJSON.Append("null");
            }
            else if(alChild is string)
            {
                if(showNodeName)
                    sbJSON.Append(SafeJSON(childname) + ": ");
                string sChild = (string)alChild;
                sChild = sChild.Trim();
                sbJSON.Append(SafeJSON(sChild));
            }
            else
                XmlToJSONnode(sbJSON, (XmlElement)alChild, showNodeName);
            sbJSON.Append(", ");
        }

        /// <summary>
        /// make the json string safe for delivery across the wire
        /// </summary>
        /// <param name="s">The s.</param>
        /// <returns></returns>
        public static string SafeJSON(string s)
        {
            if(String.IsNullOrEmpty(s))
                return "\"\"";
            int i;
            int len = s.Length;
            StringBuilder sb = new StringBuilder(len + 4);
            string t;

            sb.Append('"');
            for(i = 0; i < len; i += 1)
            {
                char c = s[i];
                if((c == '\\') || (c == '"') || (c == '>'))
                {
                    sb.Append('\\');
                    sb.Append(c);
                }
                else if(c == '\b')
                    sb.Append("\\b");
                else if(c == '\t')
                    sb.Append("\\t");
                else if(c == '\n')
                    sb.Append("\\n");
                else if(c == '\f')
                    sb.Append("\\f");
                else if(c == '\r')
                    sb.Append("\\r");
                else
                {
                    if(c < ' ')
                    {
                        //t = "000" + Integer.toHexString(c);
                        string tmp = new string(c, 1);
                        t = "000" + int.Parse(tmp, NumberStyles.HexNumber);
                        sb.Append("\\u" + t.Substring(t.Length - 4));
                    }
                    else
                        sb.Append(c);
                }
            }
            sb.Append('"');
            return sb.ToString();
        }
    }
}