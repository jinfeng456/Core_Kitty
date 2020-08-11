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
using System.Linq;
using System;

namespace GK.WMS.DAL.abs
{
    public abstract class AbsStatRealServer : AbsWMSBaseServer, IStatRealServer
    {
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();

        public Page<StatRealDto> QueryStatRealAllPage(StatRealDto dto)
        {
            string sql = @"SELECT * FROM (SELECT *,count AS inCount,NULL AS outCount FROM stat_real WHERE forword =1
                           UNION ALL
                           SELECT *,NULL AS inCount,count AS outCount FROM stat_real WHERE forword =2) A WHERE 1=1 ";
            if (!string.IsNullOrEmpty(dto.itemName))
            {
                dto.itemName = "%" + dto.itemName + "%";
                sql += " AND item_Name like @itemName ";
            }
            if (!string.IsNullOrEmpty(dto.packageSpecs))
            {
                dto.packageSpecs = "%" + dto.packageSpecs + "%";
                sql += " AND package_Specs like @packageSpecs ";
            }
            if (dto.forword > 0)
            {
                sql += " AND forword = @forword ";
            }
            if (dto.opTimeBegin != DateTime.MinValue)
            {
                sql += " AND op_time >= @opTimeBegin ";
            }
            if (dto.opTimeEnd != DateTime.MinValue)
            {
                sql += " AND op_time <= @opTimeEnd ";
            }
            return this.queryPage<StatRealDto>(sql, "month", dto);
        }

        public Page<StatReal> QueryStatRealPage(StatRealDto dto)
        {
            string sql = @"select * from Stat_Real where 1=1";
            if (!string.IsNullOrEmpty(dto.itemName))
            {
                dto.itemName = "%" + dto.itemName + "%";
                sql += " AND item_Name like @itemName ";
            }
            if (!string.IsNullOrEmpty(dto.packageSpecs))
            {
                dto.packageSpecs = "%" + dto.packageSpecs + "%";
                sql += " AND package_Specs like @packageSpecs ";
            }
            if (dto.forword > 0)
            {
                sql += " AND forword = @forword ";
            }
            if (dto.opTimeBegin != DateTime.MinValue)
            {
                sql += " AND op_time >= @opTimeBegin ";
            }
            if (dto.opTimeEnd != DateTime.MinValue)
            {
                sql += " AND op_time <= @opTimeEnd ";
            }
            return this.queryPage<StatReal>(sql, "id", dto);
        }

    }
}

