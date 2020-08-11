
using GK.Common;
using GK.WMS.DAL;

using GK.WMS.Entity;
using HY.WCS.DAL;
using HY.WCS.DAL.dto;
using HY.WCS.Entity.dto;
using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;
using System.Web;


using System.Web.Http;
using System.Web.Http.Cors;
using Web.Authorize;

namespace WebApi
{
    [FormAuthenticationFilter]

    [RoutePrefix("dictClass")]
    public class DictClassController : BaseApiController
    {
      static  ISysAuthorityServer authorityServer = WMSDalFactray.getDal<ISysAuthorityServer>();


        [HttpPost, Route("FindPage")]
        public BaseResult FindPage([FromBody]DictClassDto dto)
        {
            var info = authorityServer.QueryDictClassPage<SysDictClass>(dto);          
            return  BaseResult.Ok(info);
        }

        [HttpPost, Route("Save"), ControlName("字典分类保存")]
        public BaseResult Save([FromBody]SysDictClass model)
        {
            if (model.id == 0)
            {
                return  BaseResult.Ok(authorityServer.AddDictClass(model));
            }
            else
            {
                return  BaseResult.Ok(authorityServer.UpdateDictClass(model));
            }
        }

        [HttpPost, Route("Delete"), ControlName("字典分类删除")]
        public BaseResult Delete([FromBody]List<SysDictClass> modelList)
        {         
            return  BaseResult.Ok(authorityServer.DeleteDictClass(modelList));
        }

        [HttpPost, Route("GetAllList")]
        public BaseResult GetAllList()
        {
            var info = authorityServer.GetAllList();
            return BaseResult.Ok(info);
        }
    }
}