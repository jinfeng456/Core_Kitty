﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Entity;

namespace GK.WMS.Entity
{

    public class SysRoleMenu : WmsEntity
    {
        public long roleId { get; set; }

        public long menuId { get; set; }

    }
}