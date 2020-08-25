
using System.Collections.Generic;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using WCS.Common;
using WCS.Common.dto;

namespace GK.WCS.Client.Station {
    public class HttpSysUtil {


       public static List<ShowCache> showLog() {
            JArray data = HttpUtil.getArray("Sys/showLog");
            if(data == null) {
                return null;
            }

            List < ShowCache > list = JsonConvert.DeserializeObject<List<ShowCache>>(data.ToString());
            return list;
        }

        ///Crane/IsAutoRunning/craneId/
        static public List<TaskStat> getStat() {
            JArray data = HttpUtil.getArray("Sys/getStat");
            if(data == null) {
                return null;
                ;
            }
            List < TaskStat > list= JsonConvert.DeserializeObject<List<TaskStat>>(data.ToString());
            return list;
        }
       

       
    }
}
