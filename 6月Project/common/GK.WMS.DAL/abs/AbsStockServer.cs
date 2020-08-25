using GK.WMS.DAL.abs;
using GK.WMS.Entity;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Dapper;
using static Dapper.SqlMapper;
namespace GK.WMS.DAL
{
    public class AbsStockServer : AbsWMSBaseServer, IStockServer
    {
   
         public List< DapingDto>  getDapingDto(int id) {
        String sql = "SELECT [loc_Id] l, [status] s  FROM  [Core_stock]  where status in(1,2,3)  ";
            if (id == 1) {
              sql += " and [loc_Id]<70000";
            }else if (id == 2) {
                 sql += " and [loc_Id]>70000  and [loc_Id]<170000";
            } else {
            sql += " and [loc_Id]>170000  ";
                }
            return Connection.Query<DapingDto>(sql).ToList();
            }
        public bool completeFeedback()
        {
            throw new NotImplementedException();
        }
    }
}
