//----------SysMenu开始----------
using Blog.Core.IServices.BASE;
using Blog.Core.Model.Models;
using Blog.Core.Model.Models.Generate;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Blog.Core.IServices
{
    /// <summary>
    /// SysMenuServices
    /// </summary>	
    public interface ITableServices : IBaseServices<TableName>
    {
        Task<List<TableName>> FindTables();
    }
}

	//----------SysMenu结束----------
	