using System;
using System.Text;
using System.Linq;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;
using Dapper;
using static Dapper.SqlMapper;
using GK.Common.dto;
using GK.Common;
using GK.DAL.inter;
using GK.DAL.dialect;
using System.Web;
using GK.WMS.Entity;
using GK.WMS.DAL.util;

namespace GK.WMS.DAL.abs
{
    public abstract class AbsSequenceIdServer : AbsWMSBaseServer, ISequenceIdServer

    {
        static long SEQUENCES_ID = 0;
        static int index = 0;

        public long getId()
        {
            lock (this)
            {
                long id = 0;
                if (SEQUENCES_ID == 0 || index == 99)
                {
                    SEQUENCES_ID = querySequence();
                    index = 0;
                }
                index++;
                id = SEQUENCES_ID * 100 + index;
                return id;

            }

        }

        public DateTime GetTime()
        {
            return DateTime.Now;
            //return Connection.Query<DateTime>("select getdate()").ToList()[0].Date;
        }

        public string GetSerial(string tableName, int businessType = 0, string description = "")
        {
            return SysUtil.GetSerial(Connection, tableName, businessType, description);
        }

        public abstract long querySequence();
    }
}
