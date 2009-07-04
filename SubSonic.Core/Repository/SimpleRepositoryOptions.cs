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

namespace SubSonic.Repository
{
	[Flags]
	public enum SimpleRepositoryOptions
	{
		/// <summary>
		/// An enumeration value for no options configured.
		/// </summary>
		None = 0,

		/// <summary>
		/// The default set of options (right now the same as none).
		/// </summary>
		Default = 0,

		/// <summary>
		/// Use this flag to let the repository run migrations.
		/// </summary>
		RunMigrations = 1
	}
}