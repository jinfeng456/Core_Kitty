	//----------SysMenu开始----------
    

using Blog.Core.Repository.Base;
using Blog.Core.Model.Models;
using Blog.Core.IRepository;
using Blog.Core.IRepository.UnitOfWork;
namespace Blog.Core.Repository
{	
	/// <summary>
	/// SysMenuRepository
	/// </summary>	
	public class SysMenuRepository : BaseRepository<SysMenu>, ISysMenuRepository
    {
		public SysMenuRepository(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }
       
    }
}

	//----------SysMenu结束----------
	