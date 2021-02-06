using SqlSugar;
using System;
namespace Blog.Core.Model.Models
{

	public class SysUserRole: BaseEntity
	{
		/// <summary>
		/// user_ids
		/// </summary>
		[SugarColumn(ColumnDataType = "bigint", IsNullable = true)]
		public long? UserIds { get; set; }

		/// <summary>
		/// role_id
		/// </summary>
		[SugarColumn(ColumnDataType = "bigint", IsNullable = true)]
		public long? RoleId { get; set; }

		/// <summary>
		/// create_by
		/// </summary>
		[SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
		public string CreateBy { get; set; }

		/// <summary>
		/// create_time
		/// </summary>
		[SugarColumn(IsNullable = true)]
		public DateTime? CreateTime { get; set; }

		/// <summary>
		/// last_update_by
		/// </summary>
		[SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
		public string LastUpdateBy { get; set; }

		/// <summary>
		/// last_update_time
		/// </summary>
		[SugarColumn(IsNullable = true)]
		public DateTime? LastUpdateTime { get; set; }
	 
	 }
}	 
