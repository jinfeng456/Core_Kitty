using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{
	 ///<summary>
	 ///Topic
	 ///</summary>
	 [Table("Topic")]	
	 public class Topic
	 {
	 
		 /// <summary>
        /// Id
        /// </summary>
		[Key]
		[Required]
		public int Id { get; set; }
	
		 /// <summary>
        /// tLogo
        /// </summary>
		public string tLogo { get; set; }
	
		 /// <summary>
        /// tName
        /// </summary>
		public string tName { get; set; }
	
		 /// <summary>
        /// tDetail
        /// </summary>
		public string tDetail { get; set; }
	
		 /// <summary>
        /// tAuthor
        /// </summary>
		public string tAuthor { get; set; }
	
		 /// <summary>
        /// tSectendDetail
        /// </summary>
		public string tSectendDetail { get; set; }
	
		 /// <summary>
        /// tIsDelete
        /// </summary>
		[Required]
		public bool tIsDelete { get; set; }
	
		 /// <summary>
        /// tRead
        /// </summary>
		[Required]
		public int tRead { get; set; }
	
		 /// <summary>
        /// tCommend
        /// </summary>
		[Required]
		public int tCommend { get; set; }
	
		 /// <summary>
        /// tGood
        /// </summary>
		[Required]
		public int tGood { get; set; }
	
		 /// <summary>
        /// tCreatetime
        /// </summary>
		[Required]
		public DateTime tCreatetime { get; set; }
	
		 /// <summary>
        /// tUpdatetime
        /// </summary>
		[Required]
		public DateTime tUpdatetime { get; set; }
	 
	 }
}	 
