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
using WCS.Carrier.enumerate;
using WCS.Entity;
using WCS.Common;
using WCS.Carrier;

namespace GK.WCS.Controller {
    public class CarrierAllocateJobTask3 : CarrierAllocateJobTask {

        ITaskCarrierServer taskCarrierServer = ServerFactray.getServer<ITaskCarrierServer>();
        ITaskCraneServer taskCraneServer = ServerFactray.getServer<ITaskCraneServer>();
        ITaskCompleteServer taskCompleteServer = ServerFactray.getServer<ITaskCompleteServer>();
        ITaskServer taskServer = WMSDalFactray.getDal<ITaskServer>();

        CarrierSynchro carrierSynchro;
        Wms2WcsTask wms2WcsTask;

        List<int> outPoint = new List<int>();
        public CarrierAllocateJobTask3() :base(3)
        {
            
        }
        protected override void onlyOneTime() {          
            carrierSynchro = (CarrierSynchro)TaskPool.get<CarrierSynchro>();
            wms2WcsTask = (Wms2WcsTask)TaskPool.get<Wms2WcsTask>();
        }
        public override void excute() {
            OutPointAssign();

            if (outPointApply(outPoint)) 
            {
                Thread.Sleep(2000);
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
            outPoint.Add(1360);
            outPoint.Add(1362);
            outPoint.Add(1364);
            outPoint.Add(1366);
            outPoint.Add(1368);
            outPoint.Add(1370);
            outPoint.Add(1372);
            outPoint.Add(1374);
        }
       

    }
} 
