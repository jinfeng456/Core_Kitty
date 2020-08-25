using System.Text;
using Dapper;
using System.Data.SqlClient;
using HY.WCS.DAL.dto;
using System.Configuration;
using System.ComponentModel;
using WebApi.util;
using GK.WMS.Entity;
using System.Linq;
using WMS.DAL;
using Common.dto;

namespace GK.WMS.DAL.abs
{
    public abstract class AbsStatMonthServer : AbsWMSBaseServer, IStatMonthServer
    {
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();
        public Page<StatMonth> QueryStatMonthPage(StatMonthDto dto)
        {
            string sql = @"select * from Stat_Month where 1=1 ";
            if (!string.IsNullOrEmpty(dto.itemName))
            {
                dto.itemName = "%" + dto.itemName + "%";
                sql += " AND item_Name like @itemName ";
            }
            if (!string.IsNullOrEmpty(dto.modelSpecs))
            {
                dto.modelSpecs = "%" + dto.modelSpecs + "%";
                sql += " AND model_Specs like @modelSpecs ";
            }
            if (dto.coreItemType > 0)
            {
                sql += " AND core_Item_Type like @coreItemType ";
            }
            return this.queryPage<StatMonth>(sql, "id", dto);
        }

    }
}

