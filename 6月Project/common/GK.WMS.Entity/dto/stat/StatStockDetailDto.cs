using GK.Common.dto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity.dto {
   public class StatStockDetailDto  : PageDto{
             public String itemName
        {
            get; set;
        }
         public String wmsBanthNo
        {
            get; set;
        }

    }
}
