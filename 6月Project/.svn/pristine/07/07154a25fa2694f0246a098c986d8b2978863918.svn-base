using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WebApi
{
    /// <summary>
    /// 数据响应基础类
    /// </summary>
    /// <remarks>被所有业务实体响应类基础</remarks>
    public class PageResult<T>
    {
		/**
		 * 当前页码
		 */
		public int pageNum { get; set; }
		/**
		 * 每页数量
		 */
		public int pageSize { get; set; }
		/**
		 * 记录总数
		 */
		public long totalSize { get; set; }
		/**
		 * 页码总数
		 */
		public int totalPages { get; set; }
		/**
		 * 分页数据
		 */
		public List<T> content { get; set; }

	}
}
