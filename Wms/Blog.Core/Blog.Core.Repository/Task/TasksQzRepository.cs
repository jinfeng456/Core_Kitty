//-----------------------------------------代码开始--------------------------------------------------------
using Blog.Core.Repository.Base;
using Blog.Core.Model.Models;
using Blog.Core.IRepository;
using Blog.Core.IRepository.UnitOfWork;
namespace Blog.Core.Repository
{	
	/// <summary>
	/// TasksQzRepository
	/// </summary>	
	public class TasksQzRepository : BaseRepository<TasksQz>, ITasksQzRepository
    {
	    public TasksQzRepository(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }
       
    }
}
//----------------------------------------代码结束------------------------------------------------------
