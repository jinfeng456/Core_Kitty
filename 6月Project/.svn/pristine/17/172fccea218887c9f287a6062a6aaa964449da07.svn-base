using GK.Common.dto;
using GK.DAL.inter;
using GK.WMS.DAL.abs;
using GK.WMS.Entity;
using GK.WMS.Entity.dto;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace GK.WMS.DAL
{
    public abstract class AbsStatServer:AbsWMSBaseServer, IStatServer {
        public Page<StatStockDetail> QueryStatStockDetailPage(StatStockDetailDto dto) {
            string sql = " select * from Stat_Stock_Detail  where 1=1 ";

            if (!String.IsNullOrEmpty(dto.itemName)) {
                sql+="and item_Name like '%@itemName%' ";
            }
            if (!String.IsNullOrEmpty(dto.wmsBanthNo)) {
                sql+="and wms_Banth_No like '%@wmsBanthNo%' ";
            }
           string orderBy = "begin_Time  desc";
           return  this.queryPage<StatStockDetail>(sql, orderBy, dto);
        }
    }
}
