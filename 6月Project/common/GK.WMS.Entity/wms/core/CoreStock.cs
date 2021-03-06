﻿using GK.Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GK.WMS.Entity
{
    public class CoreStock : BaseEntity
    {
        public long? whId { get; set; }

        public long? classifyId { get; set; }

        public int? pileType { get; set; }
        public int? areaId { get; set; }

        public int? locId { get; set; }

        public int? locIndex { get; set; }

        public string boxCode { get; set; }

        public int? status { get; set; }

        public int? infocount { get; set; }

        public int? locked { get; set; }

        public DateTime? createTime { get; set; }

        public string sameCode { get; set; }

        public DateTime? changeTime { get; set; }

        public int? occupancy { get; set; }

        public int? pkStatus { get; set; }

        public int? statusTypes { get; set; }
        public int? isFull { get; set; }
        public long rItemId{ get; set; }

        public String rItemCode{ get; set; }
    }
}