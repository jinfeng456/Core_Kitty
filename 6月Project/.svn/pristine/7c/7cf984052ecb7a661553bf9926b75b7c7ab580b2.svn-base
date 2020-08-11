using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WCS.Open.http.server {
   public class RGVServer:BaseServer {

        override public object work(List<String> param) {
          
                RGVstatusOpen open = new RGVstatusOpen();
              
                open.ready =1;
                open.rgvStatus =2;
                open.currentPos = 3;
                open.goalPos =4;
                open.readyOutProduct = 9;
                open.readyInPallet = 8;
                open.readyInPackage = 6;
                open.finshInPallet = 6;
                open.finshInPackage = 6;


                return open;

           
        }
    }
    [Serializable]
    public class RGVstatusOpen {
        public int ready;
        public int rgvStatus;
        public int currentPos;
        public int goalPos;
       
        public int readyOutProduct;
        public int readyInPallet;
        public int readyInPackage;

        public int finshInPallet;
        public int finshInPackage;


    }
}
