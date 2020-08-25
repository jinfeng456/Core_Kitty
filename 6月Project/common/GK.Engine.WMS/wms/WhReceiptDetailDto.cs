using GK.WMS.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using WMS.Entity;

namespace GK.Engine.WMS {
   public class WhReceiptDetailDto {
        public WhReceiptDetailDto(AbsReceiptDetail detail) {
            receiptDetail = detail;
            count = (int)detail.planCount;
        }
        public int count { get; set; }

        public AbsReceiptDetail receiptDetail { get; set; }
        public bool same(CoreStockDetail detail) {
            return false;
        }



    }
}
