
using Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity
{
    public class StatStockDetail : BaseEntity
    {
        public long  itemId
        {
            get; set;
        }
        public int count
        {
            get; set;
        }
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
