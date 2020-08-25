using Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity.wms
{
    public class WhReceiptPkDetail : BaseEntity
    {
        public long receptId { get; set; }

     
        public int itemId { get; set;}   
        public int wmsBanchNo { get; set;}   
        public DateTime createTime { get; set;}   
        public long stockDetailId { get; set;}   
        public DateTime finshTime { get; set;}   
        public int count { get; set;}   
        public String barCode { get; set; }
        public String boxCode { get; set; }
        public int status { get; set; }
    }
}
