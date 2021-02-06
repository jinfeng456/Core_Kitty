using SqlSugar;
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
		[SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
		public string Name { get; set; }

		/// <summary>
		/// 上级菜单
		/// </summary>
		[SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
		public int? ParentId { get; set; }

		/// <summary>
		/// 菜单URL
		/// </summary>
		[SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
		public string Url { get; set; }

		/// <summary>
		/// 参数类型
		/// </summary>
		[SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
		public string Perms { get; set; }

		/// <summary>
		/// 操作数据 类型 1.添加  2.编辑
		/// </summary>
		[SugarColumn(ColumnDataType = "int", IsNullable = true)]
		public int? Dtype { get; set; }

		/// <summary>
		/// 图标
		/// </summary>
		[SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
		public string Icon { get; set; }

		/// <summary>
		/// 排序号
		/// </summary>
		[SugarColumn(ColumnDataType = "int", IsNullable = false)]
		public int OrderNum { get; set; }

		/// <summary>
		/// 创建人
		/// </summary>
		[SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
		public string CreateBy { get; set; }

		/// <summary>
		/// 创建时间
		/// </summary>
		[SugarColumn(IsNullable = true)]
		public DateTime? CreateTime { get; set; }

		/// <summary>
		/// 最后更新人
		/// </summary>
		[SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
		public string LastUpdateBy { get; set; }



		/// <summary>
		/// 最后更新时间
		/// </summary>
		[SugarColumn(IsNullable = true)]
		public DateTime? LastUpdateTime { get; set; }

		/// <summary>
		/// 删除标记0.未删除 1.删除
		/// </summary>
		[SugarColumn(ColumnDataType = "tinyint", IsNullable = true)]
		public byte? DelFlag { get; set; }


		// 非数据库字段
		public string ParentName;
		// 非数据库字段
		public int Level;
		// 非数据库字段
		public List<SysMenu> Children;

	}
}	 
