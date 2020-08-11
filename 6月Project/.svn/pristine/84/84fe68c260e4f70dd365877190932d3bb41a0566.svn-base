using System;
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
    public class CarrierAllocateJobTask6 : CarrierAllocateJobTask {

        ITaskCarrierServer taskCarrierServer = ServerFactray.getServer<ITaskCarrierServer>();
        ITaskCraneServer taskCraneServer = ServerFactray.getServer<ITaskCraneServer>();
        ITaskCompleteServer taskCompleteServer = ServerFactray.getServer<ITaskCompleteServer>();
        ITaskServer taskServer = WMSDalFactray.getDal<ITaskServer>();
        GK.WCS.DAL.ISequenceIdServer sequenceIdServer = ServerFactray.getServer<GK.WCS.DAL.ISequenceIdServer>();

        CarrierSynchro carrierSynchro;
        Wms2WcsTask wms2WcsTask;
        List<int> outPoint = new List<int>();
        public CarrierAllocateJobTask6() :base(6)
        {
        }
        protected override void onlyOneTime() {          
            carrierSynchro = (CarrierSynchro)TaskPool.get<CarrierSynchro>();
            wms2WcsTask = (Wms2WcsTask)TaskPool.get<Wms2WcsTask>();
        }
        public override void excute() {
            OutPointAssign();
            int dirR = CarrierDirection.dirR;
            if (dirR == 2)
            {
                if (outPointApply(outPoint))
                {
                    Thread.Sleep(2000);
                }
            }             
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
        public void OutPointAssign()
        {
            outPoint.Add(2317);
            outPoint.Add(2318);
            outPoint.Add(2319);
            outPoint.Add(2320);
            outPoint.Add(2321);
            outPoint.Add(2322);
            outPoint.Add(2323);
            outPoint.Add(2324);
        }
       

    }
} 
