using GK.Common.dto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GK.WMS.Entity .dto
{
    public class CodeInfoDto : PageDto
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
        public string FromCorpBatchNo
        {
            get; set;
        }
        //物料名称
        public string itemName
        {
            get; set;
        }
        //数量
        public int? countDb
        {
            get; set;
        }
        //单位
        public string packUnit
        {
            get; set;
        }
        //有效期
        public DateTime? exp
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