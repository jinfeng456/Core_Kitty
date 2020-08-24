using Dapper;
using GK.Common.dto;
using GK.WCS.Entity;
using GK.WCS.Entity.wcs;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace GK.WCS.DAL.abs
{
    public class AbsTaskCraneServer : AbsTaskCraneServerBase, ITaskCraneServer
    {
       
        public bool finshTaskStatus(long id)
        {
            string sql= "update Task_crane set status=3 where ID=@id";
            int i = Connection.Execute(sql, new { id = id });
            if (i != 1)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

      

        public List<TaskCrane> getTaskCraneBycompleteId(long completeId)
        {
            List<TaskCrane> taskCrane;
            string sql = "select * from Task_crane where complete_Id=@completeId";
            taskCrane = Connection.Query<TaskCrane>(sql, new { completeId = completeId }).AsList();
            return taskCrane;
        }

        public List<TaskCrane> getTaskCraneByCraneId(long id)
        {
            List<TaskCrane> taskCrane;
            string sql = "select * from Task_crane where crane_Id=@id";
            taskCrane = Connection.Query<TaskCrane>(sql, new { id = id }).AsList();
            return taskCrane;
        }

      

        public List<TaskCrane> getWorkingTask(int craneId,int dir1,int dir3)
        {
            if (dir1 == 1 && dir3 == 1)
            {
                string sql= "select * from Task_crane where Task_type=1 and crane_Id=@craneId";
                List<TaskCrane> taskCranes = Connection.Query<TaskCrane>(sql, new { craneId=craneId}).AsList();
                return taskCranes;
            }
            else if (dir1 == 1 && dir3 == 2)
            {   
                string sql= "select * from Task_crane where to_Id not in(1011,1012)  and crane_Id=@craneId";
                List<TaskCrane> taskCranes = Connection.Query<TaskCrane>(sql, new { craneId = craneId }).AsList();
                return taskCranes;
            }
            else if (dir1 == 2 && dir3 == 2)
            {
                string sql = "select * from Task_crane where  crane_Id=@craneId";
                List<TaskCrane> taskCranes = Connection.Query<TaskCrane>(sql, new { craneId = craneId }).AsList();
                return taskCranes;
            }
            else if (dir1 == 2 && dir3 == 1)
            {
                string sql = "select * from Task_crane where to_Id not in(1023,1024)  and crane_Id=@craneId";
                List<TaskCrane> taskCranes = Connection.Query<TaskCrane>(sql, new { craneId = craneId }).AsList();
                return taskCranes;
            }
            return null;
        }
        
        public bool IsTaskFinished(int taskNo, int Status)
        {
            TaskCrane taskCrane;
            string sql = "select * from Task_crane where Task_No=@TaskNo ";
            taskCrane = Connection.Query<TaskCrane>(sql, new { TaskNo = taskNo }).FirstOrDefault();
            if (taskCrane.status == Status)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public bool IsTaskFinished(int taskNo, short Status)
        {
            throw new NotImplementedException();
        }

       

        public bool resetTaskStatus(long id)
        {
            throw new NotImplementedException();
        }

        public bool UpdateTaskPriorityByCompleteId(long id, int Priority)
        {
            throw new NotImplementedException();
        }

        public bool UpdateTaskPriorityById(long id, int Priority)
        {
            throw new NotImplementedException();
        }

       
        public bool DeleteCraneTask(long completeId)
        {
            string sql = "delete dbo.Task_crane where complete_Id=@completeId";
            int i = Connection.Execute(sql, new { completeId = completeId });
            if (i < 1)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        public bool ResetCraneTaskById(long taskId)
        {
            string sql = "update Task_crane set status=1 where ID=@taskId";
            int i = Connection.Execute(sql, new { taskId = taskId });
            if (i < 1)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        public bool FinishCraneTaskById(long taskId)
        {
            string sql = "update Task_crane set status=9 where ID=@taskId";
            int i = Connection.Execute(sql, new { taskId = taskId });
            if (i < 1)
            {
                return false;
            }
            else
            {
                return true;
            }
        }
       
        public bool DeleteCraneAndCarrierTask(long completeId)
        {
            
            return true;
        }
        public bool UpdateCraneAndCarrierTask(long completeId, IDbConnection Connection, IDbTransaction transaction)
        {
            string sql = "update dbo.Task_crane set status=-1 where complete_Id=@completeId";
            int i = Connection.Execute(sql, new { completeId = completeId },transaction);
            string sql1 = "update dbo.Task_carrier set status=-1 where complete_Id=@completeId";
            int j = Connection.Execute(sql1, new { completeId = completeId }, transaction);
            if (i>=1 && j>=1)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public List<TaskCrane> getAllOutCraneTask()
        {
           
            string sql = "select * from Task_crane where Task_type=2 and  status not in (-1,9) ";
            return Connection.Query<TaskCrane>(sql).AsList();
        }

        public List<TaskCrane> getAllInCraneTask()
        {
            string sql = "select * from Task_crane where Task_type=1 and  status not in (-1,9)";
            return Connection.Query<TaskCrane>(sql).AsList();
        }

        public TaskCrane getTaskCraneByTaskNo(int taskNo)
        {  
            string sql = "select * from Task_crane where Task_No=@taskNo";
            TaskCrane taskCrane = Connection.Query<TaskCrane>(sql, new { taskNo = taskNo }).FirstOrDefault();
            return taskCrane;
        }

        public TaskCrane getTaskCraneByCompleteId(long id)
        {
            string sql = "select * from Task_crane where complete_Id=@id";
            TaskCrane taskCrane = Connection.Query<TaskCrane>(sql, new { id = id }).FirstOrDefault();
            return taskCrane;
        }
        public List<TaskCrane> getTaskCraneByStatus()
        {
            List<TaskCrane> taskCrane = null;
            string sql = "select * from Task_crane where status in (9,-1)";
            taskCrane = Connection.Query<TaskCrane>(sql).AsList();
            return taskCrane;
        }
        public List<TaskCrane> GetCraneTaskByCode(string code, IDbTransaction transaction = null)
        {
            List<TaskCrane> taskCrane = null;
            string sql = "select *  from Task_carrier where code=@code";
            taskCrane = Connection.Query<TaskCrane>(sql, new { code = code }, transaction).AsList();
            if (taskCrane==null)
            {
                return new List<TaskCrane>();
            }
            return taskCrane;
        }

        public List<TaskCrane> getWorkingCraneTask()
        {
            string sql = "select * from Task_crane where status>=1 and  status<9  and task_type in (1,2) ";
            List<TaskCrane> taskCranes = Connection.Query<TaskCrane>(sql).AsList();
            return taskCranes;
        }

        public List<TaskCrane> AllocateOutCraneTask(int point)
        {
            string sql = "select * from Task_crane where status = 1 and Task_type=2 and to_Id=@point order By Priority desc";
            List<TaskCrane> taskCranes = Connection.Query<TaskCrane>(sql, new { point = point }).AsList();
            return taskCranes;
        }

        public List<TaskCrane> AllocateInCraneTask(int TaskNo)
        {
            string sql = "select * from Task_crane where status = 1 and Task_type=1 and Task_No=@Task_No";
            List<TaskCrane> taskCranes = Connection.Query<TaskCrane>(sql, new { TaskNo = TaskNo }).AsList();
            return taskCranes;
        }
    }
}
