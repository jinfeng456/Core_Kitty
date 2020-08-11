using GK.Common.dto;
using GK.DAL.inter;
using GK.WMS.Entity;
using GK.WMS.Entity.wms;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Security.AccessControl;
using System.Text;

namespace GK.WMS.DAL
{
    public interface IWhSoInServer : IBaseServer
    {

        List<WhSoInDetail> getDetials(long soid);

        List<WhSoInDetail> GetDetails(long soId);

        //根据入库单ID去查询详细信息
        List<WhSoIn> getWhSoIn(long id);
    }
}
