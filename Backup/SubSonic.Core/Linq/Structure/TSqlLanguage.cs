// Copyright (c) Microsoft Corporation.  All rights reserved.
// This source code is made available under the terms of the Microsoft Public License (MS-PL)
//Original code created by Matt Warren: http://iqtoolkit.codeplex.com/Release/ProjectReleases.aspx?ReleaseId=19725

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data.Common;
using System.Data.SqlClient;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using System.Text;
using SubSonic.DataProviders;
using SubSonic.Linq.Translation;

namespace SubSonic.Linq.Structure
{
    /// <summary>
    /// TSQL specific QueryLanguage
    /// </summary>
    public class TSqlLanguage : QueryLanguage
    {
        public TSqlLanguage(IDataProvider provider) : base(provider) {}

        private SqlCommandBuilder cb = new SqlCommandBuilder();

        public override string Quote(string name)
        {
            return cb.QuoteIdentifier(name);
        }

        public override Expression Translate(Expression expression)
        {
            // fix up any order-by's
            expression = OrderByRewriter.Rewrite(expression);

            expression = base.Translate(expression);

            // convert skip/take info into RowNumber pattern
            expression = SkipRewriter.Rewrite(expression);

            // fix up any order-by's we may have changed
            expression = OrderByRewriter.Rewrite(expression);

            return expression;
        }

        public override string Format(Expression expression)
        {
            return TSqlFormatter.Format(expression);
        }
    }
}