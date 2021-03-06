﻿using Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity
{
   public class WhSoIn : BaseEntity
    {
        public string soNo { get; set; }

        public string srcSoBill { get; set; }

        public string gysName { get; set; }

        public DateTime createDate { get; set; }

        public DateTime finshDate { get; set; }

        public string gysId { get; set; }

        public string gysCode { get; set; }

        public int status { get; set; }

        public long fromCorpId
        {
            get; set;
        }
    }
}
