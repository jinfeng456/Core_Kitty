//----------SysMenu开始----------


using Blog.Core.Repository.Base;
using Blog.Core.IRepository.UnitOfWork;
using Blog.Core.Model.Models.Generate;
using Blog.Core.Services;

namespace Blog.Core.Repository
{
	/// <summary>
	/// SysMenuRepository
	/// </summary>	
	public class TableRepository : BaseRepository<TableName>, ITableRepository
	{
		public TableRepository(IUnitOfWork unitOfWork) : base(unitOfWork)
		{
		}

	}
}

	//----------SysMenu结束----------
	