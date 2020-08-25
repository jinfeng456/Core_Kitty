using System;
using System.Collections.Generic;
using System.Linq;
using CMNetLib.Robots.CarrierChain;
using WCS.Common;
using WCS.Common.task;

namespace GK.WCS.MechineHand
{
  
    public  class ManipulatorReader : ZtTask {
        protected ManipulatorConnect connect;
        

        public ManipulatorReader() {
            time = 500;
        }
        protected override void onlyOneTime()
        {
            connect = TaskPool.get<ManipulatorConnect>();
        }

      
        public override void excute() {
            byte[]  rs= connect.getData(6);
            rs = rs.Skip(9).ToArray<byte>();

            if (rs == null) {
                return;
            }
           
            List<byte> b = rs.ToList();
            int status = Tools.ushort16(rs, 0);
            int status2 = Tools.ushort16(rs, 2);
            int status3 = Tools.ushort16(rs, 4);
            int TaskNo = Tools.int32(rs, 4);


        }


        
     


       

    

       

      
    }
}
