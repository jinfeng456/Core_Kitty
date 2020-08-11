using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Blog.Core.Common.HttpContextUser;
using Blog.Core.IServices;
using Blog.Core.Model;
using Blog.Core.Model.Models;
using Blog.Core.Model.ViewModels;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Blog.Core.Controllers
{
    /// <summary>
    /// 首页
    /// </summary>
    [Produces("application/json")]
    [Route("api/welcome")]
    //[ApiController]
    //[Authorize(Permissions.Name)]
    public class WelComeController : ControllerBase
    {
        readonly ISysRoleServices _sysRoleServices;
        readonly ISysMenuServices _sysMenuServices;
        readonly IUser _user;


        public WelComeController(ISysRoleServices sysRoleServices, ISysMenuServices sysMenuServices,IUser user)
        {
            _sysRoleServices = sysRoleServices;
            _sysMenuServices = sysMenuServices;
            _user = user;
        }

        [HttpGet, Route("data")]
        public BaseResult data()
        {
            return new BaseResult(null);
        }

        [HttpGet, Route("indexData")]
        public BaseResult indexData()  
        {
            List<Message> list = new List<Message>();
            list.Add(new Message("半年未领用", "内容", 100, 1));
            list.Add(new Message("达到预设时效", "内容", 100, 1));
            //Pages<Message> page = new Pages<Message>();
            //page.totalSize = list.Count;
            //page.content = list;
            return BaseResult.Ok(list);
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
    }
}
