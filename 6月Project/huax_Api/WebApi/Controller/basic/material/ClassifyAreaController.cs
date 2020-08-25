
using Common.dto;
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
using WMS.DAL;
using WMS.Entity;

namespace WebApi
{
    [FormAuthenticationFilter]

    [RoutePrefix("classifyarea")]
    public class ClassifyAreaController : BaseApiController
    {
        IItemServer iitemServer = WMSDalFactray.getDal<IItemServer>();

        //物料类别分区分页查询
        [HttpPost, Route("FindPage")]
        public BaseResult FindPage([FromBody]CoreClassifyAreaDto dto)
        {
            Page<CoreClassifyArea> info = iitemServer.QueryClassifyAreaPage(dto);       
            return  BaseResult.Ok(info);
        }
        //物料类别分区保存
        [HttpPost, Route("Save"),ControlName("物料类别分区保存")]
        public BaseResult Save([FromBody]CoreClassifyArea classifyarea)
        {
            if (classifyarea.id == 0)
            {                
                    return BaseResult.Ok(iitemServer.AddClassifyArea(classifyarea));               
            }
            else
            {
                    return BaseResult.Ok(iitemServer.UpdateClassifyArea(classifyarea));
            }
        }
        //物料类别分区删除
        [HttpPost, Route("Delete"), ControlName("物料类别分区删除")]
        public BaseResult Delete([FromBody]List<CoreClassifyArea> classifyAreaList)
        {
            return  BaseResult.Ok(iitemServer.DeleteClassifyArea(classifyAreaList));
        }
    }
}