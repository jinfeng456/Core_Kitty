using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{

	 public class SysRole: BaseEntity
	{
	 
	
		 /// <summary>
        /// 角色名称
        /// </summary>
		public string name { get; set; }
	
		 /// <summary>
        /// 备注
        /// </summary>
		public string remark { get; set; }
	
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
	
		 /// <summary>
        /// 删除标记0.未删除 1.删除
        /// </summary>
		public byte? delFlag { get; set; }
	 
	 }
}	 
