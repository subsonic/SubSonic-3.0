


  
using System;
using SubSonic;
using SubSonic.Schema;
using SubSonic.DataProviders;

namespace WestWind{
	public partial class SubSonicDB{

        public StoredProcedure TestSP(int parameter1,string parameter2,decimal parameter3){
            StoredProcedure sp=new StoredProcedure("TestSP",this.Provider);
            sp.Command.AddParameter("parameter1",parameter1);
            sp.Command.AddParameter("parameter2",parameter2);
            sp.Command.AddParameter("parameter3",parameter3);
            return sp;
        }
	
	}
	
}
 