using System;
using System.Collections.Generic;
using GK.WCS.Carrier;
using CMNetLib.Robots.CarrierChain;
using CMNetLib.Robots.Crane;
using GK.WCS.DAL;
using WCS.DAL;
using WCS.Entity;

namespace GK.WCS.Open.http.server {

   public class TaskServer:BaseServer {
     
        ITaskCompleteServer taskCompleteServer = ServerFactray.getServer<ITaskCompleteServer>();
        ///Task/getComplete
        public List<TaskComplete> getComplete(List<String> param) {
           return taskCompleteServer.getAll();
        }

        public bool UpdateTaskPriorityByCompleteId(List<String> param)
        {
            long completeId = long.Parse(param[0]);
            return taskCompleteServer.UpdateTaskPriorityByCompleteId(completeId);
        }

    }

}
