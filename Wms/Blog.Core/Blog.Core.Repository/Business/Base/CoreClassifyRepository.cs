using Blog.Core.IRepository;
using Blog.Core.IRepository.UnitOfWork;
using Blog.Core.Model.Models;
using Blog.Core.Repository.Base;

namespace Blog.Core.Repository
{
	/// <summary>
	/// CoreClassifyRepository
	/// </summary>
    public class CoreClassifyRepository : BaseRepository<CoreClassify>, ICoreClassifyRepository
    {
        public CoreClassifyRepository(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }
    }
}