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
using System.Data;
using System.Data.Common;
using System.Text.RegularExpressions;
using SubSonic.Extensions;
using SubSonic.DataProviders;

namespace SubSonic.Query
{
	/// <summary>
	/// For Jeff Atwood
	/// http://www.codinghorror.com/blog/archives/000989.html
	/// </summary>
	/// <summary>
	/// A class which wraps an inline SQL call
	/// 
	/// Updated to support MySQL user and system variables.
	/// 
	///   If the connection string contains "Allow User Variables=true" and the provider 
	///   is MySQL, the following syntax is supported:
	///		
	///		@parametername - a command parameter
	///		@@uservariable - a MySQL user variable
	///		@@@servervariable - a MySQL server variable
	///		
	///  eg: UPDATE company SET next_job_id = @@job_id:=next_job_id+1 WHERE company_id=@company_id;
	///		 SELECT @@job_id;
	///		 
	///  where: @company_id is a command parameter.
	///			@@job_id is a MySql user variable.
	///
	///		
	/// </summary>
	public class CodingHorror : ISqlQuery
	{
		private readonly QueryCommand _command;
		private readonly IDataProvider _provider;

		/// <summary>
		/// Initializes a new instance of the <see cref="CodingHorror"/> class.
		/// Warning: This method assumes the default provider is intended.
		/// Call InlineQuery(string providerName) if this is not the case.
		/// </summary>
		/// <param name="sql">The SQL.</param>
		public CodingHorror(string sql)
		{
			_provider = ProviderFactory.GetProvider();
			_command = new QueryCommand(sql, _provider);
		}

		/// <summary>
		/// Initializes a new instance of the <see cref="CodingHorror"/> class.
		/// </summary>
		/// <param name="sql">The SQL.</param>
		/// <param name="values">The values.</param>
		public CodingHorror(string sql, params object[] values)
		{
			_provider = ProviderFactory.GetProvider();
			_command = new QueryCommand(sql, _provider);
			LoadCommandParams(_command, values);
		}

		/// <summary>
		/// Initializes a new instance of the <see cref="CodingHorror"/> class.
		/// </summary>
		/// <param name="provider">The provider.</param>
		public CodingHorror(IDataProvider provider)
		{
			_provider = provider;
		}

		public CodingHorror(IDataProvider provider, string sql, params object[] values)
		{
			_provider = provider;
			_command = new QueryCommand(sql, _provider);
			LoadCommandParams(_command, values);
		}

		public CodingHorror(IDataProvider provider, string sql)
		{
			_provider = provider;
			_command = new QueryCommand(sql, _provider);
		}


		#region ISqlQuery Members

		/// <summary>
		/// Gets the command.
		/// </summary>
		/// <returns></returns>
		public QueryCommand GetCommand()
		{
			return _command;
		}

		public string BuildSqlStatement()
		{
			return _command.CommandSql;
		}

		int ISqlQuery.Execute()
		{
			return _provider.ExecuteQuery(_command);
		}

		IDataReader ISqlQuery.ExecuteReader()
		{
			return _provider.ExecuteReader(_command);
		}

		#endregion


		/// <summary>
		/// Executes the specified SQL.
		/// </summary>
		public int Execute()
		{
			return _provider.ExecuteQuery(_command);
		}

		/// <summary>
		/// Executes the scalar.
		/// </summary>
		/// <typeparam name="TResult">The type of the result.</typeparam>
		/// <returns></returns>
		public TResult ExecuteScalar<TResult>()
		{
			TResult result = (TResult)_provider.ExecuteScalar(_command).ChangeTypeTo<TResult>();
			return result;
		}

		/// <summary>
		/// Executes the typed list.
		/// </summary>
		/// <typeparam name="T"></typeparam>
		/// <returns></returns>
		public List<T> ExecuteTypedList<T>() where T : new()
		{
			return _provider.ToList<T>(_command) as List<T>;
		}

		/// <summary>
		/// Executes the reader.
		/// </summary>
		/// <returns></returns>
		public DbDataReader ExecuteReader()
		{
			return _provider.ExecuteReader(_command);
		}

		void LoadCommandParams(QueryCommand cmd, object[] values)
		{
			//load up the params
			List<string> paramList;
			if (SupportMySqlUserVariables)
			{
				cmd.CommandSql = ConvertMySqlParametersAndVariables(cmd.CommandSql);
                // altered this so only supports MySql "?" parameters
                paramList = ParseParameters(cmd.CommandSql, new Regex(@"\?\w*"));
			}
			else
			{
                //bferrier altered this so Inline Query works with Oracle
                paramList = ParseParameters(cmd.CommandSql, new Regex(@"@\w*|:\w*"));
			}

			//validate it
			if (paramList.Count != values.Length)
			{
				throw new InvalidOperationException(
					"The parameter count doesn't match up with the values entered - this could be our fault with our parser; please check the list to make sure the count adds up, and if it does, please add some spacing around the parameters in the list");
			}

			for (int i = 0; i < paramList.Count; i++)
			{
				var dbType = Database.GetDbType(values[i].GetType());
				cmd.Parameters.Add(paramList[i], values[i], dbType);
			}
		}

		private static List<string> ParseParameters(string sql, Regex paramRegex)
		{
            MatchCollection matches = paramRegex.Matches(String.Concat(sql, " "));
			List<string> result = new List<string>(matches.Count);
            
            foreach (Match m in matches)
            {
                if (!result.Contains(m.Value))
                {
                    result.Add(m.Value);
                }
            }

			return result;
		}

		internal bool SupportMySqlUserVariables
		{
			get
			{
				return _provider.ConnectionString.IndexOf("Allow User Variables=true") >= 0 &&
						string.Compare(_provider.Name, "MySql.Data.MySqlClient", true) == 0;
			}
		}

		// Supports a syntax of @parameter, @@uservar and @@@systemvar
		static string ConvertMySqlParametersAndVariables(string sql)
		{
			// Convert "@parameter" -> "?parameter"
			Regex paramReg = new Regex(@"(?<!@)@\w+");
			sql = paramReg.Replace(sql, m => "?" + m.Value.Substring(1));

			// Convert @@uservar -> @uservar and @@@systemvar -> @@systemvar
			sql = sql.Replace("@@", "@");

			return sql;
		}

	}

    public class InlineQuery : CodingHorror {
        /// <summary>
		/// Initializes a new instance of the <see cref="InlineQuery"/> class.
		/// Warning: This method assumes the default provider is intended.
		/// Call InlineQuery(string providerName) if this is not the case.
		/// </summary>
		/// <param name="sql">The SQL.</param>
		public InlineQuery(string sql) : base(sql)
		{}

		/// <summary>
		/// Initializes a new instance of the <see cref="InlineQuery"/> class.
		/// </summary>
		/// <param name="sql">The SQL.</param>
		/// <param name="values">The values.</param>
		public InlineQuery(string sql, params object[] values) : base(sql, values)
		{}

		/// <summary>
		/// Initializes a new instance of the <see cref="InlineQuery"/> class.
		/// </summary>
		/// <param name="provider">The provider.</param>
		public InlineQuery(IDataProvider provider) : base(provider)
		{}

		public InlineQuery(IDataProvider provider, string sql, params object[] values) : base(provider, sql, values)
		{}

        public InlineQuery(IDataProvider provider, string sql) : base(provider, sql)
		{}
    }
}
