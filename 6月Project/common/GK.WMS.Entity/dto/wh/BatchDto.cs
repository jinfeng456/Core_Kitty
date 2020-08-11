using GK.Common.dto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HY.WCS.DAL.dto
{
    public class BatchDto : PageDto
    {
        public string batchNo { get; set; }

        public int businessStatus { get; set; }

        public long id { get; set; }

        public int itemId { get; set; }
        public string itemName { get; set; }

        public int type { get; set; }

        public bool isWarning { get; set; }

        public int Priority { get; set; }
        public long whAreaId { get; set; }
    }
}