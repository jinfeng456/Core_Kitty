using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{
	 ///<summary>
	 ///SysRole
	 ///</summary>
	 [Table("SysRole")]	
	 public class SysRole
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
        /// Remark
        /// </summary>
		public string Remark { get; set; }
	
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
