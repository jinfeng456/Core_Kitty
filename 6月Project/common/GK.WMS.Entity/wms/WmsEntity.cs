using GK.Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GK.WMS.Entity {

    public class WmsEntity : BaseEntity {
        public string createBy { get; set; }
        public DateTime createTime { get; set; }
        public string lastUpdateBy { get; set; }
        public DateTime lastUpdateTime { get; set; }

    }
}