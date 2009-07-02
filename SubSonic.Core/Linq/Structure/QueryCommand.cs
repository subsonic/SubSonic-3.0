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
        public QueryCommand(string commandText, IEnumerable<string> paramNames, Func<DbDataReader, T> projector)
        {
            CommandText = commandText;
            ParameterNames = new List<string>(paramNames).AsReadOnly();
            Projector = projector;
        }

        public string CommandText { get; private set; }

        public ReadOnlyCollection<string> ParameterNames { get; private set; }

        public Func<DbDataReader, T> Projector { get; private set; }
    }
}
