using Dapper;
using GK.WMS.DAL.abs;
using GK.WMS.Entity;
using GK.WMS.Entity.wms;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using WMS.Entity;

namespace GK.WMS.DAL
{
    public class AbsTaskServer : AbsWMSBaseServer, ITaskServer {

        public List<CoreTask> getAllUnSyncTask() {
            List<CoreTask> coreTasks;
            string sql= "select * from Core_task where Status=2 and Task_Type in (2,3)";
            coreTasks= Connection.Query<CoreTask>(sql).AsList();
            return coreTasks;
        }

        public List<CoreTask> GetInTask(string code)
        {
            List<CoreTask> coreTasks;
            string sql = "select * from Core_task where Status=2 and Task_Type=1 and box_Code=@code";
            coreTasks = Connection.Query<CoreTask>(sql, new { code = code }).AsList();
            return coreTasks;
        }

        public List<CoreTaskParam> getTaskParam(long taskId) {
            List<CoreTaskParam> coreTasks;
            string sql= "select * from Core_task_param where wms_Task_Id=@taskId";
            coreTasks = Connection.Query<CoreTaskParam>(sql, new { taskId= taskId }).AsList();
            return coreTasks;

        }

        public void updateTaskParamStatus(long paramId, int status) {
             string sql= "update Core_task_param set status=@status where id=@paramId";
             Connection.Execute(sql, new { status= status , paramId = paramId });

        }

        public void updateTaskStatus(long id, int status) {
            string sql= "update Core_task set Status=@status where id=@id";
            Connection.Execute(sql, new { status = status, id = id });
        }


        #region 入库完成
        //任务明细删除
        public int DeleteTaskParam(List<CoreTaskParam> taskParamList)
        {
            foreach (var coreTaskParam in taskParamList)
            {
                Connection.Delete<CoreTaskParam>("id=" + coreTaskParam.id.ToString());
            }
            return 1;
        }
        //任务删除
        public int DeleteTask(List<CoreTask> taskList)
        {
            foreach (var coreTask in taskList)
            {
                Connection.Delete<CoreTask>("id=" + coreTask.id.ToString());
            }
            return 1;
        }

        //根据入库任务的id来获取入库任务信息(taskStatus=3)
        public List<CoreTask> GetCoreTask(long taskId)
        {
            String sql = @"select * from Core_task where id=@taskId ";
            List<CoreTask> list = Connection.Query<CoreTask>(sql, new { taskId = taskId }).ToList();
            return list;
        }
        //根据入库任务ID得到入库明细任务
        public List<CoreTaskParam> GetCoreTaskParam(long taskId)
        {
            String sql = @"select * from Core_task_param where wms_task_id=@taskId ";
            List<CoreTaskParam> list = Connection.Query<CoreTaskParam>(sql, new { taskId = taskId }).ToList();
            return list;
        }
        //根据库存明细id获取其他信息
        public List<CoreStockDetail> GetCoreStockDetail(long id)
        {
            String sql = @"select * from core_stock_detail where id=@id ";
            List<CoreStockDetail> list = Connection.Query<CoreStockDetail>(sql, new { id = id }).ToList();
            return list;
        }
        //修改任务状态和完成时间
        public bool UpdataTask(long id)
        {  
                string sql = @"update Core_task set Status=4,finsh_Time=GETDATE() where id=@id";
                Connection.Execute(sql, new { id = id });          
            return true;
        }
        //修改任务明细状态和完成时间
        public bool UpdataTaskParam(long id)
        {
            string sql = @"update Core_task_param set Status=4,finsh_Time=GETDATE() where id=@id";
            Connection.Execute(sql, new { id = id });
            return true;
        }
        //修改库存状态和时间
        public bool UpdataStock(long id)
        {
            string sql = @"update Core_stock set Status=2,change_Time=GETDATE() where id=@id";
            Connection.Execute(sql, new { id = id });
            return true;
        }
        //修改库存明细状态和时间
        public bool UpdataStockDetail(long id)
        {
            string sql = @"update core_stock_detail set stock_Status=2,in_Time=GETDATE() where id=@id";
            Connection.Execute(sql, new { id = id });
            return true;
        }
        //通过入库单明细ID获取入库单ID
        public List<WhReceiptInDetail> GetWhReceiptInDetail(long id)
        {
            String sql = @"select * from Wh_Receipt_in_detail where id=@id ";
            List<WhReceiptInDetail> list = Connection.Query<WhReceiptInDetail>(sql, new { id = id }).ToList();
            return list;
        }
        //通过入库单Id修改入库单状态和完成时间
        public bool UpdataWhReceiptIn(long id)
        {
            string sql = @"update Wh_Receipt_in set Status=3,finsh_Time=GETDATE() where id=@id";
            Connection.Execute(sql, new { id = id });
            return true;
        }
        //根据入库订单明细查入库订单
        public List<WhSoInDetail> GetWhSoDetail(long id)
        {
            String sql = @"select * from Wh_So_in_detail where id=@id ";
            List<WhSoInDetail> list = Connection.Query<WhSoInDetail>(sql, new { id = id }).ToList();
            return list;
        }
        //修改入库订单状态和完成时间
        public bool UpdataWhSoIn(long id)
        {
            string sql = @"update Wh_So_In set Status=2,finsh_Date=GETDATE() where id=@id";
            Connection.Execute(sql, new { id = id });
            return true;
        }
        //修改批次数量
        public bool UpdataBatchCount(long id,int count)
        {
            string sql = @"update wh_batch set count=@count where id=@id";
            Connection.Execute(sql, new { count= count,id = id });
            return true;
        }
        #endregion


        #region 出库完成
        //修改库存状态和时间
        public bool UpdataStockOut(long id)
        {
            string sql = @"update Core_stock set Status=0,change_Time=GETDATE() where id=@id";
            Connection.Execute(sql, new { id = id });
            return true;
        }
        //修改库存明细状态和时间
        public bool UpdataStockDetailOut(long id)
        {
            string sql = @"update core_stock_detail set stock_Status=0,in_Time=GETDATE() where id=@id";
            Connection.Execute(sql, new { id = id });
            return true;
        }

        //通过出库单明细ID获取出库单ID
        public List<WhReceiptOutDetail> GetWhReceiptOutDetail(long id)
        {
            String sql = @"select * from Wh_Receipt_Out_detail where id=@id ";
            List<WhReceiptOutDetail> list = Connection.Query<WhReceiptOutDetail>(sql, new { id = id }).ToList();
            return list;
        }
        //通过入库单Id修改入库单状态和完成时间
        public bool UpdataWhReceiptOut(long id)
        {
            string sql = @"update Wh_Receipt_out set Status=3,finsh_Time=GETDATE() where id=@id";
            Connection.Execute(sql, new { id = id });
            return true;
        }
        //根据入库订单明细查入库订单
        public List<WhSoOutDetail> GetWhSoOutDetail(long id)
        {
            String sql = @"select * from Wh_So_out_detail where id=@id ";
            List<WhSoOutDetail> list = Connection.Query<WhSoOutDetail>(sql, new { id = id }).ToList();
            return list;
        }
        //修改入库订单状态和完成时间
        public bool UpdataWhSoOut(long id)
        {
            string sql = @"update Wh_So_Out set Status=2,finsh_Date=GETDATE() where id=@id";
            Connection.Execute(sql, new { id = id });
            return true;
        }
        #endregion
    }
}
