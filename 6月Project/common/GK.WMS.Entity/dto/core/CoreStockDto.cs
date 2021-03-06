﻿using Common.dto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HY.WCS.DAL.dto
{
    public class CoreStockDto : PageDto
    {
        public string boxCode { get; set; }
        public long itemId { get; set; }
        public int batchId { get; set; }

        public long receiptlOutId { get; set; }

        public long id { get; set; }

        public int stockStatus { get; set; }

        public long areaId { get; set; }
        public long locId { get; set; }

        public long whId { get; set; }

        public DateTime exeBeginTime { get; set; }

        public DateTime exeEndTime { get; set; }

        public DateTime retestBeginTime { get; set; }

        public DateTime retestEndTime { get; set; }

        public bool isWarning { get; set; }

        public string wmsBanchNo { get; set; }
        public int priority { get; set; }

        public long stockDetailId { get; set; }

    }
}