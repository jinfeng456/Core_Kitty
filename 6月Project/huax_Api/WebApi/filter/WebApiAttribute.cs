﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web;
using System.Web.Configuration;
using System.Web.Http;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;
using WebApi;

namespace Web
{ 
    /*
     这是一个AOP的过滤器，在执行WebApi之前，会先进入这里进行过滤，过滤通过的API，才允许调用和执行。
    */
    [AttributeUsage(AttributeTargets.Method | AttributeTargets.Class, Inherited = true, AllowMultiple = true)]
    public class WebApiAttribute : ActionFilterAttribute
    { 
        public override void OnActionExecuting(HttpActionContext actionContext)
        {

         
          
            base.OnActionExecuting(actionContext);
            
        }  
        public override void OnActionExecuted(HttpActionExecutedContext actionExecutedContext)
        {
            if(actionExecutedContext.Response != null) {
                actionExecutedContext.Response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/json");

               actionExecutedContext.Response.Headers.Add("Access-Control-Allow-Credentials","true");//跨域带cookie
                //actionExecutedContext.Response.Headers.Add("Access-Control-Allow-Origin","*");//
            }
            
  
           
            base.OnActionExecuted(actionExecutedContext);
        }
    }
}