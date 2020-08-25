<<<<<<< .mine
﻿using GK.Engine.WCS.wcs;
using GK.WCS.Entity;
||||||| .r1169
﻿using Engine.WCS;

using GK.WCS.Entity;
=======
﻿using Engine.WCS;
>>>>>>> .r1198
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using WCS.Entity;

namespace GK.Engine.WCS {
    public class WCSTransactionFacade {

        static WcsCreateInEngine wcsCreateInEngine=new WcsCreateInEngine();
        static WcsCreateMoveEngine wcsCreateMoveEngine=new WcsCreateMoveEngine();
        static WcsCreateOutEngine wcsCreateOutEngine=new WcsCreateOutEngine();
        static WcsDeleteCraneAndCarrierTask wcsDeleteCraneAndCarrierTask = new WcsDeleteCraneAndCarrierTask();

        public static bool doStockInEngine(TaskComplete task) {
                lock (wcsCreateInEngine) {
                    wcsCreateInEngine.completeId=task.id;
                    wcsCreateInEngine.wmstaskId=task.wmsTaskId;
                    wcsCreateInEngine.srcId=task.src;
                    wcsCreateInEngine.desId=task.des;
                    wcsCreateInEngine.boxCode=task.boxCode;
                    wcsCreateInEngine.itemType=task.taskType;
                String data = "";
                return wcsCreateInEngine.doWork( ref data );
                }       
        }

         public static bool doCreateMoveEngine(TaskComplete task) {
                lock (wcsCreateInEngine) {
                    wcsCreateMoveEngine.completeId=task.id;
                    wcsCreateMoveEngine.wmstaskId=task.wmsTaskId;
                    wcsCreateMoveEngine.srcId=task.src;
                    wcsCreateMoveEngine.desId=task.des;
                    wcsCreateMoveEngine.boxCode=task.boxCode;
                    wcsCreateMoveEngine.itemType=task.taskType;
                    wcsCreateMoveEngine.relyTaskId=task.relyTaskId;
                String data = "";
                    return wcsCreateMoveEngine.doWork(ref data );
                }        
        }

         public static bool docreateOutEngine(TaskComplete task) {
                lock (wcsCreateInEngine) {
                    wcsCreateOutEngine.completeId = task.id;
                    wcsCreateOutEngine.wmstaskId = task.wmsTaskId;
                    wcsCreateOutEngine.srcId = task.src;
                    wcsCreateOutEngine.desId = task.des;
                    wcsCreateOutEngine.boxCode = task.boxCode;
                    wcsCreateOutEngine.itemType = task.taskType;
                    wcsCreateOutEngine.relyTaskId = task.relyTaskId;
                String data = "";
                return wcsCreateOutEngine.doWork( ref data );
                }
        
        }

        public static bool doDeleteCraneAndCarrierTask(long completeId)
        {
            lock (wcsDeleteCraneAndCarrierTask)
            {
                wcsDeleteCraneAndCarrierTask.completeId = completeId;
                String data = "";
                return wcsDeleteCraneAndCarrierTask.doWork( ref data );
            }

        }
    }
}
