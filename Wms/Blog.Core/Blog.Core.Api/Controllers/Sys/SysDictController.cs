using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
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
    /// 字典管理
    /// </summary>
    [Route("dict")]
    //[ApiController]
    [Authorize]
    public class SysDictController : ControllerBase
    {
        readonly ISysDictServices _sysDictServices;
        readonly ISysDictClassServices _sysDictClassServices;
        readonly IUser _user;


        public SysDictController(ISysDictServices sysDictServices, IUser user, ISysDictClassServices sysDictClassServices)
        {
            _sysDictClassServices = sysDictClassServices;
            _sysDictServices = sysDictServices;
            _user = user;
        }

        /// <summary>
        /// 查询字典
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        // GET: api/User
        [HttpPost, Route("FindPage")]
        public async Task<BaseResult> FindPage([FromBody]SysDictDto dto)
        {
            Expression<Func<SysDict, bool>> whereExpression = (a) => true;
            if (dto.label.IsNotEmptyOrNull())
            {
                whereExpression = ExpressionHelp.And(whereExpression, a => (a.label != null && a.label.Contains(dto.label)));
            }
            if (dto.dictClassId > 0)
            {
                whereExpression = ExpressionHelp.And(whereExpression, a => a.dictClassId == dto.dictClassId);
            }
            var data = await _sysDictServices.QueryPage(whereExpression, dto.pageNum, dto.pageSize, " createTime desc ");
            return BaseResult.Ok(data);

        }

        /// <summary>
        /// 添加字典
        /// </summary>
        /// <param name="model">字典实体</param>
        /// <returns></returns>
        // POST: api/User
        [HttpPost, Route("Save")]
        public async Task<BaseResult> Save([FromBody]SysDict model)
        {
            if (model.id == 0)
            {
                if (model.dictClassId != 0)
                {
                    model.dtype = (await _sysDictClassServices.QueryById(model.dictClassId)).dictClassName;
                }
                model.id = _sysDictServices.GetId();
                model.createTime = DateTime.Now;
                model.createBy = _user.Name;
                model.lastUpdateBy = _user.Name;
                model.lastUpdateTime = DateTime.Now;
                return BaseResult.Ok(await _sysDictServices.Add(model));
            }
            else
            {
                if (model.dictClassId != 0)
                {
                    model.dtype = (await _sysDictClassServices.QueryById(model.dictClassId)).dictClassName;
                }
                model.lastUpdateBy = _user.Name;
                model.lastUpdateTime = DateTime.Now;
                return BaseResult.Ok(await _sysDictServices.Update(model));
            }
        }


        /// <summary>
        /// 删除字典
        /// </summary>
        /// <param name="modelList"></param>
        /// <returns></returns>
        [HttpPost, Route("Delete")]
        public async Task<BaseResult> Delete([FromBody]List<SysDict> modelList)
        {
            foreach (var model in modelList)
            {
                await _sysDictServices.Delete(model);
            }
            return BaseResult.Ok("ok");
        }

        /// <summary>
        /// 获取全部不分页
        /// </summary>
        /// <returns></returns>
        [HttpPost, Route("GetAllDicts")]
        public async Task<BaseResult> GetAllDicts()
        {
            return BaseResult.Ok(await _sysDictServices.Query());
        }
    }
}
