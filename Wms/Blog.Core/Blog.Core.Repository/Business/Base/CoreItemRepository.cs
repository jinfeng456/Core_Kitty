	//----------CoreItem开始----------
    

using Blog.Core.Repository.Base;
using Blog.Core.Model.Models;
using Blog.Core.IRepository;
using Blog.Core.IRepository.UnitOfWork;
namespace Blog.Core.Repository
{	
	/// <summary>
	/// CoreItemRepository
	/// </summary>	
	public class CoreItemRepository : BaseRepository<CoreItem>, ICoreItemRepository
    {
		public CoreItemRepository(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }
       
    }
}

	//----------CoreItem结束----------
	