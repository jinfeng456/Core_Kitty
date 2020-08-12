using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.Ws.Mes.NC
{
    public class NCAggvos
    {
        public string pk_bill_h { get; set; }
        public string wmshid { get; set; }
        public List<NCBvo> bvo { get; set; }
    }
}
