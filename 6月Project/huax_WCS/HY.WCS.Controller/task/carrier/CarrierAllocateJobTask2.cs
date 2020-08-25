using System;
using GK.WCS.Carrier;
using GK.WCS.Scan;
using GK.WCS.DAL;
using log4net.Repository.Hierarchy;
using System.Collections.Generic;
using GK.Engine.WMS.wms;
using System.Threading.Tasks;
using GK.WMS.Entity;
using GK.WMS.DAL;
using System.Threading;
using WCS.Carrier.dto;
using WCS.DAL;
using WMS.DAL;
using WCS.Common.task;
using WCS.Entity;
using WCS.Carrier.enumerate;
using WCS.Common;
using WCS.Carrier;

namespace GK.WCS.Controller {
    public class CarrierAllocateJobTask2 : CarrierAllocateJobTask {

        ITaskCarrierServer taskCarrierServer = ServerFactray.getServer<ITaskCarrierServer>();
        ITaskCraneServer taskCraneServer = ServerFactray.getServer<ITaskCraneServer>();
        ITaskCompleteServer taskCompleteServer = ServerFactray.getServer<ITaskCompleteServer>();
        ITaskServer taskServer = WMSDalFactray.getDal<ITaskServer>();

        CarrierSynchro carrierSynchro;
        Wms2WcsTask wms2WcsTask;
        List<int> inPoint = new List<int>();
        List<int> outPoint = new List<int>();
        public CarrierAllocateJobTask2() :base(2)
        {
            
        }
        protected override void onlyOneTime() {          
            carrierSynchro = (CarrierSynchro)TaskPool.get<CarrierSynchro>();
            wms2WcsTask = (Wms2WcsTask)TaskPool.get<Wms2WcsTask>();
        }
        public override void excute() {
            inPointAssign();
            OutPointAssign();
            DownLoadTask(inPoint);
            if (inPointApply(inPoint))
            {
                Thread.Sleep(2000);
            }
            if (outPointApply(outPoint))
            {
                Thread.Sleep(2000);
            }          
        }

        public void DownLoadTask(List<int> inPoint)
        {
            string errorMsg = string.Empty;
            foreach (int point in inPoint)
            {
                CarrierSignalStatus carrierSignal = carrierSynchro.getSignalStatus(point);
                if (carrierSignal.code != 0)
                {
                    List<TaskComplete> taskComplete = taskCompleteServer.GetTaskCompleteByCode(carrierSignal.code.ToString());
                    if (taskComplete.Count <= 0)
                    {
                        bool result = WMSTransactionFacade.doStockInEngine(carrierSignal.code.ToString(), ref errorMsg);
                        if (result)
                        {
                            InsertIntoTaskComplete(carrierSignal.code.ToString(),point);
                            List<TaskComplete> completeList = taskCompleteServer.getInTasks(1, carrierSignal.code.ToString());
                            foreach (TaskComplete task in completeList)
                            {
                                wms2WcsTask.sync(task);
                            }
                        }
                    }
                }
            }
        }





        public bool inPointApply(List<int> inPoint)
        {
            bool a = false;
            CarrierSignalStatus carrierSignal;
            Dictionary<int, PlcCarrierPoint> carrierPoint = CarrierPoint.carrierPoint;
            foreach (int point in inPoint)
            {
                bool result = CheckStatus(point, out carrierSignal);
                if (result)
                {
                    if (carrierSignal.arriveApply == 1)
                    {
                        TaskCarrier taskCarrier = taskCarrierServer.getByCode(carrierSignal.code.ToString());
                        sendCrarrer(1, taskCarrier, (short)carrierPoint[point].WOffset, (short)carrierPoint[point].ROffset, carrierPoint[point].PlcId);
                        a = true;
                    }
                }
            }
            return a;
        }

        public bool outPointApply(List<int> outPoint)
        {
            bool a = false;
            CarrierSignalStatus carrierSignal;
            Dictionary<int, PlcCarrierPoint> carrierPoint = CarrierPoint.carrierPoint;
            foreach (int point in outPoint)
            {
                bool result = CheckStatus(point, out carrierSignal);
                if (result)
                {
                    if (carrierSignal.arriveApply == 1)
                    {
                        TaskCarrier taskCarrier = taskCarrierServer.getCarrierTask(carrierPoint[point].pathNo);
                        sendCrarrer(1, taskCarrier, (short)carrierPoint[point].WOffset, (short)carrierPoint[point].ROffset, carrierPoint[point].PlcId);
                        a = true;
                    }
                }
            }
            return a;
        }

        private bool CheckStatus(int point, out CarrierSignalStatus carrierSignal)
        {
            carrierSignal = carrierSynchro.getSignalStatus(point);
            if (carrierSignal.plcMode != 4)
            {
                LoggerCommon.fileAll("PLC不是自动状态！");
                return false;
            }
            if (carrierSignal.plcState != 1)
            {
                LoggerCommon.fileAll("PLC没有启动完成！");
                return false;
            }
            return true;
        }
        public void inPointAssign()
        {
            inPoint.Add(1200);
            inPoint.Add(1203);
            inPoint.Add(1206);
            inPoint.Add(1210);
        }
        public void OutPointAssign()
        {
            outPoint.Add(1216);
            outPoint.Add(1219);
            outPoint.Add(1222);
        }
       

    }
} 
