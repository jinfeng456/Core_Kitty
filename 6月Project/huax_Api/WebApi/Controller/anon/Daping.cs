
using GK.WMS.DAL;
using GK.WMS.Entity;
using HY.WCS.DAL.dto;
using System.Collections.Generic;
using System.Web.Http;
using Web.Authorize;

namespace WebApi {
    [RoutePrefix("api/dp")]
    public class DapingController:BaseApiController {
  
 
        [HttpGet, Route("d/{id}")]
        public BaseResult data(int id) {
              IStockServer sequenceIdServer = WMSDalFactray.getDal<IStockServer>();
            List<DapingDto>   l  = sequenceIdServer.getDapingDto(id);
            return new BaseResult(l);

        }

        [HttpGet, Route("load/{id}")]
        public BaseResult load(int id) {
           ICoreStockServer coreStockServer = WMSDalFactray.getDal<ICoreStockServer>();
           CoreStock  cs  = coreStockServer.getCoreStockByLocId(id);
            if (cs == null) {
               return new BaseResult("NoData");
                }
           List<CoreStockDetail> list=  coreStockServer.GetListByStockId(cs.id);
           return new BaseResult(new {cs=cs,list=list });

        }

    }
}
