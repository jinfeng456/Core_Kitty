	//----------SysRoleMenu开始----------
    

using Blog.Core.Repository.Base;
using Blog.Core.Model.Models;
using Blog.Core.IRepository;
using Blog.Core.IRepository.UnitOfWork;
namespace Blog.Core.Repository
{	
	/// <summary>
	/// SysRoleMenuRepository
	/// </summary>	
	public class SysRoleMenuRepository : BaseRepository<SysRoleMenu>, ISysRoleMenuRepository
    {
		public SysRoleMenuRepository(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }
       
    }
}

	//----------SysRoleMenu结束----------
	