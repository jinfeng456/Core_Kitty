﻿using Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity.wms
{
   public class WhSoOutProduce : BaseEntity
    {
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
        public DateTime createDate { get; set; }

        public DateTime finishDate { get; set; }
        public long fromCorpId
        {
            get; set;
        }
    }
}
