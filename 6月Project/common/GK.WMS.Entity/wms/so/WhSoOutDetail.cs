﻿
using Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity.wms
{
   public class WhSoOutDetail : BaseEntity
    {
        public long soid
        {
            get; set;
        }
        public long itemId
        {
            get; set;
        }
        public int count
        {
            get; set;
        }
        public string srcSoBillDetail
        {
            get; set;
        }
        public string itemCode
        {
            get; set;
        }
        public string itemName
        {
            get; set;
        }
        public string packUnit
        {
            get; set;
        }
        public string itemSpec
        {
            get; set;
        }
        public int finshCount
        {
            get; set;
        }
    }
}
