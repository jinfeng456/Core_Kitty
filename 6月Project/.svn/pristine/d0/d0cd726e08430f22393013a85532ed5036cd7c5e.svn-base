using System;
using System.Web;
using System.Web.Http;

using Web.Authorize;

using System.Collections.Generic;
using GK.Common.dto;
using GK.Mongon.DAL;
using GK.Mongon;
using HY.WMS.DAL.dto;
using GK.Common.entity;
using GK.Mongo.Dto;

namespace WebApi
{
    [FormAuthenticationFilter]
    [RoutePrefix("log")]
    public class LoggerController : BaseApiController
    {
 

        [HttpPost, Route("wmsPage")]
        public BaseResult wmsPage([FromBody]LogDto logDto)
        {
            string begin = HttpContext.Current.Request["page"];
            string limit = HttpContext.Current.Request["limit"];
            string p = HttpContext.Current.Request["p"];
            string url = HttpContext.Current.Request["urlPath"];
            string res = HttpContext.Current.Request["res"];
            Page<HttpLog> page = HttpServerLogUtil.page((logDto.pageNum-1)* logDto.pageSize+1, logDto.pageSize, logDto.name, logDto.urlName,res);
            return new BaseResult(page);
        }
       
        [HttpGet, Route("wmsShow/{id}")]
        public BaseResult wmsShow(String id) {
            HttpLog logger = HttpServerLogUtil.show(id);
            return new BaseResult(logger);
        }

        [HttpPost, Route("FindPage")]
        public BaseResult wcsFindPage([FromBody]MessageDto dto)
        {
            Page<Messagelog> info = MessagelogUtil.page(dto);
            return BaseResult.Ok(info);
        }
    }
}
