using Common.DAL.inter;
using Common.dto;
using GK.WMS.Entity;
using GK.WMS.Entity.dto;
using GK.WMS.Entity.wms;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using WMS.Entity;

namespace GK.WMS.DAL
{
    public interface IReceiptOutServer : IBaseServer
    {
        List<WhReceiptOutDetail> getDetials(long receiptOutId);

        List<ReceiptOutdetailDto> GetOutDetials(long receiptOutId);


        Page<WhReceiptOut> QueryReceiptOutPage(ReceiptDto dto);

        List<WhReceiptOut> GetAllList(long receiptOutId);

        Page<WhReceiptOutQuery> QueryReceiptOutDetailPage(ReceiptDto dto);

        bool updateCoreStockDetails(string barCode);

         List<CoreStockDetail> getCoreStockDetials(long id);

        List<CoreStock> GetCoreStockId(string boxCode);

        bool updateCoreStockDetailsById(long id);

        List<CoreStockDetail> getCoreStockDetialsId(string barCode);
        List<WhReceiptOutDetail> GetReceiptOutDetail(ReceiptAddDto model);
        void DeleteDetailByReceptId(long receptId);

        List<WhReceiptOut> GetNotUploadList();
        Page<ReceiptOutReportDto> QueryFindReportPage(ReceiptDto dto);


        List<WhReceiptOutDetail> GetListByReceiptId(long receiptId);

        bool UpdateUploadById(long id);
        List<ReceiptOutReportDto> GetExportList(ReceiptDto dto);
    }
}
