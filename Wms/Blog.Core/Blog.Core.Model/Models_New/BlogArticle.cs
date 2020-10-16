using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{
	 ///<summary>
	 ///BlogArticle
	 ///</summary>
	 [Table("BlogArticle")]	
	 public class BlogArticle
	 {
	 
		 /// <summary>
        /// bID
        /// </summary>
		[Key]
		[Required]
		public int bID { get; set; }
	
		 /// <summary>
        /// bsubmitter
        /// </summary>
		public string bsubmitter { get; set; }
	
		 /// <summary>
        /// btitle
        /// </summary>
		public string btitle { get; set; }
	
		 /// <summary>
        /// bcategory
        /// </summary>
		public string bcategory { get; set; }
	
		 /// <summary>
        /// bcontent
        /// </summary>
		public string bcontent { get; set; }
	
		 /// <summary>
        /// btraffic
        /// </summary>
		[Required]
		public int btraffic { get; set; }
	
		 /// <summary>
        /// bcommentNum
        /// </summary>
		[Required]
		public int bcommentNum { get; set; }
	
		 /// <summary>
        /// bUpdateTime
        /// </summary>
		[Required]
		public DateTime bUpdateTime { get; set; }
	
		 /// <summary>
        /// bCreateTime
        /// </summary>
		[Required]
		public DateTime bCreateTime { get; set; }
	
		 /// <summary>
        /// bRemark
        /// </summary>
		public string bRemark { get; set; }
	
		 /// <summary>
        /// IsDeleted
        /// </summary>
		public bool? IsDeleted { get; set; }
	 
	 }
}	 
