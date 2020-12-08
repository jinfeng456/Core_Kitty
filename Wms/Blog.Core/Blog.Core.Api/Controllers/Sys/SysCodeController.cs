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
    ///<summary>
    ///SysCode
    ///</summary>
    [Route("SysCode")]
    [Authorize]
    public class SysCodeController : ControllerBase
	 {
		readonly ISysCodeServices _sysCodeServices;
        readonly IUser _user;
		public SysCodeController(ISysCodeServices sysCodeServices, IUser user)
        {
            _sysCodeServices = sysCodeServices;
            _user = user;
        }

		/// <summary>
        /// 查询
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        // GET: api/User
        [HttpPost, Route("FindPage")]
        public async Task<BaseResult> FindPage([FromBody]SysCodeDto dto)
        {
            if (string.IsNullOrEmpty(dto.TableName) || string.IsNullOrWhiteSpace(dto.TableName))
            {
                dto.TableName = "";
            }
            var data = await _sysCodeServices.QueryPage(a => (a.TableName != null && a.TableName.Contains(dto.TableName)), dto.pageNum, dto.pageSize);
            return BaseResult.Ok(data);
        }

        /// <summary>
        /// 添加
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        // POST: api/User
        [HttpPost, Route("Save")]
        public async Task<BaseResult> Save([FromBody]SysCode model)
        {
            if (model.id == 0)
            {
                model.id = await _sysCodeServices.GetId(); 
                return BaseResult.Ok(await _sysCodeServices.Add(model));
            }
            else
            {
                return BaseResult.Ok(await _sysCodeServices.Update(model));
            }
        }


        /// <summary>
        /// 删除
        /// </summary>
        /// <param name="modelList"></param>
        /// <returns></returns>
        [HttpPost, Route("Delete")]
        public async Task<BaseResult> Delete([FromBody]List<SysCode> modelList)
        {
            foreach (var model in modelList)
            {
                await _sysCodeServices.Delete(model);
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
            return BaseResult.Ok(await _sysCodeServices.Query());
        }
	 }
}	 
