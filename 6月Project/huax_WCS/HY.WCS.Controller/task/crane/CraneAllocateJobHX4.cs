


using System.Collections.Generic;

namespace GK.WCS.Controller {

    public class CraneAllocateJobHX4:CraneSimpleForkTask {

        public CraneAllocateJobHX4() : base(4) {

        }

       
        public override List<int> inPoint() {
            List<int> list = new List<int>();
            list.Add(1096);
            list.Add(1361);
            return list;
        }

        public override List<int> outPoint() {//出库口位置
            List<int> list = new List<int>();
            list.Add(1095);
            list.Add(1360);
            return list;
        }

       
        public override int inOutPointL() {
           return 2029;
        }

        public override int inOutPointR() {
           return 2317;
        }
    }
}
