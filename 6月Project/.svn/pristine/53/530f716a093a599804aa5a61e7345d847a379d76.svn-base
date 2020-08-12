using System;
using System.Collections.Generic;
using GK.Mongon.entity;
using HY.WCS.Common;
using HY.WCS.Common.Interface;
using HY.WCS.Common.task;
using MongoDB.Bson;
using MongoDB.Driver;
using Newtonsoft.Json;

namespace HY.WCS.Mongo{


    public class MongoLogTask : ZtTask {
   
        public override bool init() {
            time = 1000;
            return true;
        }
        List<EquipmentPointState> oldlist;
   

        public override void excute() {
            try {
                string value = String.Empty;

                Equipment equipment = new Equipment();
                equipment.list = new List<EquipmentPointState>();
                List<EquipmentPointState> nowlist = getNow();

                if(oldlist != null) {
                    for(int i = 0;i < nowlist.Count;i++) {
                        bool noChange = false;
                        EquipmentPointState now = nowlist[i];
                        foreach(EquipmentPointState old in oldlist) {
                            if(old.isSame(now)) {
                                noChange = true;
                                break;
                            }
                        }
                        if(!noChange) {
                            equipment.list.Add(now);
                        }
                    }
                } else {
                    equipment.list = nowlist;
                }

                MongoUtil.saveEquipmentStatus(equipment);
                oldlist = nowlist;
                clear();
            } catch { }

            List<MongonLog> list = Logger.getAll();
            MongoUtil.savelog(list);


        }

        List<EquipmentPointState> getNow() {
            List<EquipmentPointState> nowlist = new List<EquipmentPointState>();
            List<ZtTask> taskList = TaskPool.getZtTask();
            foreach(ZtTask p in taskList) {
                if(p is LoggerTaskInterface) {
                    LoggerTaskInterface loggerTasker = (LoggerTaskInterface)p;
                    List<EquipmentPointState> logopint = loggerTasker.getLogger();
                    nowlist.AddRange(logopint);
                }
            }

            return nowlist;
        }
     

        long allInTime;
        void clear() {
            long nowTicks = System.DateTime.Now.Ticks;
            if(nowTicks - allInTime > 60 * 1000 * 10000) {
                allInTime = nowTicks;
                oldlist = null;
            }

        }


         
    }
}
