using Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity
{
   public class WhSoInDetail : BaseEntity
    {
        public long soId { get; set; }

        public string itemCode { get; set; }

        public string itemName { get; set; }

        public string specification { get; set; }

        public int count { get; set; }

        public string srcSoBillDetail { get; set; }

        public int finshCount { get; set; }

        public string itemUnit { get; set; }

        public int itemId { get; set; }
    }
}
