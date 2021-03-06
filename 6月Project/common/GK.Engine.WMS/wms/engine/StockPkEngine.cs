﻿
using System;
using System.Data;
using Dapper;
using System.Collections.Generic;
using GK.WMS.Entity;
using System.Linq;
using GK.WMS.DAL;
using GK.WMS.Entity.wms;
using GK.Engine.WMS.wms;
using GK.FMXT.DAL;
using WMS.DAL;
using Mongon;

namespace GK.Engine.WMS
{
    public class StockPkEngine : WmsBaseEngine
    {
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();

        public WhReceiptPk whReceiptPk = null;
        protected override bool Execute(IDbConnection Connection, IDbTransaction transaction,ref string errorMsg)
        {
            List<CoreStockParam> list = GetStockList(Connection, transaction, whReceiptPk);

            #region 验证逻辑
            if (list == null || list.Count == 0)
            {
                errorMsg = whReceiptPk.id + " 该物料库存不存在,无法生成盘库任务";
                MessagelogUtil.savelog(whReceiptPk.id + " 该物料库存不存在,无法生成盘库任务");
                return false;
            }
            foreach (var stockItem in list)
            {
                if (stockItem.pkStatus == 1)
                {
                    errorMsg = whReceiptPk.id + " 盘库状态为盘库中,不能生成盘库任务";
                    MessagelogUtil.savelog(whReceiptPk.id + " 盘库状态为盘库中,不能生成盘库任务");
                    return false;
                }
                //if (stockItem.stockStatus != 2)
                //{
                //    MessagelogUtil.savelog(whReceiptPk.id + " 该物料不在库存中,不能生成盘库任务");
                //    return false;
                //}
            }
            #endregion

            List<long> stockIdList = new List<long>();

            for (int i = 0; i < list.Count; i++)
            {
                CoreStockParam param = list[i];
                if (!stockIdList.Contains(param.stockId))
                {
                    //出库
                    long id = CommentFunction.InsertTask(Connection, transaction, param.stockId, param.areaId, param.boxCode, 401, 2, param.locId, whReceiptPk.stn ?? 0);
                    //入库
                    CommentFunction.InsertTask(Connection, transaction, param.stockId, param.areaId, param.boxCode, 401, 1, whReceiptPk.stn ?? 0, param.locId, id);
                    CommentFunction.UpdateStock(Connection, transaction, param.id, 3, 1);
                }
                //CommentFunction.InsertTaskDetail(Connection, transaction, param.stockDetailId);
                CommentFunction.InsertPkDetail(Connection, transaction, param, whReceiptPk.id);
                //不需要修改库存明细为出库中
                CommentFunction.UpdateStockDetailStatus(Connection, transaction, param.stockDetailId, 1, 3, whReceiptPk.id);
                //更新主键
                CodeInfoUtil.UpdatePkDetailId(param.stockDetailId, whReceiptPk.id);
                stockIdList.Add(param.stockId);
            }
            whReceiptPk.status = 2;
            Connection.updateNotNull<WhReceiptPk>(whReceiptPk, transaction);
            return true;
        }

        public List<CoreStockParam> GetStockList(IDbConnection Connection, IDbTransaction transaction, WhReceiptPk model)
        {
            string sql = @"SELECT *,B.id AS stockDetailId FROM dbo.Core_stock A 
                         LEFT OUTER JOIN dbo.core_stock_detail B ON A.id = B.stock_Id WHERE B.stock_Status=2 ";

            if (model.itemId != null)
            {
                sql += " and item_Id = @itemId ";
            }
            if (model.banchNo != null)
            {
                sql += " AND wms_Banch_No =@banchNo ";
            }
            if (model.beginTime != null)
            {
                sql += " AND change_Time >@beginTime ";
            }
            if (model.finshTime != null)
            {
                sql += " AND change_Time <@finshTime ";
            }

            return Connection.Query<CoreStockParam>(sql, model, transaction).ToList();
        }
    }
}
