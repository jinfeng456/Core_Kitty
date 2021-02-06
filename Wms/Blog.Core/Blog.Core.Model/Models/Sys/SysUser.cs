using SqlSugar;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
namespace Blog.Core.Model.Models
{

	 public class SysUser : BaseEntity
	{
	 

		 /// <summary>
        /// 登录名
        /// </summary>
		//[SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
		public string Name { get; set; }

		/// <summary>
		/// 密码
		/// </summary>
		//[SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
		public string Passwords { get; set; }

		/// <summary>
		/// salt
		/// </summary>
		//[SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
		public string Salt { get; set; }

		/// <summary>
		/// 电子邮件
		/// </summary>
		//[SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
		public string Email { get; set; }

		/// <summary>
		/// 手机
		/// </summary>
		//[SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
		public string Mobile { get; set; }

		/// <summary>
		/// 用户状态 1.在用 0.禁用
		/// </summary>
		//[SugarColumn(ColumnDataType = "tinyint", IsNullable = true)]
		public byte? Userstatus { get; set; }

		/// <summary>
		/// 部门id
		/// </summary>
		//[SugarColumn(ColumnDataType = "bigint", IsNullable = true)]
		public long? DeptId { get; set; }

		/// <summary>
		/// 创建人
		/// </summary>
		//[SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
		public string CreateBy { get; set; }

		/// <summary>
		/// 创建时间
		/// </summary>
		//[SugarColumn(IsNullable = true)]
		public DateTime? CreateTime { get; set; }

		/// <summary>
		/// 最后更新人
		/// </summary>
		//[SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
		public string LastUpdateBy { get; set; }

		/// <summary>
		/// 最后更新时间
		/// </summary>
		//[SugarColumn(IsNullable = true)]
		public DateTime? LastUpdateTime { get; set; }

		/// <summary>
		/// 删除标记 1.已删除 0.未删除
		/// </summary>
		//[SugarColumn(ColumnDataType = "tinyint", IsNullable = true)]
		public byte? DelFlag { get; set; }

		/// <summary>
		/// 编号
		/// </summary>
		//[SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
		public string Code { get; set; }

		/// <summary>
		/// 审核密码
		/// </summary>
		//[SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
		public string AuditPassword { get; set; }

		public List<SysUserRole> UserRoles;

	}
}	 
