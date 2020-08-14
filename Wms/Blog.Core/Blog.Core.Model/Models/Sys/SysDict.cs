using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{

    public class SysDict : BaseEntity
    {


        /// <summary>
        /// 字典值
        /// </summary>
        [Required]
        public int? value { get; set; }

        /// <summary>
        /// label
        /// </summary>
        [Required]
        public string label { get; set; }

        /// <summary>
        /// 类型
        /// </summary>
        public string dtype { get; set; }

        /// <summary>
        /// 描述信息
        /// </summary>
        //[Required]
        public string descriptions { get; set; }

        /// <summary>
        /// 排序
        /// </summary>
        [Required]
        public decimal sort { get; set; }

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
        /// 备注
        /// </summary>
        public string remarks { get; set; }

        /// <summary>
        /// 删除标记0.未删除 1.删除
        /// </summary>
        public byte? delFlag { get; set; }

        /// <summary>
        /// 字典分类id
        /// </summary>
        public int? dictClassId { get; set; }

    }
}
