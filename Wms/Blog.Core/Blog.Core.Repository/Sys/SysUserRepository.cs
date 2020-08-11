	//----------SysUser开始----------
    

using Blog.Core.Repository.Base;
using Blog.Core.Model.Models;
using Blog.Core.IRepository;
using Blog.Core.IRepository.UnitOfWork;
namespace Blog.Core.Repository
{	
	/// <summary>
	/// SysUserRepository
	/// </summary>	
	public class SysUserRepository : BaseRepository<SysUser>, ISysUserRepository
    {
		public SysUserRepository(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }
       
    }
}

	//----------SysUser结束----------
	