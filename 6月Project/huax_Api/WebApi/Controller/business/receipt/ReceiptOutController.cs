﻿
using Common.dto;
using Dapper;
using GK.Engine.WMS;
using GK.Engine.WMS.wms;
using GK.FMXT.DAL;
using GK.WMS.DAL;
using GK.WMS.Entity;
using GK.WMS.Entity.dto;
using GK.WMS.Entity.wms;
using Microsoft.Office.Interop.Excel;
using NPOI.SS.UserModel;
using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Web.Http;
using Web.Authorize;
using WebApi.Controller.file;
using WebApi.util;
using WMS.DAL;

namespace WebApi
{
    [FormAuthenticationFilter]

    [RoutePrefix("receiptOut")]
    public class ReceiptOutController : BaseApiController
    {
        IReceiptOutServer receiptOutServer = WMSDalFactray.getDal<IReceiptOutServer>();
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();
        IWhSoOutServer whSoOutServer = WMSDalFactray.getDal<IWhSoOutServer>();

        [HttpPost, Route("FindPage")]
        public BaseResult FindPage([FromBody]ReceiptDto dto)
        {
            Page<WhReceiptOut> info = receiptOutServer.QueryReceiptOutPage(dto);
            return BaseResult.Ok(info);
        }

        [HttpPost, Route("FindDetailPage")]
        public BaseResult FindDetailPage([FromBody]ReceiptDto dto)
        {
            Page<WhReceiptOutQuery> info = receiptOutServer.QueryReceiptOutDetailPage(dto);
            return BaseResult.Ok(info);
        }

        [HttpPost, Route("batchDelete"), ControlName("出库单删除")]
        public BaseResult batchDelete([FromBody]List<WhReceiptOut> list)
        {
            foreach (WhReceiptOut receiptOut in list)
            {
                WhReceiptOut model = receiptOutServer.getById<WhReceiptOut>(receiptOut.id);
                if (model.status != 1)
                {
                    return BaseResult.Error("出库单非新建待执行状态无法删除!");
                }
                receiptOutServer.delete<WhReceiptOut>(receiptOut.id);
                receiptOutServer.DeleteDetailByReceptId(receiptOut.id);
            }
            return BaseResult.Ok("ok");
        }

        [HttpPost, Route("Save"), ControlName("出库单保存")]
        public BaseResult Save([FromBody]WhReceiptOut receiptOut)
        {
            //CodeInfoUtil.SyncCodeInfo();
            if (string.IsNullOrWhiteSpace(receiptOut.receiptNo))
            {
                receiptOut.receiptNo = sequenceIdServer.GetSerial("Wh_Receipt_out", receiptOut.outType ?? 0);
            }
            if (receiptOut.id == 0)
            {
                receiptOut.id = sequenceIdServer.getId();
                receiptOut.beginTime = sequenceIdServer.GetTime();
                receiptOut.status = 1;
                receiptOutServer.insertNotNull(receiptOut);
                return BaseResult.Ok(receiptOut);
            }
            else
            {
                receiptOutServer.updateNotNull(receiptOut);
                return BaseResult.Ok(receiptOut);
            }

        }
        [HttpPost, Route("getDetials")]
        public BaseResult getDetials([FromBody]WhReceiptOut dto)
        {
            List<WhReceiptOutDetail> info = receiptOutServer.getDetials(dto.id);
            return BaseResult.Ok(info);
        }

        [HttpPost, Route("saveDetials"), ControlName("出库单明细保存")]
        public BaseResult saveDetials([FromBody]ReceiptAddDto dto)
        {
            if (dto.id == 0)
            {
                return BaseResult.Error("请先添加主表信息");
            }
            WhReceiptOut receiptOut = receiptOutServer.getById<WhReceiptOut>(dto.id);
            if (receiptOut.status != 1)
            {
                return BaseResult.Error("出库单非新建待执行状态无法修改!");
            }
            List<WhReceiptOutDetail> detailList = receiptOutServer.GetReceiptOutDetail(dto);
            string[] ids = dto.items.Split(',');
            foreach (string id in ids)
            {
                bool same = false;
                foreach (var soDetail in detailList)
                {
                    if (soDetail.itemId == long.Parse(id.Split('|')[0]))
                    {
                        same = true;
                    }
                }
                if (!same)
                {
                    WhReceiptOutDetail detail = new WhReceiptOutDetail();
                    detail.id = sequenceIdServer.getId();
                    detail.itemId = long.Parse(id);
                    detail.receiptId = dto.id;
                    detail.stn = receiptOut.stn;
                    detail.planCount = 0;
                    detail.srcSoNo = receiptOut.srcSoNo;
                    receiptOutServer.insert(detail);
                }
            }
            return BaseResult.Ok("ok");
        }

        [HttpPost, Route("saveDetialsByBatch"), ControlName("批次出库明细保存")]//批次出库
        public BaseResult saveDetialsByBatch([FromBody]ReceiptAddDto dto)
        {
            if (dto.id == 0)
            {
                return BaseResult.Error("请先添加主表信息");
            }
            WhReceiptOut receiptOut = receiptOutServer.getById<WhReceiptOut>(dto.id);
            if (receiptOut.status != 1)
            {
                return BaseResult.Error("出库单非新建待执行状态无法修改!");
            }
            List<WhReceiptOutDetail> detailList = receiptOutServer.GetReceiptOutDetail(dto);
            string[] ids = dto.items.Split(',');

            //重复批次验证
            foreach (var id in ids)
            {
                bool same = false;
                foreach (var soDetail in detailList)
                {
                    if (soDetail.batchId == long.Parse(id.Split('|')[0]))
                    {
                        //return BaseResult.Error(500, "不能重复添加批次");
                        same = true;
                    }
                }
                if (!same)
                {
                    WhReceiptOutDetail detail = new WhReceiptOutDetail();
                    detail.id = sequenceIdServer.getId();
                    detail.itemId = long.Parse(id.Split('|')[1]);
                    detail.receiptId = dto.id;
                    detail.stn = receiptOut.stn;
                    detail.planCount = 0;
                    detail.batchId = long.Parse(id.Split('|')[0]);
                    detail.srcSoNo = receiptOut.srcSoNo;
                    detail.batchNo = id.Split('|')[2];
                    receiptOutServer.insert(detail);
                }
            }
            return BaseResult.Ok("ok");
        }
        //(销售出库,生产出库)这2个暂时分开,看实际情况是否可以合并
        [HttpPost, Route("saveDetialByOrder"), ControlName("销售出库明细保存")]//销售出库
        public BaseResult saveDetialByOrder([FromBody]ReceiptAddDto dto)
        {
            if (dto.id == 0)
            {
                return BaseResult.Error("请先添加主表信息");
            }
            WhReceiptOut receiptOut = receiptOutServer.getById<WhReceiptOut>(dto.id);
            if (receiptOut.status != 1)
            {
                return BaseResult.Error("出库单非新建待执行状态无法修改!");
            }
            List<WhSoOutParam> list = whSoOutServer.GetWhSoOutList(dto.items);
            List<WhReceiptOutDetail> detailList = receiptOutServer.GetReceiptOutDetail(dto);
            //重复添加订单号
            foreach (var soDetail in list)
            {
                bool same = false;
                foreach (var receiptDetail in detailList)
                {
                    if (receiptDetail.soDetailId == soDetail.id)
                    {
                        same = true;
                    }
                }
                if (!same)
                {
                    WhReceiptOutDetail detail = new WhReceiptOutDetail();
                    detail.id = sequenceIdServer.getId();
                    detail.itemId = soDetail.itemId;
                    detail.soid = soDetail.soid;//订单主键
                    detail.soDetailId = soDetail.id;//订单明细主键
                    detail.receiptId = dto.id; //出库单主表主键
                    detail.stn = receiptOut.stn;
                    detail.planCount = 0;
                    detail.srcSoNo = receiptOut.srcSoNo;
                    receiptOutServer.insert(detail);
                }
            }
            string[] ids = dto.items.Split(',');//订单主键集合
            //订单和仓库关系表的添加
            foreach (var id in ids)
            {
                WhSoOutReceipt soOutReceipt = new WhSoOutReceipt();
                soOutReceipt.id = sequenceIdServer.getId();
                soOutReceipt.whReceiptId = dto.id;
                soOutReceipt.soid = long.Parse(id);
                receiptOutServer.insert(soOutReceipt);
            }
            return BaseResult.Ok("ok");
        }
        [HttpPost, Route("saveDetialByProduce"), ControlName("生产出库明细保存")]//生产出库
        public BaseResult saveDetialByProduce([FromBody]ReceiptAddDto dto)
        {
            if (dto.id == 0)
            {
                return BaseResult.Error("请先添加主表信息");
            }
            WhReceiptOut receiptOut = receiptOutServer.getById<WhReceiptOut>(dto.id);
            if (receiptOut.status != 1)
            {
                return BaseResult.Error("出库单非新建待执行状态无法修改!");
            }
            List<WhSoProduceParam> list = whSoOutServer.GetWhSoProduceList(dto.items);
            List<WhReceiptOutDetail> detailList = receiptOutServer.GetReceiptOutDetail(dto);
            //重复添加订单号
            foreach (var soDetail in list)
            {
                bool same = false;
                foreach (var receiptDetail in detailList)
                {
                    if (receiptDetail.soDetailId == soDetail.id)
                    {
                        same = true;
                    }
                }
                if (!same)
                {
                    WhReceiptOutDetail detail = new WhReceiptOutDetail();
                    detail.id = sequenceIdServer.getId();
                    detail.itemId = soDetail.itemId;
                    detail.soid = soDetail.soId;//订单主键
                    detail.soDetailId = soDetail.id;//订单明细主键
                    detail.receiptId = dto.id; //出库单主表主键
                    detail.stn = receiptOut.stn;
                    detail.srcSoNo = receiptOut.srcSoNo;
                    detail.planCount = 0;
                    receiptOutServer.insert(detail);
                }
                string[] ids = dto.items.Split(',');//订单主键集合

                foreach (var id in ids) //订单和仓库关系表的添加
                {
                    WhSoOutReceipt soOutReceipt = new WhSoOutReceipt();
                    soOutReceipt.id = sequenceIdServer.getId();
                    soOutReceipt.whReceiptId = dto.id;
                    soOutReceipt.soid = long.Parse(id);
                    receiptOutServer.insert(soOutReceipt);
                }
            }
            return BaseResult.Ok("ok");
        }

        [HttpPost, Route("updateDetials"), ControlName("出库单明细修改")]
        public BaseResult updateDetials([FromBody]WhReceiptOutDetail dto)
        {
            WhReceiptOut receiptOut = receiptOutServer.getById<WhReceiptOut>(dto.receiptId ?? 0);
            if (receiptOut.status != 1)
            {
                return BaseResult.Error("出库单非新建待执行状态无法删除!");
            }
            receiptOutServer.updateNotNull(dto);
            return BaseResult.Ok("ok");
        }


        [HttpPost, Route("deleteDetial"), ControlName("出库单明细删除")]
        public BaseResult deleteDetial([FromBody]WhReceiptOutDetail dto)
        {
            WhReceiptOut receiptOut = receiptOutServer.getById<WhReceiptOut>(dto.receiptId ?? 0);
            if (receiptOut.status != 1)
            {
                return BaseResult.Error("出库单非新建待执行状态无法修改!");
            }
            receiptOutServer.delete<WhReceiptOutDetail>(dto.id);
            return BaseResult.Ok("ok");
        }

        //生成原料请检任务
        [HttpPost, Route("checkoutGenerate"), ControlName("原料抽检出库生成任务")]
        public BaseResult CheckOutGenerate([FromBody]WhReceiptOut whReceipt)
        {
            string errorMsg = string.Empty;
            if (WMSTransactionFacade.doCheckOutEngine(whReceipt, ref errorMsg))
            {
                return BaseResult.Ok("生成成功");
            }
            else
            {
                return BaseResult.Error(errorMsg);
            }
        }

        //生成任务(物料,销售,生产出库)
        [HttpPost, Route("otherOutGenerate"), ControlName("物料出库生成任务")]
        public BaseResult OtherOutGenerate([FromBody]WhReceiptOut whReceipt)
        {
            string errorMsg = string.Empty;
            if (WMSTransactionFacade.doOtherOutEngine(whReceipt, ref errorMsg))
            {
                return BaseResult.Ok("生成成功");
            }
            else
            {
                return BaseResult.Error(errorMsg);
            }
        }

        //生成批次出库任务
        [HttpPost, Route("batchOutGenerate"), ControlName("批次出库生成任务")]
        public BaseResult BatchOutGenerate([FromBody]WhReceiptOut whReceipt)
        {
            string errorMsg = string.Empty;
            if (WMSTransactionFacade.doBatchOutEngine(whReceipt,ref errorMsg))
            {
                return BaseResult.Ok("生成成功");
            }
            else
            {
                return BaseResult.Error(errorMsg);
            }
        }

        [HttpPost, Route("Preview")]
        public BaseResult Preview([FromBody]WhReceiptOut receiptOut)
        {
            if (receiptOut == null)
            {
                return BaseResult.Error("没有数据无法打印");
            }
            OutPrint outPrint = new OutPrint();
            string currentPath = System.AppDomain.CurrentDomain.BaseDirectory;
            string html = FileUtil.ReadFileFromPath(Path.Combine(currentPath, "html", "StockOut.html"));
            List<WhReceiptOut> list = receiptOutServer.GetAllList(receiptOut.id);
            var stockOutList = list;
            var stockOutDList = receiptOutServer.GetOutDetials(list[0].id);
            outPrint.html = html;
            outPrint.outList = list;
            outPrint.outDetailList = stockOutDList;
            return BaseResult.Ok(outPrint);
        }

        //出库明细
        [HttpPost, Route("FindReportPage")]
        public BaseResult FindReportPage([FromBody]ReceiptDto dto)
        {
            Page<ReceiptOutReportDto> info = receiptOutServer.QueryFindReportPage(dto);
            return BaseResult.Ok(info);
        }

        //出库明细导出
        [HttpPost, Route("GetExportList")]
        public BaseResult GetExportList([FromBody]ReceiptDto dto)
        {
            List<ReceiptOutReportDto> info = receiptOutServer.GetExportList(dto);
            return BaseResult.Ok(info);
        }
    }
}