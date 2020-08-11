	//----------SysRole开始----------
    

using Blog.Core.IServices.BASE;
using Blog.Core.Model.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Blog.Core.IServices
{
    /// <summary>
    /// SysRoleServices
    /// </summary>	
    public interface ISysRoleServices : IBaseServices<SysRole>
    {
        Task<List<SysRole>> FindUserRole(long userId);
    }
}

	//----------SysRole结束----------
	