﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity
{
    public    class WhReceiptInDetail  : AbsReceiptDetail
    {
        //wms批次号
        public string wmsBanchNo
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
        //供应商批次号
        public string FromCorpBatchNo
        {
            get; set;
        }
        public string itemName
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
        public long? soDetailId
        {
            get; set;
        }
        public long? soid
        {
            get; set;
        }
        public string modelSpecs
        {
            get; set;
        }
        public long wh_area_id
        {
            get; set;
        }
    }
}
