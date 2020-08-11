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
    public class SyncFlatOutReult : WmsBaseEngine
    {
        
        public long id;
        public int? finshCount;
        public string remark;

        IReceiptInServer receiptInServer = WMSDalFactray.getDal<IReceiptInServer>();
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();
        //平库完成反馈
        protected override bool Execute(IDbConnection conn, IDbTransaction tran, ref string errorMsg)
        {
            string sql3 = "select * from dbo.wh_batch where id=@id";
            WhBatch whBatch= conn.Query<WhBatch>(sql3, new { id = id }, tran).FirstOrDefault();
            string sql= "update dbo.wh_batch set count=count-@finshCount where id=@id";
             conn.Execute(sql, new { finshCount= finshCount, id= id },tran);
             string sql1= "select count from dbo.wh_batch where id=@id";
            //int count = conn.Query<int>(sql1, new { id = id }, tran).FirstOrDefault();
            //if (count <= 0)
            //{
            //    string sql2 = "delete dbo.wh_batch where id=@id";
            //    conn.Execute(sql2, new { id = id }, tran);
            //}
            WhReceiptOutDetail whReceiptOutDetail=new WhReceiptOutDetail();
             whReceiptOutDetail.id= sequenceIdServer.getId();
             whReceiptOutDetail.planCount=finshCount;
             whReceiptOutDetail.finshCount=finshCount;
             whReceiptOutDetail.activeCount=finshCount;
             whReceiptOutDetail.itemId=whBatch.itemId;
             whReceiptOutDetail.batchId=whBatch.id;
             whReceiptOutDetail.batchNo=whBatch.batchNo;
             whReceiptOutDetail.createTime=DateTime.Now;
             whReceiptOutDetail.remark=remark;
             conn.InsertNoNull<WhReceiptOutDetail>(whReceiptOutDetail,tran);
             return true;



        }



    }
}
