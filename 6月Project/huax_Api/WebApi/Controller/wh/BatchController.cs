
using GK.Common;
using GK.Common.dto;
using GK.Engine.WMS.wms;
using GK.WMS.DAL;

using GK.WMS.Entity;
using HY.WCS.DAL;
using HY.WCS.DAL.dto;
using HY.WCS.Entity.dto;
using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;
using System.Web;


using System.Web.Http;
using System.Web.Http.Cors;
using Web.Authorize;

namespace WebApi
{
    [FormAuthenticationFilter]

    [RoutePrefix("Batch")]
    public class BatchController : BaseApiController
    {
        IBatchServer authorityServer = WMSDalFactray.getDal<IBatchServer>();
        ICoreStockServer coreStockServer = WMSDalFactray.getDal<ICoreStockServer>();

        [HttpPost, Route("FindPage")]
        public BaseResult FindPage([FromBody]BatchDto dto)
        {
            Page<WhBatch> info = authorityServer.QueryBatchPage<WhBatch>(dto);
            return BaseResult.Ok(info);
        }

        [HttpPost, Route("Save"), ControlName("批次保存")]
        public BaseResult Save([FromBody]WhBatch model)
        {
            //批次只有修改一种情况
            authorityServer.updateNotNull<WhBatch>(model);
            coreStockServer.UpdateRbussinessByBatchId(model.id, model.businessStatus ?? 0);
            return BaseResult.Ok("ok");
        }
        //平库出库

        //[HttpGet, Route("FlatOut/{id}/{finshCount}/{remark?}")]
        [HttpPost, Route("FlatOut")]
        public BaseResult FlatOut([FromBody]WhReceiptOutDetail model)
        {
            string  errorMsg="";
            long id=model.id;
            int? finshCount=model.finshCount;
            string remark=model.remark;
            bool result = WMSTransactionFacade.doSyncFlatOutReult(id,finshCount,remark, ref errorMsg);
            if (result)
            {
                return BaseResult.Ok("ok");
            }
            else
            {
                return BaseResult.Error();
            }
            
        }
        /// <summary>
        /// 同步赋码系统批次
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        [HttpPost, Route("Synchronization"), ControlName("同步赋码系统批次")]
        public BaseResult Synchronization()
        {
            var message = authorityServer.Synchronization().Split(',');
            if (message[0] == "500")
            {
                return BaseResult.Error(message[1]);
            }
            else
            {
                return BaseResult.Ok(message[1]);
            }
        }

        [HttpPost, Route("FindBatchReport"), ControlName("批次报表查询")]
        public BaseResult FindBatchReport([FromBody]BatchDto dto)
        {
            Page<BatchReportDto> info = authorityServer.QueryBatchReportPage<BatchReportDto>(dto);
            return BaseResult.Ok(info);
        }

        [HttpPost, Route("UpdatePriority"), ControlName("修改优先级")]
        public BaseResult UpdatePriority([FromBody]WhBatch model)
        {
            bool result = authorityServer.UpdatePriority(model);
            //long coreDetailId = coreStockServer.GetByBatchId(model.id);
            CoreStockDetail coreModel = new CoreStockDetail();
            coreModel.batchId = model.id;
            coreModel.Priority = model.Priority;
            bool result2 = coreStockServer.UpdatePriority(coreModel);
            return BaseResult.Ok(result);
        }
    }
}