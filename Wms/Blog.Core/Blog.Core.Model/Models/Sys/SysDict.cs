using SqlSugar;
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
        [SugarColumn(ColumnDataType = "int", IsNullable = true)]
        public int? Value { get; set; }

        /// <summary>
        /// label
        /// </summary>
        [SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
        public string Label { get; set; }

        /// <summary>
        /// 类型
        /// </summary>
        [SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
        public string Dtype { get; set; }

        /// <summary>
        /// 描述信息
        /// </summary>
        //[Required]
        [SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
        public string Descriptions { get; set; }

        /// <summary>
        /// 排序
        /// </summary>
        [SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
        public decimal Sort { get; set; }

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
        /// 最后更新时间
        /// </summary>
        [SugarColumn(IsNullable = true)]
        public DateTime? LastUpdateTime { get; set; }

        /// <summary>
        /// 备注
        /// </summary>
        [SugarColumn(ColumnDataType = "nvarchar", Length = 500, IsNullable = true)]
        public string Remarks { get; set; }

        /// <summary>
        /// 删除标记0.未删除 1.删除
        /// </summary>
        [SugarColumn(ColumnDataType = "tinyint", IsNullable = true)]
        public byte? DelFlag { get; set; }

        /// <summary>
        /// 字典分类id
        /// </summary>
        [SugarColumn(ColumnDataType = "int", IsNullable = true)]
        public int? DictClassId { get; set; }

    }
}
