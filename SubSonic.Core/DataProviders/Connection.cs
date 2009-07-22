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
using System.Data.Common;

namespace SubSonic.DataProviders
{
    // Big thanks to Brenton Webster for the code contained herein...

    /// <summary>
    /// Indicates that a per-thread shared DbConnection object should be used the default DataProvider
    /// (or alternativley a specific DataProvider if one is given) when communicating with the database.
    /// This class is designed to be used within a using () {} block and in conjunction with a TransactionScope object.
    /// It's purpose is to force a common DbConnection object to be used which has the effect of avoiding promotion
    /// of a System.Transaction ambient Transaction to the DTC where possible.
    /// When this class is created, it indicates to the underlying DataProvider that is should use a shared DbConnection
    /// for subsequent operations. When the class is disposed (ie the using() {} block ends) it will indicate to the
    /// underlying provider that it should no longer it's current shared connection and should Dispose() it.
    /// </summary>
    public class SharedDbConnectionScope : IDisposable
    {
        /// <summary>
        /// Used to support nesting. By keeping a stack of all instances of the class that are created on this thread
        /// thread we know when it is safe to Reset the underlying shared connection.
        /// </summary>
        [ThreadStatic]
        private static Stack<SharedDbConnectionScope> __instances;

        private readonly IDataProvider _dataProvider;
        private bool _disposed;

        /// <summary>
        /// Indicates to the default DataProvider that it should use a per-thread shared connection.
        /// </summary>
        public SharedDbConnectionScope() : this(ProviderFactory.GetProvider()) {}

        /// <summary>
        /// Indicates to the default DataProvider that it should use a per-thread shared connection using the given connection string.
        /// </summary>
        /// <param name="connectionString">The connection string.</param>
        /// <param name="providerName">Name of the provider.</param>
        public SharedDbConnectionScope(string connectionString, string providerName)
            : this(ProviderFactory.GetProvider(connectionString, providerName))
        {
        }

        /// <summary>
        /// Indicates to the specified DataProvider that it should use a per-thread shared connection.
        /// </summary>
        /// <param name="dataProvider">The data provider.</param>
        public SharedDbConnectionScope(IDataProvider dataProvider)
        {
            if(dataProvider == null)
                throw new ArgumentNullException("dataProvider");

            _dataProvider = dataProvider;
            _dataProvider.InitializeSharedConnection();

            if(__instances == null)
                __instances = new Stack<SharedDbConnectionScope>();
            __instances.Push(this);
        }



        /// <summary>
        /// Provides access to underlying connection that is shared per thread
        /// </summary>
        /// <value>The current connection.</value>
        public DbConnection CurrentConnection
        {
            get { return _dataProvider.CurrentSharedConnection; }
        }


        #region IDisposable Members

        /// <summary>
        /// Performs application-defined tasks associated with freeing, releasing, or resetting unmanaged resources.
        /// </summary>
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        #endregion


        /// <summary>
        /// Releases unmanaged and - optionally - managed resources
        /// </summary>
        /// <param name="disposing"><c>true</c> to release both managed and unmanaged resources; <c>false</c> to release only unmanaged resources.</param>
        public void Dispose(bool disposing)
        {
            if(!_disposed)
            {
                if(disposing)
                {
                    // remove this instance from the stack
                    __instances.Pop();

                    // if we are the last instance, reset the connection
                    if(__instances.Count == 0)
                        _dataProvider.ResetSharedConnection();

                    _disposed = true;
                }
            }
        }
    }

    /// <summary>
    /// Used within SubSonic to automatically manage a SqlConnection. If a shared connection is available
    /// for the specified provider on the current thread, that shared connection will be used.
    /// Otherwise, a new connection will be created.
    /// Note that if a shared connection is used, it will NOT be automatically disposed - that is up to the caller.
    /// Lifetime management of the shared connection is taken care of by using a <see cref="SharedDbConnectionScope"/>
    /// If a new connection is created, it will be automatically disposed when this AutomaticConnectionScope object
    /// is disposed.
    /// </summary>
    public class AutomaticConnectionScope : IDisposable
    {
        private readonly DbConnection _dbConnection;
        private readonly bool _isUsingSharedConnection;
        private bool _disposed;

        /// <summary>
        /// Initializes a new instance of the <see cref="AutomaticConnectionScope"/> class.
        /// </summary>
        /// <param name="provider">The provider.</param>
        public AutomaticConnectionScope(IDataProvider provider)
        {
            if(provider == null)
                throw new ArgumentNullException("provider");

            if(provider.CurrentSharedConnection != null)
            {
                _dbConnection = provider.CurrentSharedConnection;
                _isUsingSharedConnection = true;
            }
            else
                _dbConnection = provider.CreateConnection();
        }

        /// <summary>
        /// Gets the connection.
        /// </summary>
        /// <value>The connection.</value>
        public DbConnection Connection
        {
            get { return _dbConnection; }
        }

        /// <summary>
        /// Gets a value indicating whether this instance is using shared connection.
        /// </summary>
        /// <value>
        /// 	<c>true</c> if this instance is using shared connection; otherwise, <c>false</c>.
        /// </value>
        public bool IsUsingSharedConnection
        {
            get { return _isUsingSharedConnection; }
        }


        #region IDisposable Members

        /// <summary>
        /// Performs application-defined tasks associated with freeing, releasing, or resetting unmanaged resources.
        /// </summary>
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        #endregion


        /// <summary>
        /// Releases unmanaged and - optionally - managed resources
        /// </summary>
        /// <param name="disposing"><c>true</c> to release both managed and unmanaged resources; <c>false</c> to release only unmanaged resources.</param>
        public void Dispose(bool disposing)
        {
            if(!_disposed)
            {
                if(disposing)
                {
                    // only dispose the connection if it is not a shared one
                    if(!_isUsingSharedConnection)
                        _dbConnection.Dispose();
                    _disposed = true;
                }
            }
        }

        /// <summary>
        /// Gets the connection.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public T GetConnection<T>() where T : DbConnection
        {
            return (T)Connection;
        }
    }
}