using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity.wms
{
    public class WhSoOutParam
    {
        public long id { get; set; }
        public string soNo { get; set; }
        public string srcSoNo { get; set; }
        public long soid { get; set; }
        public long itemId { get; set; }
        public int count { get; set; }
    }
}
