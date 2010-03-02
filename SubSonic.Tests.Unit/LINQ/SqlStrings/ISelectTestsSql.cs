
namespace SubSonic.Tests.Unit.Linq.SqlStrings
{
	public interface ISelectTestsSql
	 {
		
		 string All_With_SubQuery{ get; }
		
		
		
		 string Any_With_Collection{ get; }
		
		

		
		 string Any_With_Collection_One_False{ get; }
		
		

		
		 string Contains_Resolves_Literal{ get; }
		
		

		
		 string Contains_With_LocalCollection_2_True{ get; }
		
		

		
		 string Contains_With_LocalCollection_OneFalse{ get; }
		
		

		
		 string Contains_With_Subquery{ get; }
		
		

		
		 string Count_Distinct{ get; }
		
		


		
		 string Count_No_Args{ get; }
		
		

		
		 string Distinct_GroupBy{ get; }
		
		

		
		 string Distinct_Should_Not_Fail{ get; }
		
		

		
		 string Distinct_Should_Return_11_For_Scalar_CustomerCity{ get; }
		
		

		
		 string Distinct_Should_Return_69_For_Scalar_CustomerCity_Ordered{ get; }
		
		
		
		 string GroupBy_Basic{ get; }
		
		

		
		 string GroupBy_Distinct{ get; }
		
		
		

		
		 string GroupBy_SelectMany{ get; }
		
		

		
		 string GroupBy_Sum{ get; }
		
		

		
		 string GroupBy_Sum_With_Element_Selector_Sum_Max{ get; }
		
		

		
		 string GroupBy_Sum_With_Result_Selector{ get; }
		
		

		
		 string GroupBy_With_Anon_Element{ get; }
		
		

		
		 string GroupBy_With_Element_Selector{ get; }
		
		

		
		 string GroupBy_With_Element_Selector_Sum{ get; }
		
		

		
		 string GroupBy_With_OrderBy{ get; }
		
		

		
		 string Join_To_Categories{ get; }
		
		

		
		 string OrderBy_CustomerID{ get; }
		
		

		
		 string OrderBy_CustomerID_Descending{ get; }
		
		

		
		 string OrderBy_CustomerID_Descending_ThenBy_City{ get; }
		
		

		
		 string OrderBy_CustomerID_Descending_ThenByDescending_City{ get; }
		
		

		
		 string OrderBy_CustomerID_OrderBy_Company_City{ get; }
		
		

		
		 string OrderBy_CustomerID_ThenBy_City{ get; }
		
		

		
		 string OrderBy_CustomerID_With_Select{ get; }
		
		

		
		 string OrderBy_Join{ get; }
		
		

		
		 string OrderBy_SelectMany{ get; }
		
		

		
		 string Paging_With_Skip_Take{ get; }
		
		

		
		 string Paging_With_Take{ get; }
		
		

		
		 string Select_0_When_Set_False{ get; }
		
		

		
		 string Select_100_When_Set_True{ get; }
		
		

		
		 string Select_Anon_Constant_Int{ get; }
		
		

		
		 string Select_Anon_Constant_NullString{ get; }
		
		

		
		 string Select_Anon_Empty{ get; }
		
		

		
		 string Select_Anon_Literal{ get; }
		
		

		
		 string Select_Anon_Nested{ get; }
		
		

		
		 string Select_Anon_One{ get; }
		
		

		
		 string Select_Anon_One_And_Object{ get; }
		
		

		
		 string Select_Anon_Three{ get; }
		
		

		
		 string Select_Anon_Two{ get; }
		
		

		
		 string Select_Anon_With_Local{ get; }
		
		

		
		 string Select_Nested_Collection{ get; }
		
		

		
		 string Select_Nested_Collection_With_AnonType{ get; }
		
		

		
		 string Select_On_Self{ get; }
		
		

		
		 string Select_Scalar{ get; }
		
		


		
		 string SelectMany_Customer_Orders{ get; }
		
		


		
		 string Where_Resolves_String_EndsWith_Literal{ get; }
		
		

		
		 string Where_Resolves_String_EndsWith_OtherColumn{ get; }
		
		

		
		 string Where_Resolves_String_IsNullOrEmpty{ get; }
		
		

		
		 string Where_Resolves_String_Length{ get; }
		
		

		
		 string Where_Resolves_String_StartsWith_Literal{ get; }
		
		

		
		 string Where_Resolves_String_StartsWith_OtherColumn{ get; }
		

		
	
		 }
}
	

