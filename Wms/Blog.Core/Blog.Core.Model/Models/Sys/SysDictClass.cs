using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{
	///<summary>
	///SysDictClass
	///</summary>
	[Table("SysDictClass")]	
	 public class SysDictClass : BaseEntity
	{
	 
		 /// <summary>
        /// 字典分类名称
        /// </summary>
		public string DictClassName { get; set; }
	
		 /// <summary>
        /// 字典备注
        /// </summary>
		public string DictRemark { get; set; }
	
		 /// <summary>
        /// 创建人
        /// </summary>
		public string CreateBy { get; set; }
	
		 /// <summary>
        /// 创建时间
        /// </summary>
		public DateTime? CreateTime { get; set; }
	
		 /// <summary>
        /// 最后更新人
        /// </summary>
		public string LastUpdateBy { get; set; }
	
		 /// <summary>
        /// 最后更新时间
        /// </summary>
		public DateTime? LastUpdateTime { get; set; }
	 
	 }
}	 
