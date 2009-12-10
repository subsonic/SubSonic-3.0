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
using System.Linq;
using System.Linq.Expressions;
using SubSonic.Linq.Structure;
using SubSonic.Query;

namespace SubSonic.Extensions
{
    public class QueryVisitor : ExpressionVisitor
    {
        private List<Constraint> constraints;
        private Constraint current;
        private bool expressionOpen = false;
        private bool isLeft = false;
        private SqlQuery query;

        public IList<Constraint> GetConstraints(Expression ex)
        {
            constraints = new List<Constraint>();
            current = new Constraint();
            query = new SqlQuery();
            var expression = Visit(ex);
            return query.Constraints;
        }

        protected override Expression Visit(Expression exp)
        {
            if(exp != null)
                return base.Visit(exp);

            return exp;
        }

        protected override Expression VisitConstant(ConstantExpression c)
        {
            if(!isLeft)
                current.ParameterValue = c.Value;
            else
            {
                current.ParameterName = c.Value.ToString();
                current.ColumnName = c.Value.ToString();
            }

            return base.VisitConstant(c);
        }

        private static Expression Evaluate(Expression e)
        {
            if(e.NodeType == ExpressionType.Constant)
                return e;
            Type type = e.Type;
            if(type.IsValueType)
                e = Expression.Convert(e, typeof(object));
            Expression<Func<object>> lambda = Expression.Lambda<Func<object>>(e);
            Func<object> fn = lambda.Compile();
            return Expression.Constant(fn(), type);
        }

        protected override Expression VisitMemberAccess(MemberExpression m)
        {
            if(isLeft)
            {
                current.ColumnName = m.Member.Name;
                current.ParameterName = m.Member.Name;
                current.ConstructionFragment = m.Member.Name;
                return m;
            }
            else
            {
                var eval = (ConstantExpression)Evaluate(m);
                current.ParameterValue = eval.Value;
                return eval;
            }
        }

        protected override Expression VisitUnary(UnaryExpression u)
        {
            if (u.NodeType == ExpressionType.Not)
            {
                //this is a "!" not operator, which is akin to saying "member.name == false"
                //so we'll switch it up
                var member = u.Operand as MemberExpression;
                if(member != null)
                {
                    current.ParameterName = member.Member.Name;
                    current.ColumnName += member.Member.Name;
                    current.ConstructionFragment += member.Member.Name;
                    current.ParameterValue = false;
                    AddConstraint();
                }
            }
            return base.VisitUnary(u);
        }

        private void AddConstraint()
        {
            if(!query.Constraints.Any(x => x.ParameterName == current.ParameterName && x.ParameterValue == current.ParameterValue))
                query.Constraints.Add(current);
        }

        protected override Expression VisitBinary(BinaryExpression b)
        {
            b = ConvertVbCompareString(b);

            current = new Constraint();

            if(b.NodeType == ExpressionType.AndAlso)
            {
                if(query.Constraints.Count > 0)
                    current.Condition = ConstraintType.And;
            }
            else if(b.NodeType == ExpressionType.OrElse || b.NodeType == ExpressionType.Or)
            {
                if(query.Constraints.Count > 0)
                    current.Condition = ConstraintType.Or;
            }
            else if(b.NodeType == ExpressionType.AndAlso) {}
            else if(b.NodeType == ExpressionType.Or || b.NodeType == ExpressionType.OrElse)
            {
                if(query.Constraints.Count > 0)
                    current.Condition = ConstraintType.Or;
            }
            else if(b.NodeType == ExpressionType.NotEqual)
                current.Comparison = Comparison.NotEquals;
            else if(b.NodeType == ExpressionType.Equal)
                current.Comparison = Comparison.Equals;
            else if(b.NodeType == ExpressionType.GreaterThan)
                current.Comparison = Comparison.GreaterThan;
            else if(b.NodeType == ExpressionType.GreaterThanOrEqual)
                current.Comparison = Comparison.GreaterOrEquals;
            else if(b.NodeType == ExpressionType.LessThan)
                current.Comparison = Comparison.LessThan;
            else if(b.NodeType == ExpressionType.Not)
                Visit(b);
            else if(b.NodeType == ExpressionType.LessThanOrEqual)
                current.Comparison = Comparison.LessOrEquals;

            isLeft = true;
            Expression left = Visit(b.Left);
            isLeft = false;
            Expression right = Visit(b.Right);
            Expression conversion = Visit(b.Conversion);

            if(b.NodeType == ExpressionType.AndAlso)
            {
                if(query.Constraints.Count > 0)
                    current.Condition = ConstraintType.And;
            }
            else if(b.NodeType == ExpressionType.OrElse || b.NodeType == ExpressionType.Or)
            {
                if(query.Constraints.Count > 0)
                    current.Condition = ConstraintType.Or;
            }
            //else if (b.NodeType == ExpressionType.NotEqual && current.ParameterValue == null)
            //    current.Comparison = Comparison.IsNot;
            //else if (b.NodeType == ExpressionType.Equal && current.ParameterValue == null)
            //    current.Comparison = Comparison.Is;

            //query.OpenExpression();
            AddConstraint();
            //query.CloseExpression();
            //if (expressionOpen) {
            //    query.CloseExpression();
            //    expressionOpen = false;
            //}

            if (left != b.Left || right != b.Right || conversion != b.Conversion)
            {
                if(b.NodeType == ExpressionType.Coalesce && b.Conversion != null)
                    return Expression.Coalesce(left, right, conversion as LambdaExpression);
                return Expression.MakeBinary(b.NodeType, left, right, b.IsLiftedToNull, b.Method);
            }
            return b;
        }
    }
}