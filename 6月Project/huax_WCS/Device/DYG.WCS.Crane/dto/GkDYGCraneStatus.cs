using GK.WCS.Common;
using GK.WCS.Crane.enumerate;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WCS.Crane
{

    public class GkDYGCraneStatus:GkCraneStatusBase
    { public GkDYGCraneStatus(int id):base(id) {
        }
        public int stnId;
        public override bool checkCrane()
        {
           /* if (getStatus(StatusKey.待机) != 1)
            {
                return false;
            }*/
            if (getStatus(StatusKey.CRANE异常) != 0)
            {
                  LoggerCommon.consol("状态" + eId + "CRANE异常");
                return false;
            }
            if (getStatus(StatusKey.CRANE自动) != 1)
            {
                     LoggerCommon.consol("状态" + eId + "非自动");
                return false;
            }
            if (getStatus(StatusKey.CRANE各站均无作业) != 1)
            {
                        LoggerCommon.consol("状态" + eId + "非CRANE各站均无作业");
                return false;
            }
             if (getStatus(StatusKey.CRANE在席) == 1)
            {
                 LoggerCommon.consol( eId + "在席（货叉有货）");
                return false;
            }
            if (craneState != 1) {
                    LoggerCommon.consol("堆垛机状态非启动" + eId + "："+craneState);
             return false;
            }

            if (craneMode != 5) {
                 LoggerCommon.consol("模式异常" + eId + "："+craneMode);
             return false;
            }
            
            
            return true;
        }

    
        public ushort mw10;
        public ushort mw12;
        public ushort mw14;
        public ushort mw16;
        List<ErrorKey> list = new List<ErrorKey>();
        public ushort mw85;
        public ushort mw87;
         public ushort mw89;
        public ushort mw91;
         public ushort mw93;
         int walkNowValue;//走行现在值
         int liftNowValue;//升降现在值
        public int craneState;//堆垛机状态
        public int craneMode;//堆垛机模式
        public int sendData13;//发送数据_13
        public int walkActualPosition;//走行实际位置
        public int liftActualPosition;//升降实际位置
        public int sendData16;//发送数据_16
        public int sendData17;//发送数据_17
        public int finishFlag;//完成标志
        public int finishTaskNo;//完成任务号
       
        public int getStatus(StatusKey key)
        {
            int index = (int)key;
            int mw = index / 16;
            int bit = index % 16;
            int begin = 1;
            begin = begin << bit;
            int val = 0;
            if (mw == 0)
            {
                val = mw10 & begin;
            }
            else if (mw == 1)
            {
                val = mw12 & begin;
            }
            else if (mw == 2)
            {
                val = mw14 & begin;
            }
            else if (mw == 3)
            {
                val = mw16 & begin;
            }
            if (val > 0)
            {
                return 1;
            }

            return 0;
        }

        public void GkCraneError()
        {
            foreach (ErrorKey key in Enum.GetValues(typeof(ErrorKey)))
            {
                int index = (int)key;
                int mw = index / 16;
                int bit = index % 16;
                int begin = 1;
                begin = begin << bit;
                int val = 0;
                if (mw == 0)
                {
                    val = mw85 & begin;
                }
                else if (mw == 1)
                {
                    val = mw87 & begin;
                }
                else if (mw == 2)
                {
                    val = mw89 & begin;
                }
                else if (mw == 3)
                {
                    val = mw91 & begin;
                }
                else if (mw == 4)
                {
                    val = mw93 & begin;
                }
                if (val > 0)
                {
                    list.Add(key);
                }
            }
        }

       

        public List<ErrorKey> GetError()
        {
            return list;
        }
        public override int getX()
        {
            return walkActualPosition;        }

        public override int getY()
        {
              return liftActualPosition;        
        }

        public override int getZ()
        {
            return 0;    
        }

        public override List<string> getError()
        {
            List<String> res = new  List<String> ();
            foreach(ErrorKey key in list) {
            res.Add(key.ToString());
             }
            return res;
        }

        public override void parseError(byte[] b)
        {
             mw10 = Tools.ushort16(b, 0);
            mw12 = Tools.ushort16(b, 2);
            mw14 = Tools.ushort16(b, 4);
            mw16 = Tools.ushort16(b, 8);
            mw85 = Tools.ushort16(b, 8);
            mw87 = Tools.ushort16(b, 10);
            mw89 = Tools.ushort16(b, 14);
            mw91 = Tools.ushort16(b, 18);
            mw93 = Tools.ushort16(b, 20);
            GkCraneError();
            if (getStatus(StatusKey.CRANE异常) == 1) {
                setFault();
            } else {
                clearFault();
                list.Clear();
            }


            ticks = DateTime.Now.Ticks;
        }

        public override void parseStatus(byte[] b)
        {
             walkNowValue = Tools.ushort16(b, 12);
            liftNowValue = Tools.ushort16(b, 16);
            craneState = Tools.ushort16(b, 22);
            craneMode = Tools.ushort16(b, 24);
            sendData13 = Tools.ushort16(b, 26);
            walkActualPosition = Tools.ushort16(b, 28);
            liftActualPosition = Tools.ushort16(b, 30);
            sendData16 = Tools.ushort16(b, 32);
            sendData17 = Tools.ushort16(b, 34);
            finishFlag = Tools.ushort16(b, 36);
            finishTaskNo = Tools.ushort16(b, 38);
        }

        public override Dictionary<int,int> getTaskNo() {
           Dictionary<int,int> dict=new Dictionary<int,int>();
                if(finishFlag == 1) {
                    dict.Add(finishTaskNo,9);
                   
                }
          
                if(finishFlag == 0) {
                   dict.Add(finishTaskNo,2);
                }
            
           
            return dict;
           
        }
    }
}
