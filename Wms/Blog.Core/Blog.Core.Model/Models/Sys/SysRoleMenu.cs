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
        public int roleId { get; set; }

        /// <summary>
        /// 菜单id
        /// </summary>
        public int menuId { get; set; }

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
        /// 最后跟新时间
        /// </summary>
        public DateTime? lastUpdateTime { get; set; }

    }
}
