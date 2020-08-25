
using GK.WCS.DAL.inter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using WCS.Carrier;
using WCS.Carrier.dto;
using WCS.DAL;

namespace GK.WCS.Carrier {
    public class CarrierDirectionL: CarrierDirection
    {

        IDeviceInOrOutServer deviceInOrOutServer = ServerFactray.getServer<IDeviceInOrOutServer>();


        

        public CarrierDirectionL():base(4)
        {
            
        }

        public override int GetModel()
        {
            int LeftMode1 = deviceInOrOutServer.GetInOrNot(4);
            return LeftMode1;
        }

        public override CarrierSignalStatus GetSignalStatus()
        {
            CarrierSignalStatus carrierSignalStatus1 = carrierSynchro.getSignalStatus(2001);
            return carrierSignalStatus1;
        }
    }
}
