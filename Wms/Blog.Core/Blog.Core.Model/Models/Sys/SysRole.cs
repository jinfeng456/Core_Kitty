using SqlSugar;
using System;
namespace Blog.Core.Model.Models
{

	public class SysRole: BaseEntity
	{


		/// <summary>
		/// 角色名称
		/// </summary>
		[SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
		public string Name { get; set; }

		/// <summary>
		/// 备注
		/// </summary>
		[SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
		public string Remark { get; set; }

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
	 
	 }
}	 
