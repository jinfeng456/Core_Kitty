using Blog.Core.IRepository;
using Blog.Core.IRepository.UnitOfWork;
using Blog.Core.Model.Models;
using Blog.Core.Repository.Base;

namespace Blog.Core.Repository
{
	/// <summary>
	/// OperateLogRepository
	/// </summary>
    public class OperateLogRepository : BaseRepository<OperateLog>, IOperateLogRepository
    {
        public OperateLogRepository(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }
    }
}