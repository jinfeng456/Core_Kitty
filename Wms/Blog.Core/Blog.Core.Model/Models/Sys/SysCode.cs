using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{
	///<summary>
	///sysCode
	///</summary>
	[Table("sysCode")]	
	 public class SysCode : BaseEntity
	{
	 	
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
