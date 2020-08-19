using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Blog.Core.Common.HttpContextUser;
using Blog.Core.IServices;
using Blog.Core.Model;
using Blog.Core.Model.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

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
        /// <param name="dto">物料分类</param>
        /// <returns></returns>
        // GET: api/User
        [HttpPost, Route("FindPage")]
        public async Task<BaseResult> FindPage([FromBody]CoreItemDto dto)
        {
            if (string.IsNullOrEmpty(dto.name) || string.IsNullOrWhiteSpace(dto.name))
            {
                dto.name = "";
            }
            var data = await _coreItemServices.QueryPage(a => (a.name != null && a.name.Contains(dto.name)), dto.pageNum, dto.pageSize, " id desc ");
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
        /// <param name="CoreItem"></param>
        /// <returns></returns>
        // POST: api/User
        [HttpPost, Route("Save")]
        public async Task<BaseResult> Save([FromBody]CoreItem model)
        {
            if (model.id == 0)
            {
                model.id = _coreItemServices.GetId();
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
        public async Task<BaseResult> Delete([FromBody]List<CoreItem> modelList)
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
        /// <param name="CoreItem"></param>
        /// <returns></returns>
        // POST: api/User
        [HttpPost, Route("Restore")]
        public async Task<BaseResult> Restore([FromBody]CoreItem model)
        {
            return BaseResult.Ok(await _coreItemServices.Update(model));
        }


        /// <summary>
        /// 物料禁用
        /// </summary>
        /// <param name="CoreItem"></param>
        /// <returns></returns>
        // POST: api/User
        [HttpPost, Route("Disable")]
        public async Task<BaseResult> Disable([FromBody]CoreItem model)
        {
            return BaseResult.Ok(await _coreItemServices.Update(model));
        }


        /// <summary>
        /// 导入物料
        /// </summary>
        /// <param name="CoreItem"></param>
        /// <returns></returns>
        // POST: api/User
        [HttpPost, Route("ImportList")]
        public BaseResult ImportList([FromBody]List<CoreItem> coreItemList)
        {
            string message = string.Empty;
            bool result =  _coreItemServices.ImportList(coreItemList,out message);
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
