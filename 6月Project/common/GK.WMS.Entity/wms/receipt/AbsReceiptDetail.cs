using GK.Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity
{
    public abstract   class AbsReceiptDetail : BaseEntity
    {
       
        public long?  receiptId{
            get; set;
        }
       
        public int? planCount
        {
            get; set;
        }
        public int? finshCount
        {
            get; set;
        }
        public int? activeCount
        {
            get; set;
        }
        
        public int? stn
        {
            get; set;
        }
        public long? itemId
        {
            get; set;
        }
        public long? batchId
        {
            get; set;
        }
        public string batchNo
        {
            get; set;
        }

        public string srcSoNo
        {
            get;set;
        }
    }
}
