
using GK.Common;
using GK.Common.dto;
using GK.WMS.DAL;
using GK.WMS.Entity;
using GK.WMS.Entity.dto;
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

    [RoutePrefix("CoreStock")]
    public class CoreStockController : BaseApiController
    {
        ICoreStockServer authorityServer = WMSDalFactray.getDal<ICoreStockServer>();
        IBatchServer batchServer = WMSDalFactray.getDal<IBatchServer>();
        [HttpPost, Route("FindPage")]
        public BaseResult FindPage([FromBody]CoreStockDto dto)
        {
            Page<CoreStock> info = authorityServer.QueryCoreStockPage(dto);
            return BaseResult.Ok(info);
        }

        [HttpPost, Route("GetListByStockId")]
        public BaseResult GetListByStockId(CoreStock model)
        {
            return BaseResult.Ok(authorityServer.GetListByStockId(model.id));
        }
        //库存明细查询
        [HttpPost, Route("QueryCoreDetailPage")]
        public BaseResult QueryCoreDetailPage(CoreStockDto dto)
        {
            Page<CoreStockParam> info = authorityServer.QueryCoreDetailPage(dto);
            return BaseResult.Ok(info);
        }

        //库存明细查询
        [HttpPost, Route("QueryRealCoreDetailPage")] 
        public BaseResult QueryRealCoreDetailPage(CoreStockDto dto)
        {
            Page<CoreStockParam> info = authorityServer.QueryRealCoreDetailPage(dto);
            return BaseResult.Ok(info);
        }

        //托盘绑定的时候显示的库存明细
        [HttpPost, Route("QueryCoreStockDetailPage")] 
        public BaseResult QueryCoreStockDetailPage(CoreStockDto dto)
        {
            Page<CoreStockDetail> info = authorityServer.QueryCoreStockDetailPage(dto);
            return BaseResult.Ok(info);
        }

        [HttpPost, Route("UpdateRecepitOutId"),ControlName("托盘绑定")]
        public BaseResult UpdateRecepitOutId([FromBody]ReceiptAddDto dto)
        {
            //if (dto.id==0)
            //{
            //    return BaseResult.Error(500,"请选中行明细");
            //}
            return BaseResult.Ok(authorityServer.UpdateRecepitOutId(dto));
        }
        [HttpPost, Route("UpdatePriorityByCoreId"), ControlName("修改优先级")]
        public BaseResult UpdatePriorityByCoreId([FromBody]CoreStockDto model)
        {
            bool result2 = authorityServer.UpdatePriorityById(model);
            WhBatch whModel = new WhBatch();
            whModel.id =(long) model.batchId;
            whModel.Priority = model.priority;
            bool result = batchServer.UpdatePriority(whModel);          
            return BaseResult.Ok(result);
        }
    }
}