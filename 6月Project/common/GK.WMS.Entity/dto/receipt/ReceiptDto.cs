using GK.Common.dto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GK.WMS.Entity.dto
{
    public class ReceiptDto : PageDto
    {
        public string batchNo { get; set; }
        public int outType { get; set; }
        public string itemId { get; set; }

        public int status { get; set; }
        public string srcSoNo { get; set; }

        public string receiptNo { get; set; }

        public int outTypeClass { get; set; }

        public int stn { get; set; }

        public DateTime createBeginTime { get; set; }

        public DateTime createEndTime { get; set; }

        public DateTime finishBeginTime { get; set; }

        public DateTime finishEndTime { get; set; }

    }
}