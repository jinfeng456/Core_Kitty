using GK.WCS.Carrier.dto;
using GK.WCS.Common;
using GK.WCS.Common.task;
using GK.WCS.DAL;
using GK.WCS.DAL.inter;
using GK.WCS.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WCS.Carrier {
    public class CarrierDirection:ZtTask {
        ITaskCarrierServer taskCarrierServer = ServerFactray.getServer<ITaskCarrierServer>();
        ITaskCraneServer taskCraneServer = ServerFactray.getServer<ITaskCraneServer>();
        ITaskCompleteServer taskCompleteServer = ServerFactray.getServer<ITaskCompleteServer>();
        IDeviceInOrOutServer deviceInOrOutServer = ServerFactray.getServer<IDeviceInOrOutServer>();
        CarrierConnect connectLeft = TaskPool.get<CarrierConnect>(4);
        CarrierConnect connectRight1 = TaskPool.get<CarrierConnect>(5);
        CarrierConnect connectRight2 = TaskPool.get<CarrierConnect>(6);
        CarrierSynchro carrierSynchro = TaskPool.get<CarrierSynchro>();
        public static int dirL;
        static int carrierContr1 = 1;


        static public bool canIn()
        {
            if (carrierContr1 != 1)
            {
                return false;
            }
            return dirL == 1;


        }
        static public bool canOut()
        {
            if (carrierContr1 != 1)
            {
                return false;
            }
            return dirL == 2;


        }
        public override void excute() {
            int LeftMode1 = deviceInOrOutServer.GetInOrNot(4);
            //int RightModel1 = deviceInOrOutServer.GetInOrNot(5);
            ReadDir();
            LoggerCommon.fileAll("当前输送线方向：" + dirL);

            List<TaskCrane> taskCranes = taskCraneServer.getWorkingCraneTask();
            List<TaskCarrier> taskCarriers = taskCarrierServer.getWorkingCarrierTask();
            bool isIn = false;
            bool isOut = false;
            foreach (TaskCrane ct in taskCranes)
            {
                if (ct.taskType == 1)
                {
                    isIn = true;
                }
                else if (ct.taskType == 2)
                {
                    isOut = true;

                }
                if (isIn && isOut)
                {
                    break;
                }
            }
            foreach (TaskCarrier ct in taskCarriers)
            {
                if (ct.taskType == 1)
                {

                    isIn = true;
                }
                else if (ct.taskType == 2)
                {

                    isOut = true;
                }
                if (isIn && isOut)
                {
                    break;
                }
            }
            CarrierSignalStatus carrierSignalStatus1 = carrierSynchro.getSignalStatus(1);
            if (carrierSignalStatus1 == null)
            {
                return;
            }
            if (carrierSignalStatus1.free != 0)//需要入库
            {
                isIn = true;
            }

            if (isOut && isIn)
            {//口没有被取走 或者 刚刚放上去 即既有入库有用出口 这不变
                return;
            }

            changeDirL(isIn, isOut, LeftMode1);
        }
        public void ReadDir() {
            dirL = connectLeft.getCarrierDir(4);
        }
        public void changeDirL(bool neadIn, bool neadOut, int carrierMode) {
            if (CheckIsChange(223)) 
            {
                if (dirL == 1)//入库
                {
                    connectLeft.changeCarrierDir(4,2);//改为出库
                }
            } else 
            {
                if (dirL == 2) 
                {
                    connectLeft.changeCarrierDir(4,1);//改为入库
                }
            }
        }

        private bool CheckIsChange(int point)
        {
            CarrierSignalStatus carrierSignalStatus1 = carrierSynchro.getSignalStatus(point);
            if (carrierSignalStatus1.free != 0)
            {
                return false;
            }
            List<TaskCrane> taskCranes = taskCraneServer.getWorkingCraneTask();
            List<TaskCarrier> taskCarriers = taskCarrierServer.getWorkingCarrierTask();
            if (taskCranes.Count > 0 || taskCarriers.Count > 0)
            {
                return false;
            }
            List<TaskCrane> outTaskCranes = taskCraneServer.getAllOutCraneTask();
            if (outTaskCranes.Count <= 0)
            {
                return false;
            }
            return true;
        }
        public void HandChangeDirL(int carrierMode1) {
            if (CheckIsChange(223))
            {
                if (carrierMode1 == 1)
                {
                    connectLeft.changeCarrierDir(4, 1);
                }
                else if (carrierMode1 == 2)
                {
                    connectLeft.changeCarrierDir(4, 2);
                }
            }
        }


        public void HandChangeDirR(int carrierMode3) {
            if (CheckIsChange(259))
            {
                if (carrierMode3 == 1)
                {
                    connectRight1.changeCarrierDir(4, 1);
                    connectRight2.changeCarrierDir(4, 1);
                }
                else if (carrierMode3 == 2)
                {
                    connectRight1.changeCarrierDir(4, 2);
                    connectRight2.changeCarrierDir(4, 2);
                }
            }
        }

    }
}
