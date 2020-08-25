using Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity.wms
{
   public class WhSoOutReceipt : BaseEntity
    {
        public long soid
        {
            get; set;
        }
        public long whReceiptId
        {
            get; set;
        }
    }
}
