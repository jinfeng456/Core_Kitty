using Blog.Core.IServices;
using Blog.Core.Model;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
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