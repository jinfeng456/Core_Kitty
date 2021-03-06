﻿using Dapper;
using GK.WCS.DAL;
using GK.WCS.Entity;
using GK.WCS.Entity.wcs;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace GK.Engine.WCS
{
    public class CommentFunction
    {
        public static bool BCrane(IDbConnection connection, IDbTransaction transaction, int type, int TaskNo,int src, int des,string boxCode, long completeId, long tCompPId,long id)
        {
            string Extra;
            if (type == 1)
            {
                Extra = "crane入库";
               
            }
            else if (type == 2)
            {
                Extra = "crane出库";
            }
            else if (type == 3)
            {
                Extra = "crane移库";
            }
            else
            {
                throw new Exception("at _BCrane,type is" + type + "error");
            }

            Extra = Extra + "--" + des + "--" + boxCode;

            string sql = "select * from physical_Location where id=@id1";
            PhysicalLocation StartPoint = connection.Query<PhysicalLocation>(sql, new { id1 = src }, transaction).FirstOrDefault();
            PhysicalLocation EndPoint = connection.Query<PhysicalLocation>(sql, new { id1 = des }, transaction).FirstOrDefault();
            TaskCrane taskCrane = new TaskCrane();
            if (StartPoint == null || EndPoint ==null)
            {
                connection.InsertNoNull(taskCrane, transaction);
                return false;
            }
            taskCrane.id = id;
            taskCrane.taskNo = TaskNo;
            taskCrane.craneId = StartPoint.craneId; 
            taskCrane.code = boxCode;
            taskCrane.completeId = completeId;
            taskCrane.conpleteParamId= tCompPId;
            taskCrane.Extra = Extra;
            taskCrane.status = 1;
            taskCrane.deviceType =1;
            taskCrane.fromPlcCol = StartPoint.x;
            taskCrane.fromPlcRow = StartPoint.y;
            taskCrane.fromPlcShelf = StartPoint.z;
            taskCrane.toPlcCol = EndPoint.x;
            taskCrane.toPlcRow = EndPoint.y;
            taskCrane.toPlcShelf = EndPoint.z;
            taskCrane.taskType=type;
            connection.InsertNoNull(taskCrane, transaction);           
            return true;
        }

        public static int BBTaskNo(IDbConnection connection, IDbTransaction transaction)
        {
            int value = 0;
            string begin;
            BTaskNo bBTaskNo = new BTaskNo();
            string sql1 = "SELECT * FROM B_Task_No WHERE dateline= @now";
            List<BTaskNo> tc = connection.Query<BTaskNo>(sql1, new { now = DateTime.Now.ToString("yyyy-MM-dd") }, transaction).AsList();
            if (tc.Count == 0)
            {
                begin = DateTime.Now.ToString("MMdd");
                value = int.Parse(begin.PadRight(4)) * 1000000;
                value += 1;
                bBTaskNo.dateline = DateTime.Now.ToString("yyyy-MM-dd");
                bBTaskNo.value = value;
                connection.Insert(bBTaskNo, transaction);
            }
            else
            {
                value = tc[0].value;
                value = value + 1;
                string sql2 = "UPDATE B_Task_No SET value=@value WHERE dateline=@now";
                connection.Execute(sql2, new { value = value, now = DateTime.Now.ToString("yyyy-MM-dd") }, transaction);
            }
            return value;
        }

        public static int getInstockEndCarrier(int begin, int end)
        {
            int des;
            int craneId = GetCraneId(end);
            if (begin == 1000 || begin == 1003 || begin == 1006 || begin == 1010)
            {
                des = (craneId - 1) * 2 + 1090;
                return des;
            }
            else if (begin == 1200 || begin == 1203 || begin == 1206 || begin == 1210)
            {
                if (1 <= craneId && craneId <= 3)
                {
                    des = (craneId - 1) + 1357;
                    return des;
                }
                else
                {
                    des = (craneId - 4) * 2 + 1361;
                    return des;
                }
            }
            else if (begin == 2001)
            {
                des = (craneId - 1) + 2026;
                return des;
            }
            else if (begin == 2201)
            {
                if (1 <= craneId && craneId <= 3)
                {
                    des = (craneId - 1) + 2209;
                    return des;
                }
                else
                {
                    des = (craneId - 4) + 2317;
                    return des;
                }
            }
            return 0;
        }

        public static int getOutstockBeginCarrier(int begin, int end)
        {
            int des;
            int craneId = GetCraneId(begin);
            if (end == 1)
            {
                des = (craneId - 1) * 2 + 1089;
                return des;
            }
            else if (end == 2)
            {
                if (1 <= craneId && craneId <= 3)
                {
                    des = 1222 - (craneId - 1) * 3;
                    return des;
                }
                else
                {
                    des = (craneId - 4) * 2 + 1360;
                    return des;
                }
            }
            else if (end == 21)
            {
                des = (craneId - 1) + 2026;
                return des;
            }
            else if (end == 22)
            {
                if (1 <= craneId && craneId <= 3)
                {
                    des = (craneId - 1) + 2209;
                    return des;
                }
                else
                {
                    des = (craneId - 4) + 2317;
                    return des;
                }
            }          
            return 0;
        }

        public static int GetCraneId(int location)
        {
            int res;
            int craneId;
            res = location / 10000;
            craneId = (res + 1) / 2;
            return craneId;
        }

        public static void BCarrier(IDbConnection connection, IDbTransaction transaction, int TaskNo, int carrierEnd, string boxCode, long completeId, long tCompPId, int itemType, int srcId,long id)
        {         
            string extra;
            DateTime now;
            now = DateTime.Now;
            extra = "carrier任务 " + boxCode + "从" + srcId + "搬运到" + carrierEnd;
            if (TaskNo == 0)
            {
                throw new Exception("bcarrier error" + completeId);
            }
            TaskCarrier taskCarrier = new TaskCarrier();
            taskCarrier.id = id;
            taskCarrier.taskNo = TaskNo;
            taskCarrier.code = boxCode;
            taskCarrier.completeId = completeId;
            taskCarrier.conpleteParamId = tCompPId;
            taskCarrier.itemType = itemType;
            taskCarrier.startPath = srcId;
            taskCarrier.endPath = carrierEnd;                       
            taskCarrier.status = 1;
            taskCarrier.Extra = extra;
            taskCarrier.deviceType = 2;           
            connection.InsertNoNull(taskCarrier, transaction);
        }

        public static void BCraneRely(IDbConnection connection, IDbTransaction transaction, long taskId,string taskName,long relyId,string  relyName,long completeId)
        {
            long id;
            ISequenceIdServer sequenceIdServer = ServerFactray.getServer<ISequenceIdServer>();
            id = sequenceIdServer.getId();
            TaskRely taskRely=new TaskRely();
            taskRely.id=id;
            taskRely.relyId=relyId;
            taskRely.relyName=relyName;
            taskRely.taskId=taskId;
            taskRely.taskName=taskName;
            taskRely.completeId=completeId;
            connection.Insert(taskRely,transaction);
        }
    }
}

