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
using WMS.Entity;

namespace GK.WMS.DAL
{
    public interface ISysCodeServer : IBaseServer
    {
		Page<SysCode> QuerySysCodePage(SysCodeDto dto);
		List<SysCode> GetAllList();
	}
}

	