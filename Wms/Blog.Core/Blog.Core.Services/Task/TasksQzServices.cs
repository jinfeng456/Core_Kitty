//-----------------------------------------代码开始--------------------------------------------------------
using System;
using System.Threading.Tasks;
using Blog.Core.Common;
using Blog.Core.IRepository;
using Blog.Core.IRepository.UnitOfWork;
using Blog.Core.IServices;
using Blog.Core.Model.Models;
using Blog.Core.Services.BASE;
namespace Blog.Core.Services
{	
	/// <summary>
	/// TasksQzServices
	/// </summary>	
	public class TasksQzServices : BaseServices<TasksQz>, ITasksQzServices
    {
	
        ITasksQzRepository dal;
        public TasksQzServices(ITasksQzRepository dal)
        {
            this.dal = dal;
            base.BaseDal = dal;
        }
       
    }
}
//----------------------------------------代码结束------------------------------------------------------
