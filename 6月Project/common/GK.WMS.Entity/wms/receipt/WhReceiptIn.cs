using GK.Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity.wms
{
    public class WhReceiptIn : BaseEntity
    {
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
        ////供应商批次号
        //public string FromCorpBatchNo
        //{
        //    get; set;
        //}
       
        ////WMS批次号
        //public string wmsBanchNo
        //{
        //    get; set;
        //}
        //类型
        public int inType
        {
            get; set;
        }
        //供应商名称
        public string fromCorpName
        {
            get; set;
        }
        public long fromCorpId
        {
            get; set;
        }
        public short upload
        {
            get; set;
        }
        public string creater
        {
            get; set;
        }
        public string remark
        {
            get; set;
        }
    }
}
