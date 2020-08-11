using GK.Common.dto;
using GK.DAL.inter;
using GK.WMS.Entity;
using GK.WMS.Entity.dto;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Security.AccessControl;
using System.Text;

namespace GK.WMS.DAL
{
    public interface ICoreStockServer : IBaseServer
    {       
        Page<CoreStock> QueryCoreStockPage(CoreStockDto dto);
        List<CoreStockDetail> GetListByStockId(long stockId);
        List<CoreStock> getCoreStockByCode(String code);
        Page<CoreStockDetail> QueryCoreStockDetailPage(CoreStockDto dto);
        long UpdateRecepitOutId(ReceiptAddDto dto);

        long UpdateRbussinessByBatchId(long batchId, int batchStatus);
        List<CoreStockDetail> GetByBatchId();

        long GetByBatchId(long batchid);
        bool UpdatePriority(CoreStockDetail coreDetailId);
        
        bool UpdatePriorityById(CoreStockDto coreDetailId);
        List<CoreStockDetail> GetByOutId(long receptId);

        List<CoreStockDetail> GetByOutDetailId(long receptId);
        Page<CoreStockParam> QueryCoreDetailPage(CoreStockDto dto);
        Page<CoreStockParam> QueryRealCoreDetailPage(CoreStockDto dto);
        CoreStock getCoreStockByLocId(int locId);
        int getSumStockCountDb(long receiptlnId);


    }
}
