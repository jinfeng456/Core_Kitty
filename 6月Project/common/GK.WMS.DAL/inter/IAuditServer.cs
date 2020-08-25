using Common.DAL.inter;
using GK.WMS.Entity;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Security.AccessControl;
using System.Text;

namespace GK.WMS.DAL
{
    public interface IAuditServer : IBaseServer
    {
        List<WhAudit> GetByAuditId(long auditId);
    }
}
