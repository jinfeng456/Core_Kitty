using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.FMXT.DAL.Entity
{
    public class Export
    {
        public long id { get; set; }
        public int outType { get; set; }
        public string receiptNo { get; set; }
    }
}
