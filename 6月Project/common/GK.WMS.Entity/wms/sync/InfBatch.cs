using GK.Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GK.WMS.Entity
{

    public class InfBatch
    {
        public int  id { get; set; }
        public string taskNo { get; set; }
        public string batch { get; set; }
        //同步的实体
        public string matno { get; set; }
        public string mname { get; set; }
        public DateTime producton { get; set; }
        public string spec { get; set; }
        public string packagecascade { get; set; }

       
    }
}