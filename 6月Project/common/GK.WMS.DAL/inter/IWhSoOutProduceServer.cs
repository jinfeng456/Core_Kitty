using Common.DAL.inter;
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
    public interface IWhSoOutProduceServer : IBaseServer
    {
        List<WhSoOutProduceDetail> GetDetails(long soId);

        List<WhSoOutProduce> getWhSoOutProduce(long id);
    }
}
