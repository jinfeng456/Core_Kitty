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

namespace Blog.Core.Api.Controllers
{
	[Route("CoreItem")]
    [Authorize]
     public class CoreItemController : ControllerBase
    {
         private readonly ICoreItemServices _coreItemServices;
         readonly IUser _user;
         public CoreItemController(ICoreItemServices coreItemServices, IUser user)
         {
            _coreItemServices = coreItemServices;
            _user = user;
         }
            
         /// <summary>
         /// 查询
         /// </summary>
         /// <param name="dto"></param>
         /// <returns></returns>
         ///  Post: CoreItem
         [HttpPost, Route("FindPage")]  
         public async Task<BaseResult> FindPage([FromBody]CoreItemDto dto)
         {
            if (string.IsNullOrEmpty(dto.dictClassName) || string.IsNullOrWhiteSpace(dto.dictClassName))
            {
                dto.dictClassName = "";
            }
            var data = await _coreItemServices.QueryPage(a => (a.DictClassName != null && a.DictClassName.Contains(dto.dictClassName)), dto.pageNum, dto.pageSize, " createTime desc ");
            return BaseResult.Ok(data);
         } 
        /// <summary>
        /// 添加
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        ///  POST: CoreItem
        [HttpPost, Route("Save")]
        public async Task<BaseResult> Save([FromBody]CoreItem model)
        {
            if (model.Id == 0)
            {
                model.Id = await _coreItemServices.GetId();
                model.CreateTime = DateTime.Now;
                model.CreateBy = _user.Name;
                model.LastUpdateBy = _user.Name;
                model.LastUpdateTime = DateTime.Now;
                return BaseResult.Ok(await _coreItemServices.Add(model));                   
            }
            else
            {
                model.LastUpdateBy = _user.Name;
                model.LastUpdateTime = DateTime.Now;
                return BaseResult.Ok(await _coreItemServices.Update(model));
            }
        }
        /// <summary>
        /// 删除
        /// </summary>
        /// <param name="modelList"></param>
        /// <returns></returns>
        [HttpPost, Route("Delete")]
        public async Task<BaseResult> Delete([FromBody]List<CoreItem> modelList)
        {
            foreach (var model in modelList)
            {
                await _coreItemServices.Delete(model);
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
            return BaseResult.Ok(await _coreItemServices.Query());
        }
    }   
}