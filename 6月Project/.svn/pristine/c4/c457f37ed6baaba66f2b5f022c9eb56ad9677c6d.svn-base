using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GK.Mongon.entity;
using HY.WCS.Common.Entity;
using MongoDB.Bson;
using MongoDB.Driver;
using MongoDB.Driver.Builders;
using Newtonsoft.Json;

namespace HY.WCS.Mongo {
   public  class MongoUtil {

        protected static MongoDatabase _database;


        public static MongoDatabase database
        {
            get
            {
                if(_database == null) {
                    var client = new MongoClient($"mongodb://192.168.111.100:27017");
                    _database = client.GetServer().GetDatabase("logger");
                }

                return _database;
            }
        }


        public static void deleteEquipmentStatus(Equipment equipment) {
            var collection = database.GetCollection<BsonDocument>("wcsEquipment");
            DateTime da = DateTime.Now;
            DateTime begin = new DateTime(da.Year - 1,da.Month,da.Day);
            IMongoQuery query = Query.LTE("time",begin);
            collection.Remove(query);
        }

        public static void saveEquipmentStatus(Equipment equipment) {
            if(equipment.list.Count() == 0) {
                return;
            }
            var collection = database.GetCollection<BsonDocument>("wcsEquipment");
            BsonDocument document = BsonDocument.Parse(JsonConvert.SerializeObject(equipment));
            collection.Insert(document);
        
       }

     

        public static void savelog(List<MongonLog>  list) {
            if(list.Count == 0) {
                return;
            }
            var collection = database.GetCollection<BsonDocument>("wcslog");

            List<BsonDocument> mongonList = new List<BsonDocument>();
            foreach(MongonLog mi in list) {
                BsonDocument document = BsonDocument.Parse(JsonConvert.SerializeObject(mi));
                mongonList.Add(document);
            }
            collection.InsertBatch(mongonList);
        }



        public static void saveWsLogger(String ip,String url,String parm,String res) {
            WsLogger log = new WsLogger();
            log.ip = "wcs";
            log.urlName = url;
            log.param = parm;
            log.result = res;
            MongoCollection<BsonDocument> collection = database.GetCollection<BsonDocument>("logger_Webserver");
            collection.Insert(log);
        }
       
    }
}
