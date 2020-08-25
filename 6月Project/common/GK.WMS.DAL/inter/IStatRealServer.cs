using Common.DAL.inter;
using Common.dto;
using GK.WMS.Entity;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Security.AccessControl;
using System.Text;

namespace GK.WMS.DAL
{
    public interface IStatRealServer : IBaseServer
    {
		Page<StatReal> QueryStatRealPage(StatRealDto dto);
        Page<StatRealDto> QueryStatRealAllPage(StatRealDto dto);
    }
}

	