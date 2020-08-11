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
    public abstract class AbsWhSoOutServer : AbsWMSBaseServer, IWhSoOutServer
    {
        #region 销售出库
        public List<WhSoOutReceipt> GetSoOutReceptList(long receiptId)
        {
            string sql = @"SELECT distinct soid FROM dbo.Wh_So_Out_Receipt where 1=1 ";
            if (receiptId != 0)
            {
                sql += " AND wh_Receipt_Id = @whReceiptId";
            }
            return Connection.Query<WhSoOutReceipt>(sql, new { whReceiptId = receiptId }).ToList();
        }

        public List<WhSoOutParam> GetWhSoOutList(string soidList)
        {
            string sql = @"SELECT B.*,A.so_No FROM dbo.Wh_So_Out A 
                           LEFT OUTER JOIN dbo.Wh_So_Out_Detail B
                           ON A.ID = B.soid where 1=1 and soid in (" + soidList + ")";
            return Connection.Query<WhSoOutParam>(sql).ToList();
        }

        public Page<WhSoOut> QueryWhSoOutPage<WhSoOut>(WhSoOutDto dto)
        {
            string sql = @"SELECT * FROM dbo.Wh_So_Out where 1=1 ";
            if (!string.IsNullOrEmpty(dto.soNo))
            {
                sql += " AND so_No = @soNo ";
            }
            //订单主键的集合
            if (!string.IsNullOrEmpty(dto.items))
            {
                if (dto.items != "ALL")
                {
                    sql += " AND id in (" + dto.items.Trim(',') + ")";
                }           
            }
            else
            {
                sql += " AND 1=2 ";
            }
            return this.queryPage<WhSoOut>(sql, "id", dto);
        }


        public Page<WhSoOut> QueryWhSoOutPages<WhSoOut>(WhSoOutDto dto)
        {
            string sql = @"select id,so_No,custom_Code,custom_Id,custom_Name,src_so_bill,Status,From_Corp_Id from wh_So_out where 1=1 ";
            if (!string.IsNullOrEmpty(dto.vbillcode))
            {
                dto.vbillcode = "%" + dto.vbillcode + "%";
                sql += " AND so_No like @vbillcode ";
            }
            if (!string.IsNullOrEmpty(dto.customName))
            {
                dto.customName = "%" + dto.customName + "%";
                sql += " AND custom_Name like @customName ";
            }
            if (!string.IsNullOrEmpty(dto.status))
            {
                if (dto.status == "执行中")
                {
                    sql += " AND status=1";
                }
                else
                {
                    sql += " AND status=2";

                }
            }
            return this.queryPage<WhSoOut>(sql, "id", dto);
        }

        //明细
        public List<WhSoOutDetail> GetOrderDetailId(WhSoOut whSoOut)
        {
            WhSoOutDetail whSoOutDetail = new WhSoOutDetail();
            whSoOutDetail.soid= whSoOut.id;
            long soId = whSoOut.id;
            String sql = @"select * from wh_So_Out_Detail where soid=@soId";
            List<WhSoOutDetail> list1 = Connection.Query<WhSoOutDetail>(sql, new { soId = soId }).ToList();
            return list1;
        }

        //根据订单主Id判断
        public List<WhSoOutDetail> GetBillNo(string src_so_bill)
        {
            String sql = @"select * from wh_So_out where src_So_bill=@src_so_bill";
            List<WhSoOutDetail> list1 = Connection.Query<WhSoOutDetail>(sql, new { src_so_bill = src_so_bill }).ToList();
            return list1;
        }
        //根据订单子Id判断
        public List<WhSoOutDetail> GetPkNo(string src_so_bill_detail)
        {
            String sql = @"select * from wh_So_Out_Detail where src_so_bill_detail=@src_so_bill_detail";
            List<WhSoOutDetail> list2 = Connection.Query<WhSoOutDetail>(sql, new { src_so_bill_detail = src_so_bill_detail }).ToList();
            return list2;
        }
        #endregion

        #region 生产出库
        //public List<WhSoOutReceipt> GetSoOutReceptList(long receiptId)
        //{
        //    string sql = @"SELECT distinct soid FROM dbo.Wh_So_Out_Receipt where 1=1 ";
        //    if (receiptId != 0)
        //    {
        //        sql += " AND wh_Receipt_Id = @whReceiptId";
        //    }
        //    return Connection.Query<WhSoOutReceipt>(sql, new { whReceiptId = receiptId }).ToList();
        //}

        //public List<WhSoOutParam> GetWhSoOutList(string soidList)
        //{
        //    string sql = @"SELECT B.*,A.so_No FROM dbo.Wh_So_Out A 
        //                   LEFT OUTER JOIN dbo.Wh_So_Out_Detail B
        //                   ON A.ID = B.soid where 1=1 and soid in (" + soidList + ")";
        //    return Connection.Query<WhSoOutParam>(sql).ToList();
        //}

        //public Page<WhSoOut> QueryWhSoOutPage<WhSoOut>(WhSoOutDto dto)
        //{
        //    string sql = @"SELECT * FROM dbo.Wh_So_Out where 1=1 ";
        //    if (!string.IsNullOrEmpty(dto.soNo))
        //    {
        //        sql += " AND so_No = @soNo ";
        //    }
        //    //订单主键的集合
        //    if (!string.IsNullOrEmpty(dto.items))
        //    {
        //        if (dto.items != "ALL")
        //        {
        //            sql += " AND id in (" + dto.items.Trim(',') + ")";
        //        }
        //    }
        //    else
        //    {
        //        sql += " AND 1=2 ";
        //    }
        //    return this.queryPage<WhSoOut>(sql, "id", dto);
        //}


        public Page<WhSoOutProduce> QueryWhSoOutProducePages<WhSoOutProduce>(WhSoOutProduceDto dto)
        {
            string sql = @" select id,so_No,applicant_Code,
                            applicant_Id,applicant_Name,src_so_bill,
                            CASE Status
                            WHEN 1 THEN '执行中'
                            ELSE '完成'
                            END AS Status
                            from wh_So_out_produce where 1=1 ";
            if (!string.IsNullOrEmpty(dto.vbillcode))
            {
                dto.vbillcode = "%" + dto.vbillcode + "%";
                sql += " AND so_No like @vbillcode ";
            }
            if (!string.IsNullOrEmpty(dto.applicantName))
            {
                dto.applicantName = "%" + dto.applicantName + "%";
                sql += " AND custom_Name like @customName ";
            }
            if (!string.IsNullOrEmpty(dto.status))
            {
                if (dto.status == "执行中")
                {
                    sql += " AND status=1";
                }
                else
                {
                    sql += " AND status=2";

                }
            }
            //订单主键的集合
            if (!string.IsNullOrEmpty(dto.items))
            {
                if (dto.items != "ALL")
                {
                    sql += " AND id in (" + dto.items.Trim(',') + ")";
                }
            }
            else
            {
                sql += " AND 1=2 ";
            }
            return this.queryPage<WhSoOutProduce>(sql, "id", dto);
        }


        public Page<WhSoOutProduce> WhSoOutProducePages<WhSoOutProduce>(WhSoOutProduceDto dto)
        {
            string sql = @" select id,so_No,applicant_Code,applicant_Id,applicant_Name,src_so_bill,Status,From_Corp_Id ,create_Date,finish_Date from wh_So_out_produce where 1=1 ";
            if (!string.IsNullOrEmpty(dto.vbillcode))
            {
                dto.vbillcode = "%" + dto.vbillcode + "%";
                sql += " AND so_No like @vbillcode ";
            }
            if (!string.IsNullOrEmpty(dto.applicantName))
            {
                dto.applicantName = "%" + dto.applicantName + "%";
                sql += " AND custom_Name like @customName ";
            }
            if (!string.IsNullOrEmpty(dto.status))
            {
                if (dto.status == "执行中")
                {
                    sql += " AND status=1";
                }
                else
                {
                    sql += " AND status=2";

                }
            }
            return this.queryPage<WhSoOutProduce>(sql, "id", dto);
        }
        //明细
        public List<WhSoOutProduceDetail> GetProduceDetailId(WhSoOutProduce whSoOutProduce)
        {
            WhSoOutProduceDetail whSoOutProduceDetail = new WhSoOutProduceDetail();
            whSoOutProduceDetail.soId = whSoOutProduce.id;
            long soId = whSoOutProduce.id;
            String sql = @"select * from wh_So_Out_Produce_Detail where so_Id=@soId";
            List<WhSoOutProduceDetail> list1 = Connection.Query<WhSoOutProduceDetail>(sql, new { soId = soId }).ToList();
            return list1;
        }

        //根据订单主Id判断
        public List<WhSoOutProduceDetail> GetBillProduceNo(string src_so_bill)
        {
            String sql = @"select * from wh_So_out_Produce where src_So_Bill=@src_so_bill";
            List<WhSoOutProduceDetail> list1 = Connection.Query<WhSoOutProduceDetail>(sql, new { src_so_bill = src_so_bill }).ToList();
            return list1;
        }
        //根据订单子Id判断
        public List<WhSoOutProduceDetail> GetPkProduceNo(string src_so_bill_detail)
        {
            String sql = @"select * from wh_So_Out_Produce_Detail where src_so_bill_Detail=@src_so_bill_detail";
            List<WhSoOutProduceDetail> list2 = Connection.Query<WhSoOutProduceDetail>(sql, new { src_so_bill_detail = src_so_bill_detail }).ToList();
            return list2;
        }

        //根据订单主键 查询订单明细,将所有产品插入
        public List<WhSoProduceParam> GetWhSoProduceList(string soidList)
        {
            string sql = @"SELECT B.*,A.so_No FROM dbo.Wh_So_Out_Produce A 
                           LEFT OUTER JOIN dbo.Wh_So_Out_Produce_Detail B
                           ON A.ID = B.so_Id where 1=1 and so_Id in (" + soidList + ")";
            return Connection.Query<WhSoProduceParam>(sql).ToList();
        }


        #endregion
        public List<WhSoOutDetail> GetDetails(long soId)
        {
            String sql = "select * from Wh_So_Out_Detail  where soid=@soId";

            return Connection.Query<WhSoOutDetail>(sql, new { soId }).ToList();
        }
        public List<WhSoOut> getWhSoOut(long id)
        {
            string sql = @"select * from Wh_So_Out where id=@id ";
            List<WhSoOut> list = Connection.Query<WhSoOut>(sql, new { id = id }).ToList();
            return list;
        }

    }
}
