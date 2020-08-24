using System;
using System.Collections.Generic;
using System.IO;
using GK.WCS.Carrier.dto;
using GK.WCS.Carrier.enumerate;
using GK.WCS.Common;
using GK.WCS.Common.core.dto;
using GK.WCS.Common.task;
using GK.WCS.DAL;
using GK.WCS.Entity;
using static GK.WCS.Carrier.enumerate.CarrierPoint;

namespace GK.WCS.Carrier {
    public  class CarrierSynchro : ZtTask {
        protected CarrierConnect connect1 = TaskPool.get<CarrierConnect>(1);
        protected CarrierConnect connect2 = TaskPool.get<CarrierConnect>(2);
        protected CarrierConnect connect3 = TaskPool.get<CarrierConnect>(3);
        protected CarrierConnect connect4 = TaskPool.get<CarrierConnect>(4);
        protected CarrierConnect connect5 = TaskPool.get<CarrierConnect>(5);

        protected int plcId;
        GkCarrierStatus carrierStatus;
      
        List<int> hisTask;
        List<int> curTask;
        ITaskCarrierServer taskCarrierServer = ServerFactray.getServer<ITaskCarrierServer>();
        ITaskCraneServer taskCraneServer = ServerFactray.getServer<ITaskCraneServer>();
        
      
        public CarrierSynchro()
        {
            time = 300;
        }
        public  CarrierSignalStatus getSignalStatus(int id) {
            if (carrierStatus==null)
            {
                return null;
            }
            long des = DateTime.Now.Ticks - carrierStatus.ticks;
            if (des > 10000 * 1000) {
                LoggerCommon.fileAll("传输线信号超时" + des);
                return null;
            }
            return carrierStatus.curCarrierMessage[id];
        }
        public Dictionary<int, CarrierSignalStatus> getAllPointSignal()
        {
            long des = DateTime.Now.Ticks -  carrierStatus.ticks;
            if (des > 10000 * 2000)
            {
                LoggerCommon.fileAll("传输线信号超时" + des);
                return null;
            }
            return carrierStatus.curCarrierMessage;
        }
    

        public override void excute() {
            Dictionary<int, CarrierSignalStatus> carrierMessage = new Dictionary<int, CarrierSignalStatus>();
            readerSign(carrierMessage);
            syncSign(carrierMessage);
          
            carrierStatus = new  GkCarrierStatus(carrierMessage);
            LoggerCommon.addEquipmentStatus(carrierStatus);

        }

       void readerSign(Dictionary<int, CarrierSignalStatus> carrierMessage ) {
            if (false)
            {
                byte[] rsTaskNo1 = connect1.getData(52, 0, 444);
                byte[] rsSign1 = connect1.getData(54, 0, 222);
                byte[] carrierState1 = connect1.getCarrierStatus(0, 782);//关键点
                CarrierStatusDB(carrierMessage, rsTaskNo1, rsSign1, carrierState1,1000, 1111);
            }

  
            byte[] rsTaskNo2 = connect2.getData(52, 0, 140);
            byte[] rsSign2 = connect2.getData(54, 0, 70);
            byte[] carrierState2 = connect2.getCarrierStatus(0, 202);
            CarrierStatusDB(carrierMessage,rsTaskNo2, rsSign2 , carrierState2,1200, 1235);

            byte[] rsTaskNo3 = connect3.getData(52, 0, 304);
            byte[] rsSign3 = connect3.getData(54, 0, 152);
            byte[] carrierState3 = connect3.getCarrierStatus(0, 422);
            CarrierStatusDB(carrierMessage,rsTaskNo3, rsSign3, carrierState3,1300, 1376);

            if (false)
            {
                byte[] rsTaskNo4 = connect4.getData(52, 0, 144);
                byte[] rsSign4 = connect4.getData(54, 0, 72);
                byte[] carrierState4 = connect4.getCarrierStatus(0, 246);
                CarrierStatusDB(carrierMessage, rsTaskNo4, rsSign4, carrierState4, 2001, 2037);
            }


            byte[] rsTaskNo5 = connect5.getData(52, 0, 144);
            byte[] rsSign5 = connect5.getData(54, 0, 72);
            byte[] carrierState5 = connect5.getCarrierStatus(0, 246);
            CarrierStatusDB(carrierMessage,rsTaskNo5, rsSign5, carrierState5,2201, 2212);

        }
        List<int> GetTasks(Dictionary<int, CarrierSignalStatus> curCarrierMessage) {
               List<int> curTaskTmp = new List<int>();
                 foreach (KeyValuePair<int, CarrierSignalStatus> kvp in curCarrierMessage)//键值对一起遍历
                    {
                       int taskNo = kvp.Value.taskNo;
                        if (taskNo != 0)
                        {
                            if (!curTaskTmp.Contains(taskNo))
                            {
                                curTaskTmp.Add(taskNo);
                            }
                        }
                    }
                 return curTaskTmp;
            }


        void syncSign(Dictionary<int, CarrierSignalStatus> curCarrierMessage)
        {
            curTask = GetTasks(curCarrierMessage);
            foreach(int curTk in curTask)
            {
                if (hisTask.Count == 0||!hisTask.Contains(curTk))
                {
                    TaskCarrier taskCarrier = taskCarrierServer.getCarrarTasksByTaskNo(curTk);
                    if (taskCarrier != null)
                    {
                        if (taskCarrier.status == 1)
                        {
                            taskCarrierServer.UpdateTaskCarrierStatus(curTk, 2);
                        }
                    }
                    else
                    {
                        LoggerCommon.fileAll("任务号为 " + curTk + " 的任务不存在！ ");
                    }
                }
            }
            hisTask=curTask;
            finshTask(curCarrierMessage);
        }
        void CarrierStatusDB(Dictionary<int, CarrierSignalStatus> carrierMessage,byte[] rsTaskNo, byte[] rsSign, byte[] carrierState ,int src ,int des)
        {
            if (carrierMessage == null)
            {
                return;
            }
            if (rsTaskNo !=null && rsSign!=null)
            {
                int number = rsTaskNo.Length / 2;
                if (number != rsSign.Length)
                {
                    throw new Exception("长度异常");
                }
                for (int i = src; i < des; i++)
                {
                    int sign = Tools.ushort16(rsSign, (i - src) * 2);
                    int taskNo = Tools.int32(rsTaskNo, (i - src) * 4);
                    carrierMessage.Add(i, new CarrierSignalStatus(i, taskNo, sign));
                }
            }
            keyPointAssign(carrierMessage, carrierState);
        }
        public void keyPointAssign(Dictionary<int, CarrierSignalStatus> carrierMessage,byte[] carrierState)
        {
            Dictionary<int, PlcCarrierPoint> plcCarrierPoint = CarrierPoint.carrierPoint;
            byte[] full=new byte[carrierState.Length];   
            Stream s = new MemoryStream();   
            s.Write(carrierState, 0, carrierState.Length);     
            s.Read(full,0,full.Length);
      
            foreach (KeyValuePair<int, PlcCarrierPoint> item in plcCarrierPoint)
            {
                CarrierMachineState ms =  new CarrierMachineState(full, item.Value.ROffset);//所有关键点
                carrierMessage[item.Value.pathNo].arriveApply = ms.arriveApply;
                carrierMessage[item.Value.pathNo].arrived = ms.arrived;
                carrierMessage[item.Value.pathNo].free = ms.free;
                carrierMessage[item.Value.pathNo].code = ms.CodeMess;
                carrierMessage[item.Value.pathNo].weight = ms.weight;
                carrierMessage[item.Value.pathNo].inWHType = ms.inWHType;
                carrierMessage[item.Value.pathNo].inTask = ms.inTask;
                carrierMessage[item.Value.pathNo].plcMode = ms.plcMode;
                carrierMessage[item.Value.pathNo].plcState = ms.plcState;
            }           
        }
       
        public void finshTask(Dictionary<int, CarrierSignalStatus> curCarrierMessage)
        {
            if (curCarrierMessage==null)
            {
                return;
            }
            Dictionary<int,PlcCarrierPoint> keyPoint = CarrierPoint.carrierPoint;
            foreach (var it in keyPoint)
            {               
                CarrierSignalStatus carrierSignal = curCarrierMessage[it.Value.pathNo];
                if (carrierSignal.arrived == 1)
                {
                    int  taskNO = carrierSignal.taskNo;
                    TaskCarrier taskCarrier = taskCarrierServer.getCarrarTasksByTaskNo(taskNO);
                    if (taskCarrier != null&& taskCarrier.endPath== it.Value.pathNo)
                    {
                        if (taskCarrier.taskType == 2)
                        {
                            taskCarrierServer.UpdateTaskCarrierStatus(taskCarrier.taskNo, 9);
                            ClearTask(it.Value.PlcId,it.Value.WOffset);
                        }
                        else if(taskCarrier.taskType == 1)
                        {
                            taskCarrierServer.UpdateTaskCarrierStatus(taskCarrier.taskNo, 9);
                            TaskCrane taskCrane= taskCraneServer.getTaskCraneByTaskNo(taskCarrier.taskNo);
                            if (taskCrane.status != 1)
                            {
                                ClearTask(it.Value.PlcId, it.Value.WOffset);
                            }
                        }
                    }
                    else
                    {
                        LoggerCommon.fileAll("托盘号为 " + taskNO + "的入库任务不存在！ ");
                    }
                }
            }
        }

        private void ClearTask(int plcId, int wOffset)
        {
            if (plcId == 1)
            {
                connect1.clearCarrierTask(wOffset);
            }
            if (plcId == 2)
            {
                connect2.clearCarrierTask(wOffset);
            }
            if (plcId == 4)
            {
                connect3.clearCarrierTask(wOffset);
            }
            if (plcId == 4)
            {
                connect4.clearCarrierTask(wOffset);
            }
            if (plcId == 5)
            {
                connect5.clearCarrierTask(wOffset);
            }

        }
    }

    public class PlcPoint{

        public int  pathNo;
        public int  statusOffset;

       public PlcPoint(int pathNo,int statusOffset)
        {
           
            this.pathNo = pathNo;
            this.statusOffset = statusOffset;               
        }
    }
}
