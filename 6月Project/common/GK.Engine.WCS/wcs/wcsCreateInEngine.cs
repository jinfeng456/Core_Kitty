﻿using System.Data;
using Dapper;
using GK.WCS.DAL;

namespace GK.Engine.WCS
{
     class WcsCreateInEngine : WcsBaseEngine
    {
        public  long completeId;
        public long wmstaskId;
        public  int srcId;
        public int desId;
        public string boxCode;
        public int itemType;
        public long tCompPId;
        protected override bool Execute(IDbConnection connection, IDbTransaction transaction) {             
            int carrierEnd = CommentFunction.getInstockEndCarrier(srcId, desId);
            int TaskNo = CommentFunction.BBTaskNo(connection, transaction);
            ISequenceIdServer sequenceIdServer = ServerFactray.getServer<ISequenceIdServer>();
            long  id = sequenceIdServer.getId();

            CommentFunction.BCarrier(connection, transaction, TaskNo,carrierEnd,boxCode,completeId,tCompPId,itemType,srcId,id);
            CommentFunction.BCrane(connection, transaction, itemType, TaskNo, carrierEnd, desId,boxCode,completeId,tCompPId,id);///??????
            string sql1= "update Task_complete set status=2 where id=@completeId";
            int i = connection.Execute(sql1, new {completeId }, transaction);
            return true;          
        }
      
        
    }    
}
