using Dapper;
using GK.Common.trans;
using GK.Engine.WMS.wms;
using GK.Mongon;
using GK.WMS.DAL;
using GK.WMS.Entity;
using GK.WMS.Entity.wms;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace GK.Engine.WMS
{
    public class SyncFlatReult : WmsBaseEngine
    {
        public int finshCount; 
        public long areaId;
        public long reDetailId;
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();
        IItemServer itemServer = WMSDalFactray.getDal<IItemServer>();
        IReceiptInServer receiptInServer = WMSDalFactray.getDal<IReceiptInServer>();
        //平库完成反馈
        protected override bool Execute(IDbConnection conn, IDbTransaction tran, ref string errorMsg)
        {
       
           return updateFlatBatch( conn,  tran, finshCount, areaId,reDetailId);
        }

     
      

        bool updateFlatBatch(IDbConnection conn, IDbTransaction tran, int finshCount, long areaId, long reDetailId)
        {
            
            string sql2= "select * from dbo.Wh_Receipt_in_detail where id=@reDetailId";
            WhReceiptInDetail detail = conn.Query<WhReceiptInDetail>(sql2, new { reDetailId= reDetailId },tran).FirstOrDefault();
            WhBatch whBatch = GetWhbatch(conn, tran, detail.wmsBanchNo,detail.itemId);
            //string sql= "select SUM(plan_Count) from dbo.Wh_Receipt_in_detail where item_Id=@itemId and wms_Banch_No=@wmsBanchNo";
            //int beginCount=conn.Query<int>(sql, new { itemId= detail.itemId, wmsBanchNo= detail.wmsBanchNo },tran).FirstOrDefault();
            string sql= "update dbo.Wh_Receipt_in_detail set finsh_Count=@finshCount,wh_area_id=@areaId where id=@reDetailId";
            if (whBatch == null)
            {
                whBatch = new WhBatch();
                whBatch.id = sequenceIdServer.getId();
                long batchId = whBatch.id;
                whBatch.itemId = long.Parse(detail.itemId.ToString());
                CoreItem coreItem = itemServer.FindCoreItemById(long.Parse(detail.itemId.ToString()));
                whBatch.itemName = coreItem.name;
                whBatch.itemType = coreItem.classifyId;
                whBatch.count = finshCount;
                whBatch.batchNo = detail.wmsBanchNo;
                whBatch.businessStatus = 1;
                whBatch.frozen = 0;
                whBatch.type = coreItem.coreItemType;
                whBatch.whAreaId= areaId;
                //whBatch.beginCount=beginCount;
                conn.InsertNoNull(whBatch, tran);
                conn.Execute(sql, new { finshCount= finshCount, areaId= areaId, reDetailId = reDetailId },tran);

            }
            else
            {
                string sql1= "update dbo.wh_batch set count=@finshCount,wh_area_id=@areaId where item_Id=@itemId and batch_No=@wmsBanchNo";
                conn.Execute(sql1, new { finshCount= finshCount, areaId= areaId,itemId = detail.itemId, wmsBanchNo = detail.wmsBanchNo },tran);
                conn.Execute(sql, new { finshCount = finshCount, areaId= areaId, reDetailId = reDetailId }, tran);
            }
            return true;
        }
     

    
    

        //根据批次号查找批次信息
        public WhBatch GetWhbatch(IDbConnection conn, IDbTransaction tran, string batchNo,long? itemId)
        {
            String sql = @"select * from wh_batch where batch_No=@batchNo and item_Id=@itemId ";
            List<WhBatch> list = conn.Query<WhBatch>(sql, new { batchNo = batchNo , itemId = itemId }, tran).ToList();
            if (list.Count == 1)
            {
                return list[0];
            }
            else if (list.Count > 1)
            {
                throw new Exception(batchNo + "批次过多");
            }
            else
            {
                return null;
            }

        }

      

    }
}
