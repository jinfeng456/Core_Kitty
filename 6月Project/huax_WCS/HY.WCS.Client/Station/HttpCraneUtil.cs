﻿using System;
using System.Collections.Generic;
using CMNetLib.Robots.Crane;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using WCS.Crane;
using WCS.Entity;

namespace GK.WCS.Client.Station {
    public class HttpCraneUtil {


       public static GkCraneStatus loadData(int  CraneId) {
            JObject data = HttpUtil.getObject("Crane/craneStates/" + CraneId);
            if(data == null) {
                return null;
            }
            GkCraneStatus GkCraneStatus = JsonConvert.DeserializeObject<GkCraneStatus>(data.ToString());
            return GkCraneStatus;
        }

        ///Crane/IsAutoRunning/craneId/
        static public bool IsAutoRunning(int CraneId) {
            JValue data = HttpUtil.getJValue("Crane/IsAutoRunning/" + CraneId);
            if(data == null) {
                return false;
            }
            return bool.Parse(data.ToString());

        }
        ///Crane/ClearTaskState/craneId/forkNo
        static public bool ClearTaskState(int CraneId,int forkNo) {
            JValue data = HttpUtil.getJValue("Crane/ClearTaskState/" + CraneId+"/"+ forkNo);
            if(data == null) {
                return false;
            }
            var res= bool.Parse(data.Value.ToString());
            return res;
        }


        ///Crane/ManualAction/craneId/ManualActionCode
        static public bool ManualAction(int CraneId,int forkNo ,ManualActionCode code) {
            JValue data = HttpUtil.getJValue("Crane/ManualAction/" + CraneId + "/" + (int)forkNo+"/"+ (int)code);
            if(data == null) {
                return false;
            }
            return bool.Parse(data.ToString());


        }
        ///Crane/ReConnectRobot/craneId/mode
        static  public bool EmergencyStop(int CraneId,RobotMode mode) {
            JValue data = HttpUtil.getJValue("Crane/EmergencyStop/" + CraneId + "/" + (int)mode);
            if(data == null) {
                return false;
            }
            return bool.Parse(data.ToString());

        }

        ///Crane/ReConnectRobot/craneId/mode
        static  public bool SwtichMode(int CraneId,RobotMode mode) {
            JValue data = HttpUtil.getJValue("Crane/SwtichMode/" + CraneId + "/" + (int)mode);
            if(data == null) {
                return false;
            }
            return bool.Parse(data.ToString());

        }
        ///Crane/ReConnectRobot/craneId
        static public bool ReConnectRobot(int CraneId) {
            JValue data = HttpUtil.getJValue("Crane/ReConnectRobot/" + CraneId );
            if(data == null) {
                return false;
            }
            return bool.Parse(data.ToString());

        }


        ///Crane/ClearFault/craneId
        static public string ClearFault(int CraneId) {
            JValue data = HttpUtil.getJValue("Crane/ClearFault/" + CraneId);
            if(data == null) {
                return "网络异常";
            }
            return data.ToString();

        }
        static public string reset(int CraneId) {
            JValue data = HttpUtil.getJValue("Crane/reset/" + CraneId);
            if(data == null) {
                return "网络异常";
            }
            return data.ToString();

        }
        

        ///Crane/sendTask/craneId/forkNo/src/des/actionid
        static public bool sendTask(int CraneId, int forkNo, int taskType, int fromPlcShelf, int fromPlcRow, int fromPlcCol, int toPlcShelf, int toPlcRow, int toPlcCol) {
            JValue data = HttpUtil.getJValue("Crane/sendTask/" + CraneId + "/" + forkNo + "/" + taskType + "/" + fromPlcShelf + "/" + fromPlcRow + "/" + fromPlcCol + "/" + toPlcShelf + "/" + toPlcRow + "/" + toPlcCol);

            if(data == null) {
                return false;
            }
            return bool.Parse(data.ToString());
        }

        static public List<TaskCrane> getTaskCraneBycompleteId(long completeId)
        {
            JArray data = HttpUtil.getArray("Crane/getTaskCraneBycompleteId/"+ completeId);
            if (data == null)
            {
                return null;
                ;
            }
            List<TaskCrane> list = JsonConvert.DeserializeObject<List<TaskCrane>>(data.ToString());
            return list;
        }

        static public bool DeleteCraneTask(long completeId)
        {
            JValue data = HttpUtil.getJValue("Crane/DeleteCraneTask/" + completeId);
            if (data == null)
            {
                return false;
            }
            return bool.Parse(data.ToString());
        }

        static public bool ResetCraneTaskById(long taskId)
        {
            JValue data = HttpUtil.getJValue("Crane/ResetCraneTaskById/" + taskId);
            if (data == null)
            {
                return false;
            }
            return bool.Parse(data.ToString());
        }

        static public bool FinishCraneTaskById(long taskId)
        {
            JValue data = HttpUtil.getJValue("Crane/FinishCraneTaskById/" + taskId);
            if (data == null)
            {
                return false;
            }
            return bool.Parse(data.ToString());
        }

        static public bool DeleteCraneAndCarrierTask(long completeId)
        {
            JValue data = HttpUtil.getJValue("Crane/DeleteCraneAndCarrierTask/" + completeId);
            if (data == null)
            {
                return false;
            }
            return bool.Parse(data.ToString());
        }

        static public bool ClearCraneTask(int CraneId)
        {
            JValue data = HttpUtil.getJValue("Crane/ClearCraneTask/" + CraneId);
            if (data == null)
            {
                return false;
            }
            return bool.Parse(data.ToString());

        }

        static public bool ClearCraneFault(int CraneId)
        {
            JValue data = HttpUtil.getJValue("Crane/ClearCraneFault/" + CraneId);
            if (data==null)
            {
                return false;
            }
            return bool.Parse(data.ToString());
        }

        static public List<string> GetErrorList(int CraneId)
        {
            JArray data = HttpUtil.getArray("Crane/GetErrorList/" + CraneId);
            if (data == null)
            {
                return null;
                ;
            }
            List<string> list = JsonConvert.DeserializeObject<List<string>>(data.ToString());
            return list;
        }
    }
}
