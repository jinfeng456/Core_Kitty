using GK.Common.dto;
using GK.DAL.inter;
using GK.WMS.Entity;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Security.AccessControl;
using System.Text;

namespace GK.Fmxt.DAL
{
    public interface IMiddleServer : IBaseServer
    {
        List<LogCodeDetail> GetByBarCode(string barCode, string parentCode);
        List<CoreStockDetail> GetByBatchId();

        List<InfBatch> GetBatchList();
    }
}
