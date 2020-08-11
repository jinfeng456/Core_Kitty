	//----------SysUser开始----------
    


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
	/// SysUserServices
	/// </summary>	
	public class SysUserServices : BaseServices<SysUser>, ISysUserServices
    {
	
        ISysUserRepository dal;
        public SysUserServices(ISysUserRepository dal)
        {
            this.dal = dal;
            base.BaseDal = dal;
        }
       
    }
}

	//----------SysUser结束----------
	