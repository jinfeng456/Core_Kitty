using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HY.WCS.Entity.dto {
    public class PriorityDto {
        public long id
        {
            get;set;
        }
          public int  craneId
        {
            get; set;
        }
        public long wmsTaskId
        {
            get; set;
        }
        public long itemId
        {
            get; set;
        }
        public int type
        {
            get; set;
        }
        public int priority
        {
            get; set;
        }
        public int des
        {
            get; set;
        }
        
    }
}
