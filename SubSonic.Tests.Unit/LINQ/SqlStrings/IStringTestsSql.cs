
namespace SubSonic.Tests.Unit.Linq.SqlStrings
{
	public interface IStringTestsSql
	{
		string String_CompareEQ { get; }
		string String_CompareGE { get; }
		string String_CompareGT { get; }
		string String_CompareLE { get; }
		string String_CompareLT { get; }
		string String_CompareNE { get; }
		string String_CompareToEQ { get; }
		string String_CompareToGE { get; }
		string String_CompareToGT { get; }
		string String_CompareToLE { get; }
		string String_CompareToLT { get; }
		string String_CompareToNE { get; }
		string String_IndexOf { get; }
		string String_IndexOfChar { get; }
		string String_IsNullOrEmpty { get; }
		string String_Replace { get; }
		string String_ReplaceChars { get; }
		string String_Substring { get; }
		string String_ToLower { get; }
		string String_ToString { get; }
		string String_ToUpper { get; }
		string String_Trim { get; }
	}
}
