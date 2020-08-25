using GK.WMS.Entity.dto;
using GK.WMS.Entity.wms;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity
{
    public class OutPrint
    {
        public string html { get; set; }
        public List<WhReceiptOut> outList { get; set; }

        public List<ReceiptOutdetailDto> outDetailList { get; set; }
    }
}
