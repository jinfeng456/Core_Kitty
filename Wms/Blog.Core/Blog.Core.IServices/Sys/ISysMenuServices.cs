	//----------SysMenu开始----------
    

using Blog.Core.IServices.BASE;
using Blog.Core.Model.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Blog.Core.IServices
{
    /// <summary>
    /// SysMenuServices
    /// </summary>	
    public interface ISysMenuServices : IBaseServices<SysMenu>
    {
        Task<List<SysMenu>>  FindTree(string userName, int menuType);
        Task<List<SysMenu>> FindRoleMenus(long roleId);
        Task<List<SysMenu>> FindByUser(string name);
        Task<bool> AddPermission(string[] tableNames = null);
    }
}

	//----------SysMenu结束----------
	