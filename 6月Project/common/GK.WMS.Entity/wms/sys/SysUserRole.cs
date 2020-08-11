using GK.Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GK.WMS.Entity
{

    public class SysUserRole : WmsEntity
    {
        public long userIds { get; set; }

        public long roleId { get; set; }
    }
}