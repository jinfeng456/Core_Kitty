using Common.dto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity.wms
{
    public class WhSoOutDto : PageDto
    {
        public long id { get; set; }
        public string soNo
        {
            get; set;
        }
        public string srcSoBill
        {
            get; set;
        }
        public string customCode
        {
            get; set;
        }
        public string customId
        {
            get; set;
        }
        public string customName
        {
            get; set;
        }
        public string items
        {
            get; set;
        }
        public string status
        {
            get; set;
        }
        public string vbillcode { get; set; }
        public long fromCorpId
        {
            get; set;
        }
    }
}
