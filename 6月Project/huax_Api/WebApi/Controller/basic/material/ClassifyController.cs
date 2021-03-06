﻿using Common.dto;
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

    [RoutePrefix("classify")]
    public class ClassifyController : BaseApiController
    {
        IItemServer iitemServer = WMSDalFactray.getDal<IItemServer>();

        //物料类别分页查询
        [HttpPost, Route("FindPage")]
        public BaseResult FindPage([FromBody]ClassifyDto dto)
        {
            Page<ClassifyDto> info = iitemServer.QueryClassifyPage<ClassifyDto>(dto);       
            return  BaseResult.Ok(info);
        }
        //物料类别保存
        [HttpPost, Route("Save"), ControlName("物料类别保存")]
        public BaseResult Save([FromBody]CoreClassify classify)
        {
            if (classify.id == 0)
            {                
                    return BaseResult.Ok(iitemServer.AddClassify(classify));               
            }
            else
            {
                    return BaseResult.Ok(iitemServer.UpdateClassify(classify));
            }
        }
        //物料类别删除
        [HttpPost, Route("Delete"), ControlName("物料类别删除")]
        public BaseResult Delete([FromBody]List<CoreClassify> classifyList)
        {
            foreach (var classify in classifyList)
            {
                CoreClassify coreClassify = iitemServer.FindClassifyById(classify.id);
                List<CoreItem> list = iitemServer.GetCoreItemByClassfiyId(classify.id);
                if (list.Count()>0)
                {
                    return  BaseResult.Error("因该类别下存在物料!");
                }
            }
            return  BaseResult.Ok(iitemServer.DeleteClassify(classifyList));
        }


        //批量设置库区
        [HttpPost, Route("Batchset/{areaid}"), ControlName("物料批量设置库区")]
        public BaseResult BatchEdit([FromBody]List<long> locList, long areaid)
        {
            return BaseResult.Ok(iitemServer.BatchSetLoc(locList, areaid));
        }
    }
}