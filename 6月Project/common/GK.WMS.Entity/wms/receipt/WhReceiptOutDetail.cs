using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity
{
    public class WhReceiptOutDetail : AbsReceiptDetail {
       public long? soDetailId
        {
            get; set;
        }

        public long? soid
        {
            get; set;
        }

        public DateTime? createTime
        {
            get; set;
        }
        public string remark
        {
            get; set;
        }
    }
}
