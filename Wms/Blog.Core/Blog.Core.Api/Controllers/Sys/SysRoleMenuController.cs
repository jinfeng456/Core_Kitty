using System.Collections.Generic;
using System.Threading.Tasks;
using Blog.Core.Common.HttpContextUser;
using Blog.Core.IServices;
using Blog.Core.Model;
using Blog.Core.Model.Models;
using Microsoft.AspNetCore.Mvc;

namespace Blog.Core.Controllers
{
    /// <summary>
    /// 菜单管理
    /// </summary>
    [Route("role")]
    //[ApiController]
    //[Authorize(Permissions.Name)]
    public class SysRoleMenuController : ControllerBase
    {
        readonly ISysRoleMenuServices _sysRoleMenuServices;
        readonly ISysMenuServices _sysMenuServices;
        readonly IUser _user;


        public SysRoleMenuController(ISysRoleMenuServices sysRoleMenuServices, ISysMenuServices sysMenuServices,IUser user)
        {
            _sysRoleMenuServices = sysRoleMenuServices;
            _sysMenuServices = sysMenuServices;
            _user = user;
        }

        [HttpPost, Route("SaveRoleMenus")]
        public async Task<BaseResult> SaveRoleMenus([FromBody]List<SysRoleMenu> modelList)
        {          
            return BaseResult.Ok(await _sysRoleMenuServices.SaveRoleMenus(modelList));
        }
    }
}
