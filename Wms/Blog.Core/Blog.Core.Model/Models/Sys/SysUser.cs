using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
namespace Blog.Core.Model.Models
{

	 public class SysUser : BaseEntity
	{
	 

		 /// <summary>
        /// 登录名
        /// </summary>
		[Required]
		public string Name { get; set; }
	
		 /// <summary>
        /// 密码
        /// </summary>
		public string Passwords { get; set; }
	
		 /// <summary>
        /// salt
        /// </summary>
		public string Salt { get; set; }
	
		 /// <summary>
        /// 电子邮件
        /// </summary>
		public string Email { get; set; }
	
		 /// <summary>
        /// 手机
        /// </summary>
		public string Mobile { get; set; }
	
		 /// <summary>
        /// 用户状态 1.在用 0.禁用
        /// </summary>
		public byte? Userstatus { get; set; }
	
		 /// <summary>
        /// 部门id
        /// </summary>
		public long? DeptId { get; set; }
	
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
        /// 删除标记 1.已删除 0.未删除
        /// </summary>
		public byte? DelFlag { get; set; }
	
		 /// <summary>
        /// 编号
        /// </summary>
		public string Code { get; set; }
	
		 /// <summary>
        /// 审核密码
        /// </summary>
		public string AuditPassword { get; set; }

		public List<SysUserRole> UserRoles;

	}
}	 
