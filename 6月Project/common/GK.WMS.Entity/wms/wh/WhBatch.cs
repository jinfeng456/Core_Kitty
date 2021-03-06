﻿using Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GK.WMS.Entity
{

    public class WhBatch : BaseEntity
    {
        public long? itemId { get; set; }

        public string itemName { get; set; }

        public int? count { get; set; }

        public string batchNo { get; set; }
        /*
        1 待检验
        2 已抽样
        3 合规
        4 不合规
        */
        public int? businessStatus { get; set; }
        public int? type { get; set; }

        public DateTime? businessExp { get; set; }

        public DateTime? retestDate { get; set; }
        public int? frozen { get; set; }

        public DateTime? releaseDate { get; set; }
        public long? itemType { get; set; }

        //同步的实体
        public string matno { get; set; }

        public string mname { get; set; }

        public DateTime? productOn { get; set; }
        public string spec { get; set; }
        public string packageCascade { get; set; }
        public int? updateCode { get; set; }

        public int? Priority { get; set; }
        public int? beginCount { get; set; }
        public long? whAreaId { get; set; }
    }
}