using Blog.Core.Model.ViewModels.Base;
using System;

namespace Blog.Core.Model.Models
{
	 ///<summary>
	 ///SysCode
	 ///</summary>
	 public class SysCodeDto : PageDto
	 {
		/// <summary>
        /// TableDescription
        /// </summary>
		public string TableDescription { get; set; }
		/// <summary>
        /// 表名
        /// </summary>
		public string TableName { get; set; }
		/// <summary>
        /// SerialPrefix
        /// </summary>
		public string SerialPrefix { get; set; }
		/// <summary>
        /// BusinessType
        /// </summary>
		public int? BusinessType { get; set; }
		/// <summary>
        /// CodeNumber
        /// </summary>
		public int? CodeNumber { get; set; }
		/// <summary>
        /// CodeDate
        /// </summary>
		public DateTime? CodeDate { get; set; }
	 
	 }
}	 
