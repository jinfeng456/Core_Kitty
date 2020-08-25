using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Entity;

namespace GK.WMS.Entity
{

    public class SysUserRole : WmsEntity
    {
        public long userIds { get; set; }

        public long roleId { get; set; }
    }
}