

using GK.Engine.WMS.wms;
using GK.WMS.Entity.wms.Device;

namespace GK.WCS.Crane {
    //输送线
    public abstract class CraneSynchroDYG:CraneSynchro {


        public CraneSynchroDYG(int craneId) : base(craneId) {

        }
         protected override  GkCraneStatusBase parse() {
            GkDYGCraneStatus cs = new GkDYGCraneStatus(CraneId,craneStatus );
            cs.stnId = CraneId;
            byte[] statebyte = craneConnect.reader(500,0,40);
            cs.parseStatus(statebyte);
            cs.parseError(statebyte);
            return cs;
        }
        protected override void after(GkCraneStatusBase oldCraneStatus, GkCraneStatusBase cs)
        {
            string errorMsg = string.Empty;
            int status = 0;
            //true异常 false正常
            if (craneStatus == null || cs.isfault() != craneStatus.isfault())
            {
                if (cs.isfault())
                {
                    status = 2;
                }
                else
                {
                    status = 1;
                }
                CraneStatus model = new CraneStatus();
                model.Id = CraneId;
                model.Status = status;
                //修改CraneStatus中状态
                WMSTransactionFacade.doUpdateCraneStatusEngine(model, ref errorMsg);
            }
        }
       
    }
}
