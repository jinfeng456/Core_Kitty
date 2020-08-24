using System;
using System.Collections.Generic;
using GK.WCS.Common;

using GK.WCS.Common.Util;
using GK.WCS.Entity;

namespace GK.WCS.Carrier {
    public abstract class DYGCarrierConnect : CarrierConnect
    {


       public DYGCarrierConnect(int plcId) :base(plcId)
        {
        }


        public byte[] ReadTaskHandshake(short begin, short readCount)
        {
            byte[] bt = reader(51, (short)(begin + 2), readCount);
            return bt;
        }
 

    
        public bool clearAction(ushort type,int taskNo) {
            return true;
        }
        public void resetAction(ushort path) {
          
        }
        public void resetEndpath(int endPath)
        {
            if (endPath ==1001)
            {
                endPath=1;
            }
            else if (endPath == 1007)
            {
                endPath=2;
            }
            else if (endPath == 1011)
            {
                endPath=1;
            }
            else if (endPath == 1012)
            {
                endPath=2;
            }
            else if (endPath == 1015)
            {
                endPath=2;
            }
            else if (endPath == 1023)
            {
                endPath=1;
            }
            else if (endPath == 1024)
            {
                endPath=2;
            }
        }

        private static object socketLock1 = new object();
    }
}
