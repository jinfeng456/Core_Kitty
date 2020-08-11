using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{
	 ///<summary>
	 ///CoreItem
	 ///</summary>
	 [Table("CoreItem")]	
	 public class CoreItem: BaseEntity
	{
	 
	
		 /// <summary>
        /// ClassifyId
        /// </summary>
		[Required]
		public int classifyId { get; set; }
	
		 /// <summary>
        /// Code
        /// </summary>
		public string code { get; set; }
	
		 /// <summary>
        /// Name
        /// </summary>
		public string name { get; set; }
	
		 /// <summary>
        /// Active
        /// </summary>
		public int? active { get; set; }
	
		 /// <summary>
        /// Type
        /// </summary>
		public int? type { get; set; }
	
		 /// <summary>
        /// CoreItemType
        /// </summary>
		public int? coreItemType { get; set; }
	
		 /// <summary>
        /// ModelSpecs
        /// </summary>
		public string modelSpecs { get; set; }
	
		 /// <summary>
        /// PackageSpecs
        /// </summary>
		public string packageSpecs { get; set; }
	 
	 }
}	 
