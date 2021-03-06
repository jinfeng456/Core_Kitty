﻿using GK.Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity
{
    //物料查询
    public class CoreItem : BaseEntity
    {
        //类别
        public long  classifyId
        {
            get; set;
        }
        //public string classifyName
        //{
        //    get; set;
        //}
        //编码
        public string code
        {
            get; set;
        }
        //名称
        public string name
        {
            get; set;
        }
        //是否使用
        public string active
        {
            get; set;
        }
        public int? coreItemType
        {
            get; set;
        }

        public string modelSpecs
        {
            get; set;
        }

        public string packageSpecs
        {
            get; set;
        }
        public int? isSorting
        {
            get; set;
        }
    }
}
