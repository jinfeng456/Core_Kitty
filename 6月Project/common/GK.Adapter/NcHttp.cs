using GK.Ws.Mes.NC;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.CompilerServices;
using System.Security.Cryptography;
using System.Text;

namespace GK.Adaper
    {
   public  class NcHttp {
        //获取Token
       public static string string2MD5()
        {

            //MessageDigest md5 = null;
            MD5 md5 = MD5.Create();         
            //md5 = MessageDigest.getInstance("MD5");           
            //string nowd = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            string nowd = "2020-05-21 17:08:49";
            string instr = "jiangzhaoweifa0f9632-f86a-554e-aecf-94e9bd337ac0"+ nowd;


            byte[] buffer = Encoding.Default.GetBytes(instr);
            //开始加密
            byte[] newBuffer = md5.ComputeHash(buffer);
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < newBuffer.Length; i++)
            {
                sb.Append(newBuffer[i].ToString("x2"));
            }
            string kk = sb.ToString();
            return kk;



            //byte[] strbuffer = Encoding.Default.GetBytes(instr);
            ////加密并返回字节数组
            //string strNew = "";
            //foreach (byte item in strbuffer)
            //{
            ////对字节数组中元素格式化后拼接
            //strNew += item.ToString("x2");
            //               }
            //return strNew;
        }
        //采购订单同步
        static public string Synchronize(string billcode,string orgcode,string beginTime, string endTime) {          
            String url = "http://112.93.131.129:9080/uapws/rest/NCWMSRestResource/NCWMService";
            HttpWebRequest request = WebRequest.Create(url) as HttpWebRequest;
            string nowd = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            string str1= NcHttp.string2MD5();
            request.Timeout = 90500;
            request.Method = "POST";
            request.ContentType = "application/json;charset=UTF-8";//链接类型
            request.KeepAlive = false;             
             byte[] param =  Encoding.UTF8.GetBytes("{\"username\":\"jiangzhaowei\"," +
                  "\"ts\":\"2020-05-21 17:08:49\"," +
                 " \"signToken\":"+"\""+str1+"\""+"," +
                 "\"type\":\"cg\", " +
                 "\"json\":{\"vbillcode\":"+"\""+ billcode +"\""+ "," +
                 "\"person\":[], " +
                 "\"materiel\":[], " +
                 "\"orgcode\":["+ orgcode + "], " +
                 "\"begintime\":"+"\""+ beginTime +"\""+", " +
                 "\"endtime\":"+"\""+ endTime +"\""+ "}} ");
            request.ContentLength = param.Length;
            using (Stream reqStream = request.GetRequestStream())
            {
                reqStream.Write(param, 0, param.Length);
                reqStream.Close();
            }
            string json = "";
            HttpWebResponse response = null;
            long t1 = DateTime.Now.Ticks;
            try {
                response = request.GetResponse() as HttpWebResponse;
            } catch(Exception e) {
             
                return null;
            }
            using(Stream s = response.GetResponseStream()) {
                StreamReader reader = new StreamReader(s,Encoding.UTF8);
                json = reader.ReadToEnd();

            }        
            JObject jsonObject =  JObject.Parse(json); 
            string str= jsonObject.ToString();
            return str;
        }
        //查询销售订单同步
        static public string SalesSynchronize(string billcode, string orgcode, string beginTime, string endTime)
        {
            String url = "http://112.93.131.129:9080/uapws/rest/NCWMSRestResource/NCWMService";
            HttpWebRequest request = WebRequest.Create(url) as HttpWebRequest;
            string nowd = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            string str1 = NcHttp.string2MD5();
            request.Timeout = 90500;
            request.Method = "POST";
            request.ContentType = "application/json;charset=UTF-8";//链接类型
            request.KeepAlive = false;
            byte[] param = Encoding.UTF8.GetBytes("{\"username\":\"jiangzhaowei\"," +
                 "\"ts\":\"2020-05-21 17:08:49\"," +
                " \"signToken\":" + "\"" + str1 + "\"" + "," +
                "\"type\":\"xs\", " +
                "\"json\":{\"vbillcode\":" + "\"" + billcode + "\"" + "," +
                "\"person\":[], " +
                "\"materiel\":[], " +
                "\"orgcode\":[" + orgcode + "], " +
                "\"begintime\":" + "\"" + beginTime + "\"" + ", " +
                "\"endtime\":" + "\"" + endTime + "\"" + "}} ");
            request.ContentLength = param.Length;
            using (Stream reqStream = request.GetRequestStream())
            {
                reqStream.Write(param, 0, param.Length);
                reqStream.Close();
            }
            string json = "";
            HttpWebResponse response = null;
            long t1 = DateTime.Now.Ticks;
            try
            {
                response = request.GetResponse() as HttpWebResponse;
            }
            catch (Exception e)
            {

                return null;
            }
            using (Stream s = response.GetResponseStream())
            {
                StreamReader reader = new StreamReader(s, Encoding.UTF8);
                json = reader.ReadToEnd();

            }
            JObject jsonObject = JObject.Parse(json);
            string str = jsonObject.ToString();
            return str;
        }
        //查询出库订单同步
        static public string ProduceSynchronize(string billcode, string orgcode, string beginTime, string endTime)
        {
            String url = "http://112.93.131.129:9080/uapws/rest/NCWMSRestResource/NCWMService";
            HttpWebRequest request = WebRequest.Create(url) as HttpWebRequest;
            string nowd = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            string str1 = NcHttp.string2MD5();
            request.Timeout = 90500;
            request.Method = "POST";
            request.ContentType = "application/json;charset=UTF-8";//链接类型
            request.KeepAlive = false;
            byte[] param = Encoding.UTF8.GetBytes("{\"username\":\"jiangzhaowei\"," +
                 "\"ts\":\"2020-05-21 17:08:49\"," +
                " \"signToken\":" + "\"" + str1 + "\"" + "," +
                "\"type\":\"ck\", " +
                "\"json\":{\"vbillcode\":" + "\"" + billcode + "\"" + "," +
                "\"person\":[], " +
                "\"materiel\":[], " +
                "\"orgcode\":[" + orgcode + "], " +
                "\"begintime\":" + "\"" + beginTime + "\"" + ", " +
                "\"endtime\":" + "\"" + endTime + "\"" + "}} ");
            request.ContentLength = param.Length;
            using (Stream reqStream = request.GetRequestStream())
            {
                reqStream.Write(param, 0, param.Length);
                reqStream.Close();
            }
            string json = "";
            HttpWebResponse response = null;
            long t1 = DateTime.Now.Ticks;
            try
            {
                response = request.GetResponse() as HttpWebResponse;
            }
            catch (Exception e)
            {

                return null;
            }
            using (Stream s = response.GetResponseStream())
            {
                StreamReader reader = new StreamReader(s, Encoding.UTF8);
                json = reader.ReadToEnd();

            }
            JObject jsonObject = JObject.Parse(json);
            string str = jsonObject.ToString();
            return str;
        }

        //采购入库完成上报
        static public string ReportTask(NCFinishUpload modelUpload)
        {
            String url = "http://112.93.131.129:9080/uapws/rest/NCWMSRestResource/NCWMService";
            HttpWebRequest request = WebRequest.Create(url) as HttpWebRequest;
            request.Timeout = 90500;
            request.Method = "POST";
            request.ContentType = "application/json;charset=UTF-8";//链接类型
            request.KeepAlive = false;
            string a = JsonConvert.SerializeObject(modelUpload);
            byte[] param = Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(modelUpload));
            request.ContentLength = param.Length;
            using (Stream reqStream = request.GetRequestStream())
            {
                reqStream.Write(param, 0, param.Length);
                reqStream.Close();
            }
            string json = "";
            HttpWebResponse response = null;
            try
            {
                response = request.GetResponse() as HttpWebResponse;
            }
            catch (Exception e)
            {
                return null;
            }
            using (Stream s = response.GetResponseStream())
            {
                StreamReader reader = new StreamReader(s, Encoding.UTF8);
                json = reader.ReadToEnd();
            }
            JObject jsonObject = JObject.Parse(json);
            string str = jsonObject.ToString();
            return str;
        }
    }
}
