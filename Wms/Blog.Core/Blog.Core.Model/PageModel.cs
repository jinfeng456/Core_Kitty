using System.Collections.Generic;

namespace Blog.Core.Model
{
    /// <summary>
    /// 通用分页信息类
    /// </summary>
    public class PageModel<T>
    {
        /// <summary>
        /// 当前页标
        /// </summary>
        public int page { get; set; } = 1;
        /// <summary>
        /// 总页数
        /// </summary>
        public int pageCount { get; set; } = 6;      
        /// <summary>
        /// 每页大小
        /// </summary>
        public int PageSize { set; get; }

        public long totalSize { get; set; }
        public List<T> content { get; set; }

    }

}
