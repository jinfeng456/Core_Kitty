﻿
using Common.dto;
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
using WMS.DAL;
using WMS.Entity;

namespace WebApi
{
    [FormAuthenticationFilter]

    [RoutePrefix("CoreTask")]
    public class CoreTaskController : BaseApiController
    {
        ICoreTaskServer authorityServer = WMSDalFactray.getDal<ICoreTaskServer>();

        [HttpPost, Route("FindPage")]
        public BaseResult FindPage([FromBody]CoreTaskDto dto)
        {
            Page<CoreTask> info = authorityServer.QueryCoreTaskPage<CoreTask>(dto);
            return BaseResult.Ok(info);
        }

        [HttpPost, Route("GetListByTaskId")]
        public BaseResult GetListByTaskId(CoreTask model)
        {
            return BaseResult.Ok(authorityServer.GetListByTaskId(model.id));
        }
    }
}