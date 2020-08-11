using System;
using System.Collections.Generic;

using GK.WCS.Common;

using GK.WCS.Common.task;
using GK.WCS.Carrier;
using CMNetLib.Robots.CarrierChain;
using GK.WCS.Common.core.dto;
using CMNetLib.Robots.Crane;
using GK.WCS.Entity;
using GK.WCS.DAL;
using GK.WCS.Carrier.dto;

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
