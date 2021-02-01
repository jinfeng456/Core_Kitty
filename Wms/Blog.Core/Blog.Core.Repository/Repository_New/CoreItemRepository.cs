using Blog.Core.IRepository;
using Blog.Core.IRepository.UnitOfWork;
using Blog.Core.Model.Models;
using Blog.Core.Repository.Base;

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