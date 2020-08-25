using System;
using System.Collections.Generic;
using GK.WCS.Carrier;
using CMNetLib.Robots.CarrierChain;
using CMNetLib.Robots.Crane;
using GK.WCS.DAL;
using System.Runtime.ExceptionServices;
using WCS.DAL;
using WCS.Common.task;
using WCS.Entity;
using WCS.Carrier.dto;
using WCS.Crane;
using WCS.Carrier;

namespace GK.WCS.Open.http.server {

    public class DapingServer:BaseServer {

        ITaskCarrierServer taskCarrierServer = ServerFactray.getServer<ITaskCarrierServer>();
        CarrierSynchro carrierSynchro = (CarrierSynchro)TaskPool.get<CarrierSynchro>();
       
        public override object work(List<String> param) {



            List< Object> taskCarrier = new List<Object> ( );
           
            Dictionary<int, CarrierSignalStatus>  SignalStates = carrierSynchro.getAllPointSignal();
            List<GkCraneStatusBase> craneList = new List<GkCraneStatusBase>();
            for (int i = 1;i < 12;i++) {
                CraneSynchro reader = TaskPool.get<CraneSynchro>(i);
                GkCraneStatus rs = (GkCraneStatus)reader.getCraneStatus();
                if (rs != null) {
                    craneList.Add(rs);
                }
            }
            foreach( var key in SignalStates ) {
                int taskNo = key.Value.taskNo;
                TaskCarrier carrier = taskCarrierServer.getCacheTaskCarrier ( taskNo );
                if( carrier != null ) {
                    taskCarrier.Add ( new { begin = key.Value.id ,end = carrier.endPath ,taskNo = taskNo } );
                }
               
            }

            return new { craneList = craneList, taskCarrier= taskCarrier , SignalStates = SignalStates };
        }




    }
}
