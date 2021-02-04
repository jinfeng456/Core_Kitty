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
using Microsoft.AspNetCore.Authorization;
using System.Linq.Expressions;

namespace Blog.Core.Api.Controllers
{
	[Route("OperateLog")]
    [Authorize]
     public class OperateLogController : ControllerBase
    {
         private readonly IOperateLogServices _operateLogServices;
         readonly IUser _user;
         public OperateLogController(IOperateLogServices operateLogServices, IUser user)
         {
            _operateLogServices = operateLogServices;
            _user = user;
         }
            
         /// <summary>
         /// 查询
         /// </summary>
         /// <param name="dto"></param>
         /// <returns></returns>
         ///  Post: OperateLog
         [HttpPost, Route("FindPage")]  
         public async Task<BaseResult> FindPage([FromBody]OperateLogDto dto)
         {
            Expression<Func<OperateLog, bool>> whereExpression = a => true;
            if (dto.name.IsNotEmptyOrNull())
            {
                whereExpression = ExpressionHelp.And(whereExpression, a => a.name.Contains(dto.name));
            }
            var data = await _operateLogServices.QueryPage(whereExpression, dto.pageNum, dto.pageSize, " createTime desc ");
            return BaseResult.Ok(data);
         } 
        /// <summary>
        /// 添加
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        ///  POST: OperateLog
        [HttpPost, Route("Save")]
        public async Task<BaseResult> Save([FromBody]OperateLog model)
        {
            if (model.Id == 0)
            {
                model.Id = await _operateLogServices.GetId();
                model.CreateTime = DateTime.Now;
                model.CreateBy = _user.Name;
                model.LastUpdateBy = _user.Name;
                model.LastUpdateTime = DateTime.Now;
                return BaseResult.Ok(await _operateLogServices.Add(model));                   
            }
            else
            {
                model.LastUpdateBy = _user.Name;
                model.LastUpdateTime = DateTime.Now;
                return BaseResult.Ok(await _operateLogServices.Update(model));
            }
        }
        /// <summary>
        /// 删除
        /// </summary>
        /// <param name="modelList"></param>
        /// <returns></returns>
        [HttpPost, Route("Delete")]
        public async Task<BaseResult> Delete([FromBody]List<OperateLog> modelList)
        {
            foreach (var model in modelList)
            {
                await _operateLogServices.Delete(model);
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
            return BaseResult.Ok(await _operateLogServices.Query());
        }
    }   
}