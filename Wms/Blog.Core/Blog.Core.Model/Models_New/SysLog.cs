using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{
	 ///<summary>
	 ///SysLog
	 ///</summary>
	 [Table("SysLog")]	
	 public class SysLog
	 {
	 
		 /// <summary>
        /// Id
        /// </summary>
		[Key]
		[Required]
		public int Id { get; set; }
	
		 /// <summary>
        /// UsersName
        /// </summary>
		[Required]
		public string UsersName { get; set; }
	
		 /// <summary>
        /// Operation
        /// </summary>
		[Required]
		public string Operation { get; set; }
	
		 /// <summary>
        /// Method
        /// </summary>
		[Required]
		public string Method { get; set; }
	
		 /// <summary>
        /// Params
        /// </summary>
		[Required]
		public string Params { get; set; }
	
		 /// <summary>
        /// Times
        /// </summary>
		[Required]
		public long Times { get; set; }
	
		 /// <summary>
        /// Ip
        /// </summary>
		[Required]
		public string Ip { get; set; }
	
		 /// <summary>
        /// CreateBy
        /// </summary>
		[Required]
		public string CreateBy { get; set; }
	
		 /// <summary>
        /// CreateTime
        /// </summary>
		[Required]
		public DateTime CreateTime { get; set; }
	
		 /// <summary>
        /// LastUpdateBy
        /// </summary>
		[Required]
		public string LastUpdateBy { get; set; }
	
		 /// <summary>
        /// LastUpdateTime
        /// </summary>
		[Required]
		public DateTime LastUpdateTime { get; set; }
	 
	 }
}	 
