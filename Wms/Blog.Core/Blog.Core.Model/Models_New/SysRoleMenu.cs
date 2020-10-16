using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{
	 ///<summary>
	 ///SysRoleMenu
	 ///</summary>
	 [Table("SysRoleMenu")]	
	 public class SysRoleMenu
	 {
	 
		 /// <summary>
        /// ID
        /// </summary>
		[Key]
		[Required]
		public int ID { get; set; }
	
		 /// <summary>
        /// RoleId
        /// </summary>
		public int? RoleId { get; set; }
	
		 /// <summary>
        /// MenuId
        /// </summary>
		public int? MenuId { get; set; }
	
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
	 
	 }
}	 
