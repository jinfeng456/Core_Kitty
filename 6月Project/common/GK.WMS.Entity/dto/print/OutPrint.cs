using GK.WMS.Entity.dto;
using GK.WMS.Entity.wms;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity
{
    public class InPrint
    {
        public string html { get; set; }
        public List<WhReceiptIn> inList { get; set; }

        public List<WhReceiptInDetail> inDetailList { get; set; }
    }
}
