using Blog.Core.Model.ViewModels.Base;

namespace Blog.Core.Model.ViewModels
{
    public class CoreItemDto : PageDto
    {
        public int? id { get; set; }
        //分类
        public int? classifyId { get; set; }
        //编码
        public string code { get; set; }
        //名称
        public string name { get; set; }
        //能否使用
        public int? active { get; set; }

        public int? coreItemType { get; set; }
        public string modelSpecs { get; set; }

        public string packageSpecs { get; set; }

        //用于导出显示
        public string classifyName { get; set; }
        //用于导出显示
        public string coreItemTypeName { get; set; }

        public string info { get; set; }
    }
}