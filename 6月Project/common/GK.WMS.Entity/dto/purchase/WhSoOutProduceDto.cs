﻿using Common.dto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity.wms
{
   public class WhSoOutProduceDto : PageDto
    {
        public long id { get; set; }
        public string soNo
        {
            get; set;
        }
        public string srcSoBill
        {
            get; set;
        }
        public string applicantCode
        {
            get; set;
        }
        public string applicantId
        {
            get; set;
        }
        public string applicantName
        {
            get; set;
        }
        public string status
        {
            get; set;
        }
        public string vbillcode { get; set; }

        public string items { get; set; }
        public long fromCorpId
        {
            get; set;
        }
    }
}
