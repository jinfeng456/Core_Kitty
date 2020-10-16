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
        public int? Value { get; set; }

        /// <summary>
        /// label
        /// </summary>
        [Required]
        public string Label { get; set; }

        /// <summary>
        /// 类型
        /// </summary>
        public string Dtype { get; set; }

        /// <summary>
        /// 描述信息
        /// </summary>
        //[Required]
        public string Descriptions { get; set; }

        /// <summary>
        /// 排序
        /// </summary>
        [Required]
        public decimal Sort { get; set; }

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
        /// 备注
        /// </summary>
        public string Remarks { get; set; }

        /// <summary>
        /// 删除标记0.未删除 1.删除
        /// </summary>
        public byte? DelFlag { get; set; }

        /// <summary>
        /// 字典分类id
        /// </summary>
        public int? DictClassId { get; set; }

    }
}
