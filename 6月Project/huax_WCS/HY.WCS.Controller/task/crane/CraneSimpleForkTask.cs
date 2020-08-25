
using System.Collections.Generic;
using GK.WCS.Carrier;
using WCS.Carrier;
using WCS.Carrier.dto;
using WCS.Common;
using WCS.Common.task;
using WCS.Crane;
using WCS.Entity;

namespace GK.WCS.Controller
{
    public abstract class CraneSimpleForkTask : CraneAllocateJobHX
    {



        protected CarrierSynchro carrierSynchro = null;
        private int workedPoint = 1;
        CarrierDirection carrierDirectionL = null;
        CarrierDirection carrierDirectionR = null;
        public CraneSimpleForkTask(int id) : base(id)
        {

        }
        protected override void onlyOneTime()
        {
            base.onlyOneTime();
            //carrierSynchro = (CarrierSynchro)TaskPool.get<CarrierSynchro>();
            carrierDirectionL = TaskPool.get<CarrierDirectionL>();
            carrierDirectionR = TaskPool.get<CarrierDirectionR>();
        }
        public override TaskCrane analyseTaskModel(GkCraneStatusBase gcs)
        {

            List<TaskCrane> tcList = craneTaskDAL.getWorkingTask(craneId);
            if (tcList == null)
            {
                return null;
            }
            foreach (TaskCrane crane in tcList)
            {
                if (crane.status != 1 && crane.status != 9 && crane.status != -1)
                    LoggerCommon.fileAll(craneId + "数据库有未完成任务" + crane.taskNo);
                return null;
            }
            relyRemove(tcList);
            carrierRemove(tcList);
            return getNextTask(tcList);
        }


        TaskCrane getNextTask(List<TaskCrane> tcList)
        {
            for (int i = 0; i < 6; i++)
            {
                int key = getNext();
                foreach (TaskCrane tc in tcList)
                {
                    if (tc.toId == key || tc.fromId == key)
                    {
                        return tc;
                    }
                }
            }
            return null;
        }
        public int getNext()
        {
            if (workedPoint > 6)
            {
                workedPoint = 1;
            }
            else
            {
                workedPoint++;
            }
            return workedPoint;
        }


        bool checkCanIN(TaskCrane ft)
        {
            bool isin = false;
            List<int> inList = inPoint();
            foreach (ushort inp in inList)
            {
                CarrierSignalStatus ssIn1 = carrierSynchro.getSignalStatus(inp);
                if ((ssIn1 != null && ft.taskNo == ssIn1.taskNo && ssIn1.arrived == 1))
                {
                    isin = true;
                }
            }
            if (carrierDirectionL.dir == 1)
            {
                int point = inOutPointL();
                CarrierSignalStatus ssIn1 = carrierSynchro.getSignalStatus(point);
                if ((ssIn1 != null && ft.taskNo == ssIn1.taskNo && ssIn1.arrived == 1))
                {
                    isin = true;
                }
            }

            if (carrierDirectionR.dir == 1)
            {
                int point = inOutPointR();
                CarrierSignalStatus ssIn1 = carrierSynchro.getSignalStatus(point);
                if ((ssIn1 != null && ft.taskNo == ssIn1.taskNo && ssIn1.arrived == 1))
                {
                    isin = true;
                }
            }
            return isin;

        }


        public void carrierRemove(List<TaskCrane> allFtList)
        {


            List<int> outList = outPoint();
            List<TaskCrane> removeList = new List<TaskCrane>();
            foreach (TaskCrane ft in allFtList)
            {

                if (ft.taskType == 1)
                {
                    if (!checkCanIN(ft))
                    {
                        removeList.Add(ft);
                    }
                }
                else if (ft.taskType == 2)
                {

                    int p = ft.toId;

                    if (p == inOutPointR() && carrierDirectionR.dir != 2)
                    {
                        removeList.Add(ft);
                        continue;
                    }
                    if (p == inOutPointL() && carrierDirectionL.dir != 2)
                    {
                        removeList.Add(ft);
                        continue;
                    }
                    CarrierSignalStatus ssOut1 = carrierSynchro.getSignalStatus(p);
                    if (ssOut1 == null || ssOut1.taskNo != 0 || ssOut1.free != 1)
                    {
                        removeList.Add(ft);
                    }
                }
            }

            foreach (TaskCrane ft in removeList)
            {
                if (allFtList.Contains(ft))
                {
                    allFtList.Remove(ft);
                }
            }

        }
        public virtual int defoutPoint()
        {
            return 0;
        }
        public abstract List<int> inPoint();
        public abstract List<int> outPoint();
        public abstract int inOutPointL();
        public abstract int inOutPointR();
    }
}