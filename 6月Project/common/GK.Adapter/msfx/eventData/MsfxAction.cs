using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.Xml.Msfx.upload {
  public  class MsfxAction {
       public MsfxActionType Name ;
       public  List<String> ActionData;
    }
    public enum MsfxActionType
        {
        WareHouseIn,
        WareHouseOut,
        CodeReplace,
        CodeDestory
        }

 
}
