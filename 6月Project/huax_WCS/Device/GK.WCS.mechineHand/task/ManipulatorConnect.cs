﻿

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using CMNetLib.ModBus;
using GK.WCS.Carrier;
using WCS.Common;

namespace GK.WCS.MechineHand
{
    /// <summary>
    /// 机械手
    /// </summary>
  public  class ManipulatorConnect : RegistersModbusTcpConnect
    {

        public ManipulatorConnect() : base()
        {

        }
        /// <summary>
        /// 发送任务
        /// </summary>
        /// <param name="taskNo"></param>
        public void SendTask(int taskNo)
        {
       
            lock (socketLock)
            {
        
                var uTask = new List<ushort>();
              
                    uTask.AddRange(Tools.Int2Short(taskNo)); //任务号

                    uTask.Add((ushort)(1));

                    uTask.Add((ushort)(1));
                    write(3, uTask.ToArray(), "机器人任务发送:");
            
            }
        }
      
        private static object socketLock = new object();
    }
}


