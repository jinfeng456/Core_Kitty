using System;
using System.Collections.Generic;

using GK.WCS.Common.task;
using GK.WCS.Common.Util;
using GK.WCS.Entity;
using GK.WCS.DAL;
using GK.DAL.inter;
using GK.Engine.WCS.wcs;
using GK.Engine.WCS;
using GK.WCS.Crane;

namespace GK.WCS.Open.http.server {

    public class CraneServer:BaseServer {
        ITaskCraneServer taskCraneServer = ServerFactray.getServer<ITaskCraneServer>();

        ///Crane/craneStates/0
        public GkCraneStatusBase craneStates( List<String> param) {
            int craneId = int.Parse(param[0]);
           
            CraneSynchro reader = TaskPool.get<CraneSynchro>(craneId);
            GkDYGCraneStatus rs= (GkDYGCraneStatus)reader.getCraneStatus();
            if (rs==null)
            {
                return new GkDYGCraneStatus(0);
            }
            return rs;
        }
    
        ///Crane/ClearTaskState/craneId/forkNo
        public bool ClearTaskState(List<String> param) {
            return false;
        }

        public bool sendTask(List<String> param) {
            TaskCrane model = new TaskCrane();
            model.taskNo = TaskUtil.getTaskNo();
            model.craneId = int.Parse(param[0]);
            model.forkNo = int.Parse(param[1]);
            model.taskType = int.Parse(param[2]);
            model.fromPlcShelf = int.Parse(param[3]);
            model.fromPlcRow = int.Parse(param[4]);
            model.fromPlcCol = int.Parse(param[5]);
            model.toPlcShelf = int.Parse(param[6]);
            model.toPlcRow = int.Parse(param[7]);
            model.toPlcCol = int.Parse(param[8]);
            CraneConnect connect = TaskPool.get<CraneConnect>(int.Parse(param[0]));
            bool result = connect.SendTask(model, 0);
            return result;
        }
           
        ///Crane/ReConnectRobot/craneId
        public bool EmergencyStop(List<String> param) {
            int craneId = int.Parse(param[0]);
            CraneConnect connect = TaskPool.get<CraneConnect>(craneId);
             connect.EmergencyStop();
            return true;
        }

        public string reset(List<String> param) {
            int craneId = int.Parse(param[0]);
            CraneConnect connect = TaskPool.get<CraneConnect>(craneId);
            connect.reset();
            return "复位成功";
        }

        
        ///Crane/craneStates/craneId/forkNo/src/des/actionid
        public bool Send_SEMI_Task(List<String> param ) {       
            return false;
        }

        public List<TaskCrane> getTaskCraneBycompleteId(List<String> param)
        {
            long completeId = long.Parse(param[0]);
            return taskCraneServer.getTaskCraneBycompleteId(completeId);
        }

        public bool DeleteCraneTask(List<String> param)
        {
            long completeId = long.Parse(param[0]);
            return taskCraneServer.DeleteCraneTask(completeId);
        }

        public bool ResetCraneTaskById(List<String> param)
        {
            long taskId = long.Parse(param[0]);
            return taskCraneServer.ResetCraneTaskById(taskId);
        }
        public bool FinishCraneTaskById(List<String> param)
        {
            long taskId = long.Parse(param[0]);
            return taskCraneServer.FinishCraneTaskById(taskId);
        }

        public bool DeleteCraneAndCarrierTask(List<String> param)
        {
            long completeId = long.Parse(param[0]);
            return WCSTransactionFacade.doDeleteCraneAndCarrierTask(completeId);
        }

        public bool ClearCraneTask(List<String> param)
        {
            int craneId = int.Parse(param[0]);
            CraneConnect connect = TaskPool.get<CraneConnect>(craneId);
            connect.DeleteTask();
            return true;
        }

        public bool ClearCraneFault(List<String> param)
        {
            int craneId = int.Parse(param[0]);
            CraneSynchro craneSynchro = TaskPool.get<CraneSynchro>(craneId);
            GkCraneStatusBase status = craneSynchro.getCraneStatus();
            if (status != null) {
                status.clearFault();
                bool b = status.isfault();
                return true;
            }
            return false;
        }

        public List<string> GetErrorList(List<String> param)
        {
            int craneId = int.Parse(param[0]);
            CraneSynchro reader = TaskPool.get<CraneSynchro>(craneId);
            GkDYGCraneStatus rs = (GkDYGCraneStatus)reader.getCraneStatus();
            if (rs!=null)
            {
                return rs.getError();
            }
            return new List<string>();
        }
    }
}
