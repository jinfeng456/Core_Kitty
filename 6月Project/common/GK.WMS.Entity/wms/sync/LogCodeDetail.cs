using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GK.WMS.Entity
{
    public class LogCodeDetail
    {
        //同步的实体
        public int? id { get; set; }
        public string taskno { get; set; }
        public string barCode { get; set; }
        public string parentCode { get; set; }
        public string batch { get; set; }
        public DateTime tkdat { get; set; }
        public int levels { get; set; }
        
    }
}