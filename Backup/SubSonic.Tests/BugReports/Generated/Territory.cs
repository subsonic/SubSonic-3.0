using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SouthWind
{
	/// <summary>
	/// Added to enable test Issue148_TestMode_Field_Should_Not_Be_Included_In_Query
	/// </summary>
	public partial class Territory
	{
		public Region Region
		{
			get { return Regions.FirstOrDefault(); }
		}
	}
}
