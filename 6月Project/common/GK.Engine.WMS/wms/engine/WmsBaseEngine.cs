using GK.Common.trans;
using GK.Common;
using GK.WMS.DAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace GK.Engine.WMS{
    public abstract class WmsBaseEngine : GkTransaction {
         public  IDbConnection connection;
        override protected IDbConnection getConnection() {
            if (connection == null) {
                connection = DBUtils.newWMSConn(WMSDalFactray.prefixal);
            }
            return connection;
        }
    }

}
