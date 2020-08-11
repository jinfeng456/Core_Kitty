﻿using System;
using GK.WCS.Common.task;
using GK.WCS.Carrier;
using GK.WCS.Scan;
using GK.WCS.Common.core.dto;
using GK.WCS.Common;
using GK.WCS.DAL;
using GK.WCS.Entity;
using GK.WCS.Carrier.dto;
using log4net.Repository.Hierarchy;
using System.Collections.Generic;
using GK.Engine.WMS.wms;
using System.Threading.Tasks;
using GK.WMS.Entity;
using GK.WMS.DAL;
using GK.WCS.Carrier.enumerate;
using static GK.WCS.Carrier.enumerate.CarrierPoint;
using System.Threading;

namespace GK.WCS.Controller {
    public class CarrierAllocateJobTask1 : CarrierAllocateJobTask {

        ITaskCarrierServer taskCarrierServer = ServerFactray.getServer<ITaskCarrierServer>();
        ITaskCraneServer taskCraneServer = ServerFactray.getServer<ITaskCraneServer>();
        ITaskCompleteServer taskCompleteServer = ServerFactray.getServer<ITaskCompleteServer>();
        ITaskServer taskServer = WMSDalFactray.getDal<ITaskServer>();
        GK.WCS.DAL.ISequenceIdServer sequenceIdServer ;

        CarrierSynchro carrierSynchro;
        Wms2WcsTask wms2WcsTask;
        List<int> inPoint = new List<int>();
        List<int> outPoint = new List<int>();
        public CarrierAllocateJobTask1() :base(1)
        {
          
        }
        protected override void onlyOneTime() {          
            carrierSynchro = (CarrierSynchro)TaskPool.get<CarrierSynchro>();
            wms2WcsTask = (Wms2WcsTask)TaskPool.get<Wms2WcsTask>();
            sequenceIdServer = ServerFactray.getServer<GK.WCS.DAL.ISequenceIdServer>();
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

            foreach (int point in inPoint)
            {
                string code = "BA0029102";
                CarrierSignalStatus carrierSignal = carrierSynchro.getSignalStatus(point);
                if (carrierSignal!=null && carrierSignal.code != 0 && carrierSignal.arrived==1)
                {
                    List<TaskComplete> taskComplete = taskCompleteServer.GetTaskCompleteByCode(code);
                    if (taskComplete.Count <= 0)
                    {
                        string errorMsg = string.Empty;
                        bool result = WMSTransactionFacade.doStockInEngine(code,ref errorMsg);
                        if (result)
                        {
                            InsertIntoTaskComplete(code, point);
                            List<TaskComplete> completeList = taskCompleteServer.getInTasks(1, code);
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

        public bool CheckStatus(int point, out CarrierSignalStatus carrierSignal)
        {
            carrierSignal = carrierSynchro.getSignalStatus(point);
            if (carrierSignal == null)
            {
                return false;
            }
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
            inPoint.Add(1000);
            inPoint.Add(1003);
            inPoint.Add(1006);
            inPoint.Add(1010);
        }
        public void OutPointAssign()
        {
            outPoint.Add(1089);
            outPoint.Add(1091);
            outPoint.Add(1093);
            outPoint.Add(1095);
            outPoint.Add(1097);
            outPoint.Add(1099);
            outPoint.Add(1101);
            outPoint.Add(1103);
            outPoint.Add(1105);
            outPoint.Add(1107);
            outPoint.Add(1109);
        }
       

    }
} 
