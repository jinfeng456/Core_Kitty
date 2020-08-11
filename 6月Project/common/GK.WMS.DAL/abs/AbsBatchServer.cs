using Dapper;
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

namespace GK.WMS.DAL
{

    public abstract class AbsBatchServer : AbsWMSBaseServer, IBatchServer
    {
        ISequenceIdServer sequenceServer = WMSDalFactray.getDal<ISequenceIdServer>();



        public Page<Batch> QueryBatchPage<Batch>(BatchDto dto)
        {
            string sql;
            if (dto.whAreaId != 0)
            {   
                sql = "select * from wh_batch where 1=1 and wh_area_id in (185203,198801,198802,198803,198804) and count>=0  ";
            }
            else
            {
                 sql = "select * from wh_batch where 1=1 ";
            }
           
            if (!string.IsNullOrEmpty(dto.batchNo))
            {
                dto.batchNo = "%" + dto.batchNo + "%";
                sql += " AND batch_No like @batchNo ";
            }
            if (!string.IsNullOrEmpty(dto.itemName))
            {
                dto.itemName = "%" + dto.itemName + "%";
                sql += " AND item_Name like @itemName ";
            }
            if (dto.businessStatus != 0)
            {
                sql += " AND business_Status = @businessStatus ";
            }
            if (dto.id != 0)
            {
                sql += " AND id = @id ";
            }
            if (dto.itemId != 0)
            {
                sql += " AND item_Id = @itemId ";
            }
            if (dto.type != 0)
            {
                sql += " AND type = @type ";
            }

           
            //预警信息提示
            if (dto.isWarning)
            {
                sql += " AND datediff(DAY,business_Exp,getdate())>0  ";
            }
            return this.queryPage<Batch>(sql, "id", dto);
        }

        /// <summary>
        /// 同步批次
        /// </summary>
        /// <returns></returns>
        public string Synchronization()
        {
            string sqlRemote = "select * from Inf_Batch where 1=1 ";
            var remoteBatchList = Connection.Query<InfBatch>(sqlRemote).ToList();
            if (remoteBatchList == null || remoteBatchList.Count == 0)
            {
                return "500,远程数据库批次表没有数据";
            }
            string sqlHead = "select * from wh_batch where 1=1 and batch_No=@batchNo";
            var headBatchList = Connection.Query<WhBatch>(sqlHead, new { batchNo = remoteBatchList[0].batch }).ToList();
            if (headBatchList == null || headBatchList.Count == 0)
            {
                foreach (var remoteBatch in remoteBatchList)
                {
                    WhBatch batch = new WhBatch();
                    batch.id = sequenceServer.getId();
                    var itemList = Connection.Query<CoreItem>("select * from [dbo].[core_item] where 1=1 and code=@code", new { code = remoteBatch.matno }).ToList();
                    if (itemList == null || itemList.Count == 0)
                    {
                        return "500,不存在该物料条码";
                    }
                    batch.batchNo = remoteBatch.batch;
                    batch.itemId = int.Parse(itemList[0].id.ToString());
                    batch.itemName = itemList[0].name;
                    batch.mname = itemList[0].name;
                    batch.matno = remoteBatch.matno;
                    batch.packageCascade = remoteBatch.packagecascade;
                    batch.productOn = remoteBatch.producton;
                    batch.updateCode = 1;
                    batch.spec = remoteBatch.spec;
                    batch.businessStatus = 1;//待抽检
                    Connection.InsertNoNull<WhBatch>(batch);
                }
            }
            return "200,操作成功";
        }

        public long AddBarch(InfBatch remoteBatch)
        {
            WhBatch batch = new WhBatch();
            batch.id = sequenceServer.getId();
            var itemList = Connection.Query<CoreItem>("select * from [dbo].[core_item] where 1=1 and code=@code", new { code = remoteBatch.matno }).ToList();
            if (itemList != null && itemList.Count > 0)
            {
                batch.itemId = int.Parse(itemList[0].id.ToString());
                batch.itemName = itemList[0].name;
                batch.mname = itemList[0].name;
            }
            batch.batchNo = remoteBatch.batch;
            batch.matno = remoteBatch.matno;
            batch.packageCascade = remoteBatch.packagecascade;
            batch.productOn = remoteBatch.producton;
            batch.updateCode = 1;
            batch.spec = remoteBatch.spec;
            batch.businessStatus = 1;//待抽检
            return Connection.InsertNoNull<WhBatch>(batch);
        }

        public Page<BatchReportDto> QueryBatchReportPage<BatchReportDto>(BatchDto dto)
        {
            string sql = @"SELECT A.id,A.Priority,A.item_Id,A.batch_No,B.package_Spec,B.pack_Unit,SUM(ISNULL(B.finsh_Count,0)) AS inCount,(SUM(ISNULL(B.finsh_Count,0))-A.count) AS outCount,A.count AS lastCount FROM dbo.wh_batch  A 
                           LEFT OUTER JOIN dbo.Wh_Receipt_in_detail B
                           ON A.batch_No = B.wms_Banch_No GROUP BY A.Priority,A.id,A.item_Id,A.batch_No,B.package_Spec,B.pack_Unit,a.count
                           HAVING 1=1 ";
            if (dto.itemId != 0)
            {
                sql += " AND A.item_Id = @itemId ";
            }
            if (!string.IsNullOrEmpty(dto.batchNo))
            {
                sql += " AND A.batch_No = @batchNo ";
            }
            //sql += "GROUP BY A.item_Id,A.batch_No,B.package_Spec,B.pack_Unit,a.count";
            return this.queryPage<BatchReportDto>(sql, "batch_No", dto);
        }

        public bool UpdatePriority(WhBatch model)
        {
            string sql = @"UPDATE dbo.wh_batch SET Priority =@priority
                            WHERE id=@id";
            int a = Connection.Execute(sql, new { id = model.id, priority = model.Priority });
            if (a >= 1)
            {
                return true;
            }
            return false;
        }

     
    }
}
