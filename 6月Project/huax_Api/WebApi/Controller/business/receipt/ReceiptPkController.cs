﻿
using Common.dto;
using GK.Engine.WMS;
using GK.Engine.WMS.wms;
using GK.WMS.DAL;
using GK.WMS.Entity;
using GK.WMS.Entity.dto;
using GK.WMS.Entity.wms;
using Microsoft.AspNet.SignalR.Infrastructure;
using System.Collections.Generic;
using System.Web.Http;
using Web.Authorize;
using WMS.DAL;

namespace WebApi
{
    [FormAuthenticationFilter]

    [RoutePrefix("whReceiptPk")]
    public class ReceiptPkController : BaseApiController
    {
        IReceiptPkServer receiptPkServer = WMSDalFactray.getDal<IReceiptPkServer>();
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();
        static StockPkEngine stockPkEngine = new StockPkEngine();

        [HttpPost, Route("FindPage")]
        public BaseResult FindPage([FromBody]ReceiptPkDto dto)
        {
            Page<WhReceiptPk> info = receiptPkServer.QueryReceiptPkPage<WhReceiptPk>(dto);
            return BaseResult.Ok(info);
        }

        [HttpPost, Route("Save"),ControlName("盘库单保存")]
        public BaseResult Save([FromBody]WhReceiptPk model)
        {
            if (model.id == 0)
            {
                model.id = sequenceIdServer.getId();
                model.beginTime = sequenceIdServer.GetTime();
                model.status = 1;
                return BaseResult.Ok(receiptPkServer.insertNotNull(model));
            }
            else
            {
                return BaseResult.Ok(receiptPkServer.update(model));
            }
        }

        [HttpPost, Route("Delete"), ControlName("盘库单删除")]
        public BaseResult Delete([FromBody]List<WhReceiptPk> list)
        {
            return BaseResult.Ok(receiptPkServer.DeleteWhReceiptPk(list));
        }

        /// <summary>
        /// 生成任务
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        [HttpPost, Route("Generate"), ControlName("盘库生成任务")]
        public BaseResult Generate([FromBody]WhReceiptPk model)
        {
            string errorMsg = string.Empty;
            if (WMSTransactionFacade.doPkEngine(model,ref errorMsg))
            {
                return BaseResult.Ok("生成成功");
            }
            else
            {
                return BaseResult.Error(errorMsg);
            }
        }
    }
}