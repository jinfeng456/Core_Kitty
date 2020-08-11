using System;
using System.Collections.Generic;
using System.Security.Principal;
using System.Web;
using System.Web.Http;
using System.Web.Security;
using HY.WCS.DAL;
using Web.Authorize;
using HY.WCS.DAL.dto;
using WebApi.util;
using GK.WMS.DAL;
using GK.Common.dto;
using GK.WMS.Entity;

namespace WebApi
{
    [FormAuthenticationFilter]
    [RoutePrefix("api/welcome")]
    public class WelcomeController : BaseApiController
    {

        [HttpGet, Route("data")]
        public BaseResult data()
        {
            GenericPrincipal principal = HttpContext.Current.User as GenericPrincipal;
            FormsIdentity identity = (FormsIdentity)principal.Identity;
            FormsAuthenticationTicket ticket = identity.Ticket;
            String userid = ticket.UserData;


            return new BaseResult(null);

        }


        [HttpPost, Route("indexData")]
        public BaseResult indexData([FromBody] UserDto user)
        {
            String name = CookieHelper.LoginName();
            List<Message> list = new List<Message>();
            list.Add(new Message("半年未领用", MessageUtil.GetNoOutMessage(), 100, 1));
            list.Add(new Message("达到预设时效", MessageUtil.GetBatchMessage(), 100, 1));
            //Pages<Message> page = new Pages<Message>();
            //page.totalSize = list.Count;
            //page.content = list;
            return BaseResult.Ok(list);
        }


    }
    public class Message
    {
        public Message(String title, String info, int count, int type)
        {
            this.info = info;
            this.count = count;
            this.type = type;
            this.title = title;
        }
        public String title;
        public String info;
        public int count;
        public int type;
    }

    public class Pages<T>
    {
        /**
		 * 记录总数
		 */
        public long totalSize { get; set; }

        /**
		 * 分页数据
		 */
        public List<T> content { get; set; }
    }
}
