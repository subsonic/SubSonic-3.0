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
using System.Linq.Expressions;
using SubSonic.Query;

namespace SubSonic.Extensions
{
    public static class Linq
    {
        /// <summary>
        /// Parses the object value.
        /// </summary>
        /// <param name="expression">The expression.</param>
        /// <returns></returns>
        public static string ParseObjectValue(this LambdaExpression expression)
        {
            string result = String.Empty;
            if(expression.Body is MemberExpression)
            {
                MemberExpression m = expression.Body as MemberExpression;
                result = m.Member.Name;
            }
            else if(expression.Body.NodeType == ExpressionType.Convert)
            {
                UnaryExpression u = expression.Body as UnaryExpression;
                if (u != null)
                {
                    MemberExpression m = u.Operand as MemberExpression;
                    if(m != null)
                        result = m.Member.Name;
                }
            }
            return result;
        }

        /// <summary>
        /// Parses the passed-in Expression into exclusive (WHERE x=y) constraints.
        /// </summary>
        /// <param name="exp">The exp.</param>
        /// <returns></returns>
        public static IList<Constraint> ParseConstraints(this Expression exp)
        {
            QueryVisitor q = new QueryVisitor();
            return q.GetConstraints(exp);
        }

        /// <summary>
        /// Parses the passed-in Expression into exclusive (WHERE x=y) constraint.
        /// </summary>
        /// <param name="expression">The expression.</param>
        /// <returns></returns>
        public static Constraint ParseConstraint(this LambdaExpression expression)
        {
            QueryVisitor q = new QueryVisitor();
            var constraints = q.GetConstraints(expression);

            Constraint result = constraints.Count > 0 ? constraints[0] : new Constraint();
            //ExpressionParser parser = new ExpressionParser();
            //List<Constraint> constraints = parser.ProcessExpression(expression);

            //if (constraints.Count > 0)
            //    result = constraints[0];

            return result;
        }

        /// <summary>
        /// Determines whether the specified exp is constraint.
        /// </summary>
        /// <param name="exp">The exp.</param>
        /// <returns>
        /// 	<c>true</c> if the specified exp is constraint; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsConstraint(this Expression exp)
        {
            bool result = false;
            if(exp is BinaryExpression)
            {
                var binary = exp as BinaryExpression;
                Type binExpType = typeof(BinaryExpression);
                result = binary.Left.GetType() != binExpType && binary.Right.GetType() != binExpType;
            }
            return result;
        }

        /// <summary>
        /// Gets the constant value.
        /// </summary>
        /// <param name="exp">The exp.</param>
        /// <returns></returns>
        public static object GetConstantValue(this Expression exp)
        {
            object result = null;
            if(exp is ConstantExpression)
            {
                ConstantExpression c = (ConstantExpression)exp;
                result = c.Value;
            }
            return result;
        }
    }
}