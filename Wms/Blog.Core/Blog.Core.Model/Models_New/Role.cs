using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{
	 ///<summary>
	 ///Role
	 ///</summary>
	 [Table("Role")]	
	 public class Role
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
        /// Name
        /// </summary>
		public string Name { get; set; }
	
		 /// <summary>
        /// Description
        /// </summary>
		public string Description { get; set; }
	
		 /// <summary>
        /// OrderSort
        /// </summary>
		public int? OrderSort { get; set; }
	
		 /// <summary>
        /// Enabled
        /// </summary>
		public bool? Enabled { get; set; }
	
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
