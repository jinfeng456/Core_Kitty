	//----------SysRoleMenu开始----------
    

using Blog.Core.IServices.BASE;
using Blog.Core.Model.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Blog.Core.IServices
{
    /// <summary>
    /// SysRoleMenuServices
    /// </summary>	
    public interface ISysRoleMenuServices : IBaseServices<SysRoleMenu>
    {
        Task<int> SaveRoleMenus(List<SysRoleMenu> modelList);
    }
}

	//----------SysRoleMenu结束----------
	