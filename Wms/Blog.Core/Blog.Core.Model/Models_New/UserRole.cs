using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{
	 ///<summary>
	 ///UserRole
	 ///</summary>
	 [Table("UserRole")]	
	 public class UserRole
	 {
	 
		 /// <summary>
        /// Id
        /// </summary>
		[Key]
		[Required]
		public int Id { get; set; }
	
		 /// <summary>
        /// IsDeleted
        /// </summary>
		public bool? IsDeleted { get; set; }
	
		 /// <summary>
        /// UserId
        /// </summary>
		[Required]
		public int UserId { get; set; }
	
		 /// <summary>
        /// RoleId
        /// </summary>
		[Required]
		public int RoleId { get; set; }
	
		 /// <summary>
        /// CreateId
        /// </summary>
		public int? CreateId { get; set; }
	
		 /// <summary>
        /// CreateBy
        /// </summary>
		public string CreateBy { get; set; }
	
		 /// <summary>
        /// CreateTime
        /// </summary>
		public DateTime? CreateTime { get; set; }
	
		 /// <summary>
        /// ModifyId
        /// </summary>
		public int? ModifyId { get; set; }
	
		 /// <summary>
        /// ModifyBy
        /// </summary>
		public string ModifyBy { get; set; }
	
		 /// <summary>
        /// ModifyTime
        /// </summary>
		public DateTime? ModifyTime { get; set; }
	 
	 }
}	 
