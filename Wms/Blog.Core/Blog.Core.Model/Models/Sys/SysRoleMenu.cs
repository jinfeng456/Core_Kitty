using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{

    public class SysRoleMenu : BaseEntity
    {

        /// <summary>
        /// 角色id
        /// </summary>
        public int RoleId { get; set; }

        /// <summary>
        /// 菜单id
        /// </summary>
        public int MenuId { get; set; }

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
        /// 最后跟新时间
        /// </summary>
        public DateTime? LastUpdateTime { get; set; }

    }
}
