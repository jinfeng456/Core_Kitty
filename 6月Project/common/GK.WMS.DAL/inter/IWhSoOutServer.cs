﻿using Common.DAL.inter;
using Common.dto;
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
    public interface IWhSoOutServer : IBaseServer
    {
        #region 销售订单
        Page<WhSoOut> QueryWhSoOutPage<WhSoOut>(WhSoOutDto dto);

        Page<WhSoOut> QueryWhSoOutPages<WhSoOut>(WhSoOutDto dto);
        List<WhSoOutParam> GetWhSoOutList(string soidList);

        List<WhSoOutReceipt> GetSoOutReceptList(long receiptId);

        List<WhSoOutDetail> GetOrderDetailId(WhSoOut whSoOut);

        List<WhSoOutDetail> GetBillNo(string src_so_bill);

        List<WhSoOutDetail> GetPkNo(string src_so_bill_detail);
        #endregion

        #region 生产订单
        Page<WhSoOutProduce> QueryWhSoOutProducePages<WhSoOutProduce>(WhSoOutProduceDto dto);

        Page<WhSoOutProduce> WhSoOutProducePages<WhSoOutProduce>(WhSoOutProduceDto dto);

        List<WhSoOutProduceDetail> GetProduceDetailId(WhSoOutProduce whSoOutProduce);

        List<WhSoOutProduceDetail> GetBillProduceNo(string src_so_bill);

        List<WhSoOutProduceDetail> GetPkProduceNo(string src_so_bill_detail);

        List<WhSoProduceParam> GetWhSoProduceList(string soidList);
        #endregion
        List<WhSoOutDetail> GetDetails(long soId);

        List<WhSoOut> getWhSoOut(long id);

    }
}
