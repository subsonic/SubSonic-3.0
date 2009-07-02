// Copyright (c) Microsoft Corporation.  All rights reserved.
// This source code is made available under the terms of the Microsoft Public License (MS-PL)
//Original code created by Matt Warren: http://iqtoolkit.codeplex.com/Release/ProjectReleases.aspx?ReleaseId=19725


using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace SubSonic.Linq.Structure
{
    /// <summary>
    /// Simple implementation of the IGrouping&lt;TKey, TElement&gt; interface
    /// </summary>
    /// <typeparam name="TKey"></typeparam>
    /// <typeparam name="TElement"></typeparam>
    public class Grouping<TKey, TElement> : IGrouping<TKey, TElement>
    {
        TKey key;
        IEnumerable<TElement> group;

        public Grouping(TKey key, IEnumerable<TElement> group)
        {
            this.key = key;
            this.group = group;
        }

        public TKey Key
        {
            get { return this.key; }
        }

        public IEnumerator<TElement> GetEnumerator()
        {
            return this.group.GetEnumerator();
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return this.group.GetEnumerator();
        }
    }   
}