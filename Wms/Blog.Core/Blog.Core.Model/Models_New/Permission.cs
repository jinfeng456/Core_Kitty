using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{
	 ///<summary>
	 ///Permission
	 ///</summary>
	 [Table("Permission")]	
	 public class Permission
	 {
	 
		 /// <summary>
        /// Id
        /// </summary>
		[Key]
		[Required]
		public int Id { get; set; }
	
		 /// <summary>
        /// Code
        /// </summary>
		public string Code { get; set; }
	
		 /// <summary>
        /// Name
        /// </summary>
		public string Name { get; set; }
	
		 /// <summary>
        /// IsButton
        /// </summary>
		[Required]
		public bool IsButton { get; set; }
	
		 /// <summary>
        /// IsHide
        /// </summary>
		public bool? IsHide { get; set; }
	
		 /// <summary>
        /// IskeepAlive
        /// </summary>
		public bool? IskeepAlive { get; set; }
	
		 /// <summary>
        /// Func
        /// </summary>
		public string Func { get; set; }
	
		 /// <summary>
        /// Pid
        /// </summary>
		[Required]
		public int Pid { get; set; }
	
		 /// <summary>
        /// Mid
        /// </summary>
		[Required]
		public int Mid { get; set; }
	
		 /// <summary>
        /// OrderSort
        /// </summary>
		[Required]
		public int OrderSort { get; set; }
	
		 /// <summary>
        /// Icon
        /// </summary>
		public string Icon { get; set; }
	
		 /// <summary>
        /// Description
        /// </summary>
		public string Description { get; set; }
	
		 /// <summary>
        /// Enabled
        /// </summary>
		[Required]
		public bool Enabled { get; set; }
	
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
	
		 /// <summary>
        /// IsDeleted
        /// </summary>
		public bool? IsDeleted { get; set; }
	 
	 }
}	 
