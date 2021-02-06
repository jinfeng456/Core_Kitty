using SqlSugar;
using System;
namespace Blog.Core.Model.Models
{

    public class SysRoleMenu : BaseEntity
    {

        /// <summary>
        /// 角色id
        /// </summary>
        [SugarColumn(ColumnDataType = "int", IsNullable = true)]
        public int RoleId { get; set; }

        /// <summary>
        /// 菜单id
        /// </summary>
        [SugarColumn(ColumnDataType = "int", IsNullable = true)]
        public int MenuId { get; set; }

        /// <summary>
        /// 创建人
        /// </summary>
        [SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
        public string CreateBy { get; set; }

        /// <summary>
        /// 创建时间
        /// </summary>
        [SugarColumn(IsNullable = true)]
        public DateTime? CreateTime { get; set; }

        /// <summary>
        /// 最后更新人
        /// </summary>
        [SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
        public string LastUpdateBy { get; set; }

        /// <summary>
        /// 最后跟新时间
        /// </summary>
        [SugarColumn(IsNullable = true)]
        public DateTime? LastUpdateTime { get; set; }

    }
}
