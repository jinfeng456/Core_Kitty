using SqlSugar;
using System;
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
		[SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
		public string TableDescription { get; set; }

		/// <summary>
		/// 表名
		/// </summary>
		[SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
		public string TableName { get; set; }

		/// <summary>
		/// 前缀
		/// </summary>
		[SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
		public string SerialPrefix { get; set; }

		/// <summary>
		/// 单据类型
		/// </summary>
		[SugarColumn(ColumnDataType = "int", IsNullable = true)]
		public int? BusinessType { get; set; }

		/// <summary>
		/// 数目
		/// </summary>
		[SugarColumn(ColumnDataType = "int", IsNullable = true)]
		public int? CodeNumber { get; set; }

		/// <summary>
		/// 记录当前日期
		/// </summary>
		[SugarColumn(IsNullable = true)]
		public DateTime? CodeDate { get; set; }
	 }
}	 
