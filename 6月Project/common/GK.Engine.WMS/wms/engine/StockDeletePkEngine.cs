
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
using Engine.WMS;
using WMS.Entity;

namespace GK.Engine.WMS
{
    public class StockDeletePkEngine : WmsBaseEngine
    {
        public WhReceiptPk whReceiptPk = null;
        protected override bool Execute(IDbConnection Connection, IDbTransaction transaction,ref string errorMsg)
        {
            //1、删除盘库单任务
            CommentFunction.DeletePK(Connection, transaction, whReceiptPk.id);

            //2、根据盘库单Id修改库存明细中的状态
            CommentFunction.UpdateStockDetailStatusByPKId(Connection, transaction, whReceiptPk.id, 0, 2);

            //通过ReceiptPkId获取core_stock_detail集合
            List<CoreStockDetail> list = CommentFunction.GetStockDetailList(Connection, transaction, whReceiptPk);


            List<long> stockIdList = new List<long>();
            //5、根据库存明细Id修改CoreCodeInfo中uploadStatus，若为2删除，3改为1
            for (int i = 0; i < list.Count; i++)
            {
                if (!stockIdList.Contains((long)list[i].stockId))
                {
                    //3、根据库存明细Id,修改core_stock的状态
                    CommentFunction.UpdateStock(Connection, transaction, (long)list[i].stockId, 2, 0);

                    //4、根据core_stock的Id修改core_task的状态为-1和receipt_Finish为0
                    CommentFunction.UpdateCoreTaskStatus(Connection, transaction, (long)list[i].stockId, -2, 0);
                    stockIdList.Add((long)list[i].stockId);
                }
                CodeInfoUtil.UpdateCoreTaskUploadStatus(list[i].id);
            }
            return true;
        }

    }
}
