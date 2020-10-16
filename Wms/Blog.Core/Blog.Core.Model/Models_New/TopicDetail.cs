using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{
	 ///<summary>
	 ///TopicDetail
	 ///</summary>
	 [Table("TopicDetail")]	
	 public class TopicDetail
	 {
	 
		 /// <summary>
        /// Id
        /// </summary>
		[Key]
		[Required]
		public int Id { get; set; }
	
		 /// <summary>
        /// TopicId
        /// </summary>
		[Required]
		public int TopicId { get; set; }
	
		 /// <summary>
        /// tdLogo
        /// </summary>
		public string tdLogo { get; set; }
	
		 /// <summary>
        /// tdName
        /// </summary>
		public string tdName { get; set; }
	
		 /// <summary>
        /// tdContent
        /// </summary>
		public string tdContent { get; set; }
	
		 /// <summary>
        /// tdDetail
        /// </summary>
		public string tdDetail { get; set; }
	
		 /// <summary>
        /// tdSectendDetail
        /// </summary>
		public string tdSectendDetail { get; set; }
	
		 /// <summary>
        /// tdIsDelete
        /// </summary>
		[Required]
		public bool tdIsDelete { get; set; }
	
		 /// <summary>
        /// tdRead
        /// </summary>
		[Required]
		public int tdRead { get; set; }
	
		 /// <summary>
        /// tdCommend
        /// </summary>
		[Required]
		public int tdCommend { get; set; }
	
		 /// <summary>
        /// tdGood
        /// </summary>
		[Required]
		public int tdGood { get; set; }
	
		 /// <summary>
        /// tdCreatetime
        /// </summary>
		[Required]
		public DateTime tdCreatetime { get; set; }
	
		 /// <summary>
        /// tdUpdatetime
        /// </summary>
		[Required]
		public DateTime tdUpdatetime { get; set; }
	
		 /// <summary>
        /// tdTop
        /// </summary>
		[Required]
		public int tdTop { get; set; }
	
		 /// <summary>
        /// tdAuthor
        /// </summary>
		public string tdAuthor { get; set; }
	 
	 }
}	 
