using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WCS.Carrier.enumerate {
  

    public enum CarrierErrCode : byte {

        正常运行 = 0,
        急停 = 1,
        水平电机热继 = 2,
        水平运行超时 = 3,
        有货无任务 = 4,
        站位超时 = 5,
        超长 = 6,
        超宽 = 7,
        超高 = 8,
        原点保护报警 = 9,
        旋转位保护报警 = 10,
        旋转超时 = 11,
        顶升超时 = 12,
        顶升电机热继 = 13,
        转向电机热继 = 14,
        有任务无货 = 15,
        未知错误 = 255
    }
}
