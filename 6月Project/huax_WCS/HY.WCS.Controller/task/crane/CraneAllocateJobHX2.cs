

using System.Collections.Generic;

namespace GK.WCS.Controller  {

    public class CraneAllocateJobHX2:CraneSimpleForkTask {

        public CraneAllocateJobHX2() : base(2) {

        }

       
        public override List<int> inPoint() {
            List<int> list = new List<int>();
            list.Add(1092);
            list.Add(1358);
            return list;
        }

        public override List<int> outPoint() {//出库口位置
            List<int> list = new List<int>();
            list.Add(1091);
            list.Add(1219);
            return list;
        }
        
        public override int inOutPointL() {
           return 2027;
        }

        public override int inOutPointR() {
           return 2210;
        }
    }
}
