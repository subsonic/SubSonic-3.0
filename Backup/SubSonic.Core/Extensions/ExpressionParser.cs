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
using System.Reflection;
using SubSonic.Query;

namespace SubSonic.Extensions
{
    public class ExpressionParser
    {
        private const string contains = "Contains";
        private const string endsWith = "EndsWith";
        private const string nullableType = "Nullable`1";
        private const string op_Equality = "op_Equality";
        private const string op_GreaterThan = "op_GreaterThan";
        private const string op_GreaterThanOrEqual = "op_GreaterThanOrEqual";
        private const string op_LessThan = "op_LessThan";
        private const string op_LessThanOrEqual = "op_LessThanOrEqual";
        private const string startsWith = "StartsWith";
        private readonly List<Constraint> result;

        public ExpressionParser()
        {
            result = new List<Constraint>();
        }


        #region Process expressions

        /// <summary>
        /// Process the passed-in LINQ expression
        /// </summary>
        /// <param name="expression"></param>
        public List<Constraint> ProcessExpression(Expression expression)
        {
            if(expression.NodeType == ExpressionType.AndAlso)
                ProcessAndAlso((BinaryExpression)expression);
            else if(expression.NodeType == ExpressionType.NotEqual)
                BuildFromBinary(expression, Comparison.NotEquals);
            else if(expression.NodeType == ExpressionType.Equal)
                BuildFromBinary(expression, Comparison.Equals);
            else if(expression.NodeType == ExpressionType.GreaterThan)
                BuildFromBinary(expression, Comparison.GreaterThan);
            else if(expression.NodeType == ExpressionType.GreaterThanOrEqual)
                BuildFromBinary(expression, Comparison.LessOrEquals);
            else if(expression.NodeType == ExpressionType.LessThan)
                BuildFromBinary(expression, Comparison.LessThan);
            else if(expression.NodeType == ExpressionType.LessThanOrEqual)
                BuildFromBinary(expression, Comparison.LessOrEquals);
            else if(expression is MethodCallExpression)
                ProcessMethodCall((MethodCallExpression)expression);
            else if(expression is LambdaExpression)
                ProcessExpression(((LambdaExpression)expression).Body);
            //else if (expression is MethodCallExpression)
            //    ProcessMethodCall(expression as MethodCallExpression);
            return result;
        }

        private void ProcessAndAlso(BinaryExpression andAlso)
        {
            ProcessExpression(andAlso.Left);
            ProcessExpression(andAlso.Right);
        }

        private void AddConstraint(string columnName, Comparison comp, object value)
        {
            Constraint c = new Constraint(ConstraintType.Where, columnName);

            if(result.Count > 1)
                c = new Constraint(ConstraintType.And, columnName);

            //c.ParameterName = columnName;

            if(comp == Comparison.StartsWith)
            {
                value = string.Format("{0}%", value);
                comp = Comparison.Like;
            }
            else if(comp == Comparison.EndsWith)
            {
                value = string.Format("%{0}", value);
                comp = Comparison.Like;
            }

            c.Comparison = comp;
            c.ParameterValue = value;

            result.Add(c);
        }

        private void BuildFromBinary(Expression exp, Comparison op)
        {

            BinaryExpression expression = exp as BinaryExpression;

            if (expression != null)
            {
                //make sure the left side is a Member, and the right is a constant value
                if(expression.Left is MemberExpression && expression.Right is ConstantExpression)
                {
                    //the member - "Title", "Publisher", etc
                    MemberExpression memb = expression.Left as MemberExpression;
                    //the setting
                    ConstantExpression val = expression.Right as ConstantExpression;
                    AddConstraint(memb.Member.Name, op, val.Value);
                }
                    //or the left side is a Member, and the right is a conversion from a constant value to a nullable
                else if(expression.Left is MemberExpression && expression.Right.NodeType == ExpressionType.Convert
                        && expression.Right.Type.Name.Equals(nullableType))
                {
                    //the member - "Title", "Publisher", etc
                    MemberExpression memb = expression.Left as MemberExpression;
                    //the auto-conversion-to-nullable
                    UnaryExpression convert = expression.Right as UnaryExpression;
                    //the setting
                    if (convert != null)
                    {
                        ConstantExpression val = convert.Operand as ConstantExpression;
                        if(val != null)
                            AddConstraint(memb.Member.Name, op, val.Value);
                    }
                }
                    //if this isn't the case, it's Unary and is an enum setting
                else if(expression.Left.NodeType == ExpressionType.MemberAccess)
                {
                    MemberExpression left = expression.Left as MemberExpression;
                    MemberExpression right = expression.Right as MemberExpression;

                    if (right != null)
                    {
                        if (right.Expression.NodeType == ExpressionType.Constant)
                        {
                            ConstantExpression val = right.Expression as ConstantExpression;
                            if(val != null && left != null)
                            {
                                Type t = val.Value.GetType();
                                FieldInfo[] fields = t.GetFields();
                                object oVal = fields[0].GetValue(val.Value);
                                AddConstraint(left.Member.Name, op, oVal);
                            }
                        }
                        else if (right.Expression.NodeType == ExpressionType.MemberAccess)
                        {
                            //this is screwed
                            MemberExpression val = right.Expression as MemberExpression;
                            //object expressionValue = EvaluateExpression(val.Expression);
                            //expressionValue.GetType().InvokeMember(val.Member.Name, global, global, expressionValue) ;

                            var t = right.Member.MemberType;

                            //this should be a property
                            //PropertyInfo p = (PropertyInfo)t.GetProperties()[0].GetValue(right.Member, null);
                            //oVal = p.GetValue(val.Member, null);
                        }
                    }
                }
            }
        }

        private void BuildFromMemberAccess(Expression exp, Comparison op)
        {
            MethodCallExpression expression = exp as MethodCallExpression;

            if (expression != null)
            {
                if(expression.Arguments[0].NodeType == ExpressionType.MemberAccess)
                {
                    MemberExpression memberExpr = (MemberExpression)expression.Arguments[0];
                    if(expression.Arguments[1].NodeType == ExpressionType.Constant)
                    {
                        ConstantExpression val = (ConstantExpression)expression.Arguments[1];
                        AddConstraint(memberExpr.Member.Name, op, val.Value);
                    }
                }
                else if(expression.Arguments[0].NodeType == ExpressionType.Constant)
                {
                    ConstantExpression val = (ConstantExpression)expression.Arguments[0];
                    MemberExpression memberExpr = (MemberExpression)expression.Object;
                    AddConstraint(memberExpr.Member.Name, op, val.Value);
                }
            }
        }

        private void ProcessMethodCall(MethodCallExpression expression)
        {
            switch(expression.Method.Name)
            {
                case op_Equality:
                    // Handle book.Publisher == "xxx"
                    BuildFromMemberAccess(expression, Comparison.Equals);
                    break;
                case op_GreaterThan:
                    // Handle book.Price <= xxx
                    BuildFromMemberAccess(expression, Comparison.GreaterThan);
                    break;
                case op_LessThan:
                    // Handle book.Price <= xxx
                    BuildFromMemberAccess(expression, Comparison.LessThan);
                    break;
                case op_LessThanOrEqual:
                    // Handle book.Price <= xxx
                    BuildFromMemberAccess(expression, Comparison.LessOrEquals);
                    break;
                case op_GreaterThanOrEqual:
                    // Handle book.Price <= xxx
                    BuildFromMemberAccess(expression, Comparison.GreaterOrEquals);
                    break;
                case contains:
                    BuildFromMemberAccess(expression, Comparison.Like);
                    break;
                case startsWith:
                    BuildFromMemberAccess(expression, Comparison.StartsWith);
                    break;
                case endsWith:
                    // Handle book.Title.Contains("xxx")
                    BuildFromMemberAccess(expression, Comparison.EndsWith);
                    break;
            }
        }

        #endregion Process expressions
    }
}