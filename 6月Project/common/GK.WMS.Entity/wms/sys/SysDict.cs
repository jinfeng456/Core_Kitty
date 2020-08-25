using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Entity;

namespace GK.WMS.Entity
{

    public class SysDict : WmsEntity
    {
        public int value { get; set; }

        public string label { get; set; }

        public string dtype { get; set; }

        public string descriptions { get; set; }

        public long sort { get; set; }

        public string remarks { get; set; }

        public int delFlag { get; set; }

        public long dictClassId { get; set; }
    }
}