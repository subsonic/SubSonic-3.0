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
using System.IO;
using System.Net;

namespace SubSonic.Extensions
{
    /// <summary>
    /// Summary for the Files class
    /// </summary>
    public static class IO
    {
        /// <summary>
        /// Read a text file and obtain it's contents.
        /// </summary>
        /// <param name="absolutePath">The complete file path to write to.</param>
        /// <returns>String containing the content of the file.</returns>
        public static string GetFileText(this string absolutePath)
        {
            using(StreamReader sr = new StreamReader(absolutePath))
                return sr.ReadToEnd();
        }

        /// <summary>
        /// Creates or opens a file for writing and writes text to it.
        /// </summary>
        /// <param name="absolutePath">The complete file path to write to.</param>
        /// <param name="fileText">A String containing text to be written to the file.</param>
        public static void CreateToFile(this string fileText, string absolutePath)
        {
            using(StreamWriter sw = File.CreateText(absolutePath))
                sw.Write(fileText);
        }

        /// <summary>
        /// Update text within a file by replacing a substring within the file.
        /// </summary>
        /// <param name="absolutePath">The complete file path to write to.</param>
        /// <param name="lookFor">A String to be replaced.</param>
        /// <param name="replaceWith">A String to replace all occurrences of lookFor.</param>
        public static void UpdateFileText(this string absolutePath, string lookFor, string replaceWith)
        {
            string newText = GetFileText(absolutePath).Replace(lookFor, replaceWith);
            WriteToFile(absolutePath, newText);
        }

        /// <summary>
        /// Writes out a string to a file.
        /// </summary>
        /// <param name="absolutePath">The complete file path to write to.</param>
        /// <param name="fileText">A String containing text to be written to the file.</param>
        public static void WriteToFile(this string absolutePath, string fileText)
        {
            using(StreamWriter sw = new StreamWriter(absolutePath, false))
                sw.Write(fileText);
        }

        /// <summary>
        /// Fetches a web page
        /// </summary>
        /// <param name="url">The URL.</param>
        /// <returns></returns>
        public static string ReadWebPage(string url)
        {
            string webPage;
            WebRequest request = WebRequest.Create(url);
            using(Stream stream = request.GetResponse().GetResponseStream())
            {
                StreamReader sr = new StreamReader(stream);
                webPage = sr.ReadToEnd();
                sr.Close();
            }
            return webPage;
        }
    }
}