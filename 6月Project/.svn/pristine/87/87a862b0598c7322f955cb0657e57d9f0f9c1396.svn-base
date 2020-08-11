
using GK.Common;
using GK.Common.dto;
using GK.WMS.DAL;

using GK.WMS.Entity;
using GK.WMS.Entity.wms;
using HY.WCS.DAL;
using HY.WCS.DAL.dto;
using HY.WCS.Entity.dto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;


using System.Web.Http;
using System.Web.Http.Cors;
using Web.Authorize;

namespace WebApi
{
    [FormAuthenticationFilter]

    [RoutePrefix("corewh")]
    public class CoreWhController : BaseApiController
    {
        ICoreWhLocServer coreWhLocServer = WMSDalFactray.getDal<ICoreWhLocServer>();

        //库房分页查询
        [HttpPost, Route("FindPage")]
        public BaseResult FindPage([FromBody]CoreWhDto dto)
        {
            Page<CoreWh> info = coreWhLocServer.QueryCoreWhPage<CoreWh>(dto);       
            return  BaseResult.Ok(info);
        }
        //库房保存修改
        [HttpPost, Route("Save"), ControlName("库房保存")]
        public BaseResult Save([FromBody]CoreWh coreWh)
        {
            if (coreWh.id == 0)
            {
                bool yesorno = coreWhLocServer.QueryCoreWhPageByName(coreWh);
                if (yesorno == true)
                {
                    return BaseResult.Error("库房名称不能重复!");
                }
                else
                {
                    return BaseResult.Ok((coreWhLocServer.AddCoreWh(coreWh)));
                }
            }
            else
            {     
                    return BaseResult.Ok(coreWhLocServer.UpdateCoreWh(coreWh));
            }
        }
        //库房删除
        [HttpPost, Route("Delete"), ControlName("库房删除")]
        public BaseResult Delete([FromBody]List<CoreWh> coreWhList)
        {
            foreach (var corewh in coreWhList)
            {
                CoreWh coreWh = coreWhLocServer.FindCoreWhById(corewh.id);
                List<CoreWhArea> list = coreWhLocServer.GetAreaByWhId(corewh.id);
                if (list.Count()>0)
                {
                   return  BaseResult.Error("因该库房下存在区域!");
                }
            }
            return  BaseResult.Ok(coreWhLocServer.DeleteCoreWh(coreWhList));
        }



    }
}