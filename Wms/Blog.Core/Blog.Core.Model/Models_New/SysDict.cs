using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{
	 ///<summary>
	 ///SysDict
	 ///</summary>
	 [Table("SysDict")]	
	 public class SysDict
	 {
	 
		 /// <summary>
        /// Id
        /// </summary>
		[Key]
		[Required]
		public int Id { get; set; }
	
		 /// <summary>
        /// Value
        /// </summary>
		public int? Value { get; set; }
	
		 /// <summary>
        /// Label
        /// </summary>
		public string Label { get; set; }
	
		 /// <summary>
        /// Dtype
        /// </summary>
		public string Dtype { get; set; }
	
		 /// <summary>
        /// Descriptions
        /// </summary>
		public string Descriptions { get; set; }
	
		 /// <summary>
        /// Sort
        /// </summary>
		public decimal? Sort { get; set; }
	
		 /// <summary>
        /// CreateBy
        /// </summary>
		public string CreateBy { get; set; }
	
		 /// <summary>
        /// CreateTime
        /// </summary>
		public DateTime? CreateTime { get; set; }
	
		 /// <summary>
        /// LastUpdateBy
        /// </summary>
		public string LastUpdateBy { get; set; }
	
		 /// <summary>
        /// LastUpdateTime
        /// </summary>
		public DateTime? LastUpdateTime { get; set; }
	
		 /// <summary>
        /// Remarks
        /// </summary>
		public string Remarks { get; set; }
	
		 /// <summary>
        /// DelFlag
        /// </summary>
		public byte? DelFlag { get; set; }
	
		 /// <summary>
        /// DictClassId
        /// </summary>
		public int? DictClassId { get; set; }
	 
	 }
}	 
