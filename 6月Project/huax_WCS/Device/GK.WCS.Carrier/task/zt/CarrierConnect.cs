using System;
using System.Collections.Generic;
using GK.WCS.Common;

using GK.WCS.Common.Util;
using GK.WCS.Entity;

namespace GK.WCS.Carrier {
    public abstract class CarrierConnect : SiemensConnect
    {
        int plcId=0;

       public CarrierConnect(int plcId) :base(){
            this.plcId = plcId;
        }
       
        public bool sendTaskHandshake(short begin,short ack)
        {
            writeShort(50,(short)(begin+2),ack);
            return true;
        }

        public byte[] ReadTaskHandshake(short begin, short readCount)
        {
            byte[] bt = reader(51, (short)(begin + 2), readCount);
            return bt;
        }
        public bool SendTask(short codestate,TaskCarrier taskCarrier,short begin) 
        {
            List<byte> carrierTask=new List<byte>();
            carrierTask.AddRange(new byte[]
            {
                BitConverter.GetBytes(codestate)[1],
                BitConverter.GetBytes(codestate)[0],
            });    
            carrierTask.AddRange(new byte[]
            {
                BitConverter.GetBytes((short)taskCarrier.endPath)[1],
                BitConverter.GetBytes((short)taskCarrier.endPath)[0]
            });
            carrierTask.AddRange(new byte[]
            {
                BitConverter.GetBytes(taskCarrier.taskNo)[3],
                BitConverter.GetBytes(taskCarrier.taskNo)[2],
                BitConverter.GetBytes(taskCarrier.taskNo)[1],
                BitConverter.GetBytes(taskCarrier.taskNo)[0]
            });
           carrierTask.AddRange(new byte[]
            {
                BitConverter.GetBytes(int.Parse(taskCarrier.code))[3],
                BitConverter.GetBytes(int.Parse(taskCarrier.code))[2],
                BitConverter.GetBytes(int.Parse(taskCarrier.code))[1],
                BitConverter.GetBytes(int.Parse(taskCarrier.code))[0]
            });
            writeByteArr(50,(short)(begin+4), carrierTask.ToArray());
            return true;
        }
        public byte[] getCarrierStatus(int src, int dsc)
        {
            return reader(51,src,dsc);
        }

        public byte[] getData(int dbid, int begin, int len) {
        
            return reader(dbid, begin, len);
        }
        public int getCarrierDir(int begin)
        {
            return Tools.ushort16(reader(50,begin,2),0);
        }

        public int GetTwoFDir(int begin)
        {
            return Tools.ushort16(reader(51, begin, 2), 0);
        }
        public void clearCarrierTask( int begin)
        {
            writeInt(50,(short)(begin+16),1);
        }
        public void changeCarrierDir(int begin,short dir)
        {
            writeShort(50, (short)begin, dir);
        }
    
        public bool clearAction(ushort type,int taskNo) {
            return true;
        }
        public void resetAction(ushort path) {
          
        }
        public void resetEndpath(int endPath)
        {
            if (endPath ==1001)
            {
                endPath=1;
            }
            else if (endPath == 1007)
            {
                endPath=2;
            }
            else if (endPath == 1011)
            {
                endPath=1;
            }
            else if (endPath == 1012)
            {
                endPath=2;
            }
            else if (endPath == 1015)
            {
                endPath=2;
            }
            else if (endPath == 1023)
            {
                endPath=1;
            }
            else if (endPath == 1024)
            {
                endPath=2;
            }
        }
        protected static object socketLock = new object();
        private static object socketLock1 = new object();
    }
}
