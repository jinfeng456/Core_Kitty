using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Entity;

namespace GK.WMS.Entity
{

    public class SysRole : WmsEntity
    {
        public string name { get; set; }

        public string remark { get; set; }

        public int delFlag { get; set; }
    }
}