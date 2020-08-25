using GK.WMS.DAL;
using GK.WMS.Entity;
using HY.WCS.DAL.dto;
using System.Collections.Generic;
using System.Web.Http;
using Web.Authorize;
using WebApi.util;
using WMS.DAL;

namespace WebApi
{	
	/// <summary>
	/// StatRealController
	/// </summary>	
	[FormAuthenticationFilter]
	[RoutePrefix("statReal")]
	public class StatRealController : BaseApiController
    {
	    IStatRealServer statRealServer = WMSDalFactray.getDal<IStatRealServer>();
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();


        /// <summary>
        /// 制剂成品分类账(使用)
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPost, Route("FindPage")]
        public BaseResult FindPage([FromBody]StatRealDto dto)
        {
            var info = statRealServer.QueryStatRealPage(dto);          
            return  BaseResult.Ok(info);
        }

        /// <summary>
        /// 物料总账
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPost, Route("FindPageAll")]
        public BaseResult FindPageAll([FromBody]StatRealDto dto)
        {
            var info = statRealServer.QueryStatRealAllPage(dto);
            return BaseResult.Ok(info);
        }
    }
}

	