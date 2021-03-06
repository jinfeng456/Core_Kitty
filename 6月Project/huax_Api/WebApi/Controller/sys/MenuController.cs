﻿using GK.WMS.DAL;
using GK.WMS.Entity;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Security.Principal;
using System.Web;
using System.Web.Http;
using System.Web.Security;

using Web.Authorize;
using WMS.DAL;

namespace WebApi
{
    //[FormAuthenticationFilter]
    [RoutePrefix("menu")]
    public class MenuController : BaseApiController
    {
        ISysAuthorityServer authorityServer = WMSDalFactray.getDal<ISysAuthorityServer>();
        
        [HttpPost, Route("Save"),ControlName("菜单保存")]
        public BaseResult Save([FromBody]SysMenu model)
        {
            if (model.id == 0)
            {
                return  BaseResult.Ok(authorityServer.AddMenu(model));
            }
            else
            {
                return  BaseResult.Ok(authorityServer.UpdateMenu(model));
            }
        }

        [HttpPost, Route("Delete"), ControlName("菜单删除")]
        public BaseResult Delete([FromBody]List<SysMenu> modelList)
        {
            return  BaseResult.Ok(authorityServer.DeleteMenu(modelList));
        }

        [HttpGet, Route("FindNavTree/{userName?}")]
        public BaseResult FindNavTree(string userName)
        {
            return new BaseResult(authorityServer.FindTree(userName, 1));
        }

        [HttpGet, Route("FindMenuTree")]
        public BaseResult FindMenuTree()
        {
            return new BaseResult(authorityServer.FindTree(null, 0));
        }
    }
}
