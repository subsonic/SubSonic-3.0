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
using System.Globalization;
using System.Text.RegularExpressions;

namespace SubSonic.Extensions
{
    /// <summary>
    /// Summary for the Validation class
    /// </summary>
    public static class Validation
    {
        /// <summary>
        /// Determines whether the specified eval string contains only alpha characters.
        /// </summary>
        /// <param name="evalString">The eval string.</param>
        /// <returns>
        /// 	<c>true</c> if the specified eval string is alpha; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsAlpha(this string evalString)
        {
            return !Regex.IsMatch(evalString, RegexPattern.ALPHA);
        }

        /// <summary>
        /// Determines whether the specified eval string contains only alphanumeric characters
        /// </summary>
        /// <param name="evalString">The eval string.</param>
        /// <returns>
        /// 	<c>true</c> if the string is alphanumeric; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsAlphaNumeric(this string evalString)
        {
            return !Regex.IsMatch(evalString, RegexPattern.ALPHA_NUMERIC);
        }

        /// <summary>
        /// Determines whether the specified eval string contains only alphanumeric characters
        /// </summary>
        /// <param name="evalString">The eval string.</param>
        /// <param name="allowSpaces">if set to <c>true</c> [allow spaces].</param>
        /// <returns>
        /// 	<c>true</c> if the string is alphanumeric; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsAlphaNumeric(this string evalString, bool allowSpaces)
        {
            if(allowSpaces)
                return !Regex.IsMatch(evalString, RegexPattern.ALPHA_NUMERIC_SPACE);
            return IsAlphaNumeric(evalString);
        }

        /// <summary>
        /// Determines whether the specified eval string contains only numeric characters
        /// </summary>
        /// <param name="evalString">The eval string.</param>
        /// <returns>
        /// 	<c>true</c> if the string is numeric; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsNumeric(this string evalString)
        {
            return !Regex.IsMatch(evalString, RegexPattern.NUMERIC);
        }

        /// <summary>
        /// Determines whether the specified email address string is valid based on regular expression evaluation.
        /// </summary>
        /// <param name="emailAddressString">The email address string.</param>
        /// <returns>
        /// 	<c>true</c> if the specified email address is valid; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsEmail(this string emailAddressString)
        {
            return Regex.IsMatch(emailAddressString, RegexPattern.EMAIL);
        }

        /// <summary>
        /// Determines whether the specified string is lower case.
        /// </summary>
        /// <param name="inputString">The input string.</param>
        /// <returns>
        /// 	<c>true</c> if the specified string is lower case; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsLowerCase(this string inputString)
        {
            return Regex.IsMatch(inputString, RegexPattern.LOWER_CASE);
        }

        /// <summary>
        /// Determines whether the specified string is upper case.
        /// </summary>
        /// <param name="inputString">The input string.</param>
        /// <returns>
        /// 	<c>true</c> if the specified string is upper case; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsUpperCase(this string inputString)
        {
            return Regex.IsMatch(inputString, RegexPattern.UPPER_CASE);
        }

        /// <summary>
        /// Determines whether the specified string is a valid GUID.
        /// </summary>
        /// <param name="guid">The GUID.</param>
        /// <returns>
        /// 	<c>true</c> if the specified string is a valid GUID; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsGuid(this string guid)
        {
            return Regex.IsMatch(guid, RegexPattern.GUID);
        }

        /// <summary>
        /// Determines whether the specified string is a valid US Zip Code, using either 5 or 5+4 format.
        /// </summary>
        /// <param name="zipCode">The zip code.</param>
        /// <returns>
        /// 	<c>true</c> if it is a valid zip code; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsZIPCodeAny(this string zipCode)
        {
            return Regex.IsMatch(zipCode, RegexPattern.US_ZIPCODE_PLUS_FOUR_OPTIONAL);
        }

        /// <summary>
        /// Determines whether the specified string is a valid US Zip Code, using the 5 digit format.
        /// </summary>
        /// <param name="zipCode">The zip code.</param>
        /// <returns>
        /// 	<c>true</c> if it is a valid zip code; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsZIPCodeFive(this string zipCode)
        {
            return Regex.IsMatch(zipCode, RegexPattern.US_ZIPCODE);
        }

        /// <summary>
        /// Determines whether the specified string is a valid US Zip Code, using the 5+4 format.
        /// </summary>
        /// <param name="zipCode">The zip code.</param>
        /// <returns>
        /// 	<c>true</c> if it is a valid zip code; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsZIPCodeFivePlusFour(this string zipCode)
        {
            return Regex.IsMatch(zipCode, RegexPattern.US_ZIPCODE_PLUS_FOUR);
        }

        /// <summary>
        /// Determines whether the specified string is a valid Social Security number. Dashes are optional.
        /// </summary>
        /// <param name="socialSecurityNumber">The Social Security Number</param>
        /// <returns>
        /// 	<c>true</c> if it is a valid Social Security number; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsSocialSecurityNumber(this string socialSecurityNumber)
        {
            return Regex.IsMatch(socialSecurityNumber, RegexPattern.SOCIAL_SECURITY);
        }

        /// <summary>
        /// Determines whether the specified string is a valid IP address.
        /// </summary>
        /// <param name="ipAddress">The ip address.</param>
        /// <returns>
        /// 	<c>true</c> if valid; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsIPAddress(this string ipAddress)
        {
            return Regex.IsMatch(ipAddress, RegexPattern.IP_ADDRESS);
        }

        /// <summary>
        /// Determines whether the specified string is a valid US phone number using the referenced regex string.
        /// </summary>
        /// <param name="telephoneNumber">The telephone number.</param>
        /// <returns>
        /// 	<c>true</c> if valid; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsUSTelephoneNumber(this string telephoneNumber)
        {
            return Regex.IsMatch(telephoneNumber, RegexPattern.US_TELEPHONE);
        }

        /// <summary>
        /// Determines whether the specified string is a valid currency string using the referenced regex string.
        /// </summary>
        /// <param name="currency">The currency string.</param>
        /// <returns>
        /// 	<c>true</c> if valid; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsUSCurrency(this string currency)
        {
            return Regex.IsMatch(currency, RegexPattern.US_CURRENCY);
        }

        /// <summary>
        /// Determines whether the specified string is a valid URL string using the referenced regex string.
        /// </summary>
        /// <param name="url">The URL string.</param>
        /// <returns>
        /// 	<c>true</c> if valid; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsURL(this string url)
        {
            return Regex.IsMatch(url, RegexPattern.URL);
        }

        /// <summary>
        /// Determines whether the specified string is consider a strong password based on the supplied string.
        /// </summary>
        /// <param name="password">The password.</param>
        /// <returns>
        /// 	<c>true</c> if strong; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsStrongPassword(this string password)
        {
            return Regex.IsMatch(password, RegexPattern.STRONG_PASSWORD);
        }


        #region Credit Cards

        /// <summary>
        /// Determines whether the specified string is a valid credit, based on matching any one of the eight credit card strings
        /// </summary>
        /// <param name="creditCard">The credit card.</param>
        /// <returns>
        /// 	<c>true</c> if valid; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsCreditCardAny(this string creditCard)
        {
            if(CreditPassesFormatCheck(creditCard))
            {
                creditCard = CleanCreditCardNumber(creditCard);
                return Regex.IsMatch(creditCard, RegexPattern.CREDIT_CARD_AMERICAN_EXPRESS) ||
                       Regex.IsMatch(creditCard, RegexPattern.CREDIT_CARD_CARTE_BLANCHE) ||
                       Regex.IsMatch(creditCard, RegexPattern.CREDIT_CARD_DINERS_CLUB) ||
                       Regex.IsMatch(creditCard, RegexPattern.CREDIT_CARD_DISCOVER) ||
                       Regex.IsMatch(creditCard, RegexPattern.CREDIT_CARD_EN_ROUTE) ||
                       Regex.IsMatch(creditCard, RegexPattern.CREDIT_CARD_JCB) ||
                       Regex.IsMatch(creditCard, RegexPattern.CREDIT_CARD_MASTER_CARD) ||
                       Regex.IsMatch(creditCard, RegexPattern.CREDIT_CARD_VISA);
            }
            return false;
        }

        /// <summary>
        /// Determines whether the specified string is an American Express, Discover, MasterCard, or Visa
        /// </summary>
        /// <param name="creditCard">The credit card.</param>
        /// <returns>
        /// 	<c>true</c> if valid; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsCreditCardBigFour(this string creditCard)
        {
            if(CreditPassesFormatCheck(creditCard))
            {
                creditCard = CleanCreditCardNumber(creditCard);
                return Regex.IsMatch(creditCard, RegexPattern.CREDIT_CARD_AMERICAN_EXPRESS) ||
                       Regex.IsMatch(creditCard, RegexPattern.CREDIT_CARD_DISCOVER) ||
                       Regex.IsMatch(creditCard, RegexPattern.CREDIT_CARD_MASTER_CARD) ||
                       Regex.IsMatch(creditCard, RegexPattern.CREDIT_CARD_VISA);
            }
            return false;
        }

        /// <summary>
        /// Determines whether the specified string is an American Express card
        /// </summary>
        /// <param name="creditCard">The credit card.</param>
        /// <returns>
        /// 	<c>true</c> if valid; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsCreditCardAmericanExpress(this string creditCard)
        {
            if(CreditPassesFormatCheck(creditCard))
            {
                creditCard = CleanCreditCardNumber(creditCard);
                return Regex.IsMatch(creditCard, RegexPattern.CREDIT_CARD_AMERICAN_EXPRESS);
            }
            return false;
        }

        /// <summary>
        /// Determines whether the specified string is an Carte Blanche card
        /// </summary>
        /// <param name="creditCard">The credit card.</param>
        /// <returns>
        /// 	<c>true</c> if valid; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsCreditCardCarteBlanche(this string creditCard)
        {
            if(CreditPassesFormatCheck(creditCard))
            {
                creditCard = CleanCreditCardNumber(creditCard);
                return Regex.IsMatch(creditCard, RegexPattern.CREDIT_CARD_CARTE_BLANCHE);
            }
            return false;
        }

        /// <summary>
        /// Determines whether the specified string is an Diner's Club card
        /// </summary>
        /// <param name="creditCard">The credit card.</param>
        /// <returns>
        /// 	<c>true</c> if valid; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsCreditCardDinersClub(this string creditCard)
        {
            if(CreditPassesFormatCheck(creditCard))
            {
                creditCard = CleanCreditCardNumber(creditCard);
                return Regex.IsMatch(creditCard, RegexPattern.CREDIT_CARD_DINERS_CLUB);
            }
            return false;
        }

        /// <summary>
        /// Determines whether the specified string is a Discover card
        /// </summary>
        /// <param name="creditCard">The credit card.</param>
        /// <returns>
        /// 	<c>true</c> if valid; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsCreditCardDiscover(this string creditCard)
        {
            if(CreditPassesFormatCheck(creditCard))
            {
                creditCard = CleanCreditCardNumber(creditCard);
                return Regex.IsMatch(creditCard, RegexPattern.CREDIT_CARD_DISCOVER);
            }
            return false;
        }

        /// <summary>
        /// Determines whether the specified string is an En Route card
        /// </summary>
        /// <param name="creditCard">The credit card.</param>
        /// <returns>
        /// 	<c>true</c> if valid; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsCreditCardEnRoute(this string creditCard)
        {
            if(CreditPassesFormatCheck(creditCard))
            {
                creditCard = CleanCreditCardNumber(creditCard);
                return Regex.IsMatch(creditCard, RegexPattern.CREDIT_CARD_EN_ROUTE);
            }
            return false;
        }

        /// <summary>
        /// Determines whether the specified string is an JCB card
        /// </summary>
        /// <param name="creditCard">The credit card.</param>
        /// <returns>
        /// 	<c>true</c> if valid; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsCreditCardJCB(this string creditCard)
        {
            if(CreditPassesFormatCheck(creditCard))
            {
                creditCard = CleanCreditCardNumber(creditCard);
                return Regex.IsMatch(creditCard, RegexPattern.CREDIT_CARD_JCB);
            }
            return false;
        }

        /// <summary>
        /// Determines whether the specified string is a Master Card credit card
        /// </summary>
        /// <param name="creditCard">The credit card.</param>
        /// <returns>
        /// 	<c>true</c> if valid; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsCreditCardMasterCard(this string creditCard)
        {
            if(CreditPassesFormatCheck(creditCard))
            {
                creditCard = CleanCreditCardNumber(creditCard);
                return Regex.IsMatch(creditCard, RegexPattern.CREDIT_CARD_MASTER_CARD);
            }
            return false;
        }

        /// <summary>
        /// Determines whether the specified string is Visa card.
        /// </summary>
        /// <param name="creditCard">The credit card.</param>
        /// <returns>
        /// 	<c>true</c> if valid; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsCreditCardVisa(this string creditCard)
        {
            if(CreditPassesFormatCheck(creditCard))
            {
                creditCard = CleanCreditCardNumber(creditCard);
                return Regex.IsMatch(creditCard, RegexPattern.CREDIT_CARD_VISA);
            }
            return false;
        }

        /// <summary>
        /// Cleans the credit card number, returning just the numeric values.
        /// </summary>
        /// <param name="creditCard">The credit card.</param>
        /// <returns></returns>
        public static string CleanCreditCardNumber(this string creditCard)
        {
            Regex regex = new Regex(RegexPattern.CREDIT_CARD_STRIP_NON_NUMERIC, RegexOptions.IgnoreCase | RegexOptions.Singleline);
            return regex.Replace(creditCard, String.Empty);
        }

        /// <summary>
        /// Determines whether the credit card number, once cleaned, passes the Luhn algorith.
        /// See: http://en.wikipedia.org/wiki/Luhn_algorithm
        /// </summary>
        /// <param name="creditCardNumber">The credit card number.</param>
        /// <returns></returns>
        private static bool CreditPassesFormatCheck(this string creditCardNumber)
        {
            creditCardNumber = CleanCreditCardNumber(creditCardNumber);
            if(creditCardNumber.IsInteger())
            {
                int[] numArray = new int[creditCardNumber.Length];
                for(int i = 0; i < numArray.Length; i++)
                    numArray[i] = Convert.ToInt16(creditCardNumber[i].ToString());

                return IsValidLuhn(numArray);
            }
            return false;
        }

        /// <summary>
        /// Determines whether the specified int array passes the Luhn algorith
        /// </summary>
        /// <param name="digits">The int array to evaluate</param>
        /// <returns>
        /// 	<c>true</c> if it validates; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsValidLuhn(this int[] digits)
        {
            int sum = 0;
            bool alt = false;
            for(int i = digits.Length - 1; i >= 0; i--)
            {
                if(alt)
                {
                    digits[i] *= 2;
                    if(digits[i] > 9)
                        digits[i] -= 9; // equivalent to adding the value of digits
                }
                sum += digits[i];
                alt = !alt;
            }
            return sum % 10 == 0;
        }

        /// <summary>
        /// Determine whether the passed string is numeric, by attempting to parse it to a double
        /// </summary>
        /// <param name="str">The string to evaluated for numeric conversion</param>
        /// <returns>
        /// 	<c>true</c> if the string can be converted to a number; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsStringNumeric(this string str)
        {
            double result;
            return (double.TryParse(str, NumberStyles.Float, NumberFormatInfo.CurrentInfo, out result));
        }

        #endregion
    }
}