﻿using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web;
using System.Web.Http;
using System.Web.Security;
using Web.Authorize;

using Newtonsoft.Json;
using System.Data;
using GK.WMS.Entity;
using GK.WMS.DAL;
using HY.WCS.DAL.dto;
using WMS.DAL;

namespace WebApi
{
    [FormAuthenticationFilter]
    [RoutePrefix("role")]
    public class RolesController : BaseApiController
    {
        ISysAuthorityServer authorityServer = WMSDalFactray.getDal<ISysAuthorityServer>();

        [HttpPost, Route("FindPage")]
        public BaseResult FindPage([FromBody]RoleDto dto)
        {         
            var info = authorityServer.QueryRolePage<SysRole>(dto);         
            return  BaseResult.Ok(info);
        }

        [HttpPost, Route("Save"),ControlName("角色保存")]
        public BaseResult Save([FromBody]SysRole model)
        {
            if (model.id == 0)
            {
                List<SysRole> modelList = authorityServer.FindRoleByName(model.name);
                if (modelList != null && modelList.Count > 0)
                {
                    return  BaseResult.Error("角色已存在!");
                }
                return  BaseResult.Ok(authorityServer.AddRole(model));
            }
            else
            {
                //限制了管理员的权限不允许修改，开发中先注释
                SysRole role = authorityServer.FindRoleById(model.id);
                if (role != null)
                {
                    if (role.name.Equals("admin"))
                    {
                        return  BaseResult.Error("超级管理员不允许修改!");
                    }
                }
                return BaseResult.Ok(authorityServer.UpdateRole(model));
            }
        }

        [HttpPost, Route("Delete"), ControlName("角色删除")]
        public BaseResult Delete([FromBody]List<SysRole> modelList)
        {
            foreach (var item in modelList)
            {
                SysRole model = authorityServer.FindRoleById(item.id);
                if (model != null && model.name.Equals("admin"))
                {
                    return BaseResult.Error("超级管理员不允许删除!");
                }
            }
            return BaseResult.Ok(authorityServer.DeleteRole(modelList));
        }

        [HttpGet, Route("FindAll")]
        public BaseResult FindAll()
        {
            return BaseResult.Ok(authorityServer.FindAllRole());
        }

        [HttpGet, Route("FindRoleMenus")]
        public BaseResult FindRoleMenus(long roleId)
        {
            return BaseResult.Ok(authorityServer.FindRoleMenus(roleId));
        }

        [HttpGet, Route("FindUserRole")]
        public BaseResult FindUserRole(long userId)
        {
            return BaseResult.Ok(authorityServer.FindUserRole(userId));
        }

        [HttpPost, Route("SaveRoleMenus"), ControlName("角色分配菜单")]
        public BaseResult SaveRoleMenus([FromBody]List<SysRoleMenu> modelList)
        {
            //限制了管理员的权限不允许修改，开发中先注释
            //foreach (var model in modelList)
            //{
            //    SysRole sysRole = authorityServer.FindRoleById(model.id);
            //    if (sysRole != null && sysRole.name.Equals("admin"))
            //    {
            //        // 如果是超级管理员，不允许修改
            //        return new BaseResult().Error(500, "超级管理员拥有所有菜单权限，不允许修改！");
            //    }
            //}
            return BaseResult.Ok(authorityServer.SaveRoleMenus(modelList));
        }

    }
}
