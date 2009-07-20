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
using System.Collections.Generic;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;

namespace SubSonic.Extensions
{
    public static class Strings
    {
        private static readonly Dictionary<int, string> _entityTable = new Dictionary<int, string>();
        private static readonly Dictionary<string, string> _USStateTable = new Dictionary<string, string>();

        /// <summary>
        /// Initializes the <see cref="Strings"/> class.
        /// </summary>
        static Strings()
        {
            FillEntities();
            FillUSStates();
        }

        public static bool Matches(this string source, string compare)
        {
            return String.Equals(source, compare, StringComparison.InvariantCultureIgnoreCase);
        }

        public static bool MatchesTrimmed(this string source, string compare)
        {
            return String.Equals(source.Trim(), compare.Trim(), StringComparison.InvariantCultureIgnoreCase);
        }

        public static bool MatchesRegex(this string inputString, string matchPattern)
        {
            return Regex.IsMatch(inputString, matchPattern,
                RegexOptions.IgnoreCase | RegexOptions.IgnorePatternWhitespace);
        }

        /// <summary>
        /// Strips the last specified chars from a string.
        /// </summary>
        /// <param name="sourceString">The source string.</param>
        /// <param name="removeFromEnd">The remove from end.</param>
        /// <returns></returns>
        public static string Chop(this string sourceString, int removeFromEnd)
        {
            string result = sourceString;
            if((removeFromEnd > 0) && (sourceString.Length > removeFromEnd - 1))
                result = result.Remove(sourceString.Length - removeFromEnd, removeFromEnd);
            return result;
        }

        /// <summary>
        /// Strips the last specified chars from a string.
        /// </summary>
        /// <param name="sourceString">The source string.</param>
        /// <param name="backDownTo">The back down to.</param>
        /// <returns></returns>
        public static string Chop(this string sourceString, string backDownTo)
        {
            int removeDownTo = sourceString.LastIndexOf(backDownTo);
            int removeFromEnd = 0;
            if(removeDownTo > 0)
                removeFromEnd = sourceString.Length - removeDownTo;

            string result = sourceString;

            if(sourceString.Length > removeFromEnd - 1)
                result = result.Remove(removeDownTo, removeFromEnd);

            return result;
        }

        /// <summary>
        /// Plurals to singular.
        /// </summary>
        /// <param name="sourceString">The source string.</param>
        /// <returns></returns>
        public static string PluralToSingular(this string sourceString)
        {
            return sourceString.MakeSingular();
        }

        /// <summary>
        /// Singulars to plural.
        /// </summary>
        /// <param name="sourceString">The source string.</param>
        /// <returns></returns>
        public static string SingularToPlural(this string sourceString)
        {
            return sourceString.MakePlural();
        }

        /// <summary>
        /// Make plural when count is not one
        /// </summary>
        /// <param name="number">The number of things</param>
        /// <param name="sourceString">The source string.</param>
        /// <returns></returns>
        public static string Pluralize(this int number, string sourceString)
        {
            if(number == 1)
                return String.Concat(number, " ", sourceString.MakeSingular());
            return String.Concat(number, " ", sourceString.MakePlural());
        }

        /// <summary>
        /// Removes the specified chars from the beginning of a string.
        /// </summary>
        /// <param name="sourceString">The source string.</param>
        /// <param name="removeFromBeginning">The remove from beginning.</param>
        /// <returns></returns>
        public static string Clip(this string sourceString, int removeFromBeginning)
        {
            string result = sourceString;
            if(sourceString.Length > removeFromBeginning)
                result = result.Remove(0, removeFromBeginning);
            return result;
        }

        /// <summary>
        /// Removes chars from the beginning of a string, up to the specified string
        /// </summary>
        /// <param name="sourceString">The source string.</param>
        /// <param name="removeUpTo">The remove up to.</param>
        /// <returns></returns>
        public static string Clip(this string sourceString, string removeUpTo)
        {
            int removeFromBeginning = sourceString.IndexOf(removeUpTo);
            string result = sourceString;

            if(sourceString.Length > removeFromBeginning && removeFromBeginning > 0)
                result = result.Remove(0, removeFromBeginning);

            return result;
        }

        /// <summary>
        /// Strips the last char from a a string.
        /// </summary>
        /// <param name="sourceString">The source string.</param>
        /// <returns></returns>
        public static string Chop(this string sourceString)
        {
            return Chop(sourceString, 1);
        }

        /// <summary>
        /// Strips the last char from a a string.
        /// </summary>
        /// <param name="sourceString">The source string.</param>
        /// <returns></returns>
        public static string Clip(this string sourceString)
        {
            return Clip(sourceString, 1);
        }

        /// <summary>
        /// Fasts the replace.
        /// </summary>
        /// <param name="original">The original.</param>
        /// <param name="pattern">The pattern.</param>
        /// <param name="replacement">The replacement.</param>
        /// <returns></returns>
        public static string FastReplace(this string original, string pattern, string replacement)
        {
            return FastReplace(original, pattern, replacement, StringComparison.InvariantCultureIgnoreCase);
        }

        /// <summary>
        /// Fasts the replace.
        /// </summary>
        /// <param name="original">The original.</param>
        /// <param name="pattern">The pattern.</param>
        /// <param name="replacement">The replacement.</param>
        /// <param name="comparisonType">Type of the comparison.</param>
        /// <returns></returns>
        public static string FastReplace(this string original, string pattern, string replacement,
                                         StringComparison comparisonType)
        {
            if(original == null)
                return null;

            if(String.IsNullOrEmpty(pattern))
                return original;

            int lenPattern = pattern.Length;
            int idxPattern = -1;
            int idxLast = 0;

            StringBuilder result = new StringBuilder();

            while(true)
            {
                idxPattern = original.IndexOf(pattern, idxPattern + 1, comparisonType);

                if(idxPattern < 0)
                {
                    result.Append(original, idxLast, original.Length - idxLast);
                    break;
                }

                result.Append(original, idxLast, idxPattern - idxLast);
                result.Append(replacement);

                idxLast = idxPattern + lenPattern;
            }

            return result.ToString();
        }

        /// <summary>
        /// Returns text that is located between the startText and endText tags.
        /// </summary>
        /// <param name="sourceString">The source string.</param>
        /// <param name="startText">The text from which to start the crop</param>
        /// <param name="endText">The endpoint of the crop</param>
        /// <returns></returns>
        public static string Crop(this string sourceString, string startText, string endText)
        {
            int startIndex = sourceString.IndexOf(startText, StringComparison.CurrentCultureIgnoreCase);
            if(startIndex == -1)
                return String.Empty;

            startIndex += startText.Length;
            int endIndex = sourceString.IndexOf(endText, startIndex, StringComparison.CurrentCultureIgnoreCase);
            if(endIndex == -1)
                return String.Empty;

            return sourceString.Substring(startIndex, endIndex - startIndex);
        }

        /// <summary>
        /// Removes excess white space in a string.
        /// </summary>
        /// <param name="sourceString">The source string.</param>
        /// <returns></returns>
        public static string Squeeze(this string sourceString)
        {
            char[] delim = {' '};
            string[] lines = sourceString.Split(delim, StringSplitOptions.RemoveEmptyEntries);
            StringBuilder sb = new StringBuilder();
            foreach(string s in lines)
            {
                if(!String.IsNullOrEmpty(s.Trim()))
                    sb.Append(s + " ");
            }
            //remove the last pipe
            string result = Chop(sb.ToString());
            return result.Trim();
        }

        /// <summary>
        /// Removes all non-alpha numeric characters in a string
        /// </summary>
        /// <param name="sourceString">The source string.</param>
        /// <returns></returns>
        public static string ToAlphaNumericOnly(this string sourceString)
        {
            return Regex.Replace(sourceString, @"\W*", "");
        }

        /// <summary>
        /// Creates a string array based on the words in a sentence
        /// </summary>
        /// <param name="sourceString">The source string.</param>
        /// <returns></returns>
        public static string[] ToWords(this string sourceString)
        {
            string result = sourceString.Trim();
            return result.Split(new[] {' '}, StringSplitOptions.RemoveEmptyEntries);
        }

        /// <summary>
        /// Strips all HTML tags from a string
        /// </summary>
        /// <param name="htmlString">The HTML string.</param>
        /// <returns></returns>
        public static string StripHTML(this string htmlString)
        {
            return StripHTML(htmlString, String.Empty);
        }

        /// <summary>
        /// Strips all HTML tags from a string and replaces the tags with the specified replacement
        /// </summary>
        /// <param name="htmlString">The HTML string.</param>
        /// <param name="htmlPlaceHolder">The HTML place holder.</param>
        /// <returns></returns>
        public static string StripHTML(this string htmlString, string htmlPlaceHolder)
        {
            const string pattern = @"<(.|\n)*?>";
            string sOut = Regex.Replace(htmlString, pattern, htmlPlaceHolder);
            sOut = sOut.Replace("&nbsp;", String.Empty);
            sOut = sOut.Replace("&amp;", "&");
            sOut = sOut.Replace("&gt;", ">");
            sOut = sOut.Replace("&lt;", "<");
            return sOut;
        }

        public static List<string> FindMatches(this string source, string find)
        {
            Regex reg = new Regex(find, RegexOptions.IgnoreCase);

            List<string> result = new List<string>();
            foreach(Match m in reg.Matches(source))
                result.Add(m.Value);
            return result;
        }

        /// <summary>
        /// Converts a generic List collection to a single comma-delimitted string.
        /// </summary>
        /// <param name="list">The list.</param>
        /// <returns></returns>
        public static string ToDelimitedList(this IEnumerable<string> list)
        {
            return ToDelimitedList(list, ",");
        }

        /// <summary>
        /// Converts a generic List collection to a single string using the specified delimitter.
        /// </summary>
        /// <param name="list">The list.</param>
        /// <param name="delimiter">The delimiter.</param>
        /// <returns></returns>
        public static string ToDelimitedList(this IEnumerable<string> list, string delimiter)
        {
            StringBuilder sb = new StringBuilder();
            foreach(string s in list)
                sb.Append(String.Concat(s, delimiter));
            string result = sb.ToString();
            result = Chop(result);
            return result;
        }

        /// <summary>
        /// Strips the specified input.
        /// </summary>
        /// <param name="sourceString">The source string.</param>
        /// <param name="stripValue">The strip value.</param>
        /// <returns></returns>
        public static string Strip(this string sourceString, string stripValue)
        {
            if(!String.IsNullOrEmpty(stripValue))
            {
                string[] replace = stripValue.Split(new[] {','});
                for(int i = 0; i < replace.Length; i++)
                {
                    if(!String.IsNullOrEmpty(sourceString))
                        sourceString = Regex.Replace(sourceString, replace[i], String.Empty);
                }
            }
            return sourceString;
        }

        /// <summary>
        /// Converts ASCII encoding to Unicode
        /// </summary>
        /// <param name="asciiCode">The ASCII code.</param>
        /// <returns></returns>
        public static string AsciiToUnicode(this int asciiCode)
        {
            Encoding ascii = Encoding.UTF32;
            char c = (char)asciiCode;
            Byte[] b = ascii.GetBytes(c.ToString());
            return ascii.GetString((b));
        }

        /// <summary>
        /// Converts Text to HTML-encoded string
        /// </summary>
        /// <param name="textString">The text string.</param>
        /// <returns></returns>
        public static string TextToEntity(this string textString)
        {
            foreach(KeyValuePair<int, string> key in _entityTable)
                textString = textString.Replace(AsciiToUnicode(key.Key), key.Value);
            return textString.Replace(AsciiToUnicode(38), "&amp;");
        }

        /// <summary>
        /// Converts HTML-encoded bits to Text
        /// </summary>
        /// <param name="entityText">The entity text.</param>
        /// <returns></returns>
        public static string EntityToText(this string entityText)
        {
            entityText = entityText.Replace("&amp;", "&");
            foreach(KeyValuePair<int, string> key in _entityTable)
                entityText = entityText.Replace(key.Value, AsciiToUnicode(key.Key));
            return entityText;
        }

        /// <summary>
        /// Formats the args using String.Format with the target string as a format string.
        /// </summary>
        /// <param name="fmt">The format string passed to String.Format</param>
        /// <param name="args">The args passed to String.Format</param>
        /// <returns></returns>
        public static string ToFormattedString(this string fmt, params object[] args)
        {
            return String.Format(fmt, args);
        }

        /// <summary>
        /// Strings to enum.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="Value">The value.</param>
        /// <returns></returns>
        public static T ToEnum<T>(this string Value)
        {
            T oOut = default(T);
            Type t = typeof(T);
            foreach(FieldInfo fi in t.GetFields())
            {
                if(fi.Name.Matches(Value))
                    oOut = (T)fi.GetValue(null);
            }

            return oOut;
        }

        /// <summary>
        /// Fills the entities.
        /// </summary>
        private static void FillEntities()
        {
            _entityTable.Add(160, "&nbsp;");
            _entityTable.Add(161, "&iexcl;");
            _entityTable.Add(162, "&cent;");
            _entityTable.Add(163, "&pound;");
            _entityTable.Add(164, "&curren;");
            _entityTable.Add(165, "&yen;");
            _entityTable.Add(166, "&brvbar;");
            _entityTable.Add(167, "&sect;");
            _entityTable.Add(168, "&uml;");
            _entityTable.Add(169, "&copy;");
            _entityTable.Add(170, "&ordf;");
            _entityTable.Add(171, "&laquo;");
            _entityTable.Add(172, "&not;");
            _entityTable.Add(173, "&shy;");
            _entityTable.Add(174, "&reg;");
            _entityTable.Add(175, "&macr;");
            _entityTable.Add(176, "&deg;");
            _entityTable.Add(177, "&plusmn;");
            _entityTable.Add(178, "&sup2;");
            _entityTable.Add(179, "&sup3;");
            _entityTable.Add(180, "&acute;");
            _entityTable.Add(181, "&micro;");
            _entityTable.Add(182, "&para;");
            _entityTable.Add(183, "&middot;");
            _entityTable.Add(184, "&cedil;");
            _entityTable.Add(185, "&sup1;");
            _entityTable.Add(186, "&ordm;");
            _entityTable.Add(187, "&raquo;");
            _entityTable.Add(188, "&frac14;");
            _entityTable.Add(189, "&frac12;");
            _entityTable.Add(190, "&frac34;");
            _entityTable.Add(191, "&iquest;");
            _entityTable.Add(192, "&Agrave;");
            _entityTable.Add(193, "&Aacute;");
            _entityTable.Add(194, "&Acirc;");
            _entityTable.Add(195, "&Atilde;");
            _entityTable.Add(196, "&Auml;");
            _entityTable.Add(197, "&Aring;");
            _entityTable.Add(198, "&AElig;");
            _entityTable.Add(199, "&Ccedil;");
            _entityTable.Add(200, "&Egrave;");
            _entityTable.Add(201, "&Eacute;");
            _entityTable.Add(202, "&Ecirc;");
            _entityTable.Add(203, "&Euml;");
            _entityTable.Add(204, "&Igrave;");
            _entityTable.Add(205, "&Iacute;");
            _entityTable.Add(206, "&Icirc;");
            _entityTable.Add(207, "&Iuml;");
            _entityTable.Add(208, "&ETH;");
            _entityTable.Add(209, "&Ntilde;");
            _entityTable.Add(210, "&Ograve;");
            _entityTable.Add(211, "&Oacute;");
            _entityTable.Add(212, "&Ocirc;");
            _entityTable.Add(213, "&Otilde;");
            _entityTable.Add(214, "&Ouml;");
            _entityTable.Add(215, "&times;");
            _entityTable.Add(216, "&Oslash;");
            _entityTable.Add(217, "&Ugrave;");
            _entityTable.Add(218, "&Uacute;");
            _entityTable.Add(219, "&Ucirc;");
            _entityTable.Add(220, "&Uuml;");
            _entityTable.Add(221, "&Yacute;");
            _entityTable.Add(222, "&THORN;");
            _entityTable.Add(223, "&szlig;");
            _entityTable.Add(224, "&agrave;");
            _entityTable.Add(225, "&aacute;");
            _entityTable.Add(226, "&acirc;");
            _entityTable.Add(227, "&atilde;");
            _entityTable.Add(228, "&auml;");
            _entityTable.Add(229, "&aring;");
            _entityTable.Add(230, "&aelig;");
            _entityTable.Add(231, "&ccedil;");
            _entityTable.Add(232, "&egrave;");
            _entityTable.Add(233, "&eacute;");
            _entityTable.Add(234, "&ecirc;");
            _entityTable.Add(235, "&euml;");
            _entityTable.Add(236, "&igrave;");
            _entityTable.Add(237, "&iacute;");
            _entityTable.Add(238, "&icirc;");
            _entityTable.Add(239, "&iuml;");
            _entityTable.Add(240, "&eth;");
            _entityTable.Add(241, "&ntilde;");
            _entityTable.Add(242, "&ograve;");
            _entityTable.Add(243, "&oacute;");
            _entityTable.Add(244, "&ocirc;");
            _entityTable.Add(245, "&otilde;");
            _entityTable.Add(246, "&ouml;");
            _entityTable.Add(247, "&divide;");
            _entityTable.Add(248, "&oslash;");
            _entityTable.Add(249, "&ugrave;");
            _entityTable.Add(250, "&uacute;");
            _entityTable.Add(251, "&ucirc;");
            _entityTable.Add(252, "&uuml;");
            _entityTable.Add(253, "&yacute;");
            _entityTable.Add(254, "&thorn;");
            _entityTable.Add(255, "&yuml;");
            _entityTable.Add(402, "&fnof;");
            _entityTable.Add(913, "&Alpha;");
            _entityTable.Add(914, "&Beta;");
            _entityTable.Add(915, "&Gamma;");
            _entityTable.Add(916, "&Delta;");
            _entityTable.Add(917, "&Epsilon;");
            _entityTable.Add(918, "&Zeta;");
            _entityTable.Add(919, "&Eta;");
            _entityTable.Add(920, "&Theta;");
            _entityTable.Add(921, "&Iota;");
            _entityTable.Add(922, "&Kappa;");
            _entityTable.Add(923, "&Lambda;");
            _entityTable.Add(924, "&Mu;");
            _entityTable.Add(925, "&Nu;");
            _entityTable.Add(926, "&Xi;");
            _entityTable.Add(927, "&Omicron;");
            _entityTable.Add(928, "&Pi;");
            _entityTable.Add(929, "&Rho;");
            _entityTable.Add(931, "&Sigma;");
            _entityTable.Add(932, "&Tau;");
            _entityTable.Add(933, "&Upsilon;");
            _entityTable.Add(934, "&Phi;");
            _entityTable.Add(935, "&Chi;");
            _entityTable.Add(936, "&Psi;");
            _entityTable.Add(937, "&Omega;");
            _entityTable.Add(945, "&alpha;");
            _entityTable.Add(946, "&beta;");
            _entityTable.Add(947, "&gamma;");
            _entityTable.Add(948, "&delta;");
            _entityTable.Add(949, "&epsilon;");
            _entityTable.Add(950, "&zeta;");
            _entityTable.Add(951, "&eta;");
            _entityTable.Add(952, "&theta;");
            _entityTable.Add(953, "&iota;");
            _entityTable.Add(954, "&kappa;");
            _entityTable.Add(955, "&lambda;");
            _entityTable.Add(956, "&mu;");
            _entityTable.Add(957, "&nu;");
            _entityTable.Add(958, "&xi;");
            _entityTable.Add(959, "&omicron;");
            _entityTable.Add(960, "&pi;");
            _entityTable.Add(961, "&rho;");
            _entityTable.Add(962, "&sigmaf;");
            _entityTable.Add(963, "&sigma;");
            _entityTable.Add(964, "&tau;");
            _entityTable.Add(965, "&upsilon;");
            _entityTable.Add(966, "&phi;");
            _entityTable.Add(967, "&chi;");
            _entityTable.Add(968, "&psi;");
            _entityTable.Add(969, "&omega;");
            _entityTable.Add(977, "&thetasym;");
            _entityTable.Add(978, "&upsih;");
            _entityTable.Add(982, "&piv;");
            _entityTable.Add(8226, "&bull;");
            _entityTable.Add(8230, "&hellip;");
            _entityTable.Add(8242, "&prime;");
            _entityTable.Add(8243, "&Prime;");
            _entityTable.Add(8254, "&oline;");
            _entityTable.Add(8260, "&frasl;");
            _entityTable.Add(8472, "&weierp;");
            _entityTable.Add(8465, "&image;");
            _entityTable.Add(8476, "&real;");
            _entityTable.Add(8482, "&trade;");
            _entityTable.Add(8501, "&alefsym;");
            _entityTable.Add(8592, "&larr;");
            _entityTable.Add(8593, "&uarr;");
            _entityTable.Add(8594, "&rarr;");
            _entityTable.Add(8595, "&darr;");
            _entityTable.Add(8596, "&harr;");
            _entityTable.Add(8629, "&crarr;");
            _entityTable.Add(8656, "&lArr;");
            _entityTable.Add(8657, "&uArr;");
            _entityTable.Add(8658, "&rArr;");
            _entityTable.Add(8659, "&dArr;");
            _entityTable.Add(8660, "&hArr;");
            _entityTable.Add(8704, "&forall;");
            _entityTable.Add(8706, "&part;");
            _entityTable.Add(8707, "&exist;");
            _entityTable.Add(8709, "&empty;");
            _entityTable.Add(8711, "&nabla;");
            _entityTable.Add(8712, "&isin;");
            _entityTable.Add(8713, "&notin;");
            _entityTable.Add(8715, "&ni;");
            _entityTable.Add(8719, "&prod;");
            _entityTable.Add(8721, "&sum;");
            _entityTable.Add(8722, "&minus;");
            _entityTable.Add(8727, "&lowast;");
            _entityTable.Add(8730, "&radic;");
            _entityTable.Add(8733, "&prop;");
            _entityTable.Add(8734, "&infin;");
            _entityTable.Add(8736, "&ang;");
            _entityTable.Add(8743, "&and;");
            _entityTable.Add(8744, "&or;");
            _entityTable.Add(8745, "&cap;");
            _entityTable.Add(8746, "&cup;");
            _entityTable.Add(8747, "&int;");
            _entityTable.Add(8756, "&there4;");
            _entityTable.Add(8764, "&sim;");
            _entityTable.Add(8773, "&cong;");
            _entityTable.Add(8776, "&asymp;");
            _entityTable.Add(8800, "&ne;");
            _entityTable.Add(8801, "&equiv;");
            _entityTable.Add(8804, "&le;");
            _entityTable.Add(8805, "&ge;");
            _entityTable.Add(8834, "&sub;");
            _entityTable.Add(8835, "&sup;");
            _entityTable.Add(8836, "&nsub;");
            _entityTable.Add(8838, "&sube;");
            _entityTable.Add(8839, "&supe;");
            _entityTable.Add(8853, "&oplus;");
            _entityTable.Add(8855, "&otimes;");
            _entityTable.Add(8869, "&perp;");
            _entityTable.Add(8901, "&sdot;");
            _entityTable.Add(8968, "&lceil;");
            _entityTable.Add(8969, "&rceil;");
            _entityTable.Add(8970, "&lfloor;");
            _entityTable.Add(8971, "&rfloor;");
            _entityTable.Add(9001, "&lang;");
            _entityTable.Add(9002, "&rang;");
            _entityTable.Add(9674, "&loz;");
            _entityTable.Add(9824, "&spades;");
            _entityTable.Add(9827, "&clubs;");
            _entityTable.Add(9829, "&hearts;");
            _entityTable.Add(9830, "&diams;");
            _entityTable.Add(34, "&quot;");
            //_entityTable.Add(38, "&amp;");
            _entityTable.Add(60, "&lt;");
            _entityTable.Add(62, "&gt;");
            _entityTable.Add(338, "&OElig;");
            _entityTable.Add(339, "&oelig;");
            _entityTable.Add(352, "&Scaron;");
            _entityTable.Add(353, "&scaron;");
            _entityTable.Add(376, "&Yuml;");
            _entityTable.Add(710, "&circ;");
            _entityTable.Add(732, "&tilde;");
            _entityTable.Add(8194, "&ensp;");
            _entityTable.Add(8195, "&emsp;");
            _entityTable.Add(8201, "&thinsp;");
            _entityTable.Add(8204, "&zwnj;");
            _entityTable.Add(8205, "&zwj;");
            _entityTable.Add(8206, "&lrm;");
            _entityTable.Add(8207, "&rlm;");
            _entityTable.Add(8211, "&ndash;");
            _entityTable.Add(8212, "&mdash;");
            _entityTable.Add(8216, "&lsquo;");
            _entityTable.Add(8217, "&rsquo;");
            _entityTable.Add(8218, "&sbquo;");
            _entityTable.Add(8220, "&ldquo;");
            _entityTable.Add(8221, "&rdquo;");
            _entityTable.Add(8222, "&bdquo;");
            _entityTable.Add(8224, "&dagger;");
            _entityTable.Add(8225, "&Dagger;");
            _entityTable.Add(8240, "&permil;");
            _entityTable.Add(8249, "&lsaquo;");
            _entityTable.Add(8250, "&rsaquo;");
            _entityTable.Add(8364, "&euro;");
        }

        /// <summary>
        /// Converts US State Name to it's two-character abbreviation. Returns null if the state name was not found.
        /// </summary>
        /// <param name="stateName">US State Name (ie Texas)</param>
        /// <returns></returns>
        public static string USStateNameToAbbrev(string stateName)
        {
            stateName = stateName.ToUpper();
            foreach(KeyValuePair<string, string> key in _USStateTable)
            {
                if(stateName == key.Key)
                    return key.Value;
            }
            return null;
        }

        /// <summary>
        /// Converts a two-character US State Abbreviation to it's official Name Returns null if the abbreviation was not found.
        /// </summary>
        /// <param name="stateAbbrev">US State Name (ie Texas)</param>
        /// <returns></returns>
        public static string USStateAbbrevToName(string stateAbbrev)
        {
            stateAbbrev = stateAbbrev.ToUpper();
            foreach(KeyValuePair<string, string> key in _USStateTable)
            {
                if(stateAbbrev == key.Value)
                    return key.Key;
            }
            return null;
        }

        /// <summary>
        /// Fills the US States.
        /// </summary>
        private static void FillUSStates()
        {
            _USStateTable.Add("ALABAMA", "AL");
            _USStateTable.Add("ALASKA", "AK");
            _USStateTable.Add("AMERICAN SAMOA", "AS");
            _USStateTable.Add("ARIZONA ", "AZ");
            _USStateTable.Add("ARKANSAS", "AR");
            _USStateTable.Add("CALIFORNIA ", "CA");
            _USStateTable.Add("COLORADO ", "CO");
            _USStateTable.Add("CONNECTICUT", "CT");
            _USStateTable.Add("DELAWARE", "DE");
            _USStateTable.Add("DISTRICT OF COLUMBIA", "DC");
            _USStateTable.Add("FEDERATED STATES OF MICRONESIA", "FM");
            _USStateTable.Add("FLORIDA", "FL");
            _USStateTable.Add("GEORGIA", "GA");
            _USStateTable.Add("GUAM ", "GU");
            _USStateTable.Add("HAWAII", "HI");
            _USStateTable.Add("IDAHO", "ID");
            _USStateTable.Add("ILLINOIS", "IL");
            _USStateTable.Add("INDIANA", "IN");
            _USStateTable.Add("IOWA", "IA");
            _USStateTable.Add("KANSAS", "KS");
            _USStateTable.Add("KENTUCKY", "KY");
            _USStateTable.Add("LOUISIANA", "LA");
            _USStateTable.Add("MAINE", "ME");
            _USStateTable.Add("MARSHALL ISLANDS", "MH");
            _USStateTable.Add("MARYLAND", "MD");
            _USStateTable.Add("MASSACHUSETTS", "MA");
            _USStateTable.Add("MICHIGAN", "MI");
            _USStateTable.Add("MINNESOTA", "MN");
            _USStateTable.Add("MISSISSIPPI", "MS");
            _USStateTable.Add("MISSOURI", "MO");
            _USStateTable.Add("MONTANA", "MT");
            _USStateTable.Add("NEBRASKA", "NE");
            _USStateTable.Add("NEVADA", "NV");
            _USStateTable.Add("NEW HAMPSHIRE", "NH");
            _USStateTable.Add("NEW JERSEY", "NJ");
            _USStateTable.Add("NEW MEXICO", "NM");
            _USStateTable.Add("NEW YORK", "NY");
            _USStateTable.Add("NORTH CAROLINA", "NC");
            _USStateTable.Add("NORTH DAKOTA", "ND");
            _USStateTable.Add("NORTHERN MARIANA ISLANDS", "MP");
            _USStateTable.Add("OHIO", "OH");
            _USStateTable.Add("OKLAHOMA", "OK");
            _USStateTable.Add("OREGON", "OR");
            _USStateTable.Add("PALAU", "PW");
            _USStateTable.Add("PENNSYLVANIA", "PA");
            _USStateTable.Add("PUERTO RICO", "PR");
            _USStateTable.Add("RHODE ISLAND", "RI");
            _USStateTable.Add("SOUTH CAROLINA", "SC");
            _USStateTable.Add("SOUTH DAKOTA", "SD");
            _USStateTable.Add("TENNESSEE", "TN");
            _USStateTable.Add("TEXAS", "TX");
            _USStateTable.Add("UTAH", "UT");
            _USStateTable.Add("VERMONT", "VT");
            _USStateTable.Add("VIRGIN ISLANDS", "VI");
            _USStateTable.Add("VIRGINIA ", "VA");
            _USStateTable.Add("WASHINGTON", "WA");
            _USStateTable.Add("WEST VIRGINIA", "WV");
            _USStateTable.Add("WISCONSIN", "WI");
            _USStateTable.Add("WYOMING", "WY");
        }
    }
}