
using System;
using System.Data;
using Dapper;
using System.Collections.Generic;
using GK.WMS.Entity;
using System.Linq;
using GK.WMS.DAL;
using GK.WMS.Entity.wms;
using GK.Engine.WMS.wms;
using GK.Mongon.DAL;
using GK.Mongon;
using GK.FMXT.DAL;
using Engine.WMS;

namespace GK.Engine.WMS
{
    public class SyncMonthEngine : WmsBaseEngine
    {
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();
        protected override bool Execute(IDbConnection Connection, IDbTransaction transaction, ref string errorMsg)
        {
            DateTime maxUpdateTime = GetMaxUpdateTime(Connection, transaction);
            var statRealList = GetStatRealList(Connection, transaction, maxUpdateTime);
            foreach (var statReal in statRealList)
            {
                var statMonths = GetMonthList(statReal.month ?? 0, statReal.itemId ?? 0, Connection, transaction);
                if (statMonths == null)
                {
                    StatMonth statMonth = new StatMonth();
                    statMonth.id = sequenceIdServer.getId();
                    statMonth.month = statReal.month;
                    statMonth.itemId = statReal.itemId;
                    statMonth.itemName = statReal.itemName;
                    statMonth.itemCode = statReal.itemCode;
                    statMonth.modelSpecs = statReal.modelSpecs;
                    statMonth.unit = statReal.unit;
                    var lastRemain = GetLastRemain(Connection, transaction, GetLastMonth(statMonth.month ?? 0), statMonth.itemId ?? 0);
                    statMonth.lastRemain = lastRemain == null ? 0 : lastRemain.remain;/////
                    if (statReal.forword == 1)
                    {
                        statMonth.inCount = statReal.count;
                    }
                    else if (statReal.forword == 2)
                    {
                        statMonth.outCount = statReal.count;
                    }
                    statMonth.remain = statReal.remain;
                    statMonth.coreItemType = statReal.coreItemType; /////
                    statMonth.updateTime = DateTime.Now;
                    connection.InsertNoNull<StatMonth>(statMonth, transaction);
                }
                else
                {
                    if (statReal.forword == 1)
                    {
                        statMonths.inCount = statMonths.inCount ?? 0 + statReal.count ?? 0;
                    }
                    else if (statReal.forword == 2)
                    {
                        statMonths.outCount = statMonths.outCount ?? 0 + statReal.count ?? 0;
                    }
                    statMonths.updateTime = DateTime.Now;
                    connection.updateNotNull<StatMonth>(statMonths, transaction);
                }

            }
            return true;

        }

        private List<WhBatch> GetBatchList(IDbConnection Connection, IDbTransaction transaction)
        {
            string sql = @"SELECT * FROM dbo.wh_batch where count > 0";
            return Connection.Query<WhBatch>(sql, "", transaction).ToList();
        }

        private List<StatReal> GetStatRealList(IDbConnection Connection, IDbTransaction transaction, DateTime maxUpdateTime)
        {
            string sql = @"SELECT  core_Item_Type,month,item_Id,forword,unit,item_name,item_code,model_specs,SUM(count) AS count,remain AS remain FROM dbo.stat_real WHERE op_time>@opTime
                            GROUP BY core_Item_Type,month,item_Id,forword,unit,item_name,item_code,model_specs,remain ";
            return Connection.Query<StatReal>(sql, new { opTime = maxUpdateTime }, transaction).ToList();
        }

        private StatReal GetLastRemain(IDbConnection Connection, IDbTransaction transaction, int month, long itemId)
        {
            string sql = @"SELECT remain FROM stat_real WHERE month=@month and item_Id=@itemId and op_time IN( SELECT MAX(op_time) FROM dbo.stat_real where month=@month and item_Id=@itemId ) ";
            var result = Connection.Query<StatReal>(sql, new { month = month, itemId = itemId }, transaction).FirstOrDefault();
            return result;
        }

        /// <summary>
        /// 获得上个月的月份
        /// </summary>
        /// <param name="opTime"></param>
        /// <returns></returns>
        private int GetLastMonth(int month)
        {
            int y = month / 100;
            int m = month % 100;
            if (m == 1)
            {
                y = y * 100 - 100 + 12;
            }
            else
            {
                y = y * 100 + (m - 1);
            }
            return y;
        }

        /// <summary>
        /// 获得月份最早同步的时间
        /// </summary>
        /// <param name="Connection"></param>
        /// <param name="transaction"></param>
        /// <returns></returns>
        private DateTime GetMaxUpdateTime(IDbConnection Connection, IDbTransaction transaction)
        {
            string sql = @"SELECT MAX(update_Time) FROM dbo.stat_month ";
            return Connection.Query<DateTime>(sql, "", transaction).Single();
        }


        private StatMonth GetMonthList(int month, long itemId, IDbConnection Connection, IDbTransaction transaction)
        {
            return Connection.GetAll<StatMonth>("and month=@month and item_Id=@itemId", new { month = month, itemId = itemId }, transaction).FirstOrDefault();
        }
    }
}
