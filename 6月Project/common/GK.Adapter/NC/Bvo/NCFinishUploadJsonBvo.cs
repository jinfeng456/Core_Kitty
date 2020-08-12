using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.Ws.Mes.NC
{
    public class NCFinishUploadJsonBvo: NCBvo
    {
        public string wmsbid { get; set; }
        public string pk_bill_b { get; set; }
        public string outnum { get; set; }
        public string batchnum { get; set; }
        
    }
}
