﻿
using Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity.wms
{
    public class WhReceiptPk : BaseEntity
    {
        public DateTime? beginTime { get; set; }
        public int? status { get; set; }
        public int? stn { get; set; }
        public long? itemId { get; set; }
        public DateTime? finshTime { get; set; }
        public long? createrId { get; set; }
        public string receiptNo { get; set; }
        public int? pkType { get; set; }
        public int? detailCount { get; set; }
        public DateTime? pkBegin { get; set; }
        public DateTime? pkEnd { get; set; }
        public string banchNo { get; set; }
        public int? craneId { get; set; }
    }
}
