﻿using System;
using System.Collections.Generic;
using GK.WCS.DAL;
using GK.WCS.Entity;
using GK.WCS.Common;
using GK.Engine.WMS;
using GK.Engine.WMS.wms;

namespace GK.WCS.Controller {
    public class Wcs2WmsTask:ZtTask {
        public Wcs2WmsTask() {
            time = 2000;
        }



        ITaskCompleteServer completeDAL = ServerFactray.getServer<ITaskCompleteServer>();
        ITaskCraneServer craneDAL = ServerFactray.getServer<ITaskCraneServer>();
        ITaskCarrierServer carrierDAL = ServerFactray.getServer<ITaskCarrierServer>();
        protected override bool init() {
            return true;
        }

        public override void excute() {
            List<TaskComplete> list = completeDAL.getfinshTasks();
            string errorMsg = string.Empty;
            foreach (TaskComplete task in list)
            {
                TaskCrane craneTask = craneDAL.getTaskCraneByCompleteId(task.id);
                TaskCarrier carrierTask = carrierDAL.getCarrierTaskByCompleteId(task.id);
                if (craneTask.status == 9 && carrierTask.status == 9)
                {
                    if (WMSTransactionFacade.syncWcsReult(task.wmsTaskId, task.status,ref errorMsg))
                    {//同步成功
                        LoggerCommon.fileAll(task.wmsTaskId + "wms 同步");
                        completeDAL.finshSyncById(task.id);
                    }
                }
                else if (craneTask.status == -1 && carrierTask.status == -1)
                { 
                    if (WMSTransactionFacade.syncWcsReult(task.wmsTaskId, task.status,ref errorMsg))
                    {//同步成功
                        LoggerCommon.fileAll(task.wmsTaskId + "wms 同步");
                        completeDAL.finshSyncById(task.id);
                    }
                }
            }
        }

    }
}
