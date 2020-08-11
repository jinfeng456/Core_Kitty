
using System.Collections.Generic;

namespace GK.WCS.Controller {

    public class CraneAllocateJobHX6:CraneSimpleForkTask {

        public CraneAllocateJobHX6() : base(6) {

        }

        public override List<int> inPoint() {
            List<int> list = new List<int>();
            list.Add(1100);
            list.Add(1365);
            return list;
        }

        public override List<int> outPoint() {//出库口位置
            List<int> list = new List<int>();
            list.Add(1099);
            list.Add(1364);
            return list;
        }
        
        public override int inOutPointL() {
           return 2031;
        }

        public override int inOutPointR() {
           return 2319;
        }
       
    }
}
