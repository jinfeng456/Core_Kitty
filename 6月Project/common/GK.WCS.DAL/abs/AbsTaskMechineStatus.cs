using Dapper;
using GK.WCS.Entity.wcs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WCS.DAL.abs
{
    public class AbsTaskMechineStatus : AbsWCSBaseServer, IMechineStatusServer
    {
        public int GetCraneOverStop(int craneId)
        {
            MechineStatus mechineStatus;
            string sql = "select * from mechine_status where Id=@craneId";
            mechineStatus = Connection.Query<MechineStatus>(sql, new { craneId = craneId }).FirstOrDefault();
            return mechineStatus.overStop;
        }

        public int GetCraneRunStatus(int craneId)
        {
            MechineStatus mechineStatus;
            string sql = "select * from mechine_status where Id=@craneId";
            mechineStatus = Connection.Query<MechineStatus>(sql, new { craneId = craneId }).FirstOrDefault();
            return mechineStatus.runStatus;
        }

        public bool Update(int id, int runStatus)
        {
            string sql = "update mechine_status set run_Status=@runStatus where id=@id";
            int i = Connection.Execute(sql, new { runStatus = runStatus, id = id });
            if (i != 1)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        public bool UpdateCraneOverStop(int craneId, int value)
        {
            string sql = "update mechine_status set overstop=@value where id=@craneId";
            int i = Connection.Execute(sql, new { value = value, craneId= craneId });
            if (i != 1)
            {
                return false;
            }
            else
            {
                return true;
            }
        }


    }
}
