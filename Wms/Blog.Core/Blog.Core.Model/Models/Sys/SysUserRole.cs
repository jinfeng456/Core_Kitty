using System;
namespace Blog.Core.Model.Models
{

	public class SysUserRole: BaseEntity
	{
		 /// <summary>
        /// user_ids
        /// </summary>
		public long? UserIds { get; set; }
	
		 /// <summary>
        /// role_id
        /// </summary>
		public long? RoleId { get; set; }
	
		 /// <summary>
        /// create_by
        /// </summary>
		public string CreateBy { get; set; }
	
		 /// <summary>
        /// create_time
        /// </summary>
		public DateTime? CreateTime { get; set; }
	
		 /// <summary>
        /// last_update_by
        /// </summary>
		public string LastUpdateBy { get; set; }
	
		 /// <summary>
        /// last_update_time
        /// </summary>
		public DateTime? LastUpdateTime { get; set; }
	 
	 }
}	 
