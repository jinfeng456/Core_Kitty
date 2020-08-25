using GK.WMS.DAL;
using GK.WMS.Entity;
using HY.WCS.DAL.dto;
using System.Collections.Generic;
using System.Web.Http;
using Web.Authorize;
using WMS.DAL;

namespace WebApi
{	
	/// <summary>
	/// StatMonthController
	/// </summary>	
	[FormAuthenticationFilter]
	[RoutePrefix("statMonth")]
	public class StatMonthController : BaseApiController
    {
	    IStatMonthServer statMonthServer = WMSDalFactray.getDal<IStatMonthServer>();
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();

        [HttpPost, Route("FindPage")]
        public BaseResult FindPage([FromBody]StatMonthDto dto)
        {
            var info = statMonthServer.QueryStatMonthPage(dto);          
            return  BaseResult.Ok(info);
        }

        [HttpPost, Route("GetAllList")]
        public BaseResult GetAllList( )
        {         
            return  BaseResult.Ok(statMonthServer.GetAll<StatMonth>());
        }
       
    }
}

	