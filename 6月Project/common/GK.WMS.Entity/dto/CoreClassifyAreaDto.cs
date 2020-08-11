using GK.Common.dto;
using GK.Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity.wms
{
    public class CoreClassifyAreaDto : PageDto
    {
        public long classifyId
        {
            get; set;
        }
        public long areaId
        {
            get; set;
        }
        public int priority
        {
            get; set;
        }
    }
}
