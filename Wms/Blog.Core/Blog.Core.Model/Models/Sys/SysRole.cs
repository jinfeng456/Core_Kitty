using System;
namespace Blog.Core.Model.Models
{

	public class SysRole: BaseEntity
	{
	 
	
		 /// <summary>
        /// 角色名称
        /// </summary>
		public string Name { get; set; }
	
		 /// <summary>
        /// 备注
        /// </summary>
		public string Remark { get; set; }
	
		 /// <summary>
        /// 创建人
        /// </summary>
		public string CreateBy { get; set; }
	
		 /// <summary>
        /// 创建时间
        /// </summary>
		public DateTime? CreateTime { get; set; }
	
		 /// <summary>
        /// 最后更新人
        /// </summary>
		public string LastUpdateBy { get; set; }
	
		 /// <summary>
        /// 最后更新时间
        /// </summary>
		public DateTime? LastUpdateTime { get; set; }
	
		 /// <summary>
        /// 删除标记0.未删除 1.删除
        /// </summary>
		public byte? DelFlag { get; set; }
	 
	 }
}	 
