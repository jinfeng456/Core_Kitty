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
    public interface IStatMonthServer : IBaseServer
    {
		Page<StatMonth> QueryStatMonthPage(StatMonthDto dto);
	}
}

	