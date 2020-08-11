using GK.WMS.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.Engine.WMS {
   public class StockDto {
        public StockDto(CoreStockDetail detail) {
            id = detail.id;
            coreStockDetailList = new List<CoreStockDetail>();
            coreStockDetailList.Add(detail);
        }
        public long id { get; set; }

        public List<CoreStockDetail> coreStockDetailList { get; set; }

        public bool add(CoreStockDetail detail) {
            if (id == detail.id) {
                coreStockDetailList.Add(detail);
                return true;
            } else {
                return false;
            }
        }

        public int? remain(WhReceiptDetailDto receiptDetail, int? remain) {
          
            foreach (CoreStockDetail stockDetail in coreStockDetailList) {//遍历明细
                if (receiptDetail.same(stockDetail)) {
                    remain = remain - stockDetail.countDb;
                }
            }
            return remain;
        }
    }
}
