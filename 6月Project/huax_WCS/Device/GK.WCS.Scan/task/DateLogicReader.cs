using System;
using System.Net.Sockets;
using System.Text;
using WCS.Common;

namespace GK.WCS.Scan{
    //扫码枪读取
    public abstract class DateLogicReader:ZtTask {
        long scanTime = 0;
        bool scan = false;
        String data = "";
        DateLogicConnectTask connect = null;
        public DateLogicReader() {
            time = 50;
        }
        public bool isScan() {
            return scan;
        }
        public void startScan() {
            if(!scan) {
                scan = true;
                scanTime = DateTime.Now.Ticks;
                data = "";
            }
            
        }
        public int getScanTime() {
            long ticks = (DateTime.Now.Ticks - scanTime) /10000/1000;
            return (int)ticks;
        }
        public void getStopScan() {
            scan = false;
            data = "";

        }

        public String getData() {
            String d = data;
           
            return d;
        }
        public override void excute() {
            if(connect == null) {
                connect = getConnectTask();
            }

         
            if(scan&&String.IsNullOrEmpty(data)) {
                String d= connect.getData();
                if(d != null) {
                    data = d.Split(';')[0];
                    LoggerCommon.fileAll(connect.ip + "读取" + d);
                }
            }
          
        }
       public abstract DateLogicConnectTask getConnectTask();
       
      
    }
}
