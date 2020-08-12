using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Blog.Core.Common.HttpContextUser;
using Blog.Core.IServices;
using Blog.Core.Model;
using Blog.Core.Model.Models;
using Blog.Core.Model.ViewModels;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Blog.Core.Controllers
{
    /// <summary>
    /// 菜单管理
    /// </summary>
    [Route("role")]
    //[ApiController]
    [Authorize]
    public class SysRoleController : ControllerBase
    {
        readonly ISysRoleServices _sysRoleServices;
        readonly ISysMenuServices _sysMenuServices;
        readonly IUser _user;


        public SysRoleController(ISysRoleServices sysRoleServices, ISysMenuServices sysMenuServices, IUser user)
        {
            _sysRoleServices = sysRoleServices;
            _sysMenuServices = sysMenuServices;
            _user = user;
        }

        /// <summary>
        /// 获取全部角色
        /// </summary>
        /// <param name="page"></param>
        /// <param name="key"></param>
        /// <returns></returns>
        // GET: api/User
        [HttpPost, Route("FindPage")]
        public async Task<BaseResult> FindPage([FromBody]SysRoleDto dto)
        {
            if (string.IsNullOrEmpty(dto.name) || string.IsNullOrWhiteSpace(dto.name))
            {
                dto.name = "";
            }

            var data = await _sysRoleServices.QueryPage(a => (a.name != null && a.name.Contains(dto.name)), dto.pageNum, dto.pageSize, " id desc ");

            return BaseResult.Ok(data);

        }

        /// <summary>
        /// 添加角色
        /// </summary>
        /// <param name="SysRole"></param>
        /// <returns></returns>
        // POST: api/User
        [HttpPost, Route("Save")]
        public async Task<BaseResult> Save([FromBody]SysRole model)
        {
            if (model.id == 0)
            {
                List<SysRole> modelList = await _sysRoleServices.Query(a => a.name == model.name);
                if (modelList != null && modelList.Count > 0)
                {
                    return BaseResult.Error("角色已存在!");
                }
                model.id = _sysRoleServices.GetId();
                model.createTime = DateTime.Now;
                model.createBy = _user.Name;
                model.lastUpdateBy = _user.Name;
                model.lastUpdateTime = DateTime.Now;
                return BaseResult.Ok(await _sysRoleServices.Add(model));
            }
            else
            {
                //限制了管理员的权限不允许修改，开发中先注释
                if (model.name.Equals("admin"))
                {
                    return BaseResult.Error("超级管理员不允许修改!");
                }
                model.lastUpdateBy = _user.Name;
                model.lastUpdateTime = DateTime.Now;
                return BaseResult.Ok(await _sysRoleServices.Update(model));
            }
        }



        [HttpPost, Route("Delete")]
        public async Task<BaseResult> Delete([FromBody]List<SysRole> modelList)
        {
            if (modelList.Exists(a => a.name == "admin"))
            {
                return BaseResult.Error("超级管理员不允许删除!");
            }
            foreach (var model in modelList)
            {
                await _sysRoleServices.Delete(model);
            }
            return BaseResult.Ok("ok");
        }

        [HttpGet, Route("FindAll")]
        public async Task<BaseResult> FindAll()
        {
            return BaseResult.Ok(await _sysRoleServices.Query());
        }

        [HttpGet, Route("FindRoleMenus")]
        public async Task<BaseResult> FindRoleMenus(long roleId)
        {
            return BaseResult.Ok(await _sysMenuServices.FindRoleMenus(roleId));
        }


        [HttpGet, Route("FindUserRole")]
        public async Task<BaseResult> FindUserRole(long userId)
        {
            return BaseResult.Ok(await _sysRoleServices.FindUserRole(userId));
        }

    }
}
