	//----------SysDictClass开始----------
    

using Blog.Core.Repository.Base;
using Blog.Core.Model.Models;
using Blog.Core.IRepository;
using Blog.Core.IRepository.UnitOfWork;
namespace Blog.Core.Repository
{	
	/// <summary>
	/// SysDictClassRepository
	/// </summary>	
	public class SysDictClassRepository : BaseRepository<SysDictClass>, ISysDictClassRepository
    {
		public SysDictClassRepository(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }
       
    }
}

	//----------SysDictClass结束----------
	