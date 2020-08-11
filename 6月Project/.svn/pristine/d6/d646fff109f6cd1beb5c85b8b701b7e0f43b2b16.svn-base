using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Http.Filters;
using System.Web.Security;
using System.Net.Http;
using System.Collections.ObjectModel;
using System.Net.Http.Headers;
using System.Threading;
using System.Security.Principal;
using System.Net;
using System.Text;
using System.Web.Http.Controllers;
using WebApi;

namespace Web.Authorize 
    {
    public class FormAuthenticationFilterAttribute:AuthorizationFilterAttribute {

        public const String cookieName = "ztAuthorization";
        void setCredentials(HttpActionContext actionContext) {
            if(actionContext.Response == null) {
                actionContext.Response = new HttpResponseMessage(HttpStatusCode.OK) ;
            }

            actionContext.Response.Headers.Add("Access-Control-Allow-Credentials","true");//跨域带cookie
            //actionContext.Response.Headers.Add("Access-Control-Allow-Origin","*");//
           

        }
        public override void OnAuthorization(System.Web.Http.Controllers.HttpActionContext actionContext) {
            
            HttpActionDescriptor actionDescriptor = actionContext.ActionDescriptor;
            Collection<AllowAnonymousAttribute> collection = actionDescriptor.GetCustomAttributes<AllowAnonymousAttribute>();
            if(collection.Count > 0) {
                base.OnAuthorization(actionContext);

                setCredentials(actionContext);
                return;
            }
            if(HttpContext.Current.User != null && HttpContext.Current.User.Identity.IsAuthenticated) {
                base.OnAuthorization(actionContext);
                setCredentials(actionContext);
                return;
            }
            IEnumerable<string> list ;
             actionContext.Request.Headers.TryGetValues("token", out list);
            
            if(list == null || list.Count() != 1) {
                BaseResult br = new BaseResult(403,"没有key","Cookie 不存在") ;
                StringContent sc = new StringContent(Json6Helper.SerializeObject(br));
                actionContext.Response = new HttpResponseMessage(HttpStatusCode.OK) { Content = sc };
                  setCredentials(actionContext);
                
                return;
            }
            String cookie = list.ElementAt(0);
            String key = cookie;
            /*
            cookie = cookie.Replace("\r","");
            cookie = cookie.Replace("\n","");
            cookie = cookie.Replace(" ","");
            String[] cookies = cookie.Split(';');

            String key = "";
            foreach(String cooki in cookies) {
                if(cooki.StartsWith(cookieName)) {
                    key = cooki.Split('=')[1];
                }
            }*/
            if (key == "") {
                BaseResult br = new BaseResult(403, "未登入" , cookie);
                StringContent sc = new StringContent(Json6Helper.SerializeObject(br));
                actionContext.Response = new HttpResponseMessage(HttpStatusCode.OK) { Content = sc };
                setCredentials(actionContext);
                return;
           
            }

            //FormsAuthenticationTicket ticket = FormsAuthentication.Decrypt(key);
            //if(ticket == null) {
              
            //    BaseResult br = new BaseResult(50008, "凭证失效","");
            //    StringContent sc = new StringContent(Json6Helper.SerializeObject(br));
            //    actionContext.Response = new HttpResponseMessage(HttpStatusCode.OK) { Content = sc };
            //    setCredentials(actionContext);
            //    return;
            //}
         
            //这里可以对FormsAuthenticationTicket对象进行进一步验证

            //var principal = new GenericPrincipal(new FormsIdentity(ticket),null);
            //HttpContext.Current.User = principal;
            //Thread.CurrentPrincipal = principal;

            base.OnAuthorization(actionContext);
        }

       
    }
}