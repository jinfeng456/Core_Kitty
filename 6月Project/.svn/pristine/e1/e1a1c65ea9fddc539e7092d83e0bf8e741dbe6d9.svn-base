using System.Text;
using Dapper;
using GK.Common;
using System.Data.SqlClient;
using HY.WCS.DAL.dto;
using System.Configuration;
using System.ComponentModel;
using WebApi.util;
using GK.WMS.Entity;
using GK.Common.dto;
using System.Collections.Generic;
using System.Linq;

namespace GK.WMS.DAL.abs
{
    public abstract class AbsSysCodeServer : AbsWMSBaseServer, ISysCodeServer
    {
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();
        public Page<SysCode> QuerySysCodePage(SysCodeDto dto)
        {
            string sql = @"select * from Sys_Code where 1=1 ";
            if (!string.IsNullOrEmpty(dto.tableName))
            {
                sql += " AND table_Name = @tableName ";
            }
            return this.queryPage<SysCode>(sql, "id", dto);
        }

        public List<SysCode> GetAllList()
        {
            string sql = @"select * from SysCode";

            return Connection.Query<SysCode>(sql).ToList();
        }
   
    }
}

	