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
        CarrierSynchro carrierSynchro1 = TaskPool.get<CarrierSynchro>();
        public static int dirL = 0;
        public static int dirR = 0;
        int LeftMode1;
        int RightModel1;

        public override void excute() {
            LeftMode1 = deviceInOrOutServer.GetInOrNot(4);
            RightModel1 = deviceInOrOutServer.GetInOrNot(5);
            ReadDir();

            if (LeftMode1 == 3) {
                changeDirL();
            } else {
                HandChangeDirL(RightModel1);
            }
            if (RightModel1 == 3) {
                changeDirR();
            } else {
                HandChangeDirR(RightModel1);
            }

        }
        public void ReadDir() {
            dirL = connectLeft.getCarrierDir(4);
            dirR = connectRight1.getCarrierDir(4);
        }
        public void changeDirL() {
            CarrierSignalStatus carrierSignalStatus1 = carrierSynchro1.getSignalStatus(223);
            if (carrierSignalStatus1.free != 0) {
                return;
            }
            List<TaskCrane> taskCranes = taskCraneServer.getWorkingCraneTask();//状态等于2的
            List<TaskCarrier> taskCarriers = taskCarrierServer.getWorkingCarrierTask();//状态等于2
            if (taskCranes.Count > 0 || taskCarriers.Count > 0) {
                return;
            }
            List<TaskCrane> outTaskCranes = taskCraneServer.getAllOutCraneTask();//查所有未执行和执行中的出库
            if (outTaskCranes.Count > 0) {
                if (dirL == 1)//入库
                {
                    connectLeft.changeCarrierDir(4,2);//改为出库
                }
            } else {
                if (dirL == 2) {
                    connectLeft.changeCarrierDir(4,1);//改为入库
                }
            }
        }

        public void changeDirR() {
            CarrierSignalStatus carrierSignalStatus1 = carrierSynchro1.getSignalStatus(259);
            if (carrierSignalStatus1.free != 0) {
                return;
            }
            List<TaskCrane> taskCranes = taskCraneServer.getWorkingCraneTask();
            List<TaskCarrier> taskCarriers = taskCarrierServer.getWorkingCarrierTask();
            if (taskCranes.Count > 0 || taskCarriers.Count > 0) {
                return;
            }
            List<TaskCrane> outTaskCranes = taskCraneServer.getAllOutCraneTask();

            if (outTaskCranes.Count > 0) {
                if (dirR == 1) {
                    connectRight1.changeCarrierDir(4,2);
                    connectRight2.changeCarrierDir(4,2);
                }
            } else {
                if (dirR == 2) {
                    connectRight1.changeCarrierDir(4,1);
                    connectRight2.changeCarrierDir(4,1);
                }
            }
        }
        public void HandChangeDirL(int carrierMode1) {
            CarrierSignalStatus carrierSignalStatus1 = carrierSynchro1.getSignalStatus(223);
            if (carrierSignalStatus1.free != 0) {
                return;
            }

            List<TaskCrane> taskCranes = taskCraneServer.getWorkingCraneTask();
            List<TaskCarrier> taskCarriers = taskCarrierServer.getWorkingCarrierTask();
            if (taskCranes.Count > 0 || taskCarriers.Count > 0) {
                return;
            }
            List<TaskCrane> outTaskCranes = taskCraneServer.getAllOutCraneTask();
            if (outTaskCranes.Count > 0) {
                return;
            }
            if (carrierMode1 == 1) {
                connectLeft.changeCarrierDir(4,1);
            } else if (carrierMode1 == 2) {
                connectLeft.changeCarrierDir(4,2);
            }
        }


        public void HandChangeDirR(int carrierMode3) {
            CarrierSignalStatus carrierSignalStatus1 = carrierSynchro1.getSignalStatus(259);
            if (carrierSignalStatus1.free != 0) {
                return;
            }

            List<TaskCrane> taskCranes = taskCraneServer.getWorkingCraneTask();
            List<TaskCarrier> taskCarriers = taskCarrierServer.getWorkingCarrierTask();
            if (taskCranes.Count > 0 || taskCarriers.Count > 0) {
                return;
            }
            List<TaskCrane> outTaskCranes = taskCraneServer.getAllOutCraneTask();
            if (outTaskCranes.Count > 0) {
                return;
            }
            if (carrierMode3 == 1) {
                connectRight1.changeCarrierDir(4,1);
                connectRight2.changeCarrierDir(4,1);
            } else if (carrierMode3 == 2) {
                connectRight1.changeCarrierDir(4,2);
                connectRight2.changeCarrierDir(4,2);
            }
        }

    }
}
