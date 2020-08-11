using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WCS.Carrier.enumerate {
   
    public enum CarrierStatus : byte {
        报警 = 1,
        手动 = 2,
        运行 = 3,
        自动状态下停止 = 4
    }

}
