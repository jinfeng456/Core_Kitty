using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{
	 ///<summary>
	 ///PasswordLib
	 ///</summary>
	 [Table("PasswordLib")]	
	 public class PasswordLib
	 {
	 
		 /// <summary>
        /// PLID
        /// </summary>
		[Key]
		[Required]
		public int PLID { get; set; }
	
		 /// <summary>
        /// IsDeleted
        /// </summary>
		public bool? IsDeleted { get; set; }
	
		 /// <summary>
        /// plURL
        /// </summary>
		public string plURL { get; set; }
	
		 /// <summary>
        /// plPWD
        /// </summary>
		public string plPWD { get; set; }
	
		 /// <summary>
        /// plAccountName
        /// </summary>
		public string plAccountName { get; set; }
	
		 /// <summary>
        /// plStatus
        /// </summary>
		public int? plStatus { get; set; }
	
		 /// <summary>
        /// plErrorCount
        /// </summary>
		public int? plErrorCount { get; set; }
	
		 /// <summary>
        /// plHintPwd
        /// </summary>
		public string plHintPwd { get; set; }
	
		 /// <summary>
        /// plHintquestion
        /// </summary>
		public string plHintquestion { get; set; }
	
		 /// <summary>
        /// plCreateTime
        /// </summary>
		public DateTime? plCreateTime { get; set; }
	
		 /// <summary>
        /// plUpdateTime
        /// </summary>
		public DateTime? plUpdateTime { get; set; }
	
		 /// <summary>
        /// plLastErrTime
        /// </summary>
		public DateTime? plLastErrTime { get; set; }
	
		 /// <summary>
        /// test
        /// </summary>
		public string test { get; set; }
	 
	 }
}	 
