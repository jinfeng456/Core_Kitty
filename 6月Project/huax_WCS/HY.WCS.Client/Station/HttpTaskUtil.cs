
using System.Collections.Generic;
using GK.WCS.Common;
using GK.WCS.Common.dto;
using GK.WCS.Entity;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace GK.WCS.Client.Station {
    public class HttpTaskUtil
    {
        static public List<TaskComplete> getComplete() {
            JArray data = HttpUtil.getArray("Task/getComplete");
            if(data == null) {
                return null;
                ;
            }
            List <TaskComplete> list= JsonConvert.DeserializeObject<List<TaskComplete>>(data.ToString());
            return list;
        }

        static public bool UpdateTaskPriorityByCompleteId(long completeId)
        {
            JValue data = HttpUtil.getJValue("Task/UpdateTaskPriorityByCompleteId/" + completeId);

            if (data == null)
            {
                return false;
            }
            return bool.Parse(data.ToString());
        }

    }
}
