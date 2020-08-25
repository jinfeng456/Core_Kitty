using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Dapper;
using GK.BACK.DAL;
using GK.WCS.DAL;
using WCS.Common;
using WCS.DAL;
using WCS.Entity;

namespace GK.WCS.Controller {


    public class WCSBackTask: ZtTask
    {
       
        public WCSBackTask(){
            time = 15000;
        }
        ITaskCraneServer taskCraneServer= ServerFactray.getServer<ITaskCraneServer>();
        ITaskCarrierServer taskCarrierServer= ServerFactray.getServer<ITaskCarrierServer>();
        ITaskCompleteServer taskCompleteServer = ServerFactray.getServer<ITaskCompleteServer>();
        ITaskRelyServer taskRelyServer = ServerFactray.getServer<ITaskRelyServer>();
        IDbConnection connection = BackDBUtils.CreateBACKConnection(BackDalFactray.prefixal);

        public override void excute() {

            back();        
        }

        public void back()
        {
            List<TaskComplete> taskComplete = taskCompleteServer.getfinshTasksforUpload();
            foreach(TaskComplete taskComp in taskComplete)
            {
                long id=taskComp.id;
                TaskCrane taskCrane= taskCraneServer.getTaskCraneBycompleteId(id).FirstOrDefault();
                if (taskCrane == null)
                {
                    LoggerCommon.consol("数据备份时completeId为" + id+"的堆垛机任务不存在");
                }
                else
                {
                    string sql= "select * from  Task_crane where complete_Id = @id";
                    TaskCrane taskCrane1= connection.Query<TaskCrane>(sql, new { id = id }).FirstOrDefault();
                    if (taskCrane1 == null)
                    {
                        connection.InsertNoNull<TaskCrane>(taskCrane);
                        taskCraneServer.DeleteCraneTask(id);
                    }
                }
                TaskCarrier taskCarrier=taskCarrierServer.getCarrierTaskByComId(id).FirstOrDefault();
                if (taskCarrier == null)
                {
                    LoggerCommon.consol("数据备份时completeId为" + id + "的输送线任务不存在");
                }
                else
                {
                    string sql = "select * from  Task_carrier where complete_Id = @id";
                    if (connection.Query<TaskCarrier>(sql, new { id = id }).FirstOrDefault() == null)
                    {
                        connection.InsertNoNull<TaskCarrier>(taskCarrier);
                        taskCarrierServer.DeleteCarrierTask(id);
                    }
                }
                TaskRely taskRely=taskRelyServer.getByCompleteId(id).FirstOrDefault();
                if (taskRely == null)
                {
                    LoggerCommon.consol("数据备份时completeId为" + id + "的taskRely任务不存在");
                }
                else
                {
                    string sql = "select * from task_rely where complete_Id=@id";
                    if (connection.Query<TaskRely>(sql, new { id = id }).FirstOrDefault() == null)
                    {
                        connection.InsertNoNull<TaskRely>(taskRely);
                        taskRelyServer.deleteByCompleteId(id);
                    }
                }
                TaskComplete taskComplete1=taskCompleteServer.getById<TaskComplete>(id);
                if (taskComplete1 == null)
                {
                    LoggerCommon.consol("数据备份时completeId为" + id + "的completeId不存在");
                }
                else
                {
                    string sql = "select * from  Task_complete where id = @id";
                    if (connection.Query<TaskComplete>(sql, new { id = id }).FirstOrDefault() == null)
                    {
                        connection.InsertNoNull<TaskComplete>(taskComp);
                        taskCompleteServer.DeleteCompleteTask(id);
                    }
                }
            }



        }
       
    }
}
