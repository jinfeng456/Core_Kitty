using GK.Common.dto;
using GK.DAL.inter;
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
using GK.WMS.Entity.dto;
using GK.WMS.Entity.wms;

namespace GK.WMS.DAL
{
    public class AbsReceiptOutServer : AbsWMSBaseServer, IReceiptOutServer
    {
        //查询所有信息
        public List<CoreStockDetail> getCoreStockDetials(long id)
        {
            String sql = "select * from core_stock_detail where stock_Id=@id and stock_Status=0";
            return Connection.Query<CoreStockDetail>(sql, new { id }).ToList();
        }

        public List<WhReceiptOutDetail> getDetials(long receiptOutId)
        {
            String sql = "select * from Wh_Receipt_Out_Detail  where receipt_id=@receiptOutId";
            return Connection.Query<WhReceiptOutDetail>(sql, new { receiptOutId }).ToList();
        }

        public Page<WhReceiptOut> QueryReceiptOutPage(ReceiptDto dto)
        {
            string sql = " select * from Wh_Receipt_out  where 1=1 ";

            if (!string.IsNullOrEmpty(dto.receiptNo))
            {
                dto.receiptNo = "%" + dto.receiptNo + "%";
                sql += "and receipt_No like @receiptNo ";
            }
            if (!string.IsNullOrEmpty(dto.srcSoNo))
            {
                dto.srcSoNo = "%" + dto.srcSoNo + "%";
                sql += "and src_So_No like @srcSoNo ";
            }
            if (dto.status != 0)
            {
                sql += "and status = @status ";
            }
            if (dto.stn != 0)
            {
                sql += "and stn = @stn ";
            }
            if (dto.outType != 0)
            {
                sql += "and out_Type=@outType ";
            }
            if (dto.outTypeClass != 0)
            {
                sql += "and out_Type_Class=@outTypeClass ";
            }
            if (dto.createBeginTime != DateTime.MinValue)
            {
                sql += " AND begin_Time >= @createBeginTime ";
            }
            if (dto.createEndTime != DateTime.MinValue)
            {
                sql += " AND begin_Time <= @createEndTime ";
            }
            if (dto.finishBeginTime != DateTime.MinValue)
            {
                sql += " AND finsh_Time >= @finishBeginTime ";
            }
            if (dto.finishEndTime != DateTime.MinValue)
            {
                sql += " AND finsh_Time <= @finishEndTime ";
            }
            string orderBy = "priority,begin_Time  desc";
            return this.queryPage<WhReceiptOut>(sql, orderBy, dto);
        }
        public Page<WhReceiptOutQuery> QueryReceiptOutDetailPage(ReceiptDto dto)
        {
            string sql = @" SELECT A.status,B.* FROM dbo.Wh_Receipt_out  A
                            INNER JOIN dbo.Wh_Receipt_out_detail B ON A.ID = B.receipt_id  where 1=1 AND A.status=1";

            if (!String.IsNullOrEmpty(dto.itemId))
            {
                sql += "and item_Id=@itemId ";
            }
            if (!String.IsNullOrEmpty(dto.batchNo))
            {
                dto.batchNo = "%" + dto.batchNo + "%";
                sql += "and batch_No like @batchNo ";
            }
            if (!String.IsNullOrEmpty(dto.srcSoNo))
            {
                dto.srcSoNo = "%" + dto.srcSoNo + "%";
                sql += "and src_So_No like @srcSoNo ";
            }
            string orderBy = "id  desc";
            return this.queryPage<WhReceiptOutQuery>(sql, orderBy, dto);
        }
        public List<CoreStock> GetCoreStockId(string boxCode)
        {
            String sql = "select * from core_stock where box_Code=@boxCode";
            return Connection.Query<CoreStock>(sql, new { boxCode }).ToList();
        }


        public bool updateCoreStockDetails(string barCode)
        {
            string sql = @"update core_stock_detail set stock_Status=0 where bar_Code=@barCode and stock_Status=3";
            Connection.Execute(sql, new { barCode = barCode });
            return true;
        }

        public bool updateCoreStockDetailsById(long id)
        {
            string sql = @"update core_stock_detail set stock_Status=-1 where id=@id";
            Connection.Execute(sql, new { id = id });
            return true;
        }

        //根据成品码获取明细
        public List<CoreStockDetail> getCoreStockDetialsId(string barCode)
        {
            String sql = "select * from core_stock_detail where bar_Code=@barCode";
            return Connection.Query<CoreStockDetail>(sql, new { barCode }).ToList();
        }

        public List<WhReceiptOutDetail> GetReceiptOutDetail(ReceiptAddDto dto)
        {
            string sql = "select * from Wh_Receipt_out_detail where 1=1 ";
            if (dto.id != 0)
            {
                sql += " and receipt_id=@receiptId ";
            }
            return Connection.Query<WhReceiptOutDetail>(sql, new { receiptId = dto.id }).ToList();
        }

        public void DeleteDetailByReceptId(long receiptId)
        {
            string sql = @"DELETE FROM Wh_Receipt_out_detail where receipt_id=@receiptId";
            Connection.Execute(sql, new { receiptId = receiptId });
        }

        public List<WhReceiptOut> GetAllList(long receiptOutId)
        {
            String sql = "select * from Wh_Receipt_out where id=@receiptOutId ";
            return Connection.Query<WhReceiptOut>(sql, new { receiptOutId = receiptOutId }).ToList();
        }

        /// <summary>
        /// 这个用于打印获取结果集
        /// </summary>
        /// <param name="receiptOutId">出库单主键</param>
        /// <returns></returns>
        public List<ReceiptOutdetailDto> GetOutDetials(long receiptOutId)
        {
            String sql = @"select A.*,B.name as itemName from Wh_Receipt_Out_Detail A
                           LEFT OUTER JOIN core_item B ON A.item_Id = B.id  where receipt_id=@receiptOutId";
            return Connection.Query<ReceiptOutdetailDto>(sql, new { receiptOutId }).ToList();
        }

        public List<WhReceiptOut> GetNotUploadList()
        {
            string sql = "select * from Wh_Receipt_out where Status=3 and upload=0";
            return Connection.Query<WhReceiptOut>(sql).ToList();
        }

        public Page<ReceiptOutReportDto> QueryFindReportPage(ReceiptDto dto)
        {
            string sql = @"SELECT A.pick_Type,A.Priority,A.out_Type,A.stn,A.status,A.receipt_No,C.name AS itemName,a.begin_Time,a.finsh_Time,b.plan_Count,B.finsh_Count,B.active_Count,B.batch_No 
                            FROM dbo.Wh_Receipt_out A
                            INNER JOIN dbo.Wh_Receipt_out_detail B ON A.id = B.receipt_id
                            LEFT JOIN dbo.core_item C ON B.item_Id = C.id
                            WHERE 1=1 ";

            if (!string.IsNullOrEmpty(dto.receiptNo))
            {
                dto.receiptNo = "%" + dto.receiptNo + "%";
                sql += "and receipt_No like @receiptNo ";
            }
            if (dto.status != 0)
            {
                sql += "and status = @status ";
            }
            if (dto.stn != 0)
            {
                sql += "and A.stn = @stn ";
            }
            if (dto.outType != 0)
            {
                sql += "and A.out_Type=@outType ";
            }
            if (dto.outTypeClass != 0)
            {
                sql += "and A.out_Type_Class=@outTypeClass ";
            }
            if (dto.createBeginTime != DateTime.MinValue)
            {
                sql += " AND A.begin_Time >= @createBeginTime ";
            }
            if (dto.createEndTime != DateTime.MinValue)
            {
                sql += " AND A.begin_Time <= @createEndTime ";
            }
            if (dto.finishBeginTime != DateTime.MinValue)
            {
                sql += " AND A.finsh_Time >= @finishBeginTime ";
            }
            if (dto.finishEndTime != DateTime.MinValue)
            {
                sql += " AND A.finsh_Time <= @finishEndTime ";
            }
            string orderBy = "priority,begin_Time  desc";
            return this.queryPage<ReceiptOutReportDto>(sql, orderBy, dto);

        }

        public List<WhReceiptOutDetail> GetListByReceiptId(long receiptId)
        {
            string sql = "select * from Wh_Receipt_out_detail where receipt_Id=@receiptId";
            return Connection.Query<WhReceiptOutDetail>(sql, new { receiptId = receiptId }).ToList();
        }
        public bool UpdateUploadById(long id)
        {
            string sql = @"update Wh_Receipt_out set upload=1 where id=@id";
            Connection.Execute(sql, new { id = id });
            return true;
        }

        public List<ReceiptOutReportDto> GetExportList(ReceiptDto dto)
        {
            string sql = @"SELECT A.pick_Type,A.Priority,A.out_Type,A.stn,A.status,A.receipt_No,C.name AS itemName,a.begin_Time,a.finsh_Time,b.plan_Count,B.finsh_Count,B.active_Count,B.batch_No 
                            FROM dbo.Wh_Receipt_out A
                            INNER JOIN dbo.Wh_Receipt_out_detail B ON A.id = B.receipt_id
                            LEFT JOIN dbo.core_item C ON B.item_Id = C.id
                            WHERE 1=1 ";

            if (!string.IsNullOrEmpty(dto.receiptNo))
            {
                dto.receiptNo = "%" + dto.receiptNo + "%";
                sql += "and receipt_No like @receiptNo ";
            }
            if (dto.status != 0)
            {
                sql += "and status = @status ";
            }
            if (dto.stn != 0)
            {
                sql += "and A.stn = @stn ";
            }
            if (dto.outType != 0)
            {
                sql += "and A.out_Type=@outType ";
            }
            if (dto.outTypeClass != 0)
            {
                sql += "and A.out_Type_Class=@outTypeClass ";
            }
            if (dto.createBeginTime != DateTime.MinValue)
            {
                sql += " AND A.begin_Time >= @createBeginTime ";
            }
            if (dto.createEndTime != DateTime.MinValue)
            {
                sql += " AND A.begin_Time <= @createEndTime ";
            }
            if (dto.finishBeginTime != DateTime.MinValue)
            {
                sql += " AND A.finsh_Time >= @finishBeginTime ";
            }
            if (dto.finishEndTime != DateTime.MinValue)
            {
                sql += " AND A.finsh_Time <= @finishEndTime ";
            }
            string orderBy = "order by priority,begin_Time  desc";
            return Connection.Query<ReceiptOutReportDto>(sql + orderBy, dto).ToList();
        }
    }
}
