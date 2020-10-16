using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{
	 ///<summary>
	 ///SysUser
	 ///</summary>
	 [Table("SysUser")]	
	 public class SysUser
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
        /// Passwords
        /// </summary>
		public string Passwords { get; set; }
	
		 /// <summary>
        /// Salt
        /// </summary>
		public string Salt { get; set; }
	
		 /// <summary>
        /// Email
        /// </summary>
		public string Email { get; set; }
	
		 /// <summary>
        /// Mobile
        /// </summary>
		public string Mobile { get; set; }
	
		 /// <summary>
        /// Userstatus
        /// </summary>
		public byte? Userstatus { get; set; }
	
		 /// <summary>
        /// DeptId
        /// </summary>
		public long? DeptId { get; set; }
	
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
	
		 /// <summary>
        /// Code
        /// </summary>
		public string Code { get; set; }
	
		 /// <summary>
        /// AuditPassword
        /// </summary>
		public string AuditPassword { get; set; }
	 
	 }
}	 
