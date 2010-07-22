// Copyright (c) Microsoft Corporation.  All rights reserved.
// This source code is made available under the terms of the Microsoft Public License (MS-PL)
//Original code created by Matt Warren: http://iqtoolkit.codeplex.com/Release/ProjectReleases.aspx?ReleaseId=19725


using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using SubSonic.Linq.Structure;

namespace SubSonic.Linq.Translation
{
    /// <summary>
    /// Result from calling ColumnProjector.ProjectColumns
    /// </summary>
    public sealed class ProjectedColumns
    {
        Expression projector;
        ReadOnlyCollection<ColumnDeclaration> columns;

        public ProjectedColumns(Expression projector, ReadOnlyCollection<ColumnDeclaration> columns)
        {
            this.projector = projector;
            this.columns = columns;
        }

        public Expression Projector
        {
            get { return this.projector; }
        }

        public ReadOnlyCollection<ColumnDeclaration> Columns
        {
            get { return this.columns; }
        }
    }

    /// <summary>
    /// Splits an expression into two parts
    ///   1) a list of column declarations for sub-expressions that must be evaluated on the server
    ///   2) a expression that describes how to combine/project the columns back together into the correct result
    /// </summary>
    public class ColumnProjector : DbExpressionVisitor
    {
        Dictionary<ColumnExpression, ColumnExpression> map;
        List<ColumnDeclaration> columns;
        HashSet<string> columnNames;
        HashSet<Expression> candidates;
        HashSet<TableAlias> existingAliases;
        TableAlias newAlias;
        int iColumn;

        private ColumnProjector(Func<Expression, bool> fnCanBeColumn, Expression expression, IEnumerable<ColumnDeclaration> existingColumns, TableAlias newAlias, IEnumerable<TableAlias> existingAliases)
        {
            this.newAlias = newAlias;
            this.existingAliases = new HashSet<TableAlias>(existingAliases);
            this.map = new Dictionary<ColumnExpression, ColumnExpression>();
            if (existingColumns != null)
            {
                this.columns = new List<ColumnDeclaration>(existingColumns);
                this.columnNames = new HashSet<string>(existingColumns.Select(c => c.Name));
            }
            else
            {
                this.columns = new List<ColumnDeclaration>();
                this.columnNames = new HashSet<string>();
            }
            this.candidates = Nominator.Nominate(fnCanBeColumn, expression);
        }

        public static ProjectedColumns ProjectColumns(Func<Expression, bool> fnCanBeColumn, Expression expression, IEnumerable<ColumnDeclaration> existingColumns, TableAlias newAlias, IEnumerable<TableAlias> existingAliases)
        {
            ColumnProjector projector = new ColumnProjector(fnCanBeColumn, expression, existingColumns, newAlias, existingAliases);
            Expression expr = projector.Visit(expression);
            return new ProjectedColumns(expr, projector.columns.AsReadOnly());
        }

        public static ProjectedColumns ProjectColumns(Func<Expression, bool> fnCanBeColumn, Expression expression, IEnumerable<ColumnDeclaration> existingColumns, TableAlias newAlias, params TableAlias[] existingAliases)
        {
            return ProjectColumns(fnCanBeColumn, expression, existingColumns, newAlias, (IEnumerable<TableAlias>)existingAliases);
        }

        protected override Expression Visit(Expression expression)
        {
            if (this.candidates.Contains(expression))
            {
                if (expression.NodeType == (ExpressionType)DbExpressionType.Column)
                {
                    ColumnExpression column = (ColumnExpression)expression;
                    ColumnExpression mapped;
                    if (this.map.TryGetValue(column, out mapped))
                    {
                        return mapped;
                    }
                    // check for column that already refers to this column
                    foreach (ColumnDeclaration existingColumn in this.columns)
                    {
                        ColumnExpression cex = existingColumn.Expression as ColumnExpression;
                        if (cex != null && cex.Alias == column.Alias && cex.Name == column.Name)
                        {
                            // refer to the column already in the column list
                            return new ColumnExpression(column.Type, this.newAlias, existingColumn.Name);
                        }
                    }
                    if (this.existingAliases.Contains(column.Alias)) 
                    {
                        int ordinal = this.columns.Count;
                        string columnName = this.GetUniqueColumnName(column.Name);
                        this.columns.Add(new ColumnDeclaration(columnName, column));
                        mapped = new ColumnExpression(column.Type, this.newAlias, columnName);
                        this.map.Add(column, mapped);
                        this.columnNames.Add(columnName);
                        return mapped;
                    }
                    // must be referring to outer scope
                    return column;
                }
                else
                {
                    string columnName = this.GetNextColumnName();
                    this.columns.Add(new ColumnDeclaration(columnName, expression));
                    return new ColumnExpression(expression.Type, this.newAlias, columnName);
                }
            }
            else
            {
                return base.Visit(expression);
            }
        }

        private bool IsColumnNameInUse(string name)
        {
            return this.columnNames.Contains(name);
        }

        private string GetUniqueColumnName(string name)
        {
            string baseName = name;
            int suffix = 1;
            while (this.IsColumnNameInUse(name))
            {
                name = baseName + (suffix++);
            }
            return name;
        }

        private string GetNextColumnName()
        {
            return this.GetUniqueColumnName("c" + (iColumn++));
        }

        /// <summary>
        /// Nominator is a class that walks an expression tree bottom up, determining the set of 
        /// candidate expressions that are possible columns of a select expression
        /// </summary>
        class Nominator : DbExpressionVisitor
        {
            Func<Expression, bool> fnCanBeColumn;
            bool isBlocked;
            HashSet<Expression> candidates;

            private Nominator(Func<Expression, bool> fnCanBeColumn)
            {
                this.fnCanBeColumn = fnCanBeColumn;
                this.candidates = new HashSet<Expression>();
                this.isBlocked = false;
            }

            internal static HashSet<Expression> Nominate(Func<Expression, bool> fnCanBeColumn, Expression expression)
            {
                Nominator nominator = new Nominator(fnCanBeColumn);
                nominator.Visit(expression);
                return nominator.candidates;
            }

            protected override Expression Visit(Expression expression)
            {
                if (expression != null)
                {
                    bool saveIsBlocked = this.isBlocked;
                    this.isBlocked = false;
                    if (expression.NodeType != (ExpressionType)DbExpressionType.Scalar)
                    {
                        base.Visit(expression);
                    }
                    if (!this.isBlocked)
                    {
                        if (this.fnCanBeColumn(expression))
                        {
                            this.candidates.Add(expression);
                        }
                        else
                        {
                            this.isBlocked = true;
                        }
                    }
                    this.isBlocked |= saveIsBlocked;
                }
                return expression;
            }
        }
    }
}
