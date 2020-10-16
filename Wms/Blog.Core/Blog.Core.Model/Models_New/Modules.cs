using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{
	 ///<summary>
	 ///Modules
	 ///</summary>
	 [Table("Modules")]	
	 public class Modules
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
        /// ParentId
        /// </summary>
		public int? ParentId { get; set; }
	
		 /// <summary>
        /// Name
        /// </summary>
		public string Name { get; set; }
	
		 /// <summary>
        /// LinkUrl
        /// </summary>
		public string LinkUrl { get; set; }
	
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
        /// Icon
        /// </summary>
		public string Icon { get; set; }
	
		 /// <summary>
        /// Code
        /// </summary>
		public string Code { get; set; }
	
		 /// <summary>
        /// OrderSort
        /// </summary>
		[Required]
		public int OrderSort { get; set; }
	
		 /// <summary>
        /// Description
        /// </summary>
		public string Description { get; set; }
	
		 /// <summary>
        /// IsMenu
        /// </summary>
		[Required]
		public bool IsMenu { get; set; }
	
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
	 
	 }
}	 
