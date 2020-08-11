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
        protected CarrierConnect connect6 = TaskPool.get<CarrierConnect>(6);
        protected int plcId;
        GkCarrierStatus carrierStatus;
      
        List<int> hisTask;
        List<int> curTask;
        ITaskCarrierServer taskCarrierServer = ServerFactray.getServer<ITaskCarrierServer>();
        ITaskCraneServer taskCraneServer = ServerFactray.getServer<ITaskCraneServer>();
        
      
        public CarrierSynchro()
        {
            this.plcId = 1;
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
            keyPointAssign(carrierMessage);
            syncSign(carrierMessage);
          
            carrierStatus = new  GkCarrierStatus(carrierMessage);
            LoggerCommon.addEquipmentStatus(carrierStatus);

        }

       void readerSign(Dictionary<int, CarrierSignalStatus> carrierMessage ) {
            byte[] rsTaskNo1 = connect1.getData(52, 0, 444);
            byte[] rsSign1 = connect1.getData(54, 0, 222);
            CarrierStatusDB(carrierMessage,rsTaskNo1, rsSign1 , 1000 ,1111, 1000);

            byte[] rsTaskNo2 = connect2.getData(52, 444, 140);
            byte[] rsSign2 = connect2.getData(54, 222, 70);
            CarrierStatusDB(carrierMessage,rsTaskNo2, rsSign2 , 1200,1235,1089);

            byte[] rsTaskNo3 = connect3.getData(52, 584, 304);
            byte[] rsSign3 = connect3.getData(54, 292, 152);
               CarrierStatusDB(carrierMessage,rsTaskNo3, rsSign3, 1300, 1376,1154);

            byte[] rsTaskNo4 = connect4.getData(52, 888, 144);
            byte[] rsSign4 = connect4.getData(54, 444, 72);
             CarrierStatusDB(carrierMessage,rsTaskNo4, rsSign4, 2001, 2037,1779);

            byte[] rsTaskNo5 = connect5.getData(52, 1032, 44);
            byte[] rsSign5 = connect5.getData(54, 516, 22);
               CarrierStatusDB(carrierMessage,rsTaskNo5, rsSign5, 2201, 2212,1943);

            byte[] rsTaskNo6 = connect6.getData(52, 1076, 100);
            byte[] rsSign6 = connect6.getData(54, 538, 50);
           CarrierStatusDB(carrierMessage,rsTaskNo6, rsSign6, 2300, 2325,2031);
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
        void CarrierStatusDB(Dictionary<int, CarrierSignalStatus> carrierMessage,byte[] rsTaskNo, byte[] rsSign, int src ,int des ,int begin)
        {
            if (rsTaskNo !=null && rsSign!=null)
            {
                int number = rsSign.Length / 2;
                if (rsTaskNo.Length / 4 != number)
                {
                    throw new Exception("长度异常");
                }
                for (int i = src; i < des; i++)
                {
                    int sign = Tools.ushort16(rsSign, (i - begin) * 2);
                    int taskNo = Tools.int32(rsTaskNo, (i - begin) * 4);
                    carrierMessage.Add(i, new CarrierSignalStatus(i, taskNo, sign));
                }
            }
            
        }
        public void keyPointAssign(Dictionary<int, CarrierSignalStatus> carrierMessage)
        {
            if (carrierMessage == null)
            {
                return;
            }
            Dictionary<int, PlcCarrierPoint> plcCarrierPoint = CarrierPoint.carrierPoint;
            byte[] carrierState1 = connect1.getCarrierStatus(0,782);
            byte[] carrierState2 = connect2.getCarrierStatus(782,1034);
            byte[] carrierState3 = connect3.getCarrierStatus(1034,1566);
            byte[] carrierState4 = connect4.getCarrierStatus(1566,1902);
            byte[] carrierState5 = connect5.getCarrierStatus(1902,2014);
            byte[] carrierState6 = connect6.getCarrierStatus(2014,2238);
            byte[] full=new byte[carrierState1.Length+carrierState2.Length+carrierState3.Length+carrierState4.Length+carrierState5.Length+carrierState6.Length];   
            Stream s = new MemoryStream();   
            s.Write(carrierState1, 0, carrierState1.Length);   
            s.Write(carrierState2, 0, carrierState2.Length);   
            s.Write(carrierState3, 0, carrierState3.Length);   
            s.Write(carrierState4, 0, carrierState4.Length);  
            s.Write(carrierState5, 0, carrierState5.Length);   
            s.Write(carrierState6, 0, carrierState6.Length);  
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
                        if (taskCarrier.itemType == 2)
                        {
                            taskCarrierServer.UpdateTaskCarrierStatus(taskCarrier.taskNo, 9);
                            ClearTask(it.Value.PlcId,it.Value.WOffset);
                        }
                        else if(taskCarrier.itemType == 1)
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
            if (plcId == 6)
            {
                connect6.clearCarrierTask(wOffset);
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
