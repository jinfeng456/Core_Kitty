using GK.WCS.DAL;
using GK.WCS.DAL.inter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using WCS.Carrier;
using WCS.Carrier.dto;
using WCS.DAL;

namespace GK.WCS.Carrier
{
    public class CarrierDirectionR : CarrierDirection
    {

        IDeviceInOrOutServer deviceInOrOutServer = ServerFactray.getServer<IDeviceInOrOutServer>();




        public CarrierDirectionR() : base(5)
        {

        }

        public override int GetModel()
        {
            int LeftMode1 = deviceInOrOutServer.GetInOrNot(5);
            return LeftMode1;
        }

        public override CarrierSignalStatus GetSignalStatus()
        {
            CarrierSignalStatus carrierSignalStatus1 = carrierSynchro.getSignalStatus(2201);
            return carrierSignalStatus1;
        }
    }
}
