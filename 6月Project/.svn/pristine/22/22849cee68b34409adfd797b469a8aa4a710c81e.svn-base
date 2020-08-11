using GK.Common.entity;
using GK.Mongon.DAL;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Reflection;
using System.Security.Principal;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;
using System.Web.Security;
using WebApi.util;

namespace WebApi.filter {
   public class LoggerFilter:ActionFilterAttribute {


        private const string Key = "action";
        static List<String> list = new List<String>();
        static   Dictionary<String,String> nameDict=new Dictionary<string, string>();
        static LoggerFilter() {
           
            list.Add("^/menu/findNavTree$");
            list.Add("^/api/file/\\S+");//所有以/log/开头的请求
            list.Add("^/api/dp/\\S+");
            list.Add("^\\S+Page[^/]*$");
            list.Add("^\\S+/find[^/]+$");
            list.Add("^\\S+/get[^/]+$");
            list.Add("^\\S+/Get[^/]+$");
            list.Add("^/log/\\S+");//所有以/log/开头的请求
            list.Add("^/dict/getAllDicts$");
            list.Add("^/item/findAll$");//获取所有字典不用记录
            list.Add("^/user/findPermissions$");//获取所有字典不用记录
            list.Add("^\\S*/indexData$");//获取所有字典不用记录

            nameDict.Add("/dictClass/save","保存字典分类");
            nameDict.Add("/classifyarea/save","保存物料分区");
        }

    


        public override void OnActionExecuted(HttpActionExecutedContext actionExecutedContext) {


           
            // actionContext.ActionArguments;
            HttpRequest request = HttpContext.Current.Request;
            String ip = GetClientIp();
            String url = request.Path;

            foreach(String l in list) {
         
                if(Regex.IsMatch(url,l)) {
                    return;
                }
            }


            
            String info = null;
            if(actionExecutedContext.Response == null) {
                info = actionExecutedContext.Exception.StackTrace;
            } else {
                info = actionExecutedContext.Response.Content.ReadAsStringAsync().Result;
            }
            HttpLog log = new HttpLog();
            String name =null;
            if (nameDict.ContainsKey(url)) {
                   name = nameDict[url];
            }
            ReflectedHttpActionDescriptor rhad= actionExecutedContext.ActionContext.ActionDescriptor as ReflectedHttpActionDescriptor;
            ControlName it =  (ControlName) rhad.MethodInfo.GetCustomAttribute(typeof (ControlName));
            if (it != null) {
                 name=it.Name;
             }
            name=String.IsNullOrWhiteSpace(name)?url:name;
            log.urlName = name;
            log.url = url;
            log.param = getParam( request, actionExecutedContext);
            log.result = info;
            log.user=CookieHelper.LoginName();
            log.ip = ip;
            HttpServerLogUtil.save(log);

        }




        private String getParam(HttpRequest request,HttpActionExecutedContext actionExecutedContext) {
            String query = request.QueryString.ToString();
            String userid = "";
            GenericPrincipal principal = HttpContext.Current.User as GenericPrincipal;
            if(principal != null) {
                FormsIdentity identity = (FormsIdentity)principal.Identity;
                FormsAuthenticationTicket ticket = identity.Ticket;
                userid = ticket.UserData;
            }
            StringBuilder builder = new StringBuilder(query);
            IDictionary<string,object> dic = actionExecutedContext.ActionContext.RequestContext.RouteData.Values;
            JObject obj = body( actionExecutedContext) ;
            foreach(var item in dic) {
                JValue val = new JValue(item.Value.ToString());
                obj.Add(item.Key, val);
            }
            NameValueCollection names = request.Form;

            foreach(String name in names) {
                if(name == "password") {
                    continue;
                }
                obj.Add(name,new JObject(HttpContext.Current.Request[name]));
            }
              
            return obj.ToString();

        }

        JObject body(HttpActionExecutedContext actionExecutedContext) {
            
              var task = actionExecutedContext.Request.Content.ReadAsStreamAsync();
                    var content = string.Empty;
                    using (System.IO.Stream sm = task.Result)
                    {
                        if (sm != null&&sm.Length!=0)
                        {
                            sm.Seek(0, SeekOrigin.Begin);
                            int len = (int) sm.Length;
                            byte[] inputByts = new byte[len];
                            sm.Read(inputByts, 0, len);
                            sm.Close();
                            content = Encoding.UTF8.GetString(inputByts);
                   
                        }
                    }
                    JObject jo = new JObject();
                    if (!String.IsNullOrWhiteSpace(content)) {
                        try {
                            jo = (JObject)JsonConvert.DeserializeObject(content);
                        if(jo["password"]!=null) {
                            jo["password"]="";
                            }
              
                      
                            } catch { }
                    }
                  
          
                  
                    return jo;
        
            }
        private string GetClientIp() {
            string result = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            if(string.IsNullOrEmpty(result)) {
                result = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
            }
            if(string.IsNullOrEmpty(result)) {
                result = HttpContext.Current.Request.UserHostAddress;
            }
            if(string.IsNullOrEmpty(result)) {
                return "0.0.0.0";
            }
            return result;
        }
    }
}
