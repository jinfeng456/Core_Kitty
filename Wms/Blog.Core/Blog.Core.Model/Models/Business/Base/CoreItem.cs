using SqlSugar;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{
	 ///<summary>
	 ///CoreItem
	 ///</summary>
	 [Table("CoreItem")]	
	 public class CoreItem: BaseEntity
	{

		/// <summary>
		/// ClassifyId
		/// </summary>
		[SugarColumn(ColumnDataType = "int", IsNullable = true)]
		public int? classifyId { get; set; }

		/// <summary>
		/// Code
		/// </summary>
		[SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
		public string code { get; set; }

		/// <summary>
		/// Name
		/// </summary>
		[SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
		public string name { get; set; }

		/// <summary>
		/// Active
		/// </summary>
		[SugarColumn(ColumnDataType = "int", IsNullable = true)]
		public int? active { get; set; }

		/// <summary>
		/// Type
		/// </summary>	
		/// <summary>
		/// CoreItemType
		/// </summary>
		[SugarColumn(ColumnDataType = "int", IsNullable = true)]
		public int? coreItemType { get; set; }

		/// <summary>
		/// ModelSpecs
		/// </summary>
		[SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
		public string modelSpecs { get; set; }

		/// <summary>
		/// PackageSpecs
		/// </summary>
		[SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
		public string packageSpecs { get; set; }
	 
	 }
}	 
