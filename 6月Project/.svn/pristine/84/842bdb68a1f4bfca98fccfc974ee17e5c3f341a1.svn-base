using System;
using System.Configuration;
using System.IO;
using System.Net;
using System.Text;
using GK.WCS.Client;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace GK.WCS.Client.Station {
    internal class HttpUtil {



        internal static JArray getArray(String url) {
            JObject jsonObject = getHttpData(url);
            if(jsonObject == null) {
                return null;
            }
            JArray data = (JArray)jsonObject["data"];
            return data;
        }

        public static JObject getObject(String url) {
            JObject jsonObject = getHttpData(url);
            if(jsonObject == null) {
                return null;
            }
            JObject data = (JObject)jsonObject["data"];
            return data;
        }
        public static JValue getJValue(String url) {
            JObject jsonObject = getHttpData(url);
            if(jsonObject == null) {
                return null;
            }
            JValue data = (JValue)jsonObject["data"];
            return data;
        }

        private static JObject getHttpData(String url) {
            String baseUrl  =ConfigurationManager.AppSettings["wcsServer"];
           
            url = baseUrl + url;
            HttpWebRequest request = WebRequest.Create(url) as HttpWebRequest;
            request.Timeout = 500;
            request.Method = "GET";
            request.ContentType = "text/json";//链接类型
            request.KeepAlive = false;
            string json = "";
            HttpWebResponse response = null;
            long t1 = DateTime.Now.Ticks;
            try {
                response = request.GetResponse() as HttpWebResponse;
            } catch(Exception e) {
                FrmMain.main.setNetInfo(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + e.Message + url);
                return null;
            }

            using(Stream s = response.GetResponseStream()) {
                StreamReader reader = new StreamReader(s,Encoding.UTF8);
                json = reader.ReadToEnd();

            }
            t1 = (DateTime.Now.Ticks - t1)/10000;
            FrmMain.main.setNetInfo(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")+"用时"+t1 + "ms" + url);

            JObject jsonObject = JsonConvert.DeserializeObject<JObject>(json);
            if(jsonObject["status"].ToString() != "0") {
                FrmMain.main.setNetInfo(url + jsonObject["data"].ToString());
                return null;
           
            }
            return jsonObject;
        }

       
    }
}
