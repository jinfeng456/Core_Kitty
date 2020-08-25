using Common.dto;
using Dapper;
using GK.WMS.DAL.abs;
using GK.WMS.Entity;
using GK.WMS.Entity.dto;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net.Http.Headers;
using System.Text;
using WMS.DAL;
using WMS.Entity;

namespace GK.WMS.DAL
{
    public abstract class AbsCoreStockServer : AbsWMSBaseServer, ICoreStockServer
    {
        public CoreStock getCoreStockByLocId(int locId)
        {
            String sql = "select * from [Core_stock] where  status<>-1 and loc_Id=@locId";
            CoreStock cs = Connection.Query<CoreStock>(sql, new { locId = locId }).FirstOrDefault();
            return cs;
        }
        public Page<CoreStock> QueryCoreStockPage(CoreStockDto dto)
        {
            string sql = "select * from Core_stock where 1=1 ";
            if (!string.IsNullOrEmpty(dto.boxCode))
            {
                dto.boxCode = "%" + dto.boxCode + "%";
                sql += " AND box_Code like @boxCode ";
            }
            if (dto.areaId != 0)
            {
                sql += " AND area_Id = @areaId ";
            }
            if (dto.locId != 0)
            {
                sql += " AND loc_Id = @locId ";
            }
            return this.queryPage<CoreStock>(sql, "id", dto);
        }

        public List<CoreStockDetail> GetListByStockId(long stockId)
        {
            string sql = "select * from core_stock_detail where 1=1 and stock_Id=@stockId ";
            return Connection.Query<CoreStockDetail>(sql, new { stockId = stockId }).ToList();
        }

        public Page<CoreStockDetail> QueryCoreStockDetailPage(CoreStockDto dto)
        {
            string sql = @"SELECT B.id AS stockDetailId,B.receiptl_Out_Id,B.wms_Banch_No,B.stock_Status,B.buss_Status,B.Count_Db,B.item_Id,B.item_Code,B.remark,B.loction_Id,A.*  FROM dbo.Core_stock A
                            LEFT OUTER JOIN dbo.core_stock_detail B
                            ON A.id = B.stock_Id
                            WHERE 1 =1 ";
            if (!string.IsNullOrEmpty(dto.boxCode))
            {
                dto.boxCode = "%" + dto.boxCode + "%";
                sql += " AND B.box_Code like @boxCode ";
            }
            if (dto.itemId != 0)
            {
                sql += " AND B.item_Id = @itemId ";
            }
            if (dto.batchId != 0)
            {
                sql += " AND B.batch_Id = @batchId ";
            }
            if (dto.receiptlOutId != 0)
            {
                sql += " AND B.receiptl_Out_Id = @receiptlOutId ";
            }
            else
            {
                sql += " AND B.receiptl_Out_Id = 0 ";
            }
            if (dto.stockStatus != 0)
            {
                sql += " AND B.stock_Status = @stockStatus ";
            }
            return this.queryPage<CoreStockDetail>(sql, "id", dto);
        }

        public long UpdateRecepitOutId(ReceiptAddDto dto)
        {
            var strList = dto.items.Split(',');
            for (int i = 0; i < strList.Length; i++)
            {
                string sql = @"UPDATE dbo.core_stock_detail SET receiptl_Out_Id =@receiptlOutId
                            WHERE stock_Id=@stockId AND id =@id";
                Connection.Execute(sql, new { receiptlOutId = dto.id, stockId = strList[i].Split('|')[0], id = strList[i].Split('|')[1] });
            }
            return 1;
        }

        public long UpdateRbussinessByBatchId(long batchId, int batchStatus)
        {
            string sql = @"UPDATE dbo.core_stock_detail SET r_bussiness_status =@rBussinessStatus
                            WHERE batch_Id=@batchId ";
            var info = Connection.Execute(sql, new { batchId = batchId, rBussinessStatus = batchStatus });
            return info;
        }

        public List<CoreStock> getCoreStockByCode(string code)
        {
            string sql = @"SELECT *  FROM dbo.Core_stock  WHERE 1 =1  AND box_Code = @boxCode and status in(1,2,3)";

            return Connection.Query<CoreStock>(sql, new { boxCode = code }).ToList();
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

        public long GetByBatchId(long batchid)
        {
            string sql = @"SELECT * FROM dbo.core_stock_detail WHERE batch_Id=@batchid ";
            return Connection.Query<CoreStockDetail>(sql, new { batchid = batchid }).FirstOrDefault().id;
        }

        public bool UpdatePriority(CoreStockDetail model)
        {
            string sql = @"UPDATE dbo.core_stock_detail SET Priority =@priority
                            WHERE batch_Id=@batchId";
            int a = Connection.Execute(sql, new { batchId = model.batchId, priority = model.Priority });
            if (a >= 1)
            {
                return true;
            }
            return false;
        }
        public bool UpdatePriorityById(CoreStockDto model)
        {
            string sql = @"UPDATE dbo.core_stock_detail SET Priority =@priority
                            WHERE id=@id";
            //  int a = Connection.Execute(sql, new { id = model.stockDetailId, priority = model.priority });
            //if (a >= 1)
            //{
            //    return true;
            //}
            return false;
        }
        public List<CoreStockDetail> GetByOutId(long receiptId)
        {
            string sql = @"SELECT  *
                            FROM    dbo.core_stock_detail
                            WHERE   receiptl_Out_Id IN (
                            SELECT  B.id
                            FROM    dbo.Wh_Receipt_out A
                            LEFT OUTER JOIN dbo.Wh_Receipt_out_detail B ON A.id = B.receipt_id 
                            WHERE B.receipt_id =@receiptId); ";
            return Connection.Query<CoreStockDetail>(sql, new { receiptId = receiptId }).ToList();
        }
        public List<CoreStockDetail> GetByOutDetailId(long receptDetailId)
        {
            string sql = @"SELECT  *
                            FROM    dbo.core_stock_detail
                            WHERE   receiptl_Out_Id IN (
                            SELECT id FROM dbo.Wh_Receipt_out_detail 
                            WHERE id =@receiptDetailId); ";
            return Connection.Query<CoreStockDetail>(sql, new { receiptDetailId = receptDetailId }).ToList();
        }

        //库存查询列表
        public Page<CoreStockParam> QueryCoreDetailPage(CoreStockDto dto)
        {
            string sql = @"SELECT b.item_id,b.item_code,B.pk_Status AS pkDetailStatus, B.id AS stockDetailId,B.receiptl_Out_Id,B.wms_Banch_No,B.stock_Status,B.buss_Status,B.Count_Db,B.loction_Id,A.*,C.business_Status,C.type,C.retest_Date,C.frozen ,(datediff(DAY,in_Time,getdate())-182) AS noOutTime,B.in_Time,C.item_Name  FROM dbo.Core_stock A
                            LEFT OUTER JOIN dbo.core_stock_detail B ON A.id = B.stock_Id
                            LEFT OUTER JOIN dbo.wh_batch C ON B.batch_Id = C.id
                            WHERE 1 =1 ";
            if (dto != null)
            {
                if (!string.IsNullOrEmpty(dto.boxCode))
                {
                    dto.boxCode = "%" + dto.boxCode + "%";
                    sql += " AND A.box_Code like @boxCode ";
                }
                if (dto.stockStatus != 0)
                {
                    sql += " AND B.stock_Status = @stockStatus ";
                }
                if (dto.whId != 0)
                {
                    sql += " AND A.wh_Id = @whId ";
                }
                if (dto.areaId != 0)
                {
                    sql += " AND A.area_Id = @areaId ";
                }
                if (dto.locId != 0)
                {
                    sql += " AND A.loc_Id = @locId ";
                }
                if (dto.itemId != 0)
                {
                    sql += " AND B.item_Id = @itemId ";
                }
                if (dto.exeBeginTime != DateTime.MinValue)
                {
                    sql += " AND C.business_Exp >= @exeBeginTime ";
                }
                if (dto.exeEndTime != DateTime.MinValue)
                {
                    sql += " AND C.business_Exp <= @exeEndTime ";
                }
                if (dto.retestBeginTime != DateTime.MinValue)
                {
                    sql += " AND C.retest_Date >= @retestBeginTime ";
                }
                if (dto.retestEndTime != DateTime.MinValue)
                {
                    sql += " AND C.retest_Date <= @retestEndTime ";
                }
                //预警信息提示
                if (dto.isWarning)
                {
                    sql += " AND datediff(DAY,in_Time,getdate())>182  AND out_Time IS null  ";
                }
                if (!string.IsNullOrEmpty(dto.wmsBanchNo))
                {
                    dto.wmsBanchNo = "%" + dto.wmsBanchNo + "%";
                    sql += " AND B.wms_Banch_No like @wmsBanchNo ";
                }

            }
            return this.queryPage<CoreStockParam>(sql, "id", dto);
        }
        //库存状态不等于-1查询列表
        public Page<CoreStockParam> QueryRealCoreDetailPage(CoreStockDto dto)
        {
            string sql = @"SELECT b.item_id,b.item_code,B.pk_Status AS pkDetailStatus,B.release_date, B.id AS stockDetailId,B.Priority,B.receiptl_Out_Id,B.wms_Banch_No,B.stock_Status,B.buss_Status,B.Count_Db,B.loction_Id,B.batch_Id,A.*,C.business_Status,C.type,C.retest_Date,C.frozen ,(datediff(DAY,in_Time,getdate())-182) AS noOutTime,B.in_Time  FROM dbo.Core_stock A
                            LEFT OUTER JOIN dbo.core_stock_detail B ON A.id = B.stock_Id
                            LEFT OUTER JOIN dbo.wh_batch C ON B.batch_Id = C.id
                            WHERE 1 =1 and B.stock_Status<>-1";
            if (dto != null)
            {
                if (!string.IsNullOrEmpty(dto.boxCode))
                {
                    dto.boxCode = "%" + dto.boxCode + "%";
                    sql += " AND A.box_Code like @boxCode ";
                }
                if (dto.stockStatus != 0)
                {
                    sql += " AND B.stock_Status = @stockStatus ";
                }
                if (dto.whId != 0)
                {
                    sql += " AND A.wh_Id = @whId ";
                }
                if (dto.areaId != 0)
                {
                    sql += " AND A.area_Id = @areaId ";
                }
                if (dto.locId != 0)
                {
                    sql += " AND A.loc_Id = @locId ";
                }
                if (dto.itemId != 0)
                {
                    sql += " AND B.item_Id = @itemId ";
                }
                if (dto.exeBeginTime != DateTime.MinValue)
                {
                    sql += " AND C.business_Exp >= @exeBeginTime ";
                }
                if (dto.exeEndTime != DateTime.MinValue)
                {
                    sql += " AND C.business_Exp <= @exeEndTime ";
                }
                if (dto.retestBeginTime != DateTime.MinValue)
                {
                    sql += " AND C.retest_Date >= @retestBeginTime ";
                }
                if (dto.retestEndTime != DateTime.MinValue)
                {
                    sql += " AND C.retest_Date <= @retestEndTime ";
                }
                //预警信息提示
                if (dto.isWarning)
                {
                    sql += " AND datediff(DAY,in_Time,getdate())>182  AND out_Time IS null  ";
                }
                if (!string.IsNullOrEmpty(dto.wmsBanchNo))
                {
                    dto.wmsBanchNo = "%" + dto.wmsBanchNo + "%";
                    sql += " AND B.wms_Banch_No like @wmsBanchNo ";
                }

            }
            return this.queryPage<CoreStockParam>(sql, "id", dto);
        }

        public int getSumStockCountDb(long receiptlnId)
        {
            string sql = "select sum(Count_Db) from core_stock_detail where receiptln_Id=@receiptlnId";
            return Connection.Query<int>(sql, new { receiptlnId = receiptlnId }).FirstOrDefault();
        }
    }
}
