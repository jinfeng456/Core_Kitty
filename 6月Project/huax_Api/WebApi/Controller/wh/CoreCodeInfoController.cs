using System;
using System.Web;
using System.Web.Http;
using Web.Authorize;
using System.Collections.Generic;
using GK.Common.dto;
using GK.Mongon.DAL;
using GK.Mongon;
using HY.WMS.DAL.dto;
using GK.Common.entity;
using GK.Mongo.Dto;
using GK.FMXT.DAL;
using GK.FMXT.DAL.dto;
using GK.FMXT.DAL.Entity;
using GK.WMS.Entity.wms;

namespace WebApi
{
    [FormAuthenticationFilter]
    [RoutePrefix("CoreCodeInfo")]
    public class CoreCodeInfoController : BaseApiController
    {
        [HttpPost, Route("FindPage")]
        public BaseResult FindPage([FromBody]CodeInfoDto dto)
        {
            Page<CoreCodeInfo> page = CodeInfoUtil.page(dto);
            return new BaseResult(page);
        }

        [HttpPost, Route("UpdateBarCode"),ControlName("修改条码")]
        public BaseResult UpdateBarCode([FromBody]CoreCodeInfo codeInfo)
        {
            return BaseResult.Ok(CodeInfoUtil.UpdateBarCode(codeInfo));
        }

        [HttpPost, Route("UpdateUpLoadStatus"), ControlName("修改上传状态")]
        public BaseResult UpdateUpLoadStatus()
        {
            return BaseResult.Ok(CodeInfoUtil.UpdateUploadStatus());
        }
    }
}
