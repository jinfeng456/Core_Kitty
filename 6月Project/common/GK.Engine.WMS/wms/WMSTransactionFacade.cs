﻿using GK.WMS.Entity.wms;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using WMS.Entity;

namespace GK.Engine.WMS.wms
{
    public class WMSTransactionFacade
    {
        public static object  lockObj =new object();

        static InEngine inEngine = new InEngine();
        static SyncWcsReultEngine syncWcsReultEngine = new SyncWcsReultEngine();

        static CheckOutEngine checkOutEngine = new CheckOutEngine();
        static BatchOutEngine batchOutEngine = new BatchOutEngine();
        static OtherOutEngine otherOutEngine = new OtherOutEngine();
        static StockPkEngine pkEngine = new StockPkEngine();
        static SyncFlatReult syncFlatReult =new SyncFlatReult();
        static SyncFlatOutReult syncFlatOutReult = new SyncFlatOutReult(); 
        public static bool doStockInEngine(string boxCode, ref string errorMsg)
        {
            lock (lockObj)
            {
                inEngine.boxCode = boxCode;
                inEngine.doWork(ref errorMsg);
                return true;
            }
        }
        public static bool doSyncFlatReult(int finshCount, long areaId, long reDetailId, ref string errorMsg)
        {
            lock (lockObj)
            {
                syncFlatReult.finshCount = finshCount;
                syncFlatReult.areaId=areaId;
                syncFlatReult.reDetailId=reDetailId;
                syncFlatReult.doWork(ref errorMsg);
                return true;
            }
        }
        public static bool doSyncFlatOutReult(long id,int? finshCount,string remark, ref string errorMsg)
        {
            lock (lockObj)
            {
                syncFlatOutReult.id=id;
                syncFlatOutReult.finshCount=finshCount;
                syncFlatOutReult.remark=remark;
                syncFlatOutReult.doWork(ref errorMsg);
                return true;
            }
        }
        public static bool syncWcsReult(long taskId, int status, ref string errorMsg)
        {

            lock (lockObj)
            {
                syncWcsReultEngine.taskId = taskId;
                syncWcsReultEngine.taskStatus = status;
                return syncWcsReultEngine.doWork(ref errorMsg);
            }

        }

        public static bool doPkEngine(WhReceiptPk whReceiptPk, ref string errorMsg)
        {
            pkEngine.whReceiptPk = whReceiptPk;
            lock (lockObj)
            {
                return pkEngine.doWork(ref errorMsg);
            }
        }
        public static bool doBatchOutEngine(WhReceiptOut whReceipt, ref string errorMsg)
        {
            batchOutEngine.whReceipt = whReceipt;
            lock (lockObj)
            {
                return batchOutEngine.doWork(ref errorMsg);
            }
        }

        public static bool doCheckOutEngine(WhReceiptOut whReceipt, ref string errorMsg)
        {
            checkOutEngine.whReceipt = whReceipt;
            lock (lockObj)
            {
                return checkOutEngine.doWork(ref errorMsg);
            }
        }

        public static bool doOtherOutEngine(WhReceiptOut whReceipt, ref string errorMsg)
        {
            otherOutEngine.whReceipt = whReceipt;
            lock (lockObj)
            {
                return otherOutEngine.doWork(ref errorMsg);
            }
        }
    }
}
