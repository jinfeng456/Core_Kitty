using Dapper;
using GK.Common.dto;
using GK.DAL.inter;
using GK.WMS.DAL.abs;
using GK.WMS.Entity;
using GK.WMS.Entity.wms;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace GK.WMS.DAL
{
    public abstract class AbsWhSoInServer : AbsWMSBaseServer, IWhSoInServer
    {
        public List<WhSoInDetail> getDetials(long soid)
        {
            String sql = "select * from Wh_So_In_Detail  where so_Id=@soid";
            return Connection.Query<WhSoInDetail>(sql, new { soid }).ToList();
        }

        public List<WhSoInDetail> GetDetails(long soId)
        {
            String sql = "select * from Wh_So_In_Detail  where so_Id=@soId";

            return Connection.Query<WhSoInDetail>(sql, new { soId }).ToList();
        }

        //根据入库单ID去查询详细信息
        public List<WhSoIn> getWhSoIn(long id)
        {
            string sql = @"select * from Wh_So_In where id=@id ";
            List<WhSoIn> list = Connection.Query<WhSoIn>(sql, new { id = id }).ToList();
            return list;
        }
    }
}
