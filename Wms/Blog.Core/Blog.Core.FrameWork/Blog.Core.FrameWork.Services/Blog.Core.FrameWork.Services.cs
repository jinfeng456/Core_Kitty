





//--------------------------------------------------------------------
//     此代码由T4模板自动生成
//	   生成时间 2020-12-08 13:43:23 
//     对此文件的更改可能会导致不正确的行为，并且如果重新生成代码，这些更改将会丢失。
//--------------------------------------------------------------------
  

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

 

