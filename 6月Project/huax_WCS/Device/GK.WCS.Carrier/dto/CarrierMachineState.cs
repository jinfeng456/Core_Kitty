
using GK.WCS.Carrier.enumerate;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WCS.Common.core.dto {
  
   

    public class CarrierMachineState {
        public ushort plcMode;//PLC模式
        public ushort plcState;//PLC状态
        public ushort arriveApply;//到位申请
        public ushort arrived;//已达到
        public ushort free;//空闲
        public int CodeMess;//入口条码信息
        public int weight;//入口重量
        public int inWHType;//入口货位类型
        public int inTask;//入口任务
        
        public  CarrierMachineState(byte[] b,int begin)
        {
            plcMode=Tools.ushort16(b,begin);
            plcState=Tools.ushort16(b,begin+2);
            arriveApply=Tools.ushort16(b,begin+4);
            arrived=Tools.ushort16(b, begin+6);
            free=Tools.ushort16(b,begin+8);
            CodeMess=Tools.int32(b,begin+10);
            weight=Tools.int32(b, begin+14);
            inWHType=Tools.int32(b, begin+18);
            inTask=Tools.int32(b,begin+22);
        }

    }
}
