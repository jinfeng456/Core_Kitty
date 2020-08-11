


using System.Collections.Generic;

namespace GK.WCS.Controller {

    public class CraneAllocateJobHX5:CraneSimpleForkTask {

        public CraneAllocateJobHX5() : base(5) {

        }

        public override List<int> inPoint() {
            List<int> list = new List<int>();
            list.Add(1098);
            list.Add(1363);
            return list;
        }

        public override List<int> outPoint() {//出库口位置
            List<int> list = new List<int>();
            list.Add(1097);
            list.Add(1362);
            return list;
        }
        
        public override int inOutPointL() {
           return 2030;
        }

        public override int inOutPointR() {

           return 2318;
       }

    }
}
