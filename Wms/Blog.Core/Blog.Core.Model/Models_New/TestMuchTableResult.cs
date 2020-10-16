using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{
	 ///<summary>
	 ///TestMuchTableResult
	 ///</summary>
	 [Table("TestMuchTableResult")]	
	 public class TestMuchTableResult
	 {
	 
		 /// <summary>
        /// moduleName
        /// </summary>
		[Required]
		public string moduleName { get; set; }
	
		 /// <summary>
        /// permName
        /// </summary>
		[Required]
		public string permName { get; set; }
	
		 /// <summary>
        /// rid
        /// </summary>
		[Required]
		public int rid { get; set; }
	
		 /// <summary>
        /// mid
        /// </summary>
		[Required]
		public int mid { get; set; }
	
		 /// <summary>
        /// pid
        /// </summary>
		[Required]
		public int pid { get; set; }
	 
	 }
}	 
