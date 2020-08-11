using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HY.WCS.Common;

using System.Threading.Tasks;
using System.Threading;

using HY.WCS.CarrierChain;
using CMNetLib.ModBus;
using System.Collections.Concurrent;

using HY.WCS.task;
using HY.WCS.Entity;
using HY.WCS.DAL;

namespace HY.WCS.Server
{
    public class CarrierTools
    {
        public static void clearCarrier(ushort CarrierID, long taskNohasYear) {
         
            String err = "";

            CrarrierActionModel model = new CrarrierActionModel() {
                CarrierID = CarrierID,
                CrarrierAction = CrarrierActionEnum.任务清除,
                TaskNo1 = 0,
                TaskNo2 = Tools.longTaskNO2Int(taskNohasYear),
            };

            if (!MZCarrierChain.carrierChain.CarrierAction(model, ref err)) {
                throw new Exception("清空传输线失败！" + taskNohasYear + err);

            }
        }

        public static void CarrierAction(ushort CarrierID,CrarrierActionEnum action) {

            String err = "";

            CrarrierActionModel model = new CrarrierActionModel() {
                CarrierID = CarrierID,
                CrarrierAction = action,
                TaskNo1 = 0,
                TaskNo2 = 0,
            };

            if (!MZCarrierChain.carrierChain.CarrierAction(model, ref err)) {
                throw new Exception("清空传输线失败！" + action + err);

            }
        }

        public static bool CarrierSendTask(ushort StartPath, ushort EndPath, ushort PathNo, int TaskNo) {
            string err = string.Empty;
            if (MZCarrierChain.carrierChain.SendTask(new HY.WCS.CarrierChain.TaskSendModel() {
                StartPath = StartPath,
                EndPath = EndPath,
                PathNo = PathNo,
                TaskNo = TaskNo

            }, ref err)) {
                return true;
            } else {
                String info = "输送链任务Start:{0},End:{1},Path:{2},TaskNo:{3}失败:{4}";
                info = string.Format(info, StartPath, EndPath, PathNo, TaskNo, err);
                Logger.DoErrLogAndShow(info);
                return false;
            }

        }

    }
}
