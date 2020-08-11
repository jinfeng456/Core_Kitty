
using System.Collections.Generic;

namespace GK.WCS.Controller {

    public class CraneAllocateJobHX8:CraneSimpleForkTask {

        public CraneAllocateJobHX8() : base(8) {

        }

      
        public override List<int> inPoint() {
            List<int> list = new List<int>();
            list.Add(1104);
            list.Add(1369);
            return list;
        }

        public override List<int> outPoint() {//出库口位置
            List<int> list = new List<int>();
            list.Add(1103);
            list.Add(1368);
            return list;
        }
        
        public override int inOutPointL() {
           return 2033;
        }

        public override int inOutPointR() {
           return 2321;
        }
       
    }
}
