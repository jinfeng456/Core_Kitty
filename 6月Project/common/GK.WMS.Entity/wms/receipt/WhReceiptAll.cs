﻿using Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity.wms
{
    public class WhReceiptAll : BaseEntity
    {
        public string soNo { get; set; }

        public string srcSoBill { get; set; }

        public string gysName { get; set; }

        public DateTime createdate { get; set; }

        public DateTime finshdate { get; set; }

        public string gysId { get; set; }

        public string gysCode { get; set; }

        public string status { get; set; }

        public string applyCode { get; set; }
        public long soId { get; set; }

        public string itemCode { get; set; }

        public string itemName { get; set; }

        public string specification { get; set; }

        public int count { get; set; }

        public string srcSoBillDetail { get; set; }

        public int finshCount { get; set; }

        public string itemUnit { get; set; }
        //供应商批次号
        public string FromCorpBatchNo
        {
            get; set;
        }
        //WMS批次号
        public string wmsBanchNo
        {
            get; set;
        }
        //类型
        public int inType
        {
            get; set;
        }
        //创建时间
        public DateTime createTime
        {
            get; set;
        }
        //单位
        public string packUnit
        {
            get; set;
        }
        //供应商名称
        public string FromCorpName
        {
            get; set;
        }
        //规格
        public string packageSpec
        {
            get; set;
        }
        public long receptId
        {
            get; set;
        }

        public int planCount
        {
            get; set;
        }
        public int activeCount
        {
            get; set;
        }

        public int stn
        {
            get; set;
        }
        public long itemId
        {
            get; set;
        }
        public string receiptNo
        {
            get; set;
        }
    }
}
