using System;
using System.Collections.Generic;
using GK.WCS.Carrier;
using GK.WCS.Scan;
using GK.WCS.DAL;
using System.Threading;
using GK.WMS.DAL;
using GK.WMS.Entity;
using WCS.Common;
using WCS.DAL;
using WMS.DAL;
using WCS.Entity;
using WCS.Common.task;
using WMS.Entity;
using WCS.Carrier;

namespace GK.WCS.Controller {
    public abstract class CarrierAllocateJobTask : ZtTask {

        protected CarrierConnect connect;
        protected DateLogicReader dateLogicReader ;


        protected ITaskCraneServer craneTaskDAL = ServerFactray.getServer<ITaskCraneServer>();
        protected ITaskCarrierServer CarrierDAL = ServerFactray.getServer<ITaskCarrierServer>();
        protected ITaskCompleteServer comServer = ServerFactray.getServer<ITaskCompleteServer>();
        protected ICoreTaskServer coreTaskServer = ServerFactray.getServer<ICoreTaskServer>();
        ITaskServer taskServer = WMSDalFactray.getDal<ITaskServer>();

        protected int CarrierId=1;
        public CarrierAllocateJobTask(int carrierId) {
            time = 600;
            CarrierId = carrierId;
        }
        protected override bool init()
        {
            return true;
        }

        protected void sendCrarrer(short codestate,TaskCarrier carrier,short wbegin ,short rbegin,int plcId) 
        {
            //修改core_task状态为3
            long wmsid = comServer.GetWmsIdById(carrier.completeId);
            bool result = coreTaskServer.UpdateStatusById(wmsid);
            connect = (CarrierConnect)TaskPool.get<CarrierConnect>(plcId);
            connect.SendTask(codestate,carrier, wbegin);
            connect.sendTaskHandshake(wbegin, 1);
        }

        protected void InsertIntoTaskComplete(string code, int point)
        {
            //查找入库任务插入
            List<CoreTask> list = taskServer.GetInTask(code);
            foreach (CoreTask task in list)
            {
                TaskComplete complete = comServer.getTaskCompleteByWmsTaskId(task.id);
                if (complete == null)
                {
                    complete = new TaskComplete();
                    complete.id = WCSDalUtil.getID();
                    complete.wmsTaskId = task.id;
                    complete.boxCode = task.boxCode;
                    complete.taskType = task.taskType;
                    complete.des = task.des;
                    complete.src = point;
                    complete.status = 1;
                    complete.Priority = task.Priority;
                    complete.info = task.info;
                    complete.relyTaskId = task.relyTaskId;
                    complete.createTime = DateTime.Now;
                    comServer.insertNotNull(complete);
                }
            }
        }
    }
}
