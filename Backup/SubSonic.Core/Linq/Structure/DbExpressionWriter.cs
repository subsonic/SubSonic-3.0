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
using System.IO;

namespace SubSonic.Linq.Structure
{
    /// <summary>
    /// Writes out an expression tree (including DbExpression nodes) in a C#-ish syntax
    /// </summary>
    public class DbExpressionWriter : ExpressionWriter
    {
        Dictionary<TableAlias, int> aliasMap = new Dictionary<TableAlias, int>();

        protected DbExpressionWriter(TextWriter writer)
            : base(writer)
        {
        }

        public new static void Write(TextWriter writer, Expression expression)
        {
            new DbExpressionWriter(writer).Visit(expression);
        }

        public new static string WriteToString(Expression expression)
        {
            StringWriter sw = new StringWriter();
            Write(sw, expression);
            return sw.ToString();
        }

        protected override Expression Visit(Expression exp)
        {
            if (exp == null)
                return null;

            switch ((DbExpressionType)exp.NodeType)
            {
                case DbExpressionType.Projection:
                    return this.VisitProjection((ProjectionExpression)exp);
                case DbExpressionType.ClientJoin:
                    return this.VisitClientJoin((ClientJoinExpression)exp);
                case DbExpressionType.Select:
                    return this.VisitSelect((SelectExpression)exp);
                case DbExpressionType.OuterJoined:
                    return this.VisitOuterJoined((OuterJoinedExpression)exp);
                case DbExpressionType.Column:
                    return this.VisitColumn((ColumnExpression)exp);
                default:
                    if (exp is DbExpression)
                    {
                        this.Write(TSqlFormatter.Format(exp));
                        return exp;
                    }
                    else
                    {
                        return base.Visit(exp);
                    }
            }
        }

        protected void AddAlias(TableAlias alias)
        {
            if (!this.aliasMap.ContainsKey(alias))
            {
                this.aliasMap.Add(alias, this.aliasMap.Count);
            }
        }

        protected virtual Expression VisitProjection(ProjectionExpression projection)
        {
            this.AddAlias(projection.Source.Alias);
            this.Write("Project(");
            this.WriteLine(Indentation.Inner);
            this.Write("@\"");
            this.Visit(projection.Source);
            this.Write("\",");
            this.WriteLine(Indentation.Same);
            this.Visit(projection.Projector);
            this.Write(",");
            this.WriteLine(Indentation.Same);
            this.Visit(projection.Aggregator);
            this.WriteLine(Indentation.Outer);
            this.Write(")");
            return projection;
        }

        protected virtual Expression VisitClientJoin(ClientJoinExpression join)
        {
            this.AddAlias(join.Projection.Source.Alias);
            this.Write("ClientJoin(");
            this.WriteLine(Indentation.Inner);
            this.Write("OuterKey(");
            this.VisitExpressionList(join.OuterKey);
            this.Write("),");
            this.WriteLine(Indentation.Same);
            this.Write("InnerKey(");
            this.VisitExpressionList(join.InnerKey);
            this.Write("),");
            this.WriteLine(Indentation.Same);
            this.Visit(join.Projection);
            this.WriteLine(Indentation.Outer);
            this.Write(")");
            return join;
        }

        protected virtual Expression VisitOuterJoined(OuterJoinedExpression outer)
        {
            this.Write("Outer(");
            this.WriteLine(Indentation.Inner);
            this.Visit(outer.Test);
            this.Write(", ");
            this.WriteLine(Indentation.Same);
            this.Visit(outer.Expression);
            this.WriteLine(Indentation.Outer);
            this.Write(")");
            return outer;
        }

        protected virtual Expression VisitSelect(SelectExpression select)
        {
            this.Write(select.QueryText);
            return select;
        }

        protected virtual Expression VisitColumn(ColumnExpression column)
        {
            int iAlias;
            string aliasName = 
                this.aliasMap.TryGetValue(column.Alias, out iAlias)
                ? "A" + iAlias
                : "A?";

            this.Write(aliasName);
            this.Write(".");
            this.Write("Column(\"");
            this.Write(column.Name);
            this.Write("\")");
            return column;
        }
    }
}
 