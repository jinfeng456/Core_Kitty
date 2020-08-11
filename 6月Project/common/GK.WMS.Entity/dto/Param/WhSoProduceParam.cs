using GK.Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity.wms
{
    public class WhSoProduceParam
    {
        public long id { get; set; }
        public string soNo { get; set; }
        public long soId { get; set; }
        public long itemId { get; set; }
        public double count { get; set; }
        public string srcSoBillDetail { get; set; }
        public long itemCode { get; set; }
        public string itemName { get; set; }
        public string packUnit { get; set; }
        public string itemSpec { get; set; }
    }
}
