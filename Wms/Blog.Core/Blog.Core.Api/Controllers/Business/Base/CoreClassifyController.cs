using Blog.Core.Controllers;
using Blog.Core.IServices;
using Blog.Core.Model;
using Blog.Core.Model.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Linq.Expressions;
using System.Threading.Tasks;

namespace Blog.Core.Api.Controllers
{
    [Route("classify")]
    [Authorize]
    public class CoreClassifyController : ControllerBase
    {
        /// <summary>
        /// 服务器接口，因为是模板生成，所以首字母是大写的，自己可以重构下
        /// </summary>
        private readonly ICoreClassifyServices _coreClassifyServices;

        public CoreClassifyController(ICoreClassifyServices CoreClassifyServices)
        {
            _coreClassifyServices = CoreClassifyServices;
        }
        //[HttpPost, Route("FindPage")]
        //public async Task<BaseResult> FindPage([FromBody]CoreClassifyDto dto)

        //{
        //    if (string.IsNullOrEmpty(dto.name) || string.IsNullOrWhiteSpace(dto.name))
        //    {
        //        dto.name = "";
        //    }
        //    Expression<Func<CoreClassify, bool>> whereExpression = a => (a.name != null && a.name.Contains(dto.name));
        //    var data = await _coreClassifyServices.QueryPage(whereExpression, dto.pageNum, dto.pageSize, " id desc ");
        //    return BaseResult.Ok(data);
        //}

        /// <summary>
        /// 查询物料分类
        /// </summary>
        /// <param name="dto">物料分类</param>
        /// <returns></returns>
        // GET: api/User
        [HttpPost, Route("FindPage")]
        public async Task<BaseResult> FindPage()
        {
            int pageNum = 1;
            int pageSize = 1000;
            var data = await _coreClassifyServices.QueryPage(null, pageNum, pageSize, " id desc ");
            return BaseResult.Ok(data);
        }
    }
}