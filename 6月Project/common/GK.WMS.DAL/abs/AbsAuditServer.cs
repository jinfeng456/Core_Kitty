using Dapper;
using GK.Common.dto;
using GK.DAL.inter;
using GK.WMS.DAL.abs;
using GK.WMS.Entity;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace GK.WMS.DAL
{
    public abstract class AbsAuditServer : AbsWMSBaseServer, IAuditServer
    {
        public List<WhAudit> GetByAuditId(long auditId)
        {
            string sql = "select * from wh_audit where 1=1 and audit_Id=@auditId";
            return Connection.Query<WhAudit>(sql, new { auditId = auditId }).ToList();
        }     
    }
}
