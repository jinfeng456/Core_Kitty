using Dapper;
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
    public abstract class AbsWhSoOutProduceServer : AbsWMSBaseServer, IWhSoOutProduceServer
    {

        public List<WhSoOutProduceDetail> GetDetails(long soId)
        {
            String sql = "select * from Wh_So_Out_Produce_Detail  where so_Id=@soId";
            return Connection.Query<WhSoOutProduceDetail>(sql, new { soId }).ToList();
        }
        public List<WhSoOutProduce> getWhSoOutProduce(long id)
        {
            string sql = @"select * from Wh_So_Out_Produce where id=@id ";
            List<WhSoOutProduce> list = Connection.Query<WhSoOutProduce>(sql, new { id = id }).ToList();
            return list;
        }
    }
}
