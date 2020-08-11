	//----------SysUserRole开始----------
    

using Blog.Core.Repository.Base;
using Blog.Core.Model.Models;
using Blog.Core.IRepository;
using Blog.Core.IRepository.UnitOfWork;
namespace Blog.Core.Repository
{	
	/// <summary>
	/// SysUserRoleRepository
	/// </summary>	
	public class SysUserRoleRepository : BaseRepository<SysUserRole>, ISysUserRoleRepository
    {
		public SysUserRoleRepository(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }
       
    }
}

	//----------SysUserRole结束----------
	