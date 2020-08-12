
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace WebApi
{
    public class BaseApiController : ApiController
    {   
        public BaseResult Options() {
            BaseResult baseResult = new BaseResult("不支持的请求方式Options");
            return baseResult;
        }
        public BaseResult Put(int id,[FromBody]string value) {
            BaseResult baseResult = new BaseResult("不支持的请求方式Put");
            return baseResult;
        }

        public BaseResult Delete(int id) {
            BaseResult baseResult = new BaseResult("不支持的请求方式Delete");
            return baseResult;
        }

        virtual public BaseResult Post([FromBody]string value) {
            BaseResult baseResult = new BaseResult("不支持的请求方式Post");
            return baseResult;


        }

    }
}
