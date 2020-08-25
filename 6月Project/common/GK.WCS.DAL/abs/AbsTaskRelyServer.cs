using Dapper;
using GK.WCS.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using WCS.DAL.abs;
using WCS.Entity;

namespace GK.WCS.DAL.abs
{
    public class AbsTaskRelyServer : AbsWCSBaseServer, ITaskRelyServer
    {
        public void deleteByCompleteId(long completeId)
        {
            string sql = "delete task_rely where complete_Id=@completeId";
            Connection.Execute(sql, new { completeId= completeId });
        }

        public List<TaskRely> getByCompleteId(long completeId)
        {
            string sql = "select * from task_rely where complete_Id=@completeId";
           return  Connection.Query<TaskRely>(sql, new { completeId = completeId }).AsList();

        }
    }
}
