using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Entity;

namespace GK.WMS.Entity
{

    public class SysDictClass : WmsEntity
    {
        public string dictClassName { get; set; }

        public string dictRemark { get; set; }

    }
}