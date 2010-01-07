// Copyright (c) Microsoft Corporation.  All rights reserved.
// This source code is made available under the terms of the Microsoft Public License (MS-PL)
//Original code created by Matt Warren: http://iqtoolkit.codeplex.com/Release/ProjectReleases.aspx?ReleaseId=19725


using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data.Common;

namespace SubSonic.Linq.Structure
{
    public class QueryCommand<T>
    {
		public QueryCommand(string commandText, IEnumerable<string> paramNames, Func<DbDataReader, T> projector, List<string> ColumnNames)//mike ColumnNames added to support project
        {
            CommandText = commandText;
            ParameterNames = new List<string>(paramNames).AsReadOnly();
            Projector = projector;
			this.ColumnNames = ColumnNames;//mike added to support project
        }

        public string CommandText { get; private set; }
		public List<string> ColumnNames = new List<string>();//mike added to support project
        public ReadOnlyCollection<string> ParameterNames { get; private set; }

        public Func<DbDataReader, T> Projector { get; private set; }
    }
}
