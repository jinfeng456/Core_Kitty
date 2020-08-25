using Common.dto;
using GK.WMS.DAL;
using GK.WMS.Entity;
using HY.WCS.DAL;
using HY.WCS.DAL.dto;
using HY.WCS.Entity.dto;
using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Http;
using System.Web.Http.Cors;
using Web.Authorize;
using WebApi.util;
using WMS.DAL;

namespace WebApi
{
    [FormAuthenticationFilter]

    [RoutePrefix("user")]
    public class UsersController : BaseApiController
    {
        ISysAuthorityServer authorityServer = WMSDalFactray.getDal<ISysAuthorityServer>();

        [HttpGet, Route("info")]
        public BaseResult info()
        {
            String data = " 0";
            return new BaseResult("admin");
        }

        [HttpPost, Route("FindPage")]
        public BaseResult FindPage([FromBody]UserDto dto)
        {
            Page<SysUserQuery> info = authorityServer.QueryUserPage<SysUserQuery>(dto);       
            return  BaseResult.Ok(info);
        }

        [HttpPost, Route("Save"), ControlName("用户保存")]
        public BaseResult Save([FromBody]SysUser user)
        {
            if (user.id == 0)
            {
                return  BaseResult.Ok(authorityServer.AddUser(user));
            }
            else
            {
                if (user.name == "admin")
                {
                    return  BaseResult.Error("超级管理员不允许修改!");
                }
                return  BaseResult.Ok(authorityServer.UpdateUser(user));
            }
        }

        [HttpPost, Route("Delete"), ControlName("用户删除")]
        public BaseResult Delete([FromBody]List<SysUser> userList)
        {
            foreach (var user in userList)
            {
                SysUser sysUser = authorityServer.FindUserById(user.id);
                if (sysUser != null && sysUser.name.Equals("admin"))
                {
                    return  BaseResult.Error("超级管理员不允许删除!");
                }
            }
            return  BaseResult.Ok(authorityServer.DeleteUser(userList));
        }

        [HttpGet, Route("FindPermissions/{name?}")]
        public BaseResult FindPermissions(string name)
        {
            List<string> perms = new List<string>();
            List<SysMenu> sysMenus = authorityServer.FindByUser(name);
            foreach (var sysMenu in sysMenus)
            {
                if (!string.IsNullOrEmpty(sysMenu.perms))
                {
                    perms.Add(sysMenu.perms);
                }
            }
            return  BaseResult.Ok(perms);
        }
        [HttpGet, Route("UpdateUserPassWord/{passWord?}/{oldWord?}")]
        public BaseResult UpdateUserPassWord(string passWord,string oldWord)
        {
            string result= authorityServer.UpdateUserPassWord(passWord,oldWord);
            if (result == "与原始密码不一致")
            {
                return BaseResult.Error("用户密码修改失败，所输入的用户原始密码不正确，请输入正确的原始密码！");
            }
            else
            {
                return BaseResult.Ok(result);
            }
           
        }
        [HttpGet, Route("UpdateCheckPassWord/{passWord?}/{oldWord?}")]
        public BaseResult UpdateCheckPassWord(string passWord, string oldWord)
        {
            string result = authorityServer.UpdateCheckPassWord(passWord, oldWord);
            if (result == "与原始密码不一致")
            {
                return BaseResult.Error("用户密码修改失败，所输入的用户原始密码不正确，请输入正确的原始密码！");
            }
            else
            {
                return BaseResult.Ok(result);
            }

        }
    }
}