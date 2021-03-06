﻿using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Threading.Tasks;
using Blog.Core.Common.HttpContextUser;
using Blog.Core.IServices;
using Blog.Core.Model;
using Blog.Core.Model.Models;
using Blog.Core.Model.ViewModels;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SqlSugar;

namespace Blog.Core.Controllers
{
    /// <summary>
    /// 物料管理
    /// </summary>
    [Route("item")]
    [Authorize]
    public class CoreItemController : ControllerBase
    {
        readonly ICoreItemServices _coreItemServices;
        readonly IUser _user;


        public CoreItemController(ICoreItemServices coreItemServices, IUser user)
        {
            _coreItemServices = coreItemServices;
            _user = user;
        }

        /// <summary>
        /// 查询物料信息
        /// </summary>
        /// <param name="dto">物料名称</param>
        /// <returns></returns>
        // GET: api/User
        [HttpPost, Route("FindPage")]
        public async Task<BaseResult> FindPage([FromBody] CoreItemDto dto)
        {
            Expression<Func<CoreItem, CoreClassify, SysDict, bool>> whereExpression = (ci, cc, sd) => true;
            if (dto.name.IsNotEmptyOrNull())
            {
                whereExpression = ExpressionHelp.And(whereExpression, (ci, cc, sd) => ci.name.Contains(dto.name));
            }
            if (dto.modelSpecs.IsNotEmptyOrNull())
            {
                whereExpression = ExpressionHelp.And(whereExpression, (ci, cc, sd) => ci.modelSpecs.Contains(dto.modelSpecs));
            }
            if (dto.classifyId > 0)
            {
                whereExpression = ExpressionHelp.And(whereExpression, (ci, cc, sd) => ci.classifyId == dto.classifyId);
            }
            if (dto.coreItemType > 0)
            {
                whereExpression = ExpressionHelp.And(whereExpression, (ci, cc, sd) => ci.coreItemType == dto.coreItemType);
            }
            if (dto.code.IsNotEmptyOrNull())
            {
                whereExpression = ExpressionHelp.And(whereExpression, (ci, cc, sd) => ci.code.Contains(dto.code));
            }
            var data = await _coreItemServices.QueryMuchPage(
               (ci, cc, sd) => new object[] {
                    JoinType.Left, ci.classifyId == cc.id,
                    JoinType.Left, ci.coreItemType == sd.Value && sd.Dtype=="coreItemType"
               },
               (ci, cc, sd) => new
               {
                   ci.id,
                   ci.name,
                   ci.code,
                   ci.classifyId,
                   ci.active,
                   ci.coreItemType,
                   ci.modelSpecs,
                   ci.packageSpecs,
                   cc.info,
                   classifyName = cc.name,
                   coreItemTypeName = sd.Label
               },
               whereExpression, dto.pageNum, dto.pageSize
               );
            return BaseResult.Ok(data);
        }


        [HttpPost, Route("findAll")]
        public async Task<BaseResult> FindAll()
        {
            return BaseResult.Ok(await _coreItemServices.Query());
        }

        /// <summary>
        /// 添加物料
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        // POST: api/User
        [HttpPost, Route("Save")]
        public async Task<BaseResult> Save([FromBody] CoreItem model)
        {
            if (model.id == 0)
            {
                model.id = await _coreItemServices.GetId();
                return BaseResult.Ok(await _coreItemServices.Add(model));
            }
            else
            {
                return BaseResult.Ok(await _coreItemServices.Update(model));
            }
        }


        /// <summary>
        /// 删除物料
        /// </summary>
        /// <param name="modelList"></param>
        /// <returns></returns>
        [HttpPost, Route("Delete")]
        public async Task<BaseResult> Delete([FromBody] List<CoreItem> modelList)
        {
            foreach (var model in modelList)
            {
                await _coreItemServices.Delete(model);
            }
            return BaseResult.Ok("ok");
        }

        /// <summary>
        /// 物料恢复
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        // POST: api/User
        [HttpPost, Route("Restore")]
        public async Task<BaseResult> Restore([FromBody] CoreItem model)
        {
            return BaseResult.Ok(await _coreItemServices.Update(model));
        }


        /// <summary>
        /// 物料禁用
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        // POST: api/User
        [HttpPost, Route("Disable")]
        public async Task<BaseResult> Disable([FromBody] CoreItem model)
        {
            return BaseResult.Ok(await _coreItemServices.Update(model));
        }


        /// <summary>
        /// 导入物料
        /// </summary>
        /// <param name="coreItemList"></param>
        /// <returns></returns>
        // POST: api/User
        [HttpPost, Route("ImportList")]
        public async Task<BaseResult> ImportList([FromBody] List<CoreItem> coreItemList)
        {
            RefAsync<string> message = string.Empty;
            bool result = await _coreItemServices.ImportList(coreItemList, message);
            if (result)
            {
                return BaseResult.Ok("操作成功!");
            }
            else
            {
                return BaseResult.Error(message);
            }
        }
    }
}
