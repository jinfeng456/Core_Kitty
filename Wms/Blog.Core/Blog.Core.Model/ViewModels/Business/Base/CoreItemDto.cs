﻿using Blog.Core.Model.ViewModels.Base;

namespace Blog.Core.Controllers
{
    public class CoreItemDto : PageDto
    {
        //分类
        public long classifyId { get; set; }
        //编码
        public string code { get; set; }
        //名称
        public string name { get; set; }
        //能否使用
        public int active { get; set; }

        public int coreItemType { get; set; }
        public string modelSpecs { get; set; }

        public string packageSpecs { get; set; }

        //用于导出显示
        public string classifyName { get; set; }
        //用于导出显示
        public string coreItemTypeName { get; set; }
    }
}