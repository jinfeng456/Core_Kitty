using Common.DAL.inter;
using GK.WMS.Entity;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Security.AccessControl;
using System.Text;
using WMS.Entity;

namespace GK.Fmxt.DAL
{
    public interface IMiddleServer : IBaseServer
    {
        List<LogCodeDetail> GetByBarCode(string barCode, string parentCode);
        List<CoreStockDetail> GetByBatchId();

        List<InfBatch> GetBatchList();
    }
}
