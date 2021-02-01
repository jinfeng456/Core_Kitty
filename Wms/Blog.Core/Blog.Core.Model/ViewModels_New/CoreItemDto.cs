using System;
using System.Linq;
using System.Text;
using SqlSugar;


namespace Blog.Core.Model.ViewModels
{
    ///<summary>
    ///物料信息表
    ///</summary>
    public class CoreItemDto
    {
                   //主键
           [SugarColumn(IsPrimaryKey=true)]
           public int id { get; set; }
           //物料类别
           public int? classifyId { get; set; }
           //物料编码
           public string code { get; set; }
           //物料名称
           public string name { get; set; }
           //是否启用
           public int? active { get; set; }
           //物料类型
           public int? coreItemType { get; set; }
           //物料规格
           public string modelSpecs { get; set; }
           //包装规格
           public string packageSpecs { get; set; }
    }
}