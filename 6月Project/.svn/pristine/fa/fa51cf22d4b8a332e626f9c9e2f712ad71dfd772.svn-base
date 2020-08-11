
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

    [RoutePrefix("corewharea")]
    public class CoreWhAreaController : BaseApiController
    {
        ICoreWhLocServer coreWhLocServer = WMSDalFactray.getDal<ICoreWhLocServer>();

        //区域分页查询
        [HttpPost, Route("FindPage")]
        public BaseResult FindPage([FromBody]CoreWhAreaDto dto)
        {
            Page<CoreWhArea> info = coreWhLocServer.QueryAreaPage(dto);       
            return  BaseResult.Ok(info);
        }
        //区域保存修改
        [HttpPost, Route("Save"), ControlName("库区保存")]
        public BaseResult Save([FromBody]CoreWhArea coreArea)
        {
            if (coreArea.id == 0)
            {
                bool yesorno = coreWhLocServer.QueryAreaPageByName(coreArea);
                if (yesorno == true)
                {
                    return BaseResult.Error("区域名称不能重复!");
                }
                else
                {
                    return BaseResult.Ok((coreWhLocServer.AddArea(coreArea)));
                }
            }
            else
            {
                    return BaseResult.Ok(coreWhLocServer.UpdateArea(coreArea));
            }
        }
        //区域删除
        [HttpPost, Route("Delete"), ControlName("库区删除")]
        public BaseResult Delete([FromBody]List<CoreWhArea> areaList)
        {
            foreach (var corewharea in areaList)
            {
                CoreWhArea corearea = coreWhLocServer.FindAreaById(corewharea.id);
                List<CoreWhLoc> list = coreWhLocServer.GetLocByWhAreaId(corewharea.id);
                if (list.Count()>0)
                {
                   return  BaseResult.Error("因该区域下存在库位!");
                }
            }
            return  BaseResult.Ok(coreWhLocServer.DeleteArea(areaList));
        }
    }
}