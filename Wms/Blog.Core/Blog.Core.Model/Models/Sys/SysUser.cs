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
		public string name { get; set; }
	
		 /// <summary>
        /// 密码
        /// </summary>
		public string passwords { get; set; }
	
		 /// <summary>
        /// salt
        /// </summary>
		public string salt { get; set; }
	
		 /// <summary>
        /// 电子邮件
        /// </summary>
		public string email { get; set; }
	
		 /// <summary>
        /// 手机
        /// </summary>
		public string mobile { get; set; }
	
		 /// <summary>
        /// 用户状态 1.在用 0.禁用
        /// </summary>
		public byte? userstatus { get; set; }
	
		 /// <summary>
        /// 部门id
        /// </summary>
		public long? deptId { get; set; }
	
		 /// <summary>
        /// 创建人
        /// </summary>
		public string createBy { get; set; }
	
		 /// <summary>
        /// 创建时间
        /// </summary>
		public DateTime? createTime { get; set; }
	
		 /// <summary>
        /// 最后更新人
        /// </summary>
		public string lastUpdateBy { get; set; }
	
		 /// <summary>
        /// 最后更新时间
        /// </summary>
		public DateTime? lastUpdateTime { get; set; }
	
		 /// <summary>
        /// 删除标记 1.已删除 0.未删除
        /// </summary>
		public byte? delFlag { get; set; }
	
		 /// <summary>
        /// 编号
        /// </summary>
		public string code { get; set; }
	
		 /// <summary>
        /// 审核密码
        /// </summary>
		public string auditPassword { get; set; }

		public List<SysUserRole> userRoles;

	}
}	 
