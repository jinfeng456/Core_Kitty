using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WCS.Open
{
   public  class PrintDto
    {
        //规格
        public string modelSpecs
        {
            get; set;
        }
        //物料编码
        public string itemCode
        {
            get; set;
        }
        //内部批号
        public string wmsBanchNo
        {
            get; set;
        }
        //供应商批次号
        public string fromCorpBatchNo
        {
            get; set;
        }
        //物料名称
        public string itemName
        {
            get; set;
        }
        //数量
        public string countDb
        {
            get; set;
        }
        //单位
        public string packUnit
        {
            get; set;
        }
        //有效期
        public string exp
        {
            get; set;
        }
        //NO
        public string barCode
        {
            get; set;
        }
    }
}
