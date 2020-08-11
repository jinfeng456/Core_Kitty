using System;
using System.Collections.Generic;
using GK.WCS.Entity;
using GK.WCS.Open.http.server;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace GK.WCS.Client.Station {
    public class HttpCarrierUtil {


       public static  String clearAction(int plcId,int CarrierID) {
            JValue data = HttpUtil.getJValue("Carrier/clearAction/"+ plcId+"/" + CarrierID);
            return data.ToString();
        }
        public static String resetAction(int plcId,int CarrierID) {
            JValue data = HttpUtil.getJValue("Carrier/resetAction/"+plcId+"/" + CarrierID);
            return data.ToString();
        }

        public static String sendMiddle( int Taskno,int path,int posin ) {
            JValue data = HttpUtil.getJValue("Carrier/sendMiddle/" + Taskno + "/" + path + "/" + posin);
            return data.ToString();
        }
        public static CarrierData reflash(int plcId,int taskNo) {
            JObject data = HttpUtil.getObject("Carrier/reflash/"+ plcId + "/" + taskNo);
            if(data == null) {
                return null;
            }
            CarrierData carrierData = JsonConvert.DeserializeObject<CarrierData>(data.ToString());
            return carrierData;
        }

        static public List<TaskCarrier> getCarrierTaskByCompleteId(long completeId)
        {
            JArray data = HttpUtil.getArray("Carrier/getCarrierTaskByCompleteId/" + completeId);
            if (data == null)
            {
                return null;
                ;
            }
            List<TaskCarrier> list = JsonConvert.DeserializeObject<List<TaskCarrier>>(data.ToString());
            return list;
        }

        static public bool DeleteCarrierTask(long completeId)
        {
            JValue data = HttpUtil.getJValue("Carrier/DeleteCarrierTask/" + completeId);
            if (data == null)
            {
                return false;
            }
            return bool.Parse(data.ToString());
        }

        static public bool ResetCarrierTaskById(long taskId)
        {
            JValue data = HttpUtil.getJValue("Carrier/ResetCarrierTaskById/" + taskId);
            if (data == null)
            {
                return false;
            }
            return bool.Parse(data.ToString());
        }

        static public bool FinishCarrierTaskById(long taskId)
        {
            JValue data = HttpUtil.getJValue("Carrier/FinishCarrierTaskById/" + taskId);
            if (data == null)
            {
                return false;
            }
            return bool.Parse(data.ToString());
        }


    }
}
