using Common.dto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GK.WMS.Entity .dto
{
    public class ReceiptindetailDto : PageDto
    {
        //wms批次号
        public string wmsBanchNo
        {
            get; set;
        }
        //创建时间
        public DateTime createTime
        {
            get; set;
        }
        //单位
        public string packUnit
        {
            get; set;
        }
        //供应商批次号
        public string FromCorpBatchNo
        {
            get; set;
        }
        //供应商名称
        public string FromCorpName
        {
            get; set;
        }
        //规格
        public string packageSpec
        {
            get; set;
        }
        public long soDetailId
        {
            get; set;
        }
    }
}