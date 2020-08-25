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
    /// 字典分类管理
    /// </summary>
    [Route("dictClass")]
    //[ApiController]
    [Authorize]
    public class SysDictClassController : ControllerBase
    {
        readonly ISysDictClassServices _sysDictClassServices;
        readonly IUser _user;


        public SysDictClassController(ISysDictClassServices sysDictClassServices, IUser user)
        {
            _sysDictClassServices = sysDictClassServices;
            _user = user;
        }

        /// <summary>
        /// 查询字典分类
        /// </summary>
        /// <param name="dto">字典分类</param>
        /// <returns></returns>
        // GET: api/User
        [HttpPost, Route("FindPage")]
        public async Task<BaseResult> FindPage([FromBody]SysDictClassDto dto)
        {
            if (string.IsNullOrEmpty(dto.dictClassName) || string.IsNullOrWhiteSpace(dto.dictClassName))
            {
                dto.dictClassName = "";
            }
            var data = await _sysDictClassServices.QueryPage(a => (a.dictClassName != null && a.dictClassName.Contains(dto.dictClassName)), dto.pageNum, dto.pageSize, " createTime desc ");
            return BaseResult.Ok(data);
        }

        /// <summary>
        /// 添加字典分类
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        // POST: api/User
        [HttpPost, Route("Save")]
        public async Task<BaseResult> Save([FromBody]SysDictClass model)
        {
            if (model.id == 0)
            {
                model.id = await _sysDictClassServices.GetId();
                model.createTime = DateTime.Now;
                model.createBy = _user.Name;
                model.lastUpdateBy = _user.Name;
                model.lastUpdateTime = DateTime.Now;
                return BaseResult.Ok(await _sysDictClassServices.Add(model));
            }
            else
            {
                model.lastUpdateBy = _user.Name;
                model.lastUpdateTime = DateTime.Now;
                return BaseResult.Ok(await _sysDictClassServices.Update(model));
            }
        }


        /// <summary>
        /// 删除字典分类
        /// </summary>
        /// <param name="modelList"></param>
        /// <returns></returns>
        [HttpPost, Route("Delete")]
        public async Task<BaseResult> Delete([FromBody]List<SysDictClass> modelList)
        {
            foreach (var model in modelList)
            {
                await _sysDictClassServices.Delete(model);
            }
            return BaseResult.Ok("ok");
        }

        /// <summary>
        /// 查询全部
        /// </summary>
        /// <returns></returns>
        [HttpPost, Route("GetAllList")]
        public async Task<BaseResult> GetAllList()
        {
            return BaseResult.Ok(await _sysDictClassServices.Query());
        }
    }
}
