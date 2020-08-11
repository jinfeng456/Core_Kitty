using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{

	 public class SysUserRole: BaseEntity
	{
	 

		 /// <summary>
        /// user_ids
        /// </summary>
		public long? userIds { get; set; }
	
		 /// <summary>
        /// role_id
        /// </summary>
		public long? roleId { get; set; }
	
		 /// <summary>
        /// create_by
        /// </summary>
		public string createBy { get; set; }
	
		 /// <summary>
        /// create_time
        /// </summary>
		public DateTime? createTime { get; set; }
	
		 /// <summary>
        /// last_update_by
        /// </summary>
		public string lastUpdateBy { get; set; }
	
		 /// <summary>
        /// last_update_time
        /// </summary>
		public DateTime? lastUpdateTime { get; set; }
	 
	 }
}	 
