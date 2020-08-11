using System;
using System.Collections.Generic;
using GK.WCS.Common;
using GK.WCS.Common.task;
using GK.WCS.Carrier;
using GK.WCS.Common.core.dto;
using GK.WCS.Scan;
using GK.WCS.DAL;
using GK.WCS.Entity;
using System.Threading;
using GK.WMS.DAL;
using GK.WMS.Entity;

namespace GK.WCS.Controller {
    public abstract class CarrierAllocateJobTask : ZtTask {

        protected CarrierConnect connect;
        protected DateLogicReader dateLogicReader ;


        protected ITaskCraneServer craneTaskDAL = ServerFactray.getServer<ITaskCraneServer>();
        protected ITaskCarrierServer CarrierDAL = ServerFactray.getServer<ITaskCarrierServer>();
        protected ITaskCompleteServer comServer = ServerFactray.getServer<ITaskCompleteServer>();
        protected ICoreTaskServer coreTaskServer = ServerFactray.getServer<ICoreTaskServer>();
        ITaskServer taskServer = WMSDalFactray.getDal<ITaskServer>();
        GK.WCS.DAL.ISequenceIdServer sequenceIdServer = ServerFactray.getServer<GK.WCS.DAL.ISequenceIdServer>();

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
            for (int i = 0; i < 3; i++)
            {                
                Thread.Sleep(10);
                if (Tools.ushort16(connect.ReadTaskHandshake(rbegin, 2), 0) == 2)
                {
                    connect.sendTaskHandshake(wbegin, 0);
                }
            }
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
                    complete.id = sequenceIdServer.getId();
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
