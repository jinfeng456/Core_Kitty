
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

    [RoutePrefix("corewhloc")]
    public class CoreWhLocController : BaseApiController
    {
        ICoreWhLocServer coreWhLocServer = WMSDalFactray.getDal<ICoreWhLocServer>();

        //库位分页查询
        [HttpPost, Route("FindPage")]
        public BaseResult FindPage([FromBody]CoreWhLocDto dto)
        {
            Page<CoreWhLoc> info = coreWhLocServer.QueryLocPage(dto);       
            return  BaseResult.Ok(info);
        }
        //库位保存修改
        [HttpPost, Route("Save"), ControlName("库位保存")]
        public BaseResult Save([FromBody]CoreWhLoc coreLoc)
        {
            if (coreLoc.id == 0)
            {
                bool yesorno = coreWhLocServer.QueryLocPageByRow(coreLoc);
                if (yesorno == true)
                {
                    return BaseResult.Error("库位不能重复设置!");
                }
                else
                {
                    return BaseResult.Ok((coreWhLocServer.AddLoc(coreLoc)));
                }
            }
            else
            {
                    return BaseResult.Ok(coreWhLocServer.UpdateLoc(coreLoc));
            }
        }
        //库位删除
        [HttpPost, Route("Delete"), ControlName("库位删除")]
        public BaseResult Delete([FromBody]List<CoreWhLoc> locList)
        {
            foreach (var corewhloc in locList)
            {
                CoreWhLoc coreloc = coreWhLocServer.FindLocById(corewhloc.id);
                //List<CoreWhLoc> list = coreWhLocServer.GetLocByWhAreaId(corewhloc.id);
                //if (list.Count()>0)
                //{
                //   return  BaseResult.Error(500, "因该区域下存在库位!");
                //}
            }
            return  BaseResult.Ok(coreWhLocServer.DeleteLoc(locList));
        }
        //库位批量编辑
        [HttpPost, Route("BatchEdit/{areaid}"), ControlName("库位批量编辑")]
        public BaseResult BatchEdit([FromBody]List<long> locList,long areaid)
        {            
            return BaseResult.Ok(coreWhLocServer.BatchUpdataLoc(locList, areaid));
        }
    }
}