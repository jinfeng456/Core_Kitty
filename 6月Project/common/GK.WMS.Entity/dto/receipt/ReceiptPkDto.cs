using GK.Common.dto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GK.WMS.Entity.dto
{
    public class ReceiptPkDto : PageDto
    {
        public string banchNo { get; set; }
        public int pkType { get; set; }
        public int stn { get; set; }
        public int status { get; set; }
        public DateTime finshTime { get; set; }
        public long itemId { get; set; }
    }
}