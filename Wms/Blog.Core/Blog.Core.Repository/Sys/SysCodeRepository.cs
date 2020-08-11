	//----------SysCode开始----------
    

using Blog.Core.Repository.Base;
using Blog.Core.Model.Models;
using Blog.Core.IRepository;
using Blog.Core.IRepository.UnitOfWork;
namespace Blog.Core.Repository
{	
	/// <summary>
	/// SysCodeRepository
	/// </summary>	
	public class SysCodeRepository : BaseRepository<SysCode>, ISysCodeRepository
    {
		public SysCodeRepository(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }
       
    }
}

	//----------SysCode结束----------
	