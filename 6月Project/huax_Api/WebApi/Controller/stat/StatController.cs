using Common.dto;
using GK.WMS.DAL;
using GK.WMS.Entity;
using GK.WMS.Entity.dto;
using GK.WMS.Entity.wms;
using System.Web.Http;
using Web.Authorize;
using WMS.DAL;

namespace WebApi
{
    [FormAuthenticationFilter]

    [RoutePrefix("stat")]
    public class StatController : BaseApiController
    {
        IStatServer statServer = WMSDalFactray.getDal<IStatServer>();


        [HttpPost, Route("FindPage")]
        public BaseResult FindPage([FromBody]StatStockDetailDto dto)
        {
             Page<StatStockDetail> info = statServer.QueryStatStockDetailPage(dto)   ;      
            return  BaseResult.Ok(info);
        }
       
        
    }
}