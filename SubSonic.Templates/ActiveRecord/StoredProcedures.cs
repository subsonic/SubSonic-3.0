


  
using System;
using SubSonic;
using SubSonic.Schema;
using SubSonic.DataProviders;

namespace Southwind{
	public class SPs{

        public static StoredProcedure TestSP(){
            StoredProcedure sp=new StoredProcedure("TestSP",ProviderFactory.GetProvider("Northwind"));
            return sp;
        }
	
	}
	
}
 