using Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity.wms
{
    class SysMenuRole : BaseEntity
    {
        public long menuId
        {
            get; set;
        }
        public long roleId
        {
            get; set;
        }
    }
}
