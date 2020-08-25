using System.Collections.Generic;
using WCS.Crane;
using WCS.Entity;

namespace GK.WCS.Controller {

    public class CraneAllocateJobHX1:CraneSimpleForkTask {

        public CraneAllocateJobHX1() : base(1) {
            
        }

         public override TaskCrane analyseTaskModel(GkCraneStatusBase gcs){
            TaskCrane tc=new TaskCrane();
       
            tc.taskNo=65536*257+25;
            tc.fromPlcShelf=11;
            tc.fromPlcCol=1;
            tc.fromPlcRow=1;
            tc.toPlcCol=7;
            tc.toPlcRow=4;
            tc.toPlcShelf=21;
            tc.taskType=3;
            return tc;
        }

        public override int inOutPointL() {
           return 2026;
        }

        public override int inOutPointR() {
           return 2209;
        }

        public override List<int> inPoint() {
            List<int> list = new List<int>();
            list.Add(1090);
            list.Add(1357);
            return list;
        }

        public override List<int> outPoint() {//出库口位置
            List<int> list = new List<int>();
            list.Add(1089);
            list.Add(1222);
            return list;
        }

       
    }
}
