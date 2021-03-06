﻿using Common;
using GK.WMS.DAL;
using GK.WMS.Entity;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web;
using System.Web.Http;
using System.Web.Security;
using Web.Authorize;
using WebApi.util;
using WMS.DAL;

namespace WebApi
{
    //[RoutePrefix("api")]
    public class LoginController : BaseApiController
    {
        ISysAuthorityServer authorityServer = WMSDalFactray.getDal<ISysAuthorityServer>();

        [HttpPost, Route("login/{name}")]
        public BaseResult login(String name, [FromBody]SysUser user)
        {
            String data = " 0";
            string password2 = HttpContext.Current.Request["password"];
            string password = GKMD5.MD5Encrypt(user.passwords);

            List<SysUser> userList = authorityServer.GetUser(name, password);

            if (userList.Count > 0)
            {
                data = userList[0].id.ToString();
                FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(0, FormAuthenticationFilterAttribute.cookieName, DateTime.Now,
                                DateTime.Now.AddHours(1), true, data, FormsAuthentication.FormsCookiePath);
                //返回登录结果、用户信息、用户验证票据信息
                String Ticket = FormsAuthentication.Encrypt(ticket);
                return new BaseResult(Ticket);
                //存储为cookie
                //HttpCookie cookie = new HttpCookie(FormAuthenticationFilterAttribute.cookieName,Ticket);
                // cookie.Path = FormsAuthentication.FormsCookiePath;
                // HttpContext.Current.Response.AppendCookie(cookie);


            }
            return new BaseResult("");
        }


        [HttpPost, Route("login"), ControlName("登录操作")]
        public BaseResult login([FromBody] UserDto user)
        {
            List<SysUser> listByName = authorityServer.GetUser(user.account);
            if (listByName == null || listByName.Count == 0)
            {
                return BaseResult.Error("账号不存在！");
            }
            List<SysUser> listByNamePwd = authorityServer.GetUser(user.account, GKMD5.MD5Encrypt(user.password));
            if (listByNamePwd == null || listByNamePwd.Count == 0)
            {
                return BaseResult.Error("密码不正确！");
            }
            if (listByName[0].userstatus == 0)
            {
                return BaseResult.Error("账号已锁定！");
            }
            AuthenticatioToken token = new AuthenticatioToken();
            String name =user.account;
         
            token.token = byteMargin((DateTime.Now.Ticks+""),name);
            return BaseResult.Ok(token);
        }

        String  byteMargin(String str1,String str2) {
       
            str1=str1 .Substring(0,15);
            byte[] time =System.Text.Encoding.Default.GetBytes (str1);

            byte[] byteArray = System.Text.Encoding.UTF8.GetBytes (str2);

            byte[] res=new byte[time.Length+byteArray.Length];
            int indexer1 =0;
            int indexer2 =0;
            for(int i = 0;i < res.Length;i++) {
                if (i % 2 == 0) {//0
                    if (indexer1 == time.Length) {//时间结束了
                        res[i]=byteArray[indexer2++];
                    } else {
                        res[i]=time[indexer1++];
                    }
                } else {
                    if (indexer2 == byteArray.Length) {//用户名结束
                        res[i]=time[indexer1++];
                    } else {
                         res[i]=byteArray[indexer2++];
                    }
                }
            }
            string  pic = Convert.ToBase64String(res);
            return pic;
        }


      
        [HttpPost, Route("logout"),ControlName("登出操作")]
        public BaseResult logout([FromBody] UserDto user)
        {

            return BaseResult.Ok("");
        }








    }


}
