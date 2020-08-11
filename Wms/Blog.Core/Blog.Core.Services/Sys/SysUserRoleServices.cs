	//----------SysUserRole开始----------
    


using System;
using System.Threading.Tasks;
using Blog.Core.Common;
using Blog.Core.IRepository;
using Blog.Core.IRepository.UnitOfWork;
using Blog.Core.IServices;
using Blog.Core.Model.Models;
using Blog.Core.Services.BASE;
namespace Blog.Core.Services
{	
	/// <summary>
	/// SysUserRoleServices
	/// </summary>	
	public class SysUserRoleServices : BaseServices<SysUserRole>, ISysUserRoleServices
    {
	
        ISysUserRoleRepository dal;
        public SysUserRoleServices(ISysUserRoleRepository dal)
        {
            this.dal = dal;
            base.BaseDal = dal;
        }
       
    }
}

	//----------SysUserRole结束----------
	