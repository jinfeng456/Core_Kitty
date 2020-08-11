	//----------SysRole开始----------
    

using Blog.Core.Repository.Base;
using Blog.Core.Model.Models;
using Blog.Core.IRepository;
using Blog.Core.IRepository.UnitOfWork;
namespace Blog.Core.Repository
{	
	/// <summary>
	/// SysRoleRepository
	/// </summary>	
	public class SysRoleRepository : BaseRepository<SysRole>, ISysRoleRepository
    {
		public SysRoleRepository(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }
       
    }
}

	//----------SysRole结束----------
	