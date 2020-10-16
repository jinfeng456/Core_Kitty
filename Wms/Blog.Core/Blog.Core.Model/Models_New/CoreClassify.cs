using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{
	 ///<summary>
	 ///CoreClassify
	 ///</summary>
	 [Table("CoreClassify")]	
	 public class CoreClassify
	 {
	 
		 /// <summary>
        /// id
        /// </summary>
		[Key]
		[Required]
		public long id { get; set; }
	
		 /// <summary>
        /// name
        /// </summary>
		public string name { get; set; }
	
		 /// <summary>
        /// info
        /// </summary>
		public string info { get; set; }
	
		 /// <summary>
        /// stockWidth
        /// </summary>
		public int? stockWidth { get; set; }
	
		 /// <summary>
        /// stockHigh
        /// </summary>
		public int? stockHigh { get; set; }
	
		 /// <summary>
        /// stockDeep
        /// </summary>
		public int? stockDeep { get; set; }
	 
	 }
}	 
