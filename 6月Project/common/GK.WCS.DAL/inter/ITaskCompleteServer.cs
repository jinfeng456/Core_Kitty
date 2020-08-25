
using System.Collections.Generic;
using System.Linq;
using System.Data.SqlClient;
using System;
using System.Data;
using Common.DAL.inter;
using WCS.Entity;

namespace GK.WCS.DAL
{
    public interface ITaskCompleteServer : IBaseServer {
       

        // 1分解未完成 2不可插入 3执行完成  -1 删除
        List<TaskComplete> getTasks(int status);

        List<TaskComplete> getInTasks(int status, string code);

        // 获取 3执行完成 -1 删除状态的任务 upload为0
        List<TaskComplete> getfinshTasksforUpload();

        List<TaskComplete> getfinshTasks();

        List<TaskComplete> getResolveTasks();
        //upload 设置为1
        bool finshSyncById(long id);


        List<TaskComplete> getAll();


        TaskComplete getTaskCompleteByWmsTaskId(long wmsTaskId);
        TaskComplete getTaskCompleteById(long id);
        TaskCompleteParam getTaskCompleteParamByDetailId(long id);//根据id查询

        T getOnlyOne<T>(String sql, Object value) where T : new();


         bool UpdatePriorityById(long id, int Priority);

        bool UpdateStatusById(long id, int status);

        bool UpdateTaskPriorityByCompleteId(long completeId);
        void DeleteCompleteTask(long Id);

        List<TaskComplete> GetTaskCompleteByCode(string code, IDbTransaction transaction = null);

        long GetWmsIdById(long id);
    }
}
