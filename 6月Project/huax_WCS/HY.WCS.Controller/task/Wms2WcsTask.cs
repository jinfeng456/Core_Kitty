using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GK.WCS.DAL;
using GK.WMS.Entity;
using GK.WMS.DAL;
using GK.Engine.WCS;
using GK.WCS.Carrier;
using WCS.Common;
using WCS.DAL;
using WMS.DAL;
using WCS.Common.task;
using WCS.Entity;
using WMS.Entity;
using WCS.Carrier;

namespace GK.WCS.Controller {

    public class Wms2WcsTask:ZtTask {
        private static object lock_obj = new object();
        public Wms2WcsTask() {
            time = 500;
        }

        ITaskCraneServer craneDAL = ServerFactray.getServer<ITaskCraneServer>();
        ITaskCarrierServer carrierDAL = ServerFactray.getServer<ITaskCarrierServer>();
        ITaskServer taskServer;
        ITaskCompleteServer completeServer = null;
        CarrierConnect connect = null;

        protected override bool init() {       
            taskServer = WMSDalFactray.getDal<ITaskServer>();
            completeServer = ServerFactray.getServer<ITaskCompleteServer>();
            connect = TaskPool.get<CarrierConnect>(1);
            return true;
        }
        public override void excute() {
            wmsToWcsData();
           List<TaskComplete> completeList = completeServer.getTasks(1);
            foreach (TaskComplete task in completeList) {
                sync(task);
            }
        }

        public void wmsToWcsData()
        {
            //获取Core_task中状态为2的出库任务和移库任务
            List<CoreTask> list = taskServer.getAllUnSyncTask();
            foreach (CoreTask task in list)
            {
                if (task.status==2)
                {
                    //CoreTask，CoreTaskParam 保存 到Task_complete，Task_complete_param
                    //判断Task_complete是否含有此数据
                    TaskComplete complete = completeServer.getTaskCompleteByWmsTaskId(task.id);
                    if (complete == null)
                    {
                        complete = new TaskComplete();
                        complete.id = WCSDalUtil.getID();
                        complete.wmsTaskId = task.id;
                        complete.boxCode = task.boxCode;
                        complete.taskType = task.taskType;
                        complete.des = task.des;
                        complete.src = task.src;
                        complete.status = 1;
                        complete.Priority = task.Priority;
                        complete.info = task.info;
                        complete.relyTaskId = task.relyTaskId;
                        complete.createTime = DateTime.Now;
                        completeServer.insertNotNull(complete);
                    }
                }
                else if (task.status == -2)
                {
                    //1、查询completeId
                    TaskComplete complete = completeServer.getTaskCompleteByWmsTaskId(task.id);
                    //2、查询修改垛机和输送线状态为-1
                    craneDAL.UpdateCraneStatusByComId(complete.id,-1);
                    carrierDAL.UpdateCraneStatusByComId(complete.id, -1);
                }
            }
        }
        
        public void sync(TaskComplete task) {   
            lock (lock_obj) {
                bool check = false;
                if(task.taskType == 1) {
                   check= WCSTransactionFacade.doStockInEngine(task);
                } else if(task.taskType == 2) {
                    check = WCSTransactionFacade.docreateOutEngine(task);
                } else if(task.taskType == 3) {
                   check= WCSTransactionFacade.doCreateMoveEngine(task);
                    taskServer.updateTaskStatus(task.id,3);                   
                }
            }
        }

    }
}
