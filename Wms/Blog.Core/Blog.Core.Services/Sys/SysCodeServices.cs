	//----------SysCode开始----------
    


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
	/// SysCodeServices
	/// </summary>	
	public class SysCodeServices : BaseServices<SysCode>, ISysCodeServices
    {
	
        ISysCodeRepository dal;
        public SysCodeServices(ISysCodeRepository dal)
        {
            this.dal = dal;
            base.BaseDal = dal;
        }
       
    }
}

	//----------SysCode结束----------
	