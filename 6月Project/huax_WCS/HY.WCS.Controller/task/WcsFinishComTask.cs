using System;
using System.Collections.Generic;
using GK.WCS.DAL;
using GK.WCS.Entity;
using GK.WCS.Common;
using GK.Engine.WMS;
using GK.Engine.WMS.wms;

namespace GK.WCS.Controller {
    public class WcsFinishComTask : ZtTask {
        public WcsFinishComTask() {
            time = 2000;
        }



        ITaskCompleteServer completeDAL = ServerFactray.getServer<ITaskCompleteServer>();
        ITaskCraneServer craneDAL = ServerFactray.getServer<ITaskCraneServer>();
        ITaskCarrierServer carrierDAL = ServerFactray.getServer<ITaskCarrierServer>();
        protected override bool init() {
            return true;
        }
        public override void excute() {
            List<TaskComplete> list = completeDAL.getResolveTasks();
            foreach (TaskComplete task in list)
            {
                TaskCrane craneTask = craneDAL.getTaskCraneByCompleteId(task.id);
                TaskCarrier carrierTask = carrierDAL.getCarrierTaskByCompleteId(task.id);
                if (craneTask.status == 9 && carrierTask.status == 9)
                {
                    completeDAL.UpdateStatusById(task.id,3);
                }
                else if (craneTask.status == -1 && carrierTask.status == -1)
                {
                    completeDAL.UpdateStatusById(task.id, -1);
                }
            }
        }

    }
}
