using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using MongoDB.Bson.Serialization.Attributes;

namespace HY.WCS.Mongo {
   public  class WsLogger {
        public WsLogger() {
            dt = DateTime.Now;
            orderNo = dt.Ticks;
        }
       
        public String urlName
        {
            get; set;
        }
        public String param
        {
            get; set;
        }
        public String result
        {
            get; set;
        }
        [BsonDateTimeOptions(Kind = DateTimeKind.Local)]
        public DateTime dt
        {
            get; set;
        }
        public String ip
        {
            get; set;
        }
        public long orderNo
        {
            get; set;
        }

    }
}
