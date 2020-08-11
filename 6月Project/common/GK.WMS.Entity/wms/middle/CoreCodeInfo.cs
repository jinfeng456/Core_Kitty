using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity.wms
{
    public class CoreCodeInfo
    {

        public object _id { get; set; }
        public long stockDetailId { get; set; }
        public string barCode { get; set; }
        public string parentCode { get; set; }
        public int isFull { get; set; }
        public long outDetailId { get; set; }

        public long pkDetailId { get; set; }
        /// <summary>
        /// 0库外，1.入库中2 库存，3 出库中，-1 出库完成
        /// </summary>
        public int status { get; set; }
        public int count { get; set; }
        public int? level { get; set; }
        public string oldBarcode { get; set; }
        /// <summary>
        /// //1，正常 2，盘盈，3 盘亏，4,修改条码
        /// </summary>
        public int uploadStatus { get; set; }   
    }
}
