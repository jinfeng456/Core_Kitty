using Dapper;
using GK.WMS.DAL;
using GK.WMS.Entity;
using GK.WMS.Entity.wms;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Management.Instrumentation;
using System.Text;

namespace GK.Engine.WMS.wms
{
    public class CommentFunction
    {
        static ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();
        /// <summary>
        /// 任务主表添加
        /// </summary>
        /// <param name="Connection"></param>
        /// <param name="transaction"></param>
        /// <param name="transaction"></param>
        /// <param name="transaction"></param>
        /// <returns></returns>
        public static long InsertTask(IDbConnection Connection, IDbTransaction transaction,long stockId,int areaId,String boxCode  , int bussType, int taskType,int start, int end,long relay=0)
        {
            CoreTask task = new CoreTask();
            task.id = sequenceIdServer.getId();
            task.stockId = stockId;
            task.areaId = areaId;
            task.boxCode = boxCode;
            task.status = 2;//1新建状态 2待下发wcs 3下发完成 4执行完成
            task.createTime = sequenceIdServer.GetTime();
            task.maxstock = 1;
            task.bussType = bussType; //出库类型 出库,入库相关类型
            task.taskType = taskType; //任务类型 1入库任务 2出库任务 3移库任务 4渡库任务
            task.upload = 0;
            task.src = start;  //起始位置
            task.des = end;    //目标位置
            task.relyTaskId = relay;
            Connection.InsertNoNull<CoreTask>(task, transaction);
            return task.id;
        }

        /// <summary>
        /// 任务子表添加
        /// </summary>
        /// <param name="Connection">连接对象</param>
        /// <param name="transaction">事务对象</param>
        /// <param name="stockDetailId">货位库存明细主键</param>
        /// <returns></returns>
        public static long InsertTaskDetail(IDbConnection Connection, IDbTransaction transaction, long stockDetailId, long taskId)
        {
            //任务明细添加
            CoreTaskParam param = new CoreTaskParam();
            param.id = sequenceIdServer.getId();
            param.detailId = stockDetailId;
            param.wmsTaskId = taskId; //task.id
            param.status = 2;//新建状态
            param.createTime = sequenceIdServer.GetTime();
            return Connection.InsertNoNull<CoreTaskParam>(param, transaction);
        }

        /// <summary>
        /// 盘点明细表添加
        /// </summary>
        /// <param name="Connection">连接对象</param>
        /// <param name="transaction">事务对象</param>
        /// <param name="stockDetailId">货位库存明细主键</param>
        /// <param name="receptId">盘点单主表主键</param>
        /// <returns></returns>
        public static long InsertPkDetail(IDbConnection Connection, IDbTransaction transaction, CoreStockParam param, long receptId)
        {
            //任务明细添加
            WhReceiptPkDetail receiptPkdetail = new WhReceiptPkDetail();
            receiptPkdetail.id = sequenceIdServer.getId();
            receiptPkdetail.receptId = receptId;
            receiptPkdetail.stockDetailId = param.stockDetailId;
            receiptPkdetail.barCode = param.barCode;
            return Connection.InsertNoNull<WhReceiptPkDetail>(receiptPkdetail, transaction);
        }
        /// <summary>
        /// 库位库存修改库存状态,盘库状态
        /// </summary>
        /// <param name="Connection"></param>
        /// <param name="transaction"></param>
        /// <param name="stockId">库存主键</param>
        /// <param name="status">0库外 1入库中 2库存 3出库中</param>
        /// <param name="pkStatus">0 未盘库 1 盘库中</param>
        /// <returns></returns>
        public static bool UpdateStock(IDbConnection Connection, IDbTransaction transaction, long stockId, int status, int pkStatus)
        {
            CoreStock model = new CoreStock();
            model.id = stockId;
            model.status = status;
            model.pkStatus = pkStatus;
            return Connection.updateNotNull<CoreStock>(model, transaction);
        }
        /// <summary>
        /// 库位库存修改库存状态
        /// </summary>
        /// <param name="Connection"></param>
        /// <param name="transaction"></param>
        /// <param name="stockId">库存主键</param>
        /// <param name="status">0库外 1入库中 2库存 3出库中</param>
        /// <returns></returns>
        public static bool UpdateStock(IDbConnection Connection, IDbTransaction transaction, long stockId, int status)
        {
            CoreStock model = new CoreStock();
            model.id = stockId;
            model.status = status;
            return Connection.updateNotNull<CoreStock>(model, transaction);
        }
        /// <summary>
        /// 库位明细库存中修改库存状态,盘库状态(盘库使用)
        /// </summary>
        /// <param name="Connection"></param>
        /// <param name="transaction"></param>
        /// <param name="stockDetailId">库存明细主键</param>
        /// <param name="pkStatus">0 未盘库 1 盘库中</param>
        /// <param name="stockStatus">0库外 1入库中 2库存 3出库中</param>
        /// <returns></returns>
        public static bool UpdateStockDetailStatus(IDbConnection Connection, IDbTransaction transaction, long stockDetailId, int pkStatus, int stockStatus, long whReceiptPkId)
        {
            CoreStockDetail model = new CoreStockDetail();
            model.id = stockDetailId;
            model.pkStatus = pkStatus;
            //model.stockStatus = stockStatus;   //盘库的时候不需要改为出库中,PDA 修改数量 2020/7/14
            model.receiptpkid = whReceiptPkId;
            return Connection.updateNotNull<CoreStockDetail>(model, transaction);
        }


        /// <summary>
        /// 库位明细库存中修改库存状态,盘库状态
        /// </summary>
        /// <param name="Connection"></param>
        /// <param name="transaction"></param>
        /// <param name="param"></param>
        /// <param name="pkStatus">0 未盘库 1 盘库中</param>
        /// <param name="stockStatus">0库外 1入库中 2库存 3出库中</param>
        /// <returns></returns>
        public static long InsertStockDetail(IDbConnection Connection, IDbTransaction transaction, CoreStockParam param, int pkStatus, int stockStatus, int count, string batchNo)
        {
            CoreStockDetail model = new CoreStockDetail();
            model.id = sequenceIdServer.getId();
            model.pkStatus = pkStatus;
            model.stockStatus = stockStatus;
            model.barCode = param.barCode;
            model.batchId = param.batchId;
            model.countDb = count;
            model.bussStatus = param.bussStatus;
            model.itemId = param.itemId;
            model.loctionId = param.loctionId;
            model.pkStatus = param.pkStatus;
            model.receiptlnId = param.receiptlnId;
            model.receiptlOutId = param.receiptlOutId;
            model.stockId = param.stockId;
            model.stockStatus = param.stockStatus;
            model.wmsBanchNo = batchNo;
            model.inTime = param.inTime;
            //model.businessCreateTime = param.businessCreateTime;
            return Connection.InsertNoNull<CoreStockDetail>(model, transaction);
        }

        /// <summary>
        /// 库位明细库存中修改库存状态,回写出库子表的主键
        /// </summary>
        /// <param name="Connection"></param>
        /// <param name="transaction"></param>
        /// <param name="stockDetailId">库存明细主键</param>
        /// <param name="stockStatus">0库外 1入库中 2库存 3出库中</param>
        /// <returns></returns>
        public static bool UpdateStockDetail(IDbConnection Connection, IDbTransaction transaction, long stockDetailId, int stockStatus, long receiptOutDetailId)
        {
            CoreStockDetail model = new CoreStockDetail();
            model.id = stockDetailId;
            model.stockStatus = stockStatus;
            model.receiptlOutId = receiptOutDetailId;
            return Connection.updateNotNull<CoreStockDetail>(model, transaction);
        }

        /// <summary>
        /// 库位明细库存中修改库存状态
        /// </summary>
        /// <param name="Connection"></param>
        /// <param name="transaction"></param>
        /// <param name="stockDetailId">库存明细主键</param>
        /// <param name="stockStatus">0库外 1入库中 2库存 3出库中</param>
        /// <returns></returns>
        public static bool UpdateStockCount(IDbConnection Connection, IDbTransaction transaction, long stockDetailId, int count)
        {
            CoreStockDetail model = new CoreStockDetail();
            model.id = stockDetailId;
            model.countDb = count;
            return Connection.updateNotNull<CoreStockDetail>(model, transaction);
        }

         public static bool UpdataWhLoc(IDbConnection Connection, IDbTransaction transaction, long id)
        {

            String sql = @"select count(*) from core_task where des=@des and status in (1,2,3) ";
            int count1 =Connection.Query<int>(sql, new { des = id }, transaction).FirstOrDefault();

            sql = @"select count(*) from core_stock where loc_Id=@locId ";
            int count2 = Connection.Query<int>(sql, new { locId = id }, transaction).FirstOrDefault();

            string sql2 = @"update core_wh_loc set stock_Count=@count where id=@id";
            Connection.Execute(sql2, new { id = id, count = count1+count2 }, transaction);
            return true;
        }
         public static bool closureTask(IDbConnection Connection,IDbTransaction transaction,long id,int status) {
            string sql = @"update Core_task set Status=@status,finsh_Time=GETDATE() where id=@id";
            Connection.Execute(sql,new {
                id = id,status = status
            },transaction);
            return true;
        }

         public static CoreTask getCoreTask(IDbConnection Connection,IDbTransaction transaction,long taskId) {
            String sql = @"select * from Core_task where id=@taskId ";
            List<CoreTask> list = Connection.Query<CoreTask>(sql,new {
                taskId = taskId
            },transaction).ToList();

            if (list.Count < 1) {
                throw new Exception(taskId + " 任务不存在!");

            }
            return list[0];
        }

         public  static CoreStock getCoreStock(IDbConnection Connection,IDbTransaction transaction,long id) {
            String sql = @"select * from core_stock where id=@id ";
            List<CoreStock> list = Connection.Query<CoreStock>(sql,new {
                id = id
            },transaction).ToList();
            if (list.Count == 1) {
                return list[0];
            } else if (list.Count > 1) {
                throw new Exception(id + "货位记录过多");
            } else {
                return null;
            }

        }

        
         public  static void taskFinshUpdateStock(IDbConnection Connection,IDbTransaction transaction,CoreTask ct,int stockStauts) {
            if (ct.taskType == 1) {
                string sql = @"update Core_stock set Status=@status,change_Time=GETDATE() where id=@id and Status=1";
                exec(Connection,transaction,sql,new {
                    id = ct.stockId,status = stockStauts
                });
                sql = @"update core_stock_detail set stock_Status=@status,in_Time=GETDATE() where stock_Status=1 and stock_id=@id";
                exec(Connection,transaction,sql,new {
                    id = ct.stockId,status = stockStauts
                });
            } else if (ct.taskType == 2) {

                if (stockStauts == -1) {
                      String sqlQuery = @"select * from core_stock_detail where  stock_Id=@stockId and stock_Status=2";
                            List<CoreStockDetail> list = Connection.Query<CoreStockDetail>(sqlQuery,new {
                               stockId = ct.stockId
                            },transaction).ToList();
                    if (list.Count > 0) {
                        stockStauts=0;
                    }
                 }

                string sql = @"update Core_stock set Status=@status,change_Time=GETDATE() where id=@id and Status=3";
                exec(Connection,transaction,sql,new {
                    id = ct.stockId,status = stockStauts
                });

                sql = @"update core_stock_detail set stock_Status=@status,out_Time=GETDATE() where stock_Status=3 and stock_Id=@stockId  ";
                exec(Connection,transaction,sql,new {
                    stockId = ct.stockId,status = stockStauts
                });
            }
        }
         public  static void exec(IDbConnection Conn,IDbTransaction tr,String sql,object p) {
            Conn.Execute(sql,p,tr);
        }
        
    }
}
