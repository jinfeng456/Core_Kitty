using GK.WCS.Client.Station;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HY.WCS.Client.Station
{
    public class HttpDeviceInOrNotUtil
    {
        static public bool UpdateInOrNot(int CraneId,int value)
        {
            JValue data = HttpUtil.getJValue("DeviceInOrNot/UpdateInOrNot/" + CraneId + "/" + value);
            if (data == null)
            {
                return false;
            }
            return bool.Parse(data.ToString());
        }
    }
}
