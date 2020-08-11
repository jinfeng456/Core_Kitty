using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web;
using System.Web.Http.Filters;
using WebApi;

namespace Web.Filter {
    public class WebApiExceptionFilterAttribution:ExceptionFilterAttribute {
        public override void OnException(HttpActionExecutedContext context) {
            base.OnException(context);
            Exception e = context.Exception;
            if(context.Response == null) {
                context.Response = new HttpResponseMessage(HttpStatusCode.OK);
            }
            BaseResult br = new BaseResult(2,"系统异常",e.StackTrace) ;
            StringContent sc = new StringContent(Json6Helper.SerializeObject(br));
            context.Response.Content = sc;
            context.Response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/json");
            context.Response.Headers.Add("Access-Control-Allow-Credentials","true");//跨域带cookie
            //context.Response.Headers.Add("Access-Control-Allow-Origin","*");//

        }
    }
}