using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{
	 ///<summary>
	 ///CoreItem
	 ///</summary>
	 [Table("CoreItem")]	
	 public class CoreItem
	 {
	 
		 /// <summary>
        /// id
        /// </summary>
		[Key]
		[Required]
		public int id { get; set; }
	
		 /// <summary>
        /// classifyId
        /// </summary>
		public int? classifyId { get; set; }
	
		 /// <summary>
        /// code
        /// </summary>
		public string code { get; set; }
	
		 /// <summary>
        /// name
        /// </summary>
		public string name { get; set; }
	
		 /// <summary>
        /// active
        /// </summary>
		public int? active { get; set; }
	
		 /// <summary>
        /// coreItemType
        /// </summary>
		public int? coreItemType { get; set; }
	
		 /// <summary>
        /// modelSpecs
        /// </summary>
		public string modelSpecs { get; set; }
	
		 /// <summary>
        /// packageSpecs
        /// </summary>
		public string packageSpecs { get; set; }
	 
	 }
}	 
