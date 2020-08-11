	//----------SysDictClass开始----------
    


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
	/// SysDictClassServices
	/// </summary>	
	public class SysDictClassServices : BaseServices<SysDictClass>, ISysDictClassServices
    {
	
        ISysDictClassRepository dal;
        public SysDictClassServices(ISysDictClassRepository dal)
        {
            this.dal = dal;
            base.BaseDal = dal;
        }
       
    }
}

	//----------SysDictClass结束----------
	