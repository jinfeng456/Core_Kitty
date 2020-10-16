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
    [Route("menu")]
    //[ApiController]
    [Authorize]
    public class SysMenuController : ControllerBase
    {
        readonly ISysMenuServices _sysMenuServices;
        readonly IUser _user;


        public SysMenuController(ISysMenuServices sysMenuServices, IUser user)
        {
            _sysMenuServices = sysMenuServices;
            _user = user;
        }


        /// <summary>
        /// 添加菜单
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        // POST: api/User
        [HttpPost, Route("Save")]
        public async Task<BaseResult> Save([FromBody]SysMenu model)
        {
            if (model.id == 0)
            {
                model.id = await _sysMenuServices.GetId();
                model.CreateTime = DateTime.Now;
                model.CreateBy = _user.Name;
                model.LastUpdateBy = _user.Name;
                model.LastUpdateTime = DateTime.Now;
                return BaseResult.Ok(await _sysMenuServices.Add(model));
            }
            else
            {
                model.LastUpdateBy = _user.Name;
                model.LastUpdateTime = DateTime.Now;
                return BaseResult.Ok(await _sysMenuServices.Update(model));
            }
        }


        
        [HttpPost, Route("Delete")]
        public async Task<BaseResult> Delete([FromBody]List<SysMenu> modelList)
        {
            foreach (var model in modelList)
            {
                await _sysMenuServices.Delete(model);
            }
            return BaseResult.Ok("ok");
        }

        [HttpGet, Route("FindNavTree/{userName?}")] //{userName?}
        public async Task<BaseResult> FindNavTree(string userName)
        {
            var info = await _sysMenuServices.FindTree(userName, 1);
            return  BaseResult.Ok(await _sysMenuServices.FindTree(userName, 1));
        }

        [HttpGet, Route("FindMenuTree")]
        public async Task<BaseResult> FindMenuTree()
        {
            return  BaseResult.Ok(await _sysMenuServices.FindTree(null, 0));
        }


    }
}
