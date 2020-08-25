using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity.wms
{
    public class WhReceiptOut : AbsReceipt
    {
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

        public string receiptNo
        {
            get; set;
        }
        public int stn
        {
            get; set;
        }
        public int status
        {
            get; set;
        }
        public DateTime beginTime
        {
            get; set;
        }
        public DateTime finshTime
        {
            get; set;
        }
        public int outTypeClass
        {
            get; set;
        }

        public int pickType
        {
            get; set;
        }
        public string creater
        {
            get; set;
        }
    }
}
