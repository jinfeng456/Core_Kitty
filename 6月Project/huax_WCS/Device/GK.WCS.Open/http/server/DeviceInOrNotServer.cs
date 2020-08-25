using System;
using System.Collections.Generic;
using GK.WCS.DAL;
using GK.WCS.DAL.inter;
using WCS.DAL;

namespace GK.WCS.Open.http.server {

    public class DeviceInOrNotServer : BaseServer {
        IDeviceInOrOutServer deviceInOrNotServer = ServerFactray.getServer<IDeviceInOrOutServer>();

        public bool UpdateInOrNot(List<String> param) {
            int craneId = int.Parse(param[0]);
            int value = int.Parse(param[1]);
            return deviceInOrNotServer.UpdateInOrNot(craneId, value);
            return true;
        }


    }
}
