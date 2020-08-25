
using Common;
using GK.WMS.DAL;
using GK.WMS.Entity;
using HY.WCS.DAL;
using HY.WCS.DAL.dto;
using HY.WCS.Entity.dto;
using Newtonsoft.Json.Schema;
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

    [RoutePrefix("Audit")]
    public class AuditController : BaseApiController
    {
        IAuditServer auditServer = WMSDalFactray.getDal<IAuditServer>();
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();
        ISysAuthorityServer authorityServer = WMSDalFactray.getDal<ISysAuthorityServer>();

        [HttpPost, Route("Save"),ControlName("检验审核意见保存")]
        public BaseResult Save([FromBody]WhAuditParam param)
        {
            WhAudit model = new WhAudit();
            var userList = authorityServer.GetUser(CookieHelper.LoginName());
            string newAuditPassword= GKMD5.MD5Encrypt(param.auditPassword);
            if (userList[0].auditPassword != newAuditPassword)
            {
                return BaseResult.Error("电子密码认证失败!");
            }
            //判断是否已经审核过
            var list = auditServer.GetByAuditId(param.auditId);
            if (list != null && list.Count > 0) //如果该批次已经审核过
            {
                model.id = param.id;
                model.auditer = param.auditer;
                model.auditId = param.auditId;
                model.auditInfo = param.auditInfo;
                model.auditType = param.auditType;
                model.auditer = CookieHelper.LoginName();
                return BaseResult.Ok(auditServer.updateNotNull<WhAudit>(model));
            }
            else
            {
                model.id = sequenceIdServer.getId();
                model.createDate = sequenceIdServer.GetTime();
                model.auditer = param.auditer;
                model.auditId = param.auditId;
                model.auditInfo = param.auditInfo;
                model.auditType = param.auditType;
                model.auditer = CookieHelper.LoginName();               
                return BaseResult.Ok(auditServer.insertNotNull<WhAudit>(model));
            }
        }

        [HttpPost, Route("GetByAuditId")]
        public BaseResult GetByAuditId(WhBatch model)
        {
            return BaseResult.Ok(auditServer.GetByAuditId(model.id));
        }
    }
}