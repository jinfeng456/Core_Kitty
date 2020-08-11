using GK.Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity
{
    public class WhReceiptOutQuery : AbsReceiptDetail {
       public long soDetailId
        {
            get; set;
        }

        public int status
        {
            get; set;
        }
    }
}
