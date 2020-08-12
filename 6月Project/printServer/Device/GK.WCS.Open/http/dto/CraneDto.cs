using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using CMNetLib.Robots.Crane;

namespace GK.WCS.Open.http.dto {
    public class CraneData {
        public bool Fault;
        public RobotMode controlMode;
        public CraneStatus craneStatus;
        public CraneNetData netData = new CraneNetData();
        public CraneRuningData runingData = new CraneRuningData();
        public List<TaskStatusModel> taskState;
        public Dictionary<int,ForkErrCode> ForkStatus;
        public List<DIO> DO;
        public List<DIO> DI;
        public List<AIO> AO;
        public List<AIO> AI;
    }

    public class CraneNetData {
        public long RoundtripTime;
        public String ip;
        public String controlPort;
        public String readPort;
    }
    public class CraneRuningData {
        public decimal NowY
        {
            get;
            set;
        }
        public decimal NowX
        {
            get;
            set;
        }
        public int Y_Speed
        {
            get;
            set;
        }
        public int X_Speed
        {
            get;
            set;
        }
        public byte errDatailCode
        {
            get;
            set;
        }
        public byte errCodeNo
        {
            get;
            set;
        }
       
    }


}
