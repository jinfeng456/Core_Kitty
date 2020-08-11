


using System.Collections.Generic;

namespace GK.WCS.Controller {

    public class CraneAllocateJobHX11:CraneSimpleForkTask {

        public CraneAllocateJobHX11() : base(11) {

        }

        
        public override List<int> inPoint() {
            List<int> list = new List<int>();
            list.Add(1110);
            list.Add(1375);
            return list;
        }

        public override List<int> outPoint() {//出库口位置
            List<int> list = new List<int>();
            list.Add(1109);
            list.Add(1374);
            return list;
        }

       
        public override int inOutPointL() {
           return 2036;
        }

        public override int inOutPointR() {
           return 2324;
        }
    }
}
