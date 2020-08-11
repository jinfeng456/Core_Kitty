using GK.Common.dto;
using GK.DAL.inter;
using GK.WMS.Entity;
using GK.WMS.Entity.dto;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace GK.WMS.DAL
{
    public interface IStatServer : IBaseServer
    {
          Page<StatStockDetail> QueryStatStockDetailPage(StatStockDetailDto dto);
       
    }
}
