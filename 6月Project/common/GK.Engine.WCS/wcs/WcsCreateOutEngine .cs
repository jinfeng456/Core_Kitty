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
     class WcsCreateOutEngine : WcsBaseEngine
    {
        public long completeId;
        public long wmstaskId;
        public  int srcId;
        public int desId;
        public string boxCode;
        public int itemType;
        public long relyTaskId;
        public long tCompPId;

        public int carrierEnd;
        protected override bool Execute(IDbConnection connection, IDbTransaction transaction) 
        {
            int TaskNo = CommentFunction.BBTaskNo(connection, transaction);
            int carrierBegin = CommentFunction.getOutstockBeginCarrier(srcId, desId);
            ISequenceIdServer sequenceIdServer = ServerFactray.getServer<ISequenceIdServer>();
            long id = sequenceIdServer.getId();
            CommentFunction.BCrane(connection,transaction, itemType, TaskNo,srcId,carrierBegin,boxCode,completeId,tCompPId,id);
            if (desId==1)
            {
                carrierEnd = 1080;
            }
            else if(desId == 2)
            {
                carrierEnd = 1230;
            }
            else if (desId == 21)
            {
                carrierEnd = 2002;
            }
            else if (desId == 22)
            {
                carrierEnd = 2202;
            }
            CommentFunction.BCarrier(connection,transaction,TaskNo, carrierEnd, boxCode,completeId,tCompPId,itemType, carrierBegin, id);
            string sql = "update dbo.Task_complete set status=2 where Id=@completeId";
            connection.Execute(sql, new { completeId = completeId }, transaction);
            return true;
        }
       
    }   
}
