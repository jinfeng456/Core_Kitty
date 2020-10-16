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
		public string TableDescription { get; set; }
	
		 /// <summary>
        /// 表名
        /// </summary>
		public string TableName { get; set; }
	
		 /// <summary>
        /// 前缀
        /// </summary>
		public string SerialPrefix { get; set; }
	
		 /// <summary>
        /// 单据类型
        /// </summary>
		public int? BusinessType { get; set; }
	
		 /// <summary>
        /// 数目
        /// </summary>
		public int? CodeNumber { get; set; }
	
		 /// <summary>
        /// 记录当前日期
        /// </summary>
		public DateTime? CodeDate { get; set; }
	 
	 }
}	 
