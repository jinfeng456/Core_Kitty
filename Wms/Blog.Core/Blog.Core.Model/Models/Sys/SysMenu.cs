using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{
	 ///<summary>
	 ///sys_menu
	 ///</summary>
	 [Table("sys_menu")]	
	 public class SysMenu: BaseEntity
	{
	 

		 /// <summary>
        /// 菜单名称
        /// </summary>
		public string name { get; set; }
	
		 /// <summary>
        /// 上级菜单
        /// </summary>
		public int? parentId { get; set; }
	
		 /// <summary>
        /// 菜单URL
        /// </summary>
		public string url { get; set; }
	
		 /// <summary>
        /// 参数类型
        /// </summary>
		public string perms { get; set; }
	
		 /// <summary>
        /// 操作数据 类型 1.添加  2.编辑
        /// </summary>
		public int? dtype { get; set; }
	
		 /// <summary>
        /// 图标
        /// </summary>
		public string icon { get; set; }
	
		 /// <summary>
        /// 排序号
        /// </summary>
		public int orderNum { get; set; }
	
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


		// 非数据库字段
		public string parentName;
		// 非数据库字段
		public int level;
		// 非数据库字段
		public List<SysMenu> children;

	}
}	 
