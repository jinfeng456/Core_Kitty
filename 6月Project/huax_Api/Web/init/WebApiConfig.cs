using System.Web.Http;
using Newtonsoft.Json.Serialization;
using System.Web.Http.Dispatcher;
using System.Collections.Generic;
using System.Reflection;
using Web.Authorize;
using System.Web.Http.Routing;
using System.Web.Routing;
using System.Web.Http.Cors;
using System.Web.Http.WebHost;
using System.Web.SessionState;
using System.Web;
using Web.Filter;
using WebApi.filter;
using System.Configuration;

namespace Web
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            #region 跨域配置
            //
            //config.EnableCors(new EnableCorsAttribute("http://localhost,http://127.0.0.1,http://192.168.111.100", "*", "*"));
            // config.EnableCors(new EnableCorsAttribute("*", "*", "*"));

            #endregion 
            // 干掉XML序列化器
            //config.Formatters.Remove(config.Formatters.XmlFormatter);
            config.Filters.Add(new WebApiAttribute());
            // 解决json序列化时的循环引用问题
            config.Formatters.JsonFormatter.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore;
            config.Formatters.JsonFormatter.SerializerSettings.DateFormatString = "yyyy-MM-dd HH:mm:ss";
            // 对 JSON 数据使用混合大小写。驼峰式,但是是javascript 首字母小写形式.
            config.Formatters.JsonFormatter.SerializerSettings.ContractResolver = new  CamelCasePropertyNamesContractResolver();
            // 对 JSON 数据使用混合大小写。跟属性名同样的大小.输出
            //config.Formatters.JsonFormatter.SerializerSettings.ContractResolver = new DefaultContractResolver();

            // Web API 路由
            config.MapHttpAttributeRoutes();
            /*
            RouteTable.Routes.MapHttpRoute(
              name: "DefaultApi",
              routeTemplate: "json/{controller}/{id}",
              defaults: new {
                  id = RouteParameter.Optional
              }

              ).RouteHandler = new SessionControllerRouteHandler();
            ;
            foreach(Route rb in RouteTable.Routes) {
                rb.RouteHandler = new SessionControllerRouteHandler();
            }*/

            //config.Services.Replace(typeof(IAssembliesResolver), new ExtendedDefaultAssembliesResolver());

            // 取消注释下面的代码行可对具有 IQueryable 或 IQueryable<T> 返回类型的操作启用查询支持。
            // 若要避免处理意外查询或恶意查询，请使用 QueryableAttribute 上的验证设置来验证传入查询。
            // 有关详细信息，请访问 http://go.microsoft.com/fwlink/?LinkId=279712。
            //config.EnableQuerySupport();

            // 若要在应用程序中禁用跟踪，请注释掉或删除以下代码行
            // 有关详细信息，请参阅: http://www.asp.net/web-api
            //config.EnableSystemDiagnosticsTracing();

            GlobalConfiguration.Configuration.Filters.Add(new WebApiExceptionFilterAttribution());

            GlobalConfiguration.Configuration.Filters.Add(new LoggerFilter());
            

        }
    }


    public class ExtendedDefaultAssembliesResolver : DefaultAssembliesResolver
    {
        public override ICollection<Assembly> GetAssemblies()
        {
            //Assembly a = typeof(LoginController).Assembly;
            //AssemblyName assemblyName = a.GetName();
            //if (!AppDomain.CurrentDomain.GetAssemblies().Any(assembly => AssemblyName.ReferenceMatchesDefinition(assembly.GetName(), assemblyName)))
            //{
            //    AppDomain.CurrentDomain.Load(assemblyName);
            //}

            return base.GetAssemblies();
        }
    }



    public class SessionRouteHandler:HttpControllerHandler, IRequiresSessionState {
        public SessionRouteHandler(RouteData routeData)
            : base(routeData) {
        }
    }
    public class SessionControllerRouteHandler:HttpControllerRouteHandler {
        protected override IHttpHandler GetHttpHandler(RequestContext requestContext) {
            return new SessionRouteHandler(requestContext.RouteData);
        }
    }
}
