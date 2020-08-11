using System;

using System.Net.Sockets;
using System.Text;
using GK.WCS.Common;

namespace GK.WCS.Scan{
    //扫码枪链接
    public class DateLogicConnectTask:SocketZtTaskConnect {
        public DateLogicConnectTask() {
            exceptionSleep = false;
        }
        public String getData() {
            if(noConn()) {
                throw new Exception(className + "链接异常:" + ip);
            }
            Send(new byte[] { (byte)'T' });
            byte[] result =ReadTelex(1024);  
            int receiveLength = result.Length;
            if(0 >= receiveLength) { //客户端主动断开时也会执行到这里
                return null;
            }
            String value = Encoding.ASCII.GetString(result,0,receiveLength);

            if(value == "[d]") {
                LoggerCommon.consol("异常读码" + value);
                return null;
            }
         
            if(value.IndexOf("[") == 0 && value.IndexOf("]") == value.Length - 1) {
                return value.Substring(1,value.Length - 2);
            }
            return null;
        }
      
    }
}
