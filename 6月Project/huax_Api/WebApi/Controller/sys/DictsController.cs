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
using WebApi.util;
using WMS.DAL;

namespace WebApi
{
    [FormAuthenticationFilter]

    [RoutePrefix("dict")]
    public class DictsController : BaseApiController
    {
        ISysAuthorityServer authorityServer = WMSDalFactray.getDal<ISysAuthorityServer>();
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();


        [HttpPost, Route("FindPage")]
        public BaseResult FindPage([FromBody]DictsDto dto)
        {
            var info = authorityServer.QueryDictsPage(dto);
            return  BaseResult.Ok(info);
        }

        [HttpPost, Route("Save"), ControlName("字典删除")]
        public BaseResult Save([FromBody]SysDict model)
        {
            model.lastUpdateBy = CookieHelper.LoginName();
            model.lastUpdateTime = DateTime.Now;
            if (model.id == 0)
            {
                if (model.dictClassId != 0)
                {
                    model.dtype = authorityServer.getById<SysDictClass>(model.dictClassId).dictClassName;
                }
                model.id = sequenceIdServer.getId();
                model.createTime = sequenceIdServer.GetTime();
                model.createBy = CookieHelper.LoginName();              
                return  BaseResult.Ok(authorityServer.insert(model));
            }
            else
            {
                if (model.dictClassId != 0)
                {
                    model.dtype = authorityServer.getById<SysDictClass>(model.dictClassId).dictClassName;
                }            
                return  BaseResult.Ok(authorityServer.update(model));
            }
        }

        [HttpPost, Route("Delete"), ControlName("字典删除")]
        public BaseResult Delete([FromBody]List<SysDict> modelList)
        {
            foreach (var item in modelList)
            {
                authorityServer.delete<SysDict>(item.id);
            }
            return  BaseResult.Ok("1");
        }
       

         [HttpPost, Route("GetAllDicts")]
        public BaseResult GetAllDicts( )
        {         
            return  BaseResult.Ok(authorityServer.GetDicts());
        }
    }
}