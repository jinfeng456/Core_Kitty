
using GK.Common;
using GK.Common.dto;
using GK.WMS.DAL;

using GK.WMS.Entity;
using GK.WMS.Entity.wms;
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

    [RoutePrefix("whSoOut")]
    public class WhSoOutController : BaseApiController
    {

        IWhSoOutServer whSoOutServer = WMSDalFactray.getDal<IWhSoOutServer>();
        [HttpPost, Route("FindPage")]
        public BaseResult FindPage([FromBody]WhSoOutDto dto)
        {
            Page<WhSoOut> info = whSoOutServer.QueryWhSoOutPage<WhSoOut>(dto);
            return BaseResult.Ok(info);
        }

        [HttpPost, Route("GetSoOutReceptList")]
        public BaseResult GetSoOutReceptList([FromBody]WhReceiptOut model)
        {
            List<WhSoOutReceipt> info = whSoOutServer.GetSoOutReceptList(model.id);
            return BaseResult.Ok(info);
        }
    }
}