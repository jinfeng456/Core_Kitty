using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using Web.job;

namespace Web
{
    public class MvcApplication : System.Web.HttpApplication
    { 
        protected void Application_Start()
        {
   
            GlobalConfiguration.Configure(WebApiConfig.Register);  
            GlobalConfiguration.Configuration.Formatters.XmlFormatter.SupportedMediaTypes.Clear();//删除XML格式 回應 
              HyScheduler.Start();
        }
        protected void Application_BeginRequest(object sender, System.EventArgs e)
        {
            HttpApplication app = sender as HttpApplication;
            HttpContext context = app.Context;
            if (context.Request.HttpMethod.ToUpper() == "OPTIONS") {
                context.Response.StatusCode = 200;
          
                context.Response.End();
            }
        }




    }
}
