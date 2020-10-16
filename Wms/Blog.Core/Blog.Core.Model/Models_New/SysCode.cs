using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{
	 ///<summary>
	 ///SysCode
	 ///</summary>
	 [Table("SysCode")]	
	 public class SysCode
	 {
	 
		 /// <summary>
        /// Id
        /// </summary>
		[Key]
		[Required]
		public int Id { get; set; }
	
		 /// <summary>
        /// TableDescription
        /// </summary>
		public string TableDescription { get; set; }
	
		 /// <summary>
        /// TableName
        /// </summary>
		public string TableName { get; set; }
	
		 /// <summary>
        /// SerialPrefix
        /// </summary>
		public string SerialPrefix { get; set; }
	
		 /// <summary>
        /// BusinessType
        /// </summary>
		public int? BusinessType { get; set; }
	
		 /// <summary>
        /// CodeNumber
        /// </summary>
		public int? CodeNumber { get; set; }
	
		 /// <summary>
        /// CodeDate
        /// </summary>
		public DateTime? CodeDate { get; set; }
	 
	 }
}	 
