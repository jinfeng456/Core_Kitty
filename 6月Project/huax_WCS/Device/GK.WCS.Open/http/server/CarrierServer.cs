using System;
using System.Collections.Generic;
using GK.WCS.Carrier;
using CMNetLib.Robots.CarrierChain;
using CMNetLib.Robots.Crane;
using GK.WCS.DAL;
using WCS.Carrier.dto;
using WCS.Entity;
using WCS.DAL;
using WCS.Common.task;
using WCS.Common;
using WCS.Carrier;

namespace GK.WCS.Open.http.server {

    public class CarrierData {

        

        public Dictionary<int, CarrierSignalStatus> SignalStates
        {
            get; set;
        }

        public TaskCarrier selectTask
        {
            get; set;
        }

        

    }
   public class CarrierServer:BaseServer {
        
        ITaskCarrierServer taskCarrierServer = ServerFactray.getServer<ITaskCarrierServer>();

        ///Carrier/reflash/1/
        public CarrierData reflash(List<String> param) {
            int plcId = int.Parse(param[0]);
            CarrierData d = new CarrierData();

            CarrierSynchro carrierSynchro = (CarrierSynchro)TaskPool.get<CarrierSynchro>();
            d.SignalStates = carrierSynchro.getAllPointSignal();

            int taskNo = int.Parse(param[1]);
            if (taskNo > 10000000)
            {

                ITaskCarrierServer taskCarrierServer = ServerFactray.getServer<ITaskCarrierServer>();
                d.selectTask = taskCarrierServer.getCarrarTasksByTaskNo(taskNo);
            }
              
            return d;
        }

        ///Carrier/clearAction/plcId/path
        public String clearAction(List<String> param) {
            
            int plcId = int.Parse(param[0]);
            ushort path = ushort.Parse(param[1]);
            string info = "wcs删除任务" + path;

            CarrierSynchro carrierSynchro = (CarrierSynchro)TaskPool.get<CarrierSynchro>();
            CarrierSignalStatus ss = carrierSynchro.getSignalStatus(path);
             
            if(ss == null || ss.taskNo < 1) {
                LoggerCommon.fileAll("传输线无任务" + path);
                return path + "无任务";
            }

            CarrierConnect connect = TaskPool.get<CarrierConnect>(plcId);

            if(connect.clearAction(path,ss.taskNo)) {
                LoggerCommon.fileAll(info + "成功！");

            } else {
                LoggerCommon.fileAll(info + "失败");
            }
            return "";
        }
     
       
        ///Carrier/resetAction/path
        public String resetAction(List<String> param) {
            int plcId = int.Parse(param[0]);
            ushort path = ushort.Parse(param[1]);
            string info = "wcs复位" + path;

            string err = "";
            CarrierConnect connect =TaskPool.get<CarrierConnect>(plcId);

            //connect.resetAction(path,ref err);
            LoggerCommon.fileAll(info + "完成！");

            return "";
        }


        public List<TaskCarrier> getCarrierTaskByCompleteId(List<String> param)
        {
            long completeId = long.Parse(param[0]);
            return taskCarrierServer.getCarrierTaskByComId(completeId);
        }

        public bool DeleteCarrierTask(List<String> param)
        {
            long completeId = long.Parse(param[0]);
            return taskCarrierServer.DeleteCarrierTask(completeId);
        }

        public bool ResetCarrierTaskById(List<String> param)
        {
            long taskId = long.Parse(param[0]);
            return taskCarrierServer.ResetCarrierTaskById(taskId);
        }
        public bool FinishCarrierTaskById(List<String> param)
        {
            long taskId = long.Parse(param[0]);
            return taskCarrierServer.FinishCarrierTaskById(taskId);
        }

    }
}
