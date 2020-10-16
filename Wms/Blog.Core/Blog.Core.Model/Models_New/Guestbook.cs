using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{
	 ///<summary>
	 ///Guestbook
	 ///</summary>
	 [Table("Guestbook")]	
	 public class Guestbook
	 {
	 
		 /// <summary>
        /// id
        /// </summary>
		[Key]
		[Required]
		public int id { get; set; }
	
		 /// <summary>
        /// blogId
        /// </summary>
		[Required]
		public int blogId { get; set; }
	
		 /// <summary>
        /// createdate
        /// </summary>
		[Required]
		public DateTime createdate { get; set; }
	
		 /// <summary>
        /// username
        /// </summary>
		public string username { get; set; }
	
		 /// <summary>
        /// phone
        /// </summary>
		public string phone { get; set; }
	
		 /// <summary>
        /// QQ
        /// </summary>
		public string QQ { get; set; }
	
		 /// <summary>
        /// body
        /// </summary>
		public string body { get; set; }
	
		 /// <summary>
        /// ip
        /// </summary>
		public string ip { get; set; }
	
		 /// <summary>
        /// isshow
        /// </summary>
		[Required]
		public bool isshow { get; set; }
	 
	 }
}	 
