using System.Text;
using Dapper;
using System.Data.SqlClient;
using HY.WCS.DAL.dto;
using System.Configuration;
using System.ComponentModel;
using WebApi.util;
using GK.WMS.Entity;
using System.Collections.Generic;
using System.Linq;
using WMS.DAL;
using WMS.Entity;
using Common.dto;

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

	