using GK.WCS.Client.Station;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HY.WCS.Client.Station
{
    public class HttpMechineStatusUtil
    {
        static public bool UpdateCraneOverStop(int CraneId,int value)
        {
            JValue data = HttpUtil.getJValue("MechineStatus/UpdateCraneOverStop/" + CraneId + "/" + value);
            if (data == null)
            {
                return false;
            }
            return bool.Parse(data.ToString());
        }

        static public int GetCraneOverStop(int CraneId)
        {
            JValue data = HttpUtil.getJValue("MechineStatus/GetCraneOverStop/" + CraneId);
            if (data == null)
            {
                return 3;
            }
            return int.Parse(data.ToString());
        }

        static public bool Update(int CraneId, int value)
        {
            JValue data = HttpUtil.getJValue("MechineStatus/Update/" + CraneId + "/" + value);
            if (data == null)
            {
                return false;
            }
            return bool.Parse(data.ToString());
        }

        static public int GetCraneRunStatus(int CraneId)
        {
            JValue data = HttpUtil.getJValue("MechineStatus/GetCraneRunStatus/" + CraneId);
            if (data == null)
            {
                return 3;
            }
            return int.Parse(data.ToString());
        }
    }
}
