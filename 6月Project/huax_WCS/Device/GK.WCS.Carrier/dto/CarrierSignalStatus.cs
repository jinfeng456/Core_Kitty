﻿using GK.WCS.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WCS.Carrier.dto
{

    public class CarrierSignalStatus {
        public CarrierSignalStatus(int id, int taskNo, int carrierStatus)
        {
            this.id = id;
            this.taskNo = taskNo;
            this.carrierStatus = carrierStatus;       
        }
        public int id { get; set; }
        public int taskNo { get; set; }
        public int carrierStatus { get; set; }
        public int arriveApply { get; set; }
        public int arrived { get; set; }
        public int free{ get; set; }
        public int code { get; set; }
        public int weight { get;set;}
        public int inWHType { get; set; }
        public int inTask { get; set; }
        public int plcMode { get; set; }
        public int plcState { get; set; }

    }
    public class CarrierStatus11
    {
      
    }
}
