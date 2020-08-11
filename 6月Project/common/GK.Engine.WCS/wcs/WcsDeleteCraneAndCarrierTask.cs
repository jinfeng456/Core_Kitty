using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace GK.Engine.WCS.wcs
{
     class WcsDeleteCraneAndCarrierTask : WcsBaseEngine
    {
        public long completeId;
        protected override bool Execute(IDbConnection connection, IDbTransaction transaction)
        {
            string sql = "update dbo.Task_crane set status=-1 where complete_Id=@completeId";
            int i = connection.Execute(sql, new { completeId = completeId }, transaction);
            string sql1 = "update dbo.Task_carrier set status=-1 where complete_Id=@completeId";
            int j = connection.Execute(sql1, new { completeId = completeId }, transaction);
            if (i >= 1 && j >= 1)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
    }
}
