using Dapper;
using GK.Fmxt.DAL;
using GK.WMS.DAL.abs;
using GK.WMS.Entity;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using WMS.Entity;

namespace GK.Fmxt.DAL
{
    public abstract class AbsMiddleServer : AbsWMSBaseServer, IMiddleServer
    {
        public List<LogCodeDetail> GetByBarCode(string barCode, string parentCode)
        {
            string sql = "select * from log_code_detail where 1=1 ";
            if (!string.IsNullOrEmpty(barCode))
            {
                sql += " AND Bar_Code = @barCode ";
            }
            if (!string.IsNullOrEmpty(parentCode))
            {
                sql += " AND parentCode = @parentCode ";
            }
            return Connection.Query<LogCodeDetail>(sql, new { barCode = barCode, parentCode = parentCode }).ToList();
        }

        public List<CoreStockDetail> GetByBatchId()
        {
            string sql = @"SELECT  *
                            FROM    dbo.core_stock_detail
                            WHERE   batch_Id IN ( SELECT    id
                                                  FROM      dbo.wh_batch
                                                  WHERE     business_Status = 3
                                                            AND update_Code = 0 ); ";
            return Connection.Query<CoreStockDetail>(sql).ToList();
        }

        public List<InfBatch> GetBatchList()
        {
            string sql = @"SELECT * FROM  dbo.Inf_Batch";
            return Connection.Query<InfBatch>(sql).ToList();
        }
    }
}
