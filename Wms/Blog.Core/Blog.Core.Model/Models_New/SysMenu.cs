using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{
	 ///<summary>
	 ///SysMenu
	 ///</summary>
	 [Table("SysMenu")]	
	 public class SysMenu
	 {
	 
		 /// <summary>
        /// Id
        /// </summary>
		[Key]
		[Required]
		public int Id { get; set; }
	
		 /// <summary>
        /// Name
        /// </summary>
		public string Name { get; set; }
	
		 /// <summary>
        /// ParentId
        /// </summary>
		public long? ParentId { get; set; }
	
		 /// <summary>
        /// Url
        /// </summary>
		public string Url { get; set; }
	
		 /// <summary>
        /// Perms
        /// </summary>
		public string Perms { get; set; }
	
		 /// <summary>
        /// Dtype
        /// </summary>
		public int? Dtype { get; set; }
	
		 /// <summary>
        /// Icon
        /// </summary>
		public string Icon { get; set; }
	
		 /// <summary>
        /// OrderNum
        /// </summary>
		public int? OrderNum { get; set; }
	
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
        /// DelFlag
        /// </summary>
		public byte? DelFlag { get; set; }
	 
	 }
}	 
