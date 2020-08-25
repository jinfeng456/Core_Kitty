using Common.dto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
namespace GK.WMS.Entity
{
	 ///<summary>
	 ///SysCode
	 ///</summary>
	 public class SysCodeDto : PageDto
	 {
	 
		 /// <summary>
        /// 主键
        /// </summary>
		public long id { get; set; }
	
		 /// <summary>
        /// 表描述
        /// </summary>
		public string tableDescription { get; set; }
	
		 /// <summary>
        /// 表名
        /// </summary>
		public string tableName { get; set; }
	
		 /// <summary>
        /// 前缀
        /// </summary>
		public string serialPrefix { get; set; }
	
		 /// <summary>
        /// 单据类型
        /// </summary>
		public int? businessType { get; set; }
	
		 /// <summary>
        /// 数目
        /// </summary>
		public int? codeNumber { get; set; }
	
		 /// <summary>
        /// 记录当前日期
        /// </summary>
		public DateTime? codeDate { get; set; }
	 
	 }
} 

	