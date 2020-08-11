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

    public class PlcData {



        public Dictionary<int,CarrierSignalStatus> SignalStates {
            get; set;
        }

        public List<GkCraneStatusBase> craneList {
            get; set;
        }


    }
    public class DapingServer:BaseServer {

        ITaskCarrierServer taskCarrierServer = ServerFactray.getServer<ITaskCarrierServer>();


        public override object work(List<String> param) {

            PlcData d = new PlcData();
             Dictionary<int, CarrierSignalStatus> dic=new  Dictionary<int, CarrierSignalStatus>();
            CarrierSignalStatus css = new CarrierSignalStatus(41,1222,4);
            dic.Add(41,css);
            d.SignalStates=dic;
           /*
            CarrierSynchro carrierSynchro = (CarrierSynchro)TaskPool.get<CarrierSynchro>();
            d.SignalStates = carrierSynchro.getAllPointSignal();
            List<GkCraneStatusBase> craneList = new List<GkCraneStatusBase>();
            for (int i = 1;i < 12;i++) {
                CraneSynchro reader = TaskPool.get<CraneSynchro>(i);
                GkDYGCraneStatus rs = (GkDYGCraneStatus)reader.getCraneStatus();
                if (rs != null) {
                    craneList.Add(rs);
                }

            }
            d.craneList = craneList;
         */
            return d;
        }


    }
}
