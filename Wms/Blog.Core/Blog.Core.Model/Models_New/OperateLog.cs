using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{
	 ///<summary>
	 ///OperateLog
	 ///</summary>
	 [Table("OperateLog")]	
	 public class OperateLog
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
        /// Area
        /// </summary>
		public string Area { get; set; }
	
		 /// <summary>
        /// Controller
        /// </summary>
		public string Controller { get; set; }
	
		 /// <summary>
        /// Action
        /// </summary>
		public string Action { get; set; }
	
		 /// <summary>
        /// IPAddress
        /// </summary>
		public string IPAddress { get; set; }
	
		 /// <summary>
        /// Description
        /// </summary>
		public string Description { get; set; }
	
		 /// <summary>
        /// LogTime
        /// </summary>
		public DateTime? LogTime { get; set; }
	
		 /// <summary>
        /// LoginName
        /// </summary>
		public string LoginName { get; set; }
	
		 /// <summary>
        /// UserId
        /// </summary>
		[Required]
		public int UserId { get; set; }
	 
	 }
}	 
