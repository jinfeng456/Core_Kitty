	//----------SysDict开始----------
    


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
	/// SysDictServices
	/// </summary>	
	public class SysDictServices : BaseServices<SysDict>, ISysDictServices
    {
	
        ISysDictRepository dal;
        public SysDictServices(ISysDictRepository dal)
        {
            this.dal = dal;
            base.BaseDal = dal;
        }
       
    }
}

	//----------SysDict结束----------
	