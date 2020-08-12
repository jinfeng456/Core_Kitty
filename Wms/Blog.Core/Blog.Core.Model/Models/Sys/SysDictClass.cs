using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{
	 ///<summary>
	 ///sys_dict_class
	 ///</summary>
	 [Table("sys_dict_class")]	
	 public class SysDictClass : BaseEntity
	{
	 
		 /// <summary>
        /// 字典分类名称
        /// </summary>
		public string dictClassName { get; set; }
	
		 /// <summary>
        /// 字典备注
        /// </summary>
		public string dictRemark { get; set; }
	
		 /// <summary>
        /// 创建人
        /// </summary>
		public string createBy { get; set; }
	
		 /// <summary>
        /// 创建时间
        /// </summary>
		public DateTime? createTime { get; set; }
	
		 /// <summary>
        /// 最后更新人
        /// </summary>
		public string lastUpdateBy { get; set; }
	
		 /// <summary>
        /// 最后更新时间
        /// </summary>
		public DateTime? lastUpdateTime { get; set; }
	 
	 }
}	 