﻿using Common.DAL.inter;
using Common.dto;
using GK.WMS.Entity;
using GK.WMS.Entity.dto;
using GK.WMS.Entity.wms;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using WMS.Entity;

namespace GK.WMS.DAL
{
    public interface IReceiptInServer : IBaseServer
    {
       #region 采购订单入库单
        //采购入库订单分页
        Page<WhSoIn> QueryOrderPage(WhSoInDto dto);
        //采购入库订单转为入库单
        long AddReceiptIn(WhReceiptIn whReceiptIn, WhSoIn warehouseIn);
        //采购入库订单明细
        List<WhSoInDetail> GetOrderDetailId(WhSoIn warehouseIn);
        //子Id
        List<WhSoInDetail> GetPkNo(string src_so_bill_detail);
        //主ID
        List<WhSoInDetail> GetBillNo(string src_so_bill);
        List<WhReceiptInDetail> getAllWorkingReceiptInDetail() ;
    

        #endregion

       #region 入库单
        //采购入库订单分页
        Page<WhReceiptIn> QueryReceiptInPage(ReceiptinDto dto);
        //获取入库单明细
        List<WhReceiptInDetail> getDetials(long receiptInId);
        //入库单开始任务
        bool updateBegin(long id);
        //入库单完成任务
        bool updateFinsh(long id);

        //根据入库单ID去查询详细信息
        List<WhReceiptIn> getReceiptIn(long id);
        //通过入库单Id删除入库单明细
        bool deleteInDetail(long receiptId);

        //根据供应商获取物料
        Page<CoreItem> QueryCoreItemPage(CoreCorpItemDto dto);

        List<WhReceiptIn> GetAllList(long receiptInId);



        #endregion

        List<WhReceiptIn> GetNotUploadList();

        bool UpdateUploadById(long id);

        List<WhReceiptInDetail> GetListByReceiptId(long receiptId);
        Page<ReceiptInReportDto> QueryFindReportPage(ReceiptinDto dto);
        Page<ReceiptInFlatDto> QueryFindFlatPage(ReceiptinDto dto);
        string GetpkBillHById(long id);
        string GetpkBillBById(long id);
        List<ReceiptInReportDto> GetExportList(ReceiptinDto dto);

        bool SubmitFlat(int finshCount,string areaName);
    }
}
