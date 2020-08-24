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
using GK.WCS.Crane;
using System.Runtime.ExceptionServices;

namespace GK.WCS.Open.http.server {

    public class DapingServer:BaseServer {

        ITaskCarrierServer taskCarrierServer = ServerFactray.getServer<ITaskCarrierServer>();
        CarrierSynchro carrierSynchro = (CarrierSynchro)TaskPool.get<CarrierSynchro>();
        List<TaskCarrier> carrierList = new List<TaskCarrier>();
        public override object work(List<String> param) {

            Dictionary<int, Object> taskCarrier = new Dictionary<int, Object>();
           
            Dictionary<int, CarrierSignalStatus>  SignalStates = carrierSynchro.getAllPointSignal();
            List<GkCraneStatusBase> craneList = new List<GkCraneStatusBase>();
            for (int i = 1;i < 12;i++) {
                CraneSynchro reader = TaskPool.get<CraneSynchro>(i);
                GkDYGCraneStatus rs = (GkDYGCraneStatus)reader.getCraneStatus();
                if (rs != null) {
                    craneList.Add(rs);
                }
            }
            getTaskCarrier(taskCarrier, SignalStates);
          
            return new { craneList = craneList, taskCarrier= taskCarrier , SignalStates = SignalStates };
        }


        void getTaskCarrier(Dictionary<int, Object>  taskCarrier, Dictionary<int, CarrierSignalStatus> SignalStates)
        {
            foreach (var key in SignalStates)
            {
                int taskNo = key.Value.taskNo;

                foreach (TaskCarrier c in carrierList)
                {
                    if (taskNo == c.taskNo)
                    {
                        taskCarrier.Add(taskNo, new { endPath = c.endPath });
                        taskNo = 0;
                        break;
                    }
                }
                if (taskNo != 0)
                {
                    TaskCarrier carrier = taskCarrierServer.getCarrarTasksByTaskNo(taskNo);
                    if (carrier != null) {
                        carrierList.Add(carrier);
                        taskCarrier.Add(taskNo, new { endPath = carrier.endPath });
                    }
                   
                }

            }

            while (carrierList.Count > 1000) {
                carrierList.RemoveAt(0);
            }
        }


    }
}
