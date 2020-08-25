
using System;
using System.Collections.Generic;
using WCS.Common;
using WCS.Common.dto;
using WCS.Common.task;

namespace GK.WCS.Open.http.server {
   public class SysServer:BaseServer {
        //Sys/showLog
        public List<ShowCache> showLog(List<String> param) {
            return LoggerCache.getAll();
        }
        //Sys/getStat
        public List<TaskStat> getStat(List<String> param) {
            return TaskPool.getStat();
        }

    }
   
}
