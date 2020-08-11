
using System.Collections.Generic;

namespace GK.WCS.Controller {

    public class CraneAllocateJobHX7:CraneSimpleForkTask {

        public CraneAllocateJobHX7() : base(7) {

        }

      
        public override List<int> inPoint() {
            List<int> list = new List<int>();
            list.Add(1102);
            list.Add(1367);
            return list;
        }

        public override List<int> outPoint() {//出库口位置
            List<int> list = new List<int>();
            list.Add(1101);
            list.Add(1366);
            return list;
        }
        
        public override int inOutPointL() {
           return 2032;
        }

        public override int inOutPointR() {
           return 2320;
        }
       
    }
}
