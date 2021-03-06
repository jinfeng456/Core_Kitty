﻿using Common.dto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GK.WMS.Entity .dto
{
    public class ReceiptinDto : PageDto
    {
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
        //站台号
        public int stn
        {
            get; set;
        }
        //供应商名称
        public string FromCorpName
        {
            get; set;
        }
        //来源单号
        public string receiptNo
        {
            get; set;
        }

        public DateTime createBeginTime { get; set; }

        public DateTime createEndTime { get; set; }

        public DateTime finishBeginTime { get; set; }

        public DateTime finishEndTime { get; set; }
    }
}