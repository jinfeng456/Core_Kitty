using Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity.wms
{
   public class WhSoOut : BaseEntity
    {
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
        public string status
        {
            get; set;
        }
        public DateTime createDate { get; set; }

        public DateTime finshDate { get; set; }
        public long fromCorpId
        {
            get; set;
        }
    }
}
