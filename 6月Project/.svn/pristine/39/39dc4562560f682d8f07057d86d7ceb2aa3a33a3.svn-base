using Dapper;
using GK.Common.trans;
using GK.Engine.WMS.wms;
using GK.Mongon;
using GK.WMS.DAL;
using GK.WMS.Entity;
using GK.WMS.Entity.wms;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Text;

namespace GK.Engine.WMS
{
    public class SyncWcsReultEngine : WmsBaseEngine
    {
        public CoreTaskParam coreTaskParam = null;
        public long taskId;
        public int taskStatus;
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();
        IItemServer itemServer = WMSDalFactray.getDal<IItemServer>();
        //入库完成反馈
        protected override bool Execute(IDbConnection conn, IDbTransaction tran, ref string errorMsg)
        {
            CoreTask ct = CommentFunction.getCoreTask(conn, tran, taskId);
            CoreStock cs = CommentFunction.getCoreStock(conn, tran, ct.stockId);
            int taskType = ct.taskType;
            if (taskType == 1)
            {// 入库
                if (taskStatus == -1)
                {
                    CommentFunction.closureTask(conn, tran, taskId, -1);

                    CommentFunction.taskFinshUpdateStock(conn, tran, ct, -1);
                    CommentFunction.UpdataWhLoc(conn, tran, ct.src);
                }
                else if (taskStatus == 3)
                {
                    CommentFunction.closureTask(conn, tran, taskId, 4);
                    CommentFunction.taskFinshUpdateStock(conn, tran, ct, 2);

                    return inFinsh(conn, tran, ct, cs, ref errorMsg);

                }
            }
            else if (taskType == 2)
            {//出库
                if (taskStatus == -1)
                {
                    CommentFunction.closureTask(conn, tran, taskId, -1);
                    CommentFunction.taskFinshUpdateStock(conn, tran, ct, 2);
                }
                else if (taskStatus == 3)
                {
                    CommentFunction.closureTask(conn, tran, taskId, 4);
                    List<CoreStockDetail> list = GetCoreStockDetailOut(conn, tran, cs.id);//先获取后更新状态
                    CommentFunction.taskFinshUpdateStock(conn, tran, ct, -1);
                    CommentFunction.UpdataWhLoc(conn, tran, ct.src);
                    return OutStock(conn, tran, ct, cs, list);
                }
            }
            return true;
        }

        public bool inFinsh(IDbConnection conn, IDbTransaction tran, CoreTask ct, CoreStock cs, ref string errorMsg)
        {
            long stockId = cs.id;
            List<CoreStockDetail> list = GetCoreStockDetail(conn, tran, stockId);

            CoreStockDetail detail = list[0];
            int count = int.Parse(detail.countDb.ToString());
            //根据内部批次号查找批次
            long whBatchId = updateBatch(conn, tran, detail, ref errorMsg);
            UpdataStockDetailBatchID(conn, tran, stockId, whBatchId);
            int batchCount = GetBatchCount(conn, tran, detail.wmsBanchNo);
            UpdataBatchCountOut(conn, tran, detail.wmsBanchNo, batchCount);
            long receiptInId = (long)detail.receiptlnId;
            int finishCount = GetCountByReceiptinId(conn, tran, receiptInId);
            UpdataReceiptDetail(conn, tran, receiptInId,finishCount);
            //插入statReal表
            CoreItem coreItem = connection.GetById<CoreItem>(WMSDalFactray.prefixal, (long)detail.itemId, tran);
            WhReceiptInDetail indetail = conn.GetById<WhReceiptInDetail>(WMSDalFactray.prefixal, (long)detail.receiptlnId, tran);
            AddStatReal(detail.wmsBanchNo, ct.src, ct.des, finishCount, batchCount, detail.packUnit, indetail.id, coreItem);
            return true;
        }
        public bool OutStock(IDbConnection conn, IDbTransaction tran, CoreTask ct, CoreStock cs, List<CoreStockDetail> list)
        {
            foreach (CoreStockDetail detail in list)
            {
                int batchCount = GetBatchCount(conn, tran, detail.wmsBanchNo);
                UpdataBatchCountOut(conn, tran, detail.wmsBanchNo, batchCount);
                UpdataWhReceiptDetailOut(conn, tran, (long)detail.receiptlOutId);//???
                WhReceiptOutDetail outdetail = conn.GetById<WhReceiptOutDetail>(WMSDalFactray.prefixal, (long)detail.receiptlOutId, tran);
                if (outdetail == null)
                {
                    return true;
                }
                finshWhReceiptOut(conn, tran, (long)outdetail.receiptId);
                long soDetailId = (long)outdetail.soDetailId;
                if (soDetailId == 0)
                {
                    continue;
                }
                updateSoOutDetail(conn, tran, (long)detail.receiptlOutId);
                long soId = conn.Query<long>(@"SELECT    [soid] FROM [wms].[dbo].[Wh_So_Out_Detail] where id=@soDetailId", new
                {
                    soDetailId = soDetailId
                }, tran).FirstOrDefault();
                bool b = finshSoOut(conn, tran, soId);
                if (!b)
                {
                    return false;
                }
                //插入stat_real 报表
                CoreItem coreItem = connection.GetById<CoreItem>(WMSDalFactray.prefixal, (long)detail.itemId, tran);
                AddStatReal(detail.wmsBanchNo, ct.src, ct.des, (int)outdetail.finshCount, batchCount, detail.packUnit, outdetail.id, coreItem);
            }
            return true;
        }



        long AddStatReal(string batchNo, int start, int end, int count, int remain, string unit, long receiptDetailId, CoreItem coreItem)
        {
            StatReal statReal = new StatReal();
            statReal.id = sequenceIdServer.getId();
            statReal.wmsBanchNo = batchNo;
            statReal.sourceWhither = start + "/" + end;
            statReal.forword = 2;
            statReal.count = count;
            statReal.remain = remain;
            statReal.unit = unit;
            statReal.receiptDetailId = receiptDetailId;
            statReal.itemName = coreItem.name;
            statReal.itemCode = coreItem.code;
            statReal.itemId = coreItem.id;
            statReal.modelSpecs = coreItem.modelSpecs;
            statReal.packageSpecs = coreItem.packageSpecs;
            statReal.opTime = DateTime.Now;
            return connection.InsertNoNull(statReal);
        }
        long updateBatch(IDbConnection conn, IDbTransaction tran, CoreStockDetail detail, ref string errorMsg)
        {
            WhBatch whBatch = GetWhbatch(conn, tran, detail.wmsBanchNo, ref errorMsg);
            if (whBatch == null)
            {
                whBatch = new WhBatch();
                whBatch.id = sequenceIdServer.getId();
                long batchId = whBatch.id;
                whBatch.itemId = long.Parse(detail.itemId.ToString());
                CoreItem coreItem = itemServer.FindCoreItemById(long.Parse(detail.itemId.ToString()));
                whBatch.itemName = coreItem.name;
                whBatch.itemType = coreItem.classifyId;
                whBatch.count = 0;
                whBatch.batchNo = detail.wmsBanchNo;
                whBatch.businessStatus = 1;
                whBatch.frozen = 0;
                whBatch.type = 1;
                conn.InsertNoNull(whBatch, tran);
            }
            return whBatch.id;
        }
        //根据库存明细id获取其他信息
        public List<CoreStockDetail> GetCoreStockDetail(IDbConnection conn, IDbTransaction tran, long id)
        {
            String sql = @"select * from core_stock_detail where stock_Id=@id  and stock_Status=2";//不存在出库中的记录,否则无法入库,库外也不存在,入库扫码时需要验证
            List<CoreStockDetail> list = conn.Query<CoreStockDetail>(sql, new { id = id }, tran).ToList();
            return list;
        }

        //修改库存明细中批次ID
        public bool UpdataStockDetailBatchID(IDbConnection conn, IDbTransaction tran, long stockId, long batchId)
        {
            string sql = @"update core_stock_detail set batch_Id=@batchId where stock_Id=@stockId";
            conn.Execute(sql, new { stockId = stockId, batchId = batchId }, tran);
            return true;
        }
        //通过入库单ID修改数量
        public bool UpdataReceiptDetail(IDbConnection conn, IDbTransaction tran, long receiptId,int finishCount)
        {
            string sql = @"update Wh_Receipt_in_detail set finsh_Count=@finishCount where id=@receiptId";
            conn.Execute(sql, new { receiptId = receiptId, finishCount = finishCount }, tran);
            return true;
        }

        //根据批次号查找批次信息
        public WhBatch GetWhbatch(IDbConnection conn, IDbTransaction tran, string batchNo, ref string errorMsg)
        {
            String sql = @"select * from wh_batch where batch_No=@batchNo ";
            List<WhBatch> list = conn.Query<WhBatch>(sql, new { batchNo = batchNo }, tran).ToList();
            if (list.Count == 1)
            {
                return list[0];
            }
            else if (list.Count > 1)
            {
                errorMsg = batchNo + "批次过多";
                throw new Exception(batchNo + "批次过多");
            }
            else
            {
                return null;
            }

        }

        //出库完成逻辑
        void updateSoOutDetail(IDbConnection conn, IDbTransaction tran, long receiptOutDetailId)
        {
            String sql = "update  [Wh_So_Out_Detail] set [finsh_Count]=(SELECT sum(finsh_Count)   FROM  [Wh_Receipt_out_detail]  where so_Detail_Id=@id) where id=@id";
            conn.Execute(sql, new { id = receiptOutDetailId }, tran);
        }

        bool finshSoOut(IDbConnection conn, IDbTransaction tran, long soId)
        {
            String sql = @" SELECT count(*) FROM [wms].[dbo].[Wh_So_Out_Detail]  where [count]<> [finsh_Count] and soid=@soId";
            int count = conn.Query<int>(sql, new { soId = soId }, tran).FirstOrDefault();
            if (count == 0)
            {
                sql = @"update Wh_so_out set status=2 , finsh_Date=GETDATE() where id=@id";
                conn.Execute(sql, new { id = soId }, tran);
            }
            return true;
        }

        //通过出库单Id修改出库单状态和完成时间(3)
        public void finshWhReceiptOut(IDbConnection conn, IDbTransaction tran, long receiptId)
        {
            String sql = @"SELECT count(*) FROM [wms].[dbo].[Wh_Receipt_out_detail]  where plan_Count<> finsh_Count and [receipt_id]=@id";
            int count = conn.Query<int>(sql, new { id = receiptId }, tran).FirstOrDefault();
            if (count == 0)
            {
                string sql1 = @"update Wh_Receipt_out set Status=3,finsh_Time=GETDATE() where id=@receiptId";
                conn.Execute(sql1, new { receiptId = receiptId }, tran);
            }
        }
        //根据库存明细id获取其他信息
        public List<CoreStockDetail> GetCoreStockDetailOut(IDbConnection conn, IDbTransaction tran, long id)
        {
            String sql = @"select * from core_stock_detail where stock_Id=@id and stock_status=3 ";
            List<CoreStockDetail> list = conn.Query<CoreStockDetail>(sql, new { id = id }, tran).ToList();
            return list;
        }


        public int GetBatchCount(IDbConnection conn, IDbTransaction tran, string batchNo)
        {
            string sql = "select ISNULL(sum(count_db),0) from [core_stock_detail] where stock_Status=2 and wms_Banch_No=@batchNo ";
            return conn.Query<int>(sql, new { batchNo = batchNo }, tran).FirstOrDefault();
        }

        /// <summary>
        /// 根据入库单明细ID 获取库存数量(为完成数量)
        /// </summary>
        /// <param name="conn"></param>
        /// <param name="tran"></param>
        /// <param name="receiptInId"></param>
        /// <returns></returns>
        public int GetCountByReceiptinId(IDbConnection conn, IDbTransaction tran, long receiptInId)
        {
            string sql = "select ISNULL(sum(count_db),0) from [core_stock_detail] where stock_Status=2 and receiptln_Id=@receiptInId ";
            return conn.Query<int>(sql, new { receiptInId = receiptInId }, tran).FirstOrDefault();
        }
        //修改批次数量
        public void UpdataBatchCountOut(IDbConnection conn, IDbTransaction tran, string batchNo, int count)
        {
            string sql = @"update wh_batch set count=@count where batch_No=@batchNo";
            conn.Execute(sql, new { batchNo = batchNo, count = count }, tran);

        }
        //修改货位数量

        //修改出库单明细数量
        public bool UpdataWhReceiptDetailOut(IDbConnection conn, IDbTransaction tran, long id)
        {
            string sql = @"update Wh_Receipt_out_detail set finsh_Count=(SELECT sum( [Count_Db]  )  FROM [wms].[dbo].[core_stock_detail]  where receiptl_Out_Id=@id) where id=@id";
            conn.Execute(sql, new { id = id }, tran);
            return true;
        }

    }
}
