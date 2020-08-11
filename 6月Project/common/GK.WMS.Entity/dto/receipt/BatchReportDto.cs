using GK.Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity
{
    public class BatchReportDto
    {
        public int id { get; set; }
        public string itemId { get; set; }

        public string batchNo { get; set; }

        public string packageSpec { get; set; }

        public string packUnit { get; set; }

        public int inCount { get; set; }

        public int outCount { get; set; }

        public int lastCount { get; set; }

        public int Priority { get; set; }

    }
}
