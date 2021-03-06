﻿using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using WCS.DAL.abs;
using WCS.Entity;

namespace GK.WCS.DAL.abs
{

    public class AbsTaskCompleteServer : AbsWCSBaseServer, ITaskCompleteServer
    {
        public void DeleteCompleteTask(long Id)
        {
            string sql= "delete Task_complete where id=@Id";
            Connection.Execute(sql, new { Id= Id });
        }

        public bool finshSyncById(long id)
        {
            string sql= "update Task_complete set upload=1 where id=@id";
            int i=Connection.Execute(sql, new { id=id});
            if (i !=1)
            {
                return false;
            }
            else
            {
                return true;
            }

        }

        public List<TaskComplete> getAll()
        {
            return Connection.Query<TaskComplete>("select * from Task_Complete").ToList();
        }

        public List<TaskComplete> getfinshTasksforUpload()
        {
            List < TaskComplete > taskCompletes;
            string sql= "select * from Task_complete where upload=1";
            taskCompletes=Connection.Query<TaskComplete>(sql).AsList();
            return taskCompletes;

        }

        public List<TaskComplete> getfinshTasks()
        {
            List<TaskComplete> taskCompletes;
            string sql = "select * from Task_complete where status = 3 and upload = 0";
            taskCompletes = Connection.Query<TaskComplete>(sql).AsList();
            return taskCompletes;

        }
        public List<TaskComplete> getResolveTasks()
        {
            List<TaskComplete> taskCompletes;
            string sql = "select * from Task_complete where status = 2 and upload = 0";
            taskCompletes = Connection.Query<TaskComplete>(sql).AsList();
            return taskCompletes;

        }

        public T getOnlyOne<T>(string sql, object value) where T : new()
        {
            throw new NotImplementedException();
        }

        public List<TaskComplete> GetTaskCompleteByCode(string code, IDbTransaction transaction = null)
        {
            List<TaskComplete> taskComplete = null;
            string sql = "select *  from Task_complete where box_Code=@code";
            taskComplete = Connection.Query<TaskComplete>(sql, new { code = code }, transaction).AsList();
            if (taskComplete == null)
            {
                return new List<TaskComplete>();
            }
            return taskComplete;
        }

        public TaskComplete getTaskCompleteByWmsTaskId(long wmsTaskId)
        {
            TaskComplete taskComplete=null;
            string sql= "select * from Task_complete where wms_Task_Id=@wmsTaskId";
          
            taskComplete = Connection.Query<TaskComplete>(sql, new { wmsTaskId = wmsTaskId }).FirstOrDefault();
           
            return taskComplete;


        }

        public TaskComplete getTaskCompleteById(long id)
        {
            TaskComplete taskComplete = null;
            string sql = "select * from Task_complete where id=@id";

            taskComplete = Connection.Query<TaskComplete>(sql, new { id = id }).FirstOrDefault();

            return taskComplete;


        }

        public TaskCompleteParam getTaskCompleteParamByDetailId(long id)
        {
            string sql= "select * from Task_complete_param where detail_Id=@id";
            return Connection.Query<TaskCompleteParam>(sql, new { id=id}).FirstOrDefault();
        }

        public List<TaskComplete> getTasks(int status)
        {
            List<TaskComplete> taskCompletes;
            string sql = "select * from Task_complete where status=@status and task_Type in (2,3)";
            taskCompletes = Connection.Query<TaskComplete>(sql,new{ status= status}).AsList();
            return taskCompletes;

        }
        public List<TaskComplete> getInTasks(int status, string code)
        {
            List<TaskComplete> taskCompletes;
            string sql = "select * from Task_complete where status=@status and box_Code=@code";
            taskCompletes = Connection.Query<TaskComplete>(sql, new { status = status, code = code }).AsList();
            return taskCompletes;

        }

        public bool UpdatePriorityById(long id, int Priority)
        {
            string sql = "update Task_complete set Priority=@Priority where id=@id";
            int i = Connection.Execute(sql, new { Priority= Priority,id = id });
            if (i != 1)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        public bool UpdateStatusById(long id, int status)
        {
            string sql = "update Task_complete set status=@status where id=@id";
            int i = Connection.Execute(sql, new { status = status, id = id });
            if (i != 1)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        public bool UpdateTaskPriorityByCompleteId(long completeId)
        {
            string sql = "update Task_complete set Priority=4 where id=@complete_Id";
            int i = Connection.Execute(sql, new { complete_Id = completeId });
            if (i < 1)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        public long GetWmsIdById(long id)
        {
            long wmsid = 0;
            string sql = "select * from Task_complete where id=@id";
            wmsid = Connection.Query<TaskComplete>(sql, new { id = id }).FirstOrDefault().wmsTaskId;
            return wmsid;
        }
    }
}
