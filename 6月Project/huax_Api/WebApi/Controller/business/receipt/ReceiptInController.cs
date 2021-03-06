﻿
using Common.dto;
using GK.Engine.WMS.wms;
using GK.WMS.DAL;
using GK.WMS.Entity;
using GK.WMS.Entity.dto;
using GK.WMS.Entity.wms;
using HY.WCS.DAL.dto;
using MongoDB.Driver.Linq;
using System.Collections.Generic;
using System.IO;
using System.Web.Http;
using Web.Authorize;
using WebApi.util;
using WMS.DAL;
using WMS.Entity;

namespace WebApi
{
    [FormAuthenticationFilter]

    [RoutePrefix("receiptIn")]
    public class ReceiptInController : BaseApiController
    {
        IReceiptInServer receipt = WMSDalFactray.getDal<IReceiptInServer>();
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();
        IItemServer iitemServer = WMSDalFactray.getDal<IItemServer>();
        [HttpPost, Route("FindPage"), ControlName("入库单查询")]
        public BaseResult FindPage([FromBody]ReceiptinDto dto)
        {
            Page<WhReceiptIn> info = receipt.QueryReceiptInPage(dto);
            return BaseResult.Ok(info);
        }

        [HttpPost, Route("batchDelete")]
        public BaseResult batchDelete([FromBody]List<WhReceiptIn> list)
        {

            foreach (WhReceiptIn receiptIn in list)
            {
                List<WhReceiptIn> InList = receipt.getReceiptIn(receiptIn.id);
                if (InList[0].status == 1)
                {
                    receipt.delete<WhReceiptIn>(receiptIn.id);
                    receipt.deleteInDetail(receiptIn.id);
                }
                else
                {
                    return BaseResult.Error("入库单非待执行无法删除");
                }

            }

            return BaseResult.Ok("ok");
        }



        [HttpPost, Route("Save"), ControlName("入库单保存")]
        public BaseResult Save([FromBody]WhReceiptIn receiptIn)
        {
            if (string.IsNullOrWhiteSpace(receiptIn.receiptNo))
            {
                receiptIn.receiptNo = sequenceIdServer.GetSerial("Wh_Receipt_in", receiptIn.inType);
            }
            if (receiptIn.id == 0)
            {
                receiptIn.id = sequenceIdServer.getId();
                receiptIn.beginTime = sequenceIdServer.GetTime();
                receiptIn.finshTime = sequenceIdServer.GetTime();
                receiptIn.status = 1;
                receiptIn.creater= CookieHelper.LoginName();
                //receiptIn.wmsBanchNo = sequenceIdServer.getId().ToString();
                receipt.insertNotNull(receiptIn);
                return BaseResult.Ok(receiptIn);
            }
            else
            {
                receiptIn.status = 1;
                receipt.updateNotNull(receiptIn);
                return BaseResult.Ok(receiptIn);
            }
        }
        //平库编辑
        [HttpGet, Route("Submit/{finshCount?}/{areaId?}/{reDetailId?}")]
        public BaseResult Submit(int finshCount, long areaId,long reDetailId)
        {

             string errorMsg="";
            bool result=WMSTransactionFacade.doSyncFlatReult( finshCount,  areaId,  reDetailId,ref errorMsg);
            if (result)
            {
                return BaseResult.Ok("ok");
            }
            else
            {
                return BaseResult.Error();
            }
         
        }
        [HttpPost, Route("getDetials")]
        public BaseResult getDetials([FromBody]WhReceiptIn dto)
        {
            List<WhReceiptInDetail> info = receipt.getDetials(dto.id);
            return BaseResult.Ok(info);
        }

        [HttpPost, Route("saveDetials"), ControlName("入库单明细保存")]
        public BaseResult saveDetials([FromBody]ReceiptInAddDto dto)
        {
            WhReceiptIn receiptIn = receipt.getById<WhReceiptIn>(dto.id);
            List<WhReceiptInDetail> detailList = receipt.getDetials(dto.id);
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
                    WhReceiptInDetail detail = new WhReceiptInDetail();
                    CoreItem coreitem = iitemServer.FindCoreItemById(long.Parse(id));
                    detail.id = sequenceIdServer.getId();
                    detail.itemId = long.Parse(id);
                    detail.receiptId = receiptIn.id;
                    detail.stn = receiptIn.stn;
                    detail.planCount = 0;
                    detail.packageSpec = "";
                    detail.packUnit = "";
                    //detail.wmsBanchNo = receiptIn.wmsBanchNo;
                    detail.activeCount = 0;
                    detail.finshCount = 0;
                    detail.itemName = coreitem.name;
                    detail.createTime = sequenceIdServer.GetTime();
                    detail.FromCorpName = receiptIn.fromCorpName.Split('-')[0]; //主表是供应商加批号
                    detail.modelSpecs=coreitem.modelSpecs;
                    detail.packageSpec=coreitem.packageSpecs;
                    //detail.FromCorpBatchNo = receiptIn.FromCorpBatchNo;
                    receipt.insertNotNull(detail);
                }
            }
            return BaseResult.Ok("ok");
        }

        [HttpPost, Route("saveDetialByOrder")]
        public BaseResult saveDetialByOrder([FromBody]ReceiptAddDto dto)
        {
            WhReceiptIn receiptIn = receipt.getById<WhReceiptIn>(dto.id);
            //List<WhSoOutParam> list = whSoOutServer.GetWhSoOutList(dto.items);
            //foreach (var item in list)
            //{
            //    WhReceiptOutDetail detail = new WhReceiptOutDetail();
            //    detail.id = sequenceIdServer.getId();
            //    detail.itemId = item.itemId;
            //    detail.soDetailId = item.id;
            //    detail.receptId = dto.id;
            //    detail.stn = receiptOut.stn;
            //    detail.planCount = 0;
            //    receiptOutServer.insert(detail);
            //}
            string[] ids = dto.items.Split(',');
            //订单和仓库关系表的添加
            //foreach (var id in ids)
            //{
            //    WhSoOutReceipt soOutReceipt = new WhSoOutReceipt();
            //    soOutReceipt.id = sequenceIdServer.getId();
            //    soOutReceipt.whReceiptId = dto.id;
            //    soOutReceipt.soid = long.Parse(id);
            //    receiptOutServer.insert(soOutReceipt);
            //}


            return BaseResult.Ok("ok");
        }

        [HttpPost, Route("updateDetials"), ControlName("入库单明细修改")]
        public BaseResult updateDetials([FromBody]WhReceiptInDetail dto)
        {
            List<WhReceiptIn> InList = receipt.getReceiptIn(dto.receiptId ?? 0);
            if (InList[0].status != 1)
            {
                return BaseResult.Error("入库单非新建待执行状态无法编辑");
            }
            receipt.updateNotNull(dto);
            return BaseResult.Ok("ok");
        }


        [HttpPost, Route("deleteDetial"), ControlName("入库单明细删除")]
        public BaseResult deleteDetial([FromBody]WhReceiptInDetail dto)
        {
            List<WhReceiptIn> InList = receipt.getReceiptIn(dto.receiptId ?? 0);
            if (InList[0].status != 1)
            {
                return BaseResult.Error("入库单非新建待执行状态无法删除");
            }
            receipt.delete<WhReceiptInDetail>(dto.id);
            return BaseResult.Ok("ok");
        }

        //开始任务
        [HttpPost, Route("begin"), ControlName("入库单开始任务")]
        public BaseResult begin([FromBody]WhReceiptIn dto)
        {
            int sum = 0;
            List<WhReceiptInDetail> detailList = receipt.getDetials(dto.id);
            for (int i = 0; i < detailList.Count; i++)
            {
                if (detailList[i].wmsBanchNo == null || detailList[i].wmsBanchNo == "0" || detailList[i].wmsBanchNo == "")
                {
                    sum += 1;
                }
            }
            if (sum > 0)
            {
                return BaseResult.Error("入库单" + dto.id + "没有内部批号无法开始任务");
            }
            else
            {
                receipt.updateBegin(dto.id);
                return BaseResult.Ok("ok");
            }
        }
        //完成任务
        [HttpPost, Route("finsh"), ControlName("入库单完成任务")]
        public BaseResult finsh([FromBody]WhReceiptIn dto)
        {
            receipt.updateFinsh(dto.id);
            return BaseResult.Ok("ok");
        }
        //根据供应商获取物料列表
        [HttpPost, Route("findItemPage")]
        public BaseResult FindItemPage([FromBody]CoreCorpItemDto dto)
        {
            Page<CoreItem> info = receipt.QueryCoreItemPage(dto);
            return BaseResult.Ok(info);
        }

        [HttpPost, Route("Preview")]
        public BaseResult Preview([FromBody]WhReceiptIn receiptIn)
        {
            if (receiptIn == null)
            {
                return BaseResult.Error("没有数据无法打印");
            }
            InPrint inPrint = new InPrint();
            string currentPath = System.AppDomain.CurrentDomain.BaseDirectory;
            string html = FileUtil.ReadFileFromPath(Path.Combine(currentPath, "html", "StockIn.html"));
            List<WhReceiptIn> list = receipt.GetAllList(receiptIn.id);
            var stockInList = list;
            var stockInDList = receipt.getDetials(list[0].id);
            inPrint.html = html;
            inPrint.inList = list;
            inPrint.inDetailList = stockInDList;
            return BaseResult.Ok(inPrint);
        }

        //入库明细
        [HttpPost, Route("FindReportPage")]
        public BaseResult FindReportPage([FromBody]ReceiptinDto dto)
        {
            Page<ReceiptInReportDto> info = receipt.QueryFindReportPage(dto);
            return BaseResult.Ok(info);
        }
        //平库入库明细
        [HttpPost, Route("FindFlatReportPage")]
        public BaseResult FindFlatReportPage([FromBody]ReceiptinDto dto)
        {
            Page<ReceiptInFlatDto> info = receipt.QueryFindFlatPage(dto);
            return BaseResult.Ok(info);
        }
        //入库明细导出
        [HttpPost, Route("GetExportList")]
        public BaseResult GetExportList([FromBody]ReceiptinDto dto)
        {
            List<ReceiptInReportDto> info = receipt.GetExportList(dto);
            return BaseResult.Ok(info);
        }
    }
}