using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Dapper;
using GK.Common.trans;
using GK.WCS.DAL;
using GK.WCS.Entity;
using GK.WCS.Entity.wcs;

namespace GK.Engine.WCS
{
     class WcsCreateMoveEngine : WcsBaseEngine
    {
        public  long completeId;
        public long wmstaskId;
        public  int srcId;
        public int desId;
        public string boxCode;
        public int itemType;
        public long relyTaskId;
        public long tCompPId;
        protected override bool Execute(IDbConnection connection, IDbTransaction transaction) 
        {
            string sql= "select * from dbo.Task_complete where wms_Task_Id=@wmstaskId";
            TaskComplete taskComplete = connection.Query<TaskComplete>(sql, new { wmstaskId= wmstaskId },transaction).FirstOrDefault(); 
            int TaskNo = CommentFunction.BBTaskNo(connection,transaction);
            ISequenceIdServer sequenceIdServer = ServerFactray.getServer<ISequenceIdServer>();
            long id = sequenceIdServer.getId();
            CommentFunction.BCrane(connection,transaction, itemType, TaskNo,srcId,desId,boxCode,completeId,tCompPId,id);
            string sql3= "update dbo.Task_complete set status=2 where Id=@completeId";
            connection.Execute(sql3, new { completeId= completeId },transaction);
            return true;
        }
      

       
     
      



       


    }
    
}
