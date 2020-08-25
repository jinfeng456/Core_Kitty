using Common.dto;
using GK.BACK.DAL;
using GK.Fmxt.DAL;
using GK.FMXT.DAL.dto;
using GK.FMXT.DAL.Entity;
using GK.WMS.Entity;
using GK.WMS.Entity.wms;
using MongoDB.Bson;
using MongoDB.Driver;
using MongoDB.Driver.Builders;
using Mongon.DAL;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Management.Instrumentation;
using System.Text;
using WMS.Entity;

namespace GK.FMXT.DAL
{
    public class CodeInfoUtil
    {
        static IMiddleServer middleServer = FmxtDalFactray.getDal<IMiddleServer>();
        public static void SyncCodeInfo()
        {
            List<CoreCodeInfo> list = GetCodeList(middleServer.GetByBatchId());
            if (list.Count == 0)
            {
                return;
            }
            var collection = MongonBaseDAL.database.GetCollection<BsonDocument>("CoreCodeInfo");
            List<BsonDocument> mongonList = new List<BsonDocument>();
            foreach (CoreCodeInfo codeInfo in list)
            {
                if (codeInfo.level == 2)
                {
                    //SaveCodeInfo(mongonList, codeInfo);
                    var listRemoteCode2 = GetCodeInfo(codeInfo.barCode);
                    foreach (var remoteCodeInfo2 in listRemoteCode2)
                    {
                        CoreCodeInfo codeInfo2 = new CoreCodeInfo();
                        codeInfo2.barCode = remoteCodeInfo2.barCode;
                        codeInfo2.parentCode = codeInfo.barCode;
                        codeInfo2.level = 1;
                        codeInfo2.stockDetailId = codeInfo.stockDetailId;
                        codeInfo2.isFull = 1;
                        SaveCodeInfo(mongonList, codeInfo2);
                    }
                }
                else if (codeInfo.level == 3)
                {
                    //SaveCodeInfo(mongonList, codeInfo);
                    var listRemoteCode2 = GetCodeInfo(codeInfo.barCode);
                    foreach (var remoteCodeInfo2 in listRemoteCode2)
                    {
                        CoreCodeInfo codeInfo2 = new CoreCodeInfo();
                        codeInfo2.barCode = remoteCodeInfo2.barCode;
                        codeInfo2.parentCode = codeInfo.barCode;
                        codeInfo2.level = 2;
                        codeInfo2.stockDetailId = codeInfo.stockDetailId;
                        codeInfo2.isFull = 1;
                        SaveCodeInfo(mongonList, codeInfo2);

                        var listRemoteCode1 = GetCodeInfo(codeInfo2.barCode);
                        foreach (var remoteCodeInfo1 in listRemoteCode1)
                        {
                            CoreCodeInfo codeInfo1 = new CoreCodeInfo();
                            codeInfo1.barCode = remoteCodeInfo1.barCode;
                            codeInfo1.parentCode = codeInfo2.barCode;
                            codeInfo1.level = 1;
                            codeInfo1.stockDetailId = codeInfo.stockDetailId;
                            codeInfo2.isFull = 1;
                            SaveCodeInfo(mongonList, codeInfo1);
                        }
                    }
                }
            }
            if (mongonList.Count > 0)
            {
                collection.InsertBatch(mongonList);
            }

        }


        //public static void saveCodeInfo(String into) {
        //    CoreCodeInfo codeInfo = new CoreCodeInfo();
        //    codeInfo.

        //    var collection = MongonBaseDAL.database.GetCollection<BsonDocument>("CoreCodeInfo");

        //    List<BsonDocument> mongonList = new List<BsonDocument>();
        //    BsonDocument document = BsonDocument.Parse(JsonConvert.SerializeObject(mi));
        //    document.Remove("_id");
        //    mongonList.Add(document);
        //    collection.InsertBatch(mongonList);
        //}




        public static int Insert(CoreCodeInfo codeInfo)
        {
            var collection = MongonBaseDAL.database.GetCollection<BsonDocument>("CoreCodeInfo");
            List<BsonDocument> mongonList = new List<BsonDocument>();
            BsonDocument document = BsonDocument.Parse(JsonConvert.SerializeObject(codeInfo));
            document.Remove("_id");
            mongonList.Add(document);
            collection.InsertBatch(mongonList);
            return 1;
        }

        public static int UpdateBarCode(CoreCodeInfo codeInfo)
        {
            var collection = MongonBaseDAL.database.GetCollection<BsonDocument>("CoreCodeInfo");
            IMongoQuery myQuery = Query.And(Query.EQ("barCode", codeInfo.oldBarcode), Query.EQ("level", 1));
            UpdateBuilder update;
            if (codeInfo.uploadStatus != 4)
            {
                update = Update.Set("uploadStatus", "4").Set("oldBarcode", codeInfo.oldBarcode).Set("barCode", codeInfo.barCode);
            }
            else
            {
                update = Update.Set("uploadStatus", "4").Set("barCode", codeInfo.barCode);
            }
            collection.Update(myQuery, update);
            return 1;
        }

        public static int UpdateUploadStatus(string barCode, int uploadStatus)
        {
            var collection = MongonBaseDAL.database.GetCollection<BsonDocument>("CoreCodeInfo");
            IMongoQuery myQuery = Query.EQ("barCode", barCode);
            UpdateBuilder update = Update.Set("uploadStatus", uploadStatus);
            collection.Update(myQuery, update);
            return 1;
        }

        public static int UpdateUploadStatus(string barCode, int uploadStatus, long stockDetailId)
        {
            var collection = MongonBaseDAL.database.GetCollection<BsonDocument>("CoreCodeInfo");
            IMongoQuery myQuery = Query.EQ("barCode", barCode);
            UpdateBuilder update = Update.Set("uploadStatus", uploadStatus).Set("stockDetailId", stockDetailId);
            collection.Update(myQuery, update);
            return 1;
        }

        public static int UpdatePkDetailId(long stockDetailId, long receiptPkId)
        {
            var collection = MongonBaseDAL.database.GetCollection<BsonDocument>("CoreCodeInfo");
            IMongoQuery myQuery = Query.EQ("stockDetailId", stockDetailId);
            UpdateBuilder update = Update.Set("pkDetailId", receiptPkId);
            collection.Update(myQuery, update);
            return 1;
        }

        public static int UpdateUploadStatus()
        {
            var collection = MongonBaseDAL.database.GetCollection<BsonDocument>("CoreCodeInfo");
            IMongoQuery myQuery = Query.GT("barCode", "0");
            UpdateBuilder update = Update.Set("uploadStatus", "4");
            collection.Update(myQuery, update);
            return 1;
        }
        public static List<BsonDocument> SaveCodeInfo(List<BsonDocument> mongonList, CoreCodeInfo codeInfo)
        {
            if (!Exist(codeInfo.barCode))
            {
                BsonDocument document = BsonDocument.Parse(JsonConvert.SerializeObject(codeInfo));
                document.Remove("_id");
                mongonList.Add(document);
            }
            return mongonList;
        }
        public static List<LogCodeDetail> GetCodeInfo(string parentCode)
        {
            return middleServer.GetByBarCode("", parentCode);
        }
        public static bool Exist(string barCode)
        {
            MongoCollection<CoreCodeInfo> collection = MongonBaseDAL.database.GetCollection<CoreCodeInfo>("CoreCodeInfo");
            List<IMongoQuery> queryList = new List<IMongoQuery>();
            queryList.Add(Query.EQ("barCode", barCode));
            var query = Query.And(queryList);
            if (collection.FindOne(query) != null)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public static Page<CoreCodeInfo> page(CodeInfoDto param)
        {
            int begin = (param.pageNum - 1) * param.pageSize;
            int limit = param.pageSize;
            MongoCollection<CoreCodeInfo> collection = MongonBaseDAL.database.GetCollection<CoreCodeInfo>("CoreCodeInfo");

            List<IMongoQuery> queryList = getParam(param);
            Page<CoreCodeInfo> page = new Page<CoreCodeInfo>();
            MongoCursor<CoreCodeInfo> result = null;
            if (queryList.Count > 0)
            {
                var query = Query.And(queryList);
                result = collection.Find(query).SetSkip(begin).SetLimit(limit).SetSortOrder(SortBy.Descending("barCode"));
                page.totalSize = collection.Count(query);
            }
            else
            {
                result = collection.FindAll().SetSkip(begin).SetLimit(limit).SetSortOrder(SortBy.Descending("barCode"));
                page.totalSize = collection.Count();
            }

            List<CoreCodeInfo> codeInfoList = new List<CoreCodeInfo>();
            foreach (CoreCodeInfo codeInfo in result)
            {
                codeInfoList.Add(codeInfo);
            }
            page.content = codeInfoList;
            return page;
        }

        public static MongoCursor<CoreCodeInfo> GetAll()
        {
            MongoCollection<CoreCodeInfo> collection = MongonBaseDAL.database.GetCollection<CoreCodeInfo>("CoreCodeInfo");
            return collection.FindAll();
        }

        static List<IMongoQuery> getParam(CodeInfoDto param)
        {
            List<IMongoQuery> queryList = new List<IMongoQuery>();

            if (!String.IsNullOrEmpty(param.barCode))
            {
                queryList.Add(Query.Matches("barCode", param.barCode));
            }
            if (!String.IsNullOrEmpty(param.parentCode))
            {
                queryList.Add(Query.Matches("parentCode", param.parentCode));
            }
            return queryList;
        }
        static public List<CoreCodeInfo> GetCodeList(List<CoreStockDetail> list)
        {
            MongoCollection<CoreCodeInfo> collection = MongonBaseDAL.database.GetCollection<CoreCodeInfo>("CoreCodeInfo");
            List<IMongoQuery> queryList = new List<IMongoQuery>();
            List<BsonValue> valueList = new List<BsonValue>();
            foreach (var item in list)
            {
                valueList.Add(BsonValue.Create(item.id));
            }
            queryList.Add(Query.In("stockDetailId", valueList));
            var query = Query.And(queryList);
            return collection.Find(query).ToList();
        }

        static public List<CoreCodeInfo> GetCodeListByPkdetailId(long pkDetailId)
        {
            MongoCollection<CoreCodeInfo> collection = MongonBaseDAL.database.GetCollection<CoreCodeInfo>("CoreCodeInfo");
            List<IMongoQuery> queryList = new List<IMongoQuery>();
            queryList.Add(Query.EQ("pkDetailId", pkDetailId));
            var query = Query.And(queryList);
            return collection.Find(query).ToList();
        }

        public static List<CoreCodeInfo> GetInfoByBarCode(string barCode)
        {
            MongoCollection<CoreCodeInfo> collection = MongonBaseDAL.database.GetCollection<CoreCodeInfo>("CoreCodeInfo");
            List<IMongoQuery> queryList = new List<IMongoQuery>();
            queryList.Add(Query.EQ("barCode", barCode));
            var query = Query.And(queryList);
            return collection.Find(query).ToList();
        }

        public static int UpdateIsFull(string parentCode, string[] listBarCode)
        {
            var collection = MongonBaseDAL.database.GetCollection<BsonDocument>("CoreCodeInfo");
            List<IMongoQuery> queryList = new List<IMongoQuery>();
            queryList.Add(Query.EQ("parentCode", parentCode));
            foreach (var barCode in listBarCode)
            {
                queryList.Add(Query.GT("barCode", barCode));
            }
            IMongoQuery myQuery = Query.And(queryList);
            UpdateBuilder update = Update.Set("isFull", 1);
            collection.Update(myQuery, update);
            return 1;
        }
    }
}
