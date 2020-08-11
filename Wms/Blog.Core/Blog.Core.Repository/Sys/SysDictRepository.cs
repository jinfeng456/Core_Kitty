	//----------SysDict开始----------
    

using Blog.Core.Repository.Base;
using Blog.Core.Model.Models;
using Blog.Core.IRepository;
using Blog.Core.IRepository.UnitOfWork;
namespace Blog.Core.Repository
{	
	/// <summary>
	/// SysDictRepository
	/// </summary>	
	public class SysDictRepository : BaseRepository<SysDict>, ISysDictRepository
    {
		public SysDictRepository(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }
       
    }
}

	//----------SysDict结束----------
	