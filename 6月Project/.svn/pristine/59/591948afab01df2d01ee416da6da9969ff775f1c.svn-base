
using System.Collections.Generic;

namespace GK.WCS.Controller{

    public class CraneAllocateJobHX10:CraneSimpleForkTask {

        public CraneAllocateJobHX10() : base(10) {

        }

        
        public override List<int> inPoint() {
            List<int> list = new List<int>();
            list.Add(1108);
            list.Add(1373);
            return list;
        }

        public override List<int> outPoint() {//出库口位置
            List<int> list = new List<int>();
            list.Add(1107);
            list.Add(1372);
            return list;
        }

       
        public override int inOutPointL() {
           return 2035;
        }

        public override int inOutPointR() {
           return 2323;
        }
    }
}
