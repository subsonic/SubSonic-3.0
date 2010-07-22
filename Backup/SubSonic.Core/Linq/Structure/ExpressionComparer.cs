// Copyright (c) Microsoft Corporation.  All rights reserved.
// This source code is made available under the terms of the Microsoft Public License (MS-PL)
//Original code created by Matt Warren: http://iqtoolkit.codeplex.com/Release/ProjectReleases.aspx?ReleaseId=19725

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using System.Text;

namespace SubSonic.Linq.Structure
{
    /// <summary>
    /// Compare two expressions to determine if they are equivalent
    /// </summary>
    public class ExpressionComparer
    {
        ScopedDictionary<ParameterExpression, ParameterExpression> parameterScope;

        protected ExpressionComparer(ScopedDictionary<ParameterExpression, ParameterExpression> parameterScope)
        {
            this.parameterScope = parameterScope;
        }

        public static bool AreEqual(Expression a, Expression b)
        {
            return AreEqual(null, a, b);
        }

        public static bool AreEqual(ScopedDictionary<ParameterExpression, ParameterExpression> parameterScope, Expression a, Expression b)
        {
            return new ExpressionComparer(parameterScope).Compare(a, b);
        }

        protected virtual bool Compare(Expression a, Expression b)
        {
            if (a == b)
                return true;
            if (a == null || b == null)
                return false;
            if (a.NodeType != b.NodeType)
                return false;
            if (a.Type != b.Type)
                return false;
            switch (a.NodeType)
            {
                case ExpressionType.Negate:
                case ExpressionType.NegateChecked:
                case ExpressionType.Not:
                case ExpressionType.Convert:
                case ExpressionType.ConvertChecked:
                case ExpressionType.ArrayLength:
                case ExpressionType.Quote:
                case ExpressionType.TypeAs:
                case ExpressionType.UnaryPlus:
                    return this.CompareUnary((UnaryExpression)a, (UnaryExpression)b);
                case ExpressionType.Add:
                case ExpressionType.AddChecked:
                case ExpressionType.Subtract:
                case ExpressionType.SubtractChecked:
                case ExpressionType.Multiply:
                case ExpressionType.MultiplyChecked:
                case ExpressionType.Divide:
                case ExpressionType.Modulo:
                case ExpressionType.And:
                case ExpressionType.AndAlso:
                case ExpressionType.Or:
                case ExpressionType.OrElse:
                case ExpressionType.LessThan:
                case ExpressionType.LessThanOrEqual:
                case ExpressionType.GreaterThan:
                case ExpressionType.GreaterThanOrEqual:
                case ExpressionType.Equal:
                case ExpressionType.NotEqual:
                case ExpressionType.Coalesce:
                case ExpressionType.ArrayIndex:
                case ExpressionType.RightShift:
                case ExpressionType.LeftShift:
                case ExpressionType.ExclusiveOr:
                case ExpressionType.Power:
                    return this.CompareBinary((BinaryExpression)a, (BinaryExpression)b);
                case ExpressionType.TypeIs:
                    return this.CompareTypeIs((TypeBinaryExpression)a, (TypeBinaryExpression)b);
                case ExpressionType.Conditional:
                    return this.CompareConditional((ConditionalExpression)a, (ConditionalExpression)b);
                case ExpressionType.Constant:
                    return this.CompareConstant((ConstantExpression)a, (ConstantExpression)b);
                case ExpressionType.Parameter:
                    return this.CompareParameter((ParameterExpression)a, (ParameterExpression)b);
                case ExpressionType.MemberAccess:
                    return this.CompareMemberAccess((MemberExpression)a, (MemberExpression)b);
                case ExpressionType.Call:
                    return this.CompareMethodCall((MethodCallExpression)a, (MethodCallExpression)b);
                case ExpressionType.Lambda:
                    return this.CompareLambda((LambdaExpression)a, (LambdaExpression)b);
                case ExpressionType.New:
                    return this.CompareNew((NewExpression)a, (NewExpression)b);
                case ExpressionType.NewArrayInit:
                case ExpressionType.NewArrayBounds:
                    return this.CompareNewArray((NewArrayExpression)a, (NewArrayExpression)b);
                case ExpressionType.Invoke:
                    return this.CompareInvocation((InvocationExpression)a, (InvocationExpression)b);
                case ExpressionType.MemberInit:
                    return this.CompareMemberInit((MemberInitExpression)a, (MemberInitExpression)b);
                case ExpressionType.ListInit:
                    return this.CompareListInit((ListInitExpression)a, (ListInitExpression)b);
                default:
                    throw new Exception(string.Format("Unhandled expression type: '{0}'", a.NodeType));
            }
        }

        protected virtual bool CompareUnary(UnaryExpression a, UnaryExpression b)
        {
            return a.NodeType == b.NodeType
                && a.Method == b.Method
                && a.IsLifted == b.IsLifted
                && a.IsLiftedToNull == b.IsLiftedToNull
                && this.Compare(a.Operand, b.Operand);
        }

        protected virtual bool CompareBinary(BinaryExpression a, BinaryExpression b)
        {
            return a.NodeType == b.NodeType
                && a.Method == b.Method
                && a.IsLifted == b.IsLifted
                && a.IsLiftedToNull == b.IsLiftedToNull
                && this.Compare(a.Left, b.Left)
                && this.Compare(a.Right, b.Right);
        }

        protected virtual bool CompareTypeIs(TypeBinaryExpression a, TypeBinaryExpression b)
        {
            return a.TypeOperand == b.TypeOperand
                && this.Compare(a.Expression, b.Expression);
        }

        protected virtual bool CompareConditional(ConditionalExpression a, ConditionalExpression b)
        {
            return this.Compare(a.Test, b.Test)
                && this.Compare(a.IfTrue, b.IfTrue)
                && this.Compare(a.IfFalse, b.IfFalse);
        }

        protected virtual bool CompareConstant(ConstantExpression a, ConstantExpression b)
        {
            return object.Equals(a.Value, b.Value);
        }

        protected virtual bool CompareParameter(ParameterExpression a, ParameterExpression b)
        {
            if (this.parameterScope != null)
            {
                ParameterExpression mapped;
                if (this.parameterScope.TryGetValue(a, out mapped))
                    return mapped == b;
            }
            return a == b;
        }

        protected virtual bool CompareMemberAccess(MemberExpression a, MemberExpression b)
        {
            return a.Member == b.Member
                && this.Compare(a.Expression, b.Expression);
        }

        protected virtual bool CompareMethodCall(MethodCallExpression a, MethodCallExpression b)
        {
            return a.Method == b.Method
                && this.Compare(a.Object, b.Object)
                && this.CompareExpressionList(a.Arguments, b.Arguments);
        }

        protected virtual bool CompareLambda(LambdaExpression a, LambdaExpression b)
        {
            int n = a.Parameters.Count;
            if (b.Parameters.Count != n)
                return false;
            // all must have same type
            for (int i = 0; i < n; i++)
            {
                if (a.Parameters[i].Type != b.Parameters[i].Type)
                    return false;
            }
            var save = this.parameterScope;
            this.parameterScope = new ScopedDictionary<ParameterExpression, ParameterExpression>(this.parameterScope);
            try
            {
                for (int i = 0; i < n; i++)
                {
                    this.parameterScope.Add(a.Parameters[i], b.Parameters[i]);
                }
                return this.Compare(a.Body, b.Body);
            }
            finally
            {
                this.parameterScope = save;
            }
        }

        protected virtual bool CompareNew(NewExpression a, NewExpression b)
        {
            return a.Constructor == b.Constructor
                && this.CompareExpressionList(a.Arguments, b.Arguments)
                && this.CompareMemberList(a.Members, b.Members);
        }

        protected virtual bool CompareExpressionList(ReadOnlyCollection<Expression> a, ReadOnlyCollection<Expression> b)
        {
            if (a == b)
                return true;
            if (a == null || b == null)
                return false;
            if (a.Count != b.Count)
                return false;
            for (int i = 0, n = a.Count; i < n; i++)
            {
                if (!this.Compare(a[i], b[i]))
                    return false;
            }
            return true;
        }

        protected virtual bool CompareMemberList(ReadOnlyCollection<MemberInfo> a, ReadOnlyCollection<MemberInfo> b)
        {
            if (a == b)
                return true;
            if (a == null || b == null)
                return false;
            if (a.Count != b.Count)
                return false;
            for (int i = 0, n = a.Count; i < n; i++)
            {
                if (a[i] != b[i])
                    return false;
            }
            return true;
        }

        protected virtual bool CompareNewArray(NewArrayExpression a, NewArrayExpression b)
        {
            return this.CompareExpressionList(a.Expressions, b.Expressions);
        }

        protected virtual bool CompareInvocation(InvocationExpression a, InvocationExpression b)
        {
            return this.Compare(a.Expression, b.Expression)
                && this.CompareExpressionList(a.Arguments, b.Arguments);
        }

        protected virtual bool CompareMemberInit(MemberInitExpression a, MemberInitExpression b)
        {
            return this.Compare(a.NewExpression, b.NewExpression)
                && this.CompareBindingList(a.Bindings, b.Bindings);
        }

        protected virtual bool CompareBindingList(ReadOnlyCollection<MemberBinding> a, ReadOnlyCollection<MemberBinding> b)
        {
            if (a == b)
                return true;
            if (a == null || b == null)
                return false;
            if (a.Count != b.Count)
                return false;
            for (int i = 0, n = a.Count; i < n; i++)
            {
                if (!this.CompareBinding(a[i], b[i]))
                    return false;
            }
            return true;
        }

        protected virtual bool CompareBinding(MemberBinding a, MemberBinding b)
        {
            if (a == b)
                return true;
            if (a == null || b == null)
                return false;
            if (a.BindingType != b.BindingType)
                return false;
            if (a.Member != b.Member)
                return false;
            switch (a.BindingType)
            {
                case MemberBindingType.Assignment:
                    return this.CompareMemberAssignment((MemberAssignment)a, (MemberAssignment)b);
                case MemberBindingType.ListBinding:
                    return this.CompareMemberListBinding((MemberListBinding)a, (MemberListBinding)b);
                case MemberBindingType.MemberBinding:
                    return this.CompareMemberMemberBinding((MemberMemberBinding)a, (MemberMemberBinding)b);
                default:
                    throw new Exception(string.Format("Unhandled binding type: '{0}'", a.BindingType));
            }
        }

        protected virtual bool CompareMemberAssignment(MemberAssignment a, MemberAssignment b)
        {
            return a.Member == b.Member
                && this.Compare(a.Expression, b.Expression);
        }

        protected virtual bool CompareMemberListBinding(MemberListBinding a, MemberListBinding b)
        {
            return a.Member == b.Member
                && this.CompareElementInitList(a.Initializers, b.Initializers);
        }

        protected virtual bool CompareMemberMemberBinding(MemberMemberBinding a, MemberMemberBinding b)
        {
            return a.Member == b.Member
                && this.CompareBindingList(a.Bindings, b.Bindings);
        }

        protected virtual bool CompareListInit(ListInitExpression a, ListInitExpression b)
        {
            return this.Compare(a.NewExpression, b.NewExpression)
                && this.CompareElementInitList(a.Initializers, b.Initializers);
        }

        protected virtual bool CompareElementInitList(ReadOnlyCollection<ElementInit> a, ReadOnlyCollection<ElementInit> b)
        {
            if (a == b)
                return true;
            if (a == null || b == null)
                return false;
            if (a.Count != b.Count)
                return false;
            for (int i = 0, n = a.Count; i < n; i++)
            {
                if (!this.CompareElementInit(a[i], b[i]))
                    return false;
            }
            return true;
        }

        protected virtual bool CompareElementInit(ElementInit a, ElementInit b)
        {
            return a.AddMethod == b.AddMethod
                && this.CompareExpressionList(a.Arguments, b.Arguments);
        }
    }
}