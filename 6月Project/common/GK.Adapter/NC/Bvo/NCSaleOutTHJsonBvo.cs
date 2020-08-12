using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.Ws.Mes.NC
{
    public class NCSaleOutTHJsonBvo: NCBvo
    {
        public string wmsbid { get; set; }
        public string pk_bill_b { get; set; }
        public double outnum { get; set; }
        public string batchnum { get; set; }

        public string boxno { get; set; }
        public string oboxnum { get; set; }

    }
}
