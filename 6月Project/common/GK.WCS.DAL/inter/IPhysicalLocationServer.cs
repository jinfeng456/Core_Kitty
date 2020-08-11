﻿using GK.Common.dto;
using GK.DAL.inter;
using GK.WCS.Entity;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace GK.WCS.DAL
{
   public interface  IPhysicalLocationServer: IBaseServer
    {
        Page<PhysicalLocation> queryPhysicalLocationPage<PhysicalLocation>(int start, int end, PageDto param );


    }
}
