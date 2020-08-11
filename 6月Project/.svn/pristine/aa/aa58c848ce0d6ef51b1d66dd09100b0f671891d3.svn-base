using System;
using System.Collections.Generic;
using System.Data;
using Dapper;
using GK.Common;
using GK.Common.trans;
using GK.WCS.DAL;
using GK.WCS.Entity;

namespace GK.Engine.WCS
{
    public abstract class WcsBaseEngine : GkTransaction
    {
        public  IDbConnection connection;
          

        override protected IDbConnection getConnection() {
            if (connection == null) {
                connection = DBUtils.newWCSConn(ServerFactray.prefixal);
            }
            return connection;
        }
    }
    
}
