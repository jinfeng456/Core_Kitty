using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Blog.Core.AuthHelper.OverWrite;
using Blog.Core.Common.Helper;
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
    [Route("User")]
    //[ApiController]
    [Authorize] 
    public class SysUserController : ControllerBase
    {
        readonly ISysRoleServices _sysRoleServices;
        readonly ISysMenuServices _sysMenuServices;
        readonly ISysUserServices _sysUserServices;
        readonly ISysUserRoleServices _sysUserRoleServices;
        readonly IUser _user;


        public SysUserController(ISysUserRoleServices sysUserRoleServices, ISysUserServices sysUserServices, ISysRoleServices sysRoleServices, ISysMenuServices sysMenuServices, IUser user)
        {
            _sysUserRoleServices = sysUserRoleServices;
            _sysUserServices = sysUserServices;
            _sysRoleServices = sysRoleServices;
            _sysMenuServices = sysMenuServices;
            _user = user;
        }

        /// <summary>
        /// 获取全部角色
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        // POST: api/User
        [HttpPost, Route("FindPage")]
        public async Task<BaseResult> FindPage([FromBody]SysUserDto dto)
        {
            if (string.IsNullOrEmpty(dto.name) || string.IsNullOrWhiteSpace(dto.name))
            {
                dto.name = "";
            }
            var data = await _sysUserServices.QueryPage(a => (a.name != null && a.name.Contains(dto.name)), dto.pageNum, dto.pageSize, " id desc ");

            return BaseResult.Ok(data);

        }

        [HttpGet, Route("info")]
        public BaseResult info()
        {
            return new BaseResult("admin");
        }

        /// <summary>
        /// 添加用户
        /// </summary>
        /// <param name="SysUser"></param>
        /// <returns></returns>
        // POST: api/User
        [HttpPost, Route("Save")]
        public async Task<BaseResult> Save([FromBody]SysUser model)
        {
            if (model.id == 0)
            {
                model.id = _sysUserServices.GetId();
                model.createTime = DateTime.Now;
                model.createBy = _user.Name;
                model.lastUpdateBy = _user.Name;
                model.lastUpdateTime = DateTime.Now;
                return BaseResult.Ok(await _sysUserServices.Add(model));
            }
            else
            {
                model.lastUpdateBy = model.name;
                model.lastUpdateTime = DateTime.Now;
                await _sysUserServices.Update(model);
                await _sysUserRoleServices.Delete(a => a.userIds == model.id);
                foreach (var item in model.userRoles)
                {
                    item.id = _sysUserRoleServices.GetId();
                    item.createTime = DateTime.Now;
                    item.createBy = model.name;
                    item.lastUpdateBy = model.name;
                    item.lastUpdateTime = DateTime.Now;
                    item.userIds = model.id;
                }
                await _sysUserRoleServices.Add(model.userRoles);
            }
            return BaseResult.Ok("ok");
        }



        [HttpPost, Route("Delete")]
        public async Task<BaseResult> Delete([FromBody]List<SysUser> modelList)
        {
            foreach (var model in modelList)
            {
                await _sysUserServices.Delete(model);
            }
            return BaseResult.Ok("ok");
        }

        [HttpGet, Route("FindAll")]
        public async Task<BaseResult> FindAll()
        {
            return BaseResult.Ok(await _sysUserServices.Query());
        }

        [HttpGet, Route("FindPermissions")]
        public async Task<BaseResult> FindPermissions(string name)
        {
            List<string> perms = new List<string>();
            List<SysMenu> sysMenus = await _sysMenuServices.FindByUser(name);
            foreach (var sysMenu in sysMenus)
            {
                if (!string.IsNullOrEmpty(sysMenu.perms))
                {
                    perms.Add(sysMenu.perms);
                }
            }
            return BaseResult.Ok(perms);
        }

        // GET: api/User/5
        /// <summary>
        /// 获取用户详情根据token
        /// 【无权限】
        /// </summary>
        /// <param name="token">令牌</param>
        /// <returns></returns>
        [HttpGet]
        [AllowAnonymous]
        public async Task<BaseResult> GetInfoByToken(string token)
        {
            if (!string.IsNullOrEmpty(token))
            {
                var tokenModel = JwtHelper.SerializeJwt(token);
                if (tokenModel != null && tokenModel.Uid > 0)
                {
                    var userinfo = await _sysUserServices.QueryById(tokenModel.Uid);
                    if (userinfo != null)
                    {
                        return BaseResult.Ok(userinfo);
                    }
                }

            }
            return BaseResult.Error("token失效"); ;
        }
    }
}
