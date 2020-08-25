using GK.WCS.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using WCS.DAL;

namespace GK.WCS.Open.http.server
{
    public class MechineStatusServer: BaseServer
    {
        IMechineStatusServer mechineStatusServer = ServerFactray.getServer<IMechineStatusServer>();

        public bool UpdateCraneOverStop(List<String> param)
        {
            int craneId = int.Parse(param[0]);
            int value = int.Parse(param[1]);
            return mechineStatusServer.UpdateCraneOverStop(craneId,value);
        }

        public int GetCraneOverStop(List<String> param)
        {

     
               mechineStatusServer = ServerFactray.getServer<IMechineStatusServer>();
            int craneId = int.Parse(param[0]);
            return mechineStatusServer.GetCraneOverStop(craneId);
        }

        public bool Update(List<String> param)
        {
            int craneId = int.Parse(param[0]);
            int value = int.Parse(param[1]);
            return mechineStatusServer.Update(craneId, value);
        }

        public int GetCraneRunStatus(List<String> param)
        {
            int craneId = int.Parse(param[0]);
            return mechineStatusServer.GetCraneRunStatus(craneId);
        }
    }
}
