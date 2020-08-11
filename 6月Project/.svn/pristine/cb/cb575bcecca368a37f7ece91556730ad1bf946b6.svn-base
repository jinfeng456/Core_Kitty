using GK.Common.dto;
using GK.WCS.Entity;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Dapper;
using static Dapper.SqlMapper;
using GK.WCS.Common;

namespace GK.WCS.DAL.abs
{

    public abstract class AbsTaskCarrierServer : AbsWCSBaseServer, ITaskCarrierServer

    {
        public bool finshTaskCarrier(long id, IDbTransaction transaction = null)
        {
            string sql="update Task_carrier set status=7 where Task_No=@Task_No";
            int i=Connection.Execute(sql,new{Task_No=id },transaction);
            if (i < 1)
            {
                return false;
            }
            else
            {
                return true;
            }


        }

        public TaskCarrier getByCode(string code, IDbTransaction transaction = null)
        {
            TaskCarrier taskCarrier=null;
            string sql = "select *  from Task_carrier where code=@code";
          
           taskCarrier = Connection.Query<TaskCarrier>(sql, new { code = code }, transaction).FirstOrDefault();
         
           return taskCarrier;
         
        }


        public List<TaskCarrier> getCarrarTasksByStn(int from, int end, IDbTransaction transaction = null)
        {
            throw new NotImplementedException();
        }

        public TaskCarrier getCarrarTasksByTaskNo(int  taskNo, IDbTransaction transaction = null)
        {
            TaskCarrier taskCarrier = null;
            string sql = "select *  from Task_carrier where Task_No=@Task_No";
            try
            {
                taskCarrier = Connection.Query<TaskCarrier>(sql, new { Task_No = taskNo }, transaction).FirstOrDefault();

            }
            catch (Exception e)
            {
                LoggerCommon.fileAll("任务号为 " + taskNo + " 的任务不存在！");
            }

            return taskCarrier;
        }

        public List<TaskCarrier> getCarrierTaskByComId(long completeId, IDbTransaction transaction = null)
        {
            List<TaskCarrier> taskCarrier = null;
            string sql = "select *  from Task_carrier where complete_Id=@complete_Id";

            taskCarrier = Connection.Query<TaskCarrier>(sql, new { complete_Id = completeId }, transaction).AsList();



            return taskCarrier;
        }

        public List<TaskCarrier> getOutCarrirerCodes(int start, IDbTransaction transaction = null)
        {
            throw new NotImplementedException();
        }
        public TaskCarrier getInCarrirerTask(int boxcode,int status)
        {
            string code=boxcode.ToString();
            string sql= "select * from Task_Carrier where code=@code and status=@status";
            return Connection.Query<TaskCarrier>(sql,new{ code= code, status= status }).FirstOrDefault();
        }

        public bool UpdateTaskCarrierStatus(int taskNo,int status,  IDbTransaction transaction = null)
        {
            string sql = "update Task_carrier set status=@status where Task_No=@Task_No";
            int i = Connection.Execute(sql, new { status= status,Task_No = taskNo }, transaction);
            if (i < 1)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        public bool DeleteCarrierTask(long completeId, IDbTransaction transaction = null)
        {
            string sql = "delete dbo.Task_carrier where complete_Id=@completeId";
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

        public bool ResetCarrierTaskById(long taskId, IDbTransaction transaction = null)
        {
            string sql = "update Task_carrier set status=1 where ID=@taskId";
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

        public bool FinishCarrierTaskById(long taskId, IDbTransaction transaction = null)
        {
            string sql = "update Task_carrier set status=9 where ID=@taskId";
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

        public TaskCarrier getCarrierTask(int startPoint)
        {
            string sql = "select * from Task_carrier where Start_Path=@startPoint and Task_No = (select Task_No from Task_crane where status=9)";
            return Connection.Query<TaskCarrier>(sql, new { startPoint = startPoint }).FirstOrDefault();
        }
        public TaskCarrier getCarrierTaskByCompleteId(long id)
        {
            string sql= "select * from Task_carrier where complete_Id=@id";
            return Connection.Query<TaskCarrier>(sql,new{ id = id }).FirstOrDefault();
        }

        public List<TaskCarrier> getAllOutCarrirerTask()
        {
            string sql= "select * from Task_carrier where item_Type=2 and status not in(-1,9) ";
            return Connection.Query<TaskCarrier>(sql).AsList();
        }

        public List<TaskCarrier> getAllInCarrirerTask()
        {
            string sql = "select * from Task_carrier where item_Type=1 and status not in(-1,9) ";
            return Connection.Query<TaskCarrier>(sql).AsList();
        }

        public List<TaskCarrier> GetCarrierTaskByCode(string code, IDbTransaction transaction = null)
        {
            List<TaskCarrier> taskCarrier = null;
            string sql = "select *  from Task_carrier where code=@code";
            taskCarrier = Connection.Query<TaskCarrier>(sql, new { code = code }, transaction).AsList();
            if (taskCarrier==null)
            {
                return new List<TaskCarrier>();
            }
            return taskCarrier;
        }

        public List<TaskCarrier> getWorkingCarrierTask()
        {
            List<TaskCarrier> taskCarrier = null;
            string sql = "select *  from Task_carrier where status=2";
            taskCarrier = Connection.Query<TaskCarrier>(sql).AsList();
            if (taskCarrier == null)
            {
                return new List<TaskCarrier>();
            }
            return taskCarrier;
        }
    }
}
