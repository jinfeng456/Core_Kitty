using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{
	 ///<summary>
	 ///sysUserInfo
	 ///</summary>
	 [Table("sysUserInfo")]	
	 public class sysUserInfo
	 {
	 
		 /// <summary>
        /// uID
        /// </summary>
		[Key]
		[Required]
		public int uID { get; set; }
	
		 /// <summary>
        /// uLoginName
        /// </summary>
		public string uLoginName { get; set; }
	
		 /// <summary>
        /// uLoginPWD
        /// </summary>
		public string uLoginPWD { get; set; }
	
		 /// <summary>
        /// uRealName
        /// </summary>
		public string uRealName { get; set; }
	
		 /// <summary>
        /// uStatus
        /// </summary>
		[Required]
		public int uStatus { get; set; }
	
		 /// <summary>
        /// uRemark
        /// </summary>
		public string uRemark { get; set; }
	
		 /// <summary>
        /// uCreateTime
        /// </summary>
		[Required]
		public DateTime uCreateTime { get; set; }
	
		 /// <summary>
        /// uUpdateTime
        /// </summary>
		[Required]
		public DateTime uUpdateTime { get; set; }
	
		 /// <summary>
        /// uLastErrTime
        /// </summary>
		[Required]
		public DateTime uLastErrTime { get; set; }
	
		 /// <summary>
        /// uErrorCount
        /// </summary>
		[Required]
		public int uErrorCount { get; set; }
	
		 /// <summary>
        /// name
        /// </summary>
		public string name { get; set; }
	
		 /// <summary>
        /// sex
        /// </summary>
		public int? sex { get; set; }
	
		 /// <summary>
        /// age
        /// </summary>
		public int? age { get; set; }
	
		 /// <summary>
        /// birth
        /// </summary>
		public DateTime? birth { get; set; }
	
		 /// <summary>
        /// addr
        /// </summary>
		public string addr { get; set; }
	
		 /// <summary>
        /// tdIsDelete
        /// </summary>
		public bool? tdIsDelete { get; set; }
	 
	 }
}	 
