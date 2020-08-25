using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity
{
    public class WhReceiptOutAllDto : AbsReceiptDetail {
       public long soDetailId
        {
            get; set;
        }
        public string srcSoNo
        {
            get; set;
        }

        public int? outType
        {
            get; set;
        }
        //public int soid
        //{
        //    get; set;
        //}

        public int? priority
        {
            get; set;
        }

        public string batchNo
        {
            get; set;
        }
    }
}
