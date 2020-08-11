
using System.Collections.Generic;

namespace GK.WCS.Controller {

    public class CraneAllocateJobHX9:CraneSimpleForkTask {

        public CraneAllocateJobHX9() : base(9) {

        }

       
        public override List<int> inPoint() {
            List<int> list = new List<int>();
            list.Add(1106);
            list.Add(1371);
            return list;
        }

        public override List<int> outPoint() {//出库口位置
            List<int> list = new List<int>();
            list.Add(1105);
            list.Add(1370);
            return list;
        }
        
        public override int inOutPointL() {
           return 2034;
        }

        public override int inOutPointR() {
           return 2322;
        }
       
    }
}
