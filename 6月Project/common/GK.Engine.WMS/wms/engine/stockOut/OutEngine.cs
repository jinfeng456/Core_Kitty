
using System;
using System.Data;
using Dapper;
using System.Collections.Generic;
using GK.WMS.Entity;
using System.Linq;
using GK.WMS.DAL;
using GK.WMS.Entity.wms;
using GK.Engine.WMS.wms;
using GK.Mongon;

namespace GK.Engine.WMS
{
    public abstract class OutEngine : WmsBaseEngine
    {
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();

        public WhReceiptOut whReceipt = null;
        protected sealed override bool Execute(IDbConnection Connection, IDbTransaction transaction, ref string errorMsg)
        {
            if (whReceipt == null)
            {
                return false;
            }
            //获取所有批次
            var batchList = new List<WhBatch>();
            //
            var detailList = GetDetailList(Connection, transaction, whReceipt.id);
            if (detailList == null || detailList.Count == 0)
            {
                MessagelogUtil.savelog(whReceipt.id + " 出库单明细不存在!");
                errorMsg= (whReceipt.id + " 出库单明细不存在!");
                return false;
            }
            foreach (var receptOutDetail in detailList)
            {
                bool doOut = doOutDetail(Connection, transaction, receptOutDetail, whReceipt, batchList,ref errorMsg);
                if (!doOut)
                {
                    return false;
                }
            }
            //生成任务后将状态改为执行中 
            whReceipt.status = 2;
            Connection.updateNotNull<WhReceiptOut>(whReceipt, transaction);
            return true;

        }

        bool doOutDetail(IDbConnection Connection, IDbTransaction transaction, WhReceiptOutDetail receptOutDetail, WhReceiptOut whReceipt, List<WhBatch> batchList,ref string errorMsg)
        {
            bool result = false;
            List<CoreStockParam> list = GetStockList(Connection, transaction, receptOutDetail);
            if (!checkDetail(receptOutDetail, list, whReceipt.pickType,ref errorMsg))
            {
                return false;
            }
            List<long> stockIdList = new List<long>();
            long taskId = 0;
            int nowOutCount = receptOutDetail.planCount ?? 0;
            for (int i = 0; i < list.Count; i++)
            {
                #region 注释在查询的时候过滤
                //WhBatch batch = null;
                //var batchCollection = batchList.Where(a => a.id == list[i].batchId).ToList();
                //if (batchCollection.Count == 0)
                //{
                //    batch = Connection.Get<WhBatch>(list[i].batchId, transaction);
                //    batchList.Add(batch);
                //}
                //else
                //{
                //    batch = batchCollection[0];
                //}
                //if (batch == null)
                //{
                //    MessagelogUtil.savelog(whReceipt.id + " 该批次不存在!");
                //    errorMsg = whReceipt.id + " 该批次不存在!";
                //    return false;
                //}
                ////如果为合格才能进行任务生成
                //if (!checkBatch(batch))
                //{                 
                //    MessagelogUtil.savelog(whReceipt.id + " 该批次不合格,不能生成出库任务");                    
                //    continue;
                //}
                #endregion
                result = true;
                CoreStockParam param = list[i];
                if (!stockIdList.Contains(param.stockId))
                {
                    taskId = CommentFunction.InsertTask(Connection, transaction, param.stockId, param.areaId, param.boxCode, getStatus(), 2, param.locId, whReceipt.stn);
                    CommentFunction.UpdateStock(Connection, transaction, param.stockId, 3);
                    stockIdList.Add(param.stockId);
                }
                CommentFunction.InsertTaskDetail(Connection, transaction, param.stockDetailId, taskId);
                CommentFunction.UpdateStockDetail(Connection, transaction, param.stockDetailId, 3, receptOutDetail.id);
                //自动分配
                if (whReceipt.pickType == 1)
                {
                    nowOutCount -= list[i].countDb;
                    if (nowOutCount <= 0) //任务全部生成完
                    {
                        if (nowOutCount < 0)
                        {
                            CommentFunction.UpdateStockCount(Connection, transaction, param.stockDetailId, nowOutCount + list[i].countDb);
                            CommentFunction.InsertStockDetail(Connection, transaction, param, 0, 2, -nowOutCount, param.wmsBanchNo);
                        }
                        break;
                    }
                }
            }
            return result;
        }



        public bool checkDetail(WhReceiptOutDetail receptOutDetail, List<CoreStockParam> list, int pickType,ref string errorMsg)
        {
            if (list == null || list.Count == 0)
            {
                errorMsg = whReceipt.id + " 该物料库存不存在,无法生成出库任务";
                MessagelogUtil.savelog(whReceipt.id + " 该物料库存不存在,无法生成出库任务");
                return false;
            }
            foreach (var stockItem in list)
            {
                if (stockItem.pkStatus == 1)//主表的盘库状态
                {
                    errorMsg = whReceipt.id + " 盘库状态为盘库中,无法生成出库任务";
                    MessagelogUtil.savelog(whReceipt.id + " 盘库状态为盘库中,无法生成出库任务");
                    return false;
                }
                //if (stockItem.stockStatus != 2)
                //{
                //    MessagelogUtil.savelog(whReceipt.id + " 该物料不在库存中,不能生成出库任务");
                //    return false;
                //}
            }
            //自动分配校验库存不足,人工拣选不用
            if (pickType == 1)
            {
                if (list.Sum(a => a.countDb) < receptOutDetail.planCount)
                {
                    errorMsg= whReceipt.id + " 该物料库存不足,不能生成出库任务";
                    MessagelogUtil.savelog(whReceipt.id + " 该物料库存不足,不能生成出库任务");
                    return false;
                }
            }
            return true;
        }

        public abstract bool checkBatch();

        public abstract String getParamQueryOrder();

        public abstract int getStatus();
        public List<CoreStockParam> GetStockList(IDbConnection Connection, IDbTransaction transaction, WhReceiptOutDetail whReceiptDetail)
        {
            string sql = @"SELECT *,B.id AS stockDetailId FROM dbo.Core_stock A 
                         INNER JOIN dbo.core_stock_detail B ON A.id = B.stock_Id WHERE B.stock_Status = 2 ";

            if (whReceiptDetail.itemId != null)
            {
                sql += " and item_Id = @itemId ";
            }
            
            if (whReceiptDetail.batchId != null)
            {
                sql += " AND batch_Id =@batchId ";
            }
            //过滤合格的状态
            if (checkBatch())
            {
                sql += " AND r_bussiness_status =3 ";
            }
            //if (whReceipt.beginTime != DateTime.MinValue)
            //{
            //    sql += " AND change_Time >@beginTime ";
            //}
            //if (whReceipt.finshTime != DateTime.MinValue)
            //{
            //    sql += " AND change_Time <@finshTime ";
            //}
            sql += getParamQueryOrder();
            return Connection.Query<CoreStockParam>(sql, new { itemId = whReceiptDetail.itemId, batchId = whReceiptDetail.batchId }, transaction).ToList();
        }


        public List<WhReceiptOutDetail> GetDetailList(IDbConnection Connection, IDbTransaction transaction, long receiptId)
        {
            string sql = @"SELECT * FROM Wh_Receipt_out_detail WHERE 1=1 ";
            if (receiptId != 0)
            {
                sql += " AND receipt_Id =@id ";
            }
            return Connection.Query<WhReceiptOutDetail>(sql, new { id = receiptId }, transaction).ToList();
        }

        public List<WhBatch> GetAllBatchList(IDbConnection Connection, IDbTransaction transaction)
        {
            string sql = "SELECT * FROM wh_batch ";
            return Connection.Query<WhBatch>(sql, Connection, transaction).ToList();
        }
    }
}
