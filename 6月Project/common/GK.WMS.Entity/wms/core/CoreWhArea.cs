using GK.Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity.wms
{
    public class CoreWhArea : BaseEntity
    {
        public long  whId
        {
            get; set;
        }
        public string AreaName
        {
            get; set;
        }
        //public string name
        //{
        //    get; set;
        //}
        public long craneId
        {
            get; set;
        }
        public string info
        {
            get; set;
        }
        public string orderNo
        {
            get; set;
        }
        public int locWidth
        {
            get; set;
        }
        public int locHight
        {
            get; set;
        }
        public int locdeep
        {
            get; set;
        }
    }
}
